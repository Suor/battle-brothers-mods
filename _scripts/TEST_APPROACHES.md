# Testing BB mods: mocks, code, engine headless, engine + UI

Four ways to test a mod, compared on three of hackflow's mods (Nicknames for Everyone, Fun Facts,
Autopilot New) and the bugs known in them. Measured on suor-p1 (20 cores, load average 5–6 from
other agents' runs) on 2026-11-12; times are wall times.

| | how | where |
| --- | --- | --- |
| **mocks** | the mod in plain `squirrel`, game classes and APIs written by hand per test | `<mod>/test.nut` + `mocks.nut` (`make test`) |
| **code** | the mod + Modern Hooks, MSU, stdlib, other mods on vanilla's compiled scripts (the game's `.cnut`, transcoded by the engine; `--nut`: decompiled) in the engine's Squirrel; only exe natives stubbed | `bbtales.py --env code` on `<mod>/tales/` (`code/`) |
| **engine headless** | Enduriel's modern-bb-engine runs the game (installed `.dat`s) and the mods, UI stubbed | `bbtales.py --env engine` (default) on `<mod>/tales/` |
| **engine + UI** | the engine with the real page in headless Chromium (`bbtales.py --env ui`); earlier, the windowed build in a headless KWin (`bbui/`) | `<mod>/tales/` |

Since 2026-11-12 code, engine and engine + UI run the same scenario files (`~/projects/bbm/bbtales/README.md`, "Envs"): what an env
can't do is a SKIP, `--env all` shows where they diverge. The `<mod>/codetests/` suites the tables below cite were
merged into the scenarios then.

## Overall

