"""Mod specs, the mod store and the resolver behind `// mods:` headers, `-r` and `--lock` (README, "Mods").

A spec is `id[variant]` followed by a version spec (`==0.9.3`, `~=0.9`, `>=1.8,<1.9`) or a source
(`@dev`, `@latest`, `@nexus:<mod>/<file>`, `@sha:<prefix>`), or nothing (the newest release in the store).
"""
import concurrent.futures, hashlib, json, os, re, subprocess, sys, threading, tomllib, zipfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
MODS_ROOT = HERE.parent.parent
BBM = MODS_ROOT.parent
WORK = HERE / "work"
SOURCES = Path(os.environ.get("BBTEST_SOURCES", BBM / "service/sources"))
REGISTRY = tomllib.loads((HERE / "mods/registry.toml").read_text())
# Where store zips come from, most trusted first: the same id, variant and version is taken from the first.
INDICES = [("gh", "gh_assets.jsonl", "gh_assets"), ("nexus", "nexus_zips.jsonl", "nexus"),
           ("local", "local_zips.jsonl", "local"), ("discord", "discord_zips.jsonl", "discord")]
# The user's mods besides the dirs of MODS_ROOT: built from these working copies with @dev.
DEV_DIRS = [BBM / "stdlib", BBM / "rosetta"]


class SpecError(Exception):
    pass


# --- Versions and specs ---

def vkey(v):
    """A sort key: numeric parts (1.0 == 1), a release above its pre-releases (`-dev.15`, `-alpha`, `b2`)."""
    v = str(v).split("+", 1)[0].lstrip("v")
    m = re.match(r"(\d+(?:\.\d+)*)(.*)", v)
    if not m:
        return None
    nums = [int(x) for x in m[1].split(".")]
    while len(nums) > 1 and nums[-1] == 0:
        nums.pop()
    pre = m[2].lstrip("-.")
    return (tuple(nums), 0 if pre else 1, tuple(int(x) if x.isdigit() else x for x in re.split(r"[.\-]", pre)) if pre else ())


def is_pre(v):
    k = vkey(v)
    return k is not None and k[1] == 0


def nums(v):
    k = vkey(v)
    return list(k[0]) if k else []


def match(version, spec):
    """`spec`: comma-separated `op ver` clauses (pip-like); `~=X.Y` = >=X.Y with X.Y as the prefix,
    `~=X.Y.Z` = >=X.Y.Z, X.Y.*. Pre-releases match only a clause naming one."""
    k = vkey(version)
    if k is None:
        return not spec.strip() or any(c.strip() == f"=={version}" for c in spec.split(","))
    for clause in filter(None, (c.strip() for c in spec.split(","))):
        m = re.match(r"(==|!=|>=|<=|~=|>|<)\s*(.+)", clause)
        if not m:
            raise SpecError(f"bad version clause {clause!r}")
        op, want = m[1], m[2].strip()
        w = vkey(want)
        if w is None:
            if not (op == "==" and version == want):
                return False
            continue
        if op == "~=":
            n = nums(want)
            prefix = n[:max(2, len(n) - 1)] if len(n) > 1 else n
            ok = k >= w and list(k[0][:len(prefix)]) + [0] * (len(prefix) - len(k[0])) == prefix
        else:
            ok = {"==": k == w, "!=": k != w, ">=": k >= w, "<=": k <= w, ">": k > w, "<": k < w}[op]
        if not ok:
            return False
    return True


SPEC_RE = re.compile(r"^(!?[A-Za-z_][\w.]*?)(?:\[(\w+)\])?((?:@|==|!=|>=|<=|~=|>|<).*)?$")


