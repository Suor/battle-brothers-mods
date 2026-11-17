# Camps and Artifacts Reworked — known bugs

Collected 2026-11-11 from: a fresh full crawl of the Nexus Bugs and Posts tabs of
https://www.nexusmods.com/battlebrothers/mods/678 (`bugs.jsonl`/`posts.jsonl` in the session scratchpad, cross-checked
with `service/data/nexus_hackflow.jsonl`), per-mod Discord threads (`service/data/discord_reforged_mods.jsonl`,
`discord_legends_bbmodding_mods.jsonl`), Discord searches (`discord_search.jsonl`, `discord_help_hidden.jsonl`,
`norm/*.jsonl`), the user logs in `service/data/logs/**` (grepped for stack frames inside the mod's dirs), and the fix
history (CHANGELOG, tags with their dates, `FIX.md`, `TO_RELEASE.md`). Pure feature requests, install errors (missing
stdlib/Modern Hooks, mod unzipped) and "another mod is the culprit" threads are skipped or get one line.

Links: Nexus posts `https://www.nexusmods.com/battlebrothers/mods/678?tab=posts&jump_to_comment=<id>`, Nexus bugs
`...?tab=bugs&issue_id=<id>`; Discord `https://discord.com/channels/<guild>/<thread>/<msg>`, guilds: Legends
547043336465154049, Reforged 1006908336991645757, BB Modding 965324395851694140. Entries from `discord_search.jsonl`
or `discord_help_hidden.jsonl` have no channel id in the data, so they are cited by file + message id.
"Fixed in X" is inferred from CHANGELOG entries plus tag dates against report dates; where the match is not
explicit it says so. Code paths are relative to `mods/`.

## Open / unclear

### 1. Artifact weapon with negative head-hit chance breaks MSU serialization — open (Hackflow said MSU tightened checks broke his fix; LordMidas said he would handle it on the Reforged side — not verified)
- Source: `discord_help_hidden.jsonl` msg 1455202594757546034 (Reforged #general, 2025-12-29); logs
  `service/data/logs/Reforged/1454778333266182238/log.html`, `.../1455064633231802541/`, `.../1455202594757546034/`
  (32 occurrences overall)
- Setup: Reforged (+ Hardened), C&A 3.5.2, MSU 1.7+, mod_persistent_characters or anything using MSU SerDe emulator
- Symptoms: `The value of the variable '-25' is not acceptable` at `writeU8 -> msu/systems/serialization/serde_emulator.nut : 121`
  `<- onSerialize -> scripts/items/weapons/artifact/artifact_weapon.nut : 127`; crash when a Fallen Hero is hit by Bone Breaker.
- Suspected code: `camps_and_artifacts/scripts/items/weapons/artifact/artifact_weapon.nut:127`
  (`_out.writeU8(this.m.ChanceToHitHead)`); the 3.5.1 fix only remaps on deserialize (same file, ~line 160).
- Repro: Reforged on; create any artifact weapon whose base `ChanceToHitHead` is negative under Reforged (fencing
  sword / southern swords, -25), serialize it through `::MSU.Class.SerDeEmulator` (or the game's own writer) → assert
  no error, and that a save/load round-trip keeps `ChanceToHitHead == -25`.

### 2. `the index 'ca_getCamps' does not exist` spam from build_citystate_camp_action — open/unclear
- Source: Discord Reforged thread https://discord.com/channels/1006908336991645757/1180373120415178854/1414419759893708982
  (2025-09-08, "southern village contract doesn't appear at all"),
  https://discord.com/channels/1006908336991645757/1180373120415178854/1441517239894544615,
  https://discord.com/channels/1006908336991645757/1180373120415178854/1443604724543787108; Reforged dev replies
  in `discord_search.jsonl` msgs 1447675423852068874, 1426059736226205788, 1409281521273274378; logs
  `logs/Reforged/1441517239894544615/`, `1443604724543787108/`, `1447657982493196309/` (hundreds of lines each)
- Setup: Reforged + **Hardened** in every log seen, C&A 3.5.1 and 3.5.2; only the city-state action fails, never the noble one.
- Symptoms: `the index 'ca_getCamps' does not exist` at `onUpdate -> scripts/factions/actions/build_citystate_camp_action.nut : 12`
  every faction update.
- Suspected code: `camps_and_artifacts/camps_and_artifacts/factions/faction.nut:1-48` (hook applied via
  `mods_hookExactClass("factions/city_state_faction")` and patching `cls[cls.SuperName]`) together with
  `camps_and_artifacts/camps_and_artifacts/config/faction_traits.nut:4` (action pushed to every faction with the
  OrientalCityState trait). Some faction with that trait evidently isn't a hooked `city_state_faction` instance under
  Hardened — not confirmed.
- Repro: vanilla+Reforged (Hardened if available) new campaign with Desert DLC; iterate `World.FactionManager` factions
  that have `build_citystate_camp_action`, assert `"ca_getCamps" in f`; run `faction.update()` and assert no error.
  Also run it after a save/load.

### 3. Battle maps sometimes generate as the arena floor → crash/infinite loading entering a C&A location — fixed in C&A (vanilla root, V2 in `../../VANILLA_BUGS.md`)
- Source: https://discord.com/channels/1006908336991645757/1180373120415178854/1253396125524955156 (2024-06-20, log
  `logs/Reforged/1253396125524955156/log.html`), .../1489654728131608680 (2026-04-03), .../1300450498653978698
  (fortress not destroyed after win); `discord_search.jsonl` msg 1356535692657950921 (Reforged dev: known random crash entering locations with C&A or Crock Pot)
- Setup: Reforged; undead necropolis / artifact camps. A reload usually avoids it.
- Symptoms: `the index 'setFlipped' does not exist` at `fill -> scripts/mapgen/templates/tactical/locations/tactical_arena_floor.nut : 101`
  `<- initMap -> scripts/states/tactical_state.nut`; or an endless loading screen.
- Suspected code: not located. C&A locations without a `CombatLocation.Template[0]`:
  `camps_and_artifacts/scripts/entity/world/locations/undead_damned_city_location.nut`, `goblin_warrens_location.nut`,
  `bandit_usurper_location.nut`, `barbarian_sacred_grove_location.nut` (vanilla treats null as "no template", so this is a hint, not proof).
- Repro: spawn each C&A location type, start combat on it N times with different seeds (`World.State.enterLocation`/
  `startScriptedCombat` with `LocationTemplate = loc.getCombatLocation()`), assert that the map template is not `tactical.arena_floor` and `initMap` throws nothing.

### 4. Barbarian Thrall using Barbarian Fury crashes the game — open, unclear (no full log; only the tail was posted)
- Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/678?tab=bugs&issue_id=1033231 (2026-01-19)
- Setup: Legends + C&A 3.5.1/3.5.2 only; the save is unplayable without C&A.
- Symptoms: `Barbarian Chosen uses skill Barbarian Fury` → `Core A critical exception occured` with the script stack
  `think -> scripts/ai/tactical/agent.nut : 174 <- onProcessAI -> scripts/states/tactical_state.nut : 1456`.
- Suspected code: not located (native crash; Barbarian Fury swaps positions — maybe an oversized C&A camp party / artifact item on a barbarian under Legends).
- Repro: Legends; battle vs a C&A barbarian camp (`barbarian_sacred_grove_location`) with a thrall having `barbarian_fury_skill`; run the AI for several rounds and assert no crash. Low priority unless the engine runs Legends.

### 5. Camp tooltips disappear when the revealed camp is out of view range — open (author: "Known issue")
- Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/678?tab=bugs&issue_id=860914 (3.4)
- Suspected code: not located (vanilla behaviour for friendly/allied locations).
- Repro: reveal a noble camp (`setDiscovered(true)`), move the party far away, call `getTooltip()` on the location → assert it lists troops as for other discovered lairs.

### 6. Artifact shields keep vanilla durability under Reforged — open (author acknowledged "will need to be updated")
- Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/678?tab=posts&jump_to_comment=144655593 (2024-10-01)
- Suspected code: `camps_and_artifacts/scripts/items/shields/artifact/*.nut` (hard-coded base stats).
- Repro: Reforged on; compare `getConditionMax()` of each artifact shield with its base Reforged shield — assert it is not lower.

### 7. Plain Handgonne shows as "Famed" with C&A installed (Legends, SSU) — unclear, no reply
- Source: https://discord.com/channels/547043336465154049/1167322754991800390/1341341539431092378 (2025-02-18)
- Suspected code: not located (C&A adds `ItemType.Artifact` and hooks `items/item.getDescription`, `camps_and_artifacts/scripts/!mods_preload/mod_camps_and_artifacts.nut:61-72`).
- Repro: create `scripts/items/weapons/oriental/handgonne`, assert `!isItemType(Named)` and the description has no "Famed".

### 8. Ice arrows tooltip says "freeze", effect is Chilled — unclear (cosmetic)
- Source: https://discord.com/channels/1006908336991645757/1180373120415178854/1273624779231989894 (2024-08-15)
- Repro: tooltip of the imbued freezing ammo vs the applied effect id (`effects.chilled`).

## Fixed

### 9. Artifact armor +2 fatigue recovery stacked every battle — fixed in 3.5.0 ("fixed stacking stamina regen")
- Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/678?tab=bugs&issue_id=902060 (3.4);
  https://discord.com/channels/1006908336991645757/1180373120415178854/1296515050844192840
- Repro (regression): give an armor with the fatigue-recovery roll, run 3 battles (or `onCombatStarted`/`onCombatFinished` x3), assert `FatigueRecoveryRate` bonus stays +2.

### 10. Head-hit chance overflow (200%+ armor ignore / "200% chance to hit head") — fixed in 3.5.1 (on deserialize; see #1 for the leftover)
- Source: https://discord.com/channels/1006908336991645757/1180373120415178854/1273622454421553162

### 11. Item Spawner / Origin Maker show no items: `the index 'Flags' does not exist` — fixed in 3.4 (Item Spawner) and 3.5.2 (Origin Maker)
- Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/678?tab=bugs&issue_id=767420; posts
  https://www.nexusmods.com/battlebrothers/mods/678?tab=posts&jump_to_comment=132535238 and ...=135512145
- Error: `the index 'Flags' does not exist` at `scripts/!mods_preload/mod_camps_and_artifacts.nut : 27` — creating artifact items in the main menu, without `World`.
- Repro (regression): with no world loaded, `::new()` every script in `scripts/items/**/artifact/` → assert no error.

### 12. Noble/city-state camps spawned endlessly, blocking other camps — fixed (Nexus bug status Fixed; 3.6.0 "spread camps out more")
- Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/678?tab=bugs&issue_id=850446; https://discord.com/channels/1006908336991645757/1180373120415178854/1391729940831146044

### 13. Legends 18.1.1 stuck at world generation (stray `orc_fortress_location.cnut`, `the index 'Type' does not exist` at `camps_and_artifacts/factions/actions/build_orc_camp_action.nut : 40`) — fixed in 3.1
- Source: https://discord.com/channels/547043336465154049/1167322754991800390/1168294391744581653

### 14. 3.1 regression requiring stdlib (`the index 'std' does not exist` at `scripts/items/armor/artifact/artifact_armor.nut : 31`) — fixed in 3.2
- Source: https://discord.com/channels/547043336465154049/1167322754991800390/1173993455232483328

## Not bugs / feature requests (skipped)

No artifacts (Tweaks and Fixes "See Named Items"), item loss after 200 days (out of memory), errors from Fantasy/nggh, duplicate zip in data, Legends goblin camps not counting for the legendary location, balance threads.

## Repro status (headless scenario tests, 2026-11-12)

Suite in this dir, overview with commands in `~/projects/bbm/bbtales/OTHER_MODS_RESULTS.md`. "Reproduced"
= a test fails now naming the bug; "passes" = regression test green.

- #1 reproduced (fencing sword under Reforged, MSU emulator error verbatim);
  #6 reproduced (50–72 vs 300); #8 reproduced (cosmetic); #9 #11 pass; #2 not reproduced (Reforged
  0.8.18, Hardened forced onto it; the real setup needs Reforged ≥ 0.9); #3 not reproduced (33 fights
  on 11 C&A location types); #7 not reproduced on vanilla; #4 Legends; #5 world-map UI.

