#!/usr/bin/env python3
"""Discord CLI, posts as the user logged into Discord in the CDP browser, its token never leaves the page.
Run from a mod directory: threads default to DISCORD = <thread id>... in its Makefile, the Nexus link to its URL.

Usage: discord.py announce [-n] VERSION [THREAD...]   post VERSION's CHANGELOG entry, -n only prints it
       discord.py post THREAD TEXT_OR_FILE [--file FILE]...
       discord.py thread FORUM NAME TEXT_OR_FILE [--tag TAG_ID]... [--file FILE]...
       discord.py edit THREAD MESSAGE_ID TEXT_OR_FILE [--file FILE]...
       discord.py last THREAD [N]                       show the last N messages
"""
import argparse, base64, json, os, re, sys, time
import requests
from websockets.sync.client import connect

CDP_PORT = 9222

# The page's own auth header is caught as it sends it, requests are then made from the page
HOOK = """(() => {
  if (window.__auth) return true;
  if (!window.__authHook) {
    window.__authHook = true;
    const set = XMLHttpRequest.prototype.setRequestHeader;
    XMLHttpRequest.prototype.setRequestHeader = function (k, v) {
      if (k.toLowerCase() === "authorization") window.__auth = v;
      return set.apply(this, arguments);
    };
  }
  return false;
})()"""
FETCH = """fetch("/api/v9" + %s, {method: %s, body: %s,
  headers: {authorization: window.__auth, "content-type": "application/json"}})
  .then(async r => [r.status, await r.json().catch(() => null)])"""
# With files, the JSON goes as payload_json of a multipart body, files as files[i] referenced by attachments
FETCH_FILES = """(() => {
  const form = new FormData(), files = %s;
  form.append("payload_json", %s);
  files.forEach(([name, b64], i) =>
    form.append(`files[${i}]`, new Blob([Uint8Array.from(atob(b64), c => c.charCodeAt(0))]), name));
  return fetch("/api/v9" + %s, {method: %s, body: form, headers: {authorization: window.__auth}})
    .then(async r => [r.status, await r.json().catch(() => null)]);
})()"""


class Discord:
    def __init__(self, port=CDP_PORT):
        tabs = lambda: requests.get(f"http://127.0.0.1:{port}/json/list", timeout=5).json()
        if not any("discord.com" in t["url"] for t in tabs()):
            # a background tab keeps focus on the user's desktop, /json/new would take it
            browser = requests.get(f"http://127.0.0.1:{port}/json/version", timeout=5).json()["webSocketDebuggerUrl"]
            with connect(browser, open_timeout=10) as ws:
                ws.send(json.dumps({"id": 1, "method": "Target.createTarget",
                                    "params": {"url": "https://discord.com/channels/@me", "background": True}}))
                ws.recv(timeout=10)
            time.sleep(10)
        tab = next(t for t in tabs() if t["type"] == "page" and "discord.com" in t["url"])
        self.ws = connect(tab["webSocketDebuggerUrl"], max_size=None, open_timeout=10)
        self.msg_id = 0
        for _ in range(30):
            if self.js(HOOK):  # the page sends some authed request every few seconds
                return
            time.sleep(2)
        sys.exit("The Discord page sent no authed request — logged out, or Discord changed")

    def js(self, expr):
        self.msg_id += 1
        self.ws.send(json.dumps({"id": self.msg_id, "method": "Runtime.evaluate", "params": {
            "expression": expr, "awaitPromise": True, "returnByValue": True}}))
        while (msg := json.loads(self.ws.recv(timeout=60))).get("id") != self.msg_id:  # skip events
            pass
        r = msg["result"]
        if "exceptionDetails" in r:
            sys.exit("JS: " + r["exceptionDetails"]["exception"].get("description", expr))
        return r["result"].get("value")

    def api(self, method, path, body=None, files=()):
        if files:
            msg = body.get("message", body)  # a new forum thread carries its message inside
            msg["attachments"] = [{"id": i, "filename": os.path.basename(f)} for i, f in enumerate(files)]
            data = [[os.path.basename(f), base64.b64encode(open(f, "rb").read()).decode()] for f in files]
            expr = FETCH_FILES % (json.dumps(data), json.dumps(json.dumps(body)), json.dumps(path), json.dumps(method))
        else:
            expr = FETCH % (json.dumps(path), json.dumps(method), json.dumps(json.dumps(body) if body else None))
        status, data = self.js(expr)
        if status >= 300:
            sys.exit(f"{method} {path}: {status} {data}")
        return data


