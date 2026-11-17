# Immortal Warriors — known bugs

Collected 2026-11-11 from: a fresh full crawl of the Nexus Bugs and Posts tabs of
https://www.nexusmods.com/battlebrothers/mods/763 (`bugs.jsonl`/`posts.jsonl` in the session scratchpad, cross-checked
with `service/data/nexus_hackflow.jsonl`), per-mod Discord threads (`service/data/discord_reforged_mods.jsonl`,
`discord_legends_bbmodding_mods.jsonl`), Discord searches (`discord_search.jsonl`, `discord_help_hidden.jsonl`,
`norm/*.jsonl`), the user logs in `service/data/logs/**` (grepped for stack frames inside the mod's dirs), and the fix
history (CHANGELOG, tags with their dates, `FIX.md`, `TO_RELEASE.md`). Pure feature requests, install errors (missing
stdlib/Modern Hooks, mod unzipped) and "another mod is the culprit" threads are skipped or get one line.

Links: Nexus posts `https://www.nexusmods.com/battlebrothers/mods/763?tab=posts&jump_to_comment=<id>`, Nexus bugs
`...?tab=bugs&issue_id=<id>`; Discord `https://discord.com/channels/<guild>/<thread>/<msg>`, guilds: Legends
547043336465154049, Reforged 1006908336991645757, BB Modding 965324395851694140. Entries from `discord_search.jsonl`
or `discord_help_hidden.jsonl` have no channel id in the data, so they are cited by file + message id.
"Fixed in X" is inferred from CHANGELOG entries plus tag dates against report dates; where the match is not
explicit it says so. Code paths are relative to `mods/`.

## Open / unclear

### 1. Lone Wolf origin starts without the soul jars — open, unclear (Legends, no log)
- Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/763?tab=posts&jump_to_comment=155637604 (2025-06-17)
- Suspected code: `immortal_warriors/scripts/!mods_preload/mod_immortal_warriors.nut:61-73` (`mods_hookBaseClass` on
  `starting_scenario.onSpawnAssets`; a scenario overriding `onSpawnAssets` without the base call may not be wrapped).
- Repro: start each origin (vanilla Lone Wolf first, Legends if available) → assert the stash holds `number` (setting) items of `immortal_soul_jar`.

## Fixed

### 2. Can't start: `Unable to open file "ui/mods/i_immortal_warriors_levelup_changes.js"` — fixed in 0.2.1
- Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/763?tab=posts&jump_to_comment=169450097

### 3. Wrong include path in the second queue — fixed in 0.1.1
- Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/763?tab=bugs&issue_id=858760

## Repro status (headless scenario tests, 2026-11-12)

Suite in this dir, overview with commands in `~/projects/bbm/bbtales/OTHER_MODS_RESULTS.md`. "Reproduced"
= a test fails now naming the bug; "passes" = regression test green.

- #1 not reproduced on 13 vanilla origins incl. Lone Wolf (report is Legends).
  New: IW1 (deeds counted again each rebirth), IW2.

## Discord deep search (2026-11-12)

Systematic search of Legends, Reforged and BB Modding: every mod's display name, short forms, id and zip name, "hackflow",
hackflow's own messages (author id; BB Modding capped at 1000 of 1772) and mentions of him; plus a sweep of the 300 newest
log.html attachments not collected before (120 Legends, 120 Reforged, 60 BB Modding) for stack frames in hackflow mods' files.
Logs are in `service/tools/discord_deep/discord_logs/` (listed in its `INDEX.md`); scripts `service/tools/discord_deep/discord_deep*.py`.

Nothing new.

## Repro status (Discord section)

Headless tests, 2026-11-12, in this dir's `tale_discord_bugs*.nut`; details in `FOUND_BUGS.md`.
Open/unclear entries of the Discord section only.

1. Legends 19.4.23 / Hardened 1.26.3 / Reforged 0.9.3 (2026-11-12):
   #1 reproduced on Legends (`legends_iw_lone_wolf`, `legends_iw_early_access`: 0 jars; Legends' exact-class
   `onSpawnAssets` shadows the base-class hook; Legends' own origins get them).
