# Nicknames for Everyone — known bugs

Collected 2026-11-11 from: Nexus Posts/Bugs tabs (https://www.nexusmods.com/battlebrothers/mods/1013, Bugs tab is
empty), Discord mod threads (Reforged `1503362601722183710`, Legends `1503362808950296771`), Discord search for
"nicknames" in Legends/Reforged/BB Modding, `service/data/` scrapes and logs, `service/jobs/` (no nicknames cases),
CHANGELOG and git history. Current version 0.8.0 (tag `nicknames-0.8.0`, 2026-08-10); HEAD adds only the vanilla
Executioner background (`dbc1146`).

Code refs are to `nicknames/scripts/!mods_preload/mod_nicknames.nut` (HEAD) unless stated.

Very few user reports exist; every reported crash is fixed. Entries 1–2 were bugs found by reading the code while
checking reports, not reported by users — flagged as such; both are fixed.

## Open / unclear

### 1. Title state leaks between campaigns in one game session — fixed 2026-11-13, uncommitted (code reading, not user-reported)
- Source: code reading. `def.State` is a module-level cache: `loadState()` (lines 145–150) returns it whenever it is
  non-null, and nothing resets it on load or new campaign (only `test.nut` sets `def.State = null`).
- Mods: any.
- Symptoms (expected): after loading another save, or starting a new campaign without restarting the game, the
  "generated" (14-day) and "hired" title sets of the previous campaign are used. Fresh bros avoid titles of bros from
  the other campaign. `saveState()` (line 153) then writes the stale state into the new campaign's
  `World.Flags["nicknames.state"]`, so the leak is saved.
- Suspected code: `def.loadState` lines 145–150; missing reset hook on `world_state.onBeforeDeserialize` / `startNewCampaign`.
- Fix: `world_state.onDeserialize` and `startNewCampaign` set `def.State = null` before the original, so each
  campaign reads its own flag; `known_bugs::KB1` and `known_bugs_ct::KB1` pass in code and engine.
- Repro idea: campaign A, hire a bro, note its title T (now in `state.hired`); start campaign B in the same VM
  (or deserialize another save). Assert `::Nicknames.loadState().hired` has no T, and that B's `World.Flags` unpack of
  `nicknames.state` has no titles of A.

### 2. `def.logOut()` references undefined `_key` — fixed 2026-11-13 (code reading, debug-only)
- Source: code reading, line 278: `::World.Flags.remove(def.FlagPrefix + _key)` inside `foreach (key, _ ...)`.
- Symptoms: script error "the index '_key' does not exist" when `logOut()` is called. Only reachable with `Debug = true`
  plus a manual call, so users cannot hit it.
- Repro idea: set `::Nicknames.Debug = true`, generate a few bros, call `::Nicknames.logOut()`; assert no error and
  that the `nicknames.factors*` flags are gone.

### 3. Save broke "within a day" with Hardened + Black Pyramid submods — unclear
- Source: Reforged thread https://discord.com/channels/1006908336991645757/1503362601722183710/1521420387827716148
  (hzlt, 2026-06-30), follow-up to #5.
- Mods: Hardened, "Davkul Rising" (F1, Black Pyramid thread), 5 Black Pyramid submods; peasant militia origin. Nicknames
  0.5.2 patched locally by the reporter.
- Symptoms: after the reporter's own guard for missing `Titles`, the game started but "corrupted my save game regardless
  within a day of starting"; the reporter then removed the Black Pyramid mods and kept Nicknames with no further issues.
  No log. Probably not Nicknames, but never confirmed.
- Suspected code: none located. 0.7.1 and 0.8.0 (Black Pyramid factors) touched this area since.
- Repro idea: only if Black Pyramid content is loadable: Reforged, peasant militia origin, hire ~10 bros with BP
  backgrounds/traits, advance 1–2 days, save, load. Assert load succeeds and every bro has a non-empty string title.

## Fixed

### 4. Crash and broken save after the King's Guard event (Legends) — fixed in 0.8.0
- Sources: Nexus post https://www.nexusmods.com/battlebrothers/mods/1013?tab=posts&jump_to_comment=171856229
  (knight03, 2026-07-05, log at limewire, author: "Will fix in the next release"); Legends thread
  https://discord.com/channels/547043336465154049/1503362808950296771/1523325558078050457 (log1.html attached);
  Legends help https://discord.com/channels/547043336465154049/1523298456507125872/1523338670604681227 (another user, same event).
  Test build `mod_nicknames_0.7.1_EVENTS1.zip`; commits `5734d1c` (talents guard), `8185bad` (defer event bros to
  `onHired`).
