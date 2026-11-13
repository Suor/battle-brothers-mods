"""Print candidate hits for a mod, bug-ish ones only unless --all."""
import json, re, sys, os
D = os.path.expanduser("~/projects/bbm/mods/_scripts/bbtest/discord_logs/_search")
BUG = re.compile(r"error|crash|bug|freez|broke|issue|doesn'?t work|not work|stuck|hang|conflict|problem|incompat|fix|wrong|log\.html|stopp|fail|glitch|weird|strange|disappear|missing|corrupt", re.I)
mod = sys.argv[1]; allm = "--all" in sys.argv
FLOOR = {"nicknames": "2026-04-01", "druid": "2026-05-15", "AC": "2026-06-15", "challenges": "2026-04-10",
         "fixes": "2025-01-15", "necro": "2024-08-15", "immortal_warriors": "2024-08-01", "perma": "2025-06-01",
         "translations": "2026-04-01", "autopilot": "2023-09-15", "fun_facts": "2023-09-01"}.get(mod, "2021-01-01")
for l in open(f"{D}/hits.jsonl"):
    r = json.loads(l)
    if mod not in r["mods"] or r["known"] or r["date"] < FLOOR:
        continue
    if not allm and not (BUG.search(r["content"]) or r["files"]):
        continue
    print(f"--- {r['date']} {r['guild']} {r['url']} {r['author']}{' [HF]' if r['is_hackflow'] else ''} {r['files'] or ''}")
    print("   ", r["content"][:400].replace("\n", " / "))
