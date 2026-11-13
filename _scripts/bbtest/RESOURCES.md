# CPU, RAM and disk of the four test approaches; speeding up bbtest and bbui

## Comparable matrix (2026-11-12)

The same workloads in every way that runs them, measured the same way, so rows and columns compare. `bench/matrix.sh`
(`bench/measure.py` per run, `bench/matrix_report.py` for these tables), suor-p1, 2026-11-12:

- Ways: mocks (`make test` in nicknames, Fun Facts' `mocktests/test.nut`), `bbtest.py --env code`, `--env engine`,
  `--env ui` (the page in headless Chromium), `--ui-js` (the page in jsdom), and the KWin demos' way (`bb` with the page
  in `../bbui/kwin.sh`'s KWin, driven by `../bbui/bench.sh`, which does what each `bench/b_*.nut` does).
- Workloads: one launch of `bench/b_menu.nut`, `b_campaign.nut`, `b_saveload.nut`, `b_battle.nut` (vanilla + Modern Hooks
  0.7.0, MSU 1.9.0, stdlib; seed `bbtest`); the whole nicknames and fun_facts suites (`<mod>/scenarios/*.nut`).
- CPUs: one launch and `-j 1` suites on CPUs 2-3 (one P-core, both threads: the UI ways are several processes, and
  on one thread the windowed `bb` missed its page's 5 s answer deadline); `-j 8` suites on 0-11 (the 6 P-cores). KWin
  was started on 2-3 too (for rounds 1-2; before round 3 something else restarted it via `kwin.sh`, CPU set unknown;
  round 3's KWin rows fall within rounds 1-2's). The E-cores (12-19) were left to other agents; a sampler of CPUs 0-11 every 30 s saw only
  these runs' own processes there.
- 3 runs a row, the ways alternating run by run: engine (c5e9936), ui, jsdom 18:12–19:00; code's first round was
  re-measured at 19:01 (another agent changed the code env until 18:18, so its earlier runs were dropped); KWin and
  mocks' rounds 1-2 at 17:30–17:50, round 3 at 18:55 (their binaries didn't change in between).
- Wall; CPU = user+sys of the command and every child (Node, Chromium's processes; KWin's from `/proc`, as a tree not
  ours); peak RSS and PSS of the whole tree's sum, sampled every 0.2 s (bbtest.py's own ~25-34 MB Python included in
  every bbtest way). Where the sampler missed the largest process's peak (its `ru_maxrss` 25 % higher: the mocks and
  code's launches under 0.5 s) the memory cells are "—"; `ru_maxrss` there: mocks 13 MB, code menu 76, campaign 89,
  save + load 94 MB (the interpreter alone).
- "—" otherwise: the way doesn't do it (mocks run no game, the KWin demos run no suites, mocks are one process so `-j`
  doesn't apply). Nothing here is an estimate.
