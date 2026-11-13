"""Read-only Discord search for reports about hackflow's mods; raw results to discord_logs/_search/."""
import json, sys, os
sys.path.insert(0, "/home/suor/projects/bbm/service/prep")
from discord_api import Discord

GUILDS = {"legends": "547043336465154049", "reforged": "1006908336991645757", "bbmodding": "965324395851694140"}
OUT = os.path.expanduser("~/projects/bbm/mods/_scripts/bbtest/discord_logs/_search")


def search(d, guild, params, max_pages=40):
    """All messages for a search, as (total, [msg])."""
    msgs, offset, total = [], 0, 0
    while offset < max_pages * 25:
        status, body = d.get(f"/guilds/{GUILDS[guild]}/messages/search", {**params, "offset": offset})
        if status != 200:
            print("ERR", guild, params, status, body, file=sys.stderr)
            break
        total = body["total_results"]
        page = [m[0] for m in body["messages"]]
        msgs += page
        offset += 25
        if not page or offset >= total:
            break
    return total, msgs


if __name__ == "__main__":
    # args: name json_params [max_pages] [guilds,]
    name, params = sys.argv[1], json.loads(sys.argv[2])
    max_pages = int(sys.argv[3]) if len(sys.argv) > 3 else 40
    guilds = sys.argv[4].split(",") if len(sys.argv) > 4 else list(GUILDS)
    d = Discord()
    for g in guilds:
        path = f"{OUT}/{g}__{name}.json"
        if os.path.exists(path):
            continue
        total, msgs = search(d, g, params, max_pages)
        json.dump({"params": params, "total": total, "messages": msgs}, open(path, "w"))
        print(g, name, total, len(msgs), flush=True)