| | mocks | code | engine headless | engine + UI |
| --- | --- | --- | --- | --- |
| Setup | none (`squirrel`) | built here (codetest, roughly 3 h); the interpreter builds itself on first run | Rust, engine checkout, ~40 s build (bbtales README), the game's data | `--features ui` build ~2 min (bbtales docs/ENGINE_ISSUES.md), CEF; a KWin + `bwrap` + EGL-vendor arrangement found here (`bbui/README.md`) |
| A new test needs | a mock of every game object and API it touches | a header line; real objects from `::new` and rosters | a header line; real campaign, battles, days, saves | `--at`/`--at-page` scripts, reading back from `log.html`/screenshots |
| Per run | nicknames `make test` 0.07–0.09 s (3 runs); fun_facts / autopilot mocktests 0.005–0.016 s | 0.31–0.36 s boot per file (halved since vanilla is loaded as bytecode, not compiled from text: `~/projects/bbm/bbtales/RESOURCES.md`); nicknames 12 files (50 tests) 3.0–3.7 s, fun_facts 3 files (15) 0.95 s, autopilot 2 files (8) 0.68 s; one file 0.47 s; a save+load of a fresh campaign ~38 ms; a 3-thug battle on Autopilot's AI ~0.5 s | nicknames 47 tests: 19.8 s packed (`-j 8`), 30.7 s `--isolate`; fun_facts 51 tests: 10.1 s packed, ~16 s isolated (fun_facts/tales/README, not measured here); autopilot 80 tests: 23.0 s packed, 31.3 s `--isolate -j 12` | 24.6 s (fun_facts obituary check), 31.4 s (autopilot battle buttons), incl. zipping the mods; frames run in real time at 60 Hz; 4.6 s / 6.2 s since the checks wait on conditions instead of frame counts (`~/projects/bbm/bbtales/RESOURCES.md`) |
| Resources (`~/projects/bbm/bbtales/RESOURCES.md`, "Comparable matrix": the same workloads, CPUs 2-3 for one launch and `-j 1`, 0-11 for `-j 8`, median of 3) | one process; nicknames `make test` (48 tests) 0.06 s, Fun Facts mocktests (9) 0.01 s; 13 MB RSS; 0.001 s CPU a test | one launch 0.4 s (menu, campaign start, save + load; no worldgen), AI battle 4.4 s; battle 124 MB PSS; 0.18 s CPU a test; nicknames suite `-j 1` 10 s, `-j 8` 5.3 s wall and 0.66 GB PSS | menu 0.27 s, campaign start 2.4 s, save + load 2.7 s, AI battle 3.3 s, 86–153 MB PSS; 1.0–1.25 s CPU a test; nicknames `-j 1` 83 s, `-j 8` 22.5 s and 1.2 GB PSS | page in Chromium (`--env ui`): campaign start 3.2 s, 0.4–0.6 GB PSS, 1.5–1.6 s CPU a test, nicknames `-j 8` 33 s and 3.2 GB; in jsdom (`--env jsdom`): 3.7 s, 0.29–0.38 GB, 1.8–1.9 s a test, 34 s and 2.7 GB; KWin demo (`bbui/`): 4.9 s, 0.6–0.8 GB + GPU, the AI battle 155–260 s in real time, one at a time per KWin, no suites |
| Reaches | the mod's own functions | everything script-level off the maps: creating and hiring bros (`setStartValuesEx`, equipment, traits), backgrounds' and items' real data, campaign start (`onSpawnAssets`), events and their screens, hooks of every mod loaded, flags, Squirrel→JS calls (recorded); save/load in memory (rosters, player party, flags, stash, statistics with the fallen, mods' hooks, MSU's metadata); battles on a flat map: placement, `actor.kill`, skills' `use`, injuries, turns, AI agents (vanilla's and mods'), the battle's end with `gatherBrothers` | plus world days, settlements, battles with AI and scripted players, deaths, saves/loads, frames and timing | plus the mods' JS/CSS, tooltips drawn, DOM, screenshots, page errors |
| Doesn't reach | anything the mock doesn't model; hook ordering; other mods | world map and simulation, settlements, UI; battles' terrain, heights, visibility, line of sight, the original's pathfinding and ZOC free attacks; saves across a restart or from the game; Reforged (boots with 21 errors) | the mods' JS/CSS; Russian (`data_014.dat` breaks 1.5.2 boot) | (slow; not wired into a test runner) |
| Fidelity issues | mock drift: `getCurrentProperties()` returns base props (hides N2); a mock passes only what its author believed (F5's mock had to copy vanilla's early return) | vanilla is the game's own bytecode, so no decompiler damage and the original's line numbers (with `--nut`, scripts-base: re-decompiled after each game update, 6 files patched on the fly, 18 with endless `for`s fixed by `base/fix_decompiled.py`; same statuses on every suite); 64-bit ints; xorshift RNG (other rolls than the game) | engine divergences listed in its `parity/`; missing Fangshire DLC shifts RNG; MSU 1.8 `IsSpent` error | same as headless; MSU/Modern Hooks popups to dismiss |
| Maintenance | mocks per mod, rot with game and mod changes | stubs (`natives.nut`) grow when a test reaches a new native; vanilla follows game updates by itself (scripts-base only for `--nut`) | the engine checkout (pull), bbtales runner | as headless, plus the display arrangement (GPU-specific: Intel KWin, Mesa EGL) |

## Nicknames for Everyone

Bugs from `nicknames/tales/FOUND_BUGS.md` and `KNOWN_BUGS.md`. "caught" = a test fails on
the open bug (or fails on the old release for a fixed one). Mocks: the existing `test.nut`;
"targeted" = a mock test could be written for it, but only knowing the bug.

