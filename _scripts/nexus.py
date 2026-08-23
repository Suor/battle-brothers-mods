#!/usr/bin/env python3
"""NexusMods CLI. Run from mod directory, mod URL defaults to URL from its Makefile.

Usage: nexus.py upload [-d DESCRIPTION] [-c CHANGELOG_TEXT_OR_FILE] [mod]
       nexus.py versions [mod]
       nexus.py add-changelog VERSION TEXT_OR_FILE [mod]
       nexus.py check-updates [--local]
       nexus.py download|update mod

A mod is given as its page url or as a bare id; commands run from a mod directory default to
the URL in its Makefile.
"""
import argparse, base64, calendar, glob, json, os, re, socket, struct, sys, time, zipfile, zlib
import requests
from urllib.parse import urlparse

ENV_FILE = os.path.join(os.path.dirname(__file__), "..", ".env")
ENV_DICT = dict(l.strip().split("=", 1) for l in open(ENV_FILE) if "=" in l)
API_KEY = os.environ.get("NEXUSMODS_KEY") or ENV_DICT.get("NEXUSMODS_KEY") \
    or sys.exit("NEXUSMODS_KEY not found in environment or %s" % ENV_FILE)

BASE = "https://api.nexusmods.com/v3"
HEADERS = {"apikey": API_KEY, "Content-Type": "application/json"}
GAME = "battlebrothers"

# Mod ids for installed zips whose filename carries no Nexus id (renamed, repacks, local builds).
# None = own or dead mod, do not check.
NEXUS_IDS = {
    "PassiveShieldDamage": 746,
    "mod_pandoras_hobby": 992,
    "mod_Black_Pyramid": 986,
    "mod_dev_console": 380,
    "mod_dog_love": 686,
    "mod_hooks": 42,
    "mod_modern_hooks": 685,
    "mod_msu": 479,
    "mod_swifter": 542,
    "mod_framework": 765,
    "mod_reforged": 765,  # separate files of one mod — own entries so they don't look like dups
    "mod_reforged_core": 765,
    "mod_reforged_assets": 765,
}


def api(method, path, **kw):
    r = requests.request(method, BASE + path, headers=HEADERS, **kw)
    r.raise_for_status()
    return r.json()


def ver(s):
    m = re.search(r"(\d+(?:\.\d+)*)", s)
    return tuple(int(x) for x in m.group(1).split(".")) if m else (0,)


def split_url(url):
    """A mod page url or a bare id -> (game, site mod id)."""
    if url.isdigit():
        return GAME, int(url)
    # https://www.nexusmods.com/battlebrothers/mods/855
    parts = urlparse(url).path.strip("/").split("/")
    return parts[0], int(parts[2])


def get_mod(url):
    if not url:
        try:
            url = re.search(r"^URL\s*=\s*(\S+)", open("Makefile").read(), re.M).group(1)
        except (OSError, AttributeError):
            sys.exit("No url given and no URL in ./Makefile")
    game, mod_id = split_url(url)
    return api("GET", f"/games/{game}/mods/{mod_id}")["data"]


def get_mod_id(url):
    return get_mod(url)["id"]


def get_files(mod_id):
    return api("GET", f"/mods/{mod_id}/files")["data"]["mod_files"]


def get_versions(file_id):
    return api("GET", f"/mod-files/{file_id}/versions")["data"]["versions"]


def changelog_text(text, version):
    if os.path.isfile(text):  # extract this version's entry from a CHANGELOG file
        lines = open(text).read().split("\n")
        start = lines.index(version) + 1
        text = "\n".join(lines[start:lines.index("", start)])
    # NexusMods renders each line as a bullet itself
    return "\n".join(re.sub(r"^- ", "", l) for l in text.split("\n"))


def post_changelog(mod_id, version, text):
    api("POST", f"/mods/{mod_id}/changelogs",
        json={"version": version, "changelog": changelog_text(text, version)})
    print("Changelog added.")


def cmd_info(args):
    for k, v in get_mod(args.url).items():
        print(f"{k}: {v}")


def cmd_files(args):
    for f in get_files(get_mod_id(args.url)):
        latest = get_versions(f["id"])[0]
        print(f"{f['id']:10} {latest['version']:10} {latest['name']}  "
              f"versions={f['versions_count']} archived={f['archived_count']} "
              f"active={f['is_active']}  container={f['name']}")


