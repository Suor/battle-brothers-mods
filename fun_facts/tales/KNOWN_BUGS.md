# Fun Facts — known bugs

Collected 2026-11-11 from: Nexus Posts/Bugs tabs (https://www.nexusmods.com/battlebrothers/mods/764), Discord mod
threads (Reforged `1333021288096075786`, BB Modding `1283059183465529506`), Discord search for "fun facts" in
Legends/Reforged/BB Modding, `service/data/logs/` (user logs with `fun_facts/` stack frames), `service/jobs/`
(`hardened-fun-facts`, `broke-reforged-nested-tooltips*`), CHANGELOG, git history and the uncommitted working tree.

Released: 1.0.3 (tag `fun-facts-1.0.3`, 2025-06-14). HEAD has ~8 unreleased commits (temple/buys tracking, kill verbs,
Pandora's Hobby compat) plus an uncommitted fix in `scripts/mods/fun_facts/fun_facts.nut` (`setPlayer` no longer calls
`getName()`, see #1).

Code refs: `ff.nut` = `fun_facts/scripts/mods/fun_facts/fun_facts.nut` (HEAD), `fun_facts/<file>.nut` = hooks dir,
`preload` = `fun_facts/scripts/!mods_preload/mod_fun_facts.nut`.

General note: in Scenario mode (main-menu tactical scenarios) `::World` is not set up, but scenario bros are
`player` entities, so they get a FunFacts object too. Several hooks write `World.getTime().Days` and call
`::FunFacts.getBattleId()` (→ `::World.getPlayerRoster()`, `::World.Statistics`). See #2.

## Open / unclear

### 1. Crash creating an event bro with Reforged nested tooltips: `getID` does not exist — open in 1.0.3, fixed in working tree (uncommitted)
- Sources: logs `service/data/logs/Reforged/1498684242287268021/log.html`, `.../1499517118150869013/log.html`,
  `.../1501835667401998416/log.html` (Reforged help, "Black Pyramid" thread, Fun Facts 1.0.3); job
  `service/jobs/broke-reforged-nested-tooltips/request/log.digest.txt` (hackflow's own TMP builds, Reforged 0.8.x).
- Mods: Reforged (MSU nested tooltips) ± Hardened.
- Error:
  ```
  Script Error: the index 'getID' does not exist
    at getName -> mod_reforged/msu_systems/nested_tooltips.nut : 28
    at setPlayer -> scripts/mods/fun_facts/fun_facts.nut : 102
    at -> fun_facts/player.nut : 11                      (player.create hook)
    at start -> scripts/events/events/master_no_use_apprentice_event.nut : 64
  ```
  (job log: `cultist_origin_flock_event.nut : 55`). Reforged wraps `actor.getName()` during event screens to emit
  `[name|EventActor+<getID()>]`; inside `player.create()` the entity has no `getID` yet. The bro is left half-built.
- Suspected code: 1.0.3 `ff.nut:102` `this.m.Name = _player.getName();` in `setPlayer`, called from
  `fun_facts/player.nut:10`. The working tree drops that line (name is set later via `setName`/`onDeserialize`).
- Repro idea: Reforged loaded; fire an event that does `::new("scripts/entity/tactical/player")` inside a screen's
  `start` (e.g. `master_no_use_apprentice_event`, or a test event that sets `::Reforged.NestedTooltips` "applying
  nesting for events" and creates a player). Assert no script error, bro has `m.FunFacts != null`, and after
  `setName`/`setTitle` `m.FunFacts.m.Name == bro.getName()`.

### 2. Scenario mode: killed enemies stay alive, unarmed and untargetable — fixed in the working tree (uncommitted)
- Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/764?tab=posts&jump_to_comment=147333916
  (OrbitalOverdose, 2024-12-10, Fun Facts 0.5.0/1.0.0 era; "possibly with Autopilot New"). Author asked for a log; none
  given.
- Symptoms: only in main-menu Scenario fights. A killed enemy leaves a corpse but keeps standing and keeps its place in
  the turn order; on its turn it attacks as if unarmed; it cannot be targeted. Campaign fights are fine.
- Suspected code: `fun_facts/actor.nut:9-16` — the `actor.onDeath` hook calls `killer.m.FunFacts.onKill()` *before*
  the original. Subclasses (e.g. `human.onDeath`) spawn the corpse and drop items first, then call the base
  `actor.onDeath`, so the corpse already exists. `onKill` (`ff.nut:205-228`) calls `::FunFacts.getBattleId()`
  (`preload:17-33`, uses `::World.getPlayerRoster()` and `::World.Statistics.getFallen()`) and
  `this.World.getTime().Days`. If those throw in Scenario mode, `actor.kill()` aborts before the entity is removed from
  the map. That matches all the symptoms, but is not verified.
- Repro idea: start a tactical scenario (`Tactical.State` with `isScenarioMode() == true`, e.g.
  `scenario_combat_basics`) with Fun Facts loaded; have a player bro kill an enemy (`enemy.kill(bro, skill)`). Assert
  no script error, enemy `!isAlive()`, `!isPlacedOnMap()`, and it is gone from the turn sequence. Control: the same
  kill in a campaign battle.

### 3. Player bro injured by an attacker-less effect crashes in `onInjury` — fixed in the working tree (uncommitted)
- Source: derived from the fixed report #11 (corpse explosion, `_attacker = Null`). 1.0.2 (`dace7dd`) guarded only
  the attacker side.
- Suspected code: `fun_facts/actor.nut:31` still calls `this.m.FunFacts.onInjury(_attacker, injury)` with a null
  `_attacker`, and `ff.nut:259-260` read `_attacker.ClassName` / `_attacker.getName()`. Expected error:
  `the index 'ClassName' does not exist` at `fun_facts.nut : 259`.
- Mods: Reforged (corpse explosion via scheduled callback passes null attacker) or vanilla 1.5.1 effects that call
  `onDamageReceived(null, ...)`.
- Repro idea: tactical battle; call `bro.onDamageReceived(null, null, hitInfo)` with a hitInfo that injures (high
  damage to head/body, `InjuryThresholdMult` raised), or detonate a Reforged corpse explosion next to a player bro.
  Assert no script error and `bro.m.FunFacts.m.Stats.Injuries` grew by one, with null attacker fields.

### 4. "Failed to load fallen FunFacts: Packed string ... does not start with a magic string" — fixed in the working tree (uncommitted)
- Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/764?tab=posts&jump_to_comment=158058592
  (solinger, 2025-08-13). Errors for `FallenFunFacts.0` … `FallenFunFacts.21` on load. Reporter had commented out the
  TCO part; author asked whether the mod was added to an existing save (no answer).
- Suspected code: `fun_facts/statistics_manager.nut:16-23` writes `this.m.Flags.set("FallenFunFacts." + i, null)` for
  fallen without FunFacts; on load (`:32-43`) `::std.Flags.unpack` throws the "magic string" error when the stored value
  is a string shorter than or not starting with the packer magic (`stdlib/stdlib/flags.nut:24-38`). Hypothesis: the
  engine stores the `null` as an empty string, so every fallen bro who died before Fun Facts was installed (22 here)
  logs an error on each load. Harmless (caught), but noisy.
- Repro idea: campaign; add 2–3 entries to `World.Statistics.m.Fallen` without a `FunFacts` key (or kill bros with the
  hook removed); save; load. Assert no `Failed to load fallen FunFacts` log line and that the fallen tooltip
  (`FunFacts_getTooltipForFallen`) still works. Also try a value written by Fun Facts 0.5.0 (pre-1.0.0 format).

### 5. Roster tooltip error "string expected for the specified format" — unclear (likely a third-party translation)
- Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/764?tab=posts&jump_to_comment=155999725
  (flyflyflyflyflyfly, 2025-06-25).
- Symptoms: after a bro was struck down by a friendly arrow, his roster/payroll tooltip stops working:
  ```
  Script Error: string expected for the specified format
    extendTooltip -> scripts/mods/fun_facts/fun_facts.nut : 328
    (fromBros = 1, text = 死亡2次, deaths = 2)
    -> fun_facts/player.nut : 38   (getRosterTooltip)
  ```
  Line 328 of the English 1.0.3 has no `format()`, so this is a modified (Chinese) build; the author suspected an old
  translated version.
- Suspected code: `ff.nut` `extendTooltip` deaths block (`deaths > 1`, `KilledByBros == 1` branch, around lines 320-330).
- Versions (2026-11-15): no English release 0.5.0–1.0.3 has `format()` on that line; the report (2025-06-25) came after
  1.0.3 (2025-06-14), whose line 328 is exactly the `fromBros != deaths` branch the locals show
  (`text += ". " + (fromBros == 1 ? "One" : fromBros) + " of them from a hand of a bro."`). So a Chinese build of 1.0.3
  with that line rewritten as `format()`; Squirrel's `%s` given an integer (`fromBros`) throws exactly this error.
- Repro idea: bro with `Stats.Deaths` = 2 records, one with `IsPlayer = true, Self = false` (killed by a bro); build
  `bro.getRosterTooltip()` in English and with Rosetta Russian. Assert no error and the line reads "Died 2 times. One
  of them from a hand of a bro."

### 6. Missing stdlib gives a cryptic error instead of a dependency message — fixed in the working tree (uncommitted)
- Sources: logs `service/data/logs/Reforged/1524605783260532757/log.html`, `.../Reforged/1568349721926311988/log.html`,
  `.../Legends/1462649371081441332/log.html`; job https://bb.hackflow.ru/log/hardened-fun-facts
  (`service/jobs/hardened-fun-facts`, hackflow on Reforged Discord: "Broken Fun Facts is masking it",
  https://discord.com/channels/1006908336991645757/1568349721926311988/1569959747019477074); also
  https://discord.com/channels/1006908336991645757/1489560524818743298/1489562956642648227.
- Error: `the index 'std' does not exist at main -> scripts/mods/fun_facts/fun_facts.nut : 1` and
  `Failed to execute script file "scripts/mods/fun_facts/fun_facts.nut"`.
- Suspected code: `scripts/mods/fun_facts/fun_facts.nut:1-2` and `preload:16` use `::std` at file load time, before
  `::mods_queue`'s `stdlib(>=2.4)` check can report the missing mod.
- Repro idea: load the mod set without stdlib. Assert the only Fun Facts complaint is a mod_hooks / Modern Hooks
  "missing stdlib" message, with no script errors from `fun_facts/`.

### 7. Saves/loads get slower in long campaigns until load hangs (Legends) — unclear
- Source: Legends help https://discord.com/channels/547043336465154049/1422862672625406032/1422862672625406032
  (vektort, 2025-10-01, around day 110–117; the Legends compat checker flagged Fun Facts as "can cause weird issues";
  OneDrive write path and an incompatible retinue mod were also in play). Not attributed to Fun Facts by anyone.
- Suspected code: per-bro history grows without bound — `BattlesLog`, `Kills`, `Injuries`, `InjuriesDealt` arrays
  (`ff.nut:29-50`), packed to bro flags on every save (`fun_facts/player.nut:95-99`), plus every fallen bro
  (`statistics_manager.nut:16-23`).
- Repro idea: synthetic stress test: 20 bros + 100 fallen, each with 300 battles and 500 kills recorded through the real
  hooks (`onCombatStart/onCombatEnd/onKill`); time `onSerialize`/`onDeserialize` and measure packed flag size. Assert a
  bound (e.g. under N KB per bro) or at least a linear, not quadratic, growth.

### 8. Possible conflict with Career Stats — confirmed (JS), fixed in the working tree (uncommitted): Fun Facts' tooltip shows Career Stats' lines too
- Sources: Reforged https://discord.com/channels/1006908336991645757/1036777416309358643/1500358933762674779
  (Lord Midas, 2026-05-03: "perhaps Career Stats and Fun Facts are both incompatible"; removing did not clearly help),
  Fun Facts thread question
  https://discord.com/channels/1006908336991645757/1333021288096075786/1383259133905604698 (author: "no idea …
  might be an issue with graveyard tooltips").
- Repro idea: load both; open roster and obituary tooltips for a living and a fallen bro; assert no errors and both
  mods' lines are present.

### 9. Player-kill hint punctuation (unreleased HEAD) — fixed in the working tree (uncommitted): parts joined with commas
- Source: `mods/ff_bug.png` and `mods/TO_RELEASE.md` ("test killed/chopped … some punctuation issues"). Russian
  tooltip shows `… Каблук. снёс башку … . выпотрошил …` — sentences joined with ". " but not capitalized.
- Suspected code: `::FunFacts.PlayerKillsHint` in `fun_facts/kill_verbs.nut` (unreleased).
- Repro idea: bro with 3 `PlayerKills` records with different Fatality; build the tooltip in English and Russian;
  compare the hint text with the expected string.

## Fixed

### 10. Save corrupted after a fight on a long campaign (Legends) — fixed in 1.0.0
- Source: Legends help https://discord.com/channels/547043336465154049/1300948096183701525/1300960647118590024
  (awa200710039, 2024-10-29, day 127; "removing Fun Facts rescues my save"). Fun Facts 0.5.0.
- Fix: 1.0.0 "fixed possible SAVE CORRUPTION on very long running campaigns" — `07e1350` "support however big bro
  fun facts blobs" (chunked packing in stdlib Flags) and `eab7a0c` (same for fallen).
- Repro idea: bro whose packed `FunFacts` exceeds one flag-string limit (thousands of kill records); save; load.
  Assert load works and the record counts are unchanged.

### 11. Freeze when an attacker-less hit injures someone (corpse explosion, Reforged) — fixed in 1.0.2
- Sources: Reforged thread https://discord.com/channels/1006908336991645757/1333021288096075786/1374354008679907398
  (2025-05-20, battle vs cultists); Lord Midas https://discord.com/channels/1006908336991645757/1283857645492502549/1374016305421619222
  (Flesh Golem death breaks Reforged `onAnySkillExecutedFully`); test build `mod_fun_facts_1.0.1_FIX1.zip`; `dace7dd`.
- Error: `the index 'm' does not exist` at `fun_facts/actor.nut : 32` (`_attacker = Null`), from
  `corpse_explosion_skill.nut : 220` via Reforged `scheduledCallbackWrapper`.
- Repro idea: as #3 but with a non-player victim: Reforged, explode a corpse next to an enemy. Assert no error.

### 12. Kills/deaths not tracked in Reforged (null `_killer` in `onDeath`) — fixed in 1.0.0
- Source: Reforged https://discord.com/channels/1006908336991645757/1327651957657305099/1327651957657305099
  (hackflow, 2025-01-11: Reforged's loot change passes `_killer = null` to `actor.onDeath`); `87147ef`, `a17d8fb`.
- Code now: `fun_facts/actor.nut:2-16` remembers the killer from `actor.kill()`.
- Repro idea: Reforged battle; bro kills an enemy; assert `bro.m.FunFacts.m.Stats.Kills.len() == 1` and the enemy's
  record names the bro.

### 13. "Incompatibility with Legends" — fixed in 1.0.1 (details unknown)
- Sources: Nexus bug https://www.nexusmods.com/battlebrothers/mods/764?tab=bugs&issue_id=918766 (Zayode, 2025-03-03,
  status Fixed); Legends help https://discord.com/channels/547043336465154049/1346090426565922846/1346216010209955844
  (same user; author: "This was fixed in Fun Facts 1.0.1"). Log not preserved. 1.0.1 fixes: Deaths/Injuries/
  InjuriesDealt facts, adding to an existing campaign (`a24c041`), Vala bug (`d5b4664`).
- Repro idea: Legends campaign started without Fun Facts, then load with it (mid-save install); fight one battle with a
  Vala in the roster; open roster tooltips. Assert no errors.

## Not bugs / feature requests (skipped)
Wording ("struck down", "Inflicted"), TCO not fun, ideas (kills by type, tiles travelled, drugs, donkeys, hexe charm
count, total cost, selectable stats, lifetime bonuses); a russian translated build using stdlib (Legends 2024-09);
Hackflow's Perks bug masked by Fun Facts' `onAdded` (that was a Perks bug).

## Repro status

Headless scenario tests in this dir (2026-11-12, working tree; details and commands in
`FOUND_BUGS.md`, "Known bugs: reproduction status"):

- #1 — fixed in the working tree: `reforged::KB1` passes; with the 1.0.3 zip it fails with the
  users' stack (`nested_tooltips.nut:28` ← `fun_facts.nut:102` ← `master_no_use_apprentice_event.nut:64`).
- #2 — reproduced, cause confirmed: `scenario_mode::KB2` fails with `the index 'Statistics'
  does not exist` from `getBattleId`; the killed enemy stays alive, on the map, in the turn order.
- #3 — reproduced: `known_bugs::KB3`, `the index 'ClassName' does not exist` at `fun_facts.nut:259`.
- #4 — reproduced, hypothesis confirmed: `known_bugs::KB4`, the user's message on every load.
- #5 — not reproduced in English or Russian (Rosetta 0.4.0): needs a modified build.
- #6 — reproduced: `tale_no_stdlib.nut` fails at boot, `::std` at `mod_fun_facts.nut:16`.
- #7 — packed history grows linearly (~45 bytes a battle with 2 kills); no bug found in the mod.
- #8 — not tested (Career Stats not installed).
- #9 — reproduced in English and Russian (`tooltips::KB9`, `rosetta::KB9`).
- 2026-11-13: #2, #3, #4, #6, #9 fixed in the working tree; their tests pass in every env they run in
  (`FOUND_BUGS.md`, "Status after fixes (2026-11-13)").
- #10, #11, #12, #13 — regression tests pass (#12 can't fail on Reforged 0.8.18, which no
  longer passes a null killer; #13 simulated, no Legends).

### With real third-party mods (2026-11-12)

Legends 19.4.23, Reforged 0.9.3 + Hardened 1.26.3, Career Stats 1.0.2; details in `FOUND_BUGS.md`.

1. #1 — regression passes on Reforged 0.9.3 + Hardened (`hardened_bugs::KB1`); released 1.0.3 still crashes there
   with the users' stack, and a save load afterwards fails too (nesting left on).
2. #7 / #10 — not reproduced on Legends: long histories and 100 fallen round-trip (`legends_bugs::KB7/KB10`).
3. #8 — Squirrel side fine (`career_stats::KB8`, 2 tests); the conflict is in JS: both mods `bindTooltip` the same
   obituary row and vanilla's `bindToElement` unbinds the earlier one, so one mod's graveyard tooltip is lost
   (code-confirmed, untestable headless).
4. #11, #12 — regressions pass on Reforged 0.9.3 + Hardened (`hardened_bugs`).
5. #13 — regression passes on real Legends (`legends_bugs::KB13`, 2 tests); the 1.0.0 zip fails with the users' stack.

## Discord deep search (2026-11-12)

Checked: all hits of "fun facts", "fun_facts", "funfacts", "hackflow" mentions of Fun Facts on Legends, Reforged and
BB Modding (39 messages after 2023-09, ~12 contexts read, 7 logs downloaded to
`service/tools/discord_deep/discord_logs/`). No new Fun Facts bugs; five existing entries gain evidence.

### Extends existing

- **#13 "Incompatibility with Legends" — now with the log; fixed in 1.0.1 (`d5b4664`).** The log the reporter posted
  in the Legends help thread, https://discord.com/channels/547043336465154049/1346090426565922846/1346215317344358482
  (zayode, 2025-03-03, Fun Facts 1.0.0, Legends), is saved at `discord_logs/legends_1346215317344358482_log.html`.
  The only script error:
  ```
  Script Error: the index 'Start' does not exist
    at onCombatEnd -> scripts/mods/fun_facts/fun_facts.nut : 158
    at -> fun_facts/player.nut : 30                         (onBeforeCombatResult hook)
    at -> mod_legends/hooks/states/tactical_state.nut : 479 (alive bros loop, _isVictory = True)
    at -> mod_legends/hooks/states/tactical_state.nut : 193
    at -> fun_facts/tactical_state.nut : 21
    at onUpdate -> scripts/states/tactical_state.nut : 443
  ```
  In 1.0.0, `onCombatEnd` reads `this.m.TmpCombat.Start`, but `TmpCombat` is null when `onCombatStart` was never
  called for that bro. Legends calls `onBeforeCombatResult` on every alive roster bro (a Vala, or a bro who was added
  mid-battle). `d5b4664` "ff: fix Vala bug" (shipped in 1.0.1) added the fallback
  `local tmpCombat = this.m.TmpCombat || {Start = ...}`, now at
  `fun_facts/scripts/mods/fun_facts/fun_facts.nut:162-170`. Repro idea: a Legends-like battle end where one roster bro
  skipped `onCombatStart` (set `bro.m.FunFacts.m.TmpCombat = null`, then call `bro.onBeforeCombatResult()` /
  `m.FunFacts.onCombatEnd(bro)`). Assert no error, `Battles` is incremented, and the record has the default `Start`.

- **#10 Save corrupted on a long campaign — another log, Legends, Fun Facts 0.5.0 (russian-translated build).**
  https://discord.com/channels/547043336465154049/1288018399515115531/1288018399515115531 (txkpbica, 2024-09-24, "latest
  save corrupted, older ones load"). Hackflow's reply (…/1288045993698394216) blamed the modified FF build and suggested
  removing it or using the Nexus version. Log: `discord_logs/legends_1288018399515115531_log.html`:
  ```
  Script Error: Broken pack string
    at unpack -> stdlib/packer.nut : 76
    at unpack -> scripts/mods/fun_facts/fun_facts.nut : 346
    at -> fun_facts/statistics_manager.nut : 32     (onDeserialize, fallen i = 0)
    at onDeserialize -> scripts/states/world_state.nut : 4077
  [critical] Corrupt data before FoW. This means that your save is corrupt ...
  ```
  This is a fallen bro's packed FunFacts that didn't survive the flag round-trip, the same class as #10. It is fixed in
  1.0.0 by `eab7a0c` (chunked `::std.Flags.pack` for fallen bros, plus a `try/catch` that logs
  "Failed to load fallen FunFacts" instead of aborting the load, now at `fun_facts/fun_facts/statistics_manager.nut:32-43`).
  This also links #4: on 1.0.0+ the same broken data produces #4's caught error rather than a corrupt save.

- **#6 Missing stdlib gives a cryptic error — 2 more logs, and a Reforged dev report; still open.**
  https://discord.com/channels/1006908336991645757/1568349721926311988/1568411733716901930 (Darxo, 2026-11-06): "Funfacts
  uses features from stdlib before it registers via MSU in order to register its mod requirements … error happens in
  line 16 and you only queue your mod (and define requirements) in line 42". Hackflow
  (…/1568414752315809885): "can wrap uses, but not really a bug". Logs: `discord_logs/reforged_1568349721926311988_log.html`
  (FF 1.0.3) and `discord_logs/reforged_1489560524818743298_log.html` (FF 0.5.0,
  https://discord.com/channels/1006908336991645757/1489560524818743298/1489560524818743298, 2026-04-03), both:
  ```
  Script Error: the index 'std' does not exist
    at main -> scripts/!mods_preload/mod_fun_facts.nut : 16
  Script Error: the index 'std' does not exist
    at main -> scripts/mods/fun_facts/fun_facts.nut : 1
  ```
  The second report's freeze turned out to be unrelated (it persisted with stdlib installed, see
  `discord_logs/reforged_1489564376838180924_log.html`, no FF error).

- **#8 Possible conflict with Career Stats — one more user claim, unconfirmed.**
  https://discord.com/channels/1006908336991645757/1036777416309358643/1500404083776032768 (devoratrix_lux, 2026-05-03,
  Reforged): Career Stats panel doesn't show with Fun Facts 1.0.3 installed ("they don't work together"). Log
  `discord_logs/reforged_1500358165550731335_log.html` has no Fun Facts or Career Stats errors (only the arquebus mod's
  `AddGenericSkill` and missing LushkensLoneWolf UI files). Both mods add rows to the bro tooltip. Repro idea is as
  in #8.

- **#12 Kills not tracked in Reforged (null `_killer`) — upstream side.** Reforged reverted the loot change in 0.6.15
  (Darxo https://discord.com/channels/1006908336991645757/1327651957657305099/1339237971123114079, Lord Midas "Fixed in
  0.6.15" …/1341701424190591007, 2025-02-19). Lord Midas (…/1332229903285882911) said Reforged also set `_killer = this`
  when the player's faction dealt <50% of the damage, which would record a self-kill. FF filters self-kills
  (`fun_facts.nut` ~line 67 at `21a5f38`).

### Skipped
- "Fun Facts doesn't go well with Lifetime Stats" (sss1897, Reforged #general 2025-11-21,
  https://discord.com/channels/1006908336991645757/1006908337981509725/1441232572729397381): hearsay, no details.
- Legends "fun facts is not compatible afair" (2024-11-14, …/616566479306883073/1306599949672251423): the log
  (`discord_logs/legends_1306598679972413460_log.html`) shows errors from a specialist-skills mod (`SpecialistStaffTree` …).
  FF frames only pass through (`fun_facts/player.nut : 96` onDeserialize).
- Legends enemy-turn freeze thread 1428830061212991508: the cause was "Craftable Siege Weapons", and the freeze stayed
  after FF was removed.
- Reforged "maybe remove fun facts" (2025-04-07): the cause was Modern Hooks queueing / an MSU update.
- FF icon size in tooltips, solved with CSS by hackflow (BB Modding 2025-01-17): not a user report.


### Log sweep addendum (300 newest Discord logs)
- #6 (missing stdlib): two more Reforged logs with `the index 'std' does not exist` at
  `scripts/!mods_preload/mod_fun_facts.nut : 16` — `discord_logs/reforged_1529687086964277269_log.html`
  (https://discord.com/channels/1006908336991645757/1529687086964277269/1529687086964277269, 2026-07-22) and
  `discord_logs/reforged_1525567185580196161_log.html`
  (https://discord.com/channels/1006908336991645757/1523224802016366714/1525567185580196161, 2026-07-11).

## Repro status (Discord section)

No new entries. #6 stays reproduced by `tale_no_stdlib.nut`; #8 (Career Stats) and #13 (Legends, fixed in 1.0.1)
not tested: Career Stats and Legends aren't available.
