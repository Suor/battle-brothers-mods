# Useful Things — known bugs

Collected 2026-11-11 from: a fresh full crawl of the Nexus Bugs and Posts tabs of
https://www.nexusmods.com/battlebrothers/mods/682 (`bugs.jsonl`/`posts.jsonl` in the session scratchpad, cross-checked
with `service/data/nexus_hackflow.jsonl`), per-mod Discord threads (`service/data/discord_reforged_mods.jsonl`,
`discord_legends_bbmodding_mods.jsonl`), Discord searches (`discord_search.jsonl`, `discord_help_hidden.jsonl`,
`norm/*.jsonl`), the user logs in `service/data/logs/**` (grepped for stack frames inside the mod's dirs), and the fix
history (CHANGELOG, tags with their dates, `FIX.md`, `TO_RELEASE.md`). Pure feature requests, install errors (missing
stdlib/Modern Hooks, mod unzipped) and "another mod is the culprit" threads are skipped or get one line.

Links: Nexus posts `https://www.nexusmods.com/battlebrothers/mods/682?tab=posts&jump_to_comment=<id>`, Nexus bugs
`...?tab=bugs&issue_id=<id>`; Discord `https://discord.com/channels/<guild>/<thread>/<msg>`, guilds: Legends
547043336465154049, Reforged 1006908336991645757, BB Modding 965324395851694140. Entries from `discord_search.jsonl`
or `discord_help_hidden.jsonl` have no channel id in the data, so they are cited by file + message id.
"Fixed in X" is inferred from CHANGELOG entries plus tag dates against report dates; where the match is not
explicit it says so. Code paths are relative to `mods/`.

## Fixed

### 1. Two-handed flails lose Flail Mastery's −25% fatigue — fixed in 0.7
- Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/682?tab=bugs&issue_id=827912 (0.3); posts
  https://www.nexusmods.com/battlebrothers/mods/682?tab=posts&jump_to_comment=139999798, ...=149137853
- Suspected code: `useful/` flail hooks (`hookFlailSkill` on `skills/actives/pound`, `thresh`).
- Repro (regression): bro with `perk.mastery.flail` and an orc 2H flail → assert `pound` costs 15 and `thresh` 30 fatigue (vanilla 20/40 × 0.75); also with Modular Vanilla if present.

## Not bugs / feature requests (skipped)

Net design questions.

## Repro status (headless scenario tests, 2026-11-12)

Suite in this dir, overview with commands in `~/projects/bbm/bbtales/OTHER_MODS_RESULTS.md`. "Reproduced"
= a test fails now naming the bug; "passes" = regression test green.

- #1 passes.

## Discord deep search (2026-11-12)

Systematic search of Legends, Reforged and BB Modding: every mod's display name, short forms, id and zip name, "hackflow",
hackflow's own messages (author id; BB Modding capped at 1000 of 1772) and mentions of him; plus a sweep of the 300 newest
log.html attachments not collected before (120 Legends, 120 Reforged, 60 BB Modding) for stack frames in hackflow mods' files.
Logs are in `service/tools/discord_deep/discord_logs/` (listed in its `INDEX.md`); scripts `service/tools/discord_deep/discord_deep*.py`.

Numbering continues the list above.

### 2. Legends: Useful Things hooks fail at load — `the index 'onUpdate' does not exist` in `hand_to_hand` — open (Legends unsupported, but the mod does not say so: no `conflictWith("mod_legends")`; the reporter "believed the author")
- Source: https://discord.com/channels/547043336465154049/616566479306883073/1304459830353854505 (jiiji, 2024-11-08,
  Legends #mod-support; Chopeks pointed at Useful Things 0.5 …/1304460806905135125, z1rkel4o: "useful stuff is
  incompatible"); log `discord_logs/legends_1304459830353854505_log.html`
- Setup: Legends 18.x, Useful Things 0.5, Modern Hooks, plus Refillable Nets via Useful Things (`tnf_refillableNet`, now a declared conflict).
- Symptoms (load time, the hooks are dropped, the game then fails elsewhere):
  ```
  Script Error: the index 'onUpdate' does not exist
    at -> useful/hand_to_hand.nut : 41
    at -> modern_hooks/private_globals.nut : 368   (_src = scripts/skills/actives/hand_to_hand)
  SQ: Mod mod_hooks (modding script hooks) version 21.1 had an error (the index 'onUpdate' does not exist) during its hook on bb class scripts/skills/actives/hand_to_hand.
  Script Error: the index 'onAnySkillUsed' does not exist
    at -> useful/hand_to_hand.nut : 91
    at -> modern_hooks/private_globals.nut : 368   (_src = scripts/skills/backgrounds/brawler_background)
  ```
- Suspected code: `useful/useful/hand_to_hand.nut:41` and `:56` (`q.onUpdate`/`q.onAnySkillUsed = @(__original)` on
  `actives/hand_to_hand`) and `:90` (`q.onAnySkillUsed` on `backgrounds/brawler_background`): wrapping requires the
  function to exist in the class chain; Legends' versions don't define them. Unchanged in HEAD (0.7 + Modern Hooks
  move `3bec74a`). Fix: `mod.conflictWith("mod_legends")`, or guard with `"onUpdate" in q` / define instead of wrap.
- Repro: load Useful Things against a stub `scripts/skills/actives/hand_to_hand` and `brawler_background` without
  `onUpdate`/`onAnySkillUsed` (as Legends ships them) → assert no script error at hook time; with real vanilla
  classes assert the level-scaled damage still applies (level 11 player: `DamageRegularMin == 25`).

### Skipped

- Legends 2024-02-18 "mod_useful tripping asset manager" (jcsato guess) — the reporter found More Ambitions was the cause.

## Repro status (Discord section)

Headless tests, 2026-11-12, in this dir's `tale_discord_bugs*.nut`; details in `FOUND_BUGS.md`.
Open/unclear entries of the Discord section only.

1. Not feasible headless (Legends/SSU/Hardened/PTR not available): #2.
2. Legends 19.4.23 / Hardened 1.26.3 / Reforged 0.9.3 (2026-11-12):
   #2 not reproduced (Legends 19.4 hooks vanilla `hand_to_hand`).
