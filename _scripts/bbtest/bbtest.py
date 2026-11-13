#!/usr/bin/env python3
"""Run Battle Brothers mod test scenarios headless on modern-bb-engine.

Usage: bbtest.py [--env code|engine|jsdom|ui|game|all] [options] SCENARIO.nut...

Each scenario file starts with header comments:
    // mode: menu | campaign [seed=S] [origin=scenario.X]
    // mods: mod_nicknames mod_reforged==0.9.3 mod_msu   (README, "Mods")
    // needs: worldgen          (optional: skipped in envs that lack it)
Files with the same header share one game launch. See README.md.
"""
import argparse, concurrent.futures, hashlib, html, itertools, json, os, re, shutil, subprocess, sys, threading, time, zipfile
from pathlib import Path
import store

HERE = Path(__file__).resolve().parent
MODS_ROOT = HERE.parent.parent                       # ~/projects/bbm/mods
BBM = MODS_ROOT.parent                               # ~/projects/bbm
ENGINE = Path(os.environ.get("BBTEST_ENGINE", BBM / "3rdparty/modern-bb-engine"))
BIN = ENGINE / "target/release/examples/bbtest"
# The engine with the headless page host (`--ui-page`): branch bbtest-cef.
ENGINE_UI = Path(os.environ.get("BBTEST_UI_ENGINE", BBM / "3rdparty/modern-bb-engine-cef"))
BIN_UI = ENGINE_UI / "target/release/examples/bbtest_ui"
# The engine with the page in jsdom under Node (`--env jsdom`): branch bbtest-jsdom.
ENGINE_JS = Path(os.environ.get("BBTEST_JS_ENGINE", BBM / "3rdparty/modern-bb-engine-jsdom"))
BIN_JS = ENGINE_JS / "target/release/examples/bbtest_js"
GAME_DATA = Path(os.environ.get("BBTEST_GAME_DATA",
                 Path.home() / ".local/share/Steam/steamapps/common/Battle Brothers/data"))
# data_014.dat here is a stale Russian translation that breaks the current game's scripts.
SKIP_DATS = set(os.environ.get("BBTEST_SKIP_DATS", "data_014.dat").split(","))
WORK = HERE / "work"
CODETEST = HERE.parent / "codetest"
ENVS = ("code", "engine", "jsdom", "ui", "game")
# What each env provides of what a test or file may declare in `needs` (README, "Envs").
HAS = {"code": {"ct", "reforged9"}, "engine": {"worldgen", "map", "legends", "hardened", "reforged9"},
       "jsdom": {"worldgen", "map", "jsdom", "ui", "page", "legends", "hardened", "reforged9"},
       "ui": {"worldgen", "map", "ui", "page", "legends", "hardened", "reforged9"},
       "game": {"worldgen", "map", "legends", "hardened", "reforged9"}}
# The original game under Proton (`--env game`, README "The original game"): its isolated install and prefix.
GAME_INSTALL = GAME_DATA.parent
GAME_WORK = WORK / "game"
PROTON = Path.home() / ".local/share/Steam/steamapps/common" / os.environ.get("BBTEST_PROTON", "Proton - Experimental")
STEAM_LOGS = Path.home() / ".local/share/Steam/logs"
GAME_STALL = 120  # seconds the game may use no CPU before it's taken for hung
GAME_QUIT_GRACE = 20  # seconds the game gets to quit after the runner's EXIT before it's killed
GAME_LOCK = threading.Lock()  # one launch at a time: they share the prefix, and each is a session of the user's Steam
# Mods codetest's stubs can't boot: the need each implies.
BOOT_NEEDS = {"mod_legends": "legends", "mod_hardened": "hardened"}
# Edits applied to a copy of a third-party zip (work/patched/, same file name) for engine divergences:
# {zip name: [(file in zip, old text, new text)]}. Each is in the README's Engine issues.
ZIP_PATCHES = {
    # Squirrel 3.0 compiles `typeof x = y` (the condition is then y, truthy); 3.2 rejects it.
    "mod_legends-19.4.23.zip": [("scripts/entity/world/camp/buildings/hunter_building.nut",
                                 'typeof _m = "integer"', '"integer"')],
}


def patched(z: Path) -> Path:
    edits = ZIP_PATCHES.get(z.name)
    if not edits:
        return z
    out = WORK / "patched" / z.name
    if out.exists() and out.stat().st_mtime >= max(z.stat().st_mtime, Path(__file__).stat().st_mtime):
        return out
    out.parent.mkdir(parents=True, exist_ok=True)
    tmp = out.with_suffix(".tmp")
    with zipfile.ZipFile(z) as zin, zipfile.ZipFile(tmp, "w", zipfile.ZIP_DEFLATED) as zout:
        for info in zin.infolist():
            data = zin.read(info)
            for name, old, new in edits:
                if info.filename == name:
                    text = data.decode()
                    if old not in text:
                        sys.exit(f"bbtest: patch for {z.name}:{name} doesn't apply")
                    data = text.replace(old, new).encode()
            zout.writestr(info, data)
    tmp.replace(out)
    return out


def log(*a):
    print(*a, file=sys.stderr, flush=True)


# --- Setup ---

def shadow_data():
    """A data dir of symlinks to the game's archives, minus SKIP_DATS: the game's dir is never touched."""
    d = WORK / "gamedata"
    d.mkdir(parents=True, exist_ok=True)
    want = {p.name: p for p in GAME_DATA.glob("data_*.dat") if p.name not in SKIP_DATS}
    want["gfx"] = GAME_DATA / "gfx"
    for p in d.iterdir():
        if p.name not in want:
            p.unlink()
    for name, src in want.items():
        link = d / name
        if not link.is_symlink() or os.readlink(link) != str(src):
            link.unlink(missing_ok=True)
            link.symlink_to(src)
    return d