def cmd_versions(args):
    mod_id = get_mod_id(args.url)
    for f in get_files(mod_id):
        for v in get_versions(f["id"]):
            print(f"{v['version']:10} {v['category']:12} {v['name']}")


def cmd_changelog(args):
    post_changelog(get_mod_id(args.url), args.version, args.text)


def api1(path):  # old v1 API: cheap per-mod version/timestamp lookups
    r = requests.get("https://api.nexusmods.com/v1" + path, headers={"apikey": API_KEY})
    r.raise_for_status()
    return r.json()


def zip_version(path):
    with zipfile.ZipFile(path) as z:
        for n in z.namelist():
            if re.match(r"scripts/!mods_preload/[^/]+\.nut$", n):
                src = z.read(n).decode("utf-8", "replace")
                m = re.search(r'Version\s*=\s*"([^"]+)"', src) \
                    or re.search(r'::mods_registerMod\(\s*"[^"]+"\s*,\s*([\d.]+)', src)
                if m:
                    return m.group(1)


def parse_zip_name(name):
    """Extract (file_name, mod_id, version, download_epoch) from NexusMods/Vortex naming."""
    if m := re.match(r"^(.+?)-(\d+)-(.+)-(\d{10})\.zip$", name):  # site: name-id-1-2-3-epoch.zip
        return m.group(1), int(m.group(2)), m.group(3).replace("-", "."), int(m.group(4))
    if m := re.match(r"^(.*?) (\d+) (\S+) (\d{4}-\d{2}-\d{2}T\d{2}-\d{2}Z) ", name):  # Vortex
        epoch = calendar.timegm(time.strptime(m.group(4), "%Y-%m-%dT%H-%MZ"))
        return m.group(1), int(m.group(2)), m.group(3), epoch
    return None


TG_DIR = os.path.expanduser("~/Downloads/Telegram Desktop")  # russian repacks arrive here


def _tg_key(name):  # filename with version and copy-suffix stripped, to match repack lineages
    return re.sub(r" \(\d+\)", "", re.sub(r"\d+(?:\.\d+)+", "", name)).lower()


def file_key(name):  # what stays the same across one Nexus file's own versions
    return re.sub(r"[^a-z0-9]", "", _tg_key(name).removesuffix(".zip"))


def file_keys(f):  # a file is known both by its display name and by the name it downloads as
    keys = {file_key(f["name"])}
    if parsed := parse_zip_name(f["file_name"]):
        keys.add(file_key(parsed[0]))
    return keys


def stale_file(zip_path, mod_dir):
    """First shipped file whose source is newer than the installed copy."""
    with zipfile.ZipFile(zip_path) as z:
        for i in z.infolist():
            src = os.path.join(mod_dir, i.filename)
            # mtime is only a cheap filter (git touches it, zip truncates it) — CRC decides
            if os.path.isfile(src) \
                    and os.path.getmtime(src) > time.mktime(i.date_time + (0, 0, -1)) \
                    and zlib.crc32(open(src, "rb").read()) != i.CRC:
                return i.filename


