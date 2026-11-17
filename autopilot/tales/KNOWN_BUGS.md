# Autopilot New — known bugs

Collected 2026-11-11 from: Nexus Bugs (9 issues) and Posts (62 threads) tabs of
https://www.nexusmods.com/battlebrothers/mods/675, Discord mod threads (Reforged `1171689544916156426`, Legends
`1171689990439321620`, BB Modding `1159048664333963305`), Discord search for "autopilot", user logs in
`service/data/logs/` with `autopilot/` stack frames, `service/jobs/`, CHANGELOG, git history, and the test zips in this
dir (`_FIX*`, `_DEBUG*`, `_EXPERIMENTAL*`).

Released: 2.9.0 (tag `autopilot-new-2.9.0`, 2026-07-04). HEAD has unreleased work (three dog modes, bandages/heal ally,
Pandora's Hobby, more Reforged skills) but none of it touches the open bugs below.

Code refs are relative to `autopilot/`. Discord guilds: Legends `547043336465154049`, Reforged `1006908336991645757`,
BB Modding `965324395851694140`.

Read logs carefully: `autopilot/verbose.nut : 15/21/22` (`wrapper`) and `autopilot/hooks/tactical_state.nut : 92`
show up in almost every AI stack, because they wrap `agent.evaluate/execute` and `updateCurrentEntity`. On its own
that does not make an error Autopilot's. Many reported hangs were Legends, SSU, NgGH or Reforged skill bugs that
autopilot merely exposed by giving player bros enemy AI.

## Open / unclear

### 1. AI freeze: `getAmmoType` does not exist in swap-quiver behavior — fixed (2026-11-15: only Ammo-slot items are quivers)
- Source: Reforged thread https://discord.com/channels/1006908336991645757/1171689544916156426/1528466390758199316
  (lukesolas, 2026-07-19, 2.9.0; log on Google Drive; screenshot in
  https://discord.com/channels/1006908336991645757/1171689544916156426/1528466667506765896). Author asked "You don't have
  a quiver but you need one?"; reporter: the quiver was empty. No reply after.
- Error (repeats every think, the turn never ends):
  ```
  Script Error: the index 'getAmmoType' does not exist
    onEvaluate -> scripts/ai/autopilot_swap_quiver.nut : 29   (ammoType = 1)
    evaluate -> scripts/ai/tactical/behavior.nut : 97
    wrapper -> autopilot/verbose.nut : 22
  ```
- Suspected code: `scripts/ai/autopilot_swap_quiver.nut:26-28`. The bag filter checks
  `item.isItemType(ItemType.Ammo) && item.getAmmo() > 0 && item.getAmmoType() == ammoType`. Throwing weapons
  (javelins, throwing axes, spiked balls) and the firelance are also `ItemType.Ammo` and have `getAmmo()`, but only
  `items/ammo/ammo.nut` defines `getAmmoType()`.
- Repro idea: tactical battle, bro with a bow and an equipped quiver with `m.Ammo = 0`, throwing axes (or javelins) in
  the bag, no enemy in melee range; enable AI control (`Tactical.TurnSequenceBar.onAIButtonPressed` + confirm, or
  `bro.enableAIControl()`), run the bro's turn. Assert no script error and the turn ends within N think ticks. Variant:
  a second quiver with arrows in the bag → assert it gets equipped.

### 2. Quick-switch hotkeys still swap items when the buttons are hidden — open
- Source: Reforged thread https://discord.com/channels/1006908336991645757/1171689544916156426/1529467787523653702
  (lukesolas, 2026-07-22, 2.9.0 with Extra Keybinds: "despite the hotkeys being hidden they still work to switch
  weapons").
- Suspected code: `autopilot/hooks/tactical_state.nut:59-68` `setActionStateBySkillIndex` maps indexes past the active
  skills to `querySwitchableItems()` regardless of `::Autopilot.quickSwitch`. The flag is set to false for Extra
  Keybinds / Legends quickly_swap_items in `scripts/!mods_preload/mod_autopilot_new.nut:89-95` and is only checked in
  `turn_sequence_bar.nut:152`. `turnsequencebar_onEntitySkillClicked` (`tactical_state.nut:48-57`) likewise swaps any
  item id.
- Repro idea: set `::Autopilot.quickSwitch = false`; bro with K active skills and a spare weapon in the bag; call
  `Tactical.State.setActionStateBySkillIndex(K)` (number key K+1). Assert the mainhand item is unchanged and no AP spent.
  Control: with `quickSwitch = true` the weapon gets swapped.

### 3. Auto Recover at end of turn bypasses Reforged Unstoppable — open
- Source: Reforged thread https://discord.com/channels/1006908336991645757/1171689544916156426/1514633702917931079
  (.drglord, 2026-06-11: "autopilot bypasses unstoppable meaning you can end your turn and recover without losing the
  stacks"); Lord Midas pointed at Unstoppable's `isActiveEntity` check
  (https://discord.com/channels/1006908336991645757/1171689544916156426/1515624706714243192).
- Suspected code: `autopilot/hooks/actor.nut:38-80`. `onTurnEnd` uses `actives.recover` (line 79) before the original
  `onTurnEnd`. Reforged `perk_rf_unstoppable.onAnySkillExecuted` resets stacks on recover only
  `if (::Tactical.TurnSequenceBar.isActiveEntity(actor))`, which is apparently false at that point. Recover also spends
  the AP, so `unstoppable.onTurnEnd` no longer sees "more than half AP left" and keeps (or adds) stacks.
- Mods: Reforged.
- Repro idea: Reforged battle; bro with `perk.rf_unstoppable` at `m.Stacks = 3`, fatigue above
  `FatigueRecoveryRate`, all AP unspent; "Auto reload/recover" defaults on; end the bro's turn manually
  (`initNextTurn`). Assert `Stacks == 0` afterwards (same as using Recover by hand). Also check
  `TurnSequenceBar.isActiveEntity(bro)` at the moment autopilot's `onTurnEnd` runs.

### 4. Turn-order status bar shows the previous actor's effect icons — open
- Sources: BB Modding https://discord.com/channels/965324395851694140/965325048015646770/1421869893275353099
  (ranger.eu, 2025-09-28: a bro with no effect icons gets the previous bro's icons, e.g. a morale debuff, once you hover
  a tile; tooltips on them are empty); confirmed still present on 2.9.0:
  https://discord.com/channels/965324395851694140/1159048664333963305/1531790681763221725 (2026-07-28). Earlier
  variant via Lord Midas (Reforged, 2025-05-15, `log_10.html`):
  https://discord.com/channels/1006908336991645757/1171689544916156426/1372715905850544128 ("Removing AutoPilot solved
  the issue").
- Suspected code: not located. Author: "Don't do nothing to status bar but hack around active entity" — candidates are
  `autopilot/hooks/tactical_state.nut:73-98` (`updateCurrentEntity`) and
  `autopilot/hooks/turn_sequence_bar.nut:138-163` (`convertEntityToUIData` / `convertEntitySkillsToUIData`), plus
  `ui/mods/autopilot_new.js`.
- Repro idea (UI-data level): two player bros, A with `effects.shaken` (or any status effect), B with none. A acts and
  ends turn, B becomes active; collect the status-effect payload sent to JS for the active entity (spy on
  `m.JSHandle.call` of `turn_sequence_bar`, or call the routine that builds active-entity status icons). Assert B's
  payload has no effects. Compare with the mod's hooks disabled.

### 5. Pressing AI while a skill (Aimed Shot) is selected makes the archer shoot until out of ammo — open (low priority)
- Source: Reforged thread https://discord.com/channels/1006908336991645757/1171689544916156426/1291318476555685960
  (sarleon_., 2024-10-03, 2.4.0, "it's helped me cheese"); author acknowledged, not fixed.
- Suspected code: `autopilot/hooks/turn_sequence_bar.nut:87-104` `onAIButtonPressed` enables AI without clearing
  `Tactical.State`'s selected skill/action state (compare with the cleanup in `tactical_state.nut:36-42`).
- Repro idea: bro with a bow; `Tactical.State.setActionStateBySkillId("actives.aimed_shot")`; then turn AI on; run 3
  rounds. Assert `Tactical.State.m.CurrentActionState == null` after enabling AI and shots per turn ≤ what AP allows.

### 6. Quick-switch on a non-player player-faction entity crashes: `getPerkPoints` does not exist — unclear
- Source: log `service/data/logs/Legends/1434517398211264534/log.html` (Legends help, "Sellswords Updated (SSU)"
  thread, Autopilot New ~2.6.2, Legends + SSU + Bro Studio + Plan Perks).
- Error:
  ```
  Script Error: the index 'getPerkPoints' does not exist
    at addCharacterToUIData -> scripts/ui/global/data_helper.nut : 364
    at convertStashAndEntityToUIData -> scripts/ui/global/data_helper.nut : 200
    at -> autopilot/hooks/tactical_state.nut : 41   (swapToItem)
    at -> autopilot/hooks/tactical_state.nut : 51   (turnsequencebar_onEntitySkillClicked)
  ```
- Suspected code: `autopilot/hooks/tactical_state.nut:35-57` — `swapToItem` goes through
  `m.CharacterScreen.onEquipBagItem`, which builds character-screen UI data that assumes a `player`. Quick-switch
  buttons are offered to any entity with `querySwitchableItems` (`turn_sequence_bar.nut:150-163`).
- Repro idea: put a non-player human (e.g. charmed enemy, or a Legends/SSU summon) in the player faction with a weapon
  in its bag; make it active; click its quick-switch item id (`turnsequencebar_onEntitySkillClicked(item.getInstanceID())`).
  Assert no script error (either the swap works or no button/no-op).

### 7. Recover used while swallowed by a Nachzehrer — unclear (probably fixed in 2.5.0)
- Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/675?tab=posts&jump_to_comment=154445911
  (warmdecember, 2025-05-21: "at least on previous versions … a bro with recover is swallowed by a tier 3 nacho … uses
  recover while he is swallowed"). Author: "funny bug, never saw it myself".
- Suspected code: `autopilot/hooks/actor.nut:38-40`. The `isPlacedOnMap()` guard added in `3f44046` (2024-11-12, 2.5.0
  "speculative crash fix") should skip a swallowed (removed from map) bro, but this is untested.
- Repro idea: bro with full AP and fatigue above `FatigueRecoveryRate`; a Nachzehrer (`nachzehrer_alpha`) uses
  `actives.swallow_whole` on him during his turn, or end his turn after `removeFromMap`. Assert no `actives.recover`
  use and fatigue unchanged.

### 8. Stronghold mod fights: allied mercenaries are not automated — unclear / by design
- Sources: Nexus bug https://www.nexusmods.com/battlebrothers/mods/675?tab=bugs&issue_id=947209 (Needs more info, +1
  in 2026-02); posts https://www.nexusmods.com/battlebrothers/mods/675?tab=posts&jump_to_comment=154264770 and
  https://www.nexusmods.com/battlebrothers/mods/675?tab=posts&jump_to_comment=170094812 (2026-05-25: player-controlled
  town mercenaries are not auto, "68 vs 37" fights). Author: Stronghold has an option to let them fight on their own.
- Suspected code: `autopilot/hooks/turn_sequence_bar.nut:9-20` — `canAuto` requires a `player_agent`/no agent, not a
  guest; Stronghold allies controlled by the player are probably non-`player` or guests.
- Repro idea: a player-controlled ally that is not `scripts/entity/tactical/player` (or `isGuest()`), turn AI on.
  Assert the documented behavior: it is skipped and does not block the turn order (turn passes to the player, no hang).

### 9. Turn stuck on an unarmed bro: `isTurnDone` does not exist in `ai_engage_melee` (Legends) — unclear
- Source: Nexus bug https://www.nexusmods.com/battlebrothers/mods/675?tab=bugs&issue_id=886381 (Needs more info;
  invernalx 2024-12-05 and DanijelSBL 2025-02-24, 2.5.1, Legends).
- Error: `the index 'isTurnDone' does not exist` at `onEvaluate -> scripts/ai/tactical/behaviors/ai_engage_melee.nut :
  1032`, then endless `resuming dead generator` at `behavior.nut : 77` via `autopilot/verbose.nut : 15`.
- Suspected code: not located. Legends `ai_engage_melee` (line 1032) calls `isTurnDone()` on something that is not an
  actor, probably an entry of known allies/opponents. Autopilot wraps those in a WeakTableRef descendant (delayed melee
  kill fix, `autopilot/fixes.nut` after line 236), which may lack `isTurnDone`.
- Repro idea: Legends, unarmed bro (no mainhand, fists), enemy in melee range, AI on. Assert no script error and the
  turn ends. Also call `isTurnDone()` on the autopilot ally/opponent wrappers.

### 10. Wait-all confirmation popup becomes unresponsive — unclear
- Source: Nexus post https://www.nexusmods.com/battlebrothers/mods/675?tab=posts&jump_to_comment=136011837
  (Thefighter52, 2024-04-10, log on mediafire, not answered). Occasional; music plays, Yes/No buttons don't react.
- Suspected code: `autopilot/hooks/turn_sequence_bar.nut:30-40` `onWaitTurnAllButtonPressed` (popup callback calls
  `initNextTurnBecauseOfWait`).
- Repro idea: press wait-all (`onWaitTurnAllButtonPressed` → confirm) at different moments: during the active bro's
  move animation, at round end, when the active entity is the last one. Assert the dialog closes and the turn moves on.

### 11. Freeze after SSU Lorekeeper / Fallen Hero bros end their turn (Legends + SSU) — unclear
- Source: Legends thread https://discord.com/channels/547043336465154049/1171689990439321620/1292528729460834405
  (oldbudss, 2024-10-06, 2.4.0, logs attached; suspects SSU "Stoic Focus"). Author: "might be some SSU
  incompatibility". No follow-up.
- Repro idea: only with SSU loadable: Lorekeeper origin, AI on; assert those bros' turns end.

## Fixed

| # | Bug | Fixed in | Sources |
|---|-----|----------|---------|
| 12 | Throwing nets used although "Throw Nets" is off (Reforged tags `throw_net` with `AIBehaviorID`) | 2.9.0 (`8b55a13`) | https://discord.com/channels/1006908336991645757/1171689544916156426/1522231585854849095 (hzlt, log) |
| 13 | Duplicate quick-switch buttons, and AI UI missing, with Extra Keybinds | 2.9.0 (`162de44`) | Nexus https://www.nexusmods.com/battlebrothers/mods/675?tab=posts&jump_to_comment=159408274; https://discord.com/channels/1006908336991645757/1171689544916156426/1521179832090628236; https://discord.com/channels/547043336465154049/1171689990439321620/1418394329399169137 |
| 14 | Animals (NgGH Magic Origins spiders/wolves/ghouls, Legends donkey/horse) hang picking up a weapon | 2.7.1 (`15a8274`, test zip `_FIX_ANIMAL2`) | https://discord.com/channels/547043336465154049/1171689990439321620/1486010438243188854 (logs); Nexus bug https://www.nexusmods.com/battlebrothers/mods/675?tab=bugs&issue_id=910936 |
| 15 | Freeze every battle with AC Legends: `the index 'TameChance' does not exist` at `scripts/ai/autopilot_tame.nut : 17` | 2.7.0 (`13391f8`, `_AC_LEGENDS_FIX3`) | log `service/data/logs/Legends/1426366858357117001/log.html`; https://discord.com/channels/547043336465154049/1171689990439321620/1426366858357117001 |
| 16 | Duplicate quick-switch buttons in Legends ≥ 19.1.20 (integrated quickly_swap_items) | 2.7.0 (`cf8bdc1`, `_QUICKLY_FIX1`) | https://discord.com/channels/547043336465154049/1171689990439321620/1406556363244441681 |
| 17 | Reforged 0.7: bros idle on AI, bottom UI disappears; JS `this.mWaitTurnAllButton.enableButton` undefined | 2.6.1 (`23684ed`, `160b682`, `_FIX_REFORGED_1`, `_FIX2`) | https://discord.com/channels/1006908336991645757/1171689544916156426/1358811039122063551; Nexus https://www.nexusmods.com/battlebrothers/mods/675?tab=posts&jump_to_comment=153418359; Nexus bug https://www.nexusmods.com/battlebrothers/mods/675?tab=bugs&issue_id=946526 |
| 18 | Censer of the Diviner: bro always skips turn | 2.6.1 (`021698b`) | Nexus bug https://www.nexusmods.com/battlebrothers/mods/675?tab=bugs&issue_id=941175 |
| 19 | Non-player actor in player faction (Legends Master Necromancer "human carrion") breaks cancel: `the index 'cancelAIControl' does not exist` at `autopilot/hooks/turn_sequence_bar.nut : 71/83` | 2.6.1 (`e08b60a`) | https://discord.com/channels/547043336465154049/1171689990439321620/1331459683072086037; logs `service/data/logs/Legends/1331459683072086037/log.html`, `.../Legends/1204906255576207400/log.html` |
| 20 | Weapons with several attacks of different range (Swordstaff, fencing sword) skip turns | 2.6.0 (`adf3bf9`, `_EXPERIMENTAL3/4`) | Nexus https://www.nexusmods.com/battlebrothers/mods/675?tab=posts&jump_to_comment=132487430; https://discord.com/channels/1006908336991645757/1171689544916156426/1347948035648520274 |
| 21 | Unarmed-mastery bros (Legends) pick up weapons | 2.6.0 (`b3b794b`, `_UNARMED2`) | https://discord.com/channels/547043336465154049/1171689990439321620/1328437784297345024 |
| 22 | Experimental build: `the index 'mapValues' does not exist` at `autopilot/better_attack_default.nut : 20` (unreleased stdlib) | `_EXPERIMENTAL4` / 2.6.0 | https://discord.com/channels/1006908336991645757/1171689544916156426/1348236722353213462; log `service/data/logs/Reforged/1348236722353213462/log.html` |
| 23 | Modern Hooks error: `IsWaitingRound` field already exists in `turn_sequence_bar` (Reforged) | 2.5.2 (`d37c347`; guard at `turn_sequence_bar.nut:6`) | Nexus https://www.nexusmods.com/battlebrothers/mods/675?tab=posts&jump_to_comment=146603190; https://discord.com/channels/1006908336991645757/1171689544916156426/1318631696588996648 |
| 24 | Skills don't work when clicked (`the index 'onSkillClickedFunc' does not exist` at `autopilot/hooks/tactical_state.nut : 47`) | 2.5.1 (`db33eb4`) | https://discord.com/channels/547043336465154049/1171689990439321620/1309922337507905618; log `service/data/logs/Legends/1309922337507905618/log.html` |
| 25 | Delayed melee kill crash/hang (Reforged "Spinning the Flail", `ai_engage_melee.nut : 396`; ifrit arena crash `: 444`) | 2.5.0 (`autopilot/fixes.nut`, "great delayed melee kill fix") | Nexus https://www.nexusmods.com/battlebrothers/mods/675?tab=posts&jump_to_comment=145353375, …&jump_to_comment=143292930 |
| 26 | Status effect icons vanish for the next bro after manual wait | 2.5.0 | https://discord.com/channels/547043336465154049/1171689990439321620/1291414807010086964 |
| 27 | Bannerman with banner hangs (`resuming dead generator`, `autopilot/better_behavior.nut : 26`) | tracker "Fixed" (version not stated, likely 2.5.0) | Nexus bug https://www.nexusmods.com/battlebrothers/mods/675?tab=bugs&issue_id=863000 |
| 28 | Pets/non-players without `querySwitchableItems` (NgGH Well Trained Pets, AC): `the index 'querySwitchableItems' does not exist` at `autopilot/hooks/turn_sequence_bar.nut : 155`; AC pets have no action buttons | 2.3.0 (`8352dd6`) | log `service/data/logs/Legends/1204906255576207400/log.html`; Nexus bug https://www.nexusmods.com/battlebrothers/mods/675?tab=bugs&issue_id=745537 |
| 29 | Weapon broken at 0 durability: can't switch to the bag weapon / turn stuck | 2.2.0, extra fix 2.5.0 | Nexus bug https://www.nexusmods.com/battlebrothers/mods/675?tab=bugs&issue_id=838517; post …&jump_to_comment=136228395 |
| 30 | Stale JS error `this.mWaitAll.button` in `autopilot_new.js:109` (UI not showing) | stale per author (code gone) | Nexus bug https://www.nexusmods.com/battlebrothers/mods/675?tab=bugs&issue_id=950243; post …&jump_to_comment=158947291 |

Repro ideas for the fixed ones (regression tests), most valuable first:
- #14: NgGH-like non-human player entity with `ai_pickup_weapon` and a weapon on its tile; AI on; assert turn ends and
  `m._apSkipPickup` is set after the first failed pickup.
- #19: spawn a non-`player` actor into the player faction (`Const.Faction.Player`), AI on, then cancel
  (`onCancelButtonPressed`); assert no error and `IsOnAI == false`.
- #12: Reforged bro with a net in offhand and `perk.rf_*` net perks, "Throw Nets" off; AI on; assert agent has no
  `ThrowNet` behavior and no net is thrown in 3 rounds.
- #20: bro with a weapon whose attacks differ in range (Reforged swordstaff; vanilla: a polearm vs adjacent enemy);
  enemy only reachable by one of the skills; assert an attack is made, not a skip.
- #25: kill an enemy with a delayed (scheduled) melee hit while another bro is evaluating; assert no access to a dead
  actor (no `resuming dead generator`).
- #28: AC/vanilla dog in player-animal faction becomes active with AI on; assert `convertEntitySkillsToUIData` works.
- #29: bro whose mainhand weapon breaks (condition → 0) mid-turn with a spare weapon in the bag; assert it switches
  and the turn ends.

## Not Autopilot bugs (errors that only pass through its wrappers)
- Legends `legend_piercing_bolt/shot_skill.getAffectedTiles()` returning null → `_nexti failed` / `cannot iterate
  null` in `ai_attack_bow.nut : 182` (Legends, fixed by Legends 2025-04):
  https://discord.com/channels/547043336465154049/1171689990439321620/1360919474169188573, logs
  `service/data/logs/Legends/1350406019276341348/`, `.../1360912928462868510/`.
- Reforged Command behavior looping (reported to Reforged by the author,
  https://discord.com/channels/1006908336991645757/1171689544916156426/1333445672686321715); Legends Vala
  spiritual bond `onDamageReceived` null arithmetic; SSU AoO crash; Sellswords `aimed_shot` `isAttackable`; MaJin's
  Retinue & Cart Expansion changing `bandage_ally_skill.onVerifyTarget` signature (Modern Hooks warning,
  Nexus …&jump_to_comment=176104680); `ai_attack_knock_out` / hitchance-adj `DefenderProperties`; translated
  launcher/Chinese files (Nexus bug 946526 follow-up); broken Reforged repack (Reforged 2025-06-22).

## Feature requests / by design (skipped)
Friendly fire by ranged/AoE bros (many requests; partly reduced in 2.7.1/2.8.0); per-bro auto toggle; a "don't use
ranged/AoE" option; keybind for AI start (Q added in 2.8.0); voice of Davkul, Perfect Focus, Legends Vala/Druid skills,
slingshot, Time-Crossing Commando, dragonslayer skills not used (need behaviors or `AIBehaviorID`); guests (elder's son,
hunters, monster-hunt archers) not automated (intentional); more defensive/aggressive modes; lute bards charging;
ranged bros not switching to melee when out of ammo until an enemy is adjacent.

## Discord deep search (2026-11-12)

Source: systematic Discord search (`autopilot`, `autopilot_new`, `hackflow`, author/mentions) over Legends, Reforged
and BB Modding; ~600 autopilot hits after 2023-09, ~20 contexts read, 10 logs downloaded to
`service/tools/discord_deep/discord_logs/`. Only reports not already above. AP versions by tag date:
2.3.1 2024-09-12, 2.4.0 2024-10-03, 2.5.0 2024-11-23, 2.5.3 2025-01-13, 2.6.2 2025-05-26, 2.7.0 2025-11-20.

### 31. `division by zero` in `getFatigueScoreMult` from AP's attack-default rewrite, hit by an enemy — open
- Source: Reforged #hardened https://discord.com/channels/1006908336991645757/1138845062969704509/1383466229917945856
  (ucross, 2025-06-14, AP 2.6.x; repeated twice, screenshot 1383469117583130727). Log too big to post; error pasted.
- Mods: Reforged + Hardened (+ Reforged AIAgentFixes experimental module).
- Symptoms: freeze when an enemy (Raider captain "Guntbert the Pickpocket") breaks free of a net and keeps AP:
  ```
  evaluate -- Guntbert the Pickpocket (919779), NextBehaviorToEvaluate: 5 (Attack.Default)
  Script Error: division by zero
    getFatigueScoreMult -> scripts/ai/tactical/behavior.nut : 893
      maxFatigue = 63, currentFatigue = 63, fatigue = 0, apPct = 0.444444
    -> autopilot/better_attack_default.nut : 48
      __original = Function, score = 0.325079
  ```
  Vanilla `0.4 + (1.0 - fatigue / (maxFatigue - currentFatigue)) * 0.6` with `fatigue` an integer `0` (from
  `Math.max(0, …)`) and fatigue full → integer division by zero. Vanilla `ai_attack_default` has the same call, but
  AP's rewrite replaces it for **every** entity whose behavior class is exactly `ai_attack_default`, enemies included
  (TODO "apply for our bros only" at the top of the hook), and picks any `isUsable() && isAffordable()` skill, so a
  zero-fatigue skill at full fatigue reaches it.
- Suspected code: `autopilot/autopilot/better_attack_default.nut:48` (`score *= this.getFatigueScoreMult(this.m.Skill)`),
  hook scope at lines 13–17.
- Repro idea: tactical scene with an enemy brigand whose fatigue == max fatigue, one usable 0-fatigue attack and an
  adjacent bro; run `ai_attack_default.onEvaluate(enemy)` (or let the AI take a turn). Assert no script error and
  a finite score. Same for an AP-controlled bro at full fatigue.

### 32. Reforged ≥ 0.8 (Kata Step removed): AP ≤ 2.6.2 tries `ai_rf_kata_step` on every AI setup; freeze on end turn — fixed in 2.7.0 (log noise), freeze unclear
- Source: Reforged #hardened https://discord.com/channels/1006908336991645757/1138845062969704509/1467875389979496519
  (guardianspear, 2026-02-02, "freeze on me trying to end my turn"), Darxo's diagnosis
  https://discord.com/channels/1006908336991645757/1138845062969704509/1468453775462371462 (user: "didn't do any
  autopilot"). Log `service/tools/discord_deep/discord_logs/reforged_1467875389979496519_log.html` (AP 2.6.2).
- Mods: Reforged + Hardened.
- Symptoms: at 22:31:51, 18 s into bro Hjalmar's turn, 12 back-to-back
  ```
  Failed to load script file "scripts/ai/tactical/behaviors/ai_rf_kata_step.(nut/cnut)". Reason: File not found.
  Failed to create new instance from "scripts/ai/tactical/behaviors/ai_rf_kata_step". Reason: Script not found.
  ```
  then the player quits to menu. No script error; the only other error is Hardened's `possessed_undead_effect.nut : 115`
  (`isAlive` on a dead weakref). So 12 AI-agent setups happened at once (AP's AI button/hotkey or all-auto), the
  missing script itself is guarded (`addBehavior(..., false)`), the freeze cause is not visible.
- Code: AP 2.6.2 `autopilot/autopilot/hooks/player.nut:145`; replaced by `AIBehaviorID` lookup in `66f068b` (2.7.0).
- Repro idea: Reforged (current) + AP HEAD: start a battle, enable AI for all bros, assert no "Failed to load script"
  for `scripts/ai/tactical/behaviors/*` in the log and every bro's agent has its skill behaviors; let one full round
  run and assert the round advances (no stuck turn).

### 33. Hardened Throwing Mastery breaks AP quick-switch buttons: `the index '0' does not exist` — unclear (bandaid in Hardened)
- Sources: Reforged #general https://discord.com/channels/1006908336991645757/1283857645492502549/1294698028250173520
  (Darxo, 2024-10-12: "Hardened is currently slightly incompatible with Autopilot New, only with Throwing Mastery");
  log https://discord.com/channels/1006908336991645757/1283857645492502549/1294687416891736217 →
  `service/tools/discord_deep/discord_logs/reforged_1294687416891736217_log.html`; discussion in BB Modding AP thread
  https://discord.com/channels/965324395851694140/1159048664333963305/1294721320550010950 (MSU issue #435; Darxo
  "will implement a bandaid in my mod").
- Mods: Reforged + Hardened, AP 2.3/2.4.
- Symptoms: UI breaks for a bro with Throwing Mastery (turn-sequence skill bar data fails):
  ```
  Script Error: the index '0' does not exist
    at -> mod_hardened/hooks/skills/perks/perk_mastery_throwing.nut : 48   (_items = Array)
    at -> msu/hooks/skills/skill_container.nut : 511
    at -> msu/hooks/items/item_container.nut : 19
    at -> msu/hooks/items/item_container.nut : 9
    at -> autopilot/hooks/player.nut : 152                                  (querySwitchableItems)
    at -> autopilot/hooks/turn_sequence_bar.nut : 161                       (convertEntitySkillsToUIData)
  ```
  AP calls `isActionAffordable([item])` (one element when the slot is empty) and `isActionAffordable([])`; vanilla
  always passes `[current, new]` pairs, and Hardened's hook indexed into the array.
- Suspected code: `autopilot/autopilot/hooks/player.nut:227` (`[currentItem, item] : [item]`) and
  `autopilot/scripts/ai/autopilot_swap_quiver.nut:17` (`isActionAffordable([])`, added 2.8.0) — still the same shapes.
- Repro idea: Reforged + Hardened if loadable (else stub a `getItemActionCost(_items)` hook that reads `_items[0]`):
  bro with Throwing Mastery, a throwing weapon in the bag and an empty hand; build
  `convertEntitySkillsToUIData(bro)` and run `autopilot_swap_quiver.onEvaluate`. Assert no error.

### 34. Crash when auto-retreat makes AP use end-of-turn skills (ifrits) — fixed in 2.4.0
- Source: Reforged help https://discord.com/channels/1006908336991645757/1285943503469150228/1285943503469150228
  (thought_follower, 2024-09-18, "no crash with autopilot removed"; test build `mod_autopilot_new_2.3.1_fleeing.zip`
  did not help); log `service/tools/discord_deep/discord_logs/reforged_1285971228192145551_log.html`. Fix `00d60f1`
  "really do not autouse skills when retreating" (2024-10-03), CHANGELOG 2.4.0 "fixed crash when retreating".
- Mods: Reforged, MSU.
- Error:
  ```
  [critical] Core: Script Stacktrace:
    at unknown -> NATIVE : -1
    at -> msu/hooks/skills/skill.nut : 313
    at tryUseSkill -> autopilot/hooks/actor.nut : 46
    at -> autopilot/hooks/actor.nut : 80
    at initNextRound -> .../turn_sequence_bar.nut : 314
    at -> autopilot/hooks/turn_sequence_bar.nut : 21
  ```
- Code now: `autopilot/autopilot/hooks/actor.nut:39-40` checks `!::Tactical.State.isAutoRetreat() && isPlacedOnMap()`.
- Repro idea: battle with a bro having bandages/a loaded crossbow; trigger auto-retreat (`Tactical.State` retreat);
  advance a round. Assert no skill `use()` from `onTurnEnd`, no error.

### 35. Reforged tooltip error on AP buttons: `the index 'extend' does not exist` — fixed in 2.5.0 (likely)
- Source: Reforged help https://discord.com/channels/1006908336991645757/1284950853362520218/1284950853362520218
  (uguu1220, 2024-09-15, AP 2.3.x; the reported freeze was a Hybridization weapon swap, gone after removing AP
  https://discord.com/channels/1006908336991645757/1284950853362520218/1286746147452616808, but the user also ran an
  outdated game exe); log `service/tools/discord_deep/discord_logs/reforged_1284950853362520218_log.html`.
- Mods: Reforged, Swifter.
- Error (hovering AP's turn-bar buttons):
  ```
  Script Error: the index 'extend' does not exist
    at -> mod_reforged/hooks/ui/screens/tooltip/tooltip_events.nut : 39   (_elementId = ...AIButton / ...CancelButton)
    at -> swifter/tooltip_events.nut : 6
    at -> scripts/!mods_preload/mod_autopilot_new.nut : 68
  ```
- Code now: tooltips moved to `autopilot/autopilot/hooks/tooltip_events.nut` (`534cdbe`, 2024-10-15, first in 2.5.0).
- Repro idea: Reforged + AP: call `TooltipEvents.general_queryUIElementTooltipData(null, id, null)` for every AP button
  id in `::Autopilot.Tooltips`; assert an array comes back and no error.

### 36. Critical exception on a skill hotkey (Aimed Shot) — unclear, probably not AP
- Source: Legends AP thread https://discord.com/channels/547043336465154049/1171689990439321620/1330914917917659240
  (oldbudss, 2025-01-20, AP 2.5.x); log `service/tools/discord_deep/discord_logs/legends_1330914917917659240_log10.html`.
- Mods: Legends 19.0.
- Error:
  ```
  [critical] Core: Script Stacktrace:
    at selectSkillById -> scripts/ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar.nut : 763
    at setActionStateBySkill -> scripts/states/tactical_state.nut : 1168
    at setActionStateBySkillIndex -> scripts/states/tactical_state.nut : 1094
    at -> autopilot/hooks/tactical_state.nut : 62
    at helper_activateSkillByKey -> scripts/states/tactical_state.nut : 3011
    at helper_handleContextualKeyInput -> scripts/states/tactical_state.nut : 4037
    at -> autopilot/hooks/tactical_state.nut : 16
  ```
  Native crash inside vanilla `selectSkillById` (`JSHandle.asyncCall`); AP only forwards (`__original(index)`).
- Suspected code: `autopilot/autopilot/hooks/tactical_state.nut:59-68` forwards when `isInputLocked()` is true too,
  vanilla returns early then anyway — so likely not AP.
- Repro idea: AP bro on AI control (input locked) — press a skill hotkey; assert no `asyncCall`, no error.

### Extends existing
- #17 (Reforged 0.7 JS `this.mWaitTurnAllButton.enableButton`): Reforged help thread
  https://discord.com/channels/1006908336991645757/1369635691516137514/1370231864517726349 (hackflow 2025-05-09: "js
  errors … new clash between Reforged and Autopilot New"); log `discord_logs/x_1369881243751157781/log.html`
  (from `reforged_1369881243751157781_log.zip`): AP 2.5.3, 76× `TypeError: undefined is not an object (evaluating
  'this.mWaitTurnAllButton.enableButton')`. Same thread: Retinue Promotions old release spams `faction.update` logs
  (hackflow 1370229959804583937) — for retinue_ups; the `RF_PowerShot` error is a stale Reforged perk file, not AP.
- #14 (animals hang): earliest report — Legends AP thread
  https://discord.com/channels/547043336465154049/1171689990439321620/1230965860034809948 (2024-04-19, "fight hangs
  when one of my spiders moves", Magic Concept charmed spiders, AP 2.2.x); log
  `discord_logs/legends_1230966452685901894_log.html` has no AP error (hang, not crash).
- #26 / #4 (status icons): "the status effect bug is still happening" after 2.5.0 —
  https://discord.com/channels/547043336465154049/1171689990439321620/1330914917917659240 (2025-01-20).
- Not-AP list: Reforged Command loop — also hackflow's own report
  https://discord.com/channels/1006908336991645757/1333445407417565196/1333445407417565196.

### Not AP bugs / skipped
- Legends temp-roster crash (villagers/envoys) `updateVisibilityForFaction` at `actor.nut : 524`, AP only in the stack
  (`turn_sequence_bar.nut : 22`): fixed by Legends patch 19.0.26 —
  https://discord.com/channels/547043336465154049/1348270958191972402/1348270958191972402, log `discord_logs/legends_1348270958191972402_log.html`.
- MSU `onBeforeAnySkillExecuted` on a broken weapon (hackflow's report to MSU,
  https://discord.com/channels/965324395851694140/1288492816976318486/1307567043339358291, log
  `discord_logs/bbmodding_1307567642009145465_msu-bug-broken-weapon.html`) — MSU, AP frames are `verbose.nut` wrappers.
- MSU `skill_container.nut : 50` "value … not acceptable" in `onMovementFinished` (Legends 2024-02-19,
  `discord_logs/legends_1208949602846376006_log.html`) — AP only `verbose.nut : 21` / `tactical_state.nut : 95` wrappers.
- Magic Concept magic missile disappearing with AP (Legends 2025-06-04, 871363654610726922/1379721482082582580) — MC
  side, AP has no MC code; MC wraith.nut conflict (2023-11-16, Adam-hooks AP) — stale.
- Fleeing webknecht ZoC crash (happens without AP), "save corruption" claim with no log (2025-11-04), handgonne and
  "debug log dump" guesses by Reforged devs — no evidence.
- Archers shooting allies (Reforged 2025-12-13) — known feature request (friendly fire).


## Repro status (scenario tests, 2026-11-12)

Headless tests in this dir (`README.md`; details, causes and line refs in `FOUND_BUGS.md`), on HEAD and
on the released 2.9.0 zip (`run_released.sh`), same result on both:

- Reproduced, test fails: #1 (`tale_kb1_throwing.nut`, `tale_kb1_firelance.nut`: the users' `getAmmoType` stack,
  the turn never ends), #2 (`known_bugs::KB2` ×2), #3 (`reforged::KB3`: Recover runs while the bro isn't
  the active entity, stacks stay 3), #6 (`known_bugs::KB6`).
- Partly reproduced, test fails: #5 (the selected skill state survives switching to AI; no extra
  shots seen), #9 (`ActorFake` lacks `isTurnDone`/`getCurrentProperties`, which vanilla `ai_protect`
  calls on known allies).
- Not reproduced, open, cause unknown: #10. The mechanism tried (a second wait-all request before the popup shows
  leaves a stale `MenuStack` backstep) fails only on the engine, whose `DialogScreen.show` starts animating a frame
  late; the original and the real page drop the second request (FOUND_BUGS, "KB10 in the original game").
