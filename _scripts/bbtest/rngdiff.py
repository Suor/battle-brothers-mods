#!/usr/bin/env python3
"""Where two runs of the same tests part: the first draw that differs, with both call sites.

    ./rngdiff.py RUN_A RUN_B [-k NAME] [-C 5]

A run is a launch dir (`work/runs/<stamp>/<n>/`, its events.log) or a run dir (its launches' logs read together).
Without --draws in both runs only the BBTEST_RNG rows (count, hash, marks per battle and t.days) are compared.
"""
import argparse, html, re
from pathlib import Path

ENTRY = re.compile(r"^(\d+) (seed \S+|\S+) ?(.*)$")


def load(path: Path):
    """{test: {"rng": [rows], "draws": [(n, what, site)]}} from the events.log files under path."""
    logs = [path / "events.log"] if (path / "events.log").exists() else sorted(path.glob("*/events.log"))
    if not logs:
        raise SystemExit(f"rngdiff: no events.log in {path}")
    tests, cur = {}, None
    for log in logs:
        for line in log.read_text(errors="replace").splitlines():
            if not line.startswith("ROW "):
                continue
            text = html.unescape(line.split(" ", 3)[3]) if line.count(" ") >= 3 else ""
            if text.startswith("BBTEST_BEGIN "):
                cur = tests.setdefault(text[13:], {"rng": [], "draws": []})
            elif text.startswith("BBTEST_RNG ") and cur is not None:
                cur["rng"].append(text.split(" | ", 1)[1])
            elif text.startswith("BBTEST_DRAWS ") and cur is not None:
                for e in text[13:].split(" ; "):
                    if m := ENTRY.match(e):
                        cur["draws"].append((int(m[1]), m[2], m[3]))
    return tests


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("a", type=Path)
    ap.add_argument("b", type=Path)
    ap.add_argument("-k", dest="only", help="tests whose name contains this")
    ap.add_argument("-C", dest="context", type=int, default=5, help="draws shown before the first difference")
    args = ap.parse_args()
    a, b = load(args.a), load(args.b)
    same = True
    for name in [n for n in a if n in b and (not args.only or args.only in n)]:
        ta, tb = a[name], b[name]
        print(f"== {name}")
        for i in range(max(len(ta["rng"]), len(tb["rng"]))):
            ra = ta["rng"][i] if i < len(ta["rng"]) else "-"
            rb = tb["rng"][i] if i < len(tb["rng"]) else "-"
            print(f"   {'same' if ra == rb else 'DIFF'}  A {ra}" + ("" if ra == rb else f"\n         B {rb}"))
            same &= ra == rb
        da, db = ta["draws"], tb["draws"]
        if not da or not db:
            print("   (no draw log in " + " and ".join(x for x, d in (("A", da), ("B", db)) if not d) + ": run with --draws)")
            continue
        k = next((i for i, (x, y) in enumerate(zip(da, db)) if x[:2] != y[:2]), None)
        if k is None:
            print(f"   draws: the same {min(len(da), len(db))}" + ("" if len(da) == len(db) else
                  f", then only {'A' if len(da) > len(db) else 'B'} goes on ({len(da)} vs {len(db)})"))
            same &= len(da) == len(db)
            continue
        same = False
        print(f"   draws part at entry {k} (draw {da[k][0]} / {db[k][0]}):")
        for x in da[max(0, k - args.context):k]:
            print(f"      {x[0]:>6} {x[1]:<16} {x[2]}")
        for tag, d in (("A", da), ("B", db)):
            for x in d[k:k + 3]:
                print(f"    {tag} {x[0]:>6} {x[1]:<16} {x[2]}")
    raise SystemExit(0 if same else 1)


if __name__ == "__main__":
    main()