def cmd_check_updates(args):
    data_dir = ENV_DICT["DATA_DIR"].replace("\\", "")
    root = os.path.join(os.path.dirname(__file__), "..")
    # own mods live in mods/* and in sibling repos (rosetta, stdlib, xbe)
    own = {m.group(1): os.path.normpath(os.path.dirname(mk))
           for pat in ("*", "../*") for mk in glob.glob(os.path.join(root, pat, "Makefile"))
           if (m := re.search(r"^MOD_NAME\s*=\s*(\S+)", open(mk).read(), re.M))}

    tg = {}
    for f in os.listdir(TG_DIR) if os.path.isdir(TG_DIR) else []:
        if f.endswith(".zip"):
            tg.setdefault(_tg_key(f), []).append(f)

    unknown, stale_installs, dups, fresh, tg_newer = [], [], {}, 0, False
    for name in sorted(os.listdir(data_dir)):
        if not name.endswith(".zip"):
            continue
        path = os.path.join(data_dir, name)

        newer = [f for f in tg.get(_tg_key(name), []) if ver(f) > ver(name)]
        if newer:
            tg_newer = True
            print(f"{name}\n    -> {max(newer, key=ver)} in {TG_DIR}")

        if mod_dir := next((d for n, d in own.items()
                            if re.match(rf"(mod_)?{re.escape(n)}[_.-]", name)), None):
            dups.setdefault(mod_dir, []).append(name)
            if stale := stale_file(path, mod_dir):
                stale_installs.append((name, stale))
            continue
        if parsed := parse_zip_name(name):
            fname, mod_id, local_ver, local_ts = parsed
            lineage = fname
            dups.setdefault((mod_id, _tg_key(fname)), []).append(name)
            if args.local:
                continue
        elif prefix := max((p for p in NEXUS_IDS if name.startswith(p)), key=len, default=None):
            dups.setdefault(prefix, []).append(name)
            if args.local or NEXUS_IDS[prefix] is None:
                continue
            mod_id, local_ts, lineage = NEXUS_IDS[prefix], os.path.getmtime(path), name
            local_ver = (m.group(1) if (m := re.search(r"(\d+(?:\.\d+)+)", name)) else None) \
                or zip_version(path)
        elif args.local:
            continue
        else:
            unknown.append(name)
            continue

        # an art pack or an assets file carries its own version line, unrelated to the mod's
        data = api1(f"/games/{GAME}/mods/{mod_id}/files.json")
        by_id = {f["file_id"]: f for f in data["files"]}
        updates = {u["old_file_id"]: u["new_file_id"] for u in data["file_updates"]}
        if latest := next((f for f in data["files"] if f["file_name"] == name), None):
            while (nxt := updates.get(latest["file_id"])) in by_id:
                latest = by_id[nxt]
        else:  # a repack has no file of that name upstream — fall back to matching by name
            live = [f for f in data["files"]
                    if f["category_name"] not in ("OLD_VERSION", "ARCHIVED")]
            same = [f for f in live if file_key(lineage) in file_keys(f)] \
                or [f for f in live if f["category_name"] == "MAIN"] or live
            latest = max(same, key=lambda f: f["uploaded_timestamp"])
        remote_ver, remote_ts = latest["version"], latest["uploaded_timestamp"]
        if local_ver and ver(remote_ver) <= ver(local_ver):
            fresh += 1
            continue
        if not local_ver and remote_ts <= local_ts:
            fresh += 1
            continue
        updated = time.strftime("%Y-%m-%d", time.gmtime(remote_ts))
        fixed = "  [LOCAL FIXES — reapply, see FIXES.md]" if "FIXED" in name else ""
        print(f"{name}\n    {local_ver or '?'} -> {remote_ver} (updated {updated})  "
              f"https://www.nexusmods.com/{GAME}/mods/{mod_id}{fixed}")

    if dup_groups := [names for names in dups.values() if len(names) > 1]:
        print("Same mod installed more than once:")
        for names in dup_groups:
            print("    " + "  ".join(names))

    if stale_installs:
        # stale install is only a hint: sources may be work in progress
        print("Older than sources — WIP or forgot `make install`?")
        width = max(len(name) for name, _ in stale_installs)
        for name, stale in stale_installs:
            print(f"    {name:{width}}  {stale}")

    if args.local:
        if not (tg_newer or dup_groups or stale_installs):
            print("Nothing to report.")
        return
    print(f"\n{fresh} up to date.")
    if unknown:
        print("No Nexus id known (add to NEXUS_IDS in nexus.py?):")
        for name in unknown:
            print(f"    {name}")


def cmd_upload(args):
    # Find latest release zip (no _MODIFIED suffix)
    zips = [f for f in os.listdir(".") if f.endswith(".zip") and "_MODIFIED" not in f
            and re.search(r"\d+\.\d+", f)]
    if not zips:
        sys.exit("No release zip found")
    zipfile = max(zips, key=ver)
    version = ".".join(str(x) for x in ver(zipfile))
    name = zipfile.removesuffix(".zip")
    print(f"Found: {zipfile}  (version {version})")

    mod_id = get_mod_id(args.url)
    files = get_files(mod_id)
    if files:
        file_id = files[0]["id"]
        if version in [v["version"] for v in get_versions(file_id)]:
            sys.exit(f"Version {version} is already on NexusMods, skipping")

    description = args.description or input("File description: ").strip()

    size = os.path.getsize(zipfile)
    print(f"Uploading ({size} bytes)...")
    up = api("POST", "/uploads", json={"filename": zipfile, "size_bytes": size})["data"]

    with open(zipfile, "rb") as f:
        requests.put(up["presigned_url"], data=f, headers={
            "Content-Type": "application/octet-stream",
            "Content-Disposition": f'attachment; filename="{zipfile}"',
        }).raise_for_status()

    print("Finalising...")
    requests.post(f"{BASE}/uploads/{up['id']}/finalise", headers=HEADERS).raise_for_status()

    for _ in range(30):
        time.sleep(2)
        if api("GET", f"/uploads/{up['id']}")["data"]["state"] == "available":
            break
    else:
        sys.exit("Timed out waiting for upload to become available")

    body = {"upload_id": up["id"], "name": name, "version": version,
            "file_category": "main", "description": description, "update_mod_version": True}
    if files:
        api("POST", f"/mod-files/{file_id}/versions", json=body)
    else:
        api("POST", "/mod-files", json=body | {"mod_id": mod_id})
    print("Done!")

    if args.changelog:
        post_changelog(mod_id, version, args.changelog)


