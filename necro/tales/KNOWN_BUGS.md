# Proper Necromancer — known bugs

Collected 2026-11-11 from: a fresh full crawl of the Nexus Bugs and Posts tabs of
https://www.nexusmods.com/battlebrothers/mods/775 (`bugs.jsonl`/`posts.jsonl` in the session scratchpad, cross-checked
with `service/data/nexus_hackflow.jsonl`), per-mod Discord threads (`service/data/discord_reforged_mods.jsonl`,
`discord_legends_bbmodding_mods.jsonl`), Discord searches (`discord_search.jsonl`, `discord_help_hidden.jsonl`,
`norm/*.jsonl`), the user logs in `service/data/logs/**` (grepped for stack frames inside the mod's dirs), and the fix
history (CHANGELOG, tags with their dates, `FIX.md`, `TO_RELEASE.md`). Pure feature requests, install errors (missing
stdlib/Modern Hooks, mod unzipped) and "another mod is the culprit" threads are skipped or get one line.

Links: Nexus posts `https://www.nexusmods.com/battlebrothers/mods/775?tab=posts&jump_to_comment=<id>`, Nexus bugs
`...?tab=bugs&issue_id=<id>`; Discord `https://discord.com/channels/<guild>/<thread>/<msg>`, guilds: Legends
547043336465154049, Reforged 1006908336991645757, BB Modding 965324395851694140. Entries from `discord_search.jsonl`
or `discord_help_hidden.jsonl` have no channel id in the data, so they are cited by file + message id.
"Fixed in X" is inferred from CHANGELOG entries plus tag dates against report dates; where the match is not
explicit it says so. Code paths are relative to `mods/`.

## Open / unclear

### 1. Possess can target enemy undead (buffs an enemy the player can't control) — open (acknowledged, no fix)
- Source: https://discord.com/channels/1006908336991645757/1326065228542120016/1388799386359959572 (2025-06-29); also Nexus post
  https://www.nexusmods.com/battlebrothers/mods/775?tab=posts&jump_to_comment=144578448
- Suspected code: `necro/scripts/!mods_preload/mod_necro.nut:227-235` hooks `possess_undead_skill` but keeps vanilla
  `onVerifyTarget`, which only checks the `zombie_minion` flag, not the faction.
- Repro: necro bro with `perk.necro.possess`, an enemy zombie (`zombie_minion` flag) adjacent → assert
  `possess_undead_skill.onVerifyTarget(myTile, enemyTile) == false`; a zombie raised by the player → true.

### 2. Mind Meld doesn't copy stackable perks (Fast Adaptation, Unstoppable, …) — open (acknowledged)
- Source: same message as #1
- Suspected code: `necro/scripts/skills/perks/perk_necro_mind_meld.nut`.
- Repro: necro with Fast Adaptation + Mind Meld, raise a zombie → assert the zombie has `perk.fast_adaption`.

### 3. Can't raise a corpse inside an enemy zone of control (Reforged) — unclear (maybe by design)
- Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/775?tab=posts&jump_to_comment=144578448

## Fixed

### 4. Crash on the inventory screen after hiring 22 bros in the Necro origin — fixed in 0.4.2
- Source: https://discord.com/channels/1006908336991645757/1326065228542120016/1376542735691026492
- Repro (regression): Necro origin, add bros up to 22, open the formation/inventory (`World.Assets.updateFormation`) → assert no error and 16 in battle are allowed.

### 5. Possess stuck after a battle ended while possessing — fixed in 0.2.1
- Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/775?tab=bugs&issue_id=864946
- Repro (regression): possess a zombie, end the battle, start a new one → assert `possess_undead_skill.isUsable()`.

### 6. Loot lost on double raise / arena gave raised loot — fixed in 0.5.1 (CHANGELOG only, report not found)

## Not bugs / feature requests (skipped)

"battle doesn't end with a zombie after Run Them Down" (Nexus bug 1071967, mod_deathlog), Better Fencing and Deathgun conflicts (no log), Legends unsupported, Hardened "breaks perks" (no log).

## Repro status (headless scenario tests, 2026-11-12)

Suite in this dir, overview with commands in `~/projects/bbm/bbtales/OTHER_MODS_RESULTS.md`. "Reproduced"
= a test fails now naming the bug; "passes" = regression test green.

- #1 confirmed; #2 reproduced, cause: vanilla `getAllSkillsOfType` skips hidden skills; #4 #5
  pass; #3 not tested (maybe by design). New: NE1 (icon shared with `pg.necro`, MSU error), NE2.

## Discord deep search (2026-11-12)

Systematic search of Legends, Reforged and BB Modding: every mod's display name, short forms, id and zip name, "hackflow",
hackflow's own messages (author id; BB Modding capped at 1000 of 1772) and mentions of him; plus a sweep of the 300 newest
log.html attachments not collected before (120 Legends, 120 Reforged, 60 BB Modding) for stack frames in hackflow mods' files.
Logs are in `service/tools/discord_deep/discord_logs/` (listed in its `INDEX.md`); scripts `service/tools/discord_deep/discord_deep*.py`.

Numbering continues the list above.

### 7. Reforged 0.7.x: `the index 'PerkTreeMultipliers' does not exist` creating/loading the Necromancer background — fixed in 0.4.1 (`37960c6` "Reforged 0.7 compat"; test build `mod_necro_0.4.0_FIX1.zip`)
- Sources: https://discord.com/channels/1006908336991645757/1283857645492502549/1353632468250656778 (Reforged
  #technical-help, 2025-03-24, Darxo: "necro_background compatibility broke");
  https://discord.com/channels/1006908336991645757/1373918299187970078/1373923384353886229 (2025-05-19, Darxo: "issue
  seems to be mod_necro… Reforged 0.7.7 breaking changes"); author's FIX1 build
  https://discord.com/channels/1006908336991645757/1373230066695405598/1374295200142331966 (2025-05-20).
- Setup: Reforged 0.7.x, Proper Necro 0.4.0 (`mod_necro_0.4.0.zip`).
- Logs: `discord_logs/reforged_1353621793214173266_log.html` (on new campaign), `discord_logs/reforged_1373922723973042246_log.html` (on load):
  ```
  Script Error: the index 'PerkTreeMultipliers' does not exist
    at create -> scripts/skills/backgrounds/necro_background.nut : 54
    at -> msu/hooks/skills/skill.nut : 15
    at -> mod_reforged/hooks/skills/skill.nut : 103
    at onDeserialize -> scripts/skills/skill_container.nut : 990
    at onDeserialize -> scripts/entity/tactical/player.nut : 1986
  ```
  (0.4.0 assigned `this.m.PerkTreeMultipliers = {...}`, a slot Reforged 0.7 removed from backgrounds.) The
  `mage_background.nut : 54` "the index 'Body'" error in the first log is not Proper Necro's (no such file in the mod).
- Code now: `necro/scripts/skills/backgrounds/necro_background.nut:41-70` (`createPerkTreeBlueprint`, module-level `PerkTreeMultipliers`).
- Repro (regression): Reforged 0.7+ loaded; `::new("scripts/skills/backgrounds/necro_background")`, add to a player,
  serialize + deserialize the player; assert no error and the bro has the necro perk group.

### 8. Necro 0.3.0 on Reforged: every bro's perk screen shows the vanilla perk tree — fixed in 0.4.0 ("support Reforged")
- Source: Reforged technical-help https://discord.com/channels/1006908336991645757/1283857645492502549/1295830951422591077
  (csgonoobmiki, 2024-10-15, "new version of necro brokes perktrees"; hackflow: "didn't test it with Reforged yet …
  try deleting this 3-lines else clause", …/1295860566925119599). Log
  `discord_logs/reforged_1295761236696371252_log.html` (necro 0.3.0); its only error is from Dynamic Perks tooltips:
  `the index 'perk.head_hunter' does not exist` at `getPerkTier -> scripts/mods/mod_dynamic_perks/classes/perk_tree.nut : 214`.
- Cause: 0.3.0's `data_helper.convertEntityToUIData` hook set `result.necro_perkTree <- ::Const.Perks.Perks` for
  every non-necro bro (`else` branch, `necro/scripts/!mods_preload/mod_necro.nut:157` at `d57bab1`), and
  `ui/mods/necro.js` loads it instead of the Dynamic Perks tree.
- Code now: the hook is installed only without Dynamic Perks and sets the tree only for `background.necro`
  (`necro/scripts/!mods_preload/mod_necro.nut:195-218`); JS restores the stock tree only after its own tree
  (`necro/ui/mods/necro.js:7-15`).
- Repro: Reforged (Dynamic Perks) loaded; build UI data for a non-necro bro; assert no `necro_perkTree` key and that
  the perk tree is the bro's DPF tree.

### Skipped

- Orcs can't be raised (outdated Reforged, user confirmed fixed after update,
  https://discord.com/channels/1006908336991645757/1549689108140658798/1552419266429587568); Black Pyramid 0.4 replacing
  `weapon.isDroppedAsLoot` (hackflow reported it to BP — other mod's bug,
  https://discord.com/channels/1006908336991645757/1494077202218619020/1535924844514906152); dagger/AC Tome of Death raised loot
  loss (author note, not Proper Necro).
- Necro: possess on enemies / Mind Meld stackables (2025-07-01) — necro #1/#2; Hardened "breaks perks" — skipped before.

## Repro status (Discord section)

Headless tests, 2026-11-12, in this dir's `tale_discord_bugs*.nut`; details in `FOUND_BUGS.md`.
Open/unclear entries of the Discord section only.

1. Fixed entries #7, #8 got no regression tests.
2. Legends 19.4.23 / Hardened 1.26.3 / Reforged 0.9.3 (2026-11-12):
   "Hardened breaks perks" not reproduced (`hardened_necro`).
