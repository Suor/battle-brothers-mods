"""Print context around Discord messages (cached): discord_deep_ctx.py URL [before after]."""
import json, os, sys
sys.path.insert(0, "/home/suor/projects/bbm/service/prep")
D = os.path.expanduser("~/projects/bbm/mods/_scripts/bbtest/discord_logs/_ctx")
_d = None


def ctx(ch, mid, limit=30):
    global _d
    path = f"{D}/{ch}_{mid}_{limit}.json"
    if not os.path.exists(path):
        if _d is None:
            from discord_api import Discord
            _d = Discord()
        st, body = _d.get(f"/channels/{ch}/messages", {"around": mid, "limit": limit})
        if st != 200:
            return [{"id": "0", "timestamp": "", "author": {"username": "ERR"}, "content": f"{st} {body}", "attachments": []}]
        json.dump(body, open(path, "w"))
    return sorted(json.load(open(path)), key=lambda m: int(m["id"]))


if __name__ == "__main__":
    lim = int(sys.argv[-1]) if sys.argv[-1].isdigit() else 30
    for url in [a for a in sys.argv[1:] if "/" in a]:
        _, ch, mid = url.rstrip("/").rsplit("/", 2)
        print(f"===== {url}")
        for m in ctx(ch, mid, lim):
            mark = ">>" if m["id"] == mid else "  "
            files = " ".join(f"[{a['filename']}]" for a in m.get("attachments", []))
            ref = f" (re {m['message_reference']['message_id']})" if m.get("message_reference") else ""
            print(f"{mark}{m['timestamp'][:16]} {m['id']} {m['author']['username']}{ref}: {m['content'][:600]} {files}".replace("\n", " / "))