def ensure_engine():
    example = ENGINE / "bb-engine/examples/bbtest.rs"
    ours = HERE / "engine/bbtest.rs"
    if not example.exists() or example.read_bytes() != ours.read_bytes():
        shutil.copy(ours, example)
    if not BIN.exists() or BIN.stat().st_mtime < example.stat().st_mtime:
        log(f"building {BIN} ...")
        env = dict(os.environ, RUSTC_BOOTSTRAP="1")
        p = subprocess.run(["cargo", "build", "--release", "-p", "bb-engine", "--example", "bbtest"],
                           cwd=ENGINE, env=env, capture_output=True, text=True)
        if p.returncode:
            sys.exit(p.stderr)


def ensure_ui_engine():
    example = ENGINE_UI / "bb-ui/examples/bbtest_ui.rs"
    ours = HERE / "engine/bbtest_ui.rs"
    if not example.exists() or example.read_bytes() != ours.read_bytes():
        shutil.copy(ours, example)
    if not BIN_UI.exists() or BIN_UI.stat().st_mtime < example.stat().st_mtime:
        log(f"building {BIN_UI} ...")
        env = dict(os.environ, RUSTC_BOOTSTRAP="1")
        p = subprocess.run(["cargo", "build", "--release", "-p", "bb-ui", "--features", "cef", "--example", "bbtest_ui"],
                           cwd=ENGINE_UI, env=env, capture_output=True, text=True)
        if p.returncode:
            sys.exit(p.stderr)


def ensure_js_engine():
    example = ENGINE_JS / "bb-ui/examples/bbtest_js.rs"
    ours = HERE / "engine/bbtest_js.rs"
    if not example.exists() or example.read_bytes() != ours.read_bytes():
        shutil.copy(ours, example)
    if not (ENGINE_JS / "bb-ui/jsdom/node_modules").exists():
        subprocess.run(["npm", "ci", "--no-audit", "--no-fund"], cwd=ENGINE_JS / "bb-ui/jsdom", check=True)
    env = dict(os.environ, RUSTC_BOOTSTRAP="1")
    p = subprocess.run(["cargo", "build", "--release", "-p", "bb-ui", "--features", "jsdom", "--example", "bbtest_js"],
                       cwd=ENGINE_JS, env=env, capture_output=True, text=True)
    if p.returncode:
        sys.exit(p.stderr)


def zip_dir(src: Path, out_dir: Path) -> Path:
    """A mod dir zipped as is, e.g. a test-only stub; the zip is named after the dir."""
    if not src.is_dir():
        sys.exit(f"bbtest: no mod dir {src}")
    out_dir.mkdir(parents=True, exist_ok=True)
    out = out_dir / f"{src.name}.zip"
    with zipfile.ZipFile(out, "w", zipfile.ZIP_DEFLATED) as z:
        for p in sorted(src.rglob("*")):
            if p.is_file():
                z.write(p, p.relative_to(src))
    return out


def own_mod(f: Path, st):
    """The id of the user's mod whose scenarios/ holds f: always built from its working copy."""
    d = f.parent.parent if f.parent.name == "scenarios" else None
    return next((i for i, (dd, _, _) in st.dev.items() if dd == d), None)


def stubs(f: Path):
    """Test-only mod dirs next to a scenario file, named in headers by the dir name."""
    return {d.name: d for d in f.parent.iterdir() if d.is_dir() and (d / "scripts").is_dir()}


def mount(entries, env, built):
    """What a launch mounts: zip paths, or for code codetest's vfs tokens (working copies as dirs)."""
    out = []
    for e in entries:
        if e.source == "dev":
            if env == "code":
                out.append("stdlib" if e.dir == BBM / "stdlib" else e.dir.name if e.dir.parent == MODS_ROOT else str(e.dir))
                continue
            if e.dir not in built:
                built[e.dir] = store.build_dev(e, WORK / "built")
            e.path, e.sha = built[e.dir], store.sha256(built[e.dir])
            out.append(built[e.dir])
        elif e.source == "stub":
            out.append(str(e.dir) if env == "code" else zip_dir(e.dir, WORK / "built"))
        else:
            z = patched(store.mount_path(e))
            out.append(str(z) if env == "code" else z)
    seen, uniq = set(), []
    for z in out:
        if Path(z).name not in seen:
            seen.add(Path(z).name)
            uniq.append(z)
    return uniq


# --- Scenario files ---

def header(path: Path):
    mode, opts, mods = "menu", {}, []
    for line in path.read_text().splitlines()[:10]:
        if m := re.match(r"\s*//\s*mode:\s*(\S+)(.*)", line):
            mode = m[1]
            opts = dict(kv.split("=", 1) for kv in m[2].split())
        elif m := re.match(r"\s*//\s*mods:\s*(.*)", line):
            mods += m[1].split()
    return (mode, opts.get("seed", "bbtest"), opts.get("origin", "scenario.early_access"),
            opts.get("fresh", "0") == "1", tuple(mods), opts.get("launch", ""))


def includes(path: Path):
    """Files named by `// include: a.nut b.nut` header lines, relative to the scenario file."""
    out = []
    for line in path.read_text().splitlines()[:10]:
        if m := re.match(r"\s*//\s*include:\s*(.*)", line):
            out += [(path.parent / n).resolve() for n in m[1].split()]
    return out


def needs(path: Path, ids):
    """`// needs: a b` header lines; `ui=page` / `ui=js` in the mode line need the page."""
    out = []
    for line in path.read_text().splitlines()[:10]:
        if m := re.match(r"\s*//\s*needs:\s*(.*)", line):
            out += m[1].split()
        elif m := re.match(r"\s*//\s*mode:.*\bui=(page|js)\b", line):
            out.append("ui" if m[1] == "page" else "jsdom")
    return out + [n for i, n in BOOT_NEEDS.items() if i in ids]


def allowed_errors(path: Path):
    """Regexes from `// allow-errors: REGEX` header lines: expected errors outside tests."""
    return [m[1].strip() for line in path.read_text().splitlines()[:10]
            if (m := re.match(r"\s*//\s*allow-errors:\s*(.*)", line))]


TEST_RE = re.compile(r'^\s*test\(\s*"([^"]+)"', re.M)


def block(src, i):
    """src[i:] up to the brace closing the first `{` from i (strings and comments not skipped: a lint)."""
    j = src.find("{", i)
    if j < 0:
        return ""
    depth = 0
    for k in range(j, len(src)):
        depth += {"{": 1, "}": -1}.get(src[k], 0)
        if depth == 0:
            return src[j:k + 1]
    return src[j:]


