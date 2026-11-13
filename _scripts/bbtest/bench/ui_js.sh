#!/bin/bash
# The jsdom variant (--ui-js) against plain headless, A/B alternating run by run, each side pinned to the same
# CPUs (suor-p1: 0-11 = 6 P-cores with HT, 12-19 = E-cores): one-launch scenarios on one P-core (CPUs 2-3),
# suites on the P-cores (0-11). The suites leave out the ui_* files (they pick their own UI). JSON lines
# (measure.py) to $OUT (default work/jsdom_dev/bench.jsonl).
cd "$(dirname "$0")/.."
OUT=${OUT:-work/jsdom_dev/bench.jsonl}
FF=$(ls ../../fun_facts/scenarios/*.nut | grep -v /ui_)
AP=$(ls ../../autopilot/scenarios/*.nut | grep -v /ui_)
m() { local label=$1 cpus=$2; shift 2; bench/measure.py -n 1 --label "$label cpus=$cpus" -- taskset -c "$cpus" "$@" >> "$OUT"; }
for b in ${BENCH:-menu campaign battle}; do
    for i in 1 2 3; do
        m "plain $b" 2-3 ./bbtest.py bench/b_$b.nut
        m "js $b" 2-3 ./bbtest.py --ui-js bench/b_$b.nut
    done
done
[ -n "$NO_SUITES" ] && exit
for i in 1 2; do
    m "plain ff -j8" 0-11 ./bbtest.py -j 8 $FF
    m "js ff -j8" 0-11 ./bbtest.py --ui-js -j 8 --timeout 900 $FF
    m "js ff -j4" 0-11 ./bbtest.py --ui-js -j 4 --timeout 900 $FF
    m "plain ap -j8" 0-11 ./bbtest.py -j 8 $AP
    m "js ap -j8" 0-11 ./bbtest.py --ui-js -j 8 --timeout 900 $AP
done