class Spec:
    def __init__(self, text):
        m = SPEC_RE.match(text.strip())
        if not m:
            raise SpecError(f"bad mod spec {text!r}: want id[variant] with ==/~=/>=... or @dev/@latest/@nexus:M/F/@sha:P")
        self.text, self.id, self.variant = text, m[1].lstrip("!"), m[2]
        self.exclude = m[1].startswith("!")  # `!id`: never mounted, though required (a missing-dependency test)
        rest = m[3] or ""
        self.source = rest[1:] if rest.startswith("@") else None
        self.version = "" if self.source is not None else rest
        if self.version:
            match("1", self.version)  # validates
        if self.source and not re.match(r"^(dev|latest|nexus:\d+/\d+|sha:[0-9a-f]{4,64})$", self.source):
            raise SpecError(f"bad source in {text!r}: want @dev, @latest, @nexus:<mod>/<file> or @sha:<prefix>")

    def __repr__(self):
        return self.text


def parse_specs(texts):
    return [Spec(t) for s in texts for t in s.split()]


# --- Reading zips ---

def strip_comments(src):
    return re.sub(r"//[^\n]*|/\*.*?\*/", "", src, flags=re.S)


def table_field(srcs, name, field):
    """`field` of the table literal assigned to `name` (`::MSU <- {Version = "1.9.0", ...}`) in any of srcs."""
    for src in srcs:
        for m in re.finditer(rf"(?:::|\b){re.escape(name)}\s*(?:<-|=)\s*\{{", src):
            f = re.search(rf'\b{field}\s*=\s*("[^"]*"|\d+(?:\.\d+)*)', src[m.end():m.end() + 3000])
            if f:
                return f[1]
        m = re.search(rf"(?:::|\b){re.escape(name)}\.{field}\s*<-\s*(\"[^\"]*\"|\d+(?:\.\d+)*)", src)
        if m:
            return m[1]
    return None


def resolve_expr(expr, srcs, extra=()):
    """A string or number literal, or a name/field (`::X.ID`, `mod.Version`, `def.ID`) bound to one;
    a table literal may be in `extra` files too, a plain name only in `srcs`."""
    expr = expr.strip()
    if m := re.fullmatch(r'(.+?)\s*\+\s*"(\w*)"', expr):
        head = resolve_expr(m[1], srcs, extra)
        return head and head + m[2]
    if not re.fullmatch(r'"[^"]*"|\d+(?:\.\d+)*', expr):
        parts = re.sub(r"^::", "", expr).split(".")
        lit = None
        if len(parts) == 2:
            lit = table_field(list(srcs) + list(extra), parts[0], parts[1])
        if lit is None:
            name = parts[-1]
            for src in srcs:
                m = re.search(rf'\b{re.escape(name)}\s*(?:=|<-)\s*("[^"]*"|\d+(?:\.\d+)*)', src)
                if m:
                    lit = m[1]
                    break
        if lit is None:
            return None
        expr = lit
    # mod_hooks takes a number and prints it as Squirrel does: 2.20 as "2.2", 1.0 as "1".
    return expr[1:-1] if expr.startswith('"') else f"{float(re.match(r'[0-9]+(?:\.[0-9]+)?', expr)[0]):g}"


def balanced(src, start):
    """The text inside the parens opening at src[start]."""
    depth = 0
    for i in range(start, len(src)):
        c = src[i]
        if c == '"':
            j = src.find('"', i + 1)
            while j > 0 and src[j - 1] == "\\":
                j = src.find('"', j + 1)
            i = j if j > 0 else i
        if c in "([{":
            depth += 1
        elif c in ")]}":
            depth -= 1
            if depth == 0:
                return src[start + 1:i]
    return src[start + 1:]


def req_strings(arg, src):
    """String literals of a require/queue argument; a bare name is a local array of them (`requiredMods`)."""
    out = re.findall(r'"([^"]*)"', arg)
    for name in re.findall(r"(?<![\w.:\"])([A-Za-z_]\w*)(?![\w\"(])", re.sub(r'"[^"]*"', "", arg)):
        m = re.search(rf"\b{name}\s*(?:=|<-)\s*\[", src)
        if m:
            out += re.findall(r'"([^"]*)"', balanced(src, m.end() - 1))
    return out