def generator_captures(path: Path):
    """Closures inside a yielding test that read the test's locals: the original game's Squirrel 3.0 gives them
    null once the test has yielded (README, pitfalls). A lint: (line, test, local) per hit."""
    src = re.sub(r"//[^\n]*", "", path.read_text())
    out = []
    for m in TEST_RE.finditer(src):
        # A test passing a named function has no body here.
        if not re.match(r'\s*,\s*function\b', src[m.end():src.find("\n", m.end())].split('"', 1)[-1]):
            continue
        start = src.find("{", m.end())
        body = block(src, m.end())
        if "yield" not in body:
            continue
        names = set(re.findall(r"\blocal\s+(\w+)", body))
        for c in re.finditer(r"(?:\bfunction\s*\(|@\()", body):
            fn = c.group(0)
            inner = block(body, c.start()) if fn.startswith("function") else body[c.start():body.find("\n", c.start())]
            params = set(re.findall(r"\w+", body[c.end():body.find(")", c.end())]))
            used = set(re.findall(r"(?<![.\w])(\w+)", inner)) - params - set(re.findall(r"\blocal\s+(\w+)", inner))
            for n in sorted(names & used):
                out.append((src[:start + c.start()].count("\n") + 1, m[1], n))
    return sorted(set(out))


def wrap(path: Path, out: Path):
    # All on the file's first line, so line numbers stay the file's own.
    prefix = (f'::BBTest.File = "{path.stem}"; local test = ::BBTest.test, '
              f'beforeCampaign = ::BBTest.beforeCampaign; ')
    out.write_text(prefix + path.read_text())


# --- One launch ---

SNAPSHOTS = WORK / "snapshots"


def snapshot_key(seed, origin, zips, files, env="engine"):
    """The campaign a launch starts, as a cache key; None if its files may change it (`beforeCampaign`)."""
    if any("beforeCampaign(" in f.read_text() for f in files + [i for f in files for i in includes(f)]):
        return None
    made_by = GAME_INSTALL / "win32/BattleBrothers.exe" if env == "game" else BIN  # their saves differ
    parts = [seed, origin, str(made_by), str(made_by.stat().st_mtime_ns), *sorted(SKIP_DATS)]
    for p in [*zips, *sorted(GAME_DATA.glob("data_*.dat"))]:
        st = p.stat()
        # Zips built here are rewritten every run: by content. The rest by size and time.
        parts += [str(p), hashlib.sha1(p.read_bytes()).hexdigest() if p.is_relative_to(WORK / "built")
                  else f"{st.st_size} {st.st_mtime_ns}"]
    return hashlib.sha1("\0".join(parts).encode()).hexdigest()[:16]