- Not reproduced, test passes: #4 (Squirrel UI data is right: JS-side), #31 (max fatigue is a float in
  vanilla and Reforged, so no integer division), #36.
- By design, test passes: #8 (a guest).
- Fixed, regression passes: #12, #19, #20, #28, #29, #34, #35.
- Not testable here (mods or UI not available): #7 (no turn while swallowed), #11, #13–#18, #21, #32, #33.
- New: A1–A5 in `FOUND_BUGS.md` (player-only methods called on non-player allies: number key and AI
  button; a bro charmed when AI is pressed stays manual; NaN attack weights; tooltip for a gone entity).

## Repro status (Discord section)

Headless tests, 2026-11-12 (`FOUND_BUGS.md`, "Discord deep search: #31 again"):

1. #31 — **reproduced, not an Autopilot bug**: `discord_bugs::KB31` (Autopilot) and `discord_bugs_vanilla::KB31`
   (without it) both fail with `division by zero` once the thug's max fatigue is an integer, as Hardened's
   `getFatigueMax()` returned before its `76ba4f3` (2025-06-21, `Math.max` → `Math.maxf`). Vanilla's
   `ai_attack_default` makes the same call on the same skill filter. The float max fatigue of vanilla and
   Reforged is why `kb31*.nut` passes.