def parse_req(s):
    """`mod_x >= 1.0`, `mod_x(>=1.0)`, `mod_x`: (id, spec); None for load order (`>x`, `<x`),
    conflicts (`!x`), vanilla and DLCs."""
    s = s.strip()
    if not s or s[0] in "<>!":
        return None
    m = re.match(r"([A-Za-z_][\w]*)\s*(?:\(([^)]*)\)|(.*))$", s)
    if not m or m[1] == "vanilla" or m[1].startswith("dlc_"):
        return None
    spec = (m[2] or m[3] or "").strip()
    spec = re.sub(r"\s+", "", spec)
    return m[1], spec


REGISTER = re.compile(r"(Hooks\.(?:register|__unverifiedRegister)|mods_registerMod)\s*\(")


def read_zip(path):
    """{ids: [[id, version|None]], reqs: [[id, spec]], compiled: bool} from the zip's preload scripts."""
    ids, reqs, compiled = [], [], False
    uses_hooks = uses_mods = False
    with zipfile.ZipFile(path) as z:
        names = [n for n in z.namelist() if not n.endswith(("/", "\\"))]
        pre = [n for n in names if "mods_preload/" in n.replace("\\", "/")]
        compiled = any(n.endswith(".cnut") for n in pre)
        texts = {}
        for n in pre:
            if n.endswith(".nut"):
                try:
                    texts[n] = strip_comments(z.read(n).decode("utf-8", "replace"))
                except Exception:
                    pass
        # Tables named in registrations may live outside the preload (MSU's scripts/config, Modern Hooks').
        extra = None

        def more():
            nonlocal extra
            if extra is None:
                extra = []
                for n in names:
                    if n.endswith(".nut") and n not in texts and ("config/" in n or "hooks" in n or n.count("/") <= 2):
                        try:
                            extra.append(strip_comments(z.read(n).decode("utf-8", "replace")))
                        except Exception:
                            pass
            return extra

        for n, src in texts.items():
            uses_hooks |= "::Hooks." in src or "Hooks.register" in src
            uses_mods |= "mods_registerMod" in src or "mods_queue" in src
            for m in REGISTER.finditer(src):
                args = re.split(r",(?![^(\[]*[)\]])", balanced(src, m.end() - 1))
                if len(args) < 2:
                    continue
                i = resolve_expr(args[0], [src]) or resolve_expr(args[0], [src], more())
                if not i or not re.fullmatch(r"[\w.]+", i):
                    continue
                v = resolve_expr(args[1], [src]) or resolve_expr(args[1], [src], more())
                if vf := reg(i).get("version_file"):
                    f, rx = vf.split(":", 1)
                    m2 = f in names and re.search(rx, z.read(f).decode("utf-8", "replace"))
                    v = m2[1] if m2 else v
                ids.append([i, v])
                if m[1] == "mods_registerMod":
                    q = re.search(r"mods_queue\s*\(", src[m.end():])
                    if q:
                        qargs = balanced(src, m.end() + q.end() - 1)
                        parts = re.split(r",(?![^(\[]*[)\]])", qargs, maxsplit=1)
                        if len(parts) > 1:
                            for s in req_strings(re.split(r",\s*function", parts[1])[0], src):
                                reqs += [list(r) for x in s.split(",") if (r := parse_req(x))]
            for m in re.finditer(r"\.require\s*\(", src):
                for s in req_strings(balanced(src, m.end() - 1), src):
                    if r := parse_req(s):
                        reqs.append(list(r))
    # Mods of mod_hooks' API need it; those of Modern Hooks', it.
    own = {i for i, _ in ids}
    if uses_mods and not uses_hooks and "mod_hooks" not in own and own:
        reqs.append(["mod_hooks", ""])
    if uses_hooks and "mod_modern_hooks" not in own and own:
        reqs.append(["mod_modern_hooks", ""])
    uniq = []
    for x in ids:
        if x not in uniq:
            uniq.append(x)
    reqs = [r for i, r in enumerate(reqs) if r[0] not in own and r not in reqs[:i]]
    return {"ids": uniq, "reqs": reqs, "compiled": compiled}


