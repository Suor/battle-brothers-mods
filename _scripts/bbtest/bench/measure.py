#!/usr/bin/env python3
"""Run a command and measure it: wall, CPU (user+sys of it and its children), RSS/PSS of its process tree.

Usage: bench/measure.py [-n RUNS] [--label L] [--extra-pids-file F] [--cwd DIR] -- CMD...

The tree is sampled from /proc every 0.2 s: per-process peak RSS, and the peak of the tree's total RSS and PSS
(PSS splits shared pages, so parallel engines sharing the binary and mapped .dat files aren't counted twice).
`--extra-pids-file` adds the tree of a pid read from a file (e.g. a KWin started outside the command) to the sums.
One JSON line per run goes to stdout, with the 1-minute load average at start and end.
"""
import argparse, ctypes, json, os, resource, signal, subprocess, sys, threading, time

PAGE = os.sysconf("SC_PAGE_SIZE")
TICK = os.sysconf("SC_CLK_TCK")


def children_map():
    kids = {}
    for d in os.listdir("/proc"):
        if not d.isdigit():
            continue
        try:
            with open(f"/proc/{d}/stat") as f:
                s = f.read()
        except OSError:
            continue
        ppid = int(s.rsplit(")", 1)[1].split()[1])
        kids.setdefault(ppid, []).append(int(d))
    return kids


def tree(roots):
    kids, out, todo = children_map(), [], list(roots)
    while todo:
        p = todo.pop()
        out.append(p)
        todo += kids.get(p, [])
    return out


def mem(pid):
    """(rss, pss, comm) in bytes, or None if gone."""
    try:
        with open(f"/proc/{pid}/smaps_rollup") as f:
            rss = pss = 0
            for line in f:
                if line.startswith("Rss:"):
                    rss = int(line.split()[1]) * 1024
                elif line.startswith("Pss:"):
                    pss = int(line.split()[1]) * 1024
        with open(f"/proc/{pid}/comm") as f:
            comm = f.read().strip()
        if comm == "bbtest":  # which launch: its run dir
            with open(f"/proc/{pid}/cmdline") as f:
                args = f.read().split("\0")
            if "--out" in args:
                comm += ":" + "/".join(args[args.index("--out") + 1].split("/")[-3:-1])
        return rss, pss, comm
    except (OSError, ValueError):
        return None


def cpu_of(pid):
    """utime+stime of a live process and its waited-for children, seconds (for trees not ours, e.g. KWin)."""
    try:
        with open(f"/proc/{pid}/stat") as f:
            v = f.read().rsplit(")", 1)[1].split()
        return sum(int(x) for x in v[11:15]) / TICK
    except OSError:
        return 0.0


def run_once(cmd, cwd, extra_pid, interval=0.2):
    load0 = os.getloadavg()[0]
    ru0 = resource.getrusage(resource.RUSAGE_CHILDREN)
    extra0 = sum(cpu_of(p) for p in tree([extra_pid])) if extra_pid else 0.0
    t0 = time.monotonic()
    libc = ctypes.CDLL("libc.so.6", use_errno=True)
    # The command dies with us (PR_SET_PDEATHSIG = 1).
    proc = subprocess.Popen(cmd, cwd=cwd, preexec_fn=lambda: libc.prctl(1, signal.SIGTERM),
                            stdout=subprocess.DEVNULL if not os.environ.get("MEASURE_OUT") else None)
    peak = {"rss": 0, "pss": 0, "procs": 0}
    per = {}  # pid -> (peak rss, comm)
    stop = threading.Event()

    def sample():
        while not stop.is_set():
            roots = [proc.pid] + ([extra_pid] if extra_pid else [])
            rss = pss = n = 0
            for p in tree(roots):
                m = mem(p)
                if not m:
                    continue
                rss += m[0]
                pss += m[1]
                n += 1
                if m[0] > per.get(p, (0, ""))[0]:
                    per[p] = (m[0], m[2])
            peak["rss"] = max(peak["rss"], rss)
            peak["pss"] = max(peak["pss"], pss)
            peak["procs"] = max(peak["procs"], n)
            stop.wait(interval)

    th = threading.Thread(target=sample, daemon=True)
    th.start()
    rc = proc.wait()
    wall = time.monotonic() - t0
    stop.set()
    th.join()
    ru1 = resource.getrusage(resource.RUSAGE_CHILDREN)
    extra1 = sum(cpu_of(p) for p in tree([extra_pid])) if extra_pid else 0.0
    cpu = (ru1.ru_utime - ru0.ru_utime) + (ru1.ru_stime - ru0.ru_stime) + (extra1 - extra0)
    top = sorted(per.values(), reverse=True)
    by_comm = {}
    for r, c in per.values():
        c = c.split(":")[0]
        by_comm[c] = max(by_comm.get(c, 0), r)
    MB = 1 << 20
    return {"rc": rc, "wall": round(wall, 2), "cpu": round(cpu, 2), "cpu_pct": round(100 * cpu / wall),
            "peak_proc_rss_mb": round(top[0][0] / MB) if top else 0,
            "peak_maxrss_children_mb": round(ru1.ru_maxrss / 1024),
            "peak_total_rss_mb": round(peak["rss"] / MB), "peak_total_pss_mb": round(peak["pss"] / MB),
            "max_procs": peak["procs"], "peak_rss_by_comm_mb": {c: round(r / MB) for c, r in by_comm.items()},
            "top_procs_mb": [(c, round(r / MB)) for r, c in top[:3]],
            "load_start": load0, "load_end": os.getloadavg()[0]}


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("-n", "--runs", type=int, default=3)
    ap.add_argument("--label", default="")
    ap.add_argument("--run", type=int, default=1, help=argparse.SUPPRESS)
    ap.add_argument("--cwd", default=None)
    ap.add_argument("--extra-pids-file")
    ap.add_argument("cmd", nargs=argparse.REMAINDER)
    a = ap.parse_args()
    cmd = a.cmd[1:] if a.cmd[:1] == ["--"] else a.cmd
    extra = int(open(a.extra_pids_file).read().strip()) if a.extra_pids_file else None
    if a.runs > 1:
        # A fresh measuring process per run: RUSAGE_CHILDREN's maxrss is a maximum over all past children.
        for i in range(a.runs):
            subprocess.run([sys.executable, __file__, "-n", "1", f"--label={a.label}", f"--run={i + 1}"]
                           + (["--cwd", a.cwd] if a.cwd else [])
                           + (["--extra-pids-file", a.extra_pids_file] if a.extra_pids_file else []) + ["--"] + cmd)
        return
    r = run_once(cmd, a.cwd, extra)
    print(json.dumps({"label": a.label, "run": a.run, **r}), flush=True)


if __name__ == "__main__":
    main()
