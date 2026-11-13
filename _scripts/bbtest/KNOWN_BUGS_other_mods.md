# Known user-reported bugs — the rest of hackflow's mods

Compiled 2026-11-11 from: a fresh full crawl of the Nexus Bugs and Posts tabs of every hackflow mod
(`bugs.jsonl`/`posts.jsonl` in the session scratchpad, cross-checked with `service/data/nexus_hackflow.jsonl`),
per-mod Discord threads (`service/data/discord_reforged_mods.jsonl`, `discord_legends_bbmodding_mods.jsonl`),
Discord searches (`discord_search.jsonl`, `discord_help_hidden.jsonl`, `norm/*.jsonl`), the user logs in
`service/data/logs/**` (grepped for stack frames inside each mod's dirs), and the fix history (CHANGELOGs, tags with
their dates, `FIX.md`, `TO_RELEASE.md`). Excluded: nicknames, fun_facts, autopilot (catalogued elsewhere), XBE and
Rosetta (not in `mods/`). Pure feature requests, install errors (missing stdlib/Modern Hooks, mod unzipped) and
"another mod is the culprit" threads are skipped or get one line. Links: Nexus posts
`https://www.nexusmods.com/battlebrothers/mods/<mod>?tab=posts&jump_to_comment=<id>`, Nexus bugs
`...?tab=bugs&issue_id=<id>`; Discord `https://discord.com/channels/<guild>/<thread>/<msg>`, guilds: Legends
547043336465154049, Reforged 1006908336991645757, BB Modding 965324395851694140. Entries from `discord_search.jsonl`
or `discord_help_hidden.jsonl` have no channel id in the data, so they are cited by file + message id.
"Fixed in X" is inferred from CHANGELOG entries plus tag dates against report dates; where the match is not
explicit it says so. Code paths are relative to `mods/`.

---

## camps_and_artifacts (Camps and Artifacts Reworked, Nexus 678)