class Launch:
    def __init__(self, idx, mode, seed, origin, fresh, mods, files, only, run_dir, snapshot=None, ui=False, env="engine"):
        self.idx, self.mode, self.seed, self.origin, self.fresh = idx, mode, seed, origin, fresh
        self.ui = ui  # the real UI page: True in headless Chromium (bbtest_ui), "js" in jsdom (bbtest_js)
        self.env = env
        self.mods, self.files, self.only, self.dir = mods, files, only, run_dir  # mods: zips, or for code its vfs
        self.snapshot = snapshot  # a key of SNAPSHOTS, see snapshot_key()
        self.loaded = False  # the campaign came from the snapshot
        self.stable_rng = True
        self.draws = False

    def title(self):
        names = " ".join(f.stem for f in self.files)
        s = f"{self.mode}" + (f" seed={self.seed} origin={self.origin}" if self.mode == "campaign" else "") \
            + (" fresh" if self.fresh else "") + (" ui-page" if self.ui is True else "") + (" ui-js" if self.ui == "js" else "")
        mods = self.code_mods if self.env == "code" else ' '.join(m.name for m in self.mods)
        return f"[{self.idx}] {self.env} {names} ({s}; mods: {mods or '-'})" + \
            (f" only={self.only}" if self.only else "") + (" snapshot" if self.loaded else "")

    def run(self, data, timeout):
        self.dir.mkdir(parents=True, exist_ok=True)
        # The engine's input-driven scripted player: t.battle({player = ::__botTick}).
        scripts = [HERE / "bbtest.nut", ENGINE / "bb-engine/tests/testdata/scripted_player.nut"]
        head = self.dir / "_head.nut"
        snap = SNAPSHOTS / f"{self.snapshot}.sav" if self.snapshot else None
        unsaved = snap.with_suffix(".nut") if snap else None
        self.loaded = bool(snap and snap.exists() and unsaved.exists())
        head.write_text(f"::BBTest.Env = {quote(self.env)};\n"
                        + "::BBTest.Has = {" + ", ".join(f"{n} = true" for n in sorted(HAS[self.env])) + "};\n"
                        + (f"::BBTest.Only = {quote(self.only)};\n" if self.only else "")
                        + ("::BBTest.Fresh = true;\n" if self.fresh else "")
                        + ("::BBTest.StableRng = true;\n" if self.stable_rng else "")
                        + ("::__rng.log = true;\n" if self.draws else "")
                        + (f"::BBTest.Unsaved = {unsaved.read_text()};\n" if self.loaded else ""))
        scripts.append(head)
        self.names = {}
        files = []
        for f in self.files:
            for inc in includes(f):
                if inc not in files:
                    files.append(inc)
            files.append(f)
        for f in files:
            w = self.dir / f.name
            wrap(f, w)
            self.names[str(w)] = str(f)
            scripts.append(w)
        if self.env == "code":
            return self.run_code(scripts[2:], timeout)
        if self.env == "game":
            with GAME_LOCK:
                self.run_game(scripts, timeout, snap)
            self.store_snapshot(snap, unsaved)
            return self
        cmd = [str(BIN_JS if self.ui == "js" else BIN_UI if self.ui else BIN), "--data", str(data), "--out", str(self.dir / "events.log"),
               "--logs", str(self.dir / "logs"), "--saves", str(self.dir / "saves"),
               "--mode", self.mode, "--seed", self.seed, "--origin", self.origin,
               "--timeout", str(timeout)] + (["--ui-js"] if self.ui == "js" else [])
        for m in self.mods:
            cmd += ["--mod", str(m)]
        for s in scripts:
            cmd += ["--script", str(s)]
        if self.loaded:
            os.utime(snap)  # in use: see the pruning in main()
            (self.dir / "saves").mkdir(exist_ok=True)
            shutil.copy(snap, self.dir / "saves" / "bbtest_snapshot.sav")
            cmd += ["--load", "bbtest_snapshot"]
        elif snap:
            cmd += ["--snapshot", "bbtest_snapshot"]
        # The engine's own streams (buildTextFromTemplate's choices among others) are seeded from the clock otherwise.
        env = {"BB_ENGINE_SEED": "1", **os.environ, "BB_NO_STEAM": "1", "BB_LOGS_DIR": str(self.dir / "logs"),
               "BB_SAVES_DIR": str(self.dir / "saves"), "BB_ERROR_DIALOG": "0"}
        t0 = time.monotonic()
        try:
            p = subprocess.run(cmd, env=env, capture_output=True, text=True, timeout=timeout + 30)
            self.rc, self.stderr = p.returncode, p.stderr
        except subprocess.TimeoutExpired as e:
            self.rc, self.stderr = 124, (e.stderr or b"").decode(errors="replace") if isinstance(e.stderr, bytes) else (e.stderr or "")
        self.wall = time.monotonic() - t0
        (self.dir / "stderr.txt").write_text(self.stderr)
        self.store_snapshot(snap, unsaved)
        return self

    def store_snapshot(self, snap, unsaved):
        """The campaign this launch saved at its start, kept for later launches with the same key."""
        made = self.dir / "saves" / "bbtest_snapshot.sav"
        log = (self.dir / "events.log").read_text(errors="replace") if snap and not self.loaded else ""
        m = re.search(r"BBTEST_UNSAVED (.*)", log)
        if snap and not self.loaded and self.rc == 0 and made.exists() and m:
            SNAPSHOTS.mkdir(parents=True, exist_ok=True)
            tmp = snap.with_suffix(f".{os.getpid()}.{self.idx}")
            tmp.write_text(m[1])
            tmp.replace(unsaved)
            shutil.copy(made, tmp)
            tmp.replace(snap)

    def run_game(self, scripts, timeout, snap):
        """In the original game: the scripts, packed into a runner mod with game/runner.nut, run at its main menu."""
        import fcntl
        GAME_WORK.mkdir(parents=True, exist_ok=True)
        # Other bbtest processes too: one launch at a time on this machine.
        with open(GAME_WORK / "launch.lock", "w") as lock:
            fcntl.flock(lock, fcntl.LOCK_EX)
            return self.run_game_locked(scripts, timeout, snap)

    def run_game_locked(self, scripts, timeout, snap):
        runner = self.dir / "zzz_bbtest_runner.zip"
        autoplay = (ENGINE / "bb-engine/src/harness.rs").read_text().split('const AUTOPLAY: &str = r#"', 1)[1].split('"#;', 1)[0]
        names = []
        with zipfile.ZipFile(runner, "w", zipfile.ZIP_DEFLATED) as z:
            z.write(HERE / "game/runner.nut", "scripts/!mods_preload/zzz_bbtest_runner.nut")
            z.writestr("bbtest/0_autoplay.nut", autoplay)
            for i, sc in enumerate(scripts, 1):
                name = f"bbtest/{i}_{sc.name}"
                z.write(sc, name)
                names.append(name[:-4])
                self.names[name] = self.names.get(str(sc), str(sc))
            z.writestr("bbtest/_launch.nut", f"::BBTestRunner <- {{Mode = {quote(self.mode)}, Seed = {quote(self.seed)}, "
                       f"Origin = {quote(self.origin)}, MaxFrames = 2000000, Show = {str(bool(os.environ.get('BBGAME_SHOW'))).lower()}, "
                       f"Load = {quote('bbtest_snapshot') if self.loaded else 'null'}, "
                       f"Snapshot = {quote('bbtest_snapshot') if snap and not self.loaded else 'null'}, "
                       f"Scripts = [{', '.join(map(quote, ['bbtest/0_autoplay'] + names))}]}};\n")
        install = GAME_WORK / "install"
        data = install / "data"
        shutil.rmtree(data, ignore_errors=True)
        data.mkdir(parents=True)
        for name in ("win32", "cursors"):
            if not (install / name).is_symlink():
                (install / name).symlink_to(GAME_INSTALL / name)
        for p in [*shadow_data().iterdir(), *self.mods, runner]:
            (data / p.name).symlink_to(p.resolve() if p.is_symlink() else p)
        docs = GAME_WORK / "pfx/pfx/drive_c/users/steamuser/Documents/Battle Brothers"
        game_log = docs / "log.html"
        game_log.unlink(missing_ok=True)
        shutil.rmtree(docs / "savegames", ignore_errors=True)
        if self.loaded:
            os.utime(snap)  # in use: see the pruning in main()
            (docs / "savegames").mkdir(parents=True)
            shutil.copy(snap, docs / "savegames/bbtest_snapshot.sav")
        env = dict(os.environ, BBGAME_PFX=str(GAME_WORK / "pfx"), BBGAME_INSTALL=str(install),
                   BBGAME_OUT=str(self.dir / "game_out.txt"), BBGAME_DISPLAY="103", BBGAME_PROTON=PROTON.name)
        t0 = time.monotonic()
        p = subprocess.Popen([HERE / "game/launch.sh"], env=env)
        exited, seen = None, 0
        cpu, busy = None, t0  # the game's CPU time at the start of the window, and that window's start
        while (rc := p.poll()) is None:
            now = time.monotonic()
            # A game with an unanswering display (Xwayland) sits all but idle: its uncapped frames otherwise keep a
            # core busy. Under 5% of a core over the window: hung.
            c = game_cpu()
            if c is None or cpu is None or c - cpu > GAME_STALL * 5:
                cpu, busy = c, now
            elif now - busy > GAME_STALL:
                log(f"bbtest: the game used no CPU for {GAME_STALL} s, killing it")
                exited = None
                now = t0 + timeout + 1
            if now - t0 > timeout or exited and now - exited > GAME_QUIT_GRACE:
                p.kill()  # bwrap --die-with-parent takes the rest with it
                p.wait()
                rc = 0 if exited else 124
                break
            # The game left in a broken state may never quit after the runner's EXIT: its log has every row by then.
            if not exited and game_log.exists() and game_log.stat().st_size > seen:
                with open(game_log, "rb") as f:
                    f.seek(max(0, seen - 100))
                    if b"BBTEST_RUNNER EXIT " in f.read():
                        exited = now
                seen = game_log.stat().st_size
            try:
                p.wait(0.5)
            except subprocess.TimeoutExpired:
                pass
        self.rc = rc
        self.wall = time.monotonic() - t0
        subprocess.run([PROTON / "files/bin/wineserver", "-k"], env=dict(os.environ, WINEPREFIX=str(GAME_WORK / "pfx/pfx")))
        self.stderr = steam_check()
        if self.stderr:
            log(f"bbtest: {self.stderr}")
        (self.dir / "logs").mkdir(exist_ok=True)
        if game_log.exists():
            shutil.copy(game_log, self.dir / "logs/log.html")
        if (docs / "savegames").exists():
            shutil.copytree(docs / "savegames", self.dir / "saves", dirs_exist_ok=True)
        events = game_events(game_log.read_text(errors="replace") if game_log.exists() else "")
        (self.dir / "events.log").write_text(events)
        if self.rc == 0:
            m = re.search(r"^RUNNER EXIT (\d+)", events, re.M)
            self.rc = int(m[1]) if m else 2
        return self

    def run_code(self, scripts, timeout):
        """In codetest's interpreter: the vanilla boot and the mods (self.mods: the vfs), then
        codetest/scenario.nut runs bbtest.nut and the files as the engine's runner does."""
        import codetest
        with open(scripts[0], "a") as head:
            head.write(f"::BBTest.Launch <- {{mode = {quote(self.mode)}, seed = {quote(self.seed)}, "
                       f"origin = {quote(self.origin)}, timeout = {timeout}}};\n")
        cmd = [codetest.interpreter(), str(CODETEST / "loader.nut"), str(CODETEST), str(CODETEST / "scenario.nut"),
               "--scenario", "0", str(HERE / "bbtest.nut"), *map(str, scripts)]
        t0 = time.monotonic()
        try:
            p = subprocess.run(cmd, cwd=self.mods, capture_output=True, text=True, timeout=timeout + 30)
            out, self.stderr = p.stdout, p.stderr
        except subprocess.TimeoutExpired as e:
            out, self.stderr = e.stdout or "", "timed out"
            out = out.decode(errors="replace") if isinstance(out, bytes) else out
        self.wall = time.monotonic() - t0
        (self.dir / "events.log").write_text(out)
        (self.dir / "stderr.txt").write_text(self.stderr)
        self.rc = 0 if "RUNNER TIME done" in out else 124 if "RUNNER TIMEOUT" in out else 2
        return self

    def unwrap(self, s):
        for w, f in self.names.items():
            s = s.replace(w, f)
        return s