CDP_PORT = 9222  # yandex-browser.desktop passes --remote-debugging-port


class Browser:
    """Minimal DevTools client over a raw websocket — a free download needs a logged-in session."""

    def __init__(self, port=CDP_PORT):
        try:
            tabs = requests.get(f"http://127.0.0.1:{port}/json/list", timeout=5).json()
        except requests.ConnectionError:
            sys.exit(f"No browser on port {port} — start it with --remote-debugging-port={port}")
        pages = [t for t in tabs if t["type"] == "page"]
        if not pages:
            sys.exit("Browser has no open tab")
        tab = next((t for t in pages if "nexusmods.com" in t["url"]), pages[0])
        ws = urlparse(tab["webSocketDebuggerUrl"])
        self.sock = socket.create_connection((ws.hostname, ws.port), timeout=120)
        self.io = self.sock.makefile("rb")
        self.sock.sendall(
            f"GET {ws.path} HTTP/1.1\r\nHost: {ws.netloc}\r\nUpgrade: websocket\r\n"
            f"Connection: Upgrade\r\nSec-WebSocket-Version: 13\r\n"
            f"Sec-WebSocket-Key: {base64.b64encode(os.urandom(16)).decode()}\r\n\r\n".encode())
        if b"101" not in self.io.readline():
            sys.exit("Browser refused the DevTools websocket")
        while self.io.readline().strip():
            pass
        self.msg_id = 0

    def _send(self, text):
        payload, mask = text.encode(), os.urandom(4)
        n = len(payload)
        if n < 126:
            head = bytes([0x81, 0x80 | n])
        elif n < 65536:
            head = bytes([0x81, 0xfe]) + struct.pack(">H", n)
        else:
            head = bytes([0x81, 0xff]) + struct.pack(">Q", n)
        self.sock.sendall(head + mask + bytes(c ^ mask[i % 4] for i, c in enumerate(payload)))

    def _recv(self):
        buf = b""
        while True:
            head = self.io.read(2)
            fin, opcode, n = head[0] & 0x80, head[0] & 0x0f, head[1] & 0x7f
            if n == 126:
                n = struct.unpack(">H", self.io.read(2))[0]
            elif n == 127:
                n = struct.unpack(">Q", self.io.read(8))[0]
            buf += self.io.read(n)
            if opcode == 0x8:
                sys.exit("Browser closed the DevTools connection")
            if fin:
                return json.loads(buf)

    def call(self, method, **params):
        self.msg_id += 1
        self._send(json.dumps({"id": self.msg_id, "method": method, "params": params}))
        while (msg := self._recv()).get("id") != self.msg_id:  # skip events
            pass
        if "error" in msg:
            sys.exit(f"{method}: {msg['error']['message']}")
        return msg["result"]

    def js(self, expr):
        r = self.call("Runtime.evaluate", expression=expr, awaitPromise=True, returnByValue=True)
        if "exceptionDetails" in r:
            sys.exit("JS: " + r["exceptionDetails"]["exception"].get("description", expr))
        return r["result"].get("value")

    def goto(self, url):
        self.call("Page.navigate", url=url)
        for _ in range(60):
            time.sleep(1)
            if self.js("document.readyState") == "complete" and self.js("location.href") == url:
                return
        sys.exit(f"Timed out loading {url}")


