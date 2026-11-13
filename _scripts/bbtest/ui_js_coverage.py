#!/usr/bin/env python3
"""Which of the mods' UI JS ran in --ui-js launches: function and line coverage.

    NODE_V8_COVERAGE=work/cov ./bbtest.py --ui-js ...     # each page process writes one file
    ./ui_js_coverage.py work/cov [--mods autopilot fun_facts ...] [-v]

The page runs each script under its coui:// URL; a mod's `ui/<path>` is `coui://ui/<path>`.
V8's block coverage of every launch is merged: a function or line counts as run if any launch
ran it. A line counts if the innermost range holding its first character ran (blank lines and
comments are left out). By default every mod dir with a `ui/`.
"""
import argparse, json, re, sys
from pathlib import Path

MODS_ROOT = Path(__file__).resolve().parent.parent.parent


def mod_files(mods):
    """coui URL -> (mod, local path) of the mods' JS."""
    out = {}
    for mod in mods:
        ui = MODS_ROOT / mod / "ui"
        for f in sorted(ui.rglob("*.js")):
            out["coui://ui/" + f.relative_to(ui).as_posix()] = (mod, f)
    return out


def code_lines(src):
    """Line numbers (1-based) holding code: not blank, not only a comment."""
    lines, in_block = set(), False
    for i, line in enumerate(src.splitlines(), 1):
        s = line.strip()
        if in_block:
            if "*/" in s:
                in_block, s = False, s.split("*/", 1)[1].strip()
            else:
                continue
        if s.startswith("/*") and "*/" not in s:
            in_block = True
            continue
        s = re.sub(r"/\*.*?\*/", "", s).strip()
        if s and not s.startswith("//"):
            lines.add(i)
    return lines


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("dir", type=Path)
    ap.add_argument("--mods", nargs="*", help="mod dirs (default: every one with a ui/)")
    ap.add_argument("-v", "--verbose", action="store_true", help="list the functions that never ran")
    args = ap.parse_args()
    mods = args.mods or sorted(p.parent.name for p in MODS_ROOT.glob("*/ui") if not p.parent.name.startswith("_"))
    files = mod_files(mods)
    # url -> {function key -> ran}, url -> list of (start, end, count) of every range seen
    funcs, ranges, launches = {}, {}, 0
    for cov in sorted(args.dir.glob("coverage-*.json")):
        data = json.loads(cov.read_text())
        launches += 1
        for script in data.get("result", []):
            url = script["url"]
            if url not in files:
                continue
            fs = funcs.setdefault(url, {})
            for fn in script["functions"]:
                r0 = fn["ranges"][0]
                key = (fn["functionName"] or "(anonymous)", r0["startOffset"])
                fs[key] = fs.get(key, False) or r0["count"] > 0
                ranges.setdefault(url, []).extend((r["startOffset"], r["endOffset"], r["count"]) for r in fn["ranges"])
    rows, tot = [], [0, 0, 0, 0]
    for url, (mod, path) in files.items():
        src = path.read_text(errors="replace")
        starts = [0] + [m.end() for m in re.finditer("\n", src)]
        code = code_lines(src)
        fs = funcs.get(url)
        # A line ran if the innermost range holding its first character did (V8 nests ranges).
        ran = set()
        for ln in code:
            at = starts[ln - 1] + len(src[starts[ln - 1]:].split("\n", 1)[0]) - len(src[starts[ln - 1]:].split("\n", 1)[0].lstrip())
            best = None
            for s, e, c in ranges.get(url, []):
                if s <= at < e and (best is None or e - s < best[1] - best[0]):
                    best = (s, e, c)
            if best is not None and best[2] > 0:
                ran.add(ln)
        nf = len(fs) - 1 if fs else 0  # the script's own top-level function
        rf = sum(1 for k, v in (fs or {}).items() if v and k[1] != 0)
        rows.append((mod, url[len("coui://ui/"):], fs is not None, rf, nf, len(ran), len(code),
                     sorted(k[0] for k, v in (fs or {}).items() if not v and k[1] != 0)))
        tot[0] += rf; tot[1] += nf; tot[2] += len(ran); tot[3] += len(code)
    print(f"{launches} page processes; functions = function expressions in the file (its top level not counted)")
    print(f"{'mod':18} {'file':52} {'loaded':6} {'functions':>10} {'lines':>10}")
    for mod, f, loaded, rf, nf, rl, nl, never in rows:
        print(f"{mod:18} {f:52} {'yes' if loaded else 'no':6} {rf:>4}/{nf:<4}  {rl:>4}/{nl:<4}")
        if args.verbose and never:
            print(" " * 20 + "never ran: " + ", ".join(never))
    pct = lambda a, b: f"{100 * a / b:.0f}%" if b else "-"
    print(f"{'total':18} {'':52} {'':6} {tot[0]:>4}/{tot[1]:<4} {pct(tot[0], tot[1]):>4}  {tot[2]:>4}/{tot[3]:<4} {pct(tot[2], tot[3])}")


if __name__ == "__main__":
    sys.exit(main())
