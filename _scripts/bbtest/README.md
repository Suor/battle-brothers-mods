# bbtest — headless scenario tests for BB mods

Runs mods in the real game logic, headless, on Enduriel's
[modern-bb-engine](https://github.com/Enduriel/modern-bb-engine) (a Rust reimplementation of
the BB engine running the game's own Squirrel scripts). A scenario file holds `test(...)`
functions; they run at the main menu or in a fresh campaign, can wait for frames, world days
and scripted battles, and report probes, assert failures and every script error with its stack.
The same files run in four envs (`--env`, see Envs): `code` (codetest's interpreter, seconds),
`engine` (the default), `jsdom` and `ui` (the engine with the real page in jsdom or in Chromium).

```bash
cd ~/projects/bbm/mods/_scripts/bbtest
./bbtest.py examples/*.nut                       # all, launches in parallel
./bbtest.py --env code ../../nicknames/scenarios/*.nut      # the same files in codetest's interpreter
./bbtest.py --env all ../../fun_facts/scenarios/*.nut       # code, engine and ui: a status matrix
./bbtest.py -k "roster names" examples/nicknames_campaign.nut   # tests whose name contains this
./bbtest.py --isolate examples/battle.nut        # one game launch per test
./bbtest.py -r mod_reforged==0.9.2 ...          # another version than the headers pin (see Mods)
./bbtest.py -r mod_reforged==0.9.2 -r mod_reforged==0.9.3 ...   # a run per version, statuses compared
./bbtest.py -r '*@latest' ...                    # compat run: every third-party mod at its newest
./bbtest.py --lock work/runs/<stamp> ...         # exactly the mod files of that run (its mods.lock)
./bbtest.py -v ...                               # also warnings and log rows
./bbtest.py --keep-saves ...                     # keep saves/ of passed launches too
./bbtest.py --no-stable-rng ...                  # battles draw from the real time, as the game does (see Isolation)
./bbtest.py --snapshot ...                       # load saved campaign starts instead of worldgen (see Speed)
./bbtest.py --draws ...                          # log every draw with its call site (see Determinism across envs)
```

Exit code 1 when any test fails or errors, a launch crashes or times out, or a script error
happens outside tests (boot, mod loading, campaign start) that `known_errors.txt` doesn't list
(`--allow-boot-errors` lets those pass).

## Envs

`--env code|engine|jsdom|ui|game` (default `engine`; several comma-separated, or `all` for the first four) picks what runs
the files:

| Env | What | A suite takes | Can't do (SKIP) |
| --- | --- | --- | --- |
| `code` | the game's compiled scripts, the mods (`.nut` and `.cnut`) and `bbtest.nut` in codetest's plain interpreter (`../codetest/`, its `scenario.nut` drives the tests frame by frame): stubbed natives, the real root, main menu, world and tactical states, no world map | seconds | `t.days` (no world simulation), settlements and other world-map parts, battles off `tactical.plains`, main-menu scenario battles, multi-tile entities, `t.js`/`t.untilJs`/`t.shot`, Legends, Hardened (don't boot) |
| `engine` | modern-bb-engine headless | ~10 s–1 min | `t.js`/`t.untilJs`/`t.shot` |
| `jsdom` | the engine with the real page in jsdom under Node (`--ui-js` is the same; see "The UI page in jsdom") | ~engine to a few × engine | — (`t.shot` gives null) |
| `ui` | the engine with the real page in headless Chromium (`--ui-page` is the same) | ~3× engine | — |
| `game` | the original game under Proton, headless, through the user's Steam client (The original game) | ~45 s a campaign launch, one launch at a time, battles in real time | `t.js`/`t.untilJs`/`t.shot` |

What an env can't do raises `::BBTest.Unsupported("<what>")`: the test ends as **SKIP** with that reason, not
FAIL (an assert that failed before still makes it FAIL). A test can raise it itself, `t.skip("<what>")`, e.g. for a
helper that finds a seed's brother by name. `t.env` is the env's name.

Where an env formally runs something but is known to be inaccurate, the test declares what it needs, and envs
lacking it SKIP it: `test(name, fn, {needs = ["worldgen"]})` for one test, `// needs: worldgen` in the header for a
file (not launched at all there). Needs and the envs that have them:

- `worldgen` (engine, ui, game): a generated world: settlements, the seed's starting roster (names, backgrounds, items),
  world parties. Code starts the origin without a map, with other rolls.
- `map` (engine, ui, game): a real battle map: terrain, heights, line of sight, the original's pathing; AI choices of
  tiles and battle outcomes that hang on them. Code's battles are on a flat 32×32 map.
- `page` (jsdom, ui): the UI page of either kind: `t.js`, `t.untilJs`, `t.hover`; a page test runs in both and asks
  only what both do. `ui` (ui): Chromium's page (`ui=page` in a mode line means the same), for what jsdom lacks
  (layout, paint); `jsdom` (jsdom): the jsdom page (`ui=js`).
- `ct` (code): codetest's own helpers, `::CT` and `::__CT` (README there), e.g. `::CT.setDay`; for what other envs
  do on their own, use the API (`t.newCampaign` rather than `::CT.startCampaign`).
- `legends`, `hardened` (engine, ui, game), `reforged9` (all): implied by those mods in the header (Legends and
  Hardened don't boot in code; Reforged 0.8.18 and 0.9.3 boot there without errors).

Code runs a launch as the engine does: the root state and the main menu, one campaign started from it (or the
menu) for its files, the tests in order, `fresh=1` reloads
(an in-memory save), `t.battle` on the flat map with the scripted player's autoplay (the AI plays the company with
`fight`, `player` called every frame), `t.save`/`t.load` (at once), `t.frames`/`t.until` (a frame is 1/60 s of the
clock and scheduled events, or a battle frame), log rows and script errors reported the same. Its RNG differs from
the engine's, so rolls differ: assert behaviour, not one seed's luck.

`--env all` (or two or more) ends with a matrix: per mod pass/fail/skip in each env, then the **divergences**,
tests that pass in one env and fail in another. A divergence is a stub's inaccuracy (code), a map- or
timing-dependent outcome, or a bug that shows only in one: look at each. `<run dir>/statuses.json` has every
test's status per env, `skips.json` the reasons of its skips. `coverage_update.py <run dir>` derives
`coverage.json`'s per-env statuses of the bugs from them and refreshes `report.html`'s copy.

Workflow:

1. Edit, then `--env code` on the mod's suite: seconds, catches what is logic.
2. Before a commit, `--env engine` (the default) on the suite.
3. Before a release, `--env ui` on the files that touch the UI (or `--env all` on the suite) and read the
   divergences.

## Layout

- `bbtest.py` — the driver: builds mods, packs scenario files into launches, runs them, reports.
- `bbtest.nut` — loaded into every launch first: the test registry, scheduler and helpers.
- `engine/bbtest.rs` — the engine side, an example binary of `bb-engine`. `bbtest.py` copies it
  into the checkout (`bb-engine/examples/bbtest.rs`, a new file there) and rebuilds it when it
  differs. Edit this copy, not the checkout's.
- `engine/bbtest_ui.rs` — the same with the real UI page (`--ui-page`, see below), copied into the
  `bbtest-cef` checkout's `bb-ui/examples/`.
- `known_errors.txt` — regexes of known boot errors that don't fail a run.
- `bench/` — `ui_page.sh` (the page against headless, `UI_VARIANTS.md`), `measure.py` (wall, CPU, RSS/PSS of a command's process tree) and the launches measured in
  `RESOURCES.md` (`b_*.nut`).
- `examples/` — `menu_smoke.nut`, `nicknames_campaign.nut`, `battle.nut`. The first two each
  have one deliberately failing test, to show how failures and errors are reported, so
  `./bbtest.py examples/*.nut` exits 1.
- `probes/` — `repeat.sh FILE N [options]` runs a scenario as N launches and diffs their `STATE`/`RNG` log rows;
  `start_state.nut` dumps the campaign start (see Isolation); `parity/` the battles and days compared draw for draw
  across envs (Determinism across envs).
- `rngdiff.py RUN_A RUN_B` — where two runs of the same tests part: the first differing draw, both call sites.
- A full suite using the features below: `~/projects/bbm/mods/nicknames/scenarios/`.
- `store.py` — mod specs, the mod store and the resolver (Mods).
- `mods/` (part of the mod store: third-party zips the service's sources lack, e.g. Legends' assets; what each is and
  where it came from: `mods/VERSIONS.md`; `mods/registry.toml`, the hand facts of the resolver), `work/` (built mod
  zips, the shadow data dir, `runs/`, `patched/`, `store/` and `store_index.json` (the store's index),
  `snapshots/`, `walls.json`) — not in git.
- `thirdparty/` — smoke tests of the third-party mods themselves (Reforged 0.9, Hardened, Crock Pot, Black
  Pyramid, Clever Recruiter, Legends, Stronghold, SSU, NgGH) on the engine, `lib/tp_smoke.nut` their shared body.

The engine checkout is `~/projects/bbm/3rdparty/modern-bb-engine` (`BBTEST_ENGINE` to change).
It builds with Arch's stable cargo 1.99: `RUSTC_BOOTSTRAP=1 cargo build --release -p bb-engine
--example bbtest` (the pinned nightly isn't needed: its one feature, `c_variadic`, is stable
since 1.99; `RUSTC_BOOTSTRAP` only lets the leftover `#![feature]` line through). The first
build takes ~40 s, `bbtest.py` does it when needed. To update the engine: `git pull
--recurse-submodules` there; the example file is untracked, so it survives.

## What a launch does

1. Mounts only the game's `data_*.dat` (through `work/gamedata/`, symlinks to the Steam
   install minus `BBTEST_SKIP_DATS`, default `data_014.dat`, see Engine issues) and the
   launch's mod zips. Never the zips in the game's data dir. Saves and `log.html` go to the
   launch's run dir; nothing is written to the game's dirs or the original's savegames.
2. Boots the main menu, loads `bbtest.nut`, the engine's scripted player
   (`bb-engine/tests/testdata/scripted_player.nut`) and each scenario file (each compiled on
   its own, with the game's f32 float math; a compile error is reported with file:line and the
   other files still run).
3. Campaign mode: runs the `beforeCampaign` functions, presses New Campaign → Start with the
   seed and origin (MSU's new-campaign settings screen, if shown, is saved as is), answers the
   origin's intro event, pauses the world.
4. Runs the tests one after another, one scheduler step per frame (1/60 s of game time).

The run dir (`work/runs/<stamp>/<n>/`) keeps `events.log` (every log row, script error and
runner line), `logs/log.html` in the original's format (`../parse_log.py` and
`../bb_log_errors.py` read it), `saves/`, `stderr.txt` and the wrapped scenario files. The
last 20 invocations are kept. `saves/` (6.5 MB a save) is deleted once the launch is reported, unless it
failed (a test, a crash or a boot error) or `--keep-saves` is given; snapshots (`work/snapshots/`) stay.

## Scenario files

```squirrel
// mode: campaign seed=my-seed origin=scenario.early_access fresh=1
// mods: mod_nicknames mod_msu

beforeCampaign(function () {
    ::BBTest.Campaign.companyName <- "Probe";                         // new-campaign settings
    ::getModSetting("mod_autopilot_new", "nets").set(false);          // MSU settings
});

test("roster names", function (t) {
    local names = [];
    foreach (bro in t.roster()) names.push(bro.getName());
    t.probe("names", names);
    t.eq(names.len(), 3, "company size");
});

test("after a battle", function (t) {
    yield t.battle({spawn = "BanditRaiders", resources = 60});
    t.eq(t.result.survivors.enemies, 0, "won");
    yield t.days(2);
    t.ok(::World.getTime().Days >= 3);
});
```

Header (first 10 lines):

- `// mode: menu` (default) or `// mode: campaign` with optional `seed=` (default `bbtest`),
  `origin=` (a scenario ID, default `scenario.early_access`), `fresh=1` (see Isolation),
  `launch=NAME` (files that differ only in it run in separate launches, in parallel: for
  splitting a long suite with one setup).
- `// mods: SPEC ...` — the mods of the launch, as mod specs (Mods). The file's own mod (the dir its `scenarios/`
  is in) is built from the working copy; every other from the mod store, with what each requires.
- `// include: lib/helpers.nut ...` — files (relative to the scenario file) loaded into the
  launch before it, once per launch however many of its files name them: shared helpers.
  Keep them out of the glob you run (a subdir), or they become a launch of their own.
- `// needs: worldgen map ...` — what the file's tests need beyond the API: envs lacking one don't launch the file
  and report its tests as SKIP (Envs). One test: `test(name, fn, {needs = ["map"]})`.
- `// allow-errors: REGEX` (repeatable) — errors outside tests matching it don't fail the
  launch, like `known_errors.txt` but for this launch only: for a test of an expected boot
  error (e.g. a missing dependency).

Files with the same header share one launch; a test's full name is `<file stem>::<name>`.
In a file, `test` and `beforeCampaign` are locals bound to `::BBTest.test` and
`::BBTest.beforeCampaign`; everything else is plain game Squirrel (use `::` for globals).
Top-level code runs at the main menu, before the campaign exists: only register there.

A test function is plain, or a generator when it contains `yield`. Each `yield <wait>`
suspends it until the wait is over; it then continues in a later frame. An uncaught error
ends the test as ERROR (its stack and locals are in the report); the next test still runs.

### The test context `t`

Asserts log a failure line with file:line and carry on (they return true/false):

| | |
| --- | --- |
| `t.eq(actual, expected, msg = null)` | deep equality for arrays and tables, `==` otherwise |
| `t.ok(cond, msg)` | |
| `t.near(actual, expected, eps = 0.001, msg = null)` | floats |
| `t.throws(fn, substring = null)` | `fn` must throw (an error containing `substring`) |
| `t.fail(msg)` | |
| `t.probe(key, value)` | a `PROBE key = value` line in the report (values printed by `::BBTest.repr`: sorted tables, quoted strings) |
| `t.log(msg)` | shown in the report |
| `t.roster()` | `::World.getPlayerRoster().getAll()` |
| `t.save(name)` | save the campaign under `name` (to the launch's `saves/`) |
| `t.result` | what the last wait produced (a battle's outcome) |
| `t.env` | `"code"`, `"engine"`, `"jsdom"`, `"ui"` or `"game"` (Envs) |
| `t.state` | a table of the test's own, empty at its start: state for its callbacks (Writing scenarios: pitfalls) |
| `t.skip(what)` | end the test as SKIP: this env can't do `what` (raises `::BBTest.Unsupported(what)`) |

Waits, each `yield`ed:

| | |
| --- | --- |
| `t.frames(n)` | `n` frames (1/60 s of game time each) |
| `t.until(fn, maxFrames = 600, desc = "a condition")` | until `fn()` (or `fn(t)`) is true; a test error after `maxFrames` |
| `t.days(n, opts = null)` | run the world map for `n` days (fractions fine), then pause it again. `opts`: `quiet = true` (the company can't be attacked meanwhile), `speed = 4.0` (16 works too: 15 days in ~5900 frames, ~4 s). Unpauses again after events (they're answered, see `::BBTest.Autoplay`) and holds the speed. A day is ~1600 frames ≈ 0.5 s at speed 4. On a timeout it reports the day, pause and event state. |
| `t.load(name)` | load a save made by `t.save(name)`; back on the world map, paused. Takes ~270 frames (the world ignores a load within 4 s of the last). Root-table globals survive, as in the game. |
| `t.battle(opts = null)` | a scripted battle next to the company, back on the world map when it yields (see below) |
| `t.newCampaign(opts = null)` | quit to the main menu and start a new campaign through it, as a launch starts its own: past the origin's intro, paused. `opts`: `origin = "scenario.early_access"`, `seed = "bbtest-new"`. Saves made before stay. Code starts it at once (`::CT.startCampaign`). Later tests of a `fresh=1` launch still reload the launch's first campaign |

`t.battle` options: `spawn = "BanditRaiders"` (a `::Const.World.Spawn` key) with
`resources = 100`, or `entities = [{ID = ::Const.EntityType.BanditThug, Variant = 0, Row = 0,
Script = "scripts/entity/tactical/enemies/bandit_thug"}, ...]` (`Faction` defaults to the
`faction`'s); `faction = "Bandits"` (a `::Const.FactionType` key); `terrain =
"tactical.plains"`; `setup = function (_props) {}` to change the combat properties;
`maxFrames = 36000`. Who plays the company:

- `fight = true` (default): the AI, a `military_melee_agent` per brother. `retreat = false`
  (default) stops it from walking off the map: vanilla's player-faction AI is the
  auto-retreat one and otherwise leaves early.
- `fight = false`: the brothers end their turns at once.
- `player = ::__botTick`: the engine's scripted player plays the company through the real
  input paths (mouse clicks on tiles, turn bar buttons): waits once, uses its first usable
  attack on the nearest enemy (`::__botPrefer = ["actives.x", ...]` first), else walks up to it.
  Or any function of your own, called every battle frame, given the test's `t` if it takes an argument
  (`function (t) {}`). (`::__botTick` isn't in code: SKIP there.)
- `enemyRetreat = "end"` (default) answers vanilla's "The Enemy Retreats" dialog with "It's
  over"; `"chase"` with "Run them down!". Unanswered, it holds the battle forever.

Brothers who fall die as a player's brothers do (off the roster, items released). After the
yield, `t.result = {result, frames, survivors = {player, enemies}}`: `result` is
`::Const.Tactical.CombatResult` (None 0, EnemyRetreated 1, EnemyDestroyed 2, PlayerRetreated 3,
PlayerDestroyed 4); `survivors` are counted as the battle ended. A battle takes 1000–5000
frames, 0.1–1 s.

### `::BBTest`

- `::BBTest.Campaign` — overrides of the new-campaign settings the menu's Start sends
  (`companyName`, `banner`, `combatDifficulty`, `economicDifficulty`, `budgetDifficulty`,
  `ironman`, `explorationDifficulty`, `lateGameCrisis`, `permanentDestruction`, `seed`,
  `origin`); set them in `beforeCampaign`.
- `::BBTest.Autoplay = true` — on the world map, events are answered
  with their first button. Set false to handle `::World.State.getEventScreen()` yourself.
- `::BBTest.inBattle()`, `::BBTest.inWorld()`, `::BBTest.survivors()`, `::BBTest.repr(v)`,
  `::BBTest.equal(a, b)`.
- `::BBTest.ctx()` — the current test's `t`, for code that isn't given it.

### Helpers: `::BBT`

`bbtest.nut` holds the helpers every mod's scenarios need, the same in every env; a mod's `scenarios/lib/` keeps only
its own (Autopilot's `::APT.pilot`, Nicknames' `fillTitle` spies, ...). Bros:

| | |
| --- | --- |
| `::BBT.toughen(bros = null, repair = false)` | the roster (or `bros`): +60 melee and ranged defense, +200 HP, +30 melee and ranged skill, +200 resolve, at full HP; `repair`: gear at full condition (then a battle's wear is the repair it needs) |
| `::BBT.byId(id)`, `::BBT.byName(name)` | a bro of the roster, or null |
| `::BBT.hire(background = "farmhand_background", place = null, name = null)` | a new bro in the company, made as a settlement makes recruits |
| `::BBT.recruit(background = "farmhand_background")` | a recruit outside the company (a roster of its own), to inspect what a background rolls |
| `::BBT.equip(bro, item)` | equip an item or a script's, unequipping what holds or blocks its slot (a two-hander, a shield); throws if it won't go on |
| `::BBT.thugs(n, row = 0)`, `::BBT.unit(type, script, row = 0)` | `t.battle` entities: bandit thugs; one `::Const.EntityType[type]` of `scripts/entity/tactical/<script>` |

In battle:

| | |
| --- | --- |
| `::BBT.hostiles()` | living units hostile to the company (not allies, its animals or its summons) |
| `::BBT.attack(actor)` | its first attack skill, a strong reference as `kill()` wants |
| `::BBT.killAll(killer = null, fatality = None)` | every hostile killed by `killer`'s attack (a living bro by default: mods hooking `kill()` want a killer), again for any a death brings in |
| `::BBT.freeNear(actor, except = [])`, `::BBT.freeTile(used)` | an empty tile next to the actor (IDs in `except` excluded); the first empty one of the map's middle not in the table `used` (added there) |
| `::BBT.spawn(script, tile, faction)` | an entity on the tile, with its random equipment |
| `::BBT.scripted(steps, killer = null, until = null)` | a `t.battle` `player`: runs `steps` (a function or an array) one per frame while a player turn is on, a step returning false is retried; then ends the company's turns for good, or, with `killer`, until `until()` holds and then `::BBT.killAll(killer())`. Steps, `killer` and `until` may take `t` |
| `::BBT.wait(n)` | a step of `::BBT.scripted` waiting `n` frames |

Settings and errors:

| | |
| --- | --- |
| `::BBT.set(setting, values, raw = false)` | MSU settings (`setting(name)` gives one) set to `values`; returns the function restoring them. `raw` sets `Value` directly (sliders keeping a chosen element of their `Values`) |
| `::BBT.with(setting, values, fn, raw = false)` | `fn()` with the settings set, restored after, also when it throws |
| `::BBT.catchErrors(out)` | `::logError` messages collected into the array `out` instead of logged, until the returned function is called |
| `::BBT.dropErrors(text)`, `::BBT.tolerateRfAI()` | `::logError` messages containing `text` (Reforged's AI noise, Engine issues) dropped, until the returned function is called |

## Mods

A spec names a mod by the id its preload registers, as pip names a package:

| | |
| --- | --- |
| `mod_reforged` | the newest release in the store (pre-releases, `-dev`/`-beta`, only when named) |
| `mod_reforged==0.9.3`, `mod_reforged~=0.9`, `mod_msu>=1.8,<1.9` | a version spec; `~=0.9` = the newest 0.9.x, `~=0.9.3` = >=0.9.3 and 0.9.x |
| `mod_breditor[legends]`, `mod_reforged[russian]==0.8.18` | a variant: builds sharing an id, told apart by file name (`registry.toml`) |
| `mod_nicknames@dev` | the user's working copy (`~/projects/bbm/mods/<dir>`, `stdlib`, `rosetta`), built into `work/built/<prefix>_<version>.zip` as `make zip` names releases |
| `mod_reforged@latest` | the newest of any kind, pre-releases too |
| `mod_legacy@nexus:972/8336`, `mod_msu@sha:617af64b` | that Nexus file, that zip |
| `!stdlib` | never mounted, though required: a missing-dependency test |
| `mod_ap_probe` | a test-only mod dir next to the scenario file (`scenarios/mod_ap_probe/`), zipped as is |

The store: `mods/*.zip` and the service's collected zips (`~/projects/bbm/service/sources/`: `gh_assets/`, `nexus/`,
`local/`, `discord/` with their `*.jsonl` indices), read once into `work/store_index.json` (ids, versions and
requirements per zip, by path, size and mtime). Of the same id, variant and version the first wins: `mods/`, GitHub,
Nexus, local, Discord. Files named `*_TMP*` are local builds, not releases. The user's own mods count as released only
from Nexus, GitHub, `mods/`, or a local file named as `make zip` names a release (`mod_<MOD_NAME>_<version>.zip`), not
`_MODIFIED`/`_FIX1` builds.

Resolving a launch:

1. Each header spec picks one entry; the scenario's own mod, named bare, is its working copy. `-r SPEC` (repeatable,
   several specs in one argument fine) replaces the header's spec of that id, or adds it: `-r mod_autopilot_new==2.9.0`
   runs Autopilot's suite on that release (`autopilot/scenarios/run_released.sh`).
2. What the chosen mods require is added, transitively: Modern Hooks' `::Hooks.register` + `require("id op ver", ...)`,
   mod_hooks' `::mods_registerMod` + `::mods_queue(id, "id(op ver), ...")` (`>id`/`<id` order only, `!id` conflicts,
   `vanilla` and DLCs ignored); a mod calling `::Hooks` requires Modern Hooks, one using only `::mods_*` requires
   mod_hooks. A requirement already met by a chosen zip (Legends registers mod_hooks itself) adds nothing; otherwise
   it takes the newest release satisfying every requirement on that id.
3. A requirement no release meets but the working copy does fails with a hint to name `id@dev`; nothing falls back to
   a working copy silently.
4. What zips don't say is in `mods/registry.toml`: extra requirements, variants, `version = "declared"` (the Nexus
   declared version or the file name's, for mods registering a bogus one: Fantasy Bros registers 1, Black Pyramid
   1.4.4 registers 1.3, Legacy 2.13 2.12.2), `match` (an id for zips with a compiled preload), `version_file`.

Store zips mount under the name a player has them (index copies lose their hash or id prefix, `work/store/`), so the
load order is the game's. Every run writes `<run dir>/mods.lock`: per launch, each mod's id, variant, version, source
and sha256. `--lock <run dir or file>` mounts exactly those again (working copies are rebuilt; a changed version is
warned about). Several `-r` of one id run everything once per spec (a product over such ids): the statuses get a column
each (`engine mod_reforged==0.9.2`, ...) and the matrix compares them. `-r '*@latest'` replaces every resolved
third-party mod (not the user's) by its newest: a compat run.

Version policy:

- Bug-repro tests pin every third-party mod they involve with `==`, at the version they reproduced on; smoke and core
  tests pin too, so a normal run doesn't change by itself. `-r '*@latest'` is the compat check.
- Frameworks (Modern Hooks, MSU, stdlib) come in through `require`, unpinned; a header names one only when the mod
  under test uses it without requiring it (MSU as an optional dependency, mod_hooks for `::mods_*` mods).
- `stdlib@dev` in every header for now. The released stdlib 2.6 registers through mod_hooks and fails with Modern
  Hooks alone (`Mod stdlib requires the original mod_hooks`), so a bare `stdlib` resolves to 2.6 plus the mod_hooks
  shim (`registry.toml`), a different mod set, and its float registration breaks `require("stdlib >= 2.6")` (Engine
  issues). The working copy has the fix (`1a4ed01`), unreleased: drop `@dev` once a release has it.

## The real UI page (`--env ui`)

`./bbtest.py --env ui ...` (or `--ui-page`) runs every launch, and `// needs: ui` in a file's header makes it a
ui-only file (skipped in the other envs), with the
game's real UI page instead of the stub client: the install's and the mods' `ui/` JS and CSS in Chromium (CEF),
headless (no display, no GPU, software compositing), frames as fast as they go. The binary is `bbtest_ui`
(`engine/bbtest_ui.rs`, copied to `bb-ui/examples/` of the engine checkout on branch `bbtest-cef`,
`~/projects/bbm/3rdparty/modern-bb-engine-cef`, `BBTEST_UI_ENGINE` to change; built with `cargo build --release -p
bb-ui --features cef --example bbtest_ui`). How it works, what differs from headless, resources:
`UI_VARIANTS.md`.

| | |
| --- | --- |
| `t.js(code)` | the value of the JS expression `code` in the page (objects and arrays as tables and arrays); a JS exception raises. The page's calls into the scripts run inline |
| `t.untilJs(code, maxFrames = 600)` | a wait: until `code` is truthy in the page |
| `t.hover(selector)`, `t.unhover(selector)` | the mouse onto (off) the page's first element matching the jQuery selector: its `mouseenter` (`mouseleave`); a tooltip shows after its delay. The same in jsdom and Chromium |
| `t.shot(name)` | a PNG of the page, `<run dir>/logs/<name>.png`; returns its path (null in jsdom) |

- A page error (`console.error`, an uncaught exception) is a `[Error UI]` line: in a test it fails the test; outside
  tests it fails the launch, as a script error does.
- The page's timers, animation frames, `performance.now()` and `Date` follow the game's frames from the main menu on:
  `setTimeout(f, 500)` runs 30 frames later. A wait timing out takes a screenshot (`timeout_<n>.png`) and lists the
  shown screens.
- Popups and screens now animate (300 ms fades, ~18 frames) where the stub answered at once: a test that acts on a
  popup should wait for `isVisible() && !isAnimating()`. Acting mid-fade hits vanilla races the stub never shows
  (Autopilot's FOUND_BUGS "In the real UI page").
- Example suites (`// needs: page`, run in jsdom and here): `../../autopilot/scenarios/ui_page*.nut`,
  `../../fun_facts/scenarios/ui_*.nut`.

## The UI page in jsdom (`--env jsdom`, `ui=js`)

`./bbtest.py --env jsdom ...` (or `--ui-js`) runs every launch, and only there runs a file with `ui=js` in its mode line, with the
game's real UI page in jsdom under Node instead of the stub client: the install's and the mods' `ui/` JS (and the
CSS rules that hide and show things), no layout, no paint. The binary is `bbtest_js` (`engine/bbtest_js.rs`, copied
to `bb-ui/examples/` of the engine checkout on branch `bbtest-jsdom`, `~/projects/bbm/3rdparty/modern-bb-engine-jsdom`,
`BBTEST_JS_ENGINE` to change; built with `cargo build --release -p bb-ui --features jsdom --example bbtest_js`; the
page's script is `bb-ui/jsdom/page.js` there, its `node_modules` installed by `npm ci` on first use). `node` from
`PATH` (`BB_NODE` to change). How it works, what it shims, coverage, resources: `UI_VARIANTS.md`, "Variant 1".

- `t.js(code)`, `t.untilJs(code)` and `t.hover(selector)` work as with `--ui-page` (above); `t.shot` gives null
  (nothing is drawn).
- `::BBTest_mouseOverUI(false)` before mouse input to the tactical or world map (`onMouseInput`): jsdom can't tell
  what's under the mouse, so the cursor counts as over the page unless told (tile hovers do nothing then). Move the
  cursor (`::Cursor.setPosition`) for the scripts to notice.
- A page error (`console.error`, an uncaught exception) is an `[Error JS]` line: in a test it fails the test,
  outside tests the launch; one matching `known_errors.txt` doesn't (vanilla's own). jsdom's gaps and `console.warn`
  are `[Warning JS]` lines; `console.log` goes to `events.log` only (`JS_LOG`).
- Time is virtual, ticked by each frame's 1/60 s from the start: timers, animation frames, `Date`,
  `performance.now()`. Images "load" on the next frame (a loading screen waits for its picture). Animations take
  their frames, as with `--ui-page`.
- `BB_UI_JS_CSS=full` applies all the page's CSS (jsdom's own cascade: Fun Facts' `core` AI battle launch took 67 s instead of 4.7 s, one unpinned run); `0` none.
- `NODE_V8_COVERAGE=<dir>` writes the page's JS coverage per launch; `./ui_js_coverage.py <dir>` sums up the
  user's mods' JS (functions and lines run).
- Example suites: `../../autopilot/scenarios/ui_js_*.nut`, `../../fun_facts/scenarios/ui_js_*.nut`.

## The original game (`--env game`)

`./bbtest.py --env game ...` runs the launches in the original Battle Brothers (the Steam install's Windows build,
1.5.2.3) under Proton, with nothing on the screen. Use it to check what the engine may get wrong (the Squirrel 3.0 VM,
the natives, the real page). One launch at a time, whatever `-j`; `--env engine,game` gives the divergences matrix.

How a launch runs:

- The scenario files, `bbtest.nut`, the scripted player and the harness's autoplay are packed with
  `game/runner.nut` into the launch's `zzz_bbtest_runner.zip` (its `scripts/!mods_preload/` file). The runner does
  what `engine/bbtest.rs` does, from inside the game: a real-time event every 1 ms runs one step a frame in every
  state, scheduled again when the game clears its events (a load, a battle's end). It loads the scripts at the main
  menu, starts the campaign through the menu, calls `::BBTest.tick()` every frame, and quits when the tests finish
  (a battle left running, the world state finished, then the main menu's own Quit). A game that doesn't quit within
  20 s of the runner's `EXIT` row is killed (its log has every row by then).
- Frames run uncapped (`vblank_mode=0`, a few hundred a second) and the runner keeps the game's virtual clock at a
  60th of a second (times the speed the scripts set) a frame, as the engine's: the speeds `World.setSpeedMult` and
  `Time.setVirtualSpeed` get are multiplied by the frame rate over 60 (1–16), and the getters return the scripts'
  own. During the tests the virtual clock is also set every frame to what the engine's reads (Determinism across
  envs). So world days and battles take about the frames they take at 60 Hz, in a fraction of the time. Real-time
  things (`TimeUnit.Real` events, UI fades, the 4 s guard on loads, which the runner resets) take fewer frames: a
  wait's frame budget also lasts its frames' worth of real time at 60 Hz before it times out, and the campaign's
  intro wait is in real time.
- `--snapshot` works here too: the first campaign launch with a key saves the campaign at its start (in the game's own
  format, keyed by the game's exe), later ones load it from the main menu instead of generating the world.
- One launch at a time on the machine (a lock file in `work/game/`), so parallel bbtest runs queue.
- `game/launch.sh` starts a KWin of its own on a virtual output (seeing only the Intel GPU, as `../bbui/kwin.sh`),
  `game/session.sh` an Xwayland in it and the game through Proton (`proton waitforexitandrun`). The game renders on
  the Intel GPU; screenshots: `BBGAME_SHOTS=SECONDS` in the environment writes `<run dir>/game_out.txt.shot<n>.png`.
- Results come from the game's `log.html`, turned into `events.log` as the engine writes it. The game writes the
  log in blocks and completes it when it quits: a launch killed on its timeout loses the rows since the last block.

Isolation:

- The install is `work/game/install/`: `win32/` and `cursors/` are symlinks to the Steam install, `data/` holds
  symlinks to the shadow data dir's `.dat` files (no `data_014.dat`) and the launch's zips. The Steam install's
  `data/` and the zips there are never used.
- The Proton prefix is `work/game/pfx/` (`STEAM_COMPAT_DATA_PATH`), so `log.html`, saves and `config.cfg` are in its
  own `Documents/Battle Brothers/`; its `log.html` and `savegames/` are deleted before each launch, and copied to the
  run dir's `logs/` and `saves/` after. The user's prefix, saves, config and log aren't touched.
- The display: the KWin and Xwayland are the launch's own, inside `bwrap` with a private `/tmp/.X11-unix`, and the
  Xwayland has no abstract socket (`-nolisten local`), so nothing outside the launch can reach it.
- Steam: the game's exe carries Steam's DRM wrapper, so it runs only with the user's Steam client running and logged
  in. Each launch shows the user in game in Steam and counts as playtime. After a launch `wineserver -k` ends what's
  left in the prefix, and bbtest checks that Steam's `logs/content_log.txt` shows the game stopped (it warns if not).
  Never hide the game's PID from the host (`bwrap --unshare-pid`): Steam then tracks a namespaced PID, which on the
  host is some other process that never exits, and keeps the game "running" until Steam is restarted.
- Silent: `launch.sh` hides the sound devices and the user's PulseAudio/PipeWire sockets, `session.sh` disables
  Wine's audio drivers, the runner sets every volume to 0.
- Watching a launch: `BBGAME_SHOW=1 ./bbtest.py --env game ...` runs the game in a window on your own display
  (no KWin, Xwayland or bwrap; still silent; the runner moves your pointer to the window's centre once). For looking,
  not for runs: the window takes input.
- Proton Experimental (`BBTEST_PROTON` to change). Proton 9.0's fullscreen hack deadlocks in its init on this
  Xwayland, which has no RandR providers. The cursor is put at the window's centre at the main menu: no mouse moves
  over the headless window, and the world's hover tooltip divides by its position.

Timing: frames are uncapped and the virtual clock is held to a 60th of a second a frame (above), so `t.frames(n)` is
n frames of game time and battles run a few times faster than real time. The bench battle (3 brothers vs bandit
raiders, AI both sides) took 85–95 s of a launch against 182–244 s at the old real-time 60 Hz (CPU 2 and the E-cores,
load 4–17); menu and campaign launches didn't measurably change (~10–20 s and ~30–45 s, the same noise both ways).
A campaign from `--snapshot` loads in ~6 s against ~19 s of world generation (E-cores, one pair). `RESOURCES.md`,
"The original game", has the runs.

All suites (2026-11-13, `work/game/full/`: `run.sh` one bbtest run per mod, `rerun.sh` the files fixed meanwhile,
`merge.py` → `statuses.json`/`skips.json`, `divergences.txt` against `--env engine` of the same tree): 561 tests,
458 pass, 98 fail, 5 skip, against the engine's 467/84/5 of 556; 20 tests differ, causes in the run's report. The
`legends_bugs::KB4`/`N7` divergence of 2026-11-12 (Legends' `event.legend_legendary_locations_check` queued after the
`fresh=1` reload in the original, so `World.Events.fire()` refused) no longer shows.

## Isolation and butterflies

Tests of one launch share the game: the world, the roster, globals, hooks they install. To
keep them from affecting each other:

- Every test starts with `::Math.seedRandom(hash(test name))`, so its rolls don't depend on how
  many draws the tests before it made. That covers the script RNG only: the world state the
  earlier tests left (a changed roster, a battle that moved parties, time passed) still changes
  what happens. Example: `battle.nut`'s scripted-player battle takes 2871 frames after the other
  two battles (each toughened the same brothers again) and 2031 frames alone.
- `fresh=1` in the mode line: the campaign is saved right after it starts and loaded again
  before each test but the first (~0.1–0.15 s a test). Roster, world and time are reset; root-table
  globals, hooks and `::BBTest` state are not. Also exercises the mods' save/load code.
- `--isolate`: one launch per test (each pays the boot and campaign start, ~2–4 s; launches
  run in parallel, `-j`). Test names are found by the regex `^\s*test\(\s*"name"`.
- `-k NAME` runs one test (still after the campaign start of its file's header).
- Don't change globals (`::Const`, hooks) in a test without undoing it; prefer `beforeCampaign`
  for setup that every test of the file needs.
- The per-test seed covers only `Math.rand(min, max)`. `Math.rand()` (a battle's seed among others) is the C runtime's
  stream, which `seedRandom` never resets and the engine's sprites draw from too, and the game reseeds from the real
  time (frames since the launch's start) when a battle's units are spawned and when it ends: a test's battles depend
  on everything before them in the launch, the campaign start included. By default both follow the test's
  seed (`::BBTest.stableRng`: the reseeds draw from it, `Math.rand()` is a stream of its own seeded from it) and
  battles are pinned (Determinism across envs); `--no-stable-rng` leaves them as the game has them. The switch changed the status of
  6 tests of all suites, each passing on one launch's luck before (2026-11-12, see the mods' FOUND_BUGS).
- A launch is the same run to run: `probes/repeat.sh probes/start_state.nut 10 [options]` (RNG draws, contracts,
  parties, roster at the start and 5 days on) gave 10 identical dumps on vanilla, our mods, Reforged 0.9.3 and Legends
  (2026-11-12). Before, with mods it wasn't, for two reasons, both the original game's too:
  - tables keyed by tables iterated in heap-address order (MSU's `WeightedContainer` over troop types, in Legends'
    and Reforged's spawns): the same roll picked another troop, and every draw after shifted, contracts included. The
    engine (branch `bbtest`) now hashes an object by its creation serial, and `toHash` and `tostring()` of an object
    give it too (the strings scripts make of them, e.g. `getInstanceID()`, were address-dependent as well);
  - `buildTextFromTemplate` picks from the engine's own stream, seeded from the clock: the runner sets
    `BB_ENGINE_SEED=1` unless given.

  AI battles under Reforged were seen to differ too (kills per brother), likely the same cause; not rechecked.
- With `fresh=1` the first test of a launch runs on the campaign as started, the others on it
  reloaded, and the two differ: the same AI battle went otherwise as the first test (`-k`,
  `--isolate`) than as the second of a launch; a brother's FunFacts `Version` was 1 before any
  load and 3 after. Check `--isolate` against the packed run.

## Determinism across envs (2026-11-13)

A battle plays out draw for draw the same in the engine and the original game (`--env game`), so a divergence
between them is a real difference, not AI or RNG noise. Each wait's end logs the test's 2-arg `Math.rand` draws (a
count and Enduriel's running hash, a mark every 2000) as an `RNG` line of the report, e.g. `RNG battle: draws
0..8788 hash 485187 marks 2000:52951 ...`; the count restarts with each test. `--draws` also logs every draw and
reseed with its call site (4 frames; an AI pick with whose it is and every behaviour's score), and `rngdiff.py
<launch dir A> <launch dir B> [-k NAME]` prints the first draw where two runs part, with the draws before it and both
stacks.

Pinned in every env (`bbtest.nut`, with the stable RNG, so `--no-stable-rng` drops them; each undone after the
battle):

- the combat seed: drawn from the test's stream (`World.State.m.CombatSeed`) as the battle is set up; `Math.rand()`
  is a stream of its own (MINSTD from the test's seed): the UI's `setDirty` calls draw from it, at their own times;
- the map: reseeded from the test's seed at the battle's template (`MapGen.get`): the world's frames before it differ;
- the wall-clock reseeds (`seedRandom(Time.getRealTime())`, as the units spawn and the battle ends): from the test's
  seed;
- a new campaign's faction updates while paused (`IsRunningUpdatesWhilePaused`): off for the battle, whose start
  takes the UI's frames;
- idle sounds (a unit picked on gaps of virtual time): never;
- the AI's evaluation budget (5 ms of `Time.getExactTime`, then it yields to the next frame): unlimited;
- the turn bar learns of the battle's end at once, not on a 50 ms real-time event (another round, a draw, or not);
- draws that answer without drawing (`a` of `rand(a, b)`): from `onRender` (ghosts redraw their jitter as a sprite
  animation ends), from `loading_screen_onQueryData` (its tip, when the page asks), and a player's agent's pick while
  the player's input is awaited (vanilla's `player_agent` thinks in the background, its pick unused; the pick lands
  when the UI's popups let the player act);
- MSU's random picks from tables keyed by objects (`WeightedContainer.roll`: injuries, troops; `MSU.Table.randKey`,
  `randValue`) go by the keys' content (`::BBTest.keys`): the table's own order is by address in the original, by
  creation serial in the engine, so the same draw picked another injury after any unrelated allocation. The class
  can't be changed once instantiated: `randf` called from `roll` answers the value that lands on the item the draw
  picks in that order;
- a test's start in the world: the next faction to update is the first (a new campaign's start takes the env's own
  frames).

In the original the runner also sets the virtual clock every frame of the tests to what the engine's reads (a 60th of
a second times the speed since the scripts last set it), and the native speed factor from the frame under way.

Matched (`probes/parity/`, seed `bbtest-parity`; engine and 2 game runs each, the same count and hash):

| | draws | |
| --- | --- | --- |
| `vanilla_battle::bandits` (MSU, stdlib) | @VB@ | the whole battle and the return to the world |
| `autopilot_battle::bandits` (Autopilot New 2.9.0 plays the company) | @AP@ | |
| `reforged_battle::bandits` (Reforged 0.9.3) | @RF@ | |
| `vanilla_battle::direwolves in a forest` | @DW@ | |

What isn't pinned, and why:

- **Native differences of the engine** — real divergences, the trace finds them. Direwolves in a forest (before the
  map pin's final form): the ~34,000 draws of the forest map and the spawn matched, then a Direwolf's first
  `ai_engage_melee` scored 705.8 in the engine and 545.5 in the original: from 20,17 the engine offered it the
  destination tile 16,15, the original didn't (a reachability or pathing native).
- **World days** (`vanilla_days.nut`): faction actions and party orders run on virtual time and on the native
  movement of world parties. With the clock set per frame, a test start with the same next faction, and the same
  campaign (the original loads the engine's snapshot: copy `work/snapshots/<engine key>.sav` and `.nut` over the game
  key's), 2 days matched ~600 draws (the paused faction updates), then a party's `roam_order` re-targeted on arriving
  in the original first: its position comes from the frame's native movement, by the frame's real time times the
  speed, which the runner can only aim at. Without the shared snapshot each env's campaign start differs (the
  timers a save doesn't keep, the intro's real-time second): they part at draw 4.
- Code an env calls on its own timing still draws there: a mod's real-time events, UI callbacks; `--draws` shows them.
- Tables keyed by objects that mods iterate themselves (not through MSU's picks): their order is the env's own.

## Speed

- Launches start longest first, by their walls in earlier runs (`work/walls.json`, keyed by the launch's
  title; new ones first of all), so no long launch starts last. Results don't depend on the order.
- `--snapshot`: a campaign launch saves its campaign right after the start (paused, past the intro) to
  `work/snapshots/`, keyed by seed, origin, the mod zips (built ones by content) and the engine; a later launch
  with the same key loads it through the main menu instead of starting a campaign (~0.4 s instead of 2–5 s).
  Files with `beforeCampaign` never use it. It keeps the stable RNG even with `--no-stable-rng`, and restores the world state a save doesn't keep
  as it was at the campaign start (`::BBTest.Unsaved`: a new campaign updates the factions while paused until the
  first unpause, a loaded one doesn't; and the faction updated next), kept next to the snapshot (`<key>.nut`).
  Statuses are those without it (the five suites, 2026-11-12), except a launch whose save doesn't
  load from the main menu: nicknames' `reforged_bp` (Black Pyramid 0.4's bug, `OTHER_MODS_RESULTS.md`).
- CPU, RAM and the choice of `-j`: `RESOURCES.md`.

## Timings

Measured on suor-p1 (20 cores), serial runs, warm script cache (`~/.cache/bb-modern-engine`,
~230 MB):

| | |
| --- | --- |
| boot to main menu, frameworks + test files loaded | 0.2 s |
| new campaign (worldgen and the faction simulation) | 1.9 s (seed `bbtest-battle`), 3.9–4.2 s (seed `bbtest-nick`): depends on the seed |
| one world day | ~1600 frames, ~0.5 s |
| a battle (3 brothers vs bandit raiders) | 0.1–0.8 s |
| `examples/battle.nut` (3 battles), whole launch | 3.3 s |
| `examples/*.nut` (3 launches in parallel, mod zips rebuilt) | 4.4 s |

## Engine issues and divergences that matter for mod tests

- **No UI/JS** (without `--ui-page`, see above). Headless, the UI is a stub client that answers the scripts' calls; the mods'
  `ui/` JS and CSS never run, so JS-side bugs and anything the page computes are untestable
  here. Squirrel→JS calls happen (and must not fail), JS→Squirrel callbacks can be called by
  hand (`screen.onButtonPressed(0)` and the like). The windowed build (`cargo build --release
  -p bb-app --features ui`, ~2 min, downloads CEF) has `--at FRAMES SQ` and `--at-page FRAMES
  JS` for scripted runs, but on this machine it didn't run headless: under `kwin_wayland
  --virtual` Chromium gets no GPU ("Chromium couldn't draw the UI on the GPU"), and on the
  desktop's `:0` it booted to the menu and then presented no frames (display off), so `--at`
  never fired. The engine's own window tests use a headless gamescope, which isn't installed.
- **`typeof x = y` doesn't compile** (`can't assign expression`): the engine's Squirrel 3.2 compiler marks
  every unary expression as non-assignable; the game's 3.0 compiles it (as the value `y`). Legends 19.4.23's
  `scripts/entity/world/camp/buildings/hunter_building.nut:73` has `typeof _m = "integer"` (since 2023), so Legends
  didn't boot. bbtest mounts a copy with that expression replaced by `"integer"` (`ZIP_PATCHES` in `bbtest.py`,
  copies in `work/patched/`, same file name). It is the only compile error in Legends' 4229 scripts (checked with
  the engine's `sq_check` example).
- **`World.getRoster(id)` of an id without a roster** returns null in the engine; the original raises (`the index
  '9999' does not exist`), so `getRoster(id) || createRoster(id)` works only in the engine. `::BBT.recruit` and
  background_perks' Legends tests catch it. Legacy mod_hooks (hackflow's shim, Legends') fires `mods_hookNewObject`
  hooks in `create()` only of the rosters its `World.getRoster`/`getPlayerRoster` wrappers return, not of
  `World.createRoster`'s; with it loaded the engine answers a missing id through that wrapper, so a recruit made after
  the fallback got the hooks only in the engine (Elite Few's master talent, VAP's perks;
  `probes/game/ef_roster_hooks.nut`). `::BBT.recruit` now creates through `getRoster` after `createRoster`, as
  settlements make their recruits.
- **A mod's `.nut` older than the game's `.cnut` is ignored**, as in the original (`docs/modding.md`): Legends
  19.4.23's `scripts/preload.nut` and `root_state.nut` (dated 2026-06-15) lose to the game's of the Nov 9 update,
  and the log warns `"data_001.dat" (the game's own) overrides 2 files of "mod_legends-19.4.23.zip"`. Not a
  divergence; Legends boots and plays anyway.
- **`data_014.dat` breaks vanilla.** The install's `data_014.dat` (a Russian translation from
  May 2026) overrides ~2000 scripts from before the Nov 9 game update; with it, booting fails
  with `the index 'BanditMarauder' does not exist`. bbtest leaves it out (`BBTEST_SKIP_DATS`),
  so tests run in English vanilla 1.5.2.
- **No Fangshire DLC here** (`dlc_fangshire`, `data_002`): the starting stash lacks the
  Fangshire helm, which shifts the RNG from there on. That is why the engine's `parity` test
  fails here on 155 campaign probe keys (all menu probes match): not an engine bug.
- **MSU 1.8.0 vs vanilla 1.5.2**: MSU logs an error adding `IsSpent` to `perk_quick_hands`,
  which vanilla now has (listed in `known_errors.txt`). The same would happen in the real game.
- **Battles with the AI playing the company** report `PlayerRetreated` (3) even after a win
  when the enemy routs (the company isn't player-controlled then; the engine's draw-exact test
  `bandit_raiders_on_the_plains` expects 3 too, as the original game does). Assert on
  `t.result.survivors` instead.
- `harness::run_past_intro` never settles with MSU/stdlib loaded (they keep real-time events
  scheduled); bbtest waits for the intro event screen instead.
- Frames are fixed 1/60 s of game time each, not wall time; real-time throttles (e.g. the
  world ignoring a load within 4 s of the last one) count in frames.
- The engine's known missing natives are listed in the checkout's
  `parity/missing_natives.txt`, accepted differences in `parity/divergences.txt`; a mod calling
  a missing native gets a script error.

- **Modern Hooks' "error and quit" doesn't quit.** A failed dependency check (e.g. a mod
  without stdlib) logs its errors and raises the popup with `ForceQuit`, but headless there is
  no popup to quit from: the boot goes on and the mods' queues still run. Assert on
  `::Hooks.Popup.m.ForceQuit` and allow the errors with `// allow-errors:`.
- An error inside a script that a native calls (e.g. `create()` under `::new(...)`) is logged
  as a `SCRIPT_ERROR` even when the test catches it with `try`, and so fails the test. Don't
  probe-instantiate scripts that need arguments (e.g. `perk_hackflows_potential`).
- **Unreachable objects are collected only when a battle ends** (or a campaign is left or
  loaded; the original collects every 60 s, `docs/differences.md`). A shield destroyed in battle
  stays alive, so a weak reference to it isn't null, until the battle is over: a mod that checks
  `isNull()` on such references sees it all battle long (Fun Facts' F3).
- Reforged 0.8.18's experimental AI fixes log `onRemovedFromMap activeEntity null. Brigand
  Thug (N)` in some AI battles headless (3 of 8 bandit battles without other mods): a launch
  error. Whether the original logs it too wasn't checked; wrap `::logError` to tolerate it.
- Mods using the old `::mods_*` API (e.g. Black Pyramid, Fun Facts) need a `mod_hooks`: the newest is hackflow's
  shim 21.2 (`mod_hooks_hackflow_21.2.zip`); Legends brings its own. Reforged 0.8.18 boots from its
  `mod_framework-0.8.17-russian.zip` (`mod_modular_vanilla[russian]==0.8.6`) + `mod_reforged_core` + `_assets`;
  Legends 19.4.23 from its release zips. Rosetta 0.4.0 boots; the game is English here, so
  `::Rosetta.activate("ru")` switches the language by hand.
- A script error in a `!mods_preload` file stops the boot (`RUNNER STOPPED`), so the launch
  has no tests to report and fails as a boot failure (Fun Facts' `no_stdlib.nut`). What the
  original does after such an error wasn't checked.

- **`tofloat()` keeps 64 bits, float literals are f32** (`docs/differences.md` says only
  extreme values notice): `2.6 <=> "2.6".tofloat()` is -1 and `==` false, though their difference
  prints 0. Modern Hooks compares a float version registered from a literal with a requirement
  parsed by `tofloat`, so `require("stdlib >= 2.6")` fails at boot with `stdlib (stdlib) version 2.6
  is outdated for ... >= 2.6` (Bro Studio); any version not exact in binary is affected. The
  standalone `squirrel` gives 0 / true. Work around with `// allow-errors:` (Modern Hooks doesn't
  quit headless, the queues still run).
- **`DialogScreen.show` starts animating a frame late.** The original and the real page (`--env ui`) answer it inline:
  right after `show`, in the same frame, `isAnimating()` is true, so vanilla's `showDialogPopup` guard drops a second
  request. Headless the stub answers in a later frame, so a second request in the same frame pushes a second
  `MenuStack` backstep (Autopilot's `known_bugs::KB10` fails on the engine only; FOUND_BUGS, "KB10 in the original
  game").
- `setBrightness` scales the sprite's current color (the original's native does the same, nothing
  else is kept), so a mod's `setBrightness(0.1)` then `(1.0)` leaves it dark: compare
  `sprite.Color.R/G/B` to check a look (Standout Enemies' SE-KB1).

## Third-party mods on the engine (2026-11-12)

`./bbtest.py -j 8 thirdparty/*.nut`: each mod set boots, starts a campaign, wins an AI battle, runs 2 days and
saves/loads (`lib/tp_smoke.nut`), all on the newest versions (`mods/VERSIONS.md`):

| Set | Boot | Battle, days, save/load |
| --- | --- | --- |
| `mod_reforged==0.9.3` | clean | pass |
| + Hardened 1.26.3 | clean | pass |
| + Crock Pot 0.10.6 | clean | pass |
| + Hardened + Black Pyramid 1.4.4 (+ `mod_hooks`: its `black_pyramid_beasts` uses `::mods_queue`) | clean | pass |
| Clever Recruiter 2.1.8 | clean | pass |
| `mod_legends==19.4.23`, early access and `scenario.legends_noble` origins | clean after the `typeof` patch (Engine issues) | pass |
| Stronghold 2.18.1; also Legends + Stronghold + Clever Recruiter | clean | pass |
| Legends + SSU 8.5.2 | fails: `the index 'BanditVeteran' does not exist`, then `IsLowerVanity` (mod incompatibility: SSU is for Legends 19.2, which needs vanilla < 1.5.2) | — |
| Legends + NgGH 3.0.0-beta.90 | fails: `the index 'LegendFavouredEnemyGhoul' does not exist`, then `Simp` (same) | — |

No missing natives showed up in these runs. The two failures are mod incompatibilities a player gets too, so
`smoke_ssu.nut` and `smoke_nggh.nut` fail by design until those mods are updated.

## Writing scenarios: pitfalls (2026-11-12)

- Two files with the same name (e.g. `vanilla.nut` of two mods) and the same header land in one
  launch and one of them is silently lost (the run dir keeps wrapped files by name): give files
  of different mods distinct names when the headers can match.
- An error thrown through a native `acall` (Elite Few's and other mods' wrappers) is logged as a
  SCRIPT_ERROR even when the test catches it, failing the test: judge such tests by their ASSERTs.
- `::Tactical.State` methods can't be reassigned on the instance, and `t.battle`'s `player` isn't
  called after the battle ended: to read `CombatResultLoot` use a
  `::Time.scheduleEvent(::TimeUnit.Real, ...)` ticker (`challenges/scenarios/lib/helpers.nut`).
- The loot screen is never taken: items dropped in battle don't reach the stash.
- `t.battle` entities with a `Party` (for mods hooking `setupEntity`) must carry it as a
  `WeakTableRef`, as `world_state.startCombat` does: `actor.kill()` calls `Party.isNull()`.
- A company toughened with HP alone loses a 2H brother in an AI battle even at +300 HP: `::BBT.toughen` makes most
  hits miss (+60 melee and ranged defense) instead.
- **Callbacks mustn't read the test's locals.** In the original game (Squirrel 3.0) a closure made in a test (a
  generator) reads the test's locals, `t` among them, as null once the test has yielded
  (`probes/game/gen_outer.nut`); the engine and code read them fine. So a `player`, a `t.until` condition, a
  `::BBT.scripted` step or an `::APT.pilot` step takes the test's context as its argument and keeps its state in
  `t.state`: `t.state.seen <- {}; yield t.battle({player = function (t) { t.state.seen.x <- 1; }})`, then
  `t.state.seen` after the yield. A closure made after the last yield and called before the next is safe.
  `--env game` warns of each closure in a yielding test that names one of its locals (a lint, `generator_captures`).
- **Write Squirrel 3.0**, the original game's: the harness, helpers and scenarios run there too (`--env game`), while
  the engine and code run 3.2. Don't use what 3.0 lacks or does otherwise: return values of array methods
  (`extend`, `push`, `append` return null there; call them as statements), `in` on a class, other 3.1+ features.
  Met in the full `--env game` run: tables have no `keys()`, `values()`, `filter()`; `reduce` takes no initial
  value; a statement after an if-block on the same line (`if (c) { ... } return;`) doesn't compile.
  `World.getRoster(id)` of a missing id raises (Engine issues).
- **An uncaught script error in a frame's update stops the launch.** E.g. an AI behavior throwing in
  `tactical_state.onProcessAI` (Autopilot's KNOWN_BUGS #1): `engine.frame()` returns the error, the
  runner reports `FRAME FAILURE` and the rest of the launch's tests don't run. The original logs the
  error and goes on (the users' logs repeat it every think: the turn hangs). Put a test expected to hit
  such an error in a launch of its own (`launch=` in the header).

## Runner issues (found and fixed, 2026-11-11)

- Concurrent invocations deleted each other's run dirs (only the last 20 are kept): now a run dir touched in the
  last hour is kept too (2026-11-12).
- `fresh=1` skipped the reload before the second test of a launch (`Reloaded` started at 1),
  so tests 1 and 2 shared the world. Now every test but the first starts from the save.
- An `// include:` file with the same basename as a scenario file of its launch overwrites it in the
  run dir (both are copied to `<run dir>/<basename>`), so that file's tests never register. Not
  fixed; give includes distinct names (Autopilot's `lib/kb31_body.nut` next to `kb31.nut`).
- `t.days()` ran the world clock at normal speed after the first event: showing one resets
  `LastWorldSpeedMult` to 1, and `world_state.onUpdate` holds the speed to it, while the
  virtual clock kept the wait's speed, so the wait ended with fewer days passed (3 "days" at
  speed 4 advanced `World.getTime().Days` by 1). It now holds `LastWorldSpeedMult` too, and
  its frame budget is twice a day's frames at the speed (was below one day's).

- With the real page, the `fresh=1` reload and `t.load` ended before the load had run: the world loads only after
  the loading screen's fade-in (`onScreenShown`), so `!LoadingScreen.isVisible()` held at once and the test started on
  the old world, which the load then replaced (battles never began). Both now also wait for
  `World.State.m.CampaignToLoadFileName` to clear (2026-11-12).

## The engine's own tests on this machine

`BB_ALLOW_SKIPS=1 BB_DATA_DIR=~/projects/bbm/mods/_scripts/bbtest/work/gamedata
RUSTC_BOOTSTRAP=1 cargo test --release -p bb-engine --test <name>` (the shadow data dir is
needed, see `data_014.dat` above):

- `smoke`: the vanilla case passed (menu → campaign → battle → save → load, 3.4 s); the
  corpus case skipped.
- `combat_scenarios` `bandit_raiders_on_the_plains`, `the_player_against_bandit_raiders_on_the_plains`:
  passed, draw-exact with the original, 2 s.
- `mod_frameworks`: all 3 skipped: no reference mod corpus. The corpus is pinned file by file
  (SHA-256) to the author's own mod set in `bb-engine/src/mod_corpus.txt`;
  `scripts/refresh_mod_corpus.py` would copy the installed mods instead and rewrite that pin
  list, and the modded goldens would no longer match, so it wasn't made.
- `parity`: fails on 155 campaign keys (missing Fangshire DLC, see above); menu probes match.
