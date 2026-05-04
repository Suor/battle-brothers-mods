#!/usr/bin/env python3
"""Pretty-print errors from Battle Brothers log.html.

Usage:  bb_log_errors.py [LOG_PATH] [N]

Prints the first N error/critical entries (default 80), each followed by its
stack trace if any. The js/UI ConsoleAPI rows are skipped — they're noise.
"""
import re, sys
from html.parser import HTMLParser

path = sys.argv[1] if len(sys.argv) > 1 else \
    "/home/suor/.local/share/Steam/steamapps/compatdata/365360/pfx/drive_c/users/steamuser/Documents/Battle Brothers/log.html"

with open(path, encoding="utf-8", errors="replace") as f:
    data = f.read()


def strip_tags(html):
    parts = []
    class P(HTMLParser):
        def handle_data(self, d):
            parts.append(d)
    P().feed(html)
    return " ".join(t.strip() for t in parts if t.strip())


def field(row_html, cls):
    m = re.search(rf'<div class="{cls}">(.*?)</div>', row_html, re.S)
    return strip_tags(m.group(1)) if m else ""


def stacktrace(row_html):
    m = re.search(r'<div class="stacktrace-container">(.*)$', row_html, re.S)
    if not m:
        return []
    body = m.group(1)
    # Each frame is its own function-container; Variables come in separate
    # containers and only appear when the frame has any.
    lines = []
    for fm in re.finditer(
        r'<div class="(value|valueVar)">(.*?)</div>', body, re.S
    ):
        kind, raw = fm.group(1), strip_tags(fm.group(2))
        if not raw:
            continue
        lines.append(f"    at {raw}" if kind == "value" else f"       {raw}")
    return lines


rows = re.split(r'<div class="row ', data)
out = []
for r in rows:
    m = re.match(r'(error|critical)">', r)
    if not m:
        continue
    kind = m.group(1)
    entry = r.split('<div class="stacktrace-container">', 1)[0]
    txt = field(entry, "text")
    if not txt or "resuming dead generator" in txt:
        continue
    if "gfx/necro/" in txt and "Skipping this image keyword" in txt:
        continue
    if "gfx/fonts/" in txt:
        continue
    tag = field(entry, "tag")
    # JS errors are downstream noise from earlier squirrel failures.
    if tag == "UI" and "ConsoleAPI" in txt:
        continue
    time = field(entry, "time")
    block = [f"[{kind}] {time} {tag}: {txt}"]
    block.extend(stacktrace(r))
    out.append("\n".join(block))

N = int(sys.argv[2]) if len(sys.argv) > 2 else 80
for entry in out[:N]:
    print(entry)
    print()