| Bug | mocks | code (`nicknames/codetests/`) | engine headless | UI |
| --- | --- | --- | --- | --- |
| N1 starting bros skip `onHired` | no: needs vanilla's origins never calling it | **caught** `core::N1` (same "picked again 3 times" as the engine) | caught | – |
| N2 armor weight in `getCurrentProperties` | no: the mock returns base props | **caught** `factors::N2` (22 of 30 recruits; engine 21) | caught | – |
| N3a/b/c impossible factor sets | no: needs vanilla's backgrounds and traits | **caught** all three (48 sets, Gramps, 4 trait+attr sets: the engine's lists) | caught | – |
| N4 error in an event screen sticks `inEvent` | targeted | **caught** `events::N4` | caught | – |
| N5 vanilla-rolled event title kept | no | **caught** `events::N5`; also `events::...fitting` fails: a bastard's "the Tarnish" (set in `onAdded` from `Const.Strings.BastardTitles`) is kept and isn't among the mod's candidates at all — the engine's seed didn't roll one | caught (+ Reforged militia start) | – |
| N6 one alias per fallback perk | targeted (the mock has single fallbacks) | **caught** (12 pairs, the engine's) | caught | – |
| KB1 state cache leaks | targeted | **caught** via load (`saves::KB1`, the engine's three asserts) and via a second campaign | caught via load | – |
| KB2 `logOut()` `_key` | targeted | **caught** | caught | – |
| KB3 save broke with Black Pyramid | – | not tried (save/load reachable now; Hardened unavailable) | not reproduced | – |
| KB4 regression (King's Guard, no talents) | covered at unit level (empty `m.Talents`; not run on 0.7.0) | **fails on 0.7.0 / 0.7.1** with the users' `the index '0'` | fails on 0.7.0 / 0.7.1 | – |
| KB5 regression (no `m.Titles`) | covered at unit level | **fails on 0.7.0** (`'Titles'`) | fails on 0.7.0 | – |
| KB6 regression (Legends' 4 params) | no (the warning comes from Modern Hooks) | **fails on 0.5.1** with the users' Modern Hooks message | regression test passes (not run on old zips) | – |
| KB7 regression (no stdlib) | no | **fails on 0.5.2** (no dependency popup) | regression test passes (not run on old zips) | the popup itself |

False positives: code: none since scripts-base was refreshed to 1.5.2.3 (2 before: it predated
the Executioner background). Engine: none known.
Nicknames has no UI of its own; UI testing adds only how titles show (Rosetta's Russian,
long titles in the roster).

## Fun Facts

Engine results from `fun_facts/tales/FOUND_BUGS.md` (another agent's suite, run here:
51 tests, 16 failures/problems). Mocks: `fun_facts/mocktests/test.nut` (new, ~15 min to write,
roughly; it needed two extra rounds of mocks when `buys.nut` reached `::mods_getMember`). Since deleted as
a duplicate of the scenarios, archived in `~/projects/bbm/fun_facts_mocktests.tgz`.

| Bug | mocks | code (`fun_facts/codetests/`) | engine headless |
| --- | --- | --- | --- |
| F1 struck-down bro counted twice | no | **caught** in a battle (`battle::F1`, `[1, 1]` as the engine) | caught |
| F2 gutted/smashed swapped | **caught** (tooltip of kill records) | **caught** (same, real FunFacts over vanilla; and through a real kill in a battle) | caught through real kills |
| F3 destroyed shield charged as parts | no | no (battle, GC timing) | caught |
| F4 battle id cache | **caught** (mocked roster/fallen) | **caught** via load (battles stood in by `onCombatEnd`) and via a second campaign | caught via load |
| F5 food charged when nothing eaten | caught only because the mock copies vanilla's early return | **caught** (real `asset_manager.consumeFood`) | caught |
| F6 plurals of one | **caught** | **caught** | caught |
| F7 error on deaths without killer | **caught** (unit) | **caught** (unit; and through `kill(null)` in a battle) | caught through `kill(null)` |
| F8 pre-v3 suicide → friendly fire | **caught** (unit) | **caught** (unit; and through save/load, the engine's asserts) | caught through save/load |
| KB2 scenario-mode kill | no | no (tactical) | caught |
| KB3 attacker-less injury | **caught** (unit) | **caught** (unit) | caught through a real hit |
| KB4 fallen without facts on load | no | **caught** (`saves::KB4`, the user's error on every load) | caught |
| KB9 hint capitalization | **caught** | **caught** | caught |
| KB10–13 regressions | – | KB10 passes through save/load (a blob over one flag string); others not tried | pass (regression guards) |

Only UI testing reaches (Fun Facts' `ui/mods/fun_facts/world_obituary_screen.js`, `fun_facts.css`):
the obituary rows' MSU tooltips — bound per row with `FunFacts_Idx`, unbound when the list is
emptied (a wrong index shows another bro's facts, a missed unbind stacks tooltips); the
`msu-generic` tooltip actually rendering the hint list; the `[img]gfx/fun_facts/*.png[/img]`
icons in the costs line loading; long hints and Russian text fitting the tooltip. Demonstrated:
`bbui/examples/fun_facts_obituary.sh` opens the obituary with a fallen bro carrying facts,
hovers the row, and reads "Remembered | Died once | Chopped 3 heads" from the drawn tooltip.

## Autopilot New

Engine results from `autopilot/tales/FOUND_BUGS.md` (another agent's suite, run here: 80
tests, 17 failures/problems, same on the released 2.9.0). Mocks: `autopilot/mocktests/test.nut`
(new). Code: `autopilot/codetests/` — `core.nut` (behaviors instantiate and register,
`enableAIControl()` builds the ranged agent with Autopilot's behaviors on a real archer, the
quiver swap scores) and `known_bugs.nut` (A1, A2, A4, A5 on the hooked `tactical_state`,
`turn_sequence_bar`, `tooltip_events` and vanilla's `ai_attack_default`, called off the map).

| Bug | mocks | code | engine headless |
| --- | --- | --- | --- |
| A1 number key on a non-player ally: `querySwitchableItems` | targeted (an entity mock without the method) | **caught**, same error | caught |
| A2 AI button with a non-player ally: `isGuest` | targeted | **caught** (`canAuto`), same error | caught |
| A3 bro charmed when AI pressed stays manual | no | **caught** in a battle on AI (`battle::A3`, same assert; its control passes) | caught |
| A4 NaN attack weight with a negative score | no: the choice is vanilla's `selectBestTargetAndSkill` | **caught** (the engine's stub-skill test ported as is: `{bad = 50}`) | caught |
| A5 skill tooltip for a gone entity: `getItems` | targeted | **caught**, same error | caught |
| KB1 `getAmmoType` in swap-quiver | **caught**, but only because the mock throwing item leaves out `getAmmoType` as vanilla's does | **caught** with real items (`throwing_axe`), the users' error; in a battle too: the error out of every update, the archer's turn never ends | caught (the turn never ends) |
| KB2 quick switch off still swaps | no | not done: the swap goes through the character screen, which reaches the tactical navigator, entities and tiles (3 rounds of stubs, then stopped) | caught |
| KB3 Recover bypasses Unstoppable (Reforged) | no | no (turn end, Reforged) | caught |
| KB4 stale status icons | no | no | not reproducible headless (JS-side): UI only |
| KB5 AI with a skill selected (partly) | no | no (tactical state in battle) | partly caught |
| KB6 quick switch on a non-player ally: `getPerkPoints` | targeted | not done (as KB2) | caught |
| KB9 `ActorFake` lacks `isTurnDone` (partly) | targeted | reachable (`fixes.nut`'s class), not written | partly caught |
| KB10 wait-all popup stuck (a mechanism) | no | no (menu stack + async popup) | partly caught; the popup's keys are UI |
| KB31 division by zero in attack scoring | no | no | not reproduced (a float division in vanilla) |
| AI turns, behaviors' choices, hotkeys, wait-all/shield-wall, regressions #12–#35 | no | a battle on AI runs to the end (`battle.nut`); choices that hang on paths, heights or visibility only on a flat, all-visible map; the rest not ported | covered (`core.nut`, `behaviors.nut`, `edge.nut`, stress battles) |

Autopilot is a combat mod: its behaviors evaluate tiles, ZOC, paths. Off the map the code
approach covers setup and the parts of `onEvaluate` before the map queries (a test replaces
those queries); the rest is the engine's. Only UI testing reaches (`ui/mods/autopilot_new.js`,
`slider_setting.js`): the five turn bar buttons the JS adds and the skills bar it shifts left
(`-18.3rem`, which other mods' buttons can overlap), their tooltips' bind/unbind, the
visibility toggles (`setAIButtonVisible`, `setWaitTurnAllButtonVisible`), the keyup handler it
adds to `DialogScreen` (Enter/Esc; KNOWN_BUGS #10, an unresponsive wait-all popup), the status
bar fix in `showEntityStatusEffectbar` (KNOWN_BUGS #4, the previous actor's icons shown), and the
slider setting element in MSU's settings. Demonstrated: `bbui/examples/autopilot_buttons.sh`
starts a battle, finds the AI, wait-all and shield-wall buttons in the DOM, hovers AI and reads
"AI Control (Q) | Give control of the party to the AI." from the drawn tooltip.

## Save/load bugs of other mods

Ported to `<mod>/codetests/` from the engine suites (`<mod>/tales/`), all on `::CT.save`,
`::CT.load`, `::CT.saveLoad`:

| Bug | code | engine headless |
| --- | --- | --- |
| Retinue Promotions RU-KB1 promotion kept after loading an older save | **caught** (`saves::RU-KB1`, the same object, the engine's assert); RU-KB2 within a session passes, as there | caught |
| Elite Few EF1 master strength doubles after a load | **caught** (`saves::EF1`: `[2.56, 5.12, 5.12]`, the engine's isolated run); the control without Elite Few gives `[1, 2, 2]` as there | caught |
| Camps & Artifacts CA-KB1 fencing sword through MSU's serialization emulator (Reforged) | **caught** (both tests, the users' error word for word); the real-save round trip of every artifact passes, as there (`writeU8(-25)` truncates, the 3.5.1 remap reads it back) | caught |

What it took (2026-11-12): `~/projects/bbm/bbtales/code/saves.nut` (~300 lines: streams, metadata, `World.save`/`load`,
`PersistenceManager`, world entities), the real `player_party` instead of a stand-in, mod_hooks'
root-state hook (so `mods_hookNewObject("states/world_state")` and `onCampaignLoaded` fire), a
few `World` natives. Nothing in the existing suites changed results.

## Battles in code: spike (2026-11-12)

`~/projects/bbm/bbtales/code/tactical.nut` (~350 lines) and `::CT.startBattle`/`::CT.battleFrame`: a flat 32×32
map, vanilla's tactical_state, placement, turn bar, kills, skills, AI turns, battle end. ~70
natives modelled, 49 more no-ops seen in an AI battle; the turn bar's JS had to be emulated
(turns start from JS callbacks), the AI's background task called each frame, and the
decompiler's endless loops in 18 AI-related files fixed in scripts-base (`base/fix_decompiled.py`).
Caught: Fun Facts F1, F2, F7 (`fun_facts/codetests/battle.nut`), Autopilot KB1 and A3
(`autopilot/codetests/battle.nut`), each with the engine's assert; the controls pass. A battle
of the company on Autopilot's AI against 3 thugs takes ~0.5 s (3 rounds). Fidelity is below the
engine's: flat terrain, everything visible, the shortest path instead of the original's A*,
moves without free attacks, event delays ignored, no return to the world map; so outcomes,
AI choices of tiles and anything about positions aren't the game's.

## One suite, three envs (2026-11-12)

`bbtales.py --env code|engine|ui` runs the same `<mod>/tales/` files (bbtales README, "Envs"); the codetests were
merged into them, each bug they caught still failing in `--env code` (Fun Facts' bare-`unpack` F8 unit test aside:
it couldn't pass with any fix, the save/load F8 test covers the fix). All suites, `--env code,engine` (1135 tests incl.
examples; pass/fail/skip): code 297/52/212, engine 480/87/7; the skips in code are `t.days`, settlements, Legends,
Hardened and Reforged 0.9 files. Divergences left: Autopilot's stress battles vs Schrats, Lindwurm, Vampires (stub
gaps in code); Fun Facts F3 passes in code (GC timing); Nicknames N8 fails only in code (a companion the engine's
seed doesn't roll). Nicknames suite, `-j 8` on CPUs 0–11, 3 alternating runs: code 5.1–5.3 s, engine 25.6–26.7 s,
ui 35.1–41.5 s.

## Recommendation

1. **Code** first for logic that lives off the world map: generation, hiring, events, factors,
   tooltips' texts, economy, setup of behaviors, **save/load** (state caches, serialization
   hooks, flags; all 7 save/load bugs of the engine suites caught) and **battle logic that
   doesn't depend on terrain** (kill/death accounting, turn flow, AI turns ending, errors out of
   the update: F1, F2, F7, A3, KB1). It catches what mocks can't in ~0.5 s a file, with tests
   written as for the engine (same header, same helpers).
2. **Engine headless** for what depends on the map and the world: positions, paths, visibility,
   AI choices, retreat, world days, a restart between save and load, GC timing (F3, Autopilot's
   KB2/3/5/10, behaviors' choices, stress battles) and as the judge before a release; 10–31 s a
   suite. For a combat mod like Autopilot it stays the main tool; code now catches 6 of the 12
   bugs its suite reproduces (A1–A5, KB1).
3. **Mocks** only for pure functions with data in, data out (tooltip texts, unpacking,
   aliases); they're the fastest but catch a bug only if the mock's author already modelled
   the cause.
4. **Engine + UI** for the mods' JS: a handful of checks per mod with UI (obituary tooltips,
   turn bar buttons, dialogs), run before releases; ~5–6 s each when they wait on conditions.
