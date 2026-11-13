#!/bin/bash
# The comparable resource matrix (RESOURCES.md, "Comparable matrix"): the same workloads in every way that runs them,
# ways alternating run by run. suor-p1: CPUs 0-11 = 6 P-cores with HT, 12-19 = E-cores (kept free for others).
# One launch and -j 1 suites on one P-core (CPUs 2-3: the UI ways are several processes), -j 8 suites on 0-11.
# KWin rows need ../bbui/kwin.sh started on 2-3 first (`taskset -c 2-3 ../bbui/kwin.sh`); its CPU and memory count.
# NO_KWIN, NO_MOCKS, NO_SINGLE, NO_SUITES leave parts out; BBTEST_WAYS picks the bbtest ways, ROUNDS the rounds.
# JSON lines (measure.py) to $OUT, each run's bbtest output to $LOGS/<label>.<round>.log.
cd "$(dirname "$0")/.."
OUT=${OUT:-work/matrix/bench.jsonl}
LOGS=${LOGS:-work/matrix/logs}
mkdir -p "$LOGS"
KWIN_PID=../bbui/work/kwin.pid
NICK=$(ls ../../nicknames/scenarios/*.nut)
FF=$(ls ../../fun_facts/scenarios/*.nut)
declare -A WAY=([code]="--env code" [engine]="--env engine" [ui]="--env ui" [jsdom]="--ui-js")
m() {  # label cpus cmd...: one measured run, its output kept
    local label=$1 cpus=$2; shift 2
    local log="$LOGS/${label// /_}.$ROUND.log"
    bench/measure.py -n 1 --label "$label" ${EXTRA:+--extra-pids-file $EXTRA} -- \
        taskset -c "$cpus" sh -c '"$@" > "$0" 2>&1' "$log" "$@" >> "$OUT"
    # bbtest prunes old run dirs: keep the statuses
    local dir=$(sed -n 's/.*; runs in //p' "$log")
    [ -n "$dir" ] && cp "$dir/statuses.json" "${log%.log}.statuses.json"
}
for ROUND in ${ROUNDS:-1 2 3}; do
    if [ -z "$NO_SINGLE" ]; then
        for b in menu campaign saveload battle; do
            for w in ${BBTEST_WAYS:-code engine ui jsdom}; do m "$w $b" 2-3 ./bbtest.py ${WAY[$w]} bench/b_$b.nut; done
            [ -z "$NO_KWIN" ] && EXTRA=$KWIN_PID m "kwin $b" 2-3 env TIMEOUT=1200 ../bbui/bench.sh $b
        done
        if [ -z "$NO_MOCKS" ]; then
            m "mocks nick" 2-3 make -C ../../nicknames test
            m "mocks ff" 2-3 env STDLIB_DIR=$HOME/projects/bbm/stdlib/ sh -c 'cd ../../fun_facts && squirrel mocktests/test.nut'
        fi
    fi
    [ -n "$NO_SUITES" ] && continue
    for j in 1 8; do
        cpus=$([ $j = 1 ] && echo 2-3 || echo 0-11)
        for s in nick ff; do
            files=$([ $s = nick ] && echo "$NICK" || echo "$FF")
            for w in ${BBTEST_WAYS:-code engine ui jsdom}; do m "$w $s -j$j" $cpus ./bbtest.py ${WAY[$w]} -j $j --timeout 900 $files; done
        done
    done
done
