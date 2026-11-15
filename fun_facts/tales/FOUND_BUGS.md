# Fun Facts — bugs found by the scenario tests

Found 2026-11-12 by the headless scenario tests in this dir, on the working tree (HEAD, 8
unreleased commits after 1.0.3, plus the uncommitted `setPlayer` change). Code refs: `ff.nut` =
`fun_facts/scripts/mods/fun_facts/fun_facts.nut`, `preload` =
`fun_facts/scripts/!mods_preload/mod_fun_facts.nut`, `fun_facts/<file>.nut` = the hooks dir.
Commands run from `~/projects/bbm/bbtales`. Each test below fails now, the same
packed and with `--isolate`, and was checked against the vanilla scripts
(`~/projects/bbm/base/scripts-base/`) to rule out an engine divergence. "1.0.3" says whether the
same test fails with the released zip.

None of the findings depends on the uncommitted change; it only makes KNOWN_BUGS #1 pass.

## F1. A bro struck down who survives gets the battle counted twice — medium (HEAD regression)

- Test: `bugs::F1: a bro struck down who survives counts the battle once` —
  `./bbtales.py -k F1 ../mods/fun_facts/tales/tale_bugs.nut`
- Observed: a bro struck down by a thug (survives with a permanent injury, company wins):
  ```
  ASSERT Fun Facts battles: expected 1, got 2
  ASSERT battle log ids: expected [1], got [1, 1]
  ```
  Vanilla's `LifetimeStats.Battles` is 1. His "Killed N in a single battle", "Fled" counts and
  the "Slacked for … of total" total all take the extra record.
- Expected: one `BattlesLog` record per battle.
- Cause: commit 15ea53d ("fix last combat not recorded") calls `onCombatEnd` in the
  `player.onDeath` hook for every non-guest death (`fun_facts/player.nut:47-49`), including
  `FatalityType.Unconscious` (struck down, `actor.kill` → `isReallyKilled` false). On a victory
  vanilla's `gatherBrothers` revives the survivor and calls `onBeforeCombatResult()` on him
  (`states/tactical_state.nut:660-663`), hooked at `fun_facts/player.nut:30`: a second record.
- 1.0.3: passes (its `onCombatEnd` in `onDeath` excluded Unconscious).

## F2. Kill verbs: "gutted" and "smashed" swapped — medium (HEAD, unreleased)

- Test: `bugs::F2: kill verbs: a gutted bro is gutted, a smashed one smashed` —
  `./bbtales.py -k F2 ../mods/fun_facts/tales/tale_bugs.nut`
- Observed: a bro who disembowels a brother and one who smashes another's head:
  ```
  ASSERT tooltip of the one who gutted: expected ["Unwittingly gutted …Bertel…"], got ["Unwittingly smashed …Bertel…"]
  ASSERT tooltip of the one who smashed: expected ["Unwittingly smashed …Lothar…"], got ["Unwittingly gutted …Lothar…"]
  ```
- Expected: `Const.FatalityType` is Decapitated 1, Disemboweled 2, Smashed 3
  (`config/character.nut:465`); `extendTooltip` maps them right (`ff.nut:336-338`).
- Cause: `fun_facts/kill_verbs.nut:5-6` map 2 to "smashed %s" and 3 to "gutted %s". The Russian
  hint in `mods/ff_bug.png` shows the same swap ("выпотрошил" for a smash).

## F3. A shield destroyed in battle is charged as armor parts — low

- Test: `bugs::F3: a shield destroyed in battle isn't charged as armor parts` —
  `./bbtales.py -k F3 ../mods/fun_facts/tales/tale_bugs.nut`
- Observed: a wooden shield broken by `applyShieldDamage` (unequipped by vanilla, nothing left
  to repair, `getRepairRequired().ArmorParts == 0`):
  `ASSERT parts charged to the bro: expected 0, got 1.608` (24 condition × 0.067). The AI
  battle in `tale_core.nut` shows the same: 7.973 parts charged vs 6.365 for the gear still worn.