def game_cpu():
    """User+system ticks of the running BattleBrothers.exe processes (None while there are none)."""
    total = None
    for d in Path("/proc").iterdir():
        try:
            if d.name.isdigit() and (d / "comm").read_text().startswith("BattleBrothers"):
                f = (d / "stat").read_text().rsplit(")", 1)[1].split()
                total = (total or 0) + int(f[11]) + int(f[12])
        except OSError:
            pass
    return total


def steam_check():
    """Each launch is a session of the user's Steam client: it must show the game stopped afterwards."""
    for _ in range(20):
        states = re.findall(r"AppID 365360 state changed : (.*)", (STEAM_LOGS / "content_log.txt").read_text(errors="replace"))
        if not states or "App Running" not in states[-1]:
            return ""
        time.sleep(0.5)
    return "Steam still shows Battle Brothers running after the launch: " + states[-1]


def game_events(page):
    """log.html of the original as the engine runner's events.log: ROW lines, SCRIPT_ERROR blocks, RUNNER lines."""
    out = []
    for chunk in page.split('<div class="row ')[1:]:
        cls = chunk.split('"', 1)[0]
        tag = m[1] if (m := re.search(r'<div class="tag">([^<]*)</div>', chunk)) else ""
        start = chunk.find('<div class="text">')
        if start < 0:
            continue
        body, _, stack = chunk[start + 18:].partition('<div class="stacktrace-container')
        text = re.sub(r"(</div>\s*)+(</body>\s*</html>\s*)?$", "", body.strip()).replace("\n", "<br>")
        if text.startswith("BBTEST_RUNNER "):
            out.append("RUNNER " + text[14:])
            if text.startswith("BBTEST_RUNNER EXIT "):
                break  # what follows is the runner's own quit, e.g. Legends' errors on a world finished directly
        elif stack and cls in ("error", "critical"):
            out.append("SCRIPT_ERROR " + text)
            for kind, value in re.findall(r'<div class="(value|valueVar)">(.*?)</div>', stack, re.S):
                out.append(("  at " if kind == "value" else "     ") + html.unescape(re.sub(r"<[^>]*>", "", value)).strip())
        else:
            out.append(f"ROW {cls} {tag or '-'} {text}")
    return "\n".join(out) + "\n"


def quote(s):
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'


# --- Results ---

class Test:
    def __init__(self, name):
        self.name, self.status, self.lines, self.frames = name, None, [], 0


