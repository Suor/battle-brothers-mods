# Scenario tests of the other mods — results (2026-11-12)

Headless game-scenario suites for hackflow's mods besides nicknames, fun_facts and autopilot, on
modern-bb-engine through this runner (vanilla 1.5.2 + Modern Hooks 0.6.0 + MSU 1.8.0 + stdlib,
hackflow's mod_hooks shim; Reforged 0.8.18 where the mod claims compatibility). Each mod's suite
is `~/projects/bbm/mods/<mod>/scenarios/` with its `README.md` and, where something was found,
`FOUND_BUGS.md`. Known-bug ids follow `KNOWN_BUGS_other_mods.md` (`CA-KB1` = camps_and_artifacts
#1); new bugs are `CA1`, `IW1`, …. A bug test fails while the bug is open.

```bash
cd ~/projects/bbm/mods/_scripts/bbtest
./bbtest.py -j 12 ../../{AC,background_perks,bro_studio,camps_and_artifacts,challenges,cheap_meat,druid,elite_few,events_delayed_fix,fixes,fix_reforged,hackflows_perks,heal_repair_fix,immortal_warriors,mod_beast_loot,more_blood,necro,perma,random_perk,renamer,retinue_ups,standout_enemies,stupid_game,translations,useful}/scenarios/*.nut
```

All 26 mods: 247 tests in 83 launches on suor-p1 (`-j 12`, packed; 236 in 78, 51 s wall, before the Discord deep search tests `*/scenarios/discord_bugs*.nut`). Every
failure is a bug test (plus one control by design and the fix_reforged launch that can't boot).
Packed and `--isolate` give the same statuses for every bug test. `nicknames` (47/11) and
`fun_facts` (51/16) suites unchanged after the runner README edits.

## Per mod

| Mod | Tests | Pass | Fail | Bugs (fail now) | Known bugs: repro status |
| --- | --- | --- | --- | --- | --- |
| camps_and_artifacts | 24 | 18 | 6 | CA-KB1, CA-KB3, CA-KB6, CA-KB8 | #1 #3 #6 #8 reproduced (#3 after an arena fight); #9 #11 regressions pass; #2 not reproduced (also with Crock Pot 0.8.0, mechanism confirmed), #7 not reproduced; #4 #16 #17 Legends/SSU, #5 UI |
| retinue_ups | 14 | 11 | 3 | RU-KB1, RU1, RU2 | #1 reproduced; #2 not reproduced in-session (restart/Legends untestable); #3 passes |
| elite_few | 18 | 13 | 5 | EF-KB1 (stub), EF-KB2, EF-KB3 (partly), EF1, + 1 control | #1 #2 reproduced, #3 partly; #8 not reproduced in vanilla with Clever Recruiter 2.1.6 (Legends path, mechanism confirmed); #6 tutorial not tested; #4 #5 #9 #10 SSU/Legends |
| bro_studio | 17 | 16 | 1 | BS1 (stdlib) | #1 (also with Gifted) #2 #3 not reproduced; #6 passes |
| necro | 14 | 10 | 4 | NE-KB1, NE-KB2, NE1, NE2 | #1 #2 reproduced; #4 #5 pass; #3 maybe by design, #6 no report |
| hackflows_perks | 12 | 10 | 2 | HP-KB2, HP1 | #2 reproduced with Sato's mod; #1 not reproduced; #3 passes |
| AC | 11 | 9 | 2 | AC-KB1 (2 tests) | #1 reproduced (every type); #2 not reproduced w/o Hardened; #5 (tamed Alp) not reproduced; #3 passes |
| druid | 10 | 10 | 0 | — | #1 not reproduced (vanilla and Reforged, every beast type) |
| perma | 9 | 9 | 0 | — | #1 #2 regressions pass |
| fix_reforged | 0 | – | boot | FR1 | (no known bugs) |
| immortal_warriors | 20 | 18 | 2 | IW1, IW2 | #1 not reproduced on 13 vanilla origins (Legends-only) |
| standout_enemies | 6 | 4 | 2 | SE-KB1, SE-KB2 | #1 #2 reproduced |
| useful | 7 | 7 | 0 | — | #1 regression passes |
| background_perks | 21 | 21 | 0 | — | #1 not reproduced (14 origins); #2 passes; #3 Legends |
| fixes | 6 | 5 | 1 | FX1 | — |
| more_blood | 4 | 3 | 1 | MB1 | — |
| translations | 4 | 3 | 1 | TR1 | — |
| challenges | 10 | 10 | 0 | — | Legends report untestable |
| mod_beast_loot | 4 | 4 | 0 | — | "doesn't work in vanilla" not reproduced |
| cheap_meat | 4 | 4 | 0 | — | — |
| heal_repair_fix | 10 | 10 | 0 | — (README outdated, repair half a no-op on 1.5.2) | — |
| events_delayed_fix | 4 | 4 | 0 | — | — |
| renamer | 3 | 3 | 0 | — | — |
| stupid_game | 6 | 6 | 0 | — | — |
| random_perk | 2 | 2 | 0 | — (JS-only, smoke) | — |

Every mod has a `smoke.nut` (boot, mod registered, an AI battle won, 2 days, save/load); the 12
claiming Reforged compatibility also `smoke_reforged.nut`. All pass except fix_reforged's.

## Bugs found (new) and reproduced (known), by severity

High
1. **FR1** fix_reforged doesn't boot with Reforged 0.8.x: `the index 'PerkTreeMultipliers' does
   not exist` (`fix_reforged/scripts/!mods_preload/mod_fix_reforged.nut:15`; the field is gone since
   Reforged 0.6.2→0.8). Unreleased mod.

Medium
2. **IW1** Immortal Warriors counts kills/battles of earlier lives again on every rebirth (5+3 kills → 13).
3. **SE-KB1** Standout Enemies: hair/beard stay at a tenth of their color after the curse, head/body
   lose their tint (`setBrightness` is destructive; the look isn't saved).
4. **SE-KB2** Standout Enemies: a resisted curse throws `the index 'actor' does not exist`.
5. **CA-KB1** C&A: the Reforged artifact fencing sword (−25% head) breaks MSU's serialization emulator, users' error verbatim.
6. **CA-KB6** C&A: artifact shields under Reforged 50–72 durability vs 300 for named ones.
   **CA-KB3** C&A: after an arena fight four C&A locations build the arena floor (vanilla's shallow clone of
   `LocationTemplate` in `arena_contract`; those four never set `Template[0]`).
7. **RU-KB1** Retinue Promotions: loading an older save keeps the promoted follower object (cost 10500, effects).
8. **RU2** a demoted follower promoted again gets the flag but no cost/effects (`ru_base` left behind; root of RU-KB1).
9. **EF-KB1** Elite Few's `setScreen` wrapper hides `processInput` from Hardened's caller check (reproduced with a stub of Hardened's hook).
10. **EF-KB2** an exception in an event screen leaves `inEventOrContract` on: later recruits become masters.
11. **NE-KB1** Possess accepts enemy zombies; **NE-KB2** Mind Meld skips stackable perks (vanilla
    `getAllSkillsOfType` skips hidden skills, and they hide at 0 stacks).
12. **AC-KB1** every tamed companion has Reach 0 under Reforged (and misses the Nachzehrer's Reach growth).
13. **BS1** Bro Studio "Add good traits" off still adds them: `std.Player.addTraits` (stdlib) ignores `_opts.good`.
14. **FX1** Hackflow's Fixes under Reforged without Adam's mod_hooks: `mods_hookDescendants` missing, shield fix not applied.

Low
15. **IW2** Immortal Warriors' talent boost keeps old level-up rows for a bro who already levelled (`immortal_extraALUV` goes negative).
16. **EF1** Elite Few's master bonus to party strength doubles after a load (mod_hooks fires the `hookNewObject` twice for a loaded party).
17. **EF-KB3** MSU's dummy player gets `trait.master` under Reforged (no endless loading seen).
18. **RU1** ctrl-click on an empty retinue slot throws (`getID` before the null check).
19. **NE1** Necromastery and `pg.necro` share an icon: MSU error at every Reforged boot; **NE2** Possess shows its disabled icon.
20. **HP-KB2** Sato's Lone Wolf text lost (Sato patches `Perks[4][2]`, this mod shifts row 4); **HP1** Full Force targets `pg.rf_large`, absent in Reforged 0.8.18.
21. **CA-KB8** freezing ammo tooltips promise freezing, the hit chills.
22. **MB1** More Blood overwrites `::EventsFix` (copy-paste of the global name).
23. **TR1** price lines with nothing after "%" stay English (Rosetta's trailing `line` can't match empty at the end; unconfirmed that the mod prints such a line).

## Engine divergences and runner notes (in the runner README)

- `"2.6".tofloat()` keeps 64 bits while the literal is f32: `require("stdlib >= 2.6")` fails at boot
  (Bro Studio). Worked around with `// allow-errors:`.
- Same-named scenario files with the same header collide in one launch (one silently lost).
- Errors through a native `acall` are logged even when caught; the loot screen is never taken;
  `t.battle` entities with `Party` need a `WeakTableRef`; Reforged's `onRemovedFromMap activeEntity
  null` still shows up in some AI battles (filtered in the Reforged smoke tests and AC/druid helpers).

## Not tested, and why

- UI/JS: random_perk entirely, perk trees and level-up screens, C&A camp tooltips on the map (#5),
  Challenges' loot choice and No Tryout/No Firing, Immortal Warriors' level-up changes.
- Legends-only reports (C&A #4 #7, Elite Few #4 #5, Background Perks #3, Challenges, Immortal
  Warriors #1 on Legends' Lone Wolf, Bro Studio Legends): no Legends build here.
- Hardened (C&A #2, Elite Few #1 for real, AC #2, Bro Studio #2): Hardened 1.18.3 needs Reforged
  ≥ 0.9.0 + Dynamic Spawns, only 0.8.18 is installed.
- mod_vap: no longer supported (superseded by Bro Studio); its suite (7 tests, all passing, counted in the totals
  above) was removed on 2026-11-13.
- Game restart between save and load (Retinue #2), long-play statistics (events_delayed_fix timing),
  the other six mods the translations cover.

## Reforged 0.9.3 re-run (2026-11-12)

The 27 scenario files whose header names Reforged 0.8.18 (12 mods' `smoke_reforged.nut` and `reforged*.nut`, plus
autopilot's, fun_facts', nicknames' `reforged_bp.nut`, C&A's `discord_bugs_crock_pot.nut`), run unchanged with
`--swap` onto the newest stack (`mods/VERSIONS.md`): Modern Hooks 0.7.0 + MSU 1.9.0 (`fw9`), Reforged 0.9.3 with its
frameworks (`reforged9`), Crock Pot 0.10.6 for 0.8.0, Black Pyramid 1.4.4 for 0.4:

```bash
./bbtest.py -j 12 --swap fw=fw9 --swap mod_framework-0.8.17-russian.zip= \
  --swap mod_reforged_core-0.8.18-russian.zip=reforged9 --swap mod_crock_pot-russian.zip=mod_crock_pot-0.10.6.zip \
  --swap mod_Black_Pyramid_0.4_eng_0.4_Z3ILe0WK1.zip=mod_Black_Pyramid-1.4.4_eng.zip <those files>
```

61 tests either way; non-passing 12 on 0.8.18 → 11 on 0.9.3, plus fix_reforged's boot failure (FR1) on both.

| Test | 0.8.18 | 0.9.3 |
| --- | --- | --- |
| `nicknames reforged_bp::N5: starting brothers' titles are distinct` | FAIL (`the Conscript` twice) | PASS (also Black Pyramid 0.4 → 1.4.4: another roster; not evidence of a fix) |
| every `smoke_reforged` (12 mods) | PASS (fix_reforged: boot) | same |
| CA-KB1 ×2, CA-KB6 (50/60/72 vs 300), NE1, NE2, AC-KB1, AC-KB2, EF-KB3, FX1, autopilot KB3, HP1 (`pg.rf_large` still absent) | FAIL | FAIL, same asserts |

So every bug reproduced on Reforged 0.8.18 is still there on 0.9.3 and nothing new broke.

## Known bugs with the real third-party mods (2026-11-12)

The reports skipped before as needing Legends / Hardened / SSU / newer Reforged, now on the real mods
(`mods/VERSIONS.md`): new files `<mod>/scenarios/{legends,hardened,cr218,legacy}*.nut` (details in each mod's
`FOUND_BUGS.md`, repro lines in `KNOWN_BUGS_other_mods.md` "Repro status (Discord section)" 8–9). Added tests only;
the counts above are unchanged.

| Mod | New tests | Pass | Fail | Bugs (fail now) | Known bugs: repro status |
| --- | --- | --- | --- | --- | --- |
| camps_and_artifacts | 6 | 4 | 2 | CA-KB16 ×2 | #2 not reproduced with real Hardened (+ Crock Pot 0.10.6); #16 reproduced; #4 #7 not reproduced on Legends 19.4; #17 SSU doesn't boot |
| elite_few | 12 (2 controls) | 8 | 4 | EF-KB1 ×2 (real Hardened), EF-KB10, EF2 | #1 #10 reproduced; #5 #9 not reproduced; #8 not reproduced with CR 2.1.8; #4 SSU |
| AC | 1 | 0 | 1 | AC-KB2 | #2 reproduced with real Hardened |
| bro_studio | 4 | 4 | 0 | — | #2 not reproduced with Hardened; #4 regression passes on Legends |
| retinue_ups | 3 | 1 | 2 | RU-KB2 (Legends), RU-L1 | #2 reproduced on Legends 19.4.23 |
| immortal_warriors | 4 | 2 | 2 | IW-KB1 ×2 (Legends) | #1 reproduced on Legends (vanilla origins Legends re-hooks) |
| background_perks | 7 | 3 | 4 | BP-KB4 ×2, BP-L1 ×2 | #3 not reproduced on Legends 19.4.23; #4 reproduced |
| challenges | 3 | 2 | 1 | CH-L1 | Legends level-up: UI data fine, the button is JS |
| useful | 1 | 1 | 0 | — | #2 not reproduced on Legends 19.4.23 |
| perma | 4 | 4 | 0 | — | Legacy bridge not reproduced (Legacy 2.13) |
| necro | 1 | 1 | 0 | — | Hardened 1.26.3: perks fine |

New bugs: **EF2** (medium) Clever Recruiter 2.1.8 runs `buildAttributes` twice per recruit (first with rolls pinned to
max), so Elite Few rolls and adds the master trait twice (vanilla; on Legends the hooks wrap in another order);
**BP-L1** (medium, Legends) ~4 in 100 recruits throw `the index 'Const' does not exist`: without Dynamic Perks the mod
rolls perks Legends doesn't define; **RU-L1**, **CH-L1** (low, Legends) Legends' own `setFollower` /
`getFollowersForUI` hide the mods' hooks.

A third-party error seen once in 5 runs of `hardened_cp_bugs_ca.nut` (Reforged 0.9.3 + Hardened + Crock Pot 0.10.6):
`the index 'spawnUnit' does not exist` at `mod_dynamic_spawns/classes/spawnable.nut:140` (`chooseSpawn()` returned
null) ← Hardened's `Party.spawn` ← Crock Pot's `despawn_order` hook refilling a location, in the world AI's think.
It stops the launch here (`FRAME FAILURE`, runner README); the original would log it and go on. Not C&A's; it depends
on the engine's unseeded randomness, so the test passes on a re-run.

## Black Pyramid 0.4: its saves don't load from the main menu (2026-11-12)

Nicknames' `reforged_bp.nut` launch (Reforged 0.8.18 + Black Pyramid 0.4) fails under `--snapshot`:
`item_container.onDeserialize` → `parameter 1 has an invalid type 'null'` (`::new(IO.scriptFilenameByHash(...))` of a
hash no script has: the stream is shifted). A real bug of Black Pyramid 0.4, not of nicknames, the engine or the runner.

- Cause: `mod_elemental/hooks/item_serialize.nut` (Elemental Reforged, bundled in BP 0.4) writes a presence bool after
  every item, but reads it only when `World.Flags` holds its marker `Elem_ItemSerVer2`, assuming the flags load before
  the items. The rosters' units (and their items) load before `world_state.onDeserialize` restores `World.Flags` (the
  original's order, which the engine follows: `squirrel-bb/src/native/save/mod.rs`, probed against the original). A
  load in the running campaign still has the marker in memory and works; a load from the main menu (after starting the
  game or quitting to the menu) has a new, empty `World.Flags`: the first item's bool stays unread, and the next
  item's slot and class hash are read one byte off.
- A player hits it: Discord, BB Reforged #technical-help, message 1545767305911210085 (2026-09-05, "Game crashes
  immediately when loading any save; saves can be created but not loaded"), BP 0.4 in the original game: the same
  stack (`item_container.nut:1055`, `slotType = 0, i = 1`, `Failed to create new instance from "(null : 0x00000000)"`),
  after a return to the main menu (`service/data/logs/Reforged/1545767305911210085/log.html`).
- Without nicknames: the same (`thirdparty/bp_load.nut`, removed 2026-11-13: BP's bug, fixed in 1.x). Black Pyramid 1.4.4 + Reforged 0.9.3 (`bp_load_144.nut`): both
  loads pass, its `item_serialize.nut` reads the bool always ("symmetric with the writer").
- Repro: `./bbtest.py thirdparty/bp_load.nut thirdparty/bp_load_144.nut`: "load as from the main menu" swaps in new
  empty flags before `t.load` (as a new `world_state` has); BP 0.4 ERROR (by design, until it's fixed), 1.4.4 PASS.
  The real main-menu path: `--snapshot` (after a `--snapshot -k running` run made the snapshot) fails the BP 0.4 launch
  at its start with the same error, and runs the 1.4.4 one.
- The code approach (`_scripts/codetest`) can't tell: Reforged 0.8.18 boots there with 21 errors and its in-campaign
  load already fails (`RF_LastVisitSituations` in Reforged's `contract_manager` hook), and saves don't outlive a test.
