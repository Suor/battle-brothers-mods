# Accessory Companions fixed by hackflow — known bugs

Collected 2026-11-11 from: a fresh full crawl of the Nexus Bugs and Posts tabs of
https://www.nexusmods.com/battlebrothers/mods/1054 (`bugs.jsonl`/`posts.jsonl` in the session scratchpad, cross-checked
with `service/data/nexus_hackflow.jsonl`), per-mod Discord threads (`service/data/discord_reforged_mods.jsonl`,
`discord_legends_bbmodding_mods.jsonl`), Discord searches (`discord_search.jsonl`, `discord_help_hidden.jsonl`,
`norm/*.jsonl`), the user logs in `service/data/logs/**` (grepped for stack frames inside the mod's dirs), and the fix
history (CHANGELOG, tags with their dates, `FIX.md`, `TO_RELEASE.md`). Pure feature requests, install errors (missing
stdlib/Modern Hooks, mod unzipped) and "another mod is the culprit" threads are skipped or get one line.

Links: Nexus posts `https://www.nexusmods.com/battlebrothers/mods/1054?tab=posts&jump_to_comment=<id>`, Nexus bugs
`...?tab=bugs&issue_id=<id>`; Discord `https://discord.com/channels/<guild>/<thread>/<msg>`, guilds: Legends
547043336465154049, Reforged 1006908336991645757, BB Modding 965324395851694140. Entries from `discord_search.jsonl`
or `discord_help_hidden.jsonl` have no channel id in the data, so they are cited by file + message id.
"Fixed in X" is inferred from CHANGELOG entries plus tag dates against report dates; where the match is not
explicit it says so. Code paths are relative to `mods/`.

## Open / unclear

### 1. Tamed beasts have Reach 0 under Reforged — open (in `mods/FIX.md`; author: "will look")
- Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/1054?tab=posts&jump_to_comment=171760913 (2026-07-03)
- Suspected code: `AC/scripts/companions/types/*.nut` / companion spawning: AC builds its own entities, so Reforged's per-enemy Reach setup never runs.
- Repro: Reforged on; unleash a tamed wolf/unhold → assert `getCurrentProperties().Reach > 0`, equal to the Reforged enemy of the same type.

### 2. Tamed Nachzehrer doesn't gain max HP when eating corpses (Hardened) — unclear
- Source: https://discord.com/channels/1006908336991645757/1520795288317595789/1532715656758169681 (2026-07-31)
- Repro: companion ghoul uses Gruesome Feast → assert size grows and `getHitpointsMax()` grows like the enemy ghoul's.

## Fixed

### 3. Tame does nothing (uses AP/fatigue) without stdlib — fixed in 2.1
- Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/1054?tab=bugs&issue_id=1098149; log `logs/Nexus/1098149/log.html`
  (`the index 'std' does not exist` at `scripts/companions/player/companions_tame.nut : 96`)
- Repro (regression): without stdlib loaded, `companions_tame.getHitchance(target)` → assert a number, no error.

## Not bugs / feature requests (skipped)

Old reports of tamed Alps crashing (from the original AC, unverified), "ACU 1.2.3" crashes on the Legends Discord (that's Legends' own AC build), the broken druid link on the description page.

## Repro status (headless scenario tests, 2026-11-12)

Suite in this dir, overview with commands in `~/projects/bbm/bbtales/OTHER_MODS_RESULTS.md`. "Reproduced"
= a test fails now naming the bug; "passes" = regression test green.

- #1 confirmed for every companion type; #2 not reproduced without Hardened; #3 passes.

## Discord deep search (2026-11-12)

Systematic search of Legends, Reforged and BB Modding: every mod's display name, short forms, id and zip name, "hackflow",
hackflow's own messages (author id; BB Modding capped at 1000 of 1772) and mentions of him; plus a sweep of the 300 newest
log.html attachments not collected before (120 Legends, 120 Reforged, 60 BB Modding) for stack frames in hackflow mods' files.
Logs are in `service/tools/discord_deep/discord_logs/` (listed in its `INDEX.md`); scripts `service/tools/discord_deep/discord_deep*.py`.

Numbering continues the list above.

### 4. Tame identified beasts by their display name, so taming broke with a translated game (and Northern Expansion direwolf) — fixed in 2.0 (`2008c56`, "identify beasts by class")
- Source: BB Modding general-chat https://discord.com/channels/965324395851694140/965324396317278240/1294672268403806218
  (hackflow 2024-10-12: "if Direwolf is called something else then it cannot be tamed"; …/1294679069174009936: IDs are
  shared by dog/wolf kinds, "the author simply used Name"; AC Legends uses Type, losing dog/wolf variants).
- Old code: `this.Const.Companions.TameList.find(target.getName())` in `companions_library.nut`.
- Code now: `::Const.Companions.getType` by `ClassName` (`AC/scripts/companions/companions_library.nut:59-62`).
- Repro: rename a direwolf (`setName("Lobo")`) and a translated unhold; use Tame with forced success; assert a
  companion of the right type is produced.

### 5. Tamed Alp may crash the game (e.g. tamed Alp killing an enemy Alp) — unclear (old report relayed by the original author, never logged)
- Source: https://discord.com/channels/965324395851694140/1520791670696710295/1521099320038785196 (vazl, original AC
  author, 2026-06-29) and …/1522752220351828120; hackflow (…/1522263202971390145): "didn't do anything to fix it".
- Suspected code: `AC/scripts/companions/types/companions_alp.nut:142-269` (`onDeath`: kills `alp_shadow` illusions
  of its own faction, unequips the item) and `:295-316` (`onActorKilled` XP share); vanilla `alp_racial` /
  `sleep_skill` / nightmare (`AC/scripts/companions/skills/companions_nightmare_skill.nut`) on a player-faction alp.
- Repro: tamed Alp (player faction) vs enemy Alps with shadows; let the tamed Alp kill an enemy Alp with nightmare,
  then let the tamed Alp die; run the AI for both sides to battle end. Assert no script error and the item is returned
  to the owner's slot/stash.

### Skipped

- Reforged chat only ("looks like accessory companions", companion perks, party strength growing with companions); nothing about hackflow's build failing.

## Repro status (Discord section)

Headless tests, 2026-11-12, in this dir's `tale_discord_bugs*.nut`; details in `FOUND_BUGS.md`.
Open/unclear entries of the Discord section only.

1. #5 (tamed Alp crash) — not reproduced (`discord_bugs::AC-KB5` ×2: AI rounds; Nightmare kill both ways).
2. Fixed entry #4 got no regression test.
3. Real Hardened 1.26.3 / Reforged 0.9.3 / Crock Pot 0.10.6 / Legends 19.4.23 / Clever Recruiter 2.1.8 (2026-11-12):
   #2 reproduced with Hardened (tamed ghoul +0 HP vs wild +120 per feast; Hardened's `ghoul.grow` hook misses AC's
   class).