- Expected: parts for the condition the game will repair.
- Cause: `onCombatEnd` skips lost items only when their weak reference is null
  (`ff.nut:188`), and a destroyed shield isn't freed yet: it sits in a reference cycle until
  the next garbage collection. The engine collects when the battle ends; the original every
  60 s (`modern-bb-engine/docs/differences.md:77`), so there too the result depends on timing.
  Checking that the item is still in the bro's container would be deterministic.
- 1.0.3: fails the same.

## F4. Battle ids carry over into a loaded save — low

- Test: `bugs::F4: battle ids restart from the loaded save` —
  `./bbtales.py -k F4 ../mods/fun_facts/tales/tale_bugs.nut`
- Observed: save, fight (id 1), load the save, fight again:
  ```
  ASSERT the loaded campaign's first battle: expected [1], got [2]
  ASSERT its kill: expected [1], got [2]
  ```
  By the code, a new campaign started after another in one session continues the old ids too
  (not tested).
- Expected: ids continue from the loaded campaign's records (`getBattleId` computes exactly
  that, max + 1, when the cache is empty).
- Cause: `::FunFacts.BattleId` (`preload:10`, `:17-36`) is a root-table cache that nothing
  resets on load or new campaign. `::FunFacts.LastFallen` and `::FunFacts.Buys.Stats` (when the
  save has no `FunFactsBuys` flag) live the same way. Ids only order records now, so the effect
  is gaps and, after loading a later save, repeated ids.
- 1.0.3: fails the same.

## F5. Food is charged to bros when nothing is eaten — low

- Tests: `economy::F5: no food counted while the company doesn't eat its provisions`,
  `economy::F5b: no food counted when there is none to eat` —
  `./bbtales.py -k F5 ../mods/fun_facts/tales/tale_economy.nut`
- Observed: one day with `setUseProvisions(false)` (vanilla does it in the caravan escort and two
  other contracts) or with an empty stash: the stash loses nothing, the bros are charged
  `Spent.Food` 6.6 in total.
- Expected: Spent.Food matches the food eaten, as it does in normal travel (`economy::food`
  passes: 2 days, sums equal to 0.01).
- Cause: the `consumeFood` hook (`fun_facts/assets_manager.nut:5-15`) computes the demand
  before the original runs and charges it unconditionally; vanilla `consumeFood` returns early
  when `!IsUsingProvisions` and eats only what the stash holds
  (`states/world/asset_manager.nut:771-807`). The TCO line takes these units at the food price.
- 1.0.3: fails the same.

## F6. Counts of one in the plural — low (cosmetic, English)

- Test: `tooltips::F6: counts of one read in the singular` —
  `./bbtales.py -k F6 ../mods/fun_facts/tales/tale_tooltips.nut`
- Observed: "Suffered 1 injuries", "Inflicted 1 injuries", "Fled 1 times in 1 battles",
  "Slacked for 1 battles of total 1", "Was stunned 1 times".
- Expected: singular forms (the Russian translation has plural rules for all of these).
- Cause: fixed plurals at `ff.nut:390`, `:394`, `:422`, `:428`, `:441`; "Died once",
  "Used nine lives once" already special-case one.
- 1.0.3: fails the same.

## F7. Deaths that vanilla deals with no killer log an error — low

- Test: `bugs::F7: deaths vanilla deals with no killer log no errors` —
  `./bbtales.py -k F7 ../mods/fun_facts/tales/tale_bugs.nut`
- Observed: `bro.kill(null, null, FatalityType.Suicide)`, as `tactical_state.onBattleEnded`
  does to charmed or sleeping bros on a defeat (`states/tactical_state.nut:2003`):
  `ASSERT errors logged: expected [], got ["ff: no killer in FunFacts.onDeath"]` plus a stack
  trace. By the code, the same for bros devoured at the end of a battle (`:1944`,
  `onDeath(null, …)`) and deaths from damage with no attacker.
- Expected: a normal, quiet death record (it is recorded right, with `Name = null`).
- Cause: `ff.nut:232-235` logs an error and prints the stack for every null killer. In a
  user's `log.html` this reads as a mod error.
- 1.0.3: fails the same.

## F8. A fallen bro's pre-v3 self-inflicted death turns into friendly fire on load — low

- Test: `bugs::F8: a fallen bro's pre-v3 suicide isn't taken for friendly fire` —
  `./bbtales.py -k F8 ../mods/fun_facts/tales/tale_bugs.nut`
