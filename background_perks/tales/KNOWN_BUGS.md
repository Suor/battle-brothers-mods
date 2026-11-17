# Starting Perks by Background — known bugs

Collected 2026-11-11 from: a fresh full crawl of the Nexus Bugs and Posts tabs of
https://www.nexusmods.com/battlebrothers/mods/661 (`bugs.jsonl`/`posts.jsonl` in the session scratchpad, cross-checked
with `service/data/nexus_hackflow.jsonl`), per-mod Discord threads (`service/data/discord_reforged_mods.jsonl`,
`discord_legends_bbmodding_mods.jsonl`), Discord searches (`discord_search.jsonl`, `discord_help_hidden.jsonl`,
`norm/*.jsonl`), the user logs in `service/data/logs/**` (grepped for stack frames inside the mod's dirs), and the fix
history (CHANGELOG, tags with their dates, `FIX.md`, `TO_RELEASE.md`). Pure feature requests, install errors (missing
stdlib/Modern Hooks, mod unzipped) and "another mod is the culprit" threads are skipped or get one line.

Links: Nexus posts `https://www.nexusmods.com/battlebrothers/mods/661?tab=posts&jump_to_comment=<id>`, Nexus bugs
`...?tab=bugs&issue_id=<id>`; Discord `https://discord.com/channels/<guild>/<thread>/<msg>`, guilds: Legends
547043336465154049, Reforged 1006908336991645757, BB Modding 965324395851694140. Entries from `discord_search.jsonl`
or `discord_help_hidden.jsonl` have no channel id in the data, so they are cited by file + message id.
"Fixed in X" is inferred from CHANGELOG entries plus tag dates against report dates; where the match is not
explicit it says so. Code paths are relative to `mods/`.

## Open / unclear

### 1. Stuck on the loading screen starting a new game (1.5.1, May 2025) — unclear (log requested, none came; 2.6.1 shipped 2025-05-31)
- Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/661?tab=posts&jump_to_comment=153580650
- Repro: start each vanilla origin with the mod → assert `startNewCampaign` completes and starting bros got their perks.

### 3. Legends: endless map generation for some origins (beggar, berserker) — open, won't fix (Legends unsupported)
- Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/661?tab=posts&jump_to_comment=126520095

## Fixed

### 2. `setStartValuesEx()` called with extra args breaks events under Legends (Kingsguard cripple event shows code, headless bro, soft lock) — fixed in 2.4
- Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/665?tab=bugs&issue_id=760647 (filed against Elite Few; isolated to this mod)
- Repro (regression): fire `event.kings_guard_joins` (vanilla id) → assert no error and the new bro has a head sprite.

## Not bugs / feature requests (skipped)

Perk-point oddities from other mods, chance tweak questions; `mod_background_perks.nut : 112` in `logs/Reforged/1547359680429301840/` is a Reforged error passing through.

## Repro status (headless scenario tests, 2026-11-12)

Suite in this dir, overview with commands in `~/projects/bbm/bbtales/OTHER_MODS_RESULTS.md`. "Reproduced"
= a test fails now naming the bug; "passes" = regression test green.

- #1 not reproduced (14 vanilla origins start, perks given); #2 passes; #3 Legends.

## Discord deep search (2026-11-12)

Systematic search of Legends, Reforged and BB Modding: every mod's display name, short forms, id and zip name, "hackflow",
hackflow's own messages (author id; BB Modding capped at 1000 of 1772) and mentions of him; plus a sweep of the 300 newest
log.html attachments not collected before (120 Legends, 120 Reforged, 60 BB Modding) for stack frames in hackflow mods' files.
Logs are in `service/tools/discord_deep/discord_logs/` (listed in its `INDEX.md`); scripts `service/tools/discord_deep/discord_deep*.py`.

Numbering continues the list above.

### 4. Legends "Supposed Witch" event: first option doesn't advance, a bro is added per click, roster won't open, save then fails to load — unclear (Legends staff blamed this mod; no script error in the logs), open in code
- Source: https://discord.com/channels/547043336465154049/1320769393445048381/1320769393445048381 (dachnik228,
  2024-12-23, Legends 19.0.x); Chopeks (Legends dev) https://discord.com/channels/547043336465154049/1320769393445048381/1321079052081168406:
  "there is compat issue with `Starting Perks by Background` mod, that's the cause of this error … remove that mod";
  second reporter fate_grinder https://discord.com/channels/547043336465154049/1320769393445048381/1320946967588634757
  (Starting Perks 2.5); logs `discord_logs/legends_1320946967588634757_log.html`, `discord_logs/legends_1320772697306697829_log.html`
  (the latter without this mod, only the broken save).
- Setup: Legends 19.0.x, Starting Perks by Background 2.5, Clever Recruiter.
- Symptoms: both logs only show the after-effect on loading the save made after the event:
  ```
  [critical] A critical error occured: Class/Structure with key "84153939930382336" is not registered. ...
  Script Stacktrace:
    at loadCampaign -> scripts/states/world_state.nut : 1224
    at -> msu/hooks/states/world_state.nut : 193
    at -> mod_legends/hooks/states/world_state.nut : 97
  ```
- Suspected code: `background_perks/scripts/!mods_preload/mod_background_perks.nut:133` — the wrapper
  `setStartValuesEx(_backgrounds, _addTraits = true)` takes 2 params while Legends' is
  `(_backgrounds, _addTraits = true, _gender = -1, _addEquipment = true)` (`mod_legends/hooks/entity/tactical/player.nut:1224`).
  Legends' `supposed_witch_event.nut:40,46` calls `setStartValuesEx(this.Const.SupposedWitchBackgrounds, true, 1)`;
  the gender `1` is silently dropped, so the event bro is built with a random gender for a female-only background.
  Same class of bug as Nicknames #6 (fixed there with a 4-param Legends wrapper). The 2.4 fix (existing #2) only
  covered extra args in events in a different way; the 2.5 wrapper still drops them.
- Repro: Legends-stub `player` with the 4-param `setStartValuesEx` that records its args; load the mod; call
  `bro.setStartValuesEx(["legend_witch_background"], true, 1, false)` → assert the stub got `_gender == 1` and
  `_addEquipment == false`, and free perks were still given. Also assert no Modern Hooks "fewer total parameters"
  warning naming `mod_background_perks`.

## Repro status (Discord section)

Headless tests, 2026-11-12, in this dir's `tale_discord_bugs*.nut`; details in `FOUND_BUGS.md`.
Open/unclear entries of the Discord section only.

1. Not feasible headless (Legends/SSU/Hardened/PTR not available): #4.
2. Legends 19.4.23 / Hardened 1.26.3 / Reforged 0.9.3 (2026-11-12):
   #4 reproduced (`legends_bugs_bg_perks::BP-KB4` ×2: the 2-parameter wrapper makes Legends' own `setStartValuesEx(…,
   true, 1)` throw `wrong number of parameters`), #3 not reproduced (Beggar, Berserker start). New: BP-L1.