2. #32 — not tested beyond `tale_reforged.nut`'s AI battle on HEAD (AIBehaviorID lookup since 2.7.0); AP 2.6.2 not
   available here.
3. #33 — not feasible (Hardened).
4. #34, #35 — fixed, regressions pass (`edge::KB34`, `reforged::KB35`); #36 passes (`edge::KB36`).

### With real third-party mods (2026-11-12)

Legends 19.4.23, Reforged 0.9.3 + Hardened 1.26.3 (`tale_legends_summons.nut`, `tale_legends_summons_noap.nut`,
`tale_legends_bugs.nut`, `tale_hardened_bugs.nut`; details in `FOUND_BUGS.md`, "With real third-party mods"):

1. #6 — **reproduced** with a Legends skeleton/zombie summon: the users' `the index 'getPerkPoints' does not exist`
   (`legends_summons::KB6`, `::A1` ×2). Also without Autopilot (`tale_legends_summons_noap.nut`, 3 fail): Legends'
   integrated quickly_swap_items has the same bug.
2. #9 — **reproduced** through Legends' real `ai_engage_melee` (`legends_bugs::KB9 … gone known ally`): `ActorFake`
   lacks `isTurnDone`; the unarmed bro on AI passes.
3. #21 — **regressed** (new A6): the fix checks `perk.legend_mastery_fist`, Legends renamed it
   `perk.legend_mastery_unarmed` on 2025-01-18 (`legends_bugs::KB21`).
4. #33 — not reproduced: Hardened 1.26.3 no longer indexes `_items` (`hardened_bugs::KB33` passes). #32, #31 pass
   under Reforged 0.9.3 + Hardened (`hardened_bugs::KB32`, `::KB31 Hardened`).
5. #16 (fixed) and #36 pass on Legends; A2 not reproduced with Legends' summons (they have `isGuest`, `idle_agent`).
6. #11 — not feasible: SSU 8.5.2 doesn't boot on Legends 19.4.23 (`BanditVeteran`), and older Legends need
   vanilla < 1.5.2. NgGH (for A1/A2/#14 beasts) doesn't boot on it either.

