# UI variants for mod tests: the mods' JS in bbtest

bbtest's default UI is a stub client (README, "Engine issues"): the mods' `ui/` JS never runs. Two ways to run it.

## Variant 1: jsdom

The game's real UI page — vanilla `ui/` from the archives (~51k lines of JS with jQuery, jQuery UI, Velocity) and
every mod's registered JS and CSS — in jsdom 30.1.3 under Node 26, joined to the engine by the Coherent protocol.
`./bbtest.py --ui-js` or `ui=js` in a mode line (the runner's README, "The UI page in jsdom"). Engine branch
`bbtest-jsdom` (`~/projects/bbm/3rdparty/modern-bb-engine-jsdom`), commits `c7e6b00`, `42417f4`, `27ca3c5`.

### How it works

- **Rust side** (`bb-ui/src/jsdom.rs`, feature `jsdom`): `NodePage` starts `node bb-ui/jsdom/page.js` and is a
  `Transport` of `bridge.rs`'s `UiProtocol`, so the protocol, the JSON wire values and the Squirrel side are those of
  the CEF host. One JSON object per line over the child's stdin/stdout; the game always drives:
  `{"load"}`, `{"tick": ms}`, `{"eval": code}`, `{"run": ["t", event, args...]}` (an SQ→JS call), each answered by
  `{"done": value}`. While one runs, the page sends `{"call": [name, id, args...]}` (an `engine.call`), answered by
  `{"reply": ...}`, or first by a nested `{"run"}` when the script calls back into the page — nesting either way,
  as deep as it goes, as in the original; `{"file": url}` (a `coui://` file, from `coui.rs`'s `UiFiles` over the
  launch's archives, so mods shadow vanilla); `{"console": [level, text]}`.
- **Node side** (`bb-ui/jsdom/page.js`): blocks on stdin between messages (`fs.readSync`), so no page task runs
  except inside one of the game's messages, as the original's UI ran on the game's thread. Promise callbacks run
  after each outermost message (`setImmediate` before `done`), not inside nested ones.
- **Coherent's native half**: `window.engine` with `SendMessage`/`BindingsReady`/… before `coherent.js` runs, as
  `host/bootstrap.js` does for Chromium: an `engine.call` blocks until the game answers; a `callSQ` result reaches
  its promise in a later task (next tick); void calls are never answered.
- **Loading**: `main.html` (the mods' override, e.g. `mod_hooks`', if any) without its comments, scripts and
  stylesheet links; each script then runs by `vm.Script` under its `coui://` URL (stack traces and coverage name the
  file). Scripts the page inserts (Modern Hooks' `registerJS`, `mods_registerJS`, late JS) run after the inserting
  code, in insertion order, then fire `load` (Modern Hooks resumes the boot on the last one's), with Coherent's rule
  for a URL inserted again while its first copy waits (it runs right after that copy: Nested Tooltips' `setup.js`,
  `host/script_order.js`). Inserted stylesheet links become `<style>`.
- **Runner** (`engine/bbtest_js.rs` → `bb-ui/examples/bbtest_js.rs`): bbtest with `--ui-js`; boots with
  `boot_menu_with` ticking the page each try (Modern Hooks' handshake happens in the page), ticks the page by
  1/60 s after every frame, installs `::BBTest_js(code)` (`t.js`) and `::BBTest_mouseOverUI(bool)`.

### Time

Virtual, tied to frames: `setTimeout`/`setInterval`, `requestAnimationFrame` (once per tick), `Date`,
`performance.now()` all follow the page's clock, which only a tick moves (1/60 s a frame, from the menu on). Due
timers run in due order within a tick; inserted scripts run after the task that inserted them. So a 300 ms fade
takes 18 frames, as in the game at 60 fps, where the stub answered on the next pump: popups and turn-bar
animations take their frames (see the suites' differences below).

### What jsdom lacks, and what's shimmed

Shimmed (`page.js`):

1. `window.engine` (above) and the clock (above).
2. Images: jsdom loads none; any image given a `src` fires `load` on the next tick (the loading screen fades in on
   its picture's `load`: without this no campaign starts). Missing files load "fine" too.
3. CSS: by default only the rules' `display`, `visibility` and `overflow(-x/-y)` declarations apply — what the UI's
   scripts read back (`.css('display')`, the scroll bar's overflow check). `getComputedStyle` is replaced by an
   index of those rules (by the last compound's class/id/tag, then `matches`, specificity, order, `!important`,
   inline style), other properties from the inline style as jsdom gives them, and kept per element until the
   document changes (a `MutationObserver`'s `takeRecords()`). jsdom's own matched all ~2100 rules on each call,
   ~150 µs, and the event log's scroll bar asks ~10 times a frame in a battle (`BB_UI_JS_CSS=full` restores it).
4. `canvas.getContext` → `null`, `scrollTo`/`scrollIntoView` and media `play`/`pause`/`load` no-ops (jsdom's
   "not implemented" noise otherwise).
5. Whether the mouse is over the page: a host input jsdom can't compute; `::BBTest_mouseOverUI(false)` before mouse
   input to the map (otherwise hovers over tiles do nothing, as the cursor counts as over the UI).

Not shimmed (and why it didn't matter here): layout — every size and position is 0 (`offsetWidth`,
`getBoundingClientRect`, `.width()`, `.offset()`); jQuery's `:visible`/`:hidden` are wrong (every element
"hidden": tests read classes or `css('display')`); scroll bars measure zeros; drag and drop, focus, real input events
(tests trigger jQuery events: `trigger('mouseenter')`, `.click()`).

### Errors

`console.error` and uncaught exceptions (in scripts, timers, event handlers, animation frames) are `ROW Error JS`
lines in `events.log` (`[Error JS]` in reports: they fail the test they happen in, or the launch outside tests);
`console.warn`, jsdom's gaps and the bridge's complaints `ROW Warning JS`; `console.log` `JS_LOG` (not reported).
`known_errors.txt` regexes also excuse page errors inside tests: one entry so far, vanilla's turn bar race below.

### Suites (2026-11-12, statuses against a plain run right after)

| Suite | Plain | `--ui-js` | Differences |
| --- | --- | --- | --- |
| fun_facts (files but `ui_*`) | 67 tests, 9 failures | 69 tests (+ `ui_js_*`), 11 | `economy::ammo` fails: a Squirrel error in vanilla `shield.nut` (`getActor`) on the battle path the page's timing led to — engine/test, not page; `ui_js_kb8` fails by design (KB8) |
| autopilot (files but `ui_*`) | 99 tests, 27 failures | 88 tests (+ `ui_js_*`), 32 | 3 tests time out acting on a popup mid-fade (vanilla race, the stub never animates), losing their launch's later tests (8 fewer tests); 2 AI-outcome asserts; `stress_a::vs GoblinRaiders` hung in round 2 in 2 of 3 packed runs (not alone; not investigated); `ui_js_kb4` fails by design (KB4) |

New page errors, triaged:

| Error | Where | Whose |
| --- | --- | --- |
| `Cannot read properties of undefined (reading 'call')` at `nested_tooltips/js_hooks/screens/world/world_event_screen.js:13` | Reforged/Hardened launches, event screen | the jsdom page's: inserted scripts ran in plain insertion order; fixed by Coherent's duplicate-URL rule (`42417f4`) |
| `s.setFromString is not a function` in `extern/jquery.animate.min.js` | town screen | the jsdom page's: a commented-out `<script>` in `main.html` was run; fixed (`42417f4`) |
| `Cannot read properties of undefined (reading 'css'/'velocity')` at `turnsequencebar_module.js:996/1011` | most battles | vanilla UI: a portrait leaves the turn bar while its first-slot resize animation runs; the animation's end reads the removed portrait's data. No mod on the stack, harmless; in `known_errors.txt` |

Mods' own JS logged no error in either suite. Bugs found or confirmed in the page: Autopilot KNOWN_BUGS #4 (status
bar shows the previous bro's effect icons after a cost preview; passes with `--swap autopilot=`) and Fun Facts KB8
(Career Stats' obituary tooltip lost to Fun Facts'), in the mods' `FOUND_BUGS.md` ("In the real UI page, jsdom"),
tests `autopilot/scenarios/ui_js_kb4.nut`, `fun_facts/scenarios/ui_js_kb8.nut`; plus JS-level checks that pass:
Autopilot's five turn-bar buttons and their hover tooltips (`ui_js_buttons.nut`), Fun Facts' obituary row tooltips
(`ui_js_obituary.nut`). Found on the way, vanilla's own: the status bar's fade-out empties the bar after the next
bro's icons are in (without Autopilot, a bro after an effect-less one shows none of his own).

### Coverage of the user's mods' JS

`NODE_V8_COVERAGE=<dir>` (V8 block coverage of each page process), summed by `./ui_js_coverage.py <dir>`: a
function ran if any launch ran it; a line ran if the innermost range holding its first character did (blank lines
and comments left out; a file's top level isn't counted as a function).

Runs: the two suites above (30 page processes; launches that crashed or timed out write none) plus one launch with
all 11 mods that have a `ui/` (`work/jsdom_dev/cov_allmods.nut`: the character screen with each bro, a level-up
dialog, tooltips, the campfire, the obituary, an Autopilot battle; Bro Studio's stdlib-version boot error allowed).

| Mod | File | Functions run | Lines run |
| --- | --- | --- | --- |
| AC | `companions_tooltip.js` | 1/1 | 33/44 |
| autopilot | `autopilot_new.js` | 10/13 | 92/103 |
| autopilot | `autopilot_new/slider_setting.js` | 0/3 | 3/25 |
| bro_studio | `bro_studio.js` | 1/1 | 6/6 |
| bro_studio | `bro_studio/slider_setting.js` | 1/3 | 21/25 |
| bro_studio | `i_bro_studio_levelup_changes.js` | 1/2 | 10/46 |
| challenges | `challenges/hiring.js` | 3/4 | 11/21 |
| challenges | `challenges/loot_panel.js` | 7/8 | 65/82 |
| challenges | `challenges/slider_setting.js` | 0/3 | 3/20 |
| druid | `druid.js` | 2/3 | 14/31 |
| fun_facts | `fun_facts/world_obituary_screen.js` | 3/4 | 11/29 |
| necro | `necro.js` | 1/1 | 7/13 |
| random_perk | `random_perk.js` | 1/2 | 32/34 |
| retinue_ups | `retinue_ups.js` | 1/3 | 11/31 |
| hackflows_perks, immortal_warriors, retinue_ups | `i_*_levelup_changes.js` | not loaded | 0/3×46 |
| **total** | | **32/51 (63%)** | **319/648 (49%); 319/510 (63%) without the three unloaded copies** |

The three `i_*_levelup_changes.js` are copies of one shared library (LevelUpChanges): with several mods loaded only
the newest copy's JS is registered (`::Hooks.JSFiles` is filtered), here Bro Studio's, whose lines count once.
The two suites alone (Autopilot and Fun Facts only): 13/20 functions (65%), 106/157 lines (68%); never run there:
the slider setting (`onChange`, `updateValue`), `setAIButtonVisible`, the AI button's click callback (tests call
`onAIButtonPressed` on the Squirrel side), Fun Facts' row unbinding when the obituary list is emptied again.

Not reachable without layout or real input, or not exercised: slider settings' `onChange`/`updateValue` (MSU
settings sliders: an `input` event on a range input, triggerable but not tried), drag and drop (inventory), the
campfire slot's Ctrl+click (`ru_notifyBackendSlotCtrlClicked`), hire screen details, loot panel removal, Druid's
`markBlockedPerks` (a perk tree state not set up). Nothing that reads a size or position returns anything but 0.

### Resources

`bench/ui_js.sh` (`bench/measure.py`: wall, CPU of the whole process tree incl. the Node child, peak RSS/PSS of the
tree sampled every 0.2 s), suor-p1, 2026-11-12 11:31–11:38, load average 0.8–1.2 for the single launches and 1–7
during the suites (other agents' jobs). Plain and `--ui-js` alternate run by run on the same CPUs: single launches
on one P-core (`taskset -c 2-3`, 3 runs each), suites on the 6 P-cores (`0-11`, 2 runs each). Includes `bbtest.py`
(~24 MB, its cargo no-op check) and the mod builds. The suites are the files but `ui_*` (both sides the same tests).

| Scenario | CPUs | Plain: wall / CPU / peak RSS (PSS) | `--ui-js`: wall / CPU / peak RSS (PSS) |
| --- | --- | --- | --- |
| menu launch (`b_menu`) | 2-3 | 0.23–0.25 s / 0.23 s / 97 MB (83) | 1.09–1.11 s / 1.28–1.30 s / 302–304 MB (271–273) |
| campaign start (`b_campaign`) | 2-3 | 2.10–2.11 s / 2.08–2.09 s / 139 MB (125) | 3.27–3.30 s / 3.65–3.70 s / 374–377 MB (341–344) |
| campaign + AI battle (`b_battle`) | 2-3 | 2.86–2.89 s / 2.85–2.87 s / 152–153 MB (139) | 10.87–11.02 s / 11.88–12.04 s / 402–412 MB (369–379) |
| fun_facts suite, `-j 8` | 0-11 | 11.9–12.3 s / 73–77 s / 1.31–1.32 GB (1.24–1.25) | 25.1–25.3 s / 172–174 s / 3.38–3.42 GB (2.92–2.97) |
| fun_facts suite, `-j 4` | 0-11 | — | 31.2–31.8 s / 130–132 s / 1.88–1.89 GB (1.67–1.68) |
| autopilot suite, `-j 8` | 0-11 | 25.1–25.6 s / 190–195 s / 1.47–1.49 GB (1.40–1.41) | 85.3–89.8 s / 551–582 s / 3.80–3.89 GB (3.35–3.44) |

Per process: the engine (`bbtest_js`) as plain's `bbtest` (73–129 MB in these launches, up to ~260 MB in the
suites); the Node page 205–260 MB in a launch, up to ~420 MB in the suites. One plain menu run's RSS reads 24 MB:
the 0.2 s sampler missed the 0.23 s engine. From that:

- **Fixed cost per launch**: ~0.85 s wall and ~210 MB (Node start, jsdom parsing `main.html`, ~51k lines of vanilla
  JS run, the mods' JS). A campaign launch takes ~1.2 s more than plain's 2.1 s, so the campaign start itself costs
  the page ~0.3 s.
- **Battles**: ~3.8× plain's wall for `b_battle` (the turn bar's and event log's JS run for every turn and log line,
  each SQ→JS call a round trip to Node). Before the style shims, one unpinned run of Fun Facts'
  `core::AI battle` alone took 67 s with all CSS through jsdom's cascade, 4.7 s with the display rules only.
- **Suites**: fun_facts `-j 8` 2.1× wall, 2.3× CPU, 2.6× RAM; autopilot (battle-heavy) 3.4× wall, 3.0× CPU, 2.6× RAM.
  `-j 4` takes ~45% less RAM (1.9 GB) for ~25% more wall.
- CPU above 100% of wall in single launches: Node's GC and compiler threads beside the lockstep main threads
  (the engine and the page never run JS/Squirrel at the same time).

## Variant 2: headless Chromium

The engine's own Chromium host (`bb-ui`, CEF 154) runs the game's real page — the install's `ui/` and every mod's
`ui/` from the zips — but headless: Chromium's `headless` ozone platform, `--disable-gpu
--disable-gpu-compositing`, windowless rendering with CPU paints (`OnPaint`) copied into memory. No display, no
KWin, no GPU, no DMA-BUFs; frames run as fast as the scripts go. The page talks to the scripts through the same
Coherent bridge as the windowed game (`bridge.rs`, synchronous and nesting both ways), replacing the
`squirrel-bb/src/ui_client/` stubs.

### How to run

```bash
cd ~/projects/bbm/mods/_scripts/bbtest
./bbtest.py --ui-page -j 8 ../../fun_facts/scenarios/*.nut      # any suite with the page
./bbtest.py ../../autopilot/scenarios/ui_page*.nut              # files with `ui=page` in their mode line
```

Engine: branch `bbtest-cef` of `~/projects/bbm/3rdparty/modern-bb-engine`, worktree
`~/projects/bbm/3rdparty/modern-bb-engine-cef` (`BBTEST_UI_ENGINE`); `bbtest.py` copies `engine/bbtest_ui.rs` to its
`bb-ui/examples/` and builds `cargo build --release -p bb-ui --features cef --example bbtest_ui` (CEF's ~1.8 GB
distribution in `target/cef`, copied from the main checkout). Scenario API (`t.js`, `t.untilJs`, `t.shot`) and
pitfalls: README, "The real UI page".

Commits on `bbtest-cef`:

1. `feat(bb-ui): headless host, the page in software and on the game's clock` — `HostConfig::headless`
   (`host/mod.rs`, `paint_sink.rs`'s `MemoryFrame`, `client.rs`'s `on_paint`, `opening.rs`, `app.rs`), and
   `virtual_time.js` injected into the renderer.
2. `feat(bb-ui): bbtest_ui example, the bbtest scenario runner with the real page` — the runner on a headless
   `UiSession` (+ `UiSession::engine_mut`), natives `BBTest_js(code)`, `BBTest_shot(name)`.
3. `fix(bb-ui): the page's game clock covers new Date() and reports pictures loading`.
4. `fix(bb-ui): bbtest_ui runs the scripted player and keeps the page's clock going`.

### Frames and the page's clock

A frame is `UiSession::step_unparked` (park the page, the game's frame, let the page run if it has work — a page
with nothing to do stays parked, no round trip), then the page's clock, then the scripted player (`__autoplay`), then
the test's tick with the page parked. Page frames (layout, paint, CSS animation steps) are begun at most
`BBTEST_UI_FPS` (30) times a real second.

JS timers follow the game's time, not the wall clock (`bb-ui/src/host/virtual_time.js`): once the menu has booted,
`setTimeout`/`setInterval`, `requestAnimationFrame`, `performance.now()`, `Date.now()` and `new Date()` advance only
when the runner calls `__bbClock(gameMs)` after a frame: the timers due by then run in due order (one set meanwhile
waits for the next frame, as Coherent ran a frame's timers), then the animation frames asked for before. So
`setTimeout(f, 500)` fires 30 frames later however fast frames run, and jQuery/Velocity animations (vanilla's
300 ms screen fades) take their 18 frames. Why not real time: uncapped frames run ~30–100× faster than real time (rough estimate from the example battles' timings: ~6000 frames/s headless, ~1700 with the page), so
a fade would span hundreds of frames, differently each run, and waits counted in frames (the runner's, the tests')
would time out before the page answered. Why not DevTools' virtual time: it needs a round trip through the browser
process and an event per frame; the JS shim is one `eval` per frame the page is busy (none while it rests). The
clock is called when a timer is due or the page didn't rest. Not covered: CSS animations and transitions run on
Chromium's clock (vanilla's UI uses none), and real I/O (pictures loading, ~ms): a frame whose clock call reports
pictures loading waits (≤ 2 s real) until their `load` events ran, which made a battle's frame count repeat to ±3
frames (3083/3086 over 3 runs; 1661–3794 before).

### Test hooks and errors

`t.js(code)` evaluates JS in the page through the bridge and returns the value as Squirrel (calls the page makes into
the scripts meanwhile run inline); `t.untilJs(code)` waits for it; `t.shot(name)` saves a PNG of the page (the
memory frame; real pixels, see `work/runs/*/logs/*.png`). Page errors reach the log as `[Error UI] ConsoleAPI ...` /
`[Error UI] JS <url>:<line>: Uncaught ...` and fail the test they happen in (outside tests: the launch). A wait
that times out saves `timeout_<n>.png` and lists the shown screens.

### Results

1. Fun Facts suite (63 tests, 11 launches): **the same statuses** as headless (1 run each, plus 2 earlier page runs);
   no page errors.
2. Autopilot suite (99 tests, 19 launches): 2 page runs gave identical statuses; vs headless 7 tests differ, none a
   mod bug (Autopilot `FOUND_BUGS.md`, "In the real UI page"): 3 time out because the tests act on popups
   mid-fade (the stub shows none) — confirming a popup during its fade-in, or opening the flee dialog during the
   popup's fade-out, leaves vanilla's tactical menu stack with an entry nothing pops, and the battle's end waits on it
   forever; their launches lose their later tests (10 more). 3 AI-battle tests fail on the battle's outcome (the
   fades take frames the stub didn't, so the AI's rolls fall otherwise); run alone, `unbag shield` passes. No page
   errors.
3. JS-level checks, all new files in the mods' `scenarios/`:
   - Fun Facts obituary tooltip as drawn (`fun_facts/scenarios/ui_page.nut`, port of `bbui/examples/fun_facts_obituary.sh`):
     "Remembered | Died once | Chopped 3 heads" — passes.
   - Autopilot buttons in the DOM + the AI button's tooltip (`autopilot/scenarios/ui_page.nut`, port of
     `autopilot_buttons.sh`): one each of AI, wait all, shield wall; "AI Control (Q) | Give control of the party to
     the AI." — passes.
   - **Autopilot KNOWN_BUGS #4 reproduced and explained**: after a tile hover's cost preview, bros with no effects
     show a morale icon left from an earlier actor; without Autopilot (`ui_page_vanilla.nut`) they don't. Cause:
     Autopilot's `showEntityStatusEffectbar` override hides the container without emptying it; patched with
     `.empty()` via `t.js`, the test passes.
   - **Fun Facts KB8 reproduced**: with Career Stats 1.0.2 (Reforged 0.9.3) the obituary row's tooltip shows only
     Fun Facts' "Died once", never Career Stats' "DMG Dealt …" (`fun_facts/scenarios/ui_career_stats.nut`).
4. Engine-side finds on the way, fixed in the runner: the `fresh=1` reload and `t.load` didn't wait for the load
   itself (it starts after the loading screen's fade-in), so tests ran on the old world (README, Runner issues); the
   scripted player (`__autoplay`) has to run after each frame, as `harness::run_frame` does.

### Resources

Measured 2026-11-12 on suor-p1 with `bench/ui_page.sh` (`bench/measure.py`; A/B alternating run by run, each side
pinned with `taskset`: one-launch rows on one P-core, CPUs 2-3; suites on the P-cores, 0-11; median of 3 (min),
suites median of 2). CPU = user+sys of the whole tree incl. Chromium's processes (and KWin's for the KWin rows);
RSS/PSS = peak of the tree's sum, sampled every 0.2 s. Another agent ran bbtest suites meanwhile: load average
7–15 at the starts, so absolute walls are noisy; compare rows of the same block.

| Scenario | Variant | Wall s | CPU s | Peak RSS / PSS | Largest process |
| --- | --- | --- | --- | --- | --- |
| menu launch (`bench/b_menu.nut`), CPUs 2-3 | headless | 0.27 (0.26) | 0.2 | 98 / 81 MB | 74 MB |
| | **page** | 0.70 (0.68) | 0.7 | 598 / 400 MB | 302 MB |
| campaign start (`b_campaign.nut`), CPUs 2-3 | headless | 2.27 (2.22) | 2.2 | 140 / 126 MB | 115 MB |
| | **page** | 3.05 (2.99) | 2.8 | 762 / 531 MB | 383 MB |
| campaign + one AI battle (`b_battle.nut`), CPUs 2-3 | headless | 3.14 (3.03) | 3.1 | 153 / 139 MB | 128 MB |
| | **page** | 8.86 (8.84) | 10.0 | 832 / 585 MB | 407 MB |
| fun_facts suite (63 tests, 11 launches), CPUs 0-11 | headless `-j 8` | 12.7 (12.7) | 88 | 2.07 / 1.76 GB | 450 MB |
| | **page `-j 4`** | 35.8 (33.1) | 113 | 3.59 / 2.10 GB | 526 MB |
| | **page `-j 8`** | 28.6 (28.4) | 142 | 7.04 / 3.80 GB | 532 MB |
| | page `-j 16`, CPUs 0-19, n=1 | 44.3 | 190 | 8.72 / 4.29 GB | 545 MB |
| autopilot suite (99 tests, 19 launches), CPUs 0-11 | headless `-j 8` | 31.1 (31.0) | 233 | 2.66 / 2.05 GB | 422 MB |
| | **page `-j 8`** | 91.9 and 159.6 | 374 | 7.31 / 4.09 GB | 557 MB |
| Fun Facts obituary tooltip check, CPUs 2-3 | KWin + `bb` (`bbui/examples/fun_facts_obituary.sh`) | 5.20 (5.08) | 5.2 | 1.08 / 0.74 GB | 510 MB |
| | **page** (`fun_facts/scenarios/ui_page.nut`) | 3.14 (2.96) | 2.9 | 790 / 556 MB | 401 MB |
| Autopilot buttons + tooltip check, CPUs 2-3 | KWin + `bb` (`autopilot_buttons.sh`) | 6.49 (6.48) | 5.5 | 1.12 / 0.74 GB | 517 MB |
| | **page** (`autopilot/scenarios/ui_page.nut -k buttons`) | 3.38 (3.36) | 2.8 | 836 / 596 MB | 407 MB |

- A page launch is 3 processes (`bbtest_ui` with Chromium's browser, in-process GPU and network; the renderer; one
  more Chromium child), ~0.4 GB PSS at the menu and ~0.55 GB in a battle against 0.08–0.14 GB headless; RSS sums double count
  the shared CEF library, PSS doesn't.
- Boot costs +0.4 s, a campaign start +0.8 s; a battle ~2.8× the wall and ~3.2× the CPU: the page is busy all
  battle (the turn bar animates), so every frame pays the clock `eval` round trip and the page's own work.
- Suites are 2–4× slower at the same `-j` and need ~2× the PSS. Max useful `-j`: CPU-bound, not RAM-bound — PSS
  is ~0.4–0.5 GB a concurrent launch (3.8 GB at `-j 8`; fun_facts has 11 launches, so `-j 16` ran them all at once:
  4.3 GB) against 64 GB; `-j 8` on the 12 P-core threads beat
  `-j 4`, and `-j 16` over all 20 CPUs (n=1, under load 14) was slower than `-j 8`: use `-j 8` here (the 8 launches kept ~5 cores busy). The autopilot page runs (92 and 160 s) are probably bounded by the
  launches that sit out their 30000-frame time-outs (not profiled).
- Against the KWin demo (same checks, same CPUs): ~1.7–1.9× faster and 0.15–0.2 GB less PSS, no GPU, no compositor, and
  any number in parallel (KWin runs are one at a time per KWin).

### What doesn't work / limits

- Speed and RAM: see Resources; headless stays the default, the page is for what only the page shows.
- Tests written against the stub may assume instant screens (see Autopilot's 3 time-outs); `isAnimating()` is real
  now.
- Input: tests reach the page through `t.js` (jQuery `trigger('mouseenter')`, etc.); the host's real mouse/keys
  (`UiHost::mouse_move`, `click`, `key`) aren't exposed to scenarios yet.
- Modern Hooks' error popup (MSU 1.8.0's `IsSpent` boot error) stays open over the page; nothing here clicks it away.
- Determinism: statuses repeat run to run; frame counts can still differ by a few frames (pictures that complete
  without a `load` event are let go after 100 ms real).