def parse(launch: Launch):
    """Tests in order, problems outside tests, timings and the runner's state."""
    tests, outside, times, runner = [], [], {}, []
    cur = None
    path = launch.dir / "events.log"
    lines = path.read_text(errors="replace").splitlines() if path.exists() else []
    i = 0

    def sink(entry):
        (cur.lines if cur else outside).append(entry)

    while i < len(lines):
        line = launch.unwrap(lines[i])
        i += 1
        if line.startswith("SCRIPT_ERROR "):
            block = [line]
            while i < len(lines) and lines[i].startswith("  "):
                block.append(launch.unwrap(lines[i]))
                i += 1
            sink(("error", "\n".join(block)))
            continue
        if line.startswith("RUNNER "):
            body = line[7:]
            if body.startswith("TIME "):
                k, v = body[5:].rsplit(" ", 1)
                times[k] = float(v)
            elif body.startswith(("STOPPED", "TIMEOUT", "COMPILE_ERROR", "SCRIPT_FAILED")):
                runner.append(body)
                sink(("error", "RUNNER " + body))
            continue
        if not line.startswith("ROW "):
            continue
        _, cls, tag, text = (line.split(" ", 3) + [""] * 4)[:4]
        text = text.replace("<br>", "\n")
        if not text.startswith("BBTEST_"):
            text = html.unescape(re.sub(r"<[^>]*>", "", text))
        cls = cls.capitalize()
        if text.startswith("BBTEST_BEGIN "):
            cur = Test(text[13:])
            tests.append(cur)
        elif text.startswith("BBTEST_END ") and cur:
            m = re.match(r"BBTEST_END .* (PASS|FAIL|ERROR|SKIP) frames=(\d+)", text)
            cur.status, cur.frames = m[1], int(m[2])
            cur = None
        elif text.startswith("BBTEST_ASSERT "):
            sink(("assert", text.split(" | ", 1)[1]))
        elif text.startswith("BBTEST_SKIP "):
            sink(("skip", text.split(" | ", 1)[1]))
        elif text.startswith("BBTEST_PROBE "):
            sink(("probe", text.split(" | ", 1)[1]))
        elif text.startswith("BBTEST_LOG "):
            sink(("log", text.split(" | ", 1)[1]))
        elif text.startswith("BBTEST_RNG "):
            sink(("rng", text.split(" | ", 1)[1]))
        elif text.startswith(("BBTEST_INTERNAL",)):
            sink(("error", text))
        elif cls in ("Error", "Critical"):
            sink(("error", f"[{cls} {tag}] {text}"))
        elif cls == "Warning":
            sink(("warning", f"[{cls} {tag}] {text}"))
    if cur and cur.status is None:
        cur.status = "ERROR"
        cur.lines.append(("error", "test did not finish (crash/timeout above)"))
    return tests, outside, times, runner


def known_errors(env):
    files = [HERE / "known_errors.txt"] + ([CODETEST / "known_errors.txt"] if env == "code" else [])
    return [re.compile(l) for f in files for l in f.read_text().splitlines() if l.strip() and not l.startswith("#")]


def label(f: Path):
    """A scenario file as `<mod>/<stem>`: the matrix's and the totals' key."""
    f = f.resolve()
    rel = f.relative_to(MODS_ROOT) if f.is_relative_to(MODS_ROOT) else f
    parts = [x for x in rel.with_suffix("").parts if x != "scenarios"]
    return "/".join(parts[-2:]) if parts[:2] == ["_scripts", "bbtest"] else "/".join(parts)


def report(launch, verbose, strict_boot):
    """Prints the launch's results; returns its failures, {label::test: status} and {label::test: why skipped}."""
    tests, outside, times, runner = parse(launch)
    tm = " ".join(f"{k}={v:.1f}s" for k, v in times.items())
    print(f"\n== {launch.title()}\n   rc={launch.rc} wall={launch.wall:.1f}s {tm}")
    failed = 0
    if launch.rc not in (0,) or "done" not in " ".join(times):
        why = {124: "TIMEOUT", 2: "BOOT/LOAD FAILURE", 3: "FRAME FAILURE"}.get(launch.rc, f"CRASH rc={launch.rc}")
        print(f"   !! {why}; stderr tail:")
        for l in launch.stderr.strip().splitlines()[-15:]:
            print("      " + l)
        failed += 1
    known = known_errors(launch.env) + [re.compile(r) for f in launch.files for r in allowed_errors(f)]
    outside = [("known", t) if k == "error" and any(r.search(t) for r in known) else (k, t)
               for k, t in outside]
    boot_errors = [e for e in outside if e[0] == "error"]
    if outside and (verbose or boot_errors):
        print("   outside tests (boot, load, campaign start):")
        for kind, text in outside:
            if kind == "error" or verbose:
                print(indent(f"{kind.upper()} {text}", 6))
    if boot_errors and strict_boot:
        failed += 1
    statuses, skips = {}, {}
    stems = {f.stem: label(f) for f in launch.files}
    for t in tests:
        # The page's known errors (vanilla UI's own) don't fail a test either.
        errors = [x for x in t.lines if x[0] == "error"
                  and not (x[1].startswith("[Error JS]") and any(r.search(x[1]) for r in known))]
        status = t.status if not (errors and t.status == "PASS") else "FAIL"
        if status not in ("PASS", "SKIP"):
            failed += 1
        stem, _, name = t.name.partition("::")
        statuses[f"{stems.get(stem, stem)}::{name}"] = status
        if status == "SKIP":
            skips[f"{stems.get(stem, stem)}::{name}"] = next((x[1] for x in t.lines if x[0] == "skip"), "")
        print(f"   {status:5} {t.name}  ({t.frames} frames)")
        for kind, text in t.lines:
            # A skipped test's error is the Unsupported it raised.
            if status == "SKIP" and kind == "error":
                continue
            if kind in ("probe", "assert", "error", "log", "skip", "rng") or verbose:
                print(indent(f"{kind.upper()} {text}", 9))
    return failed, statuses, skips


def indent(s, n):
    pad = " " * n
    return "\n".join(pad + l if j == 0 else pad + "  " + l for j, l in enumerate(s.splitlines()))


def apply_overrides(specs, overrides):
    """Header specs with each `-r` spec replacing the one of its mod id, or added."""
    over = {o.id: o for o in overrides}
    out = [x for x in specs if store.Spec(x).id not in over]
    return tuple(out + [o.text for o in overrides])