def makefile_var(name):
    try:
        return re.search(rf"^{name}\s*=\s*(.+)$", open("Makefile").read(), re.M).group(1).split()
    except (OSError, AttributeError):
        return []


def read_text(text):
    return open(text).read().strip() if os.path.isfile(text) else text


def changelog_entry(version, path="CHANGELOG"):
    lines = open(path).read().split("\n")
    start = lines.index(version) + 1
    return "\n".join(lines[start:lines.index("", start)])


def announcement(version):
    url = makefile_var("URL")
    where = f" on [NexusMods](<{url[0]}>)" if url else ""
    return f"**Released {version}**{where}:\n{changelog_entry(version)}"


def post(d, thread, text, files=()):
    m = d.api("POST", f"/channels/{thread}/messages", {"content": text, "flags": 4}, files)  # no embeds
    print(f"Posted {thread}/{m['id']}")


def cmd_announce(args):
    threads = args.threads or makefile_var("DISCORD")
    if not threads and not args.dry_run:
        sys.exit("No threads given and no DISCORD in ./Makefile")
    text = announcement(args.version)
    print(text)
    if args.dry_run:
        return
    d = Discord()
    for thread in threads:
        post(d, thread, text)


def cmd_post(args):
    post(Discord(), args.thread, read_text(args.text), args.file)


def cmd_thread(args):
    t = Discord().api("POST", f"/channels/{args.forum}/threads", {
        "name": args.name, "applied_tags": args.tag,
        "message": {"content": read_text(args.text), "flags": 4}}, args.file)
    print(f"Created thread {t['id']}")


def cmd_edit(args):
    Discord().api("PATCH", f"/channels/{args.thread}/messages/{args.message}",
                  {"content": read_text(args.text)}, args.file)
    print("Edited.")


def cmd_last(args):
    for m in reversed(Discord().api("GET", f"/channels/{args.thread}/messages?limit={args.n}")):
        print(f"--- {m['id']} {m['timestamp'][:16]} {m['author']['username']}\n{m['content']}")


parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
sub = parser.add_subparsers(required=True)

p = sub.add_parser("announce", help="post a version's CHANGELOG entry to the mod's threads")
p.add_argument("-n", "--dry-run", action="store_true")
p.add_argument("version")
p.add_argument("threads", nargs="*")
p.set_defaults(func=cmd_announce)

p = sub.add_parser("post", help="post a message to a thread or channel")
p.add_argument("thread")
p.add_argument("text", help="text or file")
p.add_argument("--file", action="append", default=[], help="attach a file, repeatable")
p.set_defaults(func=cmd_post)

p = sub.add_parser("thread", help="start a thread in a forum channel")
p.add_argument("forum")
p.add_argument("name")
p.add_argument("text", help="text or file")
p.add_argument("--tag", action="append", default=[], help="forum tag id, repeatable")
p.add_argument("--file", action="append", default=[], help="attach a file, repeatable")
p.set_defaults(func=cmd_thread)

p = sub.add_parser("edit", help="replace the text of an own message")
p.add_argument("thread")
p.add_argument("message")
p.add_argument("text", help="text or file")
p.add_argument("--file", action="append", default=[], help="attach a file, replaces old attachments")
p.set_defaults(func=cmd_edit)

p = sub.add_parser("last", help="show the last messages of a thread")
p.add_argument("thread")
p.add_argument("n", nargs="?", type=int, default=3)
p.set_defaults(func=cmd_last)

if __name__ == "__main__":
    args = parser.parse_args()
    args.func(args)
