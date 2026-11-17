# Retinue Promotions — known bugs

Collected 2026-11-11 from: a fresh full crawl of the Nexus Bugs and Posts tabs of
https://www.nexusmods.com/battlebrothers/mods/681 (`bugs.jsonl`/`posts.jsonl` in the session scratchpad, cross-checked
with `service/data/nexus_hackflow.jsonl`), per-mod Discord threads (`service/data/discord_reforged_mods.jsonl`,
`discord_legends_bbmodding_mods.jsonl`), Discord searches (`discord_search.jsonl`, `discord_help_hidden.jsonl`,
`norm/*.jsonl`), the user logs in `service/data/logs/**` (grepped for stack frames inside the mod's dirs), and the fix
history (CHANGELOG, tags with their dates, `FIX.md`, `TO_RELEASE.md`). Pure feature requests, install errors (missing
stdlib/Modern Hooks, mod unzipped) and "another mod is the culprit" threads are skipped or get one line.

Links: Nexus posts `https://www.nexusmods.com/battlebrothers/mods/681?tab=posts&jump_to_comment=<id>`, Nexus bugs
`...?tab=bugs&issue_id=<id>`; Discord `https://discord.com/channels/<guild>/<thread>/<msg>`, guilds: Legends
547043336465154049, Reforged 1006908336991645757, BB Modding 965324395851694140. Entries from `discord_search.jsonl`
or `discord_help_hidden.jsonl` have no channel id in the data, so they are cited by file + message id.
"Fixed in X" is inferred from CHANGELOG entries plus tag dates against report dates; where the match is not
explicit it says so. Code paths are relative to `mods/`.

## Open / unclear

### 1. Promotion survives loading an older save: cost and effects stay promoted — open
- Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/681?tab=bugs&issue_id=935478 (1.2.2, 2025-04-18)
- Setup: vanilla; hire Trader (3500), promote (7000), load an earlier save without restarting the game.
- Symptoms: the Trader's hiring cost shows 10500 and his tooltip lists the promoted effect, yet "Promote" is still offered. Restarting the game fixes it.
- Suspected code: `retinue_ups/scripts/!mods_preload/mod_retinue_ups.nut:47-53` — `onDeserialize` only calls
  `ru_onPromote()` for flagged followers and never `ru_onDemote()` for the rest. Vanilla `retinue_manager.onDeserialize`
  → `clear()` resets only `Slots`, so the follower objects (with `m.ru_base`, raised `m.Cost`, extended `m.Effects`) survive the load.
- Repro: new campaign (Desert DLC on); hire `follower.trader`; save A; `World.Retinue.ru_promote(trader)`; load A in the
  same session → assert `trader.m.Cost == 3500`, `!("ru_base" in trader.m)`, `Effects` have no promotion line.

### 2. Promotions revert after loading a save (Legends 18.2+, More Retinue Slots, "Pandora's Hobby" recruiter) — open, unclear (Legends reworked the retinue; the author does not support it)
- Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/681?tab=posts&jump_to_comment=134630420 (2024-03-10)
  and the reply ...=153879951 (2025-05-10, test save + log on mediafire); `discord_search.jsonl` msg 1503024067035267252 (Reforged #submods-chat, 2026-05-10)
- Symptoms: works within a session; after quitting to the menu and loading, promoted effects (e.g. cheaper tryouts) are gone.
- Suspected code: same `onDeserialize` hook (`mod_retinue_ups.nut:47`); depends on `World.Flags` being deserialized before
  `World.Retinue` (true in vanilla `world_state.onDeserialize`); a mod that reorders this or rebuilds followers loses the promotion.
- Repro: promote the Recruiter, save, restart the world state (fresh `world_state`), load → assert
  `World.Retinue.ru_isPromoted(recruiter)` and the tryout cost multiplier still applies. Also with More Retinue Slots if available.

## Fixed

### 3. Cannot replace an existing retinue member: `the index 'ru_base' does not exist` — fixed in 1.2.2 ("fixed removing a retinue member")
- Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/681?tab=bugs&issue_id=773194 (0.7);
  https://discord.com/channels/1006908336991645757/1325799128982360140/1349019509616410694 (log `logs/Reforged/1349019509616410694/log.html`)
- Error: `the index 'ru_base' does not exist` at `scripts/!mods_preload/mod_retinue_ups.nut : 123 <- : 47 <- : 22 <- onHireFollower`.
- Repro (regression): hire a non-promotable follower into slot 3 (blacksmith), then hire another into the same slot → assert no error and the new follower is in the slot.

### 4. Battles never end (camera pans out, no loot screen) — fixed in 0.7 (stray `::std.Debug.log()`)
- Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/681?tab=bugs&issue_id=758595

## Not bugs / feature requests (skipped)

BB-Edit save editor breaking (Nexus ...=158564878, external tool), Legends "index 'Dude'" (Legends unsupported), "throwing errors" with a modified copy (reinstall fixed).

## Repro status (headless scenario tests, 2026-11-12)

Suite in this dir, overview with commands in `~/projects/bbm/bbtales/OTHER_MODS_RESULTS.md`. "Reproduced"
= a test fails now naming the bug; "passes" = regression test green.

- #1 reproduced (+ root cause: `ru_onDemote` leaves `m.ru_base`, new RU2); #2 not
  reproduced within a session; #3 passes. New: RU1 (ctrl-click on an empty slot throws).

## Discord deep search (2026-11-12)

Systematic search of Legends, Reforged and BB Modding: every mod's display name, short forms, id and zip name, "hackflow",
hackflow's own messages (author id; BB Modding capped at 1000 of 1772) and mentions of him; plus a sweep of the 300 newest
log.html attachments not collected before (120 Legends, 120 Reforged, 60 BB Modding) for stack frames in hackflow mods' files.
Logs are in `service/tools/discord_deep/discord_logs/` (listed in its `INDEX.md`); scripts `service/tools/discord_deep/discord_deep*.py`.

Numbering continues the list above.

### 5. 1.2.0 floods the log with `faction.update ID=… Name=…` on every faction update — fixed in 1.2.1 (`38ad5f0` "move out an unrelated fix")
- Source: https://discord.com/channels/1006908336991645757/1369635691516137514/1370229959804583937 (Reforged
  #technical-help, 2025-05-09, author: "logs about faction.update is from Retinue Promotions — update it, some debug
  code slipped to some older release"); Darxo earlier: "One of your mod is activating extensive logging"
  (https://discord.com/channels/1006908336991645757/1369635691516137514/1370033661822373948).
- Setup: Reforged 0.7.6, Retinue Promotions 1.2.0. Log `discord_logs/x_1369881243751157781/log.html`
  (from `reforged_1369881243751157781_log.zip`): 63 933 `faction.update` lines, 13 MB log, makes logs useless and too big
  to attach.
- Code (1.2.0 zip `retinue_ups/mod_retinue_ups_1.2.0.zip`, `scripts/!mods_preload/mod_retinue_ups.nut:18-20`):
  a `factions/faction.update` hook (an unrelated "skip units without troops" fix) starting with
  `::logInfo("faction.update ID=" + m.ID + " Name=" + m.Name);`. Removed in 1.2.1 together with the hook.
- Repro (regression): load the mod, advance the world 1 day, assert no `faction.update` line was logged (count log
  lines through a `::logInfo` spy).

### 6. `::mods_hookNewObjectOnce` hooks lost when the game recreates a singleton (load → main menu → load) under Reforged/MSU — fixed (Retinue Promotions before its first release `retinue-ups-0.5`, commit `1c96f6c` 2023-11-10; same fix in Elite Few 2.3.1 `efb6b62`, Events Delayed Fix 0.7 `6596680`, Hackflow's Perks 1.2 `bad6c59`, Cool and Blacksmith Fix `f34a21e`, all 2023-11-17/21; Cheap Meat CHANGELOG: "fixed hookNewObjectOnce() bug: stopped working after second game load")
- Source: hackflow's own Reforged bug threads https://discord.com/channels/1006908336991645757/1172046777147478068/1172048433712996413
  ("[0.2.1] Can't load game occasionally", 2023-11-09: "changing `mods_hookNewObjectOnce()` to `mods_hookNewObject()` on
  retinue/retinue_manager helped"; Lord Midas: the object is destroyed/recreated during world_state or game loading, so
  the hook is gone for the new instance) and https://discord.com/channels/1006908336991645757/1172125017471975454/1172924153561624686
  ("like 6 of my mods were a bit broken by this `...NewOnce()` thing", 2023-11-11).
- Setup: Reforged 0.2.x–0.3.x, MSU; vanilla has the same trap whenever an object is re-created.
- Symptoms: crash on loading a save after returning to the main menu (error in `settlement.onDeserialize`); hooked
  behaviour silently gone on the recreated object (promotions not applied, campfire Ctrl+click dead, etc.).
- Code now: every mod uses Modern Hooks `mod.hook`/`::mods_hookNewObject`; `git grep hookNewObjectOnce` finds no code
  use left in `mods/`.
- Repro: start a campaign, save, quit to the main menu, load the save, then load it again; assert
  `::World.Retinue.setFollower` is still the wrapped one (e.g. promoting a follower changes its effects) and no script
  error during deserialize. Same check for each mod's hooked singleton (`world_campfire_screen`, event manager).

### Extends existing

- **Skipped "throwing errors" with a modified copy** — another case: `discord_logs/reforged_1368280376979619964_log.html`
  (https://discord.com/channels/1006908336991645757/1283857645492502549/1368284854340423840, 2025-05-03, Lord Midas: "retinue_ups
  is throwing an error"; author: modified broken version, redownload,
  https://discord.com/channels/1006908336991645757/1283857645492502549/1368413216669040711). Error:
  ```
  Script: Failed to load script file "scripts/!mods_preload/mod_retinue_ups.nut". Reason: "expression expected" line:221 column:20.
  Script Error: the index 'mod_retinue_ups' does not exist
    at -> modern_hooks/public_globals.nut : 20
    at main -> scripts/i_retinue_ups_levelup_changes.nut : 20
  ```
  The official 1.2.2 zip compiles (line 221 is `local cook = ...` in `dropFood`), so the user's copy was edited. A side note:
  that `local cook` in 1.2.2 `mod_retinue_ups.nut:221` is dead code.

### Skipped

- Robber baron without miniboss gear blamed on Retinue Promotions (Lord Midas found nothing; `tnf` mod suspected,
  https://discord.com/channels/1006908336991645757/1006908337981509725/1497767594252439723); "Promoted Surgeon fixes permanent
  injuries 10% per level" (by design).
- Retinue Promotions compile error at line 221 (Reforged 2025-05-03): edited copy, in `other_A.md`.

## Repro status (Discord section)

Headless tests, 2026-11-12, in this dir's `tale_discord_bugs*.nut`; details in `FOUND_BUGS.md`.
Open/unclear entries of the Discord section only.

1. Fixed entries #5, #6 got no regression tests.
2. Legends 19.4.23 / Hardened 1.26.3 / Reforged 0.9.3 (2026-11-12):
   #2 reproduced on Legends (`legends_bugs_retinue::RU-KB2 legends`: flag kept, cost/effects reverted; Legends'
   instance `onDeserialize`). New: RU-L1.
