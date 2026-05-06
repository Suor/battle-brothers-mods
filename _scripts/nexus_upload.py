#!/usr/bin/env python3
"""Upload latest mod zip to NexusMods. Run from mod directory.
Usage: nexus_upload.py [-d DESCRIPTION] <nexus_url>
"""
import argparse, os, re, sys, time, requests
from urllib.parse import urlparse

API_KEY = "YAh5Y/uQPQfzv+n99IxQ9ZOeMyx4epd0gFcVldW4MJtUNw==--vXfYT03Nv8P9q/Vt--dDQXuQWt1QA05VwDamHSDg=="
BASE = "https://api.nexusmods.com/v3"
HEADERS = {"apikey": API_KEY, "Content-Type": "application/json"}


def api(method, path, **kw):
    r = requests.request(method, BASE + path, headers=HEADERS, **kw)
    r.raise_for_status()
    return r.json()


def ver(s):
    m = re.search(r"(\d+(?:\.\d+)+)", s)
    return tuple(int(x) for x in m.group(1).split(".")) if m else (0,)


parser = argparse.ArgumentParser()
parser.add_argument("url")
parser.add_argument("-d", "--description", default=None)
args = parser.parse_args()

# Parse URL: https://www.nexusmods.com/battlebrothers/mods/855
parts = urlparse(args.url).path.strip("/").split("/")
game_domain, game_scoped_id = parts[0], parts[2]

# Find latest release zip (no _MODIFIED suffix)
zips = [f for f in os.listdir(".") if f.endswith(".zip") and "_MODIFIED" not in f
        and re.search(r"\d+\.\d+", f)]
if not zips:
    sys.exit("No release zip found")
zipfile = max(zips, key=ver)
version = ".".join(str(x) for x in ver(zipfile))
name = zipfile.removesuffix(".zip")
print(f"Found: {zipfile}  (version {version})")

# Look up mod and existing file groups
mod_id = api("GET", f"/games/{game_domain}/mods/{game_scoped_id}")["data"]["id"]
groups = api("GET", f"/mods/{mod_id}/file-update-groups")["data"]["groups"]

if groups:
    group_id = groups[0]["id"]
    versions = api("GET", f"/file-update-groups/{group_id}/versions")["data"]["versions"]
    if version in [v["file"]["version"] for v in versions]:
        sys.exit(f"Version {version} is already on NexusMods, skipping")

description = args.description or input("File description: ").strip()

# Upload
size = os.path.getsize(zipfile)
print(f"Uploading ({size} bytes)...")
r = requests.post(f"{BASE}/uploads", headers=HEADERS, json={"filename": zipfile, "size_bytes": size})
r.raise_for_status()
upload_id = r.json()["data"]["id"]
presigned_url = r.json()["data"]["presigned_url"]

with open(zipfile, "rb") as f:
    requests.put(presigned_url, data=f, headers={"Content-Type": "application/octet-stream"}).raise_for_status()

print("Finalising...")
requests.post(f"{BASE}/uploads/{upload_id}/finalise", headers=HEADERS).raise_for_status()

for _ in range(30):
    time.sleep(2)
    if api("GET", f"/uploads/{upload_id}")["data"]["state"] == "available":
        break
else:
    sys.exit("Timed out waiting for upload to become available")

body = {"upload_id": upload_id, "name": name, "version": version,
        "file_category": "main", "description": description}

if groups:
    r = requests.post(f"{BASE}/mod-file-update-groups/{group_id}/versions", headers=HEADERS, json=body)
else:
    body["mod_id"] = mod_id
    r = requests.post(f"{BASE}/mod-files", headers=HEADERS, json=body)
r.raise_for_status()

print(f"Done! game_scoped_id={r.json()['data']['game_scoped_id']}")
