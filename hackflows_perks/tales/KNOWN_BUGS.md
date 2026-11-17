# Hackflow's Perks — known bugs

Collected 2026-11-11 from: a fresh full crawl of the Nexus Bugs and Posts tabs of
https://www.nexusmods.com/battlebrothers/mods/673 (`bugs.jsonl`/`posts.jsonl` in the session scratchpad, cross-checked
with `service/data/nexus_hackflow.jsonl`), per-mod Discord threads (`service/data/discord_reforged_mods.jsonl`,
`discord_legends_bbmodding_mods.jsonl`), Discord searches (`discord_search.jsonl`, `discord_help_hidden.jsonl`,
`norm/*.jsonl`), the user logs in `service/data/logs/**` (grepped for stack frames inside the mod's dirs), and the fix
history (CHANGELOG, tags with their dates, `FIX.md`, `TO_RELEASE.md`). Pure feature requests, install errors (missing
stdlib/Modern Hooks, mod unzipped) and "another mod is the culprit" threads are skipped or get one line.

Links: Nexus posts `https://www.nexusmods.com/battlebrothers/mods/673?tab=posts&jump_to_comment=<id>`, Nexus bugs
`...?tab=bugs&issue_id=<id>`; Discord `https://discord.com/channels/<guild>/<thread>/<msg>`, guilds: Legends
547043336465154049, Reforged 1006908336991645757, BB Modding 965324395851694140. Entries from `discord_search.jsonl`
or `discord_help_hidden.jsonl` have no channel id in the data, so they are cited by file + message id.
"Fixed in X" is inferred from CHANGELOG entries plus tag dates against report dates; where the match is not
explicit it says so. Code paths are relative to `mods/`.

## Open / unclear

### 1. Stabilized can't be picked: the perk point isn't spent — open, unclear (author suspects a mod interaction)
- Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/673?tab=posts&jump_to_comment=174848835 (2026-09-02, version unknown)
- Suspected code: `hackflows_perks/scripts/skills/perks/perk_hackflows_stabilized.nut` (any throw in `create`/`onAdded`/`onUpdate`
  makes `unlockPerk` fail); placed by `hackflows_perks/scripts/config/z_hackflows_perks.nut:79`.
- Repro: vanilla (no Reforged), bro with a perk point, `player.unlockPerk("perk.hackflows.stabilized")` naked, with medium
  armor, with heavy armor → assert `hasSkill`, `PerkPoints` decreased, and no script error.

### 2. Overwrites JC Sato's Balance changes to Nimble / Lone Wolf — open (Nexus "New issue"; author: these perks aren't touched)
- Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/673?tab=bugs&issue_id=1063408 (1.6.1)
- Suspected code: `hackflows_perks/scripts/config/z_hackflows_perks.nut:1-10` (`addPerk` inserts into `::Const.Perks.Perks` rows;
  if Sato patches perk defs by row/index or rebuilds `LookupMap` earlier, its changes are lost) — not confirmed.
- Repro: `hackflows_perks/tales/tale_sato.nut` (Sato's Balance Mod 2.3.1, `mods/mod_sato_balance-2.3.1.zip`; 1.4.1 in `3rdparty/` didn't patch Nimble): HP-KB2 in its FOUND_BUGS.

## Fixed

### 3. Crash under vanilla (no Reforged): `the index 'perk.rf_promised_potential' does not exist` — fixed in 1.6.3 ("fixed the mod not working under vanilla"; 1.6.2 also says "fixed occasional crash")
- Source: Nexus posts https://www.nexusmods.com/battlebrothers/mods/673?tab=posts&jump_to_comment=166860625 (2026-03-16), ...=173892969 (2026-08-15)
- Repro (regression): load without Reforged → assert no script error during queue and `perk.hackflows.*` exist in `Const.Perks.LookupMap`.

### 4. `the index 'onAdded' does not exist` after upgrading 1.5 → 1.6 — fixed in 1.6 FIXED1 / 1.6.1
- Source: https://discord.com/channels/1006908336991645757/1281787683638874203/1380614340348088351 (log `logs/Reforged/1380614340348088351/log.html`, `scripts/hackflows_perks/potential.nut : 149`)

## Repro status (headless scenario tests, 2026-11-12)

Suite in this dir, overview with commands in `~/projects/bbm/bbtales/OTHER_MODS_RESULTS.md`. "Reproduced"
= a test fails now naming the bug; "passes" = regression test green.

- #2 reproduced with Sato 1.4.1 (Lone Wolf text patched at a fixed row index the
  mod shifts; Nimble untouched by Sato); #1 not reproduced on vanilla; #3 passes. New: HP1.