- The AI battle is the same scenario but goes its own way per env: code 32003 frames (a flat map), engine 6051, ui
  13757–13760, jsdom 7253; KWin plays it in real time at 60 Hz, 155–260 s (its RNG isn't pinned). Suites: test counts
  differ per way (what an env can't do is a skip; the mocks are tests of their own).

What it shows:

1. One launch: code skips worldgen, so a campaign starts in 0.38 s against the engine's 2.39 s. Over the engine's
   wall, Chromium's page adds 0.4 s (menu), 0.8 s (campaign), 1.0 s (save + load); jsdom 0.9, 1.3, 1.5 s; the KWin demo
   0.9, 2.5, 9 s (its frames run in real time: the 260-frame wait before a load is 4.3 s) and 155–260 s for the battle.
   Memory: engine 86–153 MB PSS, jsdom 288–379, Chromium 400–614, KWin 611–830 (+ GPU memory, not counted).
2. Per test (suite CPU at `-j 1` / tests run): mocks 0.001 s, code 0.18, engine 1.0–1.25, Chromium 1.5–1.6, jsdom
   1.8–1.9 s.
3. `-j 8` on the P-cores: nicknames 5.3 s code, 22.5 s engine, 33–34 s for either page; total PSS 0.66 GB code, 1.2 GB
   engine, 2.7 GB jsdom, 3.2 GB Chromium (fun_facts the same order, 0.9 / 1.5 / 2.8 / 3.6 GB).
4. The ui battle's wall (13.3 s) is well above its CPU (7.5 s): probably the runner waiting on the page (pictures loading, page
   frames at most `BBTEST_UI_FPS` = 30 a second; UI_VARIANTS.md); not profiled further.
5. Earlier figures in this file (below) were taken under other conditions (other CPU sets, `-j`, engine builds,
   the code env before its changes): don't compare them with these.

3 runs a row; load average (1 min) at the starts 0.5–14.6.

### One launch, CPUs 2-3: wall s / CPU s, median (min); peak PSS MB median (max)

| Way | menu wall / CPU | campaign start wall / CPU | save + load wall / CPU | AI battle wall / CPU | menu PSS | campaign start PSS | save + load PSS | AI battle PSS |
|---|---|---|---|---|---|---|---|---|
| mocks | — | — | — | — | — | — | — | — |
| code | 0.40 (0.36) / 0.37 (0.35) | 0.38 (0.37) / 0.38 (0.36) | 0.42 (0.41) / 0.42 (0.41) | 4.38 (4.32) / 4.36 (4.31) | — | — | — | 124 (124) |
| engine | 0.27 (0.26) / 0.25 (0.25) | 2.39 (2.27) / 2.37 (2.25) | 2.65 (2.50) / 2.62 (2.46) | 3.32 (3.10) / 3.28 (3.07) | 86 (87) | 128 (130) | 153 (153) | 142 (142) |
| ui: Chromium | 0.69 (0.67) / 0.72 (0.70) | 3.17 (3.00) / 2.90 (2.80) | 3.65 (3.37) / 3.31 (3.08) | 13.3 (12.5) / 7.50 (7.05) | 400 (444) | 528 (532) | 560 (569) | 614 (626) |
| jsdom | 1.16 (1.08) / 1.40 (1.33) | 3.68 (3.48) / 4.06 (3.90) | 4.15 (3.85) / 4.60 (4.30) | 8.57 (8.17) / 9.44 (9.01) | 288 (292) | 354 (355) | 379 (386) | 376 (380) |
| KWin + bb (bbui) | 1.17 (1.07) / 1.02 (1.01) | 4.90 (4.66) / 5.42 (4.74) | 11.6 (10.8) / 7.35 (5.78) | 162 (155) / 63.6 (45.9) | 611 (616) | 749 (757) | 758 (761) | 830 (843) |

### Suites: wall s / CPU s, median (min); peak PSS MB median (max); -j 1 on CPUs 2-3, -j 8 on 0-11

| Way | Nicknames -j 1 wall / CPU | Nicknames -j 8 wall / CPU | Nicknames -j 8 PSS | Fun Facts -j 1 wall / CPU | Fun Facts -j 8 wall / CPU | Fun Facts -j 8 PSS |
|---|---|---|---|---|---|---|
| mocks | 0.06 (0.06) / 0.06 (0.05) | — | — | 0.01 (0.01) / 0.01 (0.01) | — | — |
| code | 10.2 (9.91) / 10.1 (9.87) | 5.32 (5.17) / 11.6 (11.0) | 663 (710) | 9.36 (9.22) / 9.33 (9.20) | 3.43 (3.32) / 12.1 (11.1) | 881 (888) |
| engine | 83.0 (77.6) / 82.3 (76.9) | 22.5 (22.2) / 104 (101) | 1228 (1235) | 70.4 (65.4) / 70.5 (65.5) | 13.8 (13.7) / 97.7 (95.6) | 1533 (1546) |
| ui: Chromium | 111 (101) / 108 (98.9) | 33.0 (32.2) / 128 (125) | 3285 (3288) | 114 (108) / 103 (89.8) | 25.4 (25.2) / 131 (128) | 3727 (3735) |
| jsdom | 118 (107) / 124 (113) | 33.8 (33.4) / 162 (161) | 2714 (2739) | 115 (113) / 125 (123) | 25.8 (25.5) / 192 (190) | 2904 (2917) |
| KWin + bb (bbui) | — | — | — | — | — | — |

### Per test: suite CPU at -j 1 / tests run (pass + fail; skips excluded), median over runs; counts min–max

| Way | Nicknames tests run (fail) / skip | Nicknames CPU s a test | Fun Facts tests run (fail) / skip | Fun Facts CPU s a test |
|---|---|---|---|---|
| mocks | 48 (0) / 0 | 0.001 | 9 (3) / 0 | 0.001 |
| code | 56 (5) / 11 | 0.181 | 53 (7) / 20 | 0.176 |
| engine | 66 (3) / 1 | 1.247 | 69 (8) / 3 | 1.022 |
| ui: Chromium | 66 (3) / 1 | 1.629 | 69 (8) / 3 | 1.488 |
| jsdom | 66 (3) / 1 | 1.878 | 69 (8) / 3 | 1.813 |
| KWin + bb (bbui) | — | — | — | — |

### Peak RSS of the tree (sum over processes, shared pages counted in each), MB median (max)

| Way | menu | campaign start | save + load | AI battle | Nicknames -j 1 | Nicknames -j 8 | Fun Facts -j 1 | Fun Facts -j 8 |
|---|---|---|---|---|---|---|---|---|
| mocks | — | — | — | — | 13 (13) | — | 12 (13) | — |
| code | — | — | — | 140 (140) | 545 (551) | 684 (731) | 209 (210) | 927 (934) |
| engine | 102 (103) | 144 (145) | 168 (168) | 157 (157) | 291 (291) | 1303 (1310) | 440 (442) | 1615 (1625) |
| ui: Chromium | 594 (654) | 752 (756) | 786 (796) | 847 (866) | 964 (976) | 6340 (6354) | 1022 (1032) | 6910 (6923) |
| jsdom | 313 (317) | 379 (379) | 404 (410) | 401 (404) | 566 (614) | 3165 (3189) | 573 (578) | 3353 (3369) |
| KWin + bb (bbui) | 893 (904) | 1032 (1051) | 1046 (1055) | 1109 (1144) | — | — | — | — |

### The original game (`--env game`, 2026-11-12)

The same `bench/b_menu.nut`, `b_campaign.nut`, `b_battle.nut` in the original (README, "The original game"), 3 runs
each, menu, campaign and battle alternating, everything (Python, KWin, Xwayland, Wine, the game) pinned to CPU 2:
one P-core thread, not the matrix's 2-3, as the game runs on one CPU. Wall is bbtest's, from the start of `launch.sh`
to its end (the game quits by itself); "menu" and "campaign" are the runner's marks, the game's real time since its
VM started (`Time.getRealTimeF`). CPU and memory weren't measured: Wine's processes leave the launched tree.
Load average (1 min) at the starts 1.7–3.8, Steam's client and other agents' work on the other CPUs.

| | wall s, median (min–max) | game's marks |
|---|---|---|
| menu | 12.2 (11.1–12.5) | main menu at 8.0–9.1 s |
| campaign start (seed `bbtest`) | 29.3 (27.7–29.5) | campaign up 16.1–16.3 s after the menu |
| AI battle (3 brothers +300 HP vs bandit raiders, 60 resources) | 223 (201–373) | the battle 172–344 s; 10179–20493 frames |

- Frames are real: the battle plays in real time at 60 frames a second, like the KWin demo's 155–260 s above, and
  its frame count varies run to run (the engine's is 6051 every time).
- The first `b_battle` runs (226–233 s) failed only on `[Error State] Invalid game state "TacticalFromWorldState"`
  rows: the original logs an error for `RootState.get()` of a state that's gone, where the engine returns null.
  `bbtest.nut`'s battle wait now checks `::Tactical.State` instead; the engine's runs are unchanged (6051 frames).
- On the E-cores (12-19, functional runs, not timed the same way) a nicknames-seed campaign launch took 43–60 s, and
  the nicknames suite's 13 launches about 21 minutes, against the engine's 44 s at `-j 6`.

### The original game, uncapped frames (`--env game`, 2026-11-13)

`game/runner.nut` and `session.sh` of 2026-11-12 ("before": vsync, real-time frames) against now ("after": vblank
off, the virtual clock held to 1/60 s a frame), alternating, `probes/game/{menu,snap_campaign,battle_result}.nut`
(Modern Hooks + MSU, seed `bbtest`; the battle is `bench/b_battle.nut`'s, its outcome logged). Run 1: everything
pinned to CPU 2, 3 rounds. Run 2: the E-cores (12-19), 2 rounds. Other agents' suites ran on CPUs 0-11
throughout (load average 4–17, `work/game/perf/timing*_load.txt`), so these are noisy; the battle's gap is far
outside the noise, the launches' isn't.

| | before, s | after, s |
|---|---|---|
| menu launch, wall | 9.9, 19.0, 19.8 / 21.0, 14.2 | 14.1, 21.2, 16.6 / 19.0, 22.2 |
| campaign launch, wall | 20.9, 34.6, 42.3 / 33.5, 48.6 | 34.8, 36.7, 44.2 / 32.6, 34.3 |
| AI battle, its part of the launch | 182, 211, 222 / 207, 192 | 92, 91, 85 / 95, 70 |
| its frames | 10873, 10063, 10955 / 12129, 8863 | 17605, 16293, 18154 / 18516, 18512 |

- Battle frames: 59–60 a second before, ~190 after (300–350 with the GPU free of other agents' Chromiums). The
  virtual clock moves 0.0167–0.0175 s a frame after, 1/60 s before (`probes/game/battle_fps.nut`). The outcome was
  PlayerDestroyed in every run of both, and in the engine (the battles here ran longer in frames).
- A launch's own overhead (one menu launch on the E-cores): `log.html` appears 3.5 s after `launch.sh` starts
  (KWin, Xwayland, Proton, the DRM wrapper), the runner's first frame at 7.7 s of the game's clock, the menu at 9.2 s;
  quitting, `wineserver -k` and Steam's stop take ~0.5 s each.
- A campaign start is world generation (~13–19 s on the main thread) plus the intro's 1.5 s; `--snapshot` loads the
  campaign in ~6 s instead (E-cores, one pair).
- Tried and left out: `Const.AI.AllottedTimePerEvaluationRun` 0.05 and 1 s instead of 0.005 (no consistent change
  in battle frame rate over 6 alternating runs, 45–300 fps, dominated by the GPU's other users); the game's own
  `VSync`/`LimitFrameRate` set at run time (no effect on the frame rate either way: only `vblank_mode=0` uncaps).

`inEvent()` of nicknames (N7, `../../nicknames/scenarios/probes/n7_stack.nut`): a verbatim copy called 200k times at
a stack depth of 33–34 frames.

| | µs a call | how |
|---|---|---|
| original, CPU 2 | 72 median (69–79), 9 rounds of 3 launches | the game's live clock around the loop, minus an empty-function control loop alternating with it (0.04–0.09 µs a call) |
| engine, CPU 4 (another P-core) | 57.8 median (57.6–60.5), 3 launch pairs | bbtest's launch wall, 200k-call launch minus the 0-call one (0.39–0.44 s) over 600k calls, alternating; the engine's clock counts frames, so the control loops (600k empty calls) are inside this figure |
 (2026-11-12): rows not comparable with each other

Measured on suor-p1 (i9-13900H: 6 P-cores with 2 threads each + 8 E-cores = 20 threads, 64 GB) on 2026-11-12
with `bench/measure.py`: wall; CPU = user+sys of the command and every child (`getrusage(RUSAGE_CHILDREN)`, plus
KWin's from `/proc` for UI runs); CPU % = CPU / wall; RSS/PSS of the whole process tree sampled from
`/proc/<pid>/smaps_rollup` every 0.2 s ("proc" = the largest single process, "total" = the peak of the tree's sum;
PSS splits pages shared between processes, e.g. the engine binary and the mapped `.dat`s of parallel launches).
Each row is 3 runs, median (min) unless marked n=1. Load average (1 min) at the start of runs was 1–20, nearly all
from these runs themselves (nothing else used CPU: checked with `ps`). Runs under 0.2 s are below the sampler's
period: their RSS is `ru_maxrss` of the children.

## Per approach

| Approach / run | Wall s | CPU s | CPU % | Peak RSS proc | Peak total RSS / PSS |
| --- | --- | --- | --- | --- | --- |
| **mocks** nicknames `make test` | 0.08 | 0.07 | 94 | 13 MB | — |
| mocks fun_facts / autopilot `mocktests/test.nut` | 0.01 / 0.01 | 0.01 | 90 | 13 MB | — |
| **code** one file (`nicknames/codetests/core.nut`) | 1.28 (1.27) | 1.26 | 99 | 323 MB | 349 / 335 MB |
| code nicknames suite (13 files, one interpreter each, `-j` = 20) | 3.14 (3.05) | 14.0 | 450 | 407 MB | 1.33 GB / 1.29 GB |
| code `autopilot/codetests/battle.nut` | 2.51 (2.48) | 2.47 | 99 | 189 MB | 215 / 201 MB |
| **engine** one launch, menu only (fw) | 0.25 (0.25) | 0.24 | 94 | 74 MB | 93 / 82 MB |
| engine campaign start, vanilla + fw | 2.23 (2.23) | 2.21 | 99 | 115 MB | 135 / 124 MB |
| engine campaign start, fw9 + Legends 19.4.23 | 3.51 (3.50) | 3.46 | 99 | 226 MB | 246 / 234 MB |
| engine campaign start, fw9 + Reforged 0.9.3 | 2.64 (2.60) | 2.62 | 99 | 149 MB | 168 / 156 MB |
| engine + one world day (`t.days(1)`, speed 4) | 2.66 (2.57): +0.43 | 2.63 | 99 | 125 MB | 145 / 134 MB |
| engine + one battle (3 bros vs raiders, AI both sides) | 2.95 (2.94): +0.72 | 2.94 | 99 | 128 MB | 148 / 137 MB |
| engine + save and load (`t.save`, `t.load`, incl. its 260-frame wait) | 2.45 (2.38): +0.22 | 2.41 | 98 | 140 MB | 160 / 148 MB |
| engine nicknames suite, 53 tests in 10 launches, `-j 12` | 21.4 (19.2) | 81 | 390 | 262 MB | 1.21 GB / 1.13 GB |
| engine nicknames `--isolate`, 53 launches, `-j 12` / `-j 16` | 33.5 (33.2) / 31.2 (30.2) | 367 / 441 | 1106 / 1446 | — | 1.56 / 2.02 GB PSS |
| engine fun_facts suite, 63 tests in 11 launches, `-j 12` | 11.7 (10.8) | 70 | 600 | 260 MB | 1.33 GB / 1.25 GB |
| engine autopilot suite, 99 tests in 19 launches, `-j 12` | 26.7 (26.5) | 186 | 697 | 263 MB | 2.00 GB / 1.91 GB |
| engine 26 other mods, 296 tests in 108 launches, `-j 12` | 71.4 (70.9) | 812 | 1134 | 810 MB | 2.54 GB / 2.44 GB |
| engine thirdparty, 19 tests in 11 launches, `-j 12` | 13.5 (13.1) | 92 | 687 | 264 MB | 1.72 GB / 1.64 GB |
| **UI** `fun_facts_obituary.sh`, fixed frames (before) | 24.3 (24.1) | 4.9 | 20 | 518 MB (`bb`) | 1.07 GB / 0.73 GB |
| UI `autopilot_buttons.sh`, fixed frames (before) | 31.2 (31.2) | 7.4 | 24 | 527 MB | 1.07 GB / 0.73 GB |
| UI `fun_facts_obituary.sh`, waiting on conditions (now) | 4.64 (4.53) | 4.2 | 90 | ~500 MB | 1.08 GB / 0.74 GB |
| UI `autopilot_buttons.sh`, waiting on conditions (now) | 6.17 (6.16) | 5.0 | 81 | ~500 MB | 1.08 GB / 0.74 GB |

- A launch is one single-threaded process (99 % CPU): the engine runs the scripts on one thread. A launch's RSS is
  75–260 MB; the most seen was 810 MB (`elite_few/scenarios/legends_bugs_elite_few.nut`: Legends + many generated
  bros, 16 s of tests). Code: the plain interpreter holds all of vanilla's scripts: 190–410 MB per file, more than
  an engine launch.
- UI totals: `bb` (~500 MB) + its CEF subprocess (~240 MB) + KWin (230 MB); GPU memory not counted. KWin's start:
  0.3 s (`kwin.sh` slept 3 s before). Zipping the mods (`mods.sh`): 18 ms.
- Packed suites use several cores: CPU % = how many launches ran on average. A suite's wall is either its longest
  launch (nicknames: 19.1 s of 21 s, a 5811-frame launch) or CPU throughput (other26: 812 s of launches).

## Disk

| What | Size |
| --- | --- |
| compiled-script cache `~/.cache/bb-modern-engine/scripts` (shared by all launches; `BB_SCRIPT_CACHE`) | 187 MB (+183 MB `sheets/`, the UI build's) |
| a launch's run dir (`events.log`, `log.html`, the wrapped files, `saves/`) | median 7 MB, max 33 MB; mostly saves (6.5 MB each: `fresh=1`, `t.save`) |
| one invocation's run dirs: nicknames / other26 | 81 MB / 0.93 GB |
| `work/runs/` after this day of benchmarking | 33 GB: every invocation of the last hour is kept besides the last 20 |
| `work/snapshots/` (`--snapshot`) | 6.5 MB per campaign; 116 after these runs (758 MB); unused for 2 days: deleted |
| codetest `work/` (symlink trees, interpreter build) / bbui `work/` | 341 MB / 13 MB |

## Where an engine launch's time goes

Over all 159 launches of the five suites (base run, `RUNNER TIME` lines): 1232 s of launches = boot to the main
menu 94 s (8 %), **campaign start 523 s (42 %)** (worldgen and the faction simulation, 2–5 s each, seed dependent;
Legends adds ~0.9 s to the boot), tests 600 s (49 %), process start/exit 15 s. `perf` of a campaign launch and of a
5-day launch: Squirrel execution (`SQVM::Execute`/`Get`, table lookups) and the world's natives (`world_nav::find_path`,
`flood_last`, `FogMask::stamp`) — the runner's own per-frame work (compiling the two one-line scripts it runs every
frame) is under 0.5 %, the driver (`bbtest.py`: building 26 mods' zips with `make include`, `git ls-files`) 0.33 s
per invocation. Frames: a world day ~1600 frames ≈ 0.43 s, a battle 0.7 s.

The compiled-script cache is used and warm (the default dir): menu 0.25 s warm vs 0.37 s with `BB_SCRIPT_CACHE=off`;
Legends campaign 3.51 s warm vs 3.70 s off vs 4.44 s cold (writing 81 MB).

## Optimizations tried

Statuses compared per launch and test with `work/resources/statuses.py` on nicknames (53 tests/11 failures),
fun_facts (63/16), autopilot (99/27), the 26 other mods (296/48) and thirdparty (19/4) at `-j 12`. The base was
identical in 3 runs (Reforged's battles included).

| Optimization | Before → after (median of 3) | Statuses | Adopted |
| --- | --- | --- | --- |
| Longest launch first (walls of earlier runs, `work/walls.json`; new launches first) | nicknames 21.4 → 20.1 s, fun_facts 11.7 → 11.2, autopilot 26.7 → 25.1, other26 71.4 → 69.8, thirdparty 13.5 → 12.8; about the run-to-run spread, the longest launch stays the bound | identical (3 runs) | yes, default |
| `-j` default 4 → 3/4 of the CPUs (15 here) | other26 at `-j` 6/8/12/16/20: 105.0 / 86.7 / 69.8 / 62.8 / 61.6 s; CPU 620 / 674 / 810 / 960 / 1120 s (E-cores and shared P-core threads do less per second); PSS 1.7 / 2.1 / 2.7 / 3.2 / 3.7 GB. autopilot (bound by a 24 s launch): 27.7 / 25.3 / 25.1 / 24.2 / 24.7 | independent of `-j` | yes |
| `--snapshot`: the campaign saved at a launch's start, loaded through the main menu by later launches with the same seed, origin, mods (built zips by content) and engine, instead of worldgen; files with `beforeCampaign` excluded | campaign phase 2–5 s → 0.4 s. Packed, `-j 12`, snapshots there (2 runs, both given): nicknames 21.4 → 14.8 / 14.4 s (CPU 81 → 31 / 29 s), fun_facts 11.7 → 8.9 / 9.9, autopilot 26.7 → 21.1 / 21.3, other26 71.4 → 52.4 / 52.1 (CPU 812 → 569 / 597 s), thirdparty 13.5 → 10.5 / 12.1. Making them costs nothing measurable (a run after an engine rebuild, which changes every key: 21.6, 11.6, 25.1, 71.2, 14.4 s). `--isolate` nicknames `-j 16`: 31.2 → 8.7 s (CPU 441 → 69 s) | not identical: packed, 3 tests change (autopilot `behaviors::unbag shield…`, `stress_a::vs Zombies.`, immortal_warriors `core::an immortal killed in battle…`) and nicknames' `reforged_bp` launch (Reforged 0.8.18 + Black Pyramid) can't load the save (`item_container.onDeserialize`: `parameter 1 has an invalid type 'null'`), losing its 3 tests; `--isolate`: only that launch | opt-in `--snapshot`; since then it implies `--stable-rng` and restores the unsaved faction-update state: statuses equal `--stable-rng`'s in all five suites but for that launch (README Speed) |
| Skipping the 260 frames before a load at a fresh process | world_state ignores a load within 4 s of real time after its start too; `--snapshot` waits them (~0.15 s) | — | no (needed) |
| Caching the built mod zips | the whole driver side is 0.33 s for 26 mods | — | no (nothing to gain) |
| Runner per-frame overhead (eval + `tick` compiled each frame) | < 0.5 % of a launch in `perf` | — | no |
| Smaller world (`set_world_size`) | vanilla's worldgen rejects ≤ 130×130; changes the world, so results | — | not tried |
| Fewer frames per game time (`--fps` < 60) | changes timing-driven results (battles' frames, waits' budgets) | — | not tried |
| Splitting the longest launches (`launch=`) | the bound of nicknames (19 s of 21 s) and autopilot (24 s) suites; a suite edit, not the runner's | — | left to the suites |

### codetest: the game's bytecode instead of decompiled text

`codetest.py` (default) vs `--nut`, alternated run by run (`codetest/work/cmp/bench.py`), on 2026-11-12 with load
average 12–18 from other agents (so walls and CPU are noisy; mins are the steadier figure). CPU = user+sys of the
children; peak RSS = the largest interpreter (`ru_maxrss` via a `CODETEST_SQ` wrapper). Median (min).

| Run | n | `--nut` wall s | cnut wall s | `--nut` CPU s | cnut CPU s | Peak RSS nut / cnut |
| --- | --- | --- | --- | --- | --- | --- |
| boot only, no mods | 5 | 0.69 (0.59) | 0.39 (0.35) | 0.68 (0.59) | 0.39 (0.35) | 65 / 66 MB |
| boot only, fw + nicknames | 5 | 0.83 (0.75) | 0.53 (0.46) | 0.82 (0.75) | 0.53 (0.45) | 75 / 76 MB |
| `nicknames/codetests/core.nut`, two series | 5, 8 | 2.09 (1.88), 1.75 (1.52) | 2.28 (1.93), 1.46 (1.30) | 2.06 (1.86), 1.73 (1.51) | 2.26 (1.91), 1.45 (1.29) | 375 / 376 MB |
| `nicknames/codetests/factors.nut` | 5 | 1.96 (1.93) | 2.03 (1.81) | 1.95 (1.92) | 2.02 (1.80) | 455 / 456 MB |
| nicknames suite (13 files), `-j 1` | 3 | 15.7 (15.4) | 12.3 (12.0) | 15.6 (15.2) | 12.2 (12.0) | 455 / 456 MB |
| nicknames suite, `-j` = 20 | 5 | 5.95 (3.63) | 4.97 (3.52) | 23.2 (18.3) | 18.4 (15.1) | 455 / 456 MB |

- The gain is the boot: the interpreter's own `BOOT` halves, 0.33 → 0.17 s alone, median 0.70 → 0.33 s over the
  25 files run in parallel (loading bytecode instead of compiling 3109 files), and `--nut` also reads every vanilla file in Python to look for decompiler damage. Tests themselves
  run at the same speed within the noise (core.nut flips sign between the two series). RSS: +1–2 MB.
- Cache: 3109 scripts, 38 MB in `codetest/work/cnut/<hash>/`; transcoding takes 0.27 s, a first run 0.9 s vs 0.4 s
  warm (one run each, no mods).
- Statuses: all 25 code test files (97 tests, 75 pass, 22 fail) identical in both modes, two rounds; the only
  output difference, the order of autopilot `battle.nut`'s `auto uses` probe, changes between runs of either mode.

### bbui (engine + UI)

Frames are paced by the display: KWin's virtual output is 60 Hz, so the examples' fixed `--at 900`…`--shot 1700`
cost 15–28 s of waiting. Tried, each 3 runs:

| Change | fun_facts_obituary | autopilot_buttons |
| --- | --- | --- |
| before: fixed frames, 60 Hz, VSync on | 24.3 s | 31.2 s |
| VSync off (`video.vsync = false` in the settings: Mailbox present, cap 144 frames/s) | 13.4 | 23.5 (a battle presents every frame: the compositor's frame callbacks still pace it at 60) |
| 240 Hz output (`kscreen-doctor output.Virtual-0.addCustomMode.1280.720.240000.full`, `mode.2`), VSync on | 8.2 | 10.1 |
| 240 Hz, VSync off | 11.8 | 14.8 |
| **waiting on conditions**, 60 Hz, VSync on | **4.6** | **6.2** |
| waiting on conditions, 240 Hz, VSync on / off | 4.6 / 4.7 | 6.1 / 6.1 |

More frames a second make the same frame count come sooner: the scripts' real-time events (the intro event 1 s in)
and the page keep their real time, so the fixed-frame scripts still passed at 240 Hz. Waiting on the state instead
(`bbui/lib/when.sq` polls in Squirrel every 50 ms of real time, the page polls with `setInterval`, `run_until.sh`
stops `bb` when the result line shows) leaves boot, worldgen, CEF and the 1 s intro: the refresh rate and VSync then
don't matter. Adopted: the condition waits (both examples PASS, also with `SHOT=1`, which keeps the screenshot at the
old fixed frame) and `kwin.sh` waiting for the socket instead of 3 s. Not adopted: 240 Hz and VSync off (no gain on
top).

## Headless engine vs UI: what each can do

Headless (`bbtest`): the game's own scripts run unchanged on the installed `.dat`s and the mods' zips; the UI is
squirrel-bb's headless client (`squirrel-bb/src/ui_client/`, `native/ui_bridge.rs`).

1. World: campaign start (worldgen, factions, origins and their intro events), world days at any speed, settlements,
   parties moving and attacking, contracts and events (answered with their first button, or by the test).
2. Battles: real tactical maps (terrain, heights, line of sight, pathfinding, ZOC), vanilla's and mods' AI on both
   sides, the engine's scripted player through the real input paths, deaths, injuries, the battle's end and return to
   the world.
3. Saves: `saveCampaign`/`loadCampaign` with the mods' serialization hooks, through the world's menu or the main menu.
4. Squirrel→JS calls (`JSHandle.asyncCall`/`call`): recorded in an ordered log and answered as the vanilla JS would
   for the generic lifecycle (`onScreenConnected`, `onScreenShown`/`Hidden`, `onModuleShown`/`Hidden` on the next
   pump); both return `null`, as in the original. bbtest's scenarios can't read that log (codetest's `::__CT.jsCalls`
   can).
5. JS→Squirrel callbacks the scripts depend on are emulated: the turn sequence bar's three first-slot callbacks (what
   starts a turn, `ui_client/turn_sequence_bar.rs`; the code approach had to emulate the same JS in Squirrel), Modern
   Hooks' loader handshake (`queryData`, `resumeOnInit`), MSU's `connectBackend` late JS. Any other callback (a button,
   a tooltip query, a settings save) a test calls by hand on the screen's Squirrel object.
6. Tooltips' Squirrel side: `TooltipEvents` and the mods' hooks on it return the tooltip data (called by the test).
7. Not there: the mods' JS and CSS, anything the page computes or decides (KNOWN_BUGS #4 of Autopilot, stale status
   icons; button visibility; DOM bindings such as Fun Facts' per-row tooltips; layout, images, fonts, text fitting),
   screenshots, input that only the page routes (keys handled in JS: the wait-all popup's Enter/Esc).

Resources: a headless launch to a campaign is 2.2 s, 1 core, 115–260 MB; the UI run of the same is ~4.6 s, ~1 core
on average, 1.07 GB RSS (0.73 GB PSS) with KWin and CEF, plus the GPU, and one at a time per KWin (bb locks its
saves dir; the examples share `work/`).
