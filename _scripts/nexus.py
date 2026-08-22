#!/usr/bin/env python3
"""NexusMods CLI. Run from mod directory, mod URL defaults to URL from its Makefile.

Usage: nexus.py upload [-d DESCRIPTION] [-c CHANGELOG_TEXT_OR_FILE] [url]
       nexus.py versions [url]
       nexus.py add-changelog VERSION TEXT_OR_FILE [url]
"""
import argparse, os, re, sys, time, requests
from urllib.parse import urlparse

ENV_FILE = os.path.join(os.path.dirname(__file__), "..", ".env")
ENV_DICT = dict(l.strip().split("=", 1) for l in open(ENV_FILE) if "=" in l)
API_KEY = os.environ.get("NEXUSMODS_KEY") or ENV_DICT.get("NEXUSMODS_KEY") \
    or sys.exit("NEXUSMODS_KEY not found in environment or %s" % ENV_FILE)

BASE = "https://api.nexusmods.com/v3"
HEADERS = {"apikey": API_KEY, "Content-Type": "application/json"}


def api(method, path, **kw):
    r = requests.request(method, BASE + path, headers=HEADERS, **kw)
    r.raise_for_status()
    return r.json()


def ver(s):
    m = re.search(r"(\d+(?:\.\d+)+)", s)
    return tuple(int(x) for x in m.group(1).split(".")) if m else (0,)


def get_mod(url):
    if not url:
        try:
            url = re.search(r"^URL\s*=\s*(\S+)", open("Makefile").read(), re.M).group(1)
        except (OSError, AttributeError):
            sys.exit("No url given and no URL in ./Makefile")
    # https://www.nexusmods.com/battlebrothers/mods/855
    parts = urlparse(url).path.strip("/").split("/")
    return api("GET", f"/games/{parts[0]}/mods/{parts[2]}")["data"]


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


parser = argparse.ArgumentParser()
sub = parser.add_subparsers(dest="cmd", required=True)

p = sub.add_parser("upload", help="upload latest release zip as a new version")
p.add_argument("url", nargs="?")
p.add_argument("-d", "--description", default=None)
p.add_argument("-c", "--changelog", default=None, help="changelog text or file")
p.set_defaults(func=cmd_upload)

p = sub.add_parser("info", help="show mod info")
p.add_argument("url", nargs="?")
p.set_defaults(func=cmd_info)

p = sub.add_parser("files", help="list mod files")
p.add_argument("url", nargs="?")
p.set_defaults(func=cmd_files)

p = sub.add_parser("versions", help="list file versions")
p.add_argument("url", nargs="?")
p.set_defaults(func=cmd_versions)

p = sub.add_parser("add-changelog", help="add a changelog entry")
p.add_argument("version")
p.add_argument("text", help="changelog text or file")
p.add_argument("url", nargs="?")
p.set_defaults(func=cmd_changelog)

args = parser.parse_args()
args.func(args)
