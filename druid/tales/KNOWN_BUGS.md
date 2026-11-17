# Proper Druid — known bugs

Collected 2026-11-11 from: a fresh full crawl of the Nexus Bugs and Posts tabs of
https://www.nexusmods.com/battlebrothers/mods/1061 (`bugs.jsonl`/`posts.jsonl` in the session scratchpad, cross-checked
with `service/data/nexus_hackflow.jsonl`), per-mod Discord threads (`service/data/discord_reforged_mods.jsonl`,
`discord_legends_bbmodding_mods.jsonl`), Discord searches (`discord_search.jsonl`, `discord_help_hidden.jsonl`,
`norm/*.jsonl`), the user logs in `service/data/logs/**` (grepped for stack frames inside the mod's dirs), and the fix
history (CHANGELOG, tags with their dates, `FIX.md`, `TO_RELEASE.md`). Pure feature requests, install errors (missing
stdlib/Modern Hooks, mod unzipped) and "another mod is the culprit" threads are skipped or get one line.

Links: Nexus posts `https://www.nexusmods.com/battlebrothers/mods/1061?tab=posts&jump_to_comment=<id>`, Nexus bugs
`...?tab=bugs&issue_id=<id>`; Discord `https://discord.com/channels/<guild>/<thread>/<msg>`, guilds: Legends
547043336465154049, Reforged 1006908336991645757, BB Modding 965324395851694140. Entries from `discord_search.jsonl`
or `discord_help_hidden.jsonl` have no channel id in the data, so they are cited by file + message id.
"Fixed in X" is inferred from CHANGELOG entries plus tag dates against report dates; where the match is not
explicit it says so. Code paths are relative to `mods/`.

## Open / unclear

### 1. Summoned beasts stand idle, facing the wrong way, "both hostile and not" — open (needs a log)
- Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/1061?tab=bugs&issue_id=1102373 (0.5.1)
- Suspected code: `druid/scripts/skills/actives/druid_summon_beast.nut:196-221` — enemy script spawned and switched to
  `Faction.PlayerAnimals`; sprite flipping relies on an `onFactionChanged` hook after `druid_Summoned`.
- Repro: druid with summon in a battle vs bandits; use the skill → assert the beast's faction is `PlayerAnimals`, sprites
  flipped like player animals, and within 2 rounds it moves or attacks an enemy (AI agent acts).

## Fixed

### 2. Crash when Starting Perks by Background is installed without More Backgrounds and Events — fixed in 0.5.2
- Source: https://discord.com/channels/1006908336991645757/1518597754505396384/1526141975596765304 (log `logs/Reforged/1526141975596765304/log.html`)

### 3. `the index 'hackflows_druid' does not exist` in queue (load order) — fixed in 0.5.1
- Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/1061?tab=bugs&issue_id=1100338

## Not bugs / feature requests (skipped)

Legends unsupported, vague perk descriptions, a question about druids with the Necromancer origin (2026-11-03).

## Repro status (headless scenario tests, 2026-11-12)

Suite in this dir, overview with commands in `~/projects/bbm/bbtales/OTHER_MODS_RESULTS.md`. "Reproduced"
= a test fails now naming the bug; "passes" = regression test green.

- #1 not reproduced (vanilla and Reforged, every beast type acts, faction PlayerAnimals, flipped).

## Discord deep search (2026-11-12)

Systematic search of Legends, Reforged and BB Modding: every mod's display name, short forms, id and zip name, "hackflow",
hackflow's own messages (author id; BB Modding capped at 1000 of 1772) and mentions of him; plus a sweep of the 300 newest
log.html attachments not collected before (120 Legends, 120 Reforged, 60 BB Modding) for stack frames in hackflow mods' files.
Logs are in `service/tools/discord_deep/discord_logs/` (listed in its `INDEX.md`); scripts `service/tools/discord_deep/discord_deep*.py`.

No new bugs: only release notes and recommendations.

- Extends #2 (fixed in 0.5.2): the log of that report is now saved as `discord_logs/reforged_1526200004580999219_log.html`
  (https://discord.com/channels/1006908336991645757/1518597754505396384/1526200004580999219, Druid 0.5.1, Reforged +
  Starting Perks by Background, no XBE): `the index 'hackflows_druid' does not exist` at
  `scripts/!mods_preload/mod_druid.nut : 38` in queue function 1 — `::std.Table.extend(::BgPerks.chances.hackflows_druid, …)`
  when only XBE defines that key; `672ed99` creates the table instead (`druid/scripts/!mods_preload/mod_druid.nut:38`).
  Test build `mod_druid_0.5.1_XBE_BgPerks_FIX1.zip`.
