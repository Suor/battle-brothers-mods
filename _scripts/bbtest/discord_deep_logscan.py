"""Download newest Discord log.html attachments (not yet collected), keep only those whose errors have frames in hackflow mods."""
import json, os, re, sys, html, requests
from concurrent.futures import ThreadPoolExecutor
B = os.path.expanduser("~/projects/bbm/mods/_scripts/bbtest/discord_logs")
D = f"{B}/_search"
LIMITS = {"legends": 120, "reforged": 120, "bbmodding": 60}
MODFILES = json.load(open(f"{D}/modfiles.json"))
SVC = os.path.expanduser("~/projects/bbm/service/data/logs")
have = set()
for s in os.listdir(SVC):
    if os.path.isdir(f"{SVC}/{s}"): have |= set(os.listdir(f"{SVC}/{s}"))
have |= {f.split("_")[1] for f in os.listdir(B) if f.count("_") >= 2}

todo = []
for g, lim in LIMITS.items():
    rows = []
    for m in json.load(open(f"{D}/{g}__logs_html.json"))["messages"]:
        atts = [a for a in m["attachments"] if "log" in a["filename"].lower() and a["filename"].lower().endswith(".html")]
        if m["id"] in have or not atts: continue
        rows.append((m["id"], g, m["channel_id"], atts))
    rows.sort(key=lambda r: -int(r[0]))
    todo += rows[:lim]

ERR = re.compile(r'<div class="row (?:error|critical)">(.*?)(?=<div class="row |\Z)', re.S)
FRAME = re.compile(r'-&gt;\s*([^<>]*?\.nut)\s*:\s*(\d+)|->\s*([^<>]*?\.nut)\s*:\s*(\d+)')


def scan(text):
    """[(mods, first error line, frame)] for errors with a frame in a hackflow mod file."""
    out = []
    for e in ERR.finditer(text):
        body = e.group(1)
        frames = [(a or c, b or d) for a, b, c, d in FRAME.findall(body)]
        hits = [(MODFILES[p.strip()], p.strip(), ln) for p, ln in frames if p.strip() in MODFILES]
        if hits:
            msg = html.unescape(re.sub(r"<[^>]+>", " ", re.search(r'class="text">(.*?)</div>', body, re.S).group(1) if 'class="text"' in body else body[:200]))
            out.append((sorted({m for h in hits for m in h[0]}), " ".join(msg.split())[:200], f"{hits[0][1]} : {hits[0][2]}"))
    return out


def job(r):
    mid, g, ch, atts = r
    res = []
    for a in atts:
        try:
            resp = requests.get(a["url"], timeout=120)
        except Exception as ex:
            return (r, a["filename"], "ERR " + str(ex), [])
        if resp.status_code != 200:
            return (r, a["filename"], f"HTTP {resp.status_code}", [])
        text = resp.content.decode("utf-8", "replace")
        hits = scan(text)
        if hits:
            open(f"{B}/{g}_{mid}_{a['filename']}", "w").write(text)
        res.append((r, a["filename"], "ok", hits))
    return res[0] if len(res) == 1 else (res[0] if res else (r, "", "none", []))


with ThreadPoolExecutor(8) as ex, open(f"{D}/logscan.jsonl", "w") as out:
    for (mid, g, ch, _), fn, st, hits in ex.map(job, todo):
        out.write(json.dumps({"id": mid, "guild": g, "channel": ch, "file": fn, "status": st, "hits": hits}) + "\n")
        if hits or st != "ok": print(g, mid, fn, st, hits[:2], flush=True)
print("scanned", len(todo))