def download_mod(mod, port, to=None, version=None):
    """Fetch the latest main file, or the given version, return (dir, mod_id, saved name)."""
    data_dir = to or ENV_DICT["DATA_DIR"].replace("\\", "")
    mod_id = split_url(mod)[1]  # site id, not the v3 one
    game_id = api1(f"/games/{GAME}.json")["id"]
    files = api1(f"/games/{GAME}/mods/{mod_id}/files.json")["files"]
    if version:  # an old version, to diff a repack against
        known = sorted({f["version"] for f in files}, key=ver)
        files = [f for f in files if f["version"] == version]
        if not files:
            sys.exit(f"Mod {mod_id} has no version {version}, only: {', '.join(known)}")
    else:
        files = [f for f in files if f["category_name"] == "MAIN"]
    if not files:
        sys.exit(f"Mod {mod_id} has no main file")
    file = max(files, key=lambda f: f["uploaded_timestamp"])
    print(f"File: {file['name']} {file['version']} (id {file['file_id']})")

    browser = Browser(port)
    if "nexusmods.com" not in (browser.js("location.host") or ""):
        browser.goto(f"https://www.nexusmods.com/{GAME}/mods/{mod_id}")
    # the site hands free users a signed CDN link only from a logged-in page
    url = browser.js("""fetch("/Core/Libs/Common/Managers/Downloads?GenerateDownloadUrl",
        {method: "POST", credentials: "include",
         headers: {"Content-Type": "application/x-www-form-urlencoded",
                   "X-Requested-With": "XMLHttpRequest"},
         body: "fid=%s&game_id=%s"}).then(r => r.json()).then(d => d.url)""" % (
        file["file_id"], game_id))
    if not url:
        sys.exit("Site returned no download url — logged out, or the endpoint changed")

    name = file["file_name"]  # the CDN path is a bare uuid on some mirrors
    path = os.path.join(data_dir, name)
    print(f"Downloading {name}...")
    r = requests.get(url, stream=True)
    r.raise_for_status()
    with open(path, "wb") as f:
        for chunk in r.iter_content(1 << 16):
            f.write(chunk)
    print(f"Saved to {path}")
    return data_dir, mod_id, name


def cmd_download(args):
    download_mod(args.mod, args.port, args.to, args.version)


def cmd_update(args):
    data_dir, mod_id, name = download_mod(args.mod, args.port)
    old_dir = os.path.join(data_dir, "_old")  # the game only loads zips at the top level
    for old in sorted(os.listdir(data_dir)):
        parsed = parse_zip_name(old)
        prefix = max((p for p in NEXUS_IDS if old.startswith(p)), key=len, default=None)
        if old != name and old.endswith(".zip") \
                and ((parsed and parsed[1] == mod_id) or NEXUS_IDS.get(prefix) == mod_id):
            os.makedirs(old_dir, exist_ok=True)
            os.replace(os.path.join(data_dir, old), os.path.join(old_dir, old))
            print(f"Moved {old} to {old_dir}")


parser = argparse.ArgumentParser()
sub = parser.add_subparsers(dest="cmd", required=True)

p = sub.add_parser("upload", help="upload latest release zip as a new version")
p.add_argument("url", nargs="?", help="mod page url or id")
p.add_argument("-d", "--description", default=None)
p.add_argument("-c", "--changelog", default=None, help="changelog text or file")
p.set_defaults(func=cmd_upload)

p = sub.add_parser("info", help="show mod info")
p.add_argument("url", nargs="?", help="mod page url or id")
p.set_defaults(func=cmd_info)

p = sub.add_parser("files", help="list mod files")
p.add_argument("url", nargs="?", help="mod page url or id")
p.set_defaults(func=cmd_files)

p = sub.add_parser("versions", help="list file versions")
p.add_argument("url", nargs="?", help="mod page url or id")
p.set_defaults(func=cmd_versions)

p = sub.add_parser("check-updates", help="check installed mods in DATA_DIR for updates")
p.add_argument("--local", action="store_true", help="only local checks, skip NexusMods")
p.set_defaults(func=cmd_check_updates)

for cmd, func, what in [("download", cmd_download, "download latest main file into DATA_DIR"),
                        ("update", cmd_update, "download it and drop the version it replaces")]:
    p = sub.add_parser(cmd, help=f"{what}, via a logged-in browser")
    p.add_argument("mod", help="mod page url or id — own mods are built locally, not downloaded")
    p.add_argument("--port", type=int, default=CDP_PORT, help="DevTools port of the running browser")
    if cmd == "download":
        p.add_argument("--to", help="save here instead of DATA_DIR")
        p.add_argument("--version", help="grab this version instead of the latest main")
    p.set_defaults(func=func)

p = sub.add_parser("add-changelog", help="add a changelog entry")
p.add_argument("version")
p.add_argument("text", help="changelog text or file")
p.add_argument("url", nargs="?", help="mod page url or id")
p.set_defaults(func=cmd_changelog)

args = parser.parse_args()
args.func(args)
