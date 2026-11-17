# Bro Studio — known bugs

Collected 2026-11-11 from: a fresh full crawl of the Nexus Bugs and Posts tabs of
https://www.nexusmods.com/battlebrothers/mods/677 (`bugs.jsonl`/`posts.jsonl` in the session scratchpad, cross-checked
with `service/data/nexus_hackflow.jsonl`), per-mod Discord threads (`service/data/discord_reforged_mods.jsonl`,
`discord_legends_bbmodding_mods.jsonl`), Discord searches (`discord_search.jsonl`, `discord_help_hidden.jsonl`,
`norm/*.jsonl`), the user logs in `service/data/logs/**` (grepped for stack frames inside the mod's dirs), and the fix
history (CHANGELOG, tags with their dates, `FIX.md`, `TO_RELEASE.md`). Pure feature requests, install errors (missing
stdlib/Modern Hooks, mod unzipped) and "another mod is the culprit" threads are skipped or get one line.

Links: Nexus posts `https://www.nexusmods.com/battlebrothers/mods/677?tab=posts&jump_to_comment=<id>`, Nexus bugs
`...?tab=bugs&issue_id=<id>`; Discord `https://discord.com/channels/<guild>/<thread>/<msg>`, guilds: Legends
547043336465154049, Reforged 1006908336991645757, BB Modding 965324395851694140. Entries from `discord_search.jsonl`
or `discord_help_hidden.jsonl` have no channel id in the data, so they are cited by file + message id.
"Fixed in X" is inferred from CHANGELOG entries plus tag dates against report dates; where the match is not
explicit it says so. Code paths are relative to `mods/`.

## Open / unclear

### 1. "Blue vial" gives a full-stat level-up to a veteran — open, unclear (no reply; which item is meant is unknown — maybe Potion of Knowledge or a Legends/Reforged potion)
- Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/677?tab=posts&jump_to_comment=166722649 (2026-03-13)
- Suspected code: `bro_studio/bro_studio/attrs.nut:71-95` — `effectiveLevel = Level - LevelUps + 1` decides veteran vs full rolls;
  XP gained in bulk (several pending LevelUps) or a level reset may land a veteran in the `<= attrsVeteran` branch.
- Repro: bro at level 12 with default settings (attrsVeteran 11); give XP worth 2 levels at once (`addXP` / Potion of Knowledge
  effect), then call `fillAttributeLevelUpValues` per level-up → assert the rolls are veteran (all 1s, or Veteran Boost values).

### 2. Hardened: critical exception, recruit spawned with a Bro Studio permanent injury — unclear (helper's guess)
- Source: `discord_search.jsonl` msg 1520698258995810314 (Reforged "Hardened" thread, 2026-06-28)
- Suspected code: `bro_studio/bro_studio/injuries.nut` (1.3.0 "permanent injuries on new bros").
- Repro: Reforged, injuries option on, generate 200 recruits → assert no error; hire one and run a battle.

### 3. Clumsy added as a positive trait — unclear (author asked whether it was there before hire; no follow-up)
- Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/677?tab=posts&jump_to_comment=130066139 (2023-11-05)
- Repro: roll positive traits 1000 times (`bro_studio/bro_studio/traits.nut`) → assert `trait.clumsy` never appears.

## Fixed

### 4. Modern Hooks error: wrapping `setStartValuesEx` with the wrong param count (Legends) — fixed in 1.3.1
- Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/677?tab=posts&jump_to_comment=169368068 (2026-05-08); https://discord.com/channels/547043336465154049/1162309320906653776/1502344256679972874

### 5. Talents ignored for bought bros (only starting bros affected) — fixed (load-order fix shipped as `bro_studio/mod_bro_studio_1.2.0_FIX1.zip`; presumably in 1.3.0)
- Source: https://discord.com/channels/547043336465154049/1162309320906653776/1360951922735059046

### 6. Talent min/max ignored, everyone gets the max — fixed in 1.0.1
- Source: https://discord.com/channels/547043336465154049/1162309320906653776/1163402792174620732
- Repro (regression): talentsMin=3, talentsMax=5, chance 50 → 500 recruits, assert counts of 3, 4 and 5 are all non-zero.

### 7. Veteran level for perks not applied — fixed in 1.0.2
- Source: https://discord.com/channels/547043336465154049/1162309320906653776/1165263373437522031

## Not bugs / feature requests (skipped)

Missing stdlib / Modern Hooks (many), Veteran Level Limit mod overlap (became a setting), extra perks from Legends/other mods, PoV/Magic Concept/More Ammos culprits, "recruits disappear after load" (Nexus bug 946648, More Ammos), "the index '6' does not exist" at `mod_bro_studio.nut : 96` in `logs/Legends/1439171393261535233/` (thrown inside the Legends Necro Lorekeeper scenario, pass-through).

## Repro status (headless scenario tests, 2026-11-12)

Suite in this dir, overview with commands in `~/projects/bbm/bbtales/OTHER_MODS_RESULTS.md`. "Reproduced"
= a test fails now naming the bug; "passes" = regression test green.

- #1 #2 #3 not reproduced; #6 passes. New: BS1 ("Add good traits" off ignored, in stdlib).

## Discord deep search (2026-11-12)

Systematic search of Legends, Reforged and BB Modding: every mod's display name, short forms, id and zip name, "hackflow",
hackflow's own messages (author id; BB Modding capped at 1000 of 1772) and mentions of him; plus a sweep of the 300 newest
log.html attachments not collected before (120 Legends, 120 Reforged, 60 BB Modding) for stack frames in hackflow mods' files.
Logs are in `service/tools/discord_deep/discord_logs/` (listed in its `INDEX.md`); scripts `service/tools/discord_deep/discord_deep*.py`.

No new bugs. The 2024-08-29 "Bro Studio + Clever Recruiter" report is the Elite Few + CR issue (elite_few #8). Skipped:
"looks like bro studio error" with no log (https://discord.com/channels/547043336465154049/1156535917276844083/1437416095899451522,
SSU tournament thread, 2025-11-10); missing stdlib reports; "only works for bros generated at start" (by design question);
Breditor issues.

- **Extends #1 ("Blue vial" full-stat level-up to a veteran).** In Reforged's "[0.6.2] Gifted + Blue Vial + Discovered
  talent may mess up player.m.Attributes a little" thread
  (https://discord.com/channels/1006908336991645757/1275826679775760467/1275830221685260378, 2024-08-21..22) hackflow
  analysed how max-roll rows from Gifted / Blue Vial interleave with later `fillAttributeLevelUpValues`, fixed it in
  Immortal Warriors (`immortal_extraALUV`, `immortal_warriors/scripts/!mods_preload/mod_immortal_warriors.nut:103-120`)
  and said "will probably want it in Bro Studio too" (…/1276318919195627585). Bro Studio never got it:
  `bro_studio/bro_studio/attrs.nut:71-95` still clears or rebuilds the whole `m.Attributes` once its front row looks
  veteran (`isVeteranAttrs`, line 98), which can drop pending potion rows. Repro addition: give a level-12 bro a Blue
  Vial / Gifted (max-only rows), level him twice; assert the max rows survive and later rows are veteran.

## Repro status (Discord section)

Headless tests, 2026-11-12, in this dir's `tale_discord_bugs*.nut`; details in `FOUND_BUGS.md`.
Open/unclear entries of the Discord section only.

1. #1 extension (Gifted max rows on a veteran) — not reproduced (`discord_bugs::BS-KB1` ×2).
2. Real Hardened 1.26.3 / Reforged 0.9.3 / Crock Pot 0.10.6 / Legends 19.4.23 / Clever Recruiter 2.1.8 (2026-11-12):
   #2 not reproduced with Hardened; #4 regression passes on Legends.