- Mods: Legends (log1.html: Legends + Elite Few + Swifter + Configurable Pause + Events Delayed Fix + Clever Recruiter),
  Nicknames 0.7.1.
- Symptoms: event text garbled, roster screen won't open after the event, saving then gives a save that does not load.
  Log1.html, first error:
  ```
  Script Error: the index '0' does not exist
    at -> scripts/!mods_preload/mod_nicknames.nut : 77   (stars = _bro.m.Talents[...])
    at -> scripts/!mods_preload/mod_nicknames.nut : 164  (buildCandidates)
    at -> scripts/!mods_preload/mod_nicknames.nut : 205  (fillTitle)
    at -> scripts/!mods_preload/mod_nicknames.nut : 311  (setStartValuesEx hook, _addTraits = False)
    at -> mod_legends/hooks/events/events/dlc4/kings_guard_1_event.nut : 21
  ```
  Legends' King's Guard calls `setStartValuesEx(..., _addTraits = false)`, so `m.Talents` is empty, and the error
  leaves the bro half-built.
- Code now: `buildFactorSet` lines 74–78 guard empty talents; `inEvent` flag (lines 290–310) defers event bros' titles
  to `onHired` (lines 347–358).
- Repro idea: Legends campaign; fire `scripts/events/events/dlc4/kings_guard_1_event` (or any event that creates a bro
  with `setStartValuesEx(bgs, false)`), pick the recruit option. Assert: no script error; the bro gets a title on
  hire; the roster screen data builds (`convertEntityToUIData`); save + load works. Also unit: bro with empty
  `m.Talents` → `fillTitle` must not throw.

### 5. Startup hang with traits/backgrounds lacking `m.Titles` (Black Pyramid) — fixed in 0.7.1
- Source: Reforged thread https://discord.com/channels/1006908336991645757/1503362601722183710/1521260482718339232
  (hzlt, 2026-06-29, attached patch notes: error `the index 'Titles' does not exist`); commit `10e08df`.
- Mods: Reforged + Hardened + Black Pyramid submods, Nicknames 0.5.2.
- Symptoms: new campaign stuck on the loading screen after the intro event; `the index 'Titles' does not exist` from
  `buildCandidates`, which aborts `startNewCampaign` while generating the roster.
- Code now: `buildCandidates` lines 188–200 check `::std.Util.isIn("Titles", ...)`.
- Repro idea: register a trait and a background class whose `m` has no `Titles` slot; generate a bro with them via
  `setStartValuesEx`, and also start a new campaign with such a bro in the starting roster. Assert no error, title set.

### 6. Modern Hooks warning about `setStartValuesEx` parameter count (Legends) — fixed in 0.5.2
- Source: Legends thread https://discord.com/channels/547043336465154049/1503362808950296771/1503439015288770652
  (mmgru, 2026-05-11, confirmed by woo77simon); author: "Fixed in 0.5.2"; commit `c995c3b`.
- Symptoms: `Mod mod_nicknames (Nicknames for Everyone) is wrapping function setStartValuesEx in bb class
  scripts/entity/tactical/player with fewer total parameters (used to be 4, wrapper returned function with 2)`.
- Code now: Legends-specific 4-parameter wrapper, lines 329–337.
- Repro idea: load with Legends; assert no Modern Hooks warning mentioning `mod_nicknames` in the log, and that
  `setStartValuesEx(bgs, true, gender, false)` passes all 4 arguments through (e.g. `_addEquipment = false` → no items).

