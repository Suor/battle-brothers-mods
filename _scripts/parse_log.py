#!/usr/bin/env python3
"""Print Battle Brothers log.html as plain text lines, one per row.

Output:  HH:MM:SS [level] TAG | text

Default filters drop noisy stuff (rosetta strings, engine resource/texture
chatter, ConsoleAPI). Use --all to disable.

Usage:
    ./parse_log.py                       # all interesting rows, oldest-first
    ./parse_log.py | grep dbg:           # filter via pipe
    ./parse_log.py --level error,warning
    ./parse_log.py --tail 200
    ./parse_log.py --all                 # do not apply default noise filter
    ./parse_log.py /path/to/log.html
"""
import argparse
import os
import re
import sys
from html.parser import HTMLParser

DEFAULT_LOG = (
    "/home/suor/.local/share/Steam/steamapps/compatdata/365360/pfx/"
    "drive_c/users/steamuser/Documents/Battle Brothers/log.html"
)

# Substrings that mark a row as noise. Match against `TAG | text`.
NOISE = [
    r"^\w+ \| rosetta:",                  # rosetta translation traffic
    r"^Resource \|",                      # engine resource loading
    r"^Texture \|",
    r"^IO \| .*not found",                # missing optional files
    r"^TacticalScene \|",
    r"ConsoleAPI",
    r"Skipping this image keyword",
    r"resuming dead generator",
]


class _Strip(HTMLParser):
    def __init__(self):
        super().__init__()
        self.out = []

    def handle_data(self, d):
        self.out.append(d)


def strip_tags(html):
    p = _Strip()
    p.feed(html)
    # Collapse to one line so grep stays useful.
    return " ".join(t.strip() for t in "".join(p.out).splitlines() if t.strip())


def field(row, cls):
    m = re.search(rf'<div class="{cls}">(.*?)</div>', row, re.S)
    return strip_tags(m.group(1)) if m else ""


def iter_rows(data):
    for chunk in re.split(r'<div class="row ', data)[1:]:
        m = re.match(r'([a-z]+)">', chunk)
        if not m:
            continue
        level = m.group(1)
        body = chunk[m.end():]
        time = field(body, "time")
        tag = field(body, "tag")
        text = field(body, "text")
        if not text:
            continue
        yield level, time, tag, text


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("path", nargs="?", default=os.environ.get("LOG_FILE", DEFAULT_LOG))
    ap.add_argument("--all", action="store_true",
                    help="disable the default noise filter")
    ap.add_argument("--level",
                    help="comma-separated levels to keep (info,debug,warning,error)")
    ap.add_argument("--tag",
                    help="comma-separated tags to keep (SQ,UI,Core,...)")
    ap.add_argument("--tail", type=int,
                    help="print only the last N matching rows")
    args = ap.parse_args()

    levels = set(args.level.split(",")) if args.level else None
    tags = set(args.tag.split(",")) if args.tag else None
    noise = None if args.all else [re.compile(p) for p in NOISE]

    try:
        with open(args.path, encoding="utf-8", errors="replace") as f:
            data = f.read()
    except FileNotFoundError:
        sys.exit(f"log not found: {args.path}")

    out = []
    for level, time, tag, text in iter_rows(data):
        if levels and level not in levels:
            continue
        if tags and tag not in tags:
            continue
        line = f"{time} [{level}] {tag} | {text}"
        if noise and any(p.search(line) for p in noise):
            continue
        out.append(line)

    if args.tail:
        out = out[-args.tail:]

    print("\n".join(out))


if __name__ == "__main__":
    main()