1. **Artifact weapon with negative head-hit chance breaks MSU serialization** — status: open (Hackflow said MSU
   tightened checks broke his fix; LordMidas said he would handle it on the Reforged side — not verified)
   - Source: `discord_help_hidden.jsonl` msg 1455202594757546034 (Reforged #general, 2025-12-29); logs
     `service/data/logs/Reforged/1454778333266182238/log.html`, `.../1455064633231802541/`, `.../1455202594757546034/`
     (32 occurrences overall)
   - Setup: Reforged (+ Hardened), C&A 3.5.2, MSU 1.7+, mod_persistent_characters or anything using MSU SerDe emulator
   - Symptoms: `The value of the variable '-25' is not acceptable` at `writeU8 -> msu/systems/serialization/serde_emulator.nut : 121`
     `<- onSerialize -> scripts/items/weapons/artifact/artifact_weapon.nut : 127`; crash when a Fallen Hero is hit by Bone Breaker.
   - Suspected code: `camps_and_artifacts/scripts/items/weapons/artifact/artifact_weapon.nut:127`
     (`_out.writeU8(this.m.ChanceToHitHead)`); the 3.5.1 fix only remaps on deserialize (same file, ~line 160).
   - Repro: Reforged on; create any artifact weapon whose base `ChanceToHitHead` is negative under Reforged (fencing
     sword / southern swords, -25), serialize it through `::MSU.Class.SerDeEmulator` (or the game's own writer) → assert
     no error, and that a save/load round-trip keeps `ChanceToHitHead == -25`.

2. **`the index 'ca_getCamps' does not exist` spam from build_citystate_camp_action** — status: open/unclear
   - Source: Discord Reforged thread https://discord.com/channels/1006908336991645757/1180373120415178854/1414419759893708982
     (2025-09-08, "southern village contract doesn't appear at all"),
     https://discord.com/channels/1006908336991645757/1180373120415178854/1441517239894544615,
     https://discord.com/channels/1006908336991645757/1180373120415178854/1443604724543787108; Reforged dev replies
     in `discord_search.jsonl` msgs 1447675423852068874, 1426059736226205788, 1409281521273274378; logs
     `logs/Reforged/1441517239894544615/`, `1443604724543787108/`, `1447657982493196309/` (hundreds of lines each)
   - Setup: Reforged + **Hardened** in every log seen, C&A 3.5.1 and 3.5.2; only the city-state action fails, never the noble one.
   - Symptoms: `the index 'ca_getCamps' does not exist` at `onUpdate -> scripts/factions/actions/build_citystate_camp_action.nut : 12`
     every faction update.
   - Suspected code: `camps_and_artifacts/camps_and_artifacts/factions/faction.nut:1-48` (hook applied via
     `mods_hookExactClass("factions/city_state_faction")` and patching `cls[cls.SuperName]`) together with
     `camps_and_artifacts/camps_and_artifacts/config/faction_traits.nut:4` (action pushed to every faction with the
     OrientalCityState trait). Some faction with that trait evidently isn't a hooked `city_state_faction` instance under
     Hardened — not confirmed.
   - Repro: vanilla+Reforged (Hardened if available) new campaign with Desert DLC; iterate `World.FactionManager` factions
     that have `build_citystate_camp_action`, assert `"ca_getCamps" in f`; run `faction.update()` and assert no error.
     Also run it after a save/load.

3. **Battle maps sometimes generate as the arena floor → crash/infinite loading entering a C&A location** — status: open, unclear (Reforged devs call it a generic issue with mods that add locations)
   - Source: https://discord.com/channels/1006908336991645757/1180373120415178854/1253396125524955156 (2024-06-20, log
     `logs/Reforged/1253396125524955156/log.html`), .../1489654728131608680 (2026-04-03), .../1300450498653978698
     (fortress not destroyed after win); `discord_search.jsonl` msg 1356535692657950921 (Reforged dev: known random crash entering locations with C&A or Crock Pot)
   - Setup: Reforged; undead necropolis / artifact camps. A reload usually avoids it.
   - Symptoms: `the index 'setFlipped' does not exist` at `fill -> scripts/mapgen/templates/tactical/locations/tactical_arena_floor.nut : 101`
     `<- initMap -> scripts/states/tactical_state.nut`; or an endless loading screen.
   - Suspected code: not located. C&A locations without a `CombatLocation.Template[0]`:
     `camps_and_artifacts/scripts/entity/world/locations/undead_damned_city_location.nut`, `goblin_warrens_location.nut`,
     `bandit_usurper_location.nut`, `barbarian_sacred_grove_location.nut` (vanilla treats null as "no template", so this is a hint, not proof).
   - Repro: spawn each C&A location type, start combat on it N times with different seeds (`World.State.enterLocation`/
     `startScriptedCombat` with `LocationTemplate = loc.getCombatLocation()`), assert that the map template is not `tactical.arena_floor` and `initMap` throws nothing.

4. **Barbarian Thrall using Barbarian Fury crashes the game** — status: open, unclear (no full log; only the tail was posted)
   - Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/678?tab=bugs&issue_id=1033231 (2026-01-19)
   - Setup: Legends + C&A 3.5.1/3.5.2 only; the save is unplayable without C&A.
   - Symptoms: `Barbarian Chosen uses skill Barbarian Fury` → `Core A critical exception occured` with the script stack
     `think -> scripts/ai/tactical/agent.nut : 174 <- onProcessAI -> scripts/states/tactical_state.nut : 1456`.
   - Suspected code: not located (native crash; Barbarian Fury swaps positions — maybe an oversized C&A camp party / artifact item on a barbarian under Legends).
   - Repro: Legends; battle vs a C&A barbarian camp (`barbarian_sacred_grove_location`) with a thrall having `barbarian_fury_skill`; run the AI for several rounds and assert no crash. Low priority unless the engine runs Legends.

5. **Camp tooltips disappear when the revealed camp is out of view range** — status: open (author: "Known issue")
   - Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/678?tab=bugs&issue_id=860914 (3.4)
   - Suspected code: not located (vanilla behaviour for friendly/allied locations).
   - Repro: reveal a noble camp (`setDiscovered(true)`), move the party far away, call `getTooltip()` on the location → assert it lists troops as for other discovered lairs.

6. **Artifact shields keep vanilla durability under Reforged** — status: open (author acknowledged "will need to be updated")
   - Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/678?tab=posts&jump_to_comment=144655593 (2024-10-01)
   - Suspected code: `camps_and_artifacts/scripts/items/shields/artifact/*.nut` (hard-coded base stats).
   - Repro: Reforged on; compare `getConditionMax()` of each artifact shield with its base Reforged shield — assert it is not lower.

7. **Plain Handgonne shows as "Famed" with C&A installed (Legends, SSU)** — status: unclear, no reply
   - Source: https://discord.com/channels/547043336465154049/1167322754991800390/1341341539431092378 (2025-02-18)
   - Suspected code: not located (C&A adds `ItemType.Artifact` and hooks `items/item.getDescription`, `camps_and_artifacts/scripts/!mods_preload/mod_camps_and_artifacts.nut:61-72`).
   - Repro: create `scripts/items/weapons/oriental/handgonne`, assert `!isItemType(Named)` and the description has no "Famed".

8. **Ice arrows tooltip says "freeze", effect is Chilled** — status: unclear (cosmetic)
   - Source: https://discord.com/channels/1006908336991645757/1180373120415178854/1273624779231989894 (2024-08-15)
   - Repro: tooltip of the imbued freezing ammo vs the applied effect id (`effects.chilled`).

9. **Artifact armor +2 fatigue recovery stacked every battle** — status: fixed in 3.5.0 ("fixed stacking stamina regen")
   - Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/678?tab=bugs&issue_id=902060 (3.4);
     https://discord.com/channels/1006908336991645757/1180373120415178854/1296515050844192840
   - Repro (regression): give an armor with the fatigue-recovery roll, run 3 battles (or `onCombatStarted`/`onCombatFinished` x3), assert `FatigueRecoveryRate` bonus stays +2.

10. **Head-hit chance overflow (200%+ armor ignore / "200% chance to hit head")** — status: fixed in 3.5.1 (on deserialize; see #1 for the leftover)
    - Source: https://discord.com/channels/1006908336991645757/1180373120415178854/1273622454421553162
11. **Item Spawner / Origin Maker show no items: `the index 'Flags' does not exist`** — status: fixed in 3.4 (Item Spawner) and 3.5.2 (Origin Maker)
    - Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/678?tab=bugs&issue_id=767420; posts
      https://www.nexusmods.com/battlebrothers/mods/678?tab=posts&jump_to_comment=132535238 and ...=135512145
    - Error: `the index 'Flags' does not exist` at `scripts/!mods_preload/mod_camps_and_artifacts.nut : 27` — creating artifact items in the main menu, without `World`.
    - Repro (regression): with no world loaded, `::new()` every script in `scripts/items/**/artifact/` → assert no error.
12. **Noble/city-state camps spawned endlessly, blocking other camps** — status: fixed (Nexus bug status Fixed; 3.6.0 "spread camps out more")
    - Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/678?tab=bugs&issue_id=850446; https://discord.com/channels/1006908336991645757/1180373120415178854/1391729940831146044
13. **Legends 18.1.1 stuck at world generation** (stray `orc_fortress_location.cnut`, `the index 'Type' does not exist` at `camps_and_artifacts/factions/actions/build_orc_camp_action.nut : 40`) — status: fixed in 3.1
    - Source: https://discord.com/channels/547043336465154049/1167322754991800390/1168294391744581653
14. **3.1 regression requiring stdlib** (`the index 'std' does not exist` at `scripts/items/armor/artifact/artifact_armor.nut : 31`) — status: fixed in 3.2
    - Source: https://discord.com/channels/547043336465154049/1167322754991800390/1173993455232483328

Skipped: no artifacts (Tweaks and Fixes "See Named Items"), item loss after 200 days (out of memory), errors from Fantasy/nggh, duplicate zip in data, Legends goblin camps not counting for the legendary location, balance threads.

---

## retinue_ups (Retinue Promotions, Nexus 681)

1. **Promotion survives loading an older save: cost and effects stay promoted** — status: open
   - Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/681?tab=bugs&issue_id=935478 (1.2.2, 2025-04-18)
   - Setup: vanilla; hire Trader (3500), promote (7000), load an earlier save without restarting the game.
   - Symptoms: the Trader's hiring cost shows 10500 and his tooltip lists the promoted effect, yet "Promote" is still offered. Restarting the game fixes it.
   - Suspected code: `retinue_ups/scripts/!mods_preload/mod_retinue_ups.nut:47-53` — `onDeserialize` only calls
     `ru_onPromote()` for flagged followers and never `ru_onDemote()` for the rest. Vanilla `retinue_manager.onDeserialize`
     → `clear()` resets only `Slots`, so the follower objects (with `m.ru_base`, raised `m.Cost`, extended `m.Effects`) survive the load.
   - Repro: new campaign (Desert DLC on); hire `follower.trader`; save A; `World.Retinue.ru_promote(trader)`; load A in the
     same session → assert `trader.m.Cost == 3500`, `!("ru_base" in trader.m)`, `Effects` have no promotion line.

2. **Promotions revert after loading a save (Legends 18.2+, More Retinue Slots, "Pandora's Hobby" recruiter)** — status: open, unclear (Legends reworked the retinue; the author does not support it)
   - Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/681?tab=posts&jump_to_comment=134630420 (2024-03-10)
     and the reply ...=153879951 (2025-05-10, test save + log on mediafire); `discord_search.jsonl` msg 1503024067035267252 (Reforged #submods-chat, 2026-05-10)
   - Symptoms: works within a session; after quitting to the menu and loading, promoted effects (e.g. cheaper tryouts) are gone.
   - Suspected code: same `onDeserialize` hook (`mod_retinue_ups.nut:47`); depends on `World.Flags` being deserialized before
     `World.Retinue` (true in vanilla `world_state.onDeserialize`); a mod that reorders this or rebuilds followers loses the promotion.
   - Repro: promote the Recruiter, save, restart the world state (fresh `world_state`), load → assert
     `World.Retinue.ru_isPromoted(recruiter)` and the tryout cost multiplier still applies. Also with More Retinue Slots if available.

3. **Cannot replace an existing retinue member: `the index 'ru_base' does not exist`** — status: fixed in 1.2.2 ("fixed removing a retinue member")
   - Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/681?tab=bugs&issue_id=773194 (0.7);
     https://discord.com/channels/1006908336991645757/1325799128982360140/1349019509616410694 (log `logs/Reforged/1349019509616410694/log.html`)
   - Error: `the index 'ru_base' does not exist` at `scripts/!mods_preload/mod_retinue_ups.nut : 123 <- : 47 <- : 22 <- onHireFollower`.
   - Repro (regression): hire a non-promotable follower into slot 3 (blacksmith), then hire another into the same slot → assert no error and the new follower is in the slot.
4. **Battles never end (camera pans out, no loot screen)** — status: fixed in 0.7 (stray `::std.Debug.log()`)
   - Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/681?tab=bugs&issue_id=758595

Skipped: BB-Edit save editor breaking (Nexus ...=158564878, external tool), Legends "index 'Dude'" (Legends unsupported), "throwing errors" with a modified copy (reinstall fixed).

---

## elite_few (Elite Few — Master Bros, Nexus 665)

1. **Hardened: negotiating contract pay leads to an empty dialog, soft lock** — status: open
   - Source: `discord_search.jsonl` msgs 1509702330881147011 (2026-05-28) and 1460221863920668756 (2026-01-12), Reforged "Hardened" thread
   - Setup: Reforged + Hardened + Elite Few 2.5.0.
   - Suspected code: `elite_few/scripts/!mods_preload/z_elite_few.nut:55-77` — `markInScreen` wraps `setScreen` in anonymous
     `concat_call` functions. Hardened's `contract.setScreen` hook (`3rdparty/Hardened/mod_hardened/hooks/contracts/contract.nut:75`)
     checks `::Hardened.getFunctionCaller() != "processInput"` and otherwise forces `_restartIfAlreadyActive = false`; behind
     Elite Few's wrapper the caller is never `processInput`, so re-entering the same negotiation screen doesn't restart it. The wrapper also drops `setScreen`'s return value. Strong hypothesis, not tested.
   - Repro (engine-agnostic): hook `contracts/contract.setScreen` innermost with a probe recording `getstackinfos(2).func`;
     call `contract.processInput(option)` that calls `setScreen` → assert the recorded caller is `processInput`. With Hardened: negotiate twice on the same screen, assert `ActiveScreen` has options.

2. **Exception inside an event/contract screen leaves every later bro rolled as an "event bro"** — status: not user-reported as such, open (from code + logs)
   - Source: logs show `inEventOrContract = True` in frames when other mods throw inside `setScreen`
     (`logs/Reforged/1374197549677936663/log.html`, `logs/Legends/1383870213740695573/log.html`); possibly related to
     Nexus post https://www.nexusmods.com/battlebrothers/mods/665?tab=posts&jump_to_comment=147597215 (Legends 19: "brothers get master trait and full stat")
   - Suspected code: `elite_few/scripts/!mods_preload/z_elite_few.nut:74-77` — `inEventOrContract = true; call.super(); inEventOrContract = false;` without try/finally.
   - Repro: set `eventAll = true`; fire an event whose `start()` throws (a mock); then generate town recruits → assert none got `trait.master` because of `eventAll` (i.e. `inEventOrContract` is false again).

3. **Endless loading on Reforged while rolling a master for `MSU_dummy_player_character`** — status: open, unclear (workaround: select mode "none")
   - Source: `discord_search.jsonl` msg 1391784028390035586 (Reforged #technical-help, 2025-07-07)
   - Suspected code: `elite_few/scripts/!mods_preload/z_elite_few.nut:178-200` (`buildAttributes` wrap runs `rollMaster` and adds `master_trait` to MSU's dummy player).
   - Repro: Reforged + MSU; with selectMode "all", trigger MSU's dummy player creation (main menu → new campaign) → assert it finishes and the dummy has no `trait.master`.

4. **SSU: city view / recruit list doesn't open** — status: unclear, no reply
   - Source: https://discord.com/channels/547043336465154049/1179715231803514910/1339048585873985588 (2025-02-12)
5. **Legends 19.0: elite bros get only 1 talent / odd stats** — status: probably fixed in 2.5.0 (Legends 19 support, 2025-04-28); unverified
   - Source: Nexus posts https://www.nexusmods.com/battlebrothers/mods/665?tab=posts&jump_to_comment=147750068, ...=147597215
6. **Tutorial contract not completing (return to village)** — status: fixed in 2.4.1
   - Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/665?tab=posts&jump_to_comment=131992190; https://discord.com/channels/547043336465154049/1179715231803514910/1216358460325888030
   - Repro (regression): tutorial scenario, finish the first fight, enter the village → assert the contract advances to the next screen.
7. **"Exclude dubious traits" ignored for event bros (Double Tongued)** — status: fixed in 2.4.1
   - Source: https://discord.com/channels/547043336465154049/1179715231803514910/1230523083971100725, ...1195757016749191349

Skipped: Kingsguard event broken (Nexus bug 760647, actually Starting Perks by Background, see background_perks #2), Clever Recruiter errors passing through Elite Few's wrapper (`logs/Legends/1370364408278286408/`), master bros' wage giving them away (changed in 2.5.0).

---

## bro_studio (Bro Studio, Nexus 677)

1. **"Blue vial" gives a full-stat level-up to a veteran** — status: open, unclear (no reply; which item is meant is unknown — maybe Potion of Knowledge or a Legends/Reforged potion)
   - Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/677?tab=posts&jump_to_comment=166722649 (2026-03-13)
   - Suspected code: `bro_studio/bro_studio/attrs.nut:71-95` — `effectiveLevel = Level - LevelUps + 1` decides veteran vs full rolls;
     XP gained in bulk (several pending LevelUps) or a level reset may land a veteran in the `<= attrsVeteran` branch.
   - Repro: bro at level 12 with default settings (attrsVeteran 11); give XP worth 2 levels at once (`addXP` / Potion of Knowledge
     effect), then call `fillAttributeLevelUpValues` per level-up → assert the rolls are veteran (all 1s, or Veteran Boost values).

2. **Hardened: critical exception, recruit spawned with a Bro Studio permanent injury** — status: unclear (helper's guess)
   - Source: `discord_search.jsonl` msg 1520698258995810314 (Reforged "Hardened" thread, 2026-06-28)
   - Suspected code: `bro_studio/bro_studio/injuries.nut` (1.3.0 "permanent injuries on new bros").
   - Repro: Reforged, injuries option on, generate 200 recruits → assert no error; hire one and run a battle.

3. **Clumsy added as a positive trait** — status: unclear (author asked whether it was there before hire; no follow-up)
   - Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/677?tab=posts&jump_to_comment=130066139 (2023-11-05)
   - Repro: roll positive traits 1000 times (`bro_studio/bro_studio/traits.nut`) → assert `trait.clumsy` never appears.

4. **Modern Hooks error: wrapping `setStartValuesEx` with the wrong param count (Legends)** — status: fixed in 1.3.1
   - Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/677?tab=posts&jump_to_comment=169368068 (2026-05-08); https://discord.com/channels/547043336465154049/1162309320906653776/1502344256679972874
5. **Talents ignored for bought bros (only starting bros affected)** — status: fixed (load-order fix shipped as `bro_studio/mod_bro_studio_1.2.0_FIX1.zip`; presumably in 1.3.0)
   - Source: https://discord.com/channels/547043336465154049/1162309320906653776/1360951922735059046
6. **Talent min/max ignored, everyone gets the max** — status: fixed in 1.0.1
   - Source: https://discord.com/channels/547043336465154049/1162309320906653776/1163402792174620732
   - Repro (regression): talentsMin=3, talentsMax=5, chance 50 → 500 recruits, assert counts of 3, 4 and 5 are all non-zero.
7. **Veteran level for perks not applied** — status: fixed in 1.0.2
   - Source: https://discord.com/channels/547043336465154049/1162309320906653776/1165263373437522031

Skipped: missing stdlib / Modern Hooks (many), Veteran Level Limit mod overlap (became a setting), extra perks from Legends/other mods, PoV/Magic Concept/More Ammos culprits, "recruits disappear after load" (Nexus bug 946648, More Ammos), "the index '6' does not exist" at `mod_bro_studio.nut : 96` in `logs/Legends/1439171393261535233/` (thrown inside the Legends Necro Lorekeeper scenario, pass-through).

---

## necro (Proper Necromancer, Nexus 775)

1. **Possess can target enemy undead (buffs an enemy the player can't control)** — status: open (acknowledged, no fix)
   - Source: https://discord.com/channels/1006908336991645757/1326065228542120016/1388799386359959572 (2025-06-29); also Nexus post
     https://www.nexusmods.com/battlebrothers/mods/775?tab=posts&jump_to_comment=144578448
   - Suspected code: `necro/scripts/!mods_preload/mod_necro.nut:227-235` hooks `possess_undead_skill` but keeps vanilla
     `onVerifyTarget`, which only checks the `zombie_minion` flag, not the faction.
   - Repro: necro bro with `perk.necro.possess`, an enemy zombie (`zombie_minion` flag) adjacent → assert
     `possess_undead_skill.onVerifyTarget(myTile, enemyTile) == false`; a zombie raised by the player → true.

2. **Mind Meld doesn't copy stackable perks (Fast Adaptation, Unstoppable, …)** — status: open (acknowledged)
   - Source: same message as #1
   - Suspected code: `necro/scripts/skills/perks/perk_necro_mind_meld.nut`.
   - Repro: necro with Fast Adaptation + Mind Meld, raise a zombie → assert the zombie has `perk.fast_adaption`.

3. **Can't raise a corpse inside an enemy zone of control (Reforged)** — status: unclear (maybe by design)
   - Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/775?tab=posts&jump_to_comment=144578448

4. **Crash on the inventory screen after hiring 22 bros in the Necro origin** — status: fixed in 0.4.2
   - Source: https://discord.com/channels/1006908336991645757/1326065228542120016/1376542735691026492
   - Repro (regression): Necro origin, add bros up to 22, open the formation/inventory (`World.Assets.updateFormation`) → assert no error and 16 in battle are allowed.
5. **Possess stuck after a battle ended while possessing** — status: fixed in 0.2.1
   - Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/775?tab=bugs&issue_id=864946
   - Repro (regression): possess a zombie, end the battle, start a new one → assert `possess_undead_skill.isUsable()`.
6. **Loot lost on double raise / arena gave raised loot** — status: fixed in 0.5.1 (CHANGELOG only, report not found)

Skipped: "battle doesn't end with a zombie after Run Them Down" (Nexus bug 1071967, mod_deathlog), Better Fencing and Deathgun conflicts (no log), Legends unsupported, Hardened "breaks perks" (no log).

---

## hackflows_perks (Hackflow's Perks, Nexus 673)

1. **Stabilized can't be picked: the perk point isn't spent** — status: open, unclear (author suspects a mod interaction)
   - Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/673?tab=posts&jump_to_comment=174848835 (2026-09-02, version unknown)
   - Suspected code: `hackflows_perks/scripts/skills/perks/perk_hackflows_stabilized.nut` (any throw in `create`/`onAdded`/`onUpdate`
     makes `unlockPerk` fail); placed by `hackflows_perks/scripts/config/z_hackflows_perks.nut:79`.
   - Repro: vanilla (no Reforged), bro with a perk point, `player.unlockPerk("perk.hackflows.stabilized")` naked, with medium
     armor, with heavy armor → assert `hasSkill`, `PerkPoints` decreased, and no script error.

2. **Overwrites JC Sato's Balance changes to Nimble / Lone Wolf** — status: open (Nexus "New issue"; author: these perks aren't touched)
   - Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/673?tab=bugs&issue_id=1063408 (1.6.1)
   - Suspected code: `hackflows_perks/scripts/config/z_hackflows_perks.nut:1-10` (`addPerk` inserts into `::Const.Perks.Perks` rows;
     if Sato patches perk defs by row/index or rebuilds `LookupMap` earlier, its changes are lost) — not confirmed.
   - Repro: `hackflows_perks/scenarios/sato.nut` (Sato's Balance Mod 2.3.1, `mods/mod_sato_balance-2.3.1.zip`; 1.4.1 in `3rdparty/` didn't patch Nimble): HP-KB2 in its FOUND_BUGS.

3. **Crash under vanilla (no Reforged): `the index 'perk.rf_promised_potential' does not exist`** — status: fixed in 1.6.3 ("fixed the mod not working under vanilla"; 1.6.2 also says "fixed occasional crash")
   - Source: Nexus posts https://www.nexusmods.com/battlebrothers/mods/673?tab=posts&jump_to_comment=166860625 (2026-03-16), ...=173892969 (2026-08-15)
   - Repro (regression): load without Reforged → assert no script error during queue and `perk.hackflows.*` exist in `Const.Perks.LookupMap`.
4. **`the index 'onAdded' does not exist` after upgrading 1.5 → 1.6** — status: fixed in 1.6 FIXED1 / 1.6.1
   - Source: https://discord.com/channels/1006908336991645757/1281787683638874203/1380614340348088351 (log `logs/Reforged/1380614340348088351/log.html`, `scripts/hackflows_perks/potential.nut : 149`)

---

## perma (Hackflow's Permanent Injuries, Nexus 855)

1. **Weapon disappears when a bro gets Missing Hand (crossbow / 2H weapon / weapon swapped in battle)** — status: fixed in 2.0.3 and 2.0.4
   - Source: https://discord.com/channels/965324395851694140/1382737616876736623/1506585854695440485 (2026-05-20; error `Attempted to drop item, but no tile specified!`),
     https://discord.com/channels/965324395851694140/1382737616876736623/1534972867555360941 (2026-08-06, swap to 1H then hand lost, "restore equipment" on)
   - Suspected code: `perma/perma_hackflow/hooks/` (Missing Hand item dropping) and the `restoreEquipment` wrap mentioned in `perma/scripts/!mods_preload/mod_perma_hackflow.nut:15`.
   - Repro (regression): bro with crossbow (and, separately, 2H sword in hand + 1H in bag, swapped mid-battle) gets `injury.missing_hand`
     while struck down / at battle end → assert the weapon ends up in the stash or loot, never vanishes; repeat with "restore equipment" on.
2. **`the index 'isNull' does not exist` in onShieldHit (non-WeakTableRef attacker)** — status: fixed in 2.0.2
   - Source: `discord_search.jsonl` msg 1499435077422284922 (Reforged #bugs), log `logs/Reforged/1499435077422284922/log.html` (perma 2.0.1, `mod_perma_hackflow.nut : 31` via Lunge)
   - Repro (regression): an attacker with Lunge misses a shield bearer → assert no error.

Unclear, likely not ours: MSU "Tried to read data beyond … Deserialization Emulator" lines with perma 2.0.2 + Legacy (`discord_help_hidden.jsonl` msg 1510021391536230420, logs `logs/Reforged/1510021391536230420/`); the author says PI doesn't serialize. Missing Hand still double-grips: by design (Stub Bonus).

---

## AC (Accessory Companions fixed by hackflow, Nexus 1054)

1. **Tamed beasts have Reach 0 under Reforged** — status: open (in `mods/FIX.md`; author: "will look")
   - Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/1054?tab=posts&jump_to_comment=171760913 (2026-07-03)
   - Suspected code: `AC/scripts/companions/types/*.nut` / companion spawning: AC builds its own entities, so Reforged's per-enemy Reach setup never runs.
   - Repro: Reforged on; unleash a tamed wolf/unhold → assert `getCurrentProperties().Reach > 0`, equal to the Reforged enemy of the same type.

2. **Tamed Nachzehrer doesn't gain max HP when eating corpses (Hardened)** — status: unclear
   - Source: https://discord.com/channels/1006908336991645757/1520795288317595789/1532715656758169681 (2026-07-31)
   - Repro: companion ghoul uses Gruesome Feast → assert size grows and `getHitpointsMax()` grows like the enemy ghoul's.

3. **Tame does nothing (uses AP/fatigue) without stdlib** — status: fixed in 2.1
   - Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/1054?tab=bugs&issue_id=1098149; log `logs/Nexus/1098149/log.html`
     (`the index 'std' does not exist` at `scripts/companions/player/companions_tame.nut : 96`)
   - Repro (regression): without stdlib loaded, `companions_tame.getHitchance(target)` → assert a number, no error.

Skipped: old reports of tamed Alps crashing (from the original AC, unverified), "ACU 1.2.3" crashes on the Legends Discord (that's Legends' own AC build), the broken druid link on the description page.

---

## druid (Proper Druid, Nexus 1061)

1. **Summoned beasts stand idle, facing the wrong way, "both hostile and not"** — status: open (needs a log)
   - Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/1061?tab=bugs&issue_id=1102373 (0.5.1)
   - Suspected code: `druid/scripts/skills/actives/druid_summon_beast.nut:196-221` — enemy script spawned and switched to
     `Faction.PlayerAnimals`; sprite flipping relies on an `onFactionChanged` hook after `druid_Summoned`.
   - Repro: druid with summon in a battle vs bandits; use the skill → assert the beast's faction is `PlayerAnimals`, sprites
     flipped like player animals, and within 2 rounds it moves or attacks an enemy (AI agent acts).
2. **Crash when Starting Perks by Background is installed without More Backgrounds and Events** — status: fixed in 0.5.2
   - Source: https://discord.com/channels/1006908336991645757/1518597754505396384/1526141975596765304 (log `logs/Reforged/1526141975596765304/log.html`)
3. **`the index 'hackflows_druid' does not exist` in queue (load order)** — status: fixed in 0.5.1
   - Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/1061?tab=bugs&issue_id=1100338

Skipped: Legends unsupported, vague perk descriptions, a question about druids with the Necromancer origin (2026-11-03).

---

## immortal_warriors (Immortal Warriors, Nexus 763)

1. **Lone Wolf origin starts without the soul jars** — status: open, unclear (Legends, no log)
   - Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/763?tab=posts&jump_to_comment=155637604 (2025-06-17)
   - Suspected code: `immortal_warriors/scripts/!mods_preload/mod_immortal_warriors.nut:61-73` (`mods_hookBaseClass` on
     `starting_scenario.onSpawnAssets`; a scenario overriding `onSpawnAssets` without the base call may not be wrapped).
   - Repro: start each origin (vanilla Lone Wolf first, Legends if available) → assert the stash holds `number` (setting) items of `immortal_soul_jar`.
2. **Can't start: `Unable to open file "ui/mods/i_immortal_warriors_levelup_changes.js"`** — status: fixed in 0.2.1
   - Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/763?tab=posts&jump_to_comment=169450097
3. **Wrong include path in the second queue** — status: fixed in 0.1.1
   - Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/763?tab=bugs&issue_id=858760

---

## standout_enemies (Standout Enemies, Nexus 331)

1. **Hair and beard stay dark after Cursed wears off** — status: open (no reply)
   - Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/331?tab=posts&jump_to_comment=152498468 (2025-04-13)
   - Suspected code: `standout_enemies/scripts/skills/cursed_effect.nut:152-165` (`updateAppearance` sets hair/beard brightness
     0.1 and back to 1.0; with `IsRemovedAfterBattle` the after-battle removal may skip `onRemoved`, and the original brightness isn't saved).
   - Repro: bro hit by a Cursed enemy (`cursed_skill`), end the battle → assert sprites `hair`, `beard`, `head`, `body` have their pre-curse brightness/color; also after save/load.
2. **Not user-reported: `checkResist()` uses an undefined `actor`** — status: open (from code)
   - Suspected code: `standout_enemies/scripts/skills/cursed_effect.nut:116-125` — `actor` is never declared in `checkResist`,
     so a successful resist throws `the index 'actor' does not exist`.
   - Repro: target with `IsResistantToAnyStatuses = true` (vanilla `ijirok_potion_effect`), apply `cursed_effect` 20 times → assert no script error.
3. **Infinite loading entering an undead location without the DLC weapon `khopesh`** — status: fixed in 0.81
   - Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/331?tab=posts&jump_to_comment=125400768
4. **Infinite loading entering the arena / an orc fortress** — status: fixed in 0.33 / probably 0.51 (2020)
   - Source: Nexus posts https://www.nexusmods.com/battlebrothers/mods/331?tab=posts&jump_to_comment=87101113, ...=87193273

Skipped: "no standout enemies seen" (faction/day dependent, or stdlib missing per `logs/Nexus/1098149/`), True Nine Lives from Champion Beasts, balance threads.

---

## useful (Useful Things, Nexus 682)

1. **Two-handed flails lose Flail Mastery's −25% fatigue** — status: fixed in 0.7
   - Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/682?tab=bugs&issue_id=827912 (0.3); posts
     https://www.nexusmods.com/battlebrothers/mods/682?tab=posts&jump_to_comment=139999798, ...=149137853
   - Suspected code: `useful/` flail hooks (`hookFlailSkill` on `skills/actives/pound`, `thresh`).
   - Repro (regression): bro with `perk.mastery.flail` and an orc 2H flail → assert `pound` costs 15 and `thresh` 30 fatigue (vanilla 20/40 × 0.75); also with Modular Vanilla if present.

Skipped: net design questions.

---

## background_perks (Starting Perks by Background, Nexus 661)

1. **Stuck on the loading screen starting a new game (1.5.1, May 2025)** — status: unclear (log requested, none came; 2.6.1 shipped 2025-05-31)
   - Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/661?tab=posts&jump_to_comment=153580650
   - Repro: start each vanilla origin with the mod → assert `startNewCampaign` completes and starting bros got their perks.
2. **`setStartValuesEx()` called with extra args breaks events under Legends (Kingsguard cripple event shows code, headless bro, soft lock)** — status: fixed in 2.4
   - Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/665?tab=bugs&issue_id=760647 (filed against Elite Few; isolated to this mod)
   - Repro (regression): fire `event.kings_guard_joins` (vanilla id) → assert no error and the new bro has a head sprite.
3. **Legends: endless map generation for some origins (beggar, berserker)** — status: open, won't fix (Legends unsupported)
   - Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/661?tab=posts&jump_to_comment=126520095

Skipped: perk-point oddities from other mods, chance tweak questions; `mod_background_perks.nut : 112` in `logs/Reforged/1547359680429301840/` is a Reforged error passing through.

---

## Others with only unclear reports

- **challenges (1010)** — "can't level up bros, no button" with Legends, no log:
  https://discord.com/channels/547043336465154049/1501802775531753472/1543644219015430186 (2026-08-30). Repro: Legends + Challenges, open a level-up → assert the perk/attribute UI data has the buttons. Unclear.
- **mod_beast_loot (660)** — "doesn't work in latest version or vanilla", no log: Nexus https://www.nexusmods.com/battlebrothers/mods/660?tab=posts&jump_to_comment=152509758; Legends staff "remove beast loot" for a new-game crash: `discord_search.jsonl` msg 1397820320756531210. Unclear.
- **mod_vap (648, dead)** — game freezes at "run them down / it's over" when enemies flee: Nexus bug https://www.nexusmods.com/battlebrothers/mods/648?tab=bugs&issue_id=710967 (1.8, no log); 2.1 vanished from MSU settings: Nexus https://www.nexusmods.com/battlebrothers/mods/648?tab=posts&jump_to_comment=133098317. Unclear, superseded by Bro Studio.

## No known bugs

cheap_meat, heal_repair_fix (item-loss reports were vanilla), more_blood (only a duplicate install), renamer, events_delayed_fix
(the `mod_events_delayed_fix.nut : 22/64` frames in Legends logs come from Legends' own bundled copy `events_delayed_fix_legends`),
fixes, fix_reforged, random_perk, stupid_game, translations.

---

## Repro status (headless scenario tests, 2026-11-12)

Suites in `mods/<mod>/scenarios/`, overview with commands in `OTHER_MODS_RESULTS.md`. "Reproduced"
= a test fails now naming the bug; "passes" = regression test green.

- camps_and_artifacts: #1 reproduced (fencing sword under Reforged, MSU emulator error verbatim);
  #6 reproduced (50–72 vs 300); #8 reproduced (cosmetic); #9 #11 pass; #2 not reproduced (Reforged
  0.8.18, Hardened forced onto it; the real setup needs Reforged ≥ 0.9); #3 not reproduced (33 fights
  on 11 C&A location types); #7 not reproduced on vanilla; #4 Legends; #5 world-map UI.
- retinue_ups: #1 reproduced (+ root cause: `ru_onDemote` leaves `m.ru_base`, new RU2); #2 not
  reproduced within a session; #3 passes. New: RU1 (ctrl-click on an empty slot throws).
- elite_few: #1 reproduced with a stub of Hardened's `setScreen` hook (caller seen as `acall`); #2
  reproduced; #3 partly (no endless loading, but MSU's dummy player gets `trait.master`); #6 not
  tested; #4 #5 SSU/Legends. New: EF1 (master strength bonus doubles after a load).
- bro_studio: #1 #2 #3 not reproduced; #6 passes. New: BS1 ("Add good traits" off ignored, in stdlib).
- necro: #1 confirmed; #2 reproduced, cause: vanilla `getAllSkillsOfType` skips hidden skills; #4 #5
  pass; #3 not tested (maybe by design). New: NE1 (icon shared with `pg.necro`, MSU error), NE2.
- hackflows_perks: #2 reproduced with Sato 1.4.1 (Lone Wolf text patched at a fixed row index the
  mod shifts; Nimble untouched by Sato); #1 not reproduced on vanilla; #3 passes. New: HP1.
- perma: #1 #2 pass.
- AC: #1 confirmed for every companion type; #2 not reproduced without Hardened; #3 passes.
- druid: #1 not reproduced (vanilla and Reforged, every beast type acts, faction PlayerAnimals, flipped).
- immortal_warriors: #1 not reproduced on 13 vanilla origins incl. Lone Wolf (report is Legends).
  New: IW1 (deeds counted again each rebirth), IW2.
- standout_enemies: #1 reproduced (`setBrightness` 0.1 then 1.0 leaves hair dark; head/body tint
  reset to white); #2 reproduced.
- useful: #1 passes.
- background_perks: #1 not reproduced (14 vanilla origins start, perks given); #2 passes; #3 Legends.
- Others: mod_beast_loot "doesn't work in vanilla" not reproduced; challenges / mod_vap reports untestable (Legends / UI).
- Mods with no known bugs got smoke + core tests; new: FX1 (fixes, Reforged without mod_hooks),
  MB1 (more_blood clobbers `::EventsFix`), TR1 (translations), FR1 (fix_reforged doesn't boot on
  Reforged 0.8.x).

## Discord deep search (2026-11-12)

Systematic search of Legends, Reforged and BB Modding: every mod's display name, short forms, id and zip name, "hackflow",
hackflow's own messages (author id; BB Modding capped at 1000 of 1772) and mentions of him; plus a sweep of the 300 newest
log.html attachments not collected before (120 Legends, 120 Reforged, 60 BB Modding) for stack frames in hackflow mods' files.
Logs are in `mods/_scripts/bbtest/discord_logs/` (listed in its `INDEX.md`); scripts `mods/_scripts/bbtest/discord_deep*.py`.
Numbering continues each mod's list above. Nothing new for: immortal_warriors, standout_enemies, events_delayed_fix, fixes,
fix_reforged, heal_repair_fix, beast_loot, vap, more_blood, random_perk, renamer, translations, challenges, cheap_meat, bro_studio
(bro_studio has an extension below).

### camps_and_artifacts

15. **Artifact Three-Headed Flail rolls with very low / negative damage** — status: fixed in 3.5.1 (`346bed5`, "fixed artifact 3-headed flail")
   - Source: https://discord.com/channels/1006908336991645757/1006909310615441508/1327138610033721385 (Reforged #general,
     2025-01-10; Darxo: "This is a bug with your camps and artifacts mod"; reply to the screenshot msg 1327098886925324462),
     author: https://discord.com/channels/1006908336991645757/1006909310615441508/1327145742308999283 ("base values for
     artifact three headed were set low — ancient base script").
   - Setup: Reforged; C&A < 3.5.0 (item still labelled "Famed Item", fixed in 3.5.0).
   - Symptoms: artifact 3-headed flail with damage far below the plain weapon (negative rolled damage shown). Already
     rolled items keep the bad values after the fix (author: needs Dev Console to edit).
   - Code now: `camps_and_artifacts/scripts/items/weapons/artifact/artifact_three_headed_flail.nut:27-28` (`RegularDamage = 30`, `RegularDamageMax = 75`).
   - Repro (regression): create `artifact_three_headed_flail` 50 times; assert `m.RegularDamage > 0`, `m.RegularDamageMax >= m.RegularDamage`
     and min/max not below the vanilla `three_headed_flail`'s ×0.8.

Extends existing:
- **#3 (arena floor on entering a location) — root cause found, C&A-side fix possible; status stays open.**
  Darxo (2026-05-06, Reforged thread "LocationTemplate"):
  https://discord.com/channels/1006908336991645757/1501460748554207273/1501461583422034011 and
  https://discord.com/channels/1006908336991645757/1501460748554207273/1501597634421325985 — vanilla
  `location.create()` does `this.m.CombatLocation = clone this.Const.Tactical.LocationTemplate`, a shallow clone, so
  every location shares one `Template` array with the global; contracts/events (vanilla `arena_contract.nut`) write
  `Template[0] = "tactical.arena_floor"` into it, and locations that don't set `Template[0]` themselves then generate an
  arena floor → `the index 'setFlipped' does not exist` at `tactical_arena_floor.nut : 101`. Darxo's repro: new campaign →
  arena fight → save → load → attack the Black Monolith → stuck loading. Lord Midas opened a vanilla bug report and a
  Modular Vanilla fix PR (https://github.com/Battle-Modders/mod_modular_vanilla/pull/96,
  https://discord.com/channels/1006908336991645757/1501460748554207273/1502533348772282418).
  C&A side: four C&A locations never set the template — `camps_and_artifacts/scripts/entity/world/locations/barbarian_sacred_grove_location.nut`,
  `bandit_usurper_location.nut`, `goblin_warrens_location.nut`, `undead_damned_city_location.nut` (each `create()` only
  calls `this.location.create()` at line 10) — and all the others write `this.m.CombatLocation.Template[0] = ...` into the
  shared array (e.g. `noble_tower_location.nut:14`), tainting it for vanilla unique locations. Fix: assign a fresh array,
  `this.m.CombatLocation.Template = ["tactical.human_camp", null]` (and `[null, null]` or an explicit template in the four).
  More logs with the same stack: `discord_logs/reforged_1359204856799301632_log.html`
  (https://discord.com/channels/1006908336991645757/1359204856799301632/1359204856799301632, 2025-04-08, contract to destroy
  "New Turmfeste"; Darxo: "common but harmless crash when using mods that add new locations, reload"),
  `discord_logs/reforged_1201375913405849712_log.html`
  (https://discord.com/channels/1006908336991645757/1201375913405849712/1201375913405849712, 2024-01-29, C&A 3.3, camp during
  the Undead crisis). Repro: headless campaign; run `arena_contract`'s template setup (or set
  `::Const.Tactical.LocationTemplate.Template[0] = "tactical.arena_floor"` the way it does via a cloned table); then create
  each C&A location class and assert `loc.m.CombatLocation.Template[0] != "tactical.arena_floor"` and
  `::Const.Tactical.LocationTemplate.Template[0] == null` after creating every C&A location.
- **#2 (`ca_getCamps` spam)** — Darxo reproduced it and blames **Crock Pot**: errors start once a game is loaded
  (https://discord.com/channels/1006908336991645757/1138845062969704509/1447686082907865218, 2025-12-08; same thread as
  `discord_search.jsonl` msg 1447675423852068874). Not yet cross-checked against Crock Pot's code; repro should add a load
  step and Crock Pot if available.
- **#11 (Origin Maker)** — another Origin Maker report with the stack through `scripts/!mods_preload/mod_camps_and_artifacts.nut : 32`
  → `mod_origin_maker_helper_process...`: https://discord.com/channels/965324395851694140/1390298133002584065/1390790898161422528
  (BB Modding, 2025-07-04, C&A 3.5.1), predates the 3.5.2 fix (2025-10-23).

Skipped: reproducible save corruption with Flesh and Faith+ / Stronghold / C&A + Lushken patch (Darxo could reproduce,
culprit never identified, https://discord.com/channels/1006908336991645757/1283857645492502549/1298968825169186836, 2024-10-24);
item with `ItemSlot.None` crash where Darxo guessed C&A, user had no artifacts
(https://discord.com/channels/1006908336991645757/1284036971341025345/1284159549787344990); Legends abduction location
"C&A tries to add gear" (vanilla placement bug per Legends dev,
https://discord.com/channels/547043336465154049/1219677793990737960/1219835309081104535); Stronghold attack loop (fixed by
reinstalling SSU); Legends/SSU "famed items break saves" (no log); difficulty/balance complaints; Lushken edited versions.

16. **Legends: artifact armor isn't layered, camp-dropped armor attachments don't fit layered armor, big camps use static vanilla spawn lists** — status: open (acknowledged limitation; hackflow considers dropping armor for Legends)
   - Sources: Legends thread https://discord.com/channels/547043336465154049/1167322754991800390/1522381465512443979
     (hackflow 2026-07-02: "maybe I should just drop weapons and ammo only for Legends. Unless someone will implement and
     test layered armors"), .../1522579506345545788 ("aside from SSU and armor being not layered it works"),
     .../1567729950360866977 (lilpod13 2026-11-05: "Artifact armors are not layered, and armor attachments dropped from
     camps don't work with layered armor. Some camps have specific outdated spawn lists … noble castles will only have
     vanilla enemies and never any legends elite enemies"). Same static-party remark for Reforged in 2024
     (https://discord.com/channels/1006908336991645757/1180373120415178854/1194987482018754590).
   - Setup: Legends 19.x.
   - Symptoms: artifact armors behave as single-piece vanilla armor; attachments from camp loot can't be attached; camp
     garrisons never contain faction-rework units.
   - Suspected code: `camps_and_artifacts/scripts/items/armor/artifact/artifact_armor.nut` (vanilla `armor` base);
     static party definitions in `camps_and_artifacts/camps_and_artifacts/config/spawnlist_*.nut`.
   - Repro: with a Legends stub/real Legends, roll 50 artifact armors and the camp loot tables; assert each armor is
     wearable with Legends' layer system (or that no armor is rolled when Legends is present, if that's the chosen fix);
     spawn a noble castle and assert its party uses the faction's current spawn list.

17. **SSU ≥ 8.0 (Legends) incompatible, "maybe because of the Dryad faction"** — status: unclear (no log, no details)
   - Source: https://discord.com/channels/547043336465154049/1167322754991800390/1522597775790047373 (silverwolf63,
     2026-07-03, reply to hackflow's "there were some discussion in SSU thread, maybe that was fixed").
   - Suspected code: C&A's per-faction hooks (`camps_and_artifacts/camps_and_artifacts/factions/faction.nut`,
     `config/faction_traits.nut`) assume a fixed faction set; a new faction type may lack the hooked methods (cf. #2
     `ca_getCamps`).
   - Repro: if SSU is loadable, Legends + SSU 8 new campaign; iterate all factions, run `update()` 50 times; assert no
     error; enter one C&A location.

### retinue_ups

5. **1.2.0 floods the log with `faction.update ID=… Name=…` on every faction update** — status: fixed in 1.2.1 (`38ad5f0` "move out an unrelated fix")
   - Source: https://discord.com/channels/1006908336991645757/1369635691516137514/1370229959804583937 (Reforged
     #technical-help, 2025-05-09, author: "logs about faction.update is from Retinue Promotions — update it, some debug
     code slipped to some older release"); Darxo earlier: "One of your mod is activating extensive logging"
     (https://discord.com/channels/1006908336991645757/1369635691516137514/1370033661822373948).
   - Setup: Reforged 0.7.6, Retinue Promotions 1.2.0. Log `discord_logs/x_1369881243751157781/log.html`
     (from `reforged_1369881243751157781_log.zip`): 63 933 `faction.update` lines, 13 MB log, makes logs useless and too big
     to attach.
   - Code (1.2.0 zip `retinue_ups/mod_retinue_ups_1.2.0.zip`, `scripts/!mods_preload/mod_retinue_ups.nut:18-20`):
     a `factions/faction.update` hook (an unrelated "skip units without troops" fix) starting with
     `::logInfo("faction.update ID=" + m.ID + " Name=" + m.Name);`. Removed in 1.2.1 together with the hook.
   - Repro (regression): load the mod, advance the world 1 day, assert no `faction.update` line was logged (count log
     lines through a `::logInfo` spy).

Extends existing:
- **Skipped "throwing errors" with a modified copy** — another case: `discord_logs/reforged_1368280376979619964_log.html`
  (https://discord.com/channels/1006908336991645757/1283857645492502549/1368284854340423840, 2025-05-03, Lord Midas: "retinue_ups
  is throwing an error"; author: modified broken version, redownload,
  https://discord.com/channels/1006908336991645757/1283857645492502549/1368413216669040711). Error:
  ```
  Script: Failed to load script file "scripts/!mods_preload/mod_retinue_ups.nut". Reason: "expression expected" line:221 column:20.
  Script Error: the index 'mod_retinue_ups' does not exist
    at -> modern_hooks/public_globals.nut : 20
    at main -> scripts/i_retinue_ups_levelup_changes.nut : 20
  ```
  The official 1.2.2 zip compiles (line 221 is `local cook = ...` in `dropFood`), so the user's copy was edited. A side note:
  that `local cook` in 1.2.2 `mod_retinue_ups.nut:221` is dead code.

Skipped: robber baron without miniboss gear blamed on Retinue Promotions (Lord Midas found nothing; `tnf` mod suspected,
https://discord.com/channels/1006908336991645757/1006908337981509725/1497767594252439723); "Promoted Surgeon fixes permanent
injuries 10% per level" (by design).

6. **`::mods_hookNewObjectOnce` hooks lost when the game recreates a singleton (load → main menu → load) under Reforged/MSU** — status: fixed (Retinue Promotions before its first release `retinue-ups-0.5`, commit `1c96f6c` 2023-11-10; same fix in Elite Few 2.3.1 `efb6b62`, Events Delayed Fix 0.7 `6596680`, Hackflow's Perks 1.2 `bad6c59`, Cool and Blacksmith Fix `f34a21e`, all 2023-11-17/21; Cheap Meat CHANGELOG: "fixed hookNewObjectOnce() bug: stopped working after second game load")
   - Source: hackflow's own Reforged bug threads https://discord.com/channels/1006908336991645757/1172046777147478068/1172048433712996413
     ("[0.2.1] Can't load game occasionally", 2023-11-09: "changing `mods_hookNewObjectOnce()` to `mods_hookNewObject()` on
     retinue/retinue_manager helped"; Lord Midas: the object is destroyed/recreated during world_state or game loading, so
     the hook is gone for the new instance) and https://discord.com/channels/1006908336991645757/1172125017471975454/1172924153561624686
     ("like 6 of my mods were a bit broken by this `...NewOnce()` thing", 2023-11-11).
   - Setup: Reforged 0.2.x–0.3.x, MSU; vanilla has the same trap whenever an object is re-created.
   - Symptoms: crash on loading a save after returning to the main menu (error in `settlement.onDeserialize`); hooked
     behaviour silently gone on the recreated object (promotions not applied, campfire Ctrl+click dead, etc.).
   - Code now: every mod uses Modern Hooks `mod.hook`/`::mods_hookNewObject`; `git grep hookNewObjectOnce` finds no code
     use left in `mods/`.
   - Repro: start a campaign, save, quit to the main menu, load the save, then load it again; assert
     `::World.Retinue.setFollower` is still the wrapped one (e.g. promoting a follower changes its effects) and no script
     error during deserialize. Same check for each mod's hooked singleton (`world_campfire_screen`, event manager).

### elite_few

8. **Clever Recruiter + Elite Few: `No overload matching this argument list found` while generating recruits** — status: other mod's bug (Clever Recruiter patches `Math.rand`; Enduriel said he'd fix it on his side), still reported in 2025
   - Sources: BB Modding https://discord.com/channels/965324395851694140/965324396317278240/1257622395435352074 (Enduriel,
     2024-07-02: CR "switcheroos rand", EF wraps `buildAttributes`, master roll → `actor.setDirty` → `::Math.rand() + ::Math.rand()`
     breaks under CR; depends on queue order; author: "This is why I shy away from patching Math.rand()"); BB Modding
     https://discord.com/channels/965324395851694140/1222072028417364059/1278620446576873513 (2024-08-29, filed as "Bro
     Studio + CR", logs show Elite Few); Legends https://discord.com/channels/547043336465154049/1179715231803514910/1370681997558681720
     (2025-05-10, "been around for a while"; existing skipped log `logs/Legends/1370364408278286408/`);
     https://discord.com/channels/547043336465154049/616566479306883073/1416051379604160532 (2025-09-12, "tell hackflow master bros is incompatible with clever recruiter").
   - Logs: `discord_logs/bbmodding_1278620446576873513_log_46.html`, `discord_logs/bbmodding_1278620446576873513_log-329.html` (Legends):
     ```
     Script Error: No overload matching this argument list found
       at -> scripts/!mods_preload/mod_clever_recruiter.nut : 43      (_a = NOT_A_NUMBER, _b = NOT_A_NUMBER)
       at setDirty -> scripts/entity/tactical/actor.nut : 457
       at onUpdateInjuryLayer -> scripts/entity/tactical/player.nut : 815
       ...
       at -> scripts/!mods_preload/z_elite_few.nut : 177              (master = True)
       at concat_call -> scripts/!mods_preload/z_elite_few.nut : 58
       at -> clever_recruiter/world_state.nut : 10
     ```
   - Suspected code: `elite_few/scripts/!mods_preload/z_elite_few.nut:178-200` (`buildAttributes` wrap adds `trait.master`
     while CR's temp player is being built, which triggers `setDirty` inside CR's patched rand). EF-side mitigation: add
     the master trait without `setDirty` side effects, or skip rolling for CR's temp player.
   - Repro: only with Clever Recruiter available: Legends/vanilla, `selectMode = "all"`, refresh a town's recruits through
     CR's `world_state` hook; assert no script error and recruits generated.

9. **Legends 18 + PTR: new campaign fails, `wrong number of parameters` in the `fillTalentValues` wrapper** — status: unclear (EF 2.4.0; a helper said EF works with PTR+SSU; no author reply)
   - Source: https://discord.com/channels/547043336465154049/1206361038258438205/1206361038258438205 (Legends help,
     2024-02-11, "every time I start a new world"); https://discord.com/channels/547043336465154049/1206361038258438205/1206391669554155582
     ("Elite Few error. Remove mod"). Log `discord_logs/legends_1206361038258438205_log.html` (also lacks Modern Hooks).
     ```
     Script Error: wrong number of parameters
       at concat_call -> scripts/!mods_preload/z_elite_few.nut : 58
       at -> scripts/!mods_preload/z_elite_few.nut : 116            (_num = 3, _force = False)
       at concat_call -> scripts/!mods_preload/z_elite_few.nut : 58
       at -> mod_ptr/hooks/entity/tactical/player.nut : 113
       at onSpawnAssets -> scripts/scenarios/world/rangers_scenario.nut : 44
     ```
   - Suspected code: `elite_few/scripts/!mods_preload/z_elite_few.nut:117-118` (`fillTalentValues` wrapper → `call.super()`
     forwards the caller's args to the wrapped function via `concat_call`, lines 55-58); the wrapped (PTR/Legends 18)
     function rejects the arg count. Not reproducible without PTR; Legends 18 is obsolete.
   - Repro: stub `player.fillTalentValues(_num)` with one parameter, call it through EF's wrapper as `fillTalentValues(3)`
     and `fillTalentValues(3, false)`; assert no error and that the stub got the same args the caller passed.

Extends existing:
- **#1 (Hardened negotiation soft lock)** — Discord links for the `discord_search.jsonl` sources: Darxo reproduced it
  (https://discord.com/channels/1006908336991645757/1138845062969704509/1460237401640275988, 2026-01-12) and again
  (https://discord.com/channels/1006908336991645757/1138845062969704509/1509951256125243582, 2026-05-29: "already got
  reported… couldn't make sense of the passage"); Darxo 2026-08-23: "only aware of a compatibility issue with Elite Few and
  Hardened in those negotiation screens" (https://discord.com/channels/1006908336991645757/1283857645492502549/1541115185232744480).
- **#3 (endless loading, MSU dummy player)** — the report thread:
  https://discord.com/channels/1006908336991645757/1283857645492502549/1391784088117182474 and
  https://discord.com/channels/1006908336991645757/1283857645492502549/1391799341701922848 (2025-07-07, "disabling the rolling
  for elite brothers in mod settings fixed it"; another user with EF has no issue).

Skipped: "elite few appears in all errors" (user retracted: another error,
https://discord.com/channels/547043336465154049/1179715231803514910/1226615116024516778); freeze starting a fight with
Specialist Rework (`discord_logs/legends_1273234913545551954_log.html`: `calculateSpecialistBonus` in
`specialist_skills_hooks`, not EF); Reforged seed freeze (`discord_logs/reforged_1285467978229354498_log.html`: `tnf_revisedNamedItems`,
`mod_rpgr_raids`); Legends logs `legends_1371869457802199111_log.html`, `legends_1395739707823886396_log.html` (EF only in
the mod list); "increase master chance over time", wrong mod name on the Legends compat list (feature/questions).

10. **Legends/SSU-reworked bad traits still allowed on master bros (Deathwish with −3 MDef per surrounding enemy)** — status: open (author: "might be fixed in the mod too, just need to detect Legends and add to the list")
   - Source: https://discord.com/channels/547043336465154049/1179715231803514910/1197433918941560842 and
     .../1197479626272952330 (frederikn0912 + hackflow, 2024-01-18; Legends + SSU). Double Tongued from the same report
     was made dubious in 2.4.1 (#7).
   - Suspected code: `elite_few/scripts/skills/traits/master_trait.nut:14-50` (Excluded) and `:52-69` (dubious) list no
     `trait.deathwish` / `trait.legend_deathwish`.
   - Repro: Legends stub where `trait.deathwish` has a negative effect; roll 500 master bros; assert none gets Deathwish
     (or that the list is chosen per Legends presence).

### bro_studio

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

### necro

7. **Reforged 0.7.x: `the index 'PerkTreeMultipliers' does not exist` creating/loading the Necromancer background** — status: fixed in 0.4.1 (`37960c6` "Reforged 0.7 compat"; test build `mod_necro_0.4.0_FIX1.zip`)
   - Sources: https://discord.com/channels/1006908336991645757/1283857645492502549/1353632468250656778 (Reforged
     #technical-help, 2025-03-24, Darxo: "necro_background compatibility broke");
     https://discord.com/channels/1006908336991645757/1373918299187970078/1373923384353886229 (2025-05-19, Darxo: "issue
     seems to be mod_necro… Reforged 0.7.7 breaking changes"); author's FIX1 build
     https://discord.com/channels/1006908336991645757/1373230066695405598/1374295200142331966 (2025-05-20).
   - Setup: Reforged 0.7.x, Proper Necro 0.4.0 (`mod_necro_0.4.0.zip`).
   - Logs: `discord_logs/reforged_1353621793214173266_log.html` (on new campaign), `discord_logs/reforged_1373922723973042246_log.html` (on load):
     ```
     Script Error: the index 'PerkTreeMultipliers' does not exist
       at create -> scripts/skills/backgrounds/necro_background.nut : 54
       at -> msu/hooks/skills/skill.nut : 15
       at -> mod_reforged/hooks/skills/skill.nut : 103
       at onDeserialize -> scripts/skills/skill_container.nut : 990
       at onDeserialize -> scripts/entity/tactical/player.nut : 1986
     ```
     (0.4.0 assigned `this.m.PerkTreeMultipliers = {...}`, a slot Reforged 0.7 removed from backgrounds.) The
     `mage_background.nut : 54` "the index 'Body'" error in the first log is not Proper Necro's (no such file in the mod).
   - Code now: `necro/scripts/skills/backgrounds/necro_background.nut:41-70` (`createPerkTreeBlueprint`, module-level `PerkTreeMultipliers`).
   - Repro (regression): Reforged 0.7+ loaded; `::new("scripts/skills/backgrounds/necro_background")`, add to a player,
     serialize + deserialize the player; assert no error and the bro has the necro perk group.

Skipped: orcs can't be raised (outdated Reforged, user confirmed fixed after update,
https://discord.com/channels/1006908336991645757/1549689108140658798/1552419266429587568); Black Pyramid 0.4 replacing
`weapon.isDroppedAsLoot` (hackflow reported it to BP — other mod's bug,
https://discord.com/channels/1006908336991645757/1494077202218619020/1535924844514906152); dagger/AC Tome of Death raised loot
loss (author note, not Proper Necro).

8. **Necro 0.3.0 on Reforged: every bro's perk screen shows the vanilla perk tree** — status: fixed in 0.4.0 ("support Reforged")
   - Source: Reforged technical-help https://discord.com/channels/1006908336991645757/1283857645492502549/1295830951422591077
     (csgonoobmiki, 2024-10-15, "new version of necro brokes perktrees"; hackflow: "didn't test it with Reforged yet …
     try deleting this 3-lines else clause", …/1295860566925119599). Log
     `discord_logs/reforged_1295761236696371252_log.html` (necro 0.3.0); its only error is from Dynamic Perks tooltips:
     `the index 'perk.head_hunter' does not exist` at `getPerkTier -> scripts/mods/mod_dynamic_perks/classes/perk_tree.nut : 214`.
   - Cause: 0.3.0's `data_helper.convertEntityToUIData` hook set `result.necro_perkTree <- ::Const.Perks.Perks` for
     every non-necro bro (`else` branch, `necro/scripts/!mods_preload/mod_necro.nut:157` at `d57bab1`), and
     `ui/mods/necro.js` loads it instead of the Dynamic Perks tree.
   - Code now: the hook is installed only without Dynamic Perks and sets the tree only for `background.necro`
     (`necro/scripts/!mods_preload/mod_necro.nut:195-218`); JS restores the stock tree only after its own tree
     (`necro/ui/mods/necro.js:7-15`).
   - Repro: Reforged (Dynamic Perks) loaded; build UI data for a non-necro bro; assert no `necro_perkTree` key and that
     the perk tree is the bro's DPF tree.

### druid

No new bugs: only release notes and recommendations.

- Extends #2 (fixed in 0.5.2): the log of that report is now saved as `discord_logs/reforged_1526200004580999219_log.html`
  (https://discord.com/channels/1006908336991645757/1518597754505396384/1526200004580999219, Druid 0.5.1, Reforged +
  Starting Perks by Background, no XBE): `the index 'hackflows_druid' does not exist` at
  `scripts/!mods_preload/mod_druid.nut : 38` in queue function 1 — `::std.Table.extend(::BgPerks.chances.hackflows_druid, …)`
  when only XBE defines that key; `672ed99` creates the table instead (`druid/scripts/!mods_preload/mod_druid.nut:38`).
  Test build `mod_druid_0.5.1_XBE_BgPerks_FIX1.zip`.

### hackflows_perks

5. **Reforged ≥0.6.x: perk groups not built, bros have empty perk trees — `the index 'Trees' does not exist`** — status: fixed in 1.5 (`7232ccd` "update to work with newer Reforged", 2025-01-06)
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

Skipped: "is hackflow perks incompatible with Legends" (perks are in Legends already); Augmented perks pack (other mod).

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

### useful

2. **Legends: Useful Things hooks fail at load — `the index 'onUpdate' does not exist` in `hand_to_hand`** — status: open (Legends unsupported, but the mod does not say so: no `conflictWith("mod_legends")`; the reporter "believed the author")
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

### background_perks

4. **Legends "Supposed Witch" event: first option doesn't advance, a bro is added per click, roster won't open, save then fails to load** — status: unclear (Legends staff blamed this mod; no script error in the logs), open in code
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

### perma

- **Extends #2 (`the index 'isNull' does not exist` in `onShieldHit`, fixed in 2.0.2).** Two Discord reports:
  https://discord.com/channels/1006908336991645757/1450012846518829087/1450013394462576782 (sp0gg 2025-12-15, Lord Midas:
  "caused by `mod_perma_hackflow`"; Perma 2.0.1 + Reforged + Modular Vanilla; log
  `discord_logs/reforged_1450012846518829087_log.html`:
  `the index 'isNull' does not exist` at `scripts/!mods_preload/mod_perma_hackflow.nut : 31` ← `onShieldHit ->
  scripts/skills/skill.nut : 1343` ← `MV_onAttackEntityMissed -> mod_modular_vanilla…`, right after a Reforged Lunge
  teleport callback) and https://discord.com/channels/1006908336991645757/1499435077422284922/1499442784728518776
  (2026-04-30, hackflow and Lord Midas work out that something passes a plain table instead of a `WeakTableRef`; fix
  `e3b0526`).

Skipped:
- "Tried to read data beyond (0) the length (0) of the Deserialization Emulator" after every load with only MSU + Perma +
  Legacy (+ Legacy × Perma compat mod), https://discord.com/channels/1006908336991645757/1283857645492502549/1510039127960191027
  (2026-05-29, log `discord_logs/reforged_1510021391536230420_log.html`, Perma 2.0.2): Perma has no serialization code;
  the MSU serde emulator is used by Legacy / its compat mod. Not Perma.
- "Injuries work like default" (Legends 2026-07-04): the mod zip wasn't in the data folder.
- Missing Hand makes the mod non-removable mid-campaign (vanilla injury's broken `onAdded`): by design, documented.

### AC

4. **Tame identified beasts by their display name, so taming broke with a translated game (and Northern Expansion direwolf)** — status: fixed in 2.0 (`2008c56`, "identify beasts by class")
   - Source: BB Modding general-chat https://discord.com/channels/965324395851694140/965324396317278240/1294672268403806218
     (hackflow 2024-10-12: "if Direwolf is called something else then it cannot be tamed"; …/1294679069174009936: IDs are
     shared by dog/wolf kinds, "the author simply used Name"; AC Legends uses Type, losing dog/wolf variants).
   - Old code: `this.Const.Companions.TameList.find(target.getName())` in `companions_library.nut`.
   - Code now: `::Const.Companions.getType` by `ClassName` (`AC/scripts/companions/companions_library.nut:59-62`).
   - Repro: rename a direwolf (`setName("Lobo")`) and a translated unhold; use Tame with forced success; assert a
     companion of the right type is produced.

5. **Tamed Alp may crash the game (e.g. tamed Alp killing an enemy Alp)** — status: unclear (old report relayed by the original author, never logged)
   - Source: https://discord.com/channels/965324395851694140/1520791670696710295/1521099320038785196 (vazl, original AC
     author, 2026-06-29) and …/1522752220351828120; hackflow (…/1522263202971390145): "didn't do anything to fix it".
   - Suspected code: `AC/scripts/companions/types/companions_alp.nut:142-269` (`onDeath`: kills `alp_shadow` illusions
     of its own faction, unequips the item) and `:295-316` (`onActorKilled` XP share); vanilla `alp_racial` /
     `sleep_skill` / nightmare (`AC/scripts/companions/skills/companions_nightmare_skill.nut`) on a player-faction alp.
   - Repro: tamed Alp (player faction) vs enemy Alps with shadows; let the tamed Alp kill an enemy Alp with nightmare,
     then let the tamed Alp die; run the AI for both sides to battle end. Assert no script error and the item is returned
     to the owner's slot/stash.

### Extends existing

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

- useful: Legends 2024-02-18 "mod_useful tripping asset manager" (jcsato guess) — the reporter found More Ambitions was the cause.
- heal_repair_fix: Legends 16.4.3 save crash after 50 days (2023-11-20) — 6-month-old Legends + 2-year-old PTR, log has no script errors (`discord_logs/legends_1176098222758965248_log.html`).
- events_delayed_fix: Reforged devs say it is redundant since vanilla 1.5.1.4 (Darxo https://discord.com/channels/1006908336991645757/1283857645492502549/1353632468250656778, Lord Midas …/1300271663744680026/1381215793768960043) — consider marking it obsolete on Nexus; not a bug.
- vap: hackflow's own 2023 report that `!mod_vap` in a `mods_queue` string fails under Modern Hooks — a Modern Hooks issue.
- AC: Reforged chat only ("looks like accessory companions", companion perks, party strength growing with companions); nothing about hackflow's build failing.
- perma test builds `_HAND_DROP_1`, `_RESTORE_FIX1` in the BB Modding thread belong to existing #1.
- standout_enemies: "not compatible with Legends" (2022) — old, Legends unsupported.

### XBE / Rosetta (not in `mods/`, one line each)

- XBE `gardener_provides_mysterious_herbs_event` broke (Reforged, 2025-05-08); fixed in battle-brothers-xbe `943ed66`:
  https://discord.com/channels/1006908336991645757/1369635691516137514/1370231422480027660.
- XBE falconer bug, test build `mod_backgrounds_and_events_0.7_FIX1.zip`:
  https://discord.com/channels/1006908336991645757/1299045289574928396/1373917190939476028 (2025-05-19).
- XBE event `candidates_town_watchman` error, likely an old version (Darxo, 2025-05-12):
  https://discord.com/channels/1006908336991645757/1371424395486040124/1371430987841671240.
- Rosetta: Russian translation changing `m.Categories` broke MSU `isWeaponType()` (Weapon Master, Sanguinary); fix
  shipped in Rosetta: https://discord.com/channels/1006908336991645757/1323598180885073973/1326000474238746726 (2025-01-07).

### Skipped (other)

- C&A city-state camps in an odd place with World Parameters (Reforged 2024-11-01, …/1180373120415178854/1301832429991886890):
  no log, "looks like a bug", likely World Parameters.
- C&A items missing from Item Spawner (Legends 2026-07-03): broken NgGH install in the log
  (`discord_logs/legends_1522671554058653696_log.html`), no C&A errors.
- Challenges "no level-up button" (Legends 2026-09-02): already under "Others with only unclear reports".
- Retinue Promotions compile error at line 221 (Reforged 2025-05-03): edited copy, in `other_A.md`.
- Necro: possess on enemies / Mind Meld stackables (2025-07-01) — necro #1/#2; Hardened "breaks perks" — skipped before.

## Repro status (Discord section)

Headless tests, 2026-11-12, in each mod's `scenarios/discord_bugs*.nut`; details in that mod's `FOUND_BUGS.md`.
Open/unclear entries of the Discord section only.

1. camps_and_artifacts #3 (extended) — **reproduced**, cause verified with a correction:
   `discord_bugs::CA-KB3` ×2 fail. Vanilla `arena_contract`'s shallow clone writes `tactical.arena_floor` into the
   global `LocationTemplate.Template`; every later location copies it, and C&A's `bandit_usurper`,
   `barbarian_sacred_grove`, `goblin_warrens`, `undead_damned_city` (and vanilla's monolith, abandoned fortress,
   battlefield) keep it — also across a save/load; their fights get arena maps. C&A's other locations do *not*
   taint the global (vanilla 1.5.2 `location.create()` clones `Template` too; a control test passes). The
   `setFlipped` crash itself didn't occur headless.
2. camps_and_artifacts #2 (extended, Crock Pot) — not reproduced with Crock Pot 0.8.0 + Reforged 0.8.18
   (`discord_bugs_crock_pot`), but the mechanism is confirmed: C&A's city-state action on Crock Pot's
   `OrientalCityState` village faction throws the users' error; Crock Pot 0.8.0 overrides `addTrait` to skip
   those actions (file dated 2025-12-12, after Darxo's repro), so older Crock Pot versions hit it.
3. AC #5 (tamed Alp crash) — not reproduced (`discord_bugs::AC-KB5` ×2: AI rounds; Nightmare kill both ways).
4. elite_few #8 (Clever Recruiter) — CR 2.1.6's bug, fixed in CR 2.1.8 (the CR 2.1.6 tests are removed). Not
   reproduced in vanilla with CR 2.1.6; the
   path needs Legends' `setHitpointsPct` → `setDirty`. Mechanism confirmed: any zero-argument `Math.rand()`
   under CR's swap throws the users' `No overload matching this argument list found`.
5. bro_studio #1 extension (Gifted max rows on a veteran) — not reproduced (`discord_bugs::BS-KB1` ×2).
6. Not feasible headless (Legends/SSU/Hardened/PTR not available): camps_and_artifacts #16, #17;
   elite_few #9, #10; useful #2; background_perks #4; perma's Legacy bridge mod.
7. Fixed entries (camps_and_artifacts #15, retinue_ups #5, #6, necro #7, #8, hackflows_perks #5, AC #4) got no
   regression tests.
8. Real Hardened 1.26.3 / Reforged 0.9.3 / Crock Pot 0.10.6 / Legends 19.4.23 / Clever Recruiter 2.1.8 (2026-11-12):
   camps_and_artifacts #2 not reproduced (Hardened, + Crock Pot; `hardened_bugs_ca`, `hardened_cp_bugs_ca`); #16
   reproduced (artifact armors aren't `legend_armor`; vanilla attachments from camp loot throw `the index '-1' does not
   exist` in Legends' `legend_armor.setUpgrade`; `legends_bugs_ca`); #7, #4 not reproduced on Legends; #17 not feasible
   (SSU doesn't boot on Legends 19.4), its Legends part passes. elite_few #1 reproduced with the real Hardened
   (`hardened_bugs_elite_few`, control `hardened_real_control_ef` passes); #10 reproduced (39/600 masters get Deathwish,
   −3 MDef under Legends); #5, #9 not reproduced on Legends 19.4; #8 not reproduced with CR 2.1.8 (fixed on CR's side);
   #4 not feasible (SSU). New EF2: CR 2.1.8 runs `buildAttributes` twice, so Elite Few rolls masters twice (vanilla).
   AC #2 reproduced with Hardened (tamed ghoul +0 HP vs wild +120 per feast; Hardened's `ghoul.grow` hook misses AC's
   class). bro_studio #2 not reproduced with Hardened; #4 regression passes on Legends.
9. Legends 19.4.23 / Hardened 1.26.3 / Reforged 0.9.3 (2026-11-12): background_perks #4 reproduced
   (`legends_bugs_bg_perks::BP-KB4` ×2: the 2-parameter wrapper makes Legends' own `setStartValuesEx(…, true, 1)` throw
   `wrong number of parameters`), #3 not reproduced (Beggar, Berserker start); immortal_warriors #1 reproduced on
   Legends (`legends_iw_lone_wolf`, `legends_iw_early_access`: 0 jars; Legends' exact-class `onSpawnAssets` shadows the
   base-class hook; Legends' own origins get them); retinue_ups #2 reproduced on Legends (`legends_bugs_retinue::RU-KB2
   legends`: flag kept, cost/effects reverted; Legends' instance `onDeserialize`); useful #2 not reproduced (Legends
   19.4 hooks vanilla `hand_to_hand`); challenges' Legends level-up report: UI data same as without the mod (the button
   is JS); necro "Hardened breaks perks" not reproduced (`hardened_necro`); perma Legacy bridge not reproduced (Legacy
   2.13 / bridge 1.1.9, MSU 1.8 and 1.9). New: BP-L1, RU-L1, CH-L1. HP1 still fails on Reforged 0.9.3.
