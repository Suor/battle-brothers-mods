"""Download log attachments of Discord messages: discord_deep_dl.py URL... → discord_logs/<guild>_<msgid>_<file>."""
import os, sys, requests
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from discord_deep_ctx import ctx
OUT = os.path.expanduser("~/projects/bbm/mods/_scripts/bbtest/discord_logs")
GUILDS = {"547043336465154049": "legends", "1006908336991645757": "reforged", "965324395851694140": "bbmodding"}
EXT = (".html", ".txt", ".log", ".zip")

for url in sys.argv[1:]:
    _, g, ch, mid = url.rstrip("/").rsplit("/", 3)
    m = next((m for m in ctx(ch, mid, 5) if m["id"] == mid), None)
    for a in (m or {}).get("attachments", []):
        if not a["filename"].lower().endswith(EXT) or a["size"] > 30e6:
            continue
        path = f"{OUT}/{GUILDS[g]}_{mid}_{a['filename']}"
        if not os.path.exists(path):
            r = requests.get(a["url"], timeout=120)
            if r.status_code != 200:
                print("FAIL", r.status_code, url, a["filename"]); continue
            open(path, "wb").write(r.content)
        print(path)
