"""Merge raw search results into candidate hits: message, guild, queries, mod guess, known-or-new."""
import json, glob, os, re, sys
from datetime import datetime, timezone

D = os.path.expanduser("~/projects/bbm/mods/_scripts/bbtest/discord_logs/_search")
GUILDS = {"legends": "547043336465154049", "reforged": "1006908336991645757", "bbmodding": "965324395851694140"}
HACKFLOW = "428871099040792587"
MODS = {
    "autopilot": r"auto[ -]?pilot", "nicknames": r"nicknames?(?! mod for)", "fun_facts": r"fun[ _]?facts",
    "camps_and_artifacts": r"camps?[ _]?(and|&)?[ _]?artifacts|\bC&A\b|\bCnA\b", "retinue_ups": r"retinue[ _](promotions?|ups)",
    "elite_few": r"elite[ _]few|master bros", "bro_studio": r"bro[ _]studio", "necro": r"proper[ _]necro|mod_necro",
    "druid": r"proper[ _]druid|mod_druid", "hackflows_perks": r"hackflow'?s?[ _]perks",
    "perma": r"permanent injuries|perma_hackflow", "immortal_warriors": r"immortal[ _]warriors",
    "standout_enemies": r"standout[ _]enemies", "useful": r"useful[ _]things|mod_useful",
    "background_perks": r"starting perks|background_perks|perks by background", "events_delayed_fix": r"delayed[ _]fix",
    "fixes": r"hackflow'?s? fixes|mod_fixes", "fix_reforged": r"reforged[ _]fix|fix_reforged",
    "heal_repair_fix": r"blacksmith fix|heal_repair_fix", "beast_loot": r"beast[ _]loot", "vap": r"veteran attrs|mod_vap",
    "more_blood": r"more[ _]blood", "random_perk": r"random[ _]perk", "renamer": r"bro[ _]renamer|mod_renamer",
    "translations": r"hackflows?_translations", "challenges": r"mod_challenges", "AC": r"accessory companions|mod_AC\b",
    "cheap_meat": r"cheap[ _]meat", "hackflow": r"hackflow",
}

known = set(open(f"{D}/known_ids.txt").read().split())
hits = {}
for path in sorted(glob.glob(f"{D}/*__*.json")):
    guild, q = os.path.basename(path)[:-5].split("__", 1)
    for m in json.load(open(path))["messages"]:
        h = hits.setdefault(m["id"], {"guild": guild, "m": m, "queries": set()})
        h["queries"].add(q)

out = []
for mid, h in hits.items():
    m = h["m"]
    text = m["content"] + " " + " ".join(a["filename"] for a in m.get("attachments", []))
    mods = [k for k, rx in MODS.items() if re.search(rx, text, re.I)]
    out.append({
        "id": mid, "guild": h["guild"], "channel": m["channel_id"], "date": m["timestamp"][:10],
        "author": m["author"]["username"], "is_hackflow": m["author"]["id"] == HACKFLOW,
        "queries": sorted(h["queries"]), "mods": mods, "known": mid in known,
        "files": [a["filename"] for a in m.get("attachments", [])],
        "url": f"https://discord.com/channels/{GUILDS[h['guild']]}/{m['channel_id']}/{mid}",
        "content": m["content"],
    })
out.sort(key=lambda r: r["id"])
with open(f"{D}/hits.jsonl", "w") as f:
    for r in out:
        f.write(json.dumps(r) + "\n")
print(len(out), "hits;", sum(r["known"] for r in out), "known")
