#!/usr/bin/env python3
"""Summarize bench/matrix.sh's JSON lines: matrix_table.py [bench.jsonl] [logs dir].
Per label: n, wall/CPU median (min), peak RSS/PSS of the tree median (max), load average at the starts (range), and
for suites the tests run (pass + fail) and skips from the run's statuses.json (one run's; they're the same run to
run unless the log says otherwise)."""
import json, re, statistics, sys
from collections import defaultdict
from pathlib import Path

src = Path(sys.argv[1] if len(sys.argv) > 1 else "work/matrix/bench.jsonl")
logs = Path(sys.argv[2] if len(sys.argv) > 2 else src.parent / "logs")
runs = defaultdict(list)
for line in src.read_text().splitlines():
    r = json.loads(line)
    runs[r["label"]].append(r)


def counts(label):
    """[(round, pass, fail, skip, other)] from each run's statuses.json, or mock output."""
    out = []
    for log in sorted(logs.glob(label.replace(" ", "_") + ".[0-9].log")):
        text = log.read_text(errors="replace")
        sj = log.with_suffix(".statuses.json")
        if sj.exists():
            st = json.loads(sj.read_text())
            c = defaultdict(int)
            for env in st.values():
                for v in env.values():
                    c[(v if isinstance(v, str) else v.get("status", "?")).upper()] += 1
            out.append((log.stem.rsplit('.', 1)[1], c["PASS"], c["FAIL"] + c["ERROR"] + c["TIMEOUT"] + c["CRASH"], c["SKIP"],
                        {k: v for k, v in c.items() if k not in ("PASS", "FAIL", "SKIP", "ERROR", "TIMEOUT", "CRASH")}))
        elif label.startswith("mocks"):
            p = len(re.findall(r"^PASS |\bOK$", text, re.M))
            f = len(re.findall(r"^FAIL ", text, re.M))
            out.append((log.stem.rsplit('.', 1)[1], p, f, 0, {}))
    return out


def med(xs):
    return statistics.median(xs)


print("| label | n | rc | wall s med (min) | CPU s med (min) | peak RSS MB med (max) | peak PSS MB med (max) | biggest proc MB | load at start | tests p/f/skip |")
print("|" + " --- |" * 10)
for label, rs in runs.items():
    w = [r["wall"] for r in rs]
    c = [r["cpu"] for r in rs]
    rss = [r["peak_total_rss_mb"] or r["peak_maxrss_children_mb"] for r in rs]
    pss = [r["peak_total_pss_mb"] for r in rs]
    big = max(r["peak_proc_rss_mb"] or r["peak_maxrss_children_mb"] for r in rs)
    ld = [r["load_start"] for r in rs]
    cn = counts(label)
    cs = sorted({(p, f, s) for _, p, f, s, _ in cn})
    print(f"| {label} | {len(rs)} | {sorted({r['rc'] for r in rs})} | {med(w):.2f} ({min(w):.2f}) | {med(c):.2f} ({min(c):.2f}) | "
          f"{med(rss):.0f} ({max(rss):.0f}) | {med(pss):.0f} ({max(pss):.0f}) | {big} | {min(ld):.1f}–{max(ld):.1f} | "
          f"{'; '.join('/'.join(map(str, x)) for x in cs)} |")
