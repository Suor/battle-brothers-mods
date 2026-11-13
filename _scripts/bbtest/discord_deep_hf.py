"""List bug-ish hackflow-authored messages and mentions of him, not already known: discord_deep_hf.py [author|mentions]."""
import json, re, sys, os
D = os.path.expanduser("~/projects/bbm/mods/_scripts/bbtest/discord_logs/_search")
BUG = re.compile(r"\bbug|fixed|will fix|\bfix\b|crash|error|broke|freez|hang|thanks for (the )?report", re.I)
kind = sys.argv[1]
for l in open(f"{D}/hits.jsonl"):
    r = json.loads(l)
    q = set(r["queries"])
    if r["known"] or not BUG.search(r["content"]):
        continue
    if kind == "author" and "author_hackflow" not in q or kind == "mentions" and ("mentions_hackflow" not in q or r["is_hackflow"]):
        continue
    print(f"--- {r['date']} {r['url']} {r['author']} {r['files'] or ''} mods={r['mods']}")
    print("   ", r["content"][:300].replace("\n", " / "))
