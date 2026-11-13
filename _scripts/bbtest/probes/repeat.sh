#!/bin/bash
# Runs a probe scenario N times as separate launches (launch=rK) and diffs their STATE/RNG lines against the first.
# Usage: probes/repeat.sh probes/start_state.nut N [bbtest.py options]
src=$1 n=$2; shift 2
here=$(cd "$(dirname "$0")/.." && pwd)
tmp=$here/work/repeat; rm -rf "$tmp"; mkdir -p "$tmp"
for i in $(seq 1 "$n"); do
    mkdir "$tmp/r$i"
    sed "1s/\$/ launch=r$i/" "$src" > "$tmp/r$i/$(basename "$src")"
done
taskset -c 12-19 "$here/bbtest.py" -j 8 "$@" "$tmp"/r*/*.nut > "$tmp/out.txt" 2>&1
run=$(grep -o "runs in .*" "$tmp/out.txt" | sed "s/runs in //")/
i=0
for d in "$run"*/; do
    i=$((i+1))
    grep -E 'ROW .* (STATE|RNG) ' "$d/events.log" | sed 's/^ROW [a-z]* [^ ]* //' > "$tmp/$i.txt"
done
for j in $(seq 2 "$i"); do
    if cmp -s "$tmp/1.txt" "$tmp/$j.txt"; then echo "$j same"; else echo "$j DIFF $(diff "$tmp/1.txt" "$tmp/$j.txt" | grep -c '^[<>]') lines"; fi
done
wc -l "$tmp"/1.txt; grep -E '^ *(PASS|FAIL|ERROR)' "$tmp/out.txt" | sort | uniq -c