- Observed: the same v2 stats (a death record with `IsPlayer = true`, the bro's own name, no
  `Self`) on a living bro and on a fallen one, saved and loaded: the living one migrates to
  `Self = true`, the fallen one to `Self = false`:
  ```
  ASSERT fallen bro: expected [true, 0], got [false, 1]
  ASSERT obituary tooltip: expected ["Died once"], got ["Died once from a hand of a bro"]
  ```
  By the same code, kill records too (a pre-v3 self-kill becomes "Unwittingly killed
  <himself>"; not tested).
- Expected: the migration (`ff.nut:520-528`) compares record names with the bro's name.
- Cause: `fun_facts/statistics_manager.nut:41-42` calls `unpack` before `setName`, so
  `m.Name` is still `"<not-set>"` during the migration; `player.onDeserialize` sets it first.
  Affects saves with stats written before v3 (1.0.0).
- 1.0.3: fails the same.

## Status after fixes (2026-11-12, uncommitted)

The author's notes on each bug in quotes. "Old" below = HEAD plus the user's uncommitted
`setPlayer` change, built as `~/projects/bbm/bbtales/work/ff_old/` and mounted instead of the working copy.

| # | Note | Status |
| --- | --- | --- |
| F1 | "unconscious not always survive the battle, i.e. if you run he turns dead, then the event should not be lost for obituary" | fixed |
| F2 | "+1" | fixed |
| F3 | "1,608 запчасти — not sure about this number, but that doesn't sound like a bug. The shield needs to be replaced or otherwise fixed. Not sure" | fixed 2026-11-13, see below |
| F4 | "Hard to believe, that should have breaking things. Need to check on old save, i.e. does it have numbers borked" | investigated: no number is wrong, only ids; fixed 2026-11-13, see below |
| F5 | "+1, unless they catch up later" | they don't catch up; fixed |
| F6 | "+1, but don't break russian version" | fixed, Russian unchanged |
| F7 | "+1" | fixed |
| F8 | "+1" | fixed |

- **F1**: `onDeath` still records the battle of every struck-down bro (so one left to die keeps
  it); `onBeforeCombatResult` (`fun_facts/player.nut:30`) skips the bro if he is in the
  survivor roster, i.e. a struck-down survivor vanilla revives on a victory. New test
  `bugs::F1: a bro struck down and left to die keeps the battle and the death` (struck down,
  then `Tactical.State.flee()`: "Left to die", the fallen has the battle, the Unconscious death,
  "Died once", all after a save/load). It passes on old code too and fails on 1.0.3 (`[0, []]`):
  this is what 15ea53d fixed. Both F1 tests pass on vanilla, Reforged 0.9.3 (`-r mod_reforged==0.9.3`)
  and Legends 19.4.23 (`-r mod_legends==19.4.23`). Vanilla's
  own obituary `Battles` misses that battle for the left to die (`gatherBrothers` uses
  `LifetimeStats.Battles` without the +1 of `getFallen`); Fun Facts now counts it.
- **F2**: `fun_facts/kill_verbs.nut:5-6` swapped; the Russian verb pairs in `rosetta_ru.nut`
  follow (`rosetta::F2: kill verbs in Russian`: "выпотрошил" / "размозжил башку").
- **F3**: 1.608 = the wooden shield's `ConditionMax` 24 × `ArmorPartsPerArmor` 0.067. On
  destruction vanilla (`items/shields/shield.nut:256-265`) unequips the shield; with the
  Blacksmith retinue (`IsBlacksmithed`) it drops it on the tile at condition 0, it comes back as
  loot and repairing it costs exactly those 1.608 parts. Without it the shield is gone, the real
  cost is a new one: Value 100 crowns before the seller's markup, while 1.608 parts at the TCO's
  default 12 crowns a part (`Buys.getAvgPrice("Parts", 12)`; an armor parts item is 200 crowns
  for 20) is ~19 crowns. Destroyed armor stays equipped at 0 and is charged its full condition
  the same way, so charging the shield is consistent with that. What is wrong is only that the
  charge is up to garbage-collection timing (the weak ref `isNull()` check): 0 or 1.608 for the
  same battle. Options: always charge (consistent, as for armor), never charge lost items
  (check the item is still in the bro's container), or charge the item's value for lost ones.
  Left for the author.
- **F4**: new test `bugs::F4: counts stay right through saves loaded out of order`: save A,
  battle, save B, load A, two battles, save C, load C; reset the cache (a game restart), load B,
  battle; load C (later than the session's ids), battle, save D, load D. After each step every
  bro's Fun Facts `Battles`, `BattlesLog` length and `Kills` count equal vanilla's
  `LifetimeStats.Battles`/`Kills`: passes. The ids do go wrong: `[2, 3]` for the first two
  battles after loading A (a gap), `[2, 3, 3]` after the restart then loading C (a repeat).
  Nothing reads the ids but `getBattleId()` itself (the max of each bro's last id), so no
  tooltip number changes. Fixed 2026-11-13, see "Status after fixes (2026-11-13…)": the ids are
  now asserted, `[1, 2]`, `[1, 2]`, `[1, 2, 3]`.
- **F5**: no catch-up in vanilla: with provisions off `consumeFood` sets `LastFoodConsumed` to
  now and returns (`states/world/asset_manager.nut:771-775`), the time is dropped; with no food
  the demand is simply not met, nothing remembers a deficit. The hook
  (`fun_facts/assets_manager.nut`) now measures what the stash's fresh food lost through the
  call and splits that by `getDailyFood()`; spoiled food the call throws away isn't counted.
  `economy::food` still matches the stash to 0.01.
- **F6**: one → "injury", "time", "battle" in `fun_facts.nut` (injuries, fled, slacked,
  effects). `rosetta_ru.nut` patterns take both forms (`injur<_:word>`, `time<_:str>`,
  `battle<_:str>`, the "Was … time…" split rule); new `rosetta::F6: counts of one and many in
  Russian` gives the same Russian on old and new code ("Получил 1 травму", "Бежал 1 раз в 1
  битвах", "Профилонил 1 битву из 1", "Был спутан 2 раза, оглушён 1 раз"). On Rosetta 0.4.0, the
  zip the suite pins. Left as is: "в 1 битвах" (the Russian TODO there), and stdlib's
  `Text.plural` (the "Died N times" and "Killed N enemies" lines) picks the singular for 21, 31…
  ("Died 21 time"), a Russian rule in an English helper.
- **F7**: the error and stack trace for a null killer removed from `FunFacts.onDeath`.
- **F8**: `fun_facts/statistics_manager.nut:41-42` set the name before `unpack`. The unit tests
  `codetests/bugs.nut` F8 (a bare `unpack` with no name) can't pass with any fix: nothing tells
  a nameless FunFacts whose record is his own; the bug is the caller's order. It was dropped
  when the code tests merged into the scenarios; `bugs::F8` (a save/load, both envs) covers the fix. `mocktests/test.nut` F8 now goes
  through the `statistics_manager` hook (fails on old code, passes now).

Checks: engine suite 63 → 67 tests (4 new), failures 16 → 9, the rest unchanged; bug tests also
with `--isolate`. Code tests: F1, F2 (2), F5, F5b, F6, F7 (2) and saves F8 flip to pass.
Mocks: F2, F5, F6, F7, F8 flip. Save compatibility: a campaign saved by old code (a struck-down
survivor with the double count, a fallen bro, kills) loaded with the new code (by putting it in
place of the launch's `--snapshot` file): every bro's and fallen's packed stats and tooltips
identical to what old code showed, no errors; a battle, save and load after it count right.
`make check`: syntax, `test.nut` and gfx pass; the Rosetta check fails, as before the fixes,
only because `rosetta -c … .` also extracts strings from `tales/`, `codetests/` and
`mocktests/` (same in other mods with test dirs); on the mod's sources alone it's OK. `test.nut`
opens its files fine under make; run bare (`squirrel test.nut`) it lacks `STDLIB_DIR` and
`ROSETTA_DIR` from `../.env`, hence "cannot open the file".

## Status after fixes (2026-11-13, uncommitted)

The author's notes on known bugs (KNOWN_BUGS.md), quoted.

| # | Note | Status |
| --- | --- | --- |
| KB2 | "fix" | fixed |
| KB3 | "fix" | fixed |
| KB4 | "is it being overwritten later and stuff works? should fix" | it worked, only the error was false; fixed |
| KB6 | "Will the fix lead to huge code changes?" | no: one line moved, two guards added; done |
| KB8 | "They were never compatible, we can't show both or can we?" | "ok, do that, do proper queue >mod_career_stats" | done |
| KB9 | "use comma ," | done |

- **KB2**: `getBattleId` (`preload:18-19`) returns 0 when `::World.Statistics` is missing or null (a main-menu
  scenario, also after a campaign was left: `world_state.onFinish` nulls it). `World.getTime()` works there in the engine, so
  the records go to the scenario bros' throwaway Fun Facts and `actor.kill` completes.
- **KB3**: `onInjury` takes a null attacker as `onDeath` does (`AttackerClass`/`AttackerName` null).
- **KB4**: the engine saves the `null` that `onSerialize` sets for a fallen without facts as the string
  `"(null : 0x00000000)"` (seen in the test); `unpack` threw on it, the catch logged it, the fallen stayed without
  facts, and the next save wrote the same again. So nothing was lost or overwritten wrongly: fallen with facts
  have packed strings at their own index, rewritten on every save. The load (`fun_facts/statistics_manager.nut`)
  now skips a value that starts with neither `Packer.magic` nor `Flags.ChunkMagic`; real errors (a broken packed
  string) are still logged. Saving is unchanged, so old saves load the same way; `KB4` is that round trip.
- **KB6**: one line moved and two one-line guards (with a comment each). `mod.Debug` (the only `::std` use at preload level) moved into the queue function; that
  function returns at once without `::std` (Modern Hooks runs it even with a requirement missing, then its popup
  quits); `scripts/mods/fun_facts/fun_facts.nut` returns at the top without `::std` (the game runs every
  `scripts/` file at boot, the users' line 1 error). Now the only complaint is the "requires stdlib" popup.
- **KB8**: both mods `bindTooltip` the obituary row and vanilla's `bindToElement` unbinds the earlier one, so
  only the mod whose JS loads last shows. Both can be shown: Fun Facts' fallen tooltip appends Career Stats' lines
  (`CareerStats_getTooltipForFallen(_idx)` without its title, the same index) when that function exists, and
  `>mod_career_stats` in the `mods_queue` makes Fun Facts' JS load last, so its tooltip is the one bound. Done:
  `ui_career_stats::KB8` passes in jsdom and Chromium, fails on 1.0.3 (`-r 'mod_fun_facts==1.0.3'`: Career Stats'
  lines missing); `career_stats::KB8 …` now expects Fun Facts' fallen tooltip to be its own lines plus Career
  Stats' (the tooltip's texts compared whole: `FFT.fallenHints` drops ids ≤ 2, and Career Stats' first line has
  id 2). Without Career Stats nothing changes (`ui_page::obituary rows` and the rest pass as before).
- **KB9**: `PlayerKillsHint` joins parts with ", " ("Unwittingly chopped Hans, stabbed Bob and Jon"). The Russian
  rule splits on ", " and glues a chunk starting with a color tag (a name) back to the previous part, since names
  in a list are comma-joined too ("Нечаянно снёс башку Hans, Ulf и Jon, заколол Bob", a new case in
  `rosetta::KB9`). The KB9 tests expect commas now, renamed "parts joined with commas"; `mocktests` too.

Checks: `./bbtales.py --env all -j 8 ../mods/fun_facts/tales/tale_*.nut` before → after: code 46/7/18 → 51/2/18,
engine 60/8/2 → 66/3/2, jsdom 61/9/0 → 67/4/0, ui 61/9/0 → 67/4/0 (pass/fail/skip); exactly KB2 (engine, jsdom,
ui), KB3, KB4, KB6, both KB9 (every env) flip to PASS, nothing else changes (still failing: F3 and both F4 as
before, KB8 in jsdom/ui). `make test` passes; `mocktests` as before but KB9 renamed (F4 still fails there).
KB8, the same run before → after: code 53/2/18 → 53/2/18, engine 67/4/2 → 67/4/2, jsdom 68/5/0 → 69/4/0, ui 69/4/0
after; only `ui_career_stats::KB8` flips to PASS (jsdom, ui), `career_stats::KB8` passes with its new expectation.
The before run's ui lost its bugs and economy launches (F2, ammo ERROR); they ran as usual after.

## Status after fixes (2026-11-13, F3 and F4, uncommitted)

The author's answers in the report's thread: F3 "yes" to never charging vanished shields; F4 "still fix those, don't
need to migrate old shit".

- **F3**: `onCombatEnd` (`ff.nut`) skips an item that has no container and lies on no tile: a shield destroyed without
  the Blacksmith is gone whatever the GC does. With the Blacksmith vanilla drops it on the bro's tile at condition 0
  (`gatherBrothers` runs before `gatherLoot`, so it is still there) and it is charged its full condition, as before.
  New test `bugs::F3: a destroyed shield the Blacksmith keeps is charged its repair` (passes on 1.0.3 too: it guards
  the kept case). `tale_core`'s parts probe now matches the repair the game will do.
- **F4**: the counter lives in the campaign's `World.Flags` (`FunFacts.BattleId`, `preload:11`, `:17-41`), saved with
  it and fresh in a new campaign, so ids grow through saves and loads whoever holds the last one; a save without the
  flag (older version, the mod added mid-campaign) starts once from max + 1 of its records. The root-table cache and
  the `statistics_manager.clear` wrapper that reset it are gone: deriving from records reused an id once the bro who
  fought the last battle left (author: "Battle id should continue incrementing throughout the same campaign"). Old
  saves keep their ids. Counts were right before because they come from the records' lists (`Battles`, `BattlesLog`,
  `Kills`); nothing reads the ids but `getBattleId` itself. New tests `bugs::F4: battle ids aren't reused after the
  bro with the highest one leaves` (fought alone, dismissed, save/load: `[1, 3]`, was `[1, 2]`) and `bugs::F4: an old
  save without the counter continues from its records` (passes on the old code too: it guards the migration);
  `counts stay right through saves loaded out of order` now asserts the ids.

Checks: `taskset -c 0-11 bbtales --env all -j 8 ../mods/fun_facts/tales` before → after: code 52/3/18 → 56/0/18,
engine 68/3/2 → 72/0/2, jsdom 70/3/0 → 74/0/0, ui 70/3/0 → 74/0/0; exactly F3 and both F4 tests flip to PASS in every
env, plus the new F3 test. With `-r 'mod_fun_facts==1.0.3'` the three fail in all four envs. `make test` passes.

The flag rework: before → after code 64/1/8 → 65/0/8, engine 70/1/2 → 71/0/2, jsdom 72/1/0 → 73/0/0, ui 72/1/0 →
73/0/0; only `F4: battle ids aren't reused…` flips to PASS. ui's launches timed out under a load average of ~40 (other
suites); their files rerun with `-j 2` all pass.

## Notes (not filed as bugs)

- A struck-down bro (`Unconscious`, survives) counts as a death ("Died once …"), and his
  struck-down by a brother as that brother's player kill ("Unwittingly killed X" while X
  lives). Bros struck down by their own bleeding get a `Self` record in `Kills`. Looks
  deliberate (KNOWN_BUGS #5's "Died 2 times" is such a bro), the wording isn't.
- With the uncommitted change `FunFacts.m.Name` is `"<not-set>"` until `setName`, `setTitle`
  or a load (starting bros and event recruits keep it until the first load). Only the
  pre-v3 migration reads it, after a load, so nothing shows; Debug output would.
- A bro never loaded packs `Stats.Version = 1` (the default), so every first load runs the
  v1→v3 migrations over current records. They are no-ops on them.
- KNOWN_BUGS #7 (save growth): 100/200/400 battles with 2 kills each pack to
  4596/9096/18096 bytes, linear, ~45 bytes a battle. Nothing quadratic in the mod's data.

## Known bugs: reproduction status

From `KNOWN_BUGS.md`; tests named `KB<n>`.

| # | Status | Test | Result now |
|---|---|---|---|
| 1 | fixed in the working tree (uncommitted) | `reforged::KB1: …` (2 tests) | pass; with `mod_fun_facts_1.0.3.zip` the event test fails with the users' stack: `getID` at `nested_tooltips.nut:28` ← `setPlayer` `fun_facts.nut:102` ← `master_no_use_apprentice_event.nut:64` |
| 2 | fixed 2026-11-13 (uncommitted) | `scenario_mode::KB2: a kill in a main-menu scenario` | pass in engine, jsdom, ui (code skips: no scenario map); failed before with `the index 'Statistics' does not exist` (`getBattleId`, `preload:21`) aborting `actor.kill` |
| 3 | fixed 2026-11-13 (uncommitted) | `known_bugs::KB3: a bro injured by an attacker-less hit` | pass in every env; failed before with `the index 'ClassName' does not exist` (`ff.nut:259`) |
| 4 | fixed 2026-11-13 (uncommitted) | `known_bugs::KB4: fallen without fun facts load without errors` | pass in every env; failed before with the user's `Failed to load fallen FunFacts: … does not start with a magic string` on every load |
| 5 | not reproduced | `tooltips::death lines`, `rosetta::KB5: …` | pass in English and with Rosetta's Russian ("Умер 2 раза. Один из них от руки товарища."); the reported `format` error needs a modified build |
| 6 | fixed 2026-11-13 (uncommitted) | `tale_no_stdlib.nut` | pass in every env: only the loader's "requires stdlib" popup; failed before at boot, `::std` at `preload:16` |
| 7 | not a bug in the data | `known_bugs::KB7: packed size grows linearly with history` | pass: linear, ~45 bytes a battle (see Notes) |
| 8 | not tested | — | Career Stats isn't installed |
| 9 | fixed 2026-11-13 (uncommitted) | `tooltips::KB9: …`, `rosetta::KB9: …` | `tooltips::KB9`, `rosetta::KB9` (now "parts joined with commas") pass in every env |
| 10 | fixed, regression passes | `known_bugs::KB10: a huge fun facts blob survives save/load` | pass: 3000 kills (> 64000 chars, chunked) round-trip |
| 11 | fixed, regression passes | `known_bugs::KB11: an enemy injured by an attacker-less hit` | pass |
| 12 | fixed, regression passes | `reforged::KB12: …` (2 tests) | pass; Reforged 0.8.18 no longer passes a null killer, so these can't catch a regression of the `ff_killer` fallback itself |
| 13 | fixed, regression passes (simulated) | `known_bugs::KB13: adding the mod to an existing campaign` | pass: a save without any Fun Facts flags loads, a battle is tracked. No Legends/Vala here |

## Known bugs with real third-party mods (2026-11-12)

Real mods from `bbtales/mods/` (`VERSIONS.md`): Legends 19.4.23, Reforged 0.9.3, Hardened 1.26.3,
Career Stats 1.0.2 (Nexus 569, newest; copied as `mod_career_stats-1.0.2.zip`).

| # | Status | Tests | Result |
| --- | --- | --- | --- |
| 1 | fixed in the working tree, regression passes on Reforged 0.9.3 + Hardened | `hardened_bugs::KB1: ...` (2 tests) | pass on HEAD. The released 1.0.3 zip fails both with the users' stack (`nested_tooltips.nut:28` ← `fun_facts.nut:102` ← `master_no_use_apprentice_event.nut:64`, now via `mod_hardened/api/hooks/events/event.nut:67`); after that event error Reforged's event nesting stays on, and the next save load fails too (`LoadingScreen.onScreenShown: the index 'getID' does not exist`, from `setPlayer` in `loadCampaign`) |
| 7 | not reproduced on Legends | `legends_bugs::KB7/KB10: long histories through a Legends save and load` | pass: 300 battles/600 kills on each bro and 100 fallen with 50 battles each round-trip on Legends; 13296 packed bytes a bro. Save time not measurable headless (`Time.getRealTimeF` doesn't advance during a call) |
| 8 | Squirrel side: no conflict; JS side: **obituary tooltip clash, confirmed by code** | `career_stats::KB8: ...` (2 tests) | pass: both mods count the battle, both tooltip lines, the fallen carries both, obituary row data has both `FunFacts_Idx` and `CareerStats_Idx`, all after save/load. But both mods' `world_obituary_screen.js` wrap `addListEntry` and call `bindTooltip` on the same row; vanilla `TooltipModule.bindToElement` first does `unbindFromElement` (`off` of all its handlers), so only the mod whose wrapper runs last shows its obituary tooltip. That matches the author's guess "graveyard tooltips". Untestable headless (no JS). Fix: bind a tooltip only if none from the other mod, or combine (e.g. add Fun Facts lines to the MSU generic tooltip when `CareerStats_Idx` is present). The roster tooltip has duplicate entry ids (6 and 7 twice), harmless (ids only name DOM nodes) |
| 10 | fixed, regression passes on Legends | `legends_bugs::KB7/KB10: ...` | pass |
| 11 | fixed, regression passes on Reforged 0.9.3 + Hardened | `hardened_bugs::KB11: ...` | pass |
| 12 | fixed, regression passes on Reforged 0.9.3 + Hardened | `hardened_bugs::KB12: ...` | pass |
| 13 | fixed, regression passes on real Legends | `legends_bugs::KB13: ...` (2 tests) | pass on HEAD. The 1.0.0 zip fails with the users' stack: `the index 'Start' does not exist` at `fun_facts.nut:158` ← `fun_facts/player.nut:30` ← `mod_legends/hooks/states/tactical_state.nut:788` |

`--isolate` and packed agree (all pass). No engine divergence met.

## In the real UI page (2026-11-12, headless Chromium)

The mod's JS run in the game's page (`bbtales.py --env ui`, `~/projects/bbm/bbtales/UI_VARIANTS.md`), on the working tree.

| # | Result | Test |
|---|---|---|
| KB8 | **confirmed in the page**: with Career Stats 1.0.2 (Reforged 0.9.3, Modern Hooks 0.7.0, MSU 1.9.0) the obituary row's tooltip shows only Fun Facts' lines, `"<name> \| Died once"`; Career Stats' ("DMG Dealt …"), which Squirrel returns for the same fallen, never shows. Both mods `bindTooltip` the row (their `world_obituary_screen.js`), the later binding wins | `ui_career_stats::KB8: the obituary row's tooltip carries both mods' lines` (fails while open) |
| — | the obituary row's MSU tooltip as drawn: `"Remembered \| Died once \| Chopped 3 heads"` (the bbui example's check) | `ui_page::obituary row tooltip: the fallen's facts, drawn` (passes) |

The whole suite with the page (`./bbtales.py --env ui -j 8 ../mods/fun_facts/tales/tale_*.nut`) gives the same statuses as
headless, and the page logged no errors (no `console.error`, no uncaught exception).

## In the real UI page, jsdom (2026-11-12)

The mod's JS run in the game's page in jsdom under Node (`bbtales.py --env jsdom`, "Variant 1" in
`~/projects/bbm/bbtales/UI_VARIANTS.md`). Tests: `./bbtales.py ../mods/fun_facts/tales/tale_ui_js_*.nut`.

| # | Result | Test |
|---|---|---|
| KB8 | **confirmed** (as with Chromium above): a fallen bro's obituary row, hovered, shows Fun Facts' lines and none of Career Stats' ("DMG Dealt …"). With Career Stats' binding put back on the row by hand, the same check sees all of Career Stats' lines and none of Fun Facts': the later `bindTooltip` wins | `ui_js_kb8::KB8: a fallen bro's obituary row shows both mods' tooltips` (fails while open) |
| — | the obituary rows and their hover tooltips: `["Remembered", "Died once"]`, `["Old Timer", "Noone remembers anything fun about this dude."]` | `ui_js_obituary::obituary rows: Fun Facts' tooltip on hover` (passes) |

The suite with the page (`./bbtales.py --env jsdom -j 8`, the files but `ui_*`, against a plain run right after) gives the
same statuses but one: `economy::ammo: what an archer shot` fails on `the index 'getActor' does not exist` in vanilla's
`shield.nut` (`applyShieldDamage` from `skill.onShieldHit`), a Squirrel error on a battle path the page's timing
led to (an arrow on a thug's shield); no page error. The page logged no errors of the mod's.