### 7. Endless loading screen with Legends when stdlib is missing — fixed in 0.6.0 (likely)
- Sources: Legends https://discord.com/channels/547043336465154049/1505701402314408027/1505701402314408027 (2026-05-17, "forever loading
  screens when used with legends"); replies: "the nicknames mod requires stdlib"
  (https://discord.com/channels/547043336465154049/547043336465154051/1506330929352933426) and the same on Reforged
  (https://discord.com/channels/1006908336991645757/1283857645492502549/1507079984978591805). 0.6.0: "require
  dependencies properly" (`be8b3d2`).
- Symptoms: hang instead of a clear "missing dependency" message.
- Code now: `mod.require("stdlib >= 2.5")`, line 20.
- Repro idea: load without stdlib; assert Modern Hooks reports the missing dependency and no script error from
  `mod_nicknames.nut`.

## Not bugs / feature requests (skipped)
Titles not updated after BrEditor adds a trait (by design: assigned once at generation, Nexus 2026-08-15); missing "the"
before titles (done in 0.6.0); title ideas (animals, "Tempo", Augmenteds perks); "Rotu compatibility?" (unanswered
question); "breditorbug" titles on Reforged (Breditor, not this mod).

## Repro status (headless scenario tests, 2026-11-11)

Tests in this dir, run per `README.md`; details and evidence in `FOUND_BUGS.md`.

1. Reproduced — `known_bugs::KB1`: after loading an earlier save, `loadState()` kept the
   later hire, and the next title written stored it in the loaded campaign's flags; fixed 2026-11-13, the tests pass.
2. Reproduced — `known_bugs::KB2`: `logOut()` threw `the index '_key' does not exist`; fixed, the test passes.
3. Not ours, fixed in Black Pyramid 1.x: Black Pyramid 0.4's own save bug (its item serializer reads one byte
   off after a load from the main menu, `~/projects/bbm/bbtales/OTHER_MODS_RESULTS.md`); BP 1.4.4 reads it right. The
   test on BP 0.4 (`reforged_bp_kb3`) is removed; `hardened_bp_bugs::KB3` covers BP 1.4.4.
4. Fixed, regression tests `known_bugs::KB4` (vanilla King's Guard event, and
   `setStartValuesEx(.., false)` outside events); both fail on 0.7.0/0.7.1 with
   `the index '0' does not exist`. Not run with Legends itself (not installed).
5. Fixed, regression test `known_bugs::KB5`; fails on 0.7.0 with `the index 'Titles' does not exist`.
6. Fixed, regression test `legends_stub::KB6` against a Legends stub (4-parameter
   `setStartValuesEx`), not real Legends.
7. Fixed, regression test `no_stdlib::KB7`: Modern Hooks names the missing stdlib and raises its
   quitting popup; no script error from the mod.

### With real third-party mods (2026-11-12)

Legends 19.4.23, Reforged 0.9.3, Hardened 1.26.3, Black Pyramid 1.4.4, Davkul Rising RF/HD compat 0.4; details in
`FOUND_BUGS.md`.

1. #3 — not reproduced with Hardened + Black Pyramid 1.4.4 + Davkul Rising (`hardened_bp_bugs::KB3`, 3 tests): undead
   forms, 2 days, two save/load rounds, all intact.
2. #4 — regression passes on real Legends (`legends_bugs::KB4`); the 0.7.1 zip fails there with the users' error.
3. #6 — regression passes on real Legends (`legends_bugs::KB6`), no Modern Hooks warning.

## Discord deep search (2026-11-12)

Checked: all hits of "nicknames", "mod_nicknames" on Legends, Reforged and BB Modding since 2026-04 (25 messages,
mostly general chat about server nicknames), 3 contexts, 2 logs downloaded to `service/tools/discord_deep/discord_logs/`.
No new Nicknames bugs.

### Extends existing

- **#4 Crash after the King's Guard event (Legends) — two more reports, both on 0.7.1, one after 0.8.0 was out.**
  - https://discord.com/channels/547043336465154049/1523298456507125872/1523317432385671260 (reasonthevoiceof,
    2026-07-05, Legends 19.4.9). Chopeks: "`mod_nicknames` … report it there, this isn't legends problem". Log
    `discord_logs/legends_1523317432385671260_log.html`.
  - https://discord.com/channels/547043336465154049/556218801872699414/1553435026589225043 (baneslayer9640,
    2026-09-26, Legends 19.4.22, Nicknames **0.7.1**): "Something wrong with king guard event / After this i cant open
    roster or save load savefile". z1rkel4o pointed at Nicknames (…/1553438966143787090). Log
    `discord_logs/legends_1553435026589225043_log.html`.
  - Both logs show the same stack as #4:
    `the index '0' does not exist` at `mod_nicknames.nut : 77` ← `: 164` ← `: 205`.
  - Fixed in 0.8.0. People still run 0.7.1 seven weeks after the release, so it is worth a note on the Nexus page or a
    pinned post in the Legends thread.

### Skipped
- "I did see a bug report regarding mod_nicknames" (Legends #general 2026-07-08): refers to #4.
- kofun translated the titles (Legends 2026-06-01): a translation, not a bug.


## Repro status (Discord section)

No new entries; #4 is covered by `known_bugs::KB4` (fixed in 0.8.0; fails on 0.7.0/0.7.1).
