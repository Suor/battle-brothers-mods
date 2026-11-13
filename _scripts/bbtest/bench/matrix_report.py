#!/usr/bin/env python3
"""bench/matrix.sh's results as the comparable matrix: matrix_report.py md|html [bench.jsonl] [logs dir].
md: tables for RESOURCES.md (median (min) wall and CPU, median peak PSS; RSS too); html: bilingual tables for report.html
(medians). Not applicable = "—"; never an estimate."""
import html, json, re, statistics, sys
from collections import defaultdict
from pathlib import Path

mode = sys.argv[1]
src = Path(sys.argv[2] if len(sys.argv) > 2 else "work/matrix/bench.jsonl")
logs = Path(sys.argv[3] if len(sys.argv) > 3 else src.parent / "logs")
runs = defaultdict(list)
for line in src.read_text().splitlines():
    r = json.loads(line)
    runs[r["label"]].append(r)

WAYS = [("mocks", "моки", "mocks"), ("code", "code", "code"), ("engine", "engine", "engine"),
        ("ui", "ui: Chromium", "ui: Chromium"), ("jsdom", "jsdom", "jsdom"), ("kwin", "KWin + bb (bbui)", "KWin + bb (bbui)")]
SINGLE = [("menu", "меню", "menu"), ("campaign", "старт кампании", "campaign start"), ("saveload", "сохр. + загрузка", "save + load"),
          ("battle", "AI-бой", "AI battle")]
SUITES = [("nick", "Nicknames"), ("ff", "Fun Facts")]
MOCKS = {"nick": "mocks nick", "ff": "mocks ff"}


def tests(label):
    """[(run, fail, skip)] per round, in round order (the code env changed under the runs: they may differ)."""
    out = []
    for log in sorted(logs.glob(label.replace(" ", "_") + ".[0-9].log")):
        sj = log.with_suffix(".statuses.json")
        if sj.exists():
            c = defaultdict(int)
            for env in json.loads(sj.read_text()).values():
                for v in env.values():
                    c[v] += 1
            f = c["FAIL"] + c["ERROR"]
            out.append((c["PASS"] + f, f, c["SKIP"]))
        elif label.startswith("mocks"):
            text = log.read_text(errors="replace")
            p = len(re.findall(r"^PASS |(?<!Tests) OK$", text, re.M))
            f = len(re.findall(r"^FAIL ", text, re.M))
            out.append((p + f, f, 0))
    return out


def rng(xs):
    return f"{min(xs)}" if min(xs) == max(xs) else f"{min(xs)}–{max(xs)}"


def per_test(label):
    """Median over rounds of the round's CPU / its tests run."""
    t, rs = tests(label), runs.get(label, [])
    if not t or len(t) != len(rs):
        return None
    return statistics.median(r["cpu"] / n for r, (n, _, _) in zip(rs, t))


def stat(label, key):
    rs = runs.get(label)
    if not rs:
        return None
    xs = [r[key] for r in rs]
    return statistics.median(xs), min(xs), max(xs), len(xs)


def undersampled(r):
    """The 0.2 s sampler missed the largest process's peak (its ru_maxrss): runs under ~0.5 s, the mocks and code's."""
    return max([m for _, m in r["top_procs_mb"]] or [0]) < 0.8 * r["peak_maxrss_children_mb"]


def mem(r):
    """Peak PSS of the tree, None where undersampled."""
    return None if undersampled(r) else r["peak_total_pss_mb"] or None


def pss(label):
    rs = runs.get(label)
    if not rs or not all(mem(r) for r in rs):
        return None
    return statistics.median([mem(r) for r in rs]), max(mem(r) for r in rs)


def rss(label):
    """Peak RSS of the tree; for the mocks (one process, under the sampler's period) the largest child's ru_maxrss."""
    rs = runs.get(label)
    if not rs or (not label.startswith("mocks") and any(undersampled(r) for r in rs)):
        return None
    pick = lambda r: r["peak_maxrss_children_mb"] if label.startswith("mocks") else r["peak_total_rss_mb"]
    return statistics.median([pick(r) for r in rs]), max(pick(r) for r in rs)


def label_of(way, work):
    if work in dict(SUITES) or work.split()[0] in dict(SUITES):
        s, j = work.split()
        return MOCKS[s] if way == "mocks" and j == "-j1" else (None if way in ("mocks", "kwin") else f"{way} {s} {j}")
    return None if way == "mocks" else f"{way} {work}"


