#!/bin/bash
# The headless-Chromium variant (--ui-page) against plain headless, A/B alternating run by run, each side pinned
# to the same CPUs (suor-p1: 0-11 = 6 P-cores with HT, 12-19 = E-cores): one-launch scenarios on one P-core
# (CPUs 2-3), suites on the P-cores (0-11). JSON lines (measure.py) to $OUT (default work/cef/bench.jsonl).
cd "$(dirname "$0")/.."
OUT=${OUT:-work/cef/bench.jsonl}
m() { local label=$1 cpus=$2; shift 2; bench/measure.py -n 1 --label "$label cpus=$cpus" -- taskset -c "$cpus" "$@" >> "$OUT"; }
for b in menu campaign battle; do
    for i in 1 2 3; do
        m "plain $b" 2-3 ./bbtest.py bench/b_$b.nut
        m "page $b" 2-3 ./bbtest.py --ui-page bench/b_$b.nut
    done
done
for i in 1 2; do
    m "plain ff -j8" 0-11 ./bbtest.py -j 8 ../../fun_facts/scenarios/*.nut
    m "page ff -j8" 0-11 ./bbtest.py --ui-page -j 8 ../../fun_facts/scenarios/*.nut
    m "page ff -j4" 0-11 ./bbtest.py --ui-page -j 4 ../../fun_facts/scenarios/*.nut
    m "plain ap -j8" 0-11 ./bbtest.py -j 8 ../../autopilot/scenarios/*.nut
    m "page ap -j8" 0-11 ./bbtest.py --ui-page -j 8 ../../autopilot/scenarios/*.nut
done
m "page ff -j16" 0-19 ./bbtest.py --ui-page -j 16 ../../fun_facts/scenarios/*.nut
