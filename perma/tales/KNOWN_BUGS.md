# Hackflow's Permanent Injuries — known bugs

Collected 2026-11-11 from: a fresh full crawl of the Nexus Bugs and Posts tabs of
https://www.nexusmods.com/battlebrothers/mods/855 (`bugs.jsonl`/`posts.jsonl` in the session scratchpad, cross-checked
with `service/data/nexus_hackflow.jsonl`), per-mod Discord threads (`service/data/discord_reforged_mods.jsonl`,
`discord_legends_bbmodding_mods.jsonl`), Discord searches (`discord_search.jsonl`, `discord_help_hidden.jsonl`,
`norm/*.jsonl`), the user logs in `service/data/logs/**` (grepped for stack frames inside the mod's dirs), and the fix
history (CHANGELOG, tags with their dates, `FIX.md`, `TO_RELEASE.md`). Pure feature requests, install errors (missing
stdlib/Modern Hooks, mod unzipped) and "another mod is the culprit" threads are skipped or get one line.

Links: Nexus posts `https://www.nexusmods.com/battlebrothers/mods/855?tab=posts&jump_to_comment=<id>`, Nexus bugs
`...?tab=bugs&issue_id=<id>`; Discord `https://discord.com/channels/<guild>/<thread>/<msg>`, guilds: Legends
547043336465154049, Reforged 1006908336991645757, BB Modding 965324395851694140. Entries from `discord_search.jsonl`
or `discord_help_hidden.jsonl` have no channel id in the data, so they are cited by file + message id.
"Fixed in X" is inferred from CHANGELOG entries plus tag dates against report dates; where the match is not
explicit it says so. Code paths are relative to `mods/`.

## Fixed

### 1. Weapon disappears when a bro gets Missing Hand (crossbow / 2H weapon / weapon swapped in battle) — fixed in 2.0.3 and 2.0.4
- Source: https://discord.com/channels/965324395851694140/1382737616876736623/1506585854695440485 (2026-05-20; error `Attempted to drop item, but no tile specified!`),
  https://discord.com/channels/965324395851694140/1382737616876736623/1534972867555360941 (2026-08-06, swap to 1H then hand lost, "restore equipment" on)
- Suspected code: `perma/perma_hackflow/hooks/` (Missing Hand item dropping) and the `restoreEquipment` wrap mentioned in `perma/scripts/!mods_preload/mod_perma_hackflow.nut:15`.
- Repro (regression): bro with crossbow (and, separately, 2H sword in hand + 1H in bag, swapped mid-battle) gets `injury.missing_hand`
  while struck down / at battle end → assert the weapon ends up in the stash or loot, never vanishes; repeat with "restore equipment" on.

### 2. `the index 'isNull' does not exist` in onShieldHit (non-WeakTableRef attacker) — fixed in 2.0.2
- Source: `discord_search.jsonl` msg 1499435077422284922 (Reforged #bugs), log `logs/Reforged/1499435077422284922/log.html` (perma 2.0.1, `mod_perma_hackflow.nut : 31` via Lunge)
- Repro (regression): an attacker with Lunge misses a shield bearer → assert no error.

## Not bugs / feature requests (skipped)

Unclear, likely not ours: MSU "Tried to read data beyond … Deserialization Emulator" lines with perma 2.0.2 + Legacy (`discord_help_hidden.jsonl` msg 1510021391536230420, logs `logs/Reforged/1510021391536230420/`); the author says PI doesn't serialize. Missing Hand still double-grips: by design (Stub Bonus).

## Repro status (headless scenario tests, 2026-11-12)

Suite in this dir, overview with commands in `~/projects/bbm/bbtales/OTHER_MODS_RESULTS.md`. "Reproduced"
= a test fails now naming the bug; "passes" = regression test green.

- #1 #2 pass.

## Discord deep search (2026-11-12)

Systematic search of Legends, Reforged and BB Modding: every mod's display name, short forms, id and zip name, "hackflow",
hackflow's own messages (author id; BB Modding capped at 1000 of 1772) and mentions of him; plus a sweep of the 300 newest
log.html attachments not collected before (120 Legends, 120 Reforged, 60 BB Modding) for stack frames in hackflow mods' files.
Logs are in `service/tools/discord_deep/discord_logs/` (listed in its `INDEX.md`); scripts `service/tools/discord_deep/discord_deep*.py`.

### Extends existing

- **Extends #2 (`the index 'isNull' does not exist` in `onShieldHit`, fixed in 2.0.2).** Two Discord reports:
  https://discord.com/channels/1006908336991645757/1450012846518829087/1450013394462576782 (sp0gg 2025-12-15, Lord Midas:
  "caused by `mod_perma_hackflow`"; Perma 2.0.1 + Reforged + Modular Vanilla; log
  `discord_logs/reforged_1450012846518829087_log.html`:
  `the index 'isNull' does not exist` at `scripts/!mods_preload/mod_perma_hackflow.nut : 31` ← `onShieldHit ->
  scripts/skills/skill.nut : 1343` ← `MV_onAttackEntityMissed -> mod_modular_vanilla…`, right after a Reforged Lunge
  teleport callback) and https://discord.com/channels/1006908336991645757/1499435077422284922/1499442784728518776
  (2026-04-30, hackflow and Lord Midas work out that something passes a plain table instead of a `WeakTableRef`; fix
  `e3b0526`).
- **perma "unclear, likely not ours" (MSU "Tried to read data beyond … Deserialization Emulator" with Legacy)** — the
  reporter narrowed it to MSU + Permanent Injuries + Legacy, on every quicksave/load of a new campaign
  (https://discord.com/channels/1006908336991645757/1283857645492502549/1510039127960191027,
  …/1510042526310989826). Reduced-modset log `discord_logs/reforged_1510042604190830823_log.html` (perma 2.0.2) shows
  3× `Tried to read data beyond (0) the length (0)` right after `MSU Serialization: Loading Legacy × Perma Hackflow
  (mod_legacy_perma_hook), version 1.1.9`. That third-party bridge mod (by Legacy's side) is the only perma-related mod
  using MSU serialization; perma itself writes nothing (hackflow …/1510099944965672970). So: the bridge mod's bug,
  not perma's. Repro (if the bridge is available): MSU + perma + Legacy + bridge, new campaign, save, load → assert no
  emulator lines.

### Skipped

- "Tried to read data beyond (0) the length (0) of the Deserialization Emulator" after every load with only MSU + Perma +
  Legacy (+ Legacy × Perma compat mod), https://discord.com/channels/1006908336991645757/1283857645492502549/1510039127960191027
  (2026-05-29, log `discord_logs/reforged_1510021391536230420_log.html`, Perma 2.0.2): Perma has no serialization code;
  the MSU serde emulator is used by Legacy / its compat mod. Not Perma.
- "Injuries work like default" (Legends 2026-07-04): the mod zip wasn't in the data folder.
- Missing Hand makes the mod non-removable mid-campaign (vanilla injury's broken `onAdded`): by design, documented.
- perma test builds `_HAND_DROP_1`, `_RESTORE_FIX1` in the BB Modding thread belong to existing #1.

## Repro status (Discord section)

Headless tests, 2026-11-12, in this dir's `tale_discord_bugs*.nut`; details in `FOUND_BUGS.md`.
Open/unclear entries of the Discord section only.

1. Not feasible headless (Legends/SSU/Hardened/PTR not available): perma's Legacy bridge mod.
2. Legends 19.4.23 / Hardened 1.26.3 / Reforged 0.9.3 (2026-11-12):
   Legacy bridge not reproduced (Legacy 2.13 / bridge 1.1.9, MSU 1.8 and 1.9).