def f2(x):
    return f"{x:.2f}" if x < 10 else f"{x:.1f}" if x < 100 else f"{x:.0f}"


def mb(x):
    return f"{x / 1024:.2f} GB" if x >= 1000 else f"{x:.0f} MB"


loads = [r["load_start"] for rs in runs.values() for r in rs]
ns = sorted({len(rs) for rs in runs.values()})

if mode == "md":
    print(f"Runs: {ns} per row; load average (1 min) at the starts {min(loads):.1f}–{max(loads):.1f}.\n")
    print("### One launch, CPUs 2-3: wall s / CPU s, median (min); peak PSS MB median (max)\n")
    print("| Way | " + " | ".join(f"{en} wall / CPU" for _, _, en in SINGLE) + " | " + " | ".join(f"{en} PSS" for _, _, en in SINGLE) + " |")
    print("|---" * (1 + 2 * len(SINGLE)) + "|")
    for w, _, en in WAYS:
        cells, pcells = [], []
        for b, _, _ in SINGLE:
            lab = label_of(w, b)
            st, ct, p = (stat(lab, "wall"), stat(lab, "cpu"), pss(lab)) if lab else (None, None, None)
            cells.append(f"{f2(st[0])} ({f2(st[1])}) / {f2(ct[0])} ({f2(ct[1])})" if st else "—")
            pcells.append(f"{p[0]:.0f} ({p[1]:.0f})" if p else "—")
        print(f"| {en} | " + " | ".join(cells) + " | " + " | ".join(pcells) + " |")
    print("\n### Suites: wall s / CPU s, median (min); peak PSS MB median (max); -j 1 on CPUs 2-3, -j 8 on 0-11\n")
    print("| Way | " + " | ".join(f"{n} -j 1 wall / CPU | {n} -j 8 wall / CPU | {n} -j 8 PSS" for _, n in SUITES) + " |")
    print("|---" * (1 + 3 * len(SUITES)) + "|")
    for w, _, en in WAYS:
        row = []
        for s, _ in SUITES:
            for j in ("-j1", "-j8"):
                lab = label_of(w, f"{s} {j}")
                st, ct = (stat(lab, "wall"), stat(lab, "cpu")) if lab else (None, None)
                row.append(f"{f2(st[0])} ({f2(st[1])}) / {f2(ct[0])} ({f2(ct[1])})" if st else "—")
            p = pss(label_of(w, f"{s} -j8")) if label_of(w, f"{s} -j8") else None
            row.append(f"{p[0]:.0f} ({p[1]:.0f})" if p else "—")
        print(f"| {en} | " + " | ".join(row) + " |")
    print("\n### Per test: suite CPU at -j 1 / tests run (pass + fail; skips excluded), median over runs; counts min–max\n")
    print("| Way | " + " | ".join(f"{n} tests run (fail) / skip | {n} CPU s a test" for _, n in SUITES) + " |")
    print("|---" * (1 + 2 * len(SUITES)) + "|")
    for w, _, en in WAYS:
        row = []
        for s, _ in SUITES:
            lab = label_of(w, f"{s} -j1")
            t, pt = (tests(lab), per_test(lab)) if lab else (None, None)
            row.append(f"{rng([x[0] for x in t])} ({rng([x[1] for x in t])}) / {rng([x[2] for x in t])}" if t else "—")
            row.append(f"{pt:.3f}" if pt else "—")
        print(f"| {en} | " + " | ".join(row) + " |")
    print("\n### Peak RSS of the tree (sum over processes, shared pages counted in each), MB median (max)\n")
    print("| Way | " + " | ".join(en for _, _, en in SINGLE) + " | " + " | ".join(f"{n} -j 1 | {n} -j 8" for _, n in SUITES) + " |")
    print("|---" * (1 + len(SINGLE) + 2 * len(SUITES)) + "|")
    for w, _, en in WAYS:
        row = []
        for b, _, _ in SINGLE:
            lab = label_of(w, b)
            r = rss(lab) if lab else None
            row.append(f"{r[0]:.0f} ({r[1]:.0f})" if r else "—")
        for s, _ in SUITES:
            for j in ("-j1", "-j8"):
                lab = label_of(w, f"{s} {j}")
                r = rss(lab) if lab else None
                row.append(f"{r[0]:.0f} ({r[1]:.0f})" if r else "—")
        print(f"| {en} | " + " | ".join(row) + " |")