def sha256(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


CACHE = WORK / "store_index.json"


def _read_one(item):
    path, stat_key = item
    try:
        return path, stat_key, read_zip(path)
    except Exception as e:  # 7z or rar named .zip, as players post them
        return path, stat_key, {"ids": [], "reqs": [], "compiled": False, "bad": str(e)[:200]}


def read_all(paths):
    """read_zip of each path, cached in work/store_index.json by path, size and mtime."""
    cache = json.loads(CACHE.read_text()) if CACHE.exists() else {}
    todo, out = [], {}
    for p in paths:
        st = p.stat()
        key = f"{st.st_size} {st.st_mtime_ns}"
        c = cache.get(str(p))
        if c and c["key"] == key:
            out[p] = c["data"]
        else:
            todo.append((p, key))
    if todo:
        print(f"bbtest: reading {len(todo)} store zips (cached in {CACHE.relative_to(HERE)}) ...", file=sys.stderr)
        with concurrent.futures.ThreadPoolExecutor(8) as ex:
            for p, key, data in ex.map(_read_one, todo):
                out[p] = data
                cache[str(p)] = {"key": key, "data": data}
        CACHE.parent.mkdir(parents=True, exist_ok=True)
        tmp = CACHE.with_suffix(f".{os.getpid()}")
        tmp.write_text(json.dumps(cache))
        tmp.replace(CACHE)
    return out


# --- The store ---

class Entry:
    """A mod as a launch mounts it: a store zip (by sha256), a working copy (`dev`), or a stub dir."""

    def __init__(self, id, version, variant, source, path=None, sha=None, provides=(), reqs=(), name=None, dir=None):
        self.id, self.version, self.variant, self.source = id, version, variant, source
        self.path, self.sha, self.dir = path, sha, dir
        self.provides = dict(provides)  # id -> version, of every mod the zip registers
        self.reqs = list(reqs)
        self.name = name or (path.name if path else None)  # the file name it is mounted under

    def lock(self):
        return {"id": self.id, "variant": self.variant, "version": self.version, "source": self.source,
                "sha256": self.sha, "file": self.name}

    def __repr__(self):
        return f"{self.id}{'[' + self.variant + ']' if self.variant else ''}=={self.version} ({self.source})"


def reg(id):
    return REGISTRY.get("mods", {}).get(id, {})


def variant_of(id, file_name):
    """The variant a file of `id` is: by the mod's own `variants` table, else the global one; None = default."""
    for name, rx in {**REGISTRY.get("variants", {}), **reg(id).get("variants", {})}.items():
        if re.search(rx, file_name):
            return name
    return reg(id).get("default")


def declared_version(row, file_name):
    if row and row.get("declared"):
        return row["declared"]
    if row and row.get("tag"):
        return row["tag"]
    m = re.search(r"[-_ ](\d+(?:[.\-]\d+)*[a-z]?)(?:[-_ ][\w\- ]*)?\.zip$", file_name)
    if not m:
        return None
    # Nexus names put dashes for dots: mod_x-473-5-0e-1749340176.zip is 5.0e.
    m2 = re.search(r"-\d+-(\d+(?:-\d+)*[a-z]?)-\d{9,}", file_name)
    return m2[1].replace("-", ".") if m2 else m[1]


def clean_name(source, file_name):
    """The name a player has the file under: index copies carry a hash or id prefix."""
    if source == "local":
        return re.sub(r"^[0-9a-f]{12}-", "", file_name)
    if source in ("gh", "discord"):
        return re.sub(r"^\d+-", "", file_name)
    return file_name


class Store:
    def __init__(self):
        self.entries = []   # third-party and released zips
        self.dev = {}       # id -> (dir, prefix, version) of the user's working copies
        self._load()

    def _rows(self):
        rows = []
        mods_dir = HERE / "mods"
        for p in sorted(mods_dir.glob("*.zip")):
            rows.append(("bbtest", p, None))
        for src, index, d in INDICES:
            f = SOURCES / index
            if not f.exists():
                continue
            for line in f.read_text().splitlines():
                r = json.loads(line)
                p = SOURCES / d / r["file_name"]
                if p.exists():
                    rows.append((src, p, r))
        return rows

    def _load(self):
        self._load_dev()
        rows = self._rows()
        data = read_all([p for _, p, _ in rows])
        by_sha_row = {}
        for src, p, r in rows:
            if r and r.get("sha256"):
                by_sha_row.setdefault(r["sha256"], r)
        seen = set()
        for src, p, r in rows:
            d = data[p]
            sha = r.get("sha256") if r else None
            if not sha:  # mods/ and GitHub assets carry no hash in an index
                sha = self._sha(p)
            if src == "bbtest":
                r = by_sha_row.get(sha)
            if sha in seen:
                continue
            seen.add(sha)
            name = clean_name(src, p.name)
            if "_TMP" in name:  # local builds, not releases
                continue
            ids = [list(x) for x in d["ids"]]
            # Compiled preloads hide registrations: the index's (it decompiles them), or the registry's `match`.
            if not ids and r:
                ids = [list(x) for x in r.get("mods", [])]
            for id, info in REGISTRY.get("mods", {}).items():
                if "match" in info and re.search(info["match"], name) and id not in [i for i, _ in ids]:
                    ids.append([id, None])
            provides = {}
            for id, v in ids:
                if reg(id).get("version") == "declared" or not v:
                    v = declared_version(r, name) or v
                if v and (id not in provides or not provides[id]):
                    provides[id] = v
            for id, v in provides.items():
                if id in self.dev and not self._is_release(id, src, name):
                    continue
                self.entries.append(Entry(id, v, variant_of(id, name), src, p, sha, provides, d["reqs"], name))

    def _sha(self, p):
        """sha256 of a store zip, cached in work/store_sha.json by path, size and mtime."""
        cache = WORK / "store_sha.json"
        if not hasattr(self, "_shas"):
            self._shas = json.loads(cache.read_text()) if cache.exists() else {}
        st = p.stat()
        key = f"{p} {st.st_size} {st.st_mtime_ns}"
        if key not in self._shas:
            self._shas[key] = sha256(p)
            cache.parent.mkdir(parents=True, exist_ok=True)
            tmp = cache.with_suffix(f".{os.getpid()}")
            tmp.write_text(json.dumps(self._shas))
            tmp.replace(cache)
        return self._shas[key]

    def _is_release(self, id, src, name):
        """The user's own mods: a published file, or a local one named as `make zip` names a release."""
        if src in ("nexus", "gh", "bbtest"):
            return True
        prefix = self.dev[id][1]
        return src == "local" and re.fullmatch(rf"{re.escape(prefix)}_\d+(\.\d+)*\.zip", name) is not None

    def _load_dev(self):
        dirs = [p.parent for p in sorted(MODS_ROOT.glob("*/Makefile"))] + DEV_DIRS
        for d in dirs:
            mk = (d / "Makefile").read_text() if (d / "Makefile").exists() else ""
            m = re.search(r"^MOD_NAME\s*=\s*(\S+)", mk, re.M)
            if not m:
                continue
            prefix = m[1] if m[1] in ("stdlib",) else f"mod_{m[1]}"
            info = dev_info(d)
            if info:
                self.dev.setdefault(info[0], (d, prefix, info[1]))

    def dev_entry(self, id):
        d, prefix, version = self.dev[id]
        info = dev_info(d)  # the working copy may have changed since
        version = info[1] if info else version
        return Entry(id, version, None, "dev", None, None, {id: version}, dev_reqs(d, id), f"{prefix}_{version}.zip", d)

    def candidates(self, id, variant):
        return [e for e in self.entries if e.id == id and e.variant == variant]

    def variants(self, id):
        return sorted({e.variant or "" for e in self.entries if e.id == id})


def dev_info(d):
    """(id, version) a working copy registers, from its preload (the registry's `version_file` where unreadable)."""
    srcs = []
    for p in sorted((d / "scripts/!mods_preload").glob("*.nut")):
        srcs.append(strip_comments(p.read_text(errors="replace")))
    for src in srcs:
        for m in REGISTER.finditer(src):
            args = re.split(r",(?![^(\[]*[)\]])", balanced(src, m.end() - 1))
            if len(args) < 2:
                continue
            i = resolve_expr(args[0], srcs)
            if not i or i.startswith(("vanilla", "test_")):
                continue
            v = resolve_expr(args[1], srcs)
            vf = reg(i).get("version_file")
            if vf:
                f, rx = vf.split(":", 1)
                v = re.search(rx, (d / f).read_text())[1]
            return i, v
    return None


def dev_reqs(d, id):
    """What a working copy requires, read as from its zip (a private one: bbtest runs in parallel)."""
    tmp = WORK / "store_dev"
    tmp.mkdir(parents=True, exist_ok=True)
    z = tmp / f"{d.name}.{os.getpid()}.{threading.get_ident()}.zip"
    with zipfile.ZipFile(z, "w") as zf:
        for p in (d / "scripts/!mods_preload").glob("*.nut"):
            zf.write(p, f"scripts/!mods_preload/{p.name}")
        for p in (d / "scripts/config").glob("*.nut") if (d / "scripts/config").exists() else []:
            zf.write(p, f"scripts/config/{p.name}")
    try:
        return read_zip(z)["reqs"]
    finally:
        z.unlink()


# --- Resolving ---

def best(cands, spec_text, latest=False):
    ok = [e for e in cands if match(e.version, spec_text) and (latest or not is_pre(e.version)
                                                                 or any(is_pre(c.split("=")[-1]) for c in spec_text.split(",") if "=" in c))]
    order = {s: i for i, s in enumerate(["bbtest", "gh", "nexus", "local", "discord"])}
    ok.sort(key=lambda e: (vkey(e.version) or ((), 0, ()), -len(e.provides), -order[e.source]), reverse=True)
    return ok[0] if ok else None


def pick(store, spec, own=None):
    """The entry for one explicit spec."""
    # The mod under test is its working copy unless a version or source is named (e.g. `-r` of a release).
    if spec.source == "dev" or (own and spec.id == own and spec.source is None and not spec.version):
        if spec.id not in store.dev:
            raise SpecError(f"{spec}: no working copy of {spec.id} (the user's mods: {', '.join(sorted(store.dev))})")
        e = store.dev_entry(spec.id)
        if spec.version and not match(e.version, spec.version):
            raise SpecError(f"{spec}: the working copy of {spec.id} is {e.version}")
        return e
    cands = store.candidates(spec.id, spec.variant)
    if spec.source and spec.source.startswith("sha:"):
        found = [e for e in store.entries if e.sha and e.sha.startswith(spec.source[4:]) and e.id == spec.id]
        if not found:
            raise SpecError(f"{spec}: no store zip of {spec.id} with that sha256")
        return found[0]
    if spec.source and spec.source.startswith("nexus:"):
        mod, file = spec.source[6:].split("/")
        rows = {str(p): r for _, p, r in store._rows() if r}
        found = [e for e in store.entries if e.id == spec.id and (r := rows.get(str(e.path)))
                 and str(r.get("nexus_mod")) == mod and str(r.get("file_id")) == file]
        if not found:
            raise SpecError(f"{spec}: no store zip of Nexus mod {mod} file {file} registering {spec.id}")
        return found[0]
    e = best(cands, spec.version, spec.source == "latest")
    if e:
        return e
    if spec.id in store.dev and match(store.dev_entry(spec.id).version, spec.version):
        raise SpecError(f"{spec}: only the working copy of {spec.id} ({store.dev_entry(spec.id).version}) satisfies "
                        f"it, no release does; use {spec.id}@dev")
    have = sorted({e.version for e in cands}, key=lambda v: vkey(v) or ((), 0, ()))
    vs = store.variants(spec.id)
    raise SpecError(f"{spec}: no such version in the store; have {', '.join(have[-12:]) or 'none'}"
                    + (f"; variants: {', '.join(v or '(default)' for v in vs)}" if len(vs) > 1 or vs and vs[0] else ""))


def extra_reqs(e):
    """The registry's `requires` of an entry: "id", or "id if SPEC" for those releases only (a working copy
    may have fixed it under the same version)."""
    out = []
    for r in reg(e.id).get("requires", []):
        id, _, when = r.partition(" if ")
        if not when or (e.source != "dev" and e.version and match(e.version, when)):
            out.append([id.strip(), ""])
    return out


def resolve(store, specs, own=None, stubs=None):
    """Entries for the specs and, transitively, what they require; `own` = the id of the mod under test
    (built from its working copy); `stubs` = {token: dir} of test-only mod dirs next to the scenario."""
    chosen, stub_entries = {}, []
    explicit, excluded = {}, {s.id for s in specs if s.exclude}
    for s in specs:
        if s.exclude:
            continue
        if stubs and s.id in stubs and s.version == "" and s.source is None:
            stub_entries.append(Entry(s.id, None, None, "stub", None, None, {}, [], f"{s.id}.zip", stubs[s.id]))
            continue
        explicit[s.id] = s
    for s in explicit.values():
        chosen[s.id] = pick(store, s, own)
    constraints = {}
    for _ in range(20):
        changed = False
        provided = {i: (e, v) for e in chosen.values() for i, v in e.provides.items()}
        for e in list(chosen.values()):
            for id, sp in e.reqs + extra_reqs(e):
                if id in excluded:
                    continue
                if sp and not any(c == sp for c, _ in constraints.get(id, [])):
                    constraints.setdefault(id, []).append((sp, e.id))
                spec_text = ",".join(c for c, _ in constraints.get(id, []))
                if id in provided:
                    pe, pv = provided[id]
                    if match(pv, spec_text):
                        continue
                    if id in explicit or pe.id != id:
                        raise SpecError(f"{e.id} requires {id} {sp}, but {pe} gives {pv}")
                ne = store.dev_entry(id) if id == own else best(store.candidates(id, None), spec_text)
                if not ne or not match(ne.version, spec_text):
                    try:
                        pick(store, Spec(id + spec_text), own)  # raises with what the store has
                    except SpecError as err:
                        raise SpecError(f"{e.id} requires {id} {spec_text or '(any)'}: {err}") from None
                    raise SpecError(f"{e.id} requires {id} {spec_text}: nothing satisfies it")
                chosen[id] = ne
                changed = True
                break
            if changed:
                break
        if not changed:
            break
    return list(chosen.values()) + stub_entries


# --- Building and mounting ---

def build_dev(e, out_dir):
    """Zip a working copy as `make install` would, without its checks, as `<prefix>_<version>.zip`."""
    src = e.dir
    run = lambda *cmd: subprocess.run(cmd, cwd=src, capture_output=True, text=True)
    sources = run("make", "-s", "--eval", "bbtest-vars: ; @echo $(SOURCES)", "bbtest-vars").stdout.split()
    run("make", "-s", "include")  # generates i_* includes, where the mod has them
    files = set()
    git = run("git", "ls-files", "--cached", "--others", "--exclude-standard", "--", *sources)
    files.update(l for l in git.stdout.splitlines() if l)
    for s in sources:
        for p in (src / s).rglob("i_*") if (src / s).is_dir() else []:
            files.add(str(p.relative_to(src)))
    out_dir.mkdir(parents=True, exist_ok=True)
    out = out_dir / e.name
    tmp = out.with_suffix(f".{os.getpid()}.tmp")
    with zipfile.ZipFile(tmp, "w", zipfile.ZIP_DEFLATED) as z:
        for f in sorted(files):
            if (src / f).is_file():
                z.write(src / f, f)
    tmp.replace(out)
    e.path, e.sha = out, sha256(out)
    return out


def mount_path(e):
    """The store zip under the name a player has it (index copies carry prefixes): a symlink if renamed."""
    if e.path.name == e.name:
        return e.path
    link = WORK / "store" / e.sha[:12] / e.name
    if not link.is_symlink():
        link.parent.mkdir(parents=True, exist_ok=True)
        link.symlink_to(e.path)
    return link