def locked(st, entries, f):
    """A launch's mods as a previous run's mods.lock has them: store zips by sha256, working copies rebuilt."""
    out = []
    for x in entries:
        if x["source"] == "dev":
            e = st.dev_entry(x["id"])
            if e.version != x["version"]:
                log(f"bbtest: --lock: the working copy of {x['id']} is {e.version} now, was {x['version']}")
        elif x["source"] == "stub":
            e = store.Entry(x["id"], None, None, "stub", None, None, {}, [], x["file"], stubs(f)[x["id"]])
        else:
            e = next((e for e in st.entries if e.sha == x["sha256"] and e.id == x["id"]), None)
            if not e:
                sys.exit(f"bbtest: --lock: no store zip of {x['id']} with sha256 {x['sha256']}")
        out.append(e)
    return out


def matrix(envs, results):
    """Per mod: PASS/FAIL/SKIP counts per env; tests that pass in one env and fail in another."""
    tests = sorted({k for e in envs for k in results[e]})
    print(f"\n== Envs: {' '.join(envs)} (pass/fail/skip; fail = FAIL or ERROR)")
    mods = sorted({k.split("/", 1)[0] for k in tests})
    for mod in mods:
        cells = []
        for e in envs:
            st = [v for k, v in results[e].items() if k.split("/", 1)[0] == mod]
            cells.append(f"{e} {st.count('PASS')}/{sum(x in ('FAIL', 'ERROR') for x in st)}/{st.count('SKIP')}")
        print(f"   {mod:24} " + "   ".join(f"{c:18}" for c in cells))
    div = [(k, {e: results[e].get(k) for e in envs}) for k in tests]
    div = [(k, st) for k, st in div if "PASS" in st.values() and {"FAIL", "ERROR"} & set(st.values())]
    print(f"   divergences ({len(div)}):" if div else "   no divergences")
    for k, st in div:
        print(f"      {k}  " + " ".join(f"{e}={v or '-'}" for e, v in st.items()))
    return div


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("files", nargs="+", type=Path)
    ap.add_argument("--env", default="engine",
                    help="code, engine (default), jsdom, ui, game (the original, one launch at a time); several "
                         "comma-separated, or all (code, engine, jsdom, ui): a matrix of the envs' statuses")
    ap.add_argument("-k", "--only", help="run only tests whose name (file::test) contains this")
    ap.add_argument("-r", dest="mods", action="append", default=[], metavar="SPEC",
                    help="a mod spec (README, \"Mods\") for every launch, replacing the header's of that mod or added; "
                         "several of one mod = a run per version; '*@latest' = the newest of every third-party mod")
    ap.add_argument("--lock", type=Path, help="mount exactly the mods of a previous run's mods.lock (or its run dir)")
    ap.add_argument("--isolate", action="store_true", help="one launch per test (slower, no shared state)")
    ap.add_argument("--snapshot", action="store_true",
                    help="campaign launches load the campaign a launch with the same seed, origin and mods saved at "
                         "its start (work/snapshots/) instead of starting one; files with beforeCampaign never do")
    # Past 3/4 of the CPUs a suite runs no faster: the rest are E-cores and second threads of P-cores.
    ap.add_argument("-j", "--jobs", type=int, default=max(1, os.cpu_count() * 3 // 4),
                    help="launches run in parallel (default 3/4 of the CPUs)")
    ap.add_argument("--timeout", type=float, default=300, help="seconds per launch (default 300)")
    ap.add_argument("--allow-boot-errors", action="store_true",
                    help="don't fail on script errors outside tests (boot, mod loading)")
    ap.add_argument("--ui-page", action="store_true", help="the same as --env ui")
    ap.add_argument("--ui-js", action="store_true", help="the same as --env jsdom")
    ap.add_argument("-v", "--verbose", action="store_true", help="also print warnings and log lines")
    ap.add_argument("--no-stable-rng", action="store_true",
                    help="battles draw from the real time and the C runtime's stream, as the game does (see Isolation)")
    ap.add_argument("--draws", action="store_true",
                    help="log every draw of the tests with its call site (BBTEST_DRAWS rows; rngdiff.py compares two runs)")
    ap.add_argument("--keep-saves", action="store_true",
                    help="keep the saves/ of launches that passed (deleted by default, ~6.5 MB each)")
    args = ap.parse_args()
    envs = list(ENVS[:4]) if args.env == "all" else ["ui"] if args.ui_page else ["jsdom"] if args.ui_js \
        else args.env.split(",")
    if bad := [e for e in envs if e not in ENVS]:
        sys.exit(f"bbtest: unknown env {bad[0]!r}, want {', '.join(ENVS)} or all")

    if {"engine", "jsdom", "ui"} & set(envs):
        ensure_engine()
    data = shadow_data()
    built = {}
    groups = {}
    skipped = {e: [] for e in envs}  # (file, what it needs) of files no launch runs in that env
    try:
        st = store.Store()
        overrides = store.parse_specs([m for m in args.mods if not m.startswith("*")])
    except store.SpecError as e:
        sys.exit(f"bbtest: {e}")
    latest = any(m.startswith("*@latest") for m in args.mods)
    by_id = {}
    for o in overrides:
        by_id.setdefault(o.id, []).append(o)
    # Several specs of one mod: a run of everything per combination, a column of the statuses each.
    combos = list(itertools.product(*by_id.values())) or [()]
    lock = None
    if args.lock:
        lf = args.lock / "mods.lock" if args.lock.is_dir() else args.lock
        lock = {(l["col"], lab): l["mods"] for l in json.loads(lf.read_text()) for lab in l["files"]}
    resolved = {}

    def resolve(col, mods, own, f):
        """The launch's mods: the header's resolved, or the lock's."""
        key = (col, mods, own, f.parent)
        if key not in resolved:
            try:
                if lock is not None:
                    found = lock.get((col, label(f)))
                    if found is None:
                        sys.exit(f"bbtest: --lock: {label(f)} ({col}) isn't in {args.lock}")
                    entries = locked(st, found, f)
                else:
                    entries = store.resolve(st, store.parse_specs(mods), own, stubs(f))
                    if latest:
                        newest = [f"{e.id}{'[' + e.variant + ']' if e.variant else ''}@latest" for e in entries
                                  if e.source not in ("dev", "stub") and e.id not in st.dev]
                        entries = store.resolve(st, store.parse_specs(list(apply_overrides(mods, store.parse_specs(newest)))),
                                                own, stubs(f))
            except store.SpecError as e:
                sys.exit(f"bbtest: {label(f)}: {e}")
            resolved[key] = entries
        return resolved[key]

    cols = []
    for combo in combos:
        tag = " ".join(o.text for o in combo if len(by_id[o.id]) > 1)
        for f in args.files:
            f = f.resolve()
            mode, seed, origin, fresh, mods, launch = header(f)
            mods = apply_overrides(mods, combo)
            own = own_mod(f, st)
            for env in envs:
                col = f"{env} {tag}".strip()
                if col not in cols:
                    cols.append(col)
                ids = [i for e in resolve(col, mods, own, f) for i in e.provides]
                if lacks := [n for n in needs(f, ids) if n not in HAS[env]]:
                    skipped.setdefault(col, []).append((f, lacks))
                    continue
                ui = env == "ui" or ("js" if env == "jsdom" else False)
                groups.setdefault((col, env, mode, seed, origin, fresh, mods, own, f.parent, launch, ui), []).append(f)

    if "game" in envs:
        for f in args.files:
            for line, name, local in generator_captures(f.resolve()):
                log(f"bbtest: {f}:{line}: in test {name!r} a closure reads the test's local `{local}`, null there "
                    f"once the test has yielded in the original game: take `t` as an argument, keep state in `t.state` (README, pitfalls)")

    stamp = time.strftime("%Y%m%d-%H%M%S") + f"-{os.getpid()}"
    runs = WORK / "runs"
    launches = []
    if any(k[-1] is True for k in groups):
        ensure_ui_engine()
    if any(k[-1] == "js" for k in groups):
        ensure_js_engine()
    if any(k[1] == "code" for k in groups):
        sys.path.insert(0, str(CODETEST))
        import codetest
    for (col, env, mode, seed, origin, fresh, mods, own, sdir, _, ui), files in groups.items():
        entries = resolve(col, mods, own, files[0])
        zips = mount(entries, env, built)
        if env == "code":
            zips = codetest.build_vfs(zips, MODS_ROOT, True)
        units = [(files, args.only)]
        if args.isolate:
            units = [([f], f"{f.stem}::{n}") for f in files for n in TEST_RE.findall(f.read_text())
                     if not args.only or args.only in f"{f.stem}::{n}"]
        for fs, only in units:
            idx = len(launches) + 1
            snap = snapshot_key(seed, origin, zips, fs, env) if args.snapshot and mode == "campaign" and env != "code" else None
            l = Launch(idx, mode, seed, origin, fresh, zips, fs, only, runs / stamp / str(idx), snap, ui, env)
            l.stable_rng = not args.no_stable_rng or args.snapshot
            l.draws = args.draws
            l.col, l.entries = col, entries
            if env == "code":
                l.code_mods = " ".join(e.name for e in entries)
            launches.append(l)

    # Longest first, by the walls of earlier runs (new launches first of all): the last to start are short.
    walls_file = WORK / "walls.json"
    walls = json.loads(walls_file.read_text()) if walls_file.exists() else {}
    keys = {l.idx: l.title().split("] ", 1)[1] for l in launches}
    order = sorted(launches, key=lambda l: -walls.get(keys[l.idx], float("inf")))
    with concurrent.futures.ThreadPoolExecutor(max(1, args.jobs)) as ex:
        list(ex.map(lambda l: l.run(data, args.timeout), order))
    walls = json.loads(walls_file.read_text()) if walls_file.exists() else {}
    walls.update({keys[l.idx]: round(l.wall, 1) for l in launches})
    tmp = walls_file.with_suffix(f".{os.getpid()}")
    tmp.write_text(json.dumps(walls, indent=0, sort_keys=True))
    tmp.replace(walls_file)
    total = failed = 0
    results = {c: {} for c in cols}
    skips = {c: {} for c in cols}
    for l in launches:
        f, statuses, why = report(l, args.verbose, not args.allow_boot_errors)
        skips[l.col].update(why)
        if not f and not args.keep_saves:
            shutil.rmtree(l.dir / "saves", ignore_errors=True)
        total += len(statuses)
        failed += f
        results[l.col].update(statuses)
    for env in cols:
        if skipped.get(env):
            print(f"\n== {env}: files not launched, their tests SKIP")
        for f, lacks in skipped.get(env, []):
            names = [n for n in TEST_RE.findall(f.read_text()) if not args.only or args.only in f"{f.stem}::{n}"]
            print(f"   {label(f)}: needs {' '.join(lacks)} ({len(names)} tests)")
            results[env].update({f"{label(f)}::{n}": "SKIP" for n in names})
            skips[env].update({f"{label(f)}::{n}": f"needs {' '.join(lacks)}" for n in names})
            total += len(names)
    if len(cols) > 1:
        matrix(cols, results)
    (runs / stamp).mkdir(parents=True, exist_ok=True)
    (runs / stamp / "mods.lock").write_text(json.dumps(
        [{"col": l.col, "env": l.env, "files": [label(f) for f in l.files], "mods": [e.lock() for e in l.entries]}
         for l in launches], indent=1))
    (runs / stamp / "statuses.json").write_text(json.dumps(results, indent=0, sort_keys=True))
    (runs / stamp / "skips.json").write_text(json.dumps(skips, indent=0, sort_keys=True))
    print(f"\n{total} tests, {failed} failures/problems; runs in {runs / stamp}")
    # Snapshots of mod builds since changed are never loaded again: drop those unused for 2 days (~6 MB each).
    for old in SNAPSHOTS.glob("*.sav") if args.snapshot else []:
        if time.time() - old.stat().st_mtime > 2 * 86400:
            old.unlink(missing_ok=True)
            old.with_suffix(".nut").unlink(missing_ok=True)
    # Keep the last 20 invocations' run dirs, and any touched in the last hour (parallel invocations).
    for old in sorted(runs.iterdir())[:-20]:
        if time.time() - old.stat().st_mtime > 3600:
            shutil.rmtree(old, ignore_errors=True)
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