else:
    esc = lambda t: html.escape(t, quote=True)
    bi = lambda tag, ru, en, a="": f'<{tag}{a} data-en="{esc(en)}">{ru}</{tag}>'
    ru_num = lambda t: t.replace(".", ",").replace(" GB", " ГБ").replace(" MB", " МБ")
    num = lambda t: t if t == "—" else bi("span", ru_num(t), t)
    td = lambda t: f'<td class="num">{num(t)}</td>'
    out = []

    def table(head_ru, head_en, groups, rows):
        """groups: [(ru, en, [(ru, en), ...])]: a header row of groups over sub-headers."""
        h1 = bi("th", head_ru, head_en, ' rowspan="2"') + "".join(
            bi("th", ru, en, f' colspan="{len(sub)}" class="grp"') for ru, en, sub in groups)
        h2 = "".join(bi("th", ru, en, ' class="num"') for _, _, sub in groups for ru, en in sub)
        body = "".join("<tr>" + bi("td", ru, en) + "".join(td(c) for c in cells) + "</tr>\n" for ru, en, cells in rows)
        return (f'<div class="scroll"><table class="res">\n<thead><tr>{h1}</tr><tr>{h2}</tr></thead>\n<tbody>\n{body}</tbody></table></div>')

    WALL_CPU = [("стена, с", "wall, s"), ("CPU, с", "CPU, s")]
    rows = []
    for w, ru, en in WAYS:
        cells = []
        for b, _, _ in SINGLE:
            lab = label_of(w, b)
            st, ct = (stat(lab, "wall"), stat(lab, "cpu")) if lab else (None, None)
            cells += [f2(st[0]) if st else "—", f2(ct[0]) if ct else "—"]
        rows.append((ru, en, cells))
    out.append(table("Один запуск<br><small>CPU 2–3</small>", "One launch<br><small>CPUs 2–3</small>",
                     [(r, e, WALL_CPU) for _, r, e in SINGLE], rows))
    rows = []
    for w, ru, en in WAYS:
        cells = []
        for b, _, _ in SINGLE:
            lab = label_of(w, b)
            p = pss(lab) if lab else None
            cells.append(mb(p[0]) if p else "—")
        rows.append((ru, en, cells))
    out.append(table("Пиковая PSS<br><small>всё дерево процессов</small>", "Peak PSS<br><small>the whole process tree</small>",
                     [("один запуск, CPU 2–3", "one launch, CPUs 2–3", [(r, e) for _, r, e in SINGLE])], rows))
    rows = []
    for w, ru, en in WAYS:
        cells = []
        for s, _ in SUITES:
            for j in ("-j1", "-j8"):
                lab = label_of(w, f"{s} {j}")
                st, ct = (stat(lab, "wall"), stat(lab, "cpu")) if lab else (None, None)
                cells += [f2(st[0]) if st else "—", f2(ct[0]) if ct else "—"]
            lab = label_of(w, f"{s} -j8")
            p = pss(lab) if lab else None
            cells.append(mb(p[0]) if p else "—")
        rows.append((ru, en, cells))
    groups = []
    for _, n in SUITES:
        groups += [(f"{n}, <code>-j 1</code>, CPU 2–3", f"{n}, <code>-j 1</code>, CPUs 2–3", WALL_CPU),
                   (f"{n}, <code>-j 8</code>, CPU 0–11", f"{n}, <code>-j 8</code>, CPUs 0–11", WALL_CPU + [("PSS", "PSS")])]
    out.append(table("Набор целиком", "Whole suite", groups, rows))
    rows = []
    for w, ru, en in WAYS:
        cells = []
        for s, _ in SUITES:
            lab = label_of(w, f"{s} -j1")
            t, pt = (tests(lab), per_test(lab)) if lab else (None, None)
            cells += [rng([x[0] for x in t]) if t else "—", rng([x[2] for x in t]) if t else "—", f"{pt:.3f}" if pt else "—"]
        rows.append((ru, en, cells))
    out.append(table("На тест<br><small>CPU набора при <code>-j 1</code> / тестов</small>",
                     "Per test<br><small>suite CPU at <code>-j 1</code> / tests</small>",
                     [(n, n, [("тестов", "tests run"), ("skip", "skips"), ("CPU, с", "CPU, s")]) for _, n in SUITES], rows))
    print("\n".join(out))
