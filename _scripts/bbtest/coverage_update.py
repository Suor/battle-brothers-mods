#!/usr/bin/env python3
"""Derives coverage.json's per-env statuses from a run's statuses.json and refreshes report.html's inline copy.

Usage: coverage_update.py [--envs code,engine,jsdom,ui] <run dir or its statuses.json>

Per env, from the statuses of a bug's `tests` (skip reasons from skips.json beside statuses.json):
- caught: a test fails there (FAIL, ERROR, or lost: its launch died before it reported); for a fixed bug,
  also where its `regression.failed_before` records the test failing on the old code;
- no: every test skips there, or the tests pass on an open bug (tried, doesn't reproduce);
- reachable: a fixed bug's regression runs there but wasn't run on the old code.
A bug without tests keeps its statuses; mocks are never touched. Each `no`/`reachable` gets its reason in `why`.
"""
import argparse
import json
import re
import sys
import time
from pathlib import Path

HERE = Path(__file__).resolve().parent
COVERAGE = HERE / "coverage.json"
REPORT = HERE / "report.html"
# Column order in the file: cheapest first, as the report's bars.
ORDER = ["mocks", "code", "engine", "jsdom", "ui", "game"]


def derive(bug, env, statuses, skips):
    sts = [(t, statuses.get(t, "LOST")) for t in bug["tests"]]
    if any(s in ("FAIL", "ERROR", "LOST") for _, s in sts):
        lost = [t for t, s in sts if s == "LOST"]
        return "caught", (f"launch died before {len(lost)} test(s) reported" if lost and len(lost) == len(sts) else None)
    if all(s == "SKIP" for _, s in sts):
        return "no", "skip: " + "; ".join(sorted({skips.get(t) or "?" for t, _ in sts}))
    reg = bug.get("regression")
    if reg:
        if env in reg["failed_before"]:
            return "caught", None
        return "reachable", "regression passes; not run on the old code here"
    return "no", "passes here"


def dump(cov):
    """The file's layout: one bug a line."""
    head = {k: v for k, v in cov.items() if k != "bugs"}
    body = json.dumps(head, ensure_ascii=False, indent=2)[:-2]
    bugs = ",\n".join("    " + json.dumps(b, ensure_ascii=False) for b in cov["bugs"])
    return body + ',\n  "bugs": [\n' + bugs + "\n  ]\n}"


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("run", type=Path)
    ap.add_argument("--envs", default="code,engine,jsdom,ui")
    args = ap.parse_args()
    path = args.run / "statuses.json" if args.run.is_dir() else args.run
    results = json.loads(path.read_text())
    skips_file = path.with_name("skips.json")
    skips = json.loads(skips_file.read_text()) if skips_file.exists() else {}
    envs = args.envs.split(",")
    if missing := [e for e in envs if e not in results]:
        sys.exit(f"coverage_update: {path} has no env {', '.join(missing)}")

    cov = json.loads(COVERAGE.read_text())
    changed = []
    for b in cov["bugs"]:
        why = dict(b.get("why", {}))
        for env in envs:
            if not b.get("tests"):
                continue
            st, reason = derive(b, env, results[env], skips.get(env, {}))
            if b.get(env) != st:
                changed.append(f"{b['id']}: {env} {b.get(env)} -> {st}" + (f" ({reason})" if reason else ""))
            b[env] = st
            if reason:
                why[env] = reason
            else:
                why.pop(env, None)
        if why:
            b["why"] = why
        else:
            b.pop("why", None)
        # Statuses in the column order, the rest of the fields where they were.
        keys = [k for k in b if k not in ORDER]
        at = keys.index("en") + 1 if "en" in keys else len(keys)
        order = keys[:at] + [k for k in ORDER if k in b] + keys[at:]
        items = {k: b[k] for k in order}
        b.clear()
        b.update(items)
    cov["date"] = time.strftime("%Y-%m-%d", time.localtime(path.stat().st_mtime))
    text = dump(cov)
    COVERAGE.write_text(text + "\n")
    html = REPORT.read_text()
    new, n = re.subn(r'(<script type="application/json" id="coverage-data">).*?(</script>)',
                     lambda m: m[1] + text + m[2], html, flags=re.S)
    if n != 1:
        sys.exit("coverage_update: no #coverage-data in report.html")
    REPORT.write_text(new)

    n = len(cov["bugs"])
    for env in ["mocks"] + envs:
        c = {s: sum(b.get(env) == s for b in cov["bugs"]) for s in ("caught", "reachable", "no")}
        print(f"{env:7} caught {c['caught']:3}  reachable {c['reachable']:3}  no {c['no']:3}  of {n}")
    print(f"\n{len(changed)} changed:" if changed else "\nnothing changed")
    for c in changed:
        print("  " + c)


if __name__ == "__main__":
    main()
