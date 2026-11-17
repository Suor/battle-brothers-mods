# Standout Enemies — known bugs

Collected 2026-11-11 from: a fresh full crawl of the Nexus Bugs and Posts tabs of
https://www.nexusmods.com/battlebrothers/mods/331 (`bugs.jsonl`/`posts.jsonl` in the session scratchpad, cross-checked
with `service/data/nexus_hackflow.jsonl`), per-mod Discord threads (`service/data/discord_reforged_mods.jsonl`,
`discord_legends_bbmodding_mods.jsonl`), Discord searches (`discord_search.jsonl`, `discord_help_hidden.jsonl`,
`norm/*.jsonl`), the user logs in `service/data/logs/**` (grepped for stack frames inside the mod's dirs), and the fix
history (CHANGELOG, tags with their dates, `FIX.md`, `TO_RELEASE.md`). Pure feature requests, install errors (missing
stdlib/Modern Hooks, mod unzipped) and "another mod is the culprit" threads are skipped or get one line.

Links: Nexus posts `https://www.nexusmods.com/battlebrothers/mods/331?tab=posts&jump_to_comment=<id>`, Nexus bugs
`...?tab=bugs&issue_id=<id>`; Discord `https://discord.com/channels/<guild>/<thread>/<msg>`, guilds: Legends
547043336465154049, Reforged 1006908336991645757, BB Modding 965324395851694140. Entries from `discord_search.jsonl`
or `discord_help_hidden.jsonl` have no channel id in the data, so they are cited by file + message id.
"Fixed in X" is inferred from CHANGELOG entries plus tag dates against report dates; where the match is not
explicit it says so. Code paths are relative to `mods/`.

## Open / unclear

### 1. Hair and beard stay dark after Cursed wears off — open (no reply)
- Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/331?tab=posts&jump_to_comment=152498468 (2025-04-13)
- Suspected code: `standout_enemies/scripts/skills/cursed_effect.nut:152-165` (`updateAppearance` sets hair/beard brightness
  0.1 and back to 1.0; with `IsRemovedAfterBattle` the after-battle removal may skip `onRemoved`, and the original brightness isn't saved).
- Repro: bro hit by a Cursed enemy (`cursed_skill`), end the battle → assert sprites `hair`, `beard`, `head`, `body` have their pre-curse brightness/color; also after save/load.

### 2. Not user-reported: `checkResist()` uses an undefined `actor` — open (from code)
- Suspected code: `standout_enemies/scripts/skills/cursed_effect.nut:116-125` — `actor` is never declared in `checkResist`,
  so a successful resist throws `the index 'actor' does not exist`.
- Repro: target with `IsResistantToAnyStatuses = true` (vanilla `ijirok_potion_effect`), apply `cursed_effect` 20 times → assert no script error.

## Fixed

### 3. Infinite loading entering an undead location without the DLC weapon `khopesh` — fixed in 0.81
- Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/331?tab=posts&jump_to_comment=125400768

### 4. Infinite loading entering the arena / an orc fortress — fixed in 0.33 / probably 0.51 (2020)
- Source: Nexus posts https://www.nexusmods.com/battlebrothers/mods/331?tab=posts&jump_to_comment=87101113, ...=87193273

## Not bugs / feature requests (skipped)

"no standout enemies seen" (faction/day dependent, or stdlib missing per `logs/Nexus/1098149/`), True Nine Lives from Champion Beasts, balance threads.

## Repro status (headless scenario tests, 2026-11-12)

Suite in this dir, overview with commands in `~/projects/bbm/bbtales/OTHER_MODS_RESULTS.md`. "Reproduced"
= a test fails now naming the bug; "passes" = regression test green.

- #1 reproduced (`setBrightness` 0.1 then 1.0 leaves hair dark; head/body tint
  reset to white); #2 reproduced.

## Discord deep search (2026-11-12)

Systematic search of Legends, Reforged and BB Modding: every mod's display name, short forms, id and zip name, "hackflow",
hackflow's own messages (author id; BB Modding capped at 1000 of 1772) and mentions of him; plus a sweep of the 300 newest
log.html attachments not collected before (120 Legends, 120 Reforged, 60 BB Modding) for stack frames in hackflow mods' files.
Logs are in `service/tools/discord_deep/discord_logs/` (listed in its `INDEX.md`); scripts `service/tools/discord_deep/discord_deep*.py`.

Nothing new.

### Skipped

- "not compatible with Legends" (2022) — old, Legends unsupported.