## Discord deep search (2026-11-12)

Systematic search of Legends, Reforged and BB Modding: every mod's display name, short forms, id and zip name, "hackflow",
hackflow's own messages (author id; BB Modding capped at 1000 of 1772) and mentions of him; plus a sweep of the 300 newest
log.html attachments not collected before (120 Legends, 120 Reforged, 60 BB Modding) for stack frames in hackflow mods' files.
Logs are in `service/tools/discord_deep/discord_logs/` (listed in its `INDEX.md`); scripts `service/tools/discord_deep/discord_deep*.py`.

Numbering continues the list above.

### 15. Artifact Three-Headed Flail rolls with very low / negative damage — fixed in 3.5.1 (`346bed5`, "fixed artifact 3-headed flail")
- Source: https://discord.com/channels/1006908336991645757/1006909310615441508/1327138610033721385 (Reforged #general,
  2025-01-10; Darxo: "This is a bug with your camps and artifacts mod"; reply to the screenshot msg 1327098886925324462),
  author: https://discord.com/channels/1006908336991645757/1006909310615441508/1327145742308999283 ("base values for
  artifact three headed were set low — ancient base script").
- Setup: Reforged; C&A < 3.5.0 (item still labelled "Famed Item", fixed in 3.5.0).
- Symptoms: artifact 3-headed flail with damage far below the plain weapon (negative rolled damage shown). Already
  rolled items keep the bad values after the fix (author: needs Dev Console to edit).