## Discord deep search (2026-11-12)

Systematic search of Legends, Reforged and BB Modding: every mod's display name, short forms, id and zip name, "hackflow",
hackflow's own messages (author id; BB Modding capped at 1000 of 1772) and mentions of him; plus a sweep of the 300 newest
log.html attachments not collected before (120 Legends, 120 Reforged, 60 BB Modding) for stack frames in hackflow mods' files.
Logs are in `service/tools/discord_deep/discord_logs/` (listed in its `INDEX.md`); scripts `service/tools/discord_deep/discord_deep*.py`.

Numbering continues the list above.

### 5. Reforged ≥0.6.x: perk groups not built, bros have empty perk trees — `the index 'Trees' does not exist` — fixed in 1.5 (`7232ccd` "update to work with newer Reforged", 2025-01-06)
- Source: https://discord.com/channels/1006908336991645757/1006908337981509725/1286660788983042079 (Reforged #general,
  2024-09-20: "hackflow's perks shows as an error"; user: starting bros "don't have any perk groups", LW and Deserters).
- Setup: Reforged 0.6.7, Hackflow's Perks 1.3.
- Log `discord_logs/reforged_1286659171185332237_log.html`:
  ```
  Script Error: the index 'Trees' does not exist
    at -> scripts/!mods_preload/mod_hackflows_perks.nut : 100
    at main -> scripts/mods/mod_reforged/load.nut : 3          (perkGroupScript = pg_rf_agile)
  Script: Failed to execute script file "scripts/mods/mod_reforged/load.nut". Reason: "the index 'Trees' does not exist".
  ```
  The monkey-patched `::DynamicPerks.PerkGroups.add` read `_perkGroup.m.Trees["default"]`; DPF renamed it, the throw
  aborted Reforged's `load.nut`, so no perk groups were registered at all.
- Code now: `hackflows_perks/scripts/!mods_preload/mod_hackflows_perks.nut:149-155` reads `_perkGroup.m.Tree` — still a
  private field; a future DPF rename would break Reforged loading the same way (consider try/catch or a public getter).
- Repro (regression): Reforged loaded; assert `::DynamicPerks.PerkGroups.findById("pg.rf_agile")` exists and its tree
  row 3 contains `perk.hackflows.balance`; also call the patched `add` with a group lacking `m.Tree` and assert it does
  not throw.

### Extends existing

- Extends #3 (vanilla crash, fixed in 1.6.3): a BB Modding report with log, Hackflow's Perks 1.6.1, no Reforged/Legends —
  https://discord.com/channels/965324395851694140/1222072072516141116/1388150642480124057 (2025-06-27),
  `discord_logs/bbmodding_1388150642480124057_log.html`:
  ```
  Script Error: the index 'perk.rf_promised_potential' does not exist
    at main -> scripts/hackflows_perks/potential.nut : 27
  Script Error: the index 'Fluff' does not exist          (later, every Potential perk instance)
    at setup -> scripts/skills/perks/perk_hackflows_potential.nut : 54
    at create -> scripts/skills/perks/perk_hackflows_potential.nut : 39
  ```
  Nobody attributed it to the mod in the thread (TaroEld blamed `tnf_rejects`).

### Skipped

- "is hackflow perks incompatible with Legends" (perks are in Legends already); Augmented perks pack (other mod).

## Repro status (Discord section)

Headless tests, 2026-11-12, in this dir's `tale_discord_bugs*.nut`; details in `FOUND_BUGS.md`.
Open/unclear entries of the Discord section only.

1. Fixed entry #5 got no regression test.
2. Legends 19.4.23 / Hardened 1.26.3 / Reforged 0.9.3 (2026-11-12):
   HP1 still fails on Reforged 0.9.3.