- Code now: `camps_and_artifacts/scripts/items/weapons/artifact/artifact_three_headed_flail.nut:27-28` (`RegularDamage = 30`, `RegularDamageMax = 75`).
- Repro (regression): create `artifact_three_headed_flail` 50 times; assert `m.RegularDamage > 0`, `m.RegularDamageMax >= m.RegularDamage`
  and min/max not below the vanilla `three_headed_flail`'s ×0.8.

### 16. Legends: artifact armor isn't layered, camp-dropped armor attachments don't fit layered armor, big camps use static vanilla spawn lists — open (acknowledged limitation; hackflow considers dropping armor for Legends)
- Sources: Legends thread https://discord.com/channels/547043336465154049/1167322754991800390/1522381465512443979
  (hackflow 2026-07-02: "maybe I should just drop weapons and ammo only for Legends. Unless someone will implement and
  test layered armors"), .../1522579506345545788 ("aside from SSU and armor being not layered it works"),
  .../1567729950360866977 (lilpod13 2026-11-05: "Artifact armors are not layered, and armor attachments dropped from
  camps don't work with layered armor. Some camps have specific outdated spawn lists … noble castles will only have
  vanilla enemies and never any legends elite enemies"). Same static-party remark for Reforged in 2024
  (https://discord.com/channels/1006908336991645757/1180373120415178854/1194987482018754590).
- Setup: Legends 19.x.
- Symptoms: artifact armors behave as single-piece vanilla armor; attachments from camp loot can't be attached; camp
  garrisons never contain faction-rework units.
- Suspected code: `camps_and_artifacts/scripts/items/armor/artifact/artifact_armor.nut` (vanilla `armor` base);
  static party definitions in `camps_and_artifacts/camps_and_artifacts/config/spawnlist_*.nut`.
- Repro: with a Legends stub/real Legends, roll 50 artifact armors and the camp loot tables; assert each armor is
  wearable with Legends' layer system (or that no armor is rolled when Legends is present, if that's the chosen fix);
  spawn a noble castle and assert its party uses the faction's current spawn list.

### 17. SSU ≥ 8.0 (Legends) incompatible, "maybe because of the Dryad faction" — unclear (no log, no details)
- Source: https://discord.com/channels/547043336465154049/1167322754991800390/1522597775790047373 (silverwolf63,
  2026-07-03, reply to hackflow's "there were some discussion in SSU thread, maybe that was fixed").
- Suspected code: C&A's per-faction hooks (`camps_and_artifacts/camps_and_artifacts/factions/faction.nut`,
  `config/faction_traits.nut`) assume a fixed faction set; a new faction type may lack the hooked methods (cf. #2
  `ca_getCamps`).
- Repro: if SSU is loadable, Legends + SSU 8 new campaign; iterate all factions, run `update()` 50 times; assert no
  error; enter one C&A location.

### Extends existing

- **#3 (arena floor on entering a location) — root cause found; fixed in C&A: the four set `Template[0]` to the camp map of their vanilla kin (goblin_camp, human_camp, barbarian_camp, ruins).**
  Darxo (2026-05-06, Reforged thread "LocationTemplate"):
  https://discord.com/channels/1006908336991645757/1501460748554207273/1501461583422034011 and
  https://discord.com/channels/1006908336991645757/1501460748554207273/1501597634421325985 — vanilla
  `location.create()` does `this.m.CombatLocation = clone this.Const.Tactical.LocationTemplate`, a shallow clone, so
  every location shares one `Template` array with the global; contracts/events (vanilla `arena_contract.nut`) write
  `Template[0] = "tactical.arena_floor"` into it, and locations that don't set `Template[0]` themselves then generate an
  arena floor → `the index 'setFlipped' does not exist` at `tactical_arena_floor.nut : 101`. Darxo's repro: new campaign →
  arena fight → save → load → attack the Black Monolith → stuck loading. Lord Midas opened a vanilla bug report and a
  Modular Vanilla fix PR (https://github.com/Battle-Modders/mod_modular_vanilla/pull/96,
  https://discord.com/channels/1006908336991645757/1501460748554207273/1502533348772282418).
  C&A side: four C&A locations never set the template — `camps_and_artifacts/scripts/entity/world/locations/barbarian_sacred_grove_location.nut`,
  `bandit_usurper_location.nut`, `goblin_warrens_location.nut`, `undead_damned_city_location.nut` (each `create()` only
  calls `this.location.create()` at line 10) — and all the others write `this.m.CombatLocation.Template[0] = ...` into the
  shared array (e.g. `noble_tower_location.nut:14`), tainting it for vanilla unique locations. Fix: assign a fresh array,
  `this.m.CombatLocation.Template = ["tactical.human_camp", null]` (and `[null, null]` or an explicit template in the four).
  More logs with the same stack: `discord_logs/reforged_1359204856799301632_log.html`
  (https://discord.com/channels/1006908336991645757/1359204856799301632/1359204856799301632, 2025-04-08, contract to destroy
  "New Turmfeste"; Darxo: "common but harmless crash when using mods that add new locations, reload"),
  `discord_logs/reforged_1201375913405849712_log.html`
  (https://discord.com/channels/1006908336991645757/1201375913405849712/1201375913405849712, 2024-01-29, C&A 3.3, camp during
  the Undead crisis). Repro: headless campaign; run `arena_contract`'s template setup (or set
  `::Const.Tactical.LocationTemplate.Template[0] = "tactical.arena_floor"` the way it does via a cloned table); then create
  each C&A location class and assert `loc.m.CombatLocation.Template[0] != "tactical.arena_floor"` and
  `::Const.Tactical.LocationTemplate.Template[0] == null` after creating every C&A location.
- **#2 (`ca_getCamps` spam)** — Darxo reproduced it and blames **Crock Pot**: errors start once a game is loaded
  (https://discord.com/channels/1006908336991645757/1138845062969704509/1447686082907865218, 2025-12-08; same thread as
  `discord_search.jsonl` msg 1447675423852068874). Not yet cross-checked against Crock Pot's code; repro should add a load
  step and Crock Pot if available.
- **#11 (Origin Maker)** — another Origin Maker report with the stack through `scripts/!mods_preload/mod_camps_and_artifacts.nut : 32`
  → `mod_origin_maker_helper_process...`: https://discord.com/channels/965324395851694140/1390298133002584065/1390790898161422528
  (BB Modding, 2025-07-04, C&A 3.5.1), predates the 3.5.2 fix (2025-10-23).

### Skipped

- Reproducible save corruption with Flesh and Faith+ / Stronghold / C&A + Lushken patch (Darxo could reproduce,
  culprit never identified, https://discord.com/channels/1006908336991645757/1283857645492502549/1298968825169186836, 2024-10-24);
  item with `ItemSlot.None` crash where Darxo guessed C&A, user had no artifacts
  (https://discord.com/channels/1006908336991645757/1284036971341025345/1284159549787344990); Legends abduction location
  "C&A tries to add gear" (vanilla placement bug per Legends dev,
  https://discord.com/channels/547043336465154049/1219677793990737960/1219835309081104535); Stronghold attack loop (fixed by
  reinstalling SSU); Legends/SSU "famed items break saves" (no log); difficulty/balance complaints; Lushken edited versions.
- C&A city-state camps in an odd place with World Parameters (Reforged 2024-11-01, …/1180373120415178854/1301832429991886890):
  no log, "looks like a bug", likely World Parameters.
- C&A items missing from Item Spawner (Legends 2026-07-03): broken NgGH install in the log
  (`discord_logs/legends_1522671554058653696_log.html`), no C&A errors.

## Repro status (Discord section)

Headless tests, 2026-11-12, in this dir's `tale_discord_bugs*.nut`; details in `FOUND_BUGS.md`.
Open/unclear entries of the Discord section only.

1. #3 (extended) — **reproduced**, cause verified with a correction:
   `discord_bugs::CA-KB3` ×2 fail. Vanilla `arena_contract`'s shallow clone writes `tactical.arena_floor` into the
   global `LocationTemplate.Template`; every later location copies it, and C&A's `bandit_usurper`,
   `barbarian_sacred_grove`, `goblin_warrens`, `undead_damned_city` (and vanilla's monolith, abandoned fortress,
   battlefield) keep it — also across a save/load; their fights get arena maps. C&A's other locations do *not*
   taint the global (vanilla 1.5.2 `location.create()` clones `Template` too; a control test passes). The
   `setFlipped` crash itself didn't occur headless.
2. #2 (extended, Crock Pot) — not reproduced with Crock Pot 0.8.0 + Reforged 0.8.18
   (`discord_bugs_crock_pot`), but the mechanism is confirmed: C&A's city-state action on Crock Pot's
   `OrientalCityState` village faction throws the users' error; Crock Pot 0.8.0 overrides `addTrait` to skip
   those actions (file dated 2025-12-12, after Darxo's repro), so older Crock Pot versions hit it.
3. Not feasible headless (Legends/SSU/Hardened/PTR not available): #16, #17.
4. Fixed entry #15 got no regression test.
5. Real Hardened 1.26.3 / Reforged 0.9.3 / Crock Pot 0.10.6 / Legends 19.4.23 / Clever Recruiter 2.1.8 (2026-11-12):
   #2 not reproduced (Hardened, + Crock Pot; `hardened_bugs_ca`, `hardened_cp_bugs_ca`); #16 reproduced (artifact
   armors aren't `legend_armor`; vanilla attachments from camp loot throw `the index '-1' does not exist` in Legends'
   `legend_armor.setUpgrade`; `legends_bugs_ca`); #7, #4 not reproduced on Legends; #17 not feasible (SSU doesn't
   boot on Legends 19.4), its Legends part passes.
