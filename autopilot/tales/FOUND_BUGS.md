# Autopilot New — bugs found by the scenario tests

Found 2026-11-12 by the headless scenario tests in this dir (README.md), on the working tree (HEAD,
8 unreleased commits after 2.9.0). Code refs are relative to `~/projects/bbm/mods/autopilot/`.
Commands run from `~/projects/bbm/bbtales`. Each test below fails now, the same packed
and with `--isolate`, and was checked against the vanilla scripts (`~/projects/bbm/base/scripts-base/`)
for an engine divergence. "2.9.0" says whether `run_released.sh` (the same test on
`mod_autopilot_new_2.9.0.zip`) fails too: it does for every finding here, so none depends on
unreleased code.

New findings are A1–A5; the repro status of every KNOWN_BUGS.md entry follows.

## A1. Number key past the skills on a non-player ally: `querySwitchableItems` does not exist — low

- Test: `known_bugs::A1: number key past the skills on a non-player ally: no error` —
  `./bbtales.py -k A1 ../mods/autopilot/tales/tale_known_bugs.nut`
- Setup: a bandit thug in the player's faction under human control (player's agent,
  `IsControlledByPlayer`), standing in for Legends/NgGH/SSU player-controlled summons; on his turn
  a number key one past his skills (`setActionStateBySkillIndex(n)`).
- Observed: `ASSERT no error: expected null, got "the index 'querySwitchableItems' does not exist"`.
- Expected: nothing happens, as vanilla does for an index past the skills.
- Cause: `autopilot/hooks/tactical_state.nut:59-68` maps every index past the actives to
  `e.querySwitchableItems()`, which only `player` has (`autopilot/hooks/player.nut:213`);
  `convertEntitySkillsToUIData` checks `"querySwitchableItems" in _entity` (`autopilot/hooks/turn_sequence_bar.nut:152`),
  this path doesn't.
- 2.9.0: same.

## A2. AI button with a non-player ally under the player's control: `isGuest` does not exist — medium (modded)

- **Fixed 2026-11-17**: `canAuto` takes only `player`s; NgGH minions and Hexe-charmed foes keep their own AI
  (NgGH has its own autopilot toggle for minions). Passes code, engine, game.

- Tests: `known_bugs::A2: AI button on a non-player ally's turn: no error` and
  `known_bugs::A2: AI confirmed with a non-player ally in the company: no error, bros on AI` —
  `./bbtales.py -k A2 ../mods/autopilot/tales/tale_known_bugs.nut`
- Observed: pressing AI (button or `Q`) on that ally's turn throws
  `the index 'isGuest' does not exist` at `autopilot/hooks/turn_sequence_bar.nut:17` from
  `onAIButtonPressed` (:87-89); pressing it on a bro's turn and confirming throws the same inside the
  popup's callback, in the loop over `AllEntities` (:95-101).
- Expected: the ally is either automated or skipped, the bros go on AI.
- Cause: `canAuto` (`turn_sequence_bar.nut:15-20`) calls `isGuest()`, a `player` method, on any
  human-controlled entity; KB19's fix guarded `cancelAIControl` only. In the confirm loop every
  entity after the ally in `AllEntities` stays manual (in the test the ally came last, so the three
  bros still got AI). Legends' player-controlled summons and NgGH's beasts are such entities.
- 2.9.0: same.

## A3. A bro charmed when AI is switched on stays manual after the charm ends — low

- **Not a bug** (user, 2026-11-17): pressing AI again takes him in; no reports.

- Test: `edge::A3: a bro charmed when AI is switched on joins AI when the charm ends` —
  `./bbtales.py -k A3 ../mods/autopilot/tales/tale_edge.nut`
- Observed: `ASSERT on autopilot's agent when the charm ends: expected ["military_melee_agent", true],
  got ["player_agent", false]`; he never acts on AI: his turns wait for the player while the rest of
  the company is on AI (`IsOnAI` true).
- Expected: he joins AI once he's the player's again (a bro charmed *after* AI was on does: test
  `edge::charmed on AI: back on autopilot's agent when the charm ends` passes).
- Cause: `onAIButtonPressed` (`autopilot/hooks/turn_sequence_bar.nut:87-103`) enables AI only for the
  entities `canAuto` at that moment; a charmed bro is in the hexe's faction then. Vanilla's
  `charmed_effect.onRemoved` restores the `player_agent` it saved. Nothing re-enables AI later.
  Pressing AI again works around it.
- 2.9.0: same.

## A4. Attack choice goes NaN with a negative-scored option and always takes the last one — low (latent)

- **Fixed 2026-11-17**: a score ≤ 0 weighs 0; passes code, engine, game.

- Test: `known_bugs::A4: attack choice with a negative-scored option still prefers the good one` —
  `./bbtales.py -k A4 ../mods/autopilot/tales/tale_known_bugs.nut` (drives the real
  `ai_attack_default.selectBestTargetAndSkill` with two stub skills and stub scores, 50 picks)
- Observed: options scored `[1.0, -0.5]`: `expected {good = 50}, got {bad = 50}`. Control
  `[1.0, 0.1]` picks mostly the good one.
- Expected: the positive option wins; the negative one (a target next to an ally) is dropped.
- Cause: `autopilot/better_attack_default.nut:81-85` weighs options by
  `Math.pow(score, AttackRangedChancePOW = 1.9)`; a negative score gives NaN, `std.Rand.index` then
  never gets `roll <= 0` and returns the last option. `scoreRangedTarget` (:119-173, the subtraction at :148) makes ranged
  scores negative for targets with allies adjacent (`TargetPriorityHittingAlliesMult = -0.8`). With
  the bad option picked, `onEvaluate` returns `max(0, …)` = 0: the bro doesn't attack at all though a
  good attack exists. Needs a bro with two or more attack skills of which one is ranged (modded
  hybrids); vanilla weapons have one ranged skill per weapon.
- 2.9.0: same.

## A5. Skill tooltip for an entity no longer in battle throws — low

- **Fixed 2026-11-17**: a gone entity gives null; passes code, engine, game.

- Test: `known_bugs::A5: skill tooltip for an entity that is gone: null, as vanilla` —
  `./bbtales.py -k A5 ../mods/autopilot/tales/tale_known_bugs.nut`
- Observed: `onQuerySkillTooltipData(-1, "actives.no_such_skill")` →
  `the index 'getItems' does not exist`; vanilla returns null.
- Cause: `autopilot/hooks/tooltip_events.nut:72-77` calls `entity.getItems()` without checking
  `Tactical.getEntityByID` found one. A hover over a dying entity's skill can ask for it.
- 2.9.0: same.

## Known bugs: repro status

| # | Status | Test | Notes |
|---|--------|------|-------|
| 1 | **fixed** (freeze; 2026-11-15, regression passes in engine and game) | `kb1_throwing::KB1…`, `kb1_firelance::KB1…` | The users' stack exactly: `getAmmoType` at `scripts/ai/autopilot_swap_quiver.nut:26` (the `filter` at :26-28 calls it on throwing weapons/firelance in the bag). Thrown from `onProcessAI` every think, so the turn never ends; here the engine stops the frame. 2.9.0 same. Control `known_bugs::swap quiver…` (full quiver in the bag) passes. |
| 2 | **reproduced** | `known_bugs::KB2…` ×2 | `quickSwitch = false`: the number key and a click with a bag item's id both swap (`got [false, 4]`: weapon changed, 4 AP). `autopilot/hooks/tactical_state.nut:48-68`. |
| 3 | **reproduced** (Reforged) | `reforged::KB3…` | Auto Recover runs with `isActiveEntity(bro) == false`; Unstoppable stays at 3 stacks (Recover by hand resets them, control passes). `autopilot/hooks/actor.nut:79` (before the original `onTurnEnd`, while the bar's active entity is no longer him). |
| 4 | not reproducible headless | `known_bugs::KB4…` passes | The Squirrel side answers each active bro's `onQueryEntityStatusEffects` with his own effects; the stale icons are JS-side (`ui/mods/autopilot_new.js:85-93` or vanilla's JS). |
| 5 | **fixed** 2026-11-17 (AI press calls vanilla `cancelCurrentAction()`; passes code, engine, game) | `known_bugs::KB5…` | After AI is pressed with Aimed Shot selected, `CurrentActionState` stays `SkillSelected` (2) and `SelectedSkillID` `actives.aimed_shot`; but shots stay within AP (1 a round), "shoots until out of ammo" not seen. `autopilot/hooks/turn_sequence_bar.nut:87-103` doesn't clear the state (`swapToItem` does, `tactical_state.nut:35-42`). |
| 6 | **reproduced** | `known_bugs::KB6…` | Same `getPerkPoints` error via `swapToItem` → `onEquipBagItem` (`tactical_state.nut:45`) for a non-player ally. See A1, A2 for the same root (player-only methods on any player-controlled actor). |
| 7 | not reproduced | — | A swallowed bro gets no turn in vanilla, so no end of turn; guard `isPlacedOnMap()` at `autopilot/hooks/actor.nut:40`. Ghoul stress battles pass. |
| 8 | by design, works | `known_bugs::KB8…` passes | A guest stays manual, the turn order goes on. |
| 9 | **fixed** 2026-11-17 (`ActorFake` has `isTurnDone`, `getCurrentProperties`; known_bugs and legends_bugs KB9 pass in engine, game) | `known_bugs::KB9…` | An `ActorRef` whose actor is gone throws `null ActorRef, index = isTurnDone` / `getCurrentProperties`: `ActorFake` (`autopilot/fixes.nut:307-320`) lacks what vanilla `ai_protect.nut:70-72` asks of known allies. Legends' `ai_engage_melee:1032` itself not testable here. |
| 10 | **not reproduced** (open, cause unknown; the mechanism below isn't the original's) | `known_bugs::KB10…` | Wait-all requested twice before the popup is shown (the UI shows it asynchronously, `DialogScreen.isVisible()` is false meanwhile) pushes two `MenuStack` backsteps; one Yes leaves one, which holds the battle's end (`onBattleEndedDelayed` waits for no backsteps) and the keys. One press works (control). Autopilot's `H`/`N`/`Q` handlers don't check `MenuStack.hasBacksteps()` (`turn_sequence_bar.nut:30-52, 87-90`); vanilla's `showDialogPopup` guard has the same gap. Whether this is the users' case is unconfirmed. **Not in the original game**: its `DialogScreen.show` is animating at once, so vanilla's guard drops the second request (KB10 in the original game, below). |
| 11 | not testable | — | Needs SSU. |
| 12 | fixed, regression passes | `reforged::KB12…` (+ control) | |
| 14, 16, 21 | not testable | — | NgGH / Legends. |
| 19 | fixed, regression passes | `known_bugs::A2: AI confirmed…` (its `cancel` assert) | `cancelAutoActions` with a non-player ally: no error. |
| 20 | fixed, regression passes | `reforged::KB20…` | Swordstaff bro attacks (`actives.prong`). |
| 28 | fixed, regression passes | `behaviors::dogs…` | The wardog's turn bar UI data is built every frame of its turns. |
| 29 | fixed, regression passes | `known_bugs::KB29…` | Hand axe breaks, the spare spear is used. |
| 31 | not reproduced | `kb31*::KB31…` pass | Vanilla's `getFatigueMax()` is `Math.floor(…)`, a float in BB, so `fatigue / (max - current)` is a float division (NaN, score 0), not an error; same with Reforged 0.8.18 and without Autopilot. The users' integer division needs a mod making max fatigue an integer (Hardened?). |
| 33 | not testable | — | Needs Hardened. |
| 34 | fixed, regression passes | `edge::KB34…` | Retreat while on AI: Autopilot off, auto-retreat on, no end-of-turn skill used, the company leaves. |
| 35 | fixed, regression passes | `reforged::KB35…` | |
| 36 | passes (not AP) | `edge::KB36…` | A skill key during an Autopilot turn changes nothing. |

Others (13, 15, 17, 18, 22–27, 30, 32) need mods or the UI not available here, or are covered by
the AI battles in general (25: delayed melee kills, 26/27).

## Engine divergences met (not Autopilot bugs)

- An uncaught script error in the tactical state's update (`onProcessAI`) used to stop the engine's
  frame and the launch; since 2026-11-15 the engine logs it and goes on, as the original does.
- None of the findings above depends on an engine divergence: A1, A2, A5, KB2, KB6 are plain
  script errors / script logic; A4 is `pow` of a negative base (NaN in C as in the engine's libm).

## Discord deep search: #31 again (2026-11-12)

- **#31 reproduced with an integer max fatigue**: `discord_bugs::KB31…` (Autopilot) and
  `discord_bugs_vanilla::KB31…` (without it) fail the same way, packed and `--isolate`:
  ```
  PROBE fatigue: types, current, max = ["integer", "integer", 80, 80]
  PROBE skill picked = "actives.chop"
  ASSERT KB31: attack_default's evaluation throws: expected null, got "division by zero"
  ```
  The test gives the thug Hardened's `getFatigueMax()` as it was before its `76ba4f3` (2025-06-21, "fix: rare
  ai crash, when evaluating skills while fully fatigued"): `::Math.max(stamina, min)`, an integer
  (`3rdparty/Hardened/mod_hardened/api/hooks/entity/tactical/actor.nut`, now `::Math.maxf`, with a comment
  naming vanilla's `getFatigueScoreMult`). The user's report (2025-06-14) predates that fix.
- So: Hardened's bug (fixed a week after the report) on vanilla's unguarded division
  (`behavior.getFatigueScoreMult`); vanilla `ai_attack_default` (same `isUsable() && isAffordable()` filter,
  same call) throws too. Autopilot's rewrite only puts its own file in the stack. Not an Autopilot bug;
  a guard in `better_attack_default.nut:48` would only hide it there.

## With real third-party mods (2026-11-12)

Legends 19.4.23, Reforged 0.9.3 + Hardened 1.26.3 (zips and sources: `~/projects/bbm/bbtales/mods/VERSIONS.md`) with
Modern Hooks 0.7.0 + MSU 1.9.0 + stdlib. Files: `tale_legends_summons.nut`, `tale_legends_summons_noap.nut` (the
same input without Autopilot), `tale_legends_bugs.nut`, `tale_hardened_bugs.nut`, helpers `lib/legends_helpers.nut`.
Summons are raised with Legends' own `legend_spawn_skeleton_low_skill` / `legend_spawn_zombie_low_skill` and a
stash item, as a necromancer does (then toughened so the thugs don't kill them before their turn). 17 tests,
8 fail; packed and `--isolate` give the same statuses and asserts, three packed runs in a row too.

### A6. Legends' unarmed mastery is no longer recognised: unarmed bros pick weapons up again (KB21 regressed) — low

- Test: `legends_bugs::KB21 Legends: a bro with Legends' unarmed mastery gets no pick-up-weapon behavior on AI`
- Observed: `PROBE perk id = "perk.legend_mastery_unarmed"`, `ASSERT no PickupWeapon behavior: expected false, got true`.
- Cause: the #21 fix (`b3b794b`, 2025-01-17) checks `hasSkill("perk.legend_mastery_fist")`
  (`autopilot/hooks/player.nut:158`); Legends renamed the perk to `perk.legend_mastery_unarmed` the next day
  (Legends `97f6434bae`, 2025-01-18, "Rename mastery fists to mastery unarmed"), so the check never matches since.
- **Fixed 2026-11-17**: both IDs checked; passes engine and game.

### KB6 reproduced on Legends 19.4.23 — Legends' own bug as well

- Tests: `legends_summons::KB6 …`, `legends_summons::A1 …` (skeleton and zombie): the number key past the skills
  or a click on a bag item's id on a Legends summon's turn throws the users' error verbatim:
  `the index 'getPerkPoints' does not exist` (vanilla `data_helper.addCharacterToUIData` via
  `CharacterScreen.onEquipBagItem`). Summons: `legends_skeleton_low` / `legends_zombie_low`, player-controlled,
  `idle_agent`.
- `tale_legends_summons_noap.nut` (Legends without Autopilot) fails the same three ways: Legends 19.1.20+ integrated
  quickly_swap_items (`mod_legends/hooks/states/tactical_state.nut:7-72`: `swapToItem`,
  `turnsequencebar_onEntitySkillClicked`, `setActionStateBySkillIndex`) and adds `querySwitchableItems` to every
  actor (`mod_legends/hooks/entity/tactical/actor.nut:32`), so Legends offers bag items to summons and swaps them
  through the player-only character screen. With Autopilot its `swapToItem` replaces Legends' (Modern Hooks warns
  `adding a new function swapToItem … already exists`), same call, same error. A1's `querySwitchableItems` error
  can't happen on Legends (every actor has it); it turns into this one.
- Fix on Autopilot's side: in `swapToItem` / the two input hooks, do nothing for an entity that isn't a `player`.

### KB9 reproduced with Legends' real `ai_engage_melee`

- Test: `legends_bugs::KB9 Legends: engage melee with a gone known ally evaluates without an error`: a pikeman on
  Autopilot (ideal range 2), his agent's known allies holding an `ActorRef` whose actor is gone; Legends'
  `ai_engage_melee.onEvaluate` asks it `isTurnDone()` (`mod_legends/hooks/ai/tactical/behaviors/ai_engage_melee.nut:61`,
  also `:1178`). Observed: `null ActorRef, index = isTurnDone<not-set>` thrown (warning
  `autopilot: null ActorRef, crashing isTurnDone`). The users' 2.5.1 error `the index 'isTurnDone' does not exist`
  is the same gap seen before AP's `ActorFake` existed; `ActorFake` (`autopilot/fixes.nut:310-323`) still lacks
  `isTurnDone`.
- The weak ref is nulled by hand: this engine collects unreachable objects only when a battle ends (runner README),
  the original's refcounting drops a dead actor at once. The natural case (`KB9 Legends: an unarmed bro on AI ends
  his turns, no error`, fists and `hand_to_hand`) passes.
- Fix: give `ActorFake` `isTurnDone() { return true }` (and `getCurrentProperties`, `isArmedWithMeleeWeapon`,
  `getIdealRange`, `getActionPoints`, which the same loops ask).

### Passing with the real mods

- `legends_summons::Legends: AI battle, autopilot plays it through`; `KB16 fixed Legends` (one quick-switch
  button per bag item: Autopilot turns its own off, `::Autopilot.quickSwitch == false` under Legends);
  `KB36 Legends` (a skill key during an Autopilot turn does nothing).
- A2 is **not** reproduced with Legends' summons: they have `isGuest()` and an `idle_agent`, so `canAuto` is false
  for them (the AI button on a summon's turn does nothing; confirming AI on a bro's turn puts the bros on AI; KB19's
  cancel passes). A2 stays a risk for summons without `isGuest` (NgGH; not loadable, see below).
- `hardened_bugs::KB33` passes: Hardened 1.26.3's `perk_mastery_throwing.getItemActionCost` iterates `_items`
  (no `_items[0]` any more), as do Reforged 0.9.3's and Legends' other `getItemActionCost` implementations;
  with the free swap on, `isActionAffordable([axe])` and `([])` are true, buttons build, no error.
- `hardened_bugs::KB32` passes: an AI battle under Reforged 0.9.3 + Hardened, 37–47 behaviors per bro, no
  `Failed to load script`, no stuck turn. `KB31 Hardened` passes: Hardened's max fatigue is a float now.

### Not feasible

- #11 (SSU Lorekeeper / Fallen Hero): SSU 8.5.2, the newest, doesn't boot on Legends 19.4.23
  (`the index 'BanditVeteran' does not exist`, `mod_sellswords/config/spawnlist_bandits.nut:1`, then
  `IsLowerVanity` in Legends' crafting); the Legends versions it was made for need vanilla < 1.5.2. Legends'
  Discord thread is titled "Sellswords Updated (SSU) (incompat since 19.3)".
- NgGH beasts for A1/A2/#14: NgGH 3.0.0-beta.90 doesn't boot on Legends 19.4.23 (`LegendFavouredEnemyGhoul`).
- No engine divergence found by these tests beyond the known garbage-collection timing (KB9 above).

## Stable RNG (2026-11-12): five tests had passed on one launch's luck

With the RNG following each test's seed (bbtales's default now) five tests failed; none is a mod bug, each test
assumed something the rolls decided, and now sets it up or asserts the behaviour instead (they pass with and without
`--no-stable-rng`, in code, engine and ui):

1. `behaviors::unbag shield…`: `his first AI action: expected "autopilot_unbag_shield", got "ai_engage_melee"`, the
   shield still on in round 1. Which behavior scores higher first is the AI's call; now: on by his second turn, by
   the unbag behavior.
2. `core::end of turn with AP left…`: an enemy's `Brigand Thug = ["actives.shieldwall"]` counted with the bros'; now
   the company's only. In code Wendel rolled a higher initiative than Bertel and freed himself: Bertel now acts first
   (+200 initiative), and Wendel's own `break_free` after Bertel's tries all failed (a roll) is allowed.
3. `known_bugs::KB29 fixed…`: the hand axe never broke (4 chops, a hit breaks it only on 50+ armor); it is now broken
   (`lowerCondition`, what such a hit does) after his first swing.
4. `known_bugs::KB4…` (UI data): Bertel's `terrain.hidden` is his own tile's effect; now each bro's ids are compared
   with his own skills.
5. `ui_page_vanilla::KB4…`: Wendel's own Confident morale icon (`status_effect_14.png`, `special.morale.check`) was
   filtered out of "own"; see the KB4 setup below.

## In the real UI page (2026-11-12, headless Chromium)

The mod's JS run in the game's page (`--env ui`; the files below have `// needs: ui`, `~/projects/bbm/bbtales/UI_VARIANTS.md`),
on the working tree.
Tests: `tale_ui_page.nut`, its vanilla control `tale_ui_page_vanilla.nut` (no Autopilot), shared body `lib/ui_page_body.nut`.

### KNOWN_BUGS #4 confirmed: the status bar shows the previous actor's effect icons — medium (visible)

- Test: `ui_page::KB4: after a tile hover the status bar shows the active bro's own effects` (fails while open):
  `./bbtales.py ../mods/autopilot/tales/tale_ui_page*.nut`
- Setup: the early-access company against 3 thugs, Torkel (acts first) with Killing Frenzy, Bertel with no effects,
  Wendel dazed, every bro in a neutral mood (no roll for a Confident start, whose morale icon `status_effect_14.png`
  is the bro's own); on each bro's first turn a tile hover's cost preview
  (`TurnSequenceBar.setActiveEntityCostsPreview`, what hovering a tile sends), then the icons the page shows against
  his own (`onQueryEntityStatusEffects`, morale included).
- Observed: Bertel is shown Torkel's `perk_36.png`; Torkel and Wendel their own. Without Autopilot
  (`ui_page_vanilla::KB4`) everybody is shown his own: the test passes. Both with and without `--no-stable-rng`.
  The earlier setup (Wendel dazed only) depended on who started Confident, which the morale roll decides; its
  vanilla control failed on that once the RNG followed the test's seed.
- Cause: `ui/mods/autopilot_new.js:87-93` replaces vanilla's `showEntityStatusEffectbar`, whose fade-out empties
  `mStatusEffectsContainer` on completion, with an instant hide that never empties it. The previous actor's icons
  stay in the container, and the next `showStatsPanel(true, …)` (`updateCostsPreview` on a tile hover, the first
  slot's `updateStatsPanel`) shows the container because it has children
  (`turnsequencebar_module.js:1246`, `showStatusEffectbarContainer = children().length > 0 && _show`). Consistent
  with the reports' "once you hover a tile".
- Fix: empty the container in the override when hiding (`if (!_show) this.mStatusEffectsContainer.empty();`);
  with that patched into the page by `t.js` the test passes.
- **Fixed 2026-11-17** that way: `ui_page::KB4` fails before, passes after in `--env ui` and `--env game`.

### Also checked

- `ui_page::buttons: ...` passes: the turn bar has one AI, one wait-all and one shield-wall button; hovering AI draws
  "AI Control (Q) | Give control of the party to the AI." (the bbui example's check).
- The whole suite with the page (`./bbtales.py --env ui -j 8 ../mods/autopilot/tales/tale_*.nut`, 2 runs, identical
  statuses): the page logged no errors. 7 tests differ from headless, none from a mod bug:
  1. `known_bugs::A2: AI confirmed with a non-player ally…`, `legends_summons::A2 Legends…` and
     `edge::KB34 fixed: retreat while on AI…` time out, the battle ended but never left, and their launch's later
     tests are lost (its reload can't run from the stuck battle). The tests act on popups mid-animation, which the
     headless stub never shows: A2 confirms the AI popup while its fade-in still runs (`DialogScreen.hide` does
     nothing until `onScreenShown`, so `onDialogHidden` never pops the tactical menu stack); KB34's `pilot` presses
     Flee while the AI popup fades out, so the popup's `onDialogHidden` pops the flee dialog's menu stack entry and
     one entry is left for good, and `onBattleEndedDelayed` waits on it forever. A player clicking that fast would
     hit the same vanilla race; the tests should wait for `isVisible() && !isAnimating()` before acting.
  2. `behaviors::throw nets…`, `behaviors::unbag shield…`, `core::AI button: autopilot's agents play a whole
     battle` fail on an AI battle's outcome (first action, a bro killed): the page's animations take frames the stub
     didn't, so the AI's rolls fall otherwise. Run alone, `unbag shield` passes with the page.

  Since rewritten (2026-11-12): popups are answered only when `isVisible() && !isAnimating()`
  (`::APT.dialogReady`, `confirmDialog`, `cancelDialog`), Flee waits for the AI popup's fade-out, KB10 reads the menu
  stack after the popup's fade-out, and `unbag shield` asserts the shield goes on by his second turn (whether he
  swings first is the AI's scores and the map's). With the stable RNG all 7 pass or fail alike in engine and ui.
  `known_bugs::KB10: wait-all pressed twice…` passes in every env since code and the engine report a screen animating
  inside its `show`, as the original does (its parity probe `campaign/screen_animating`): vanilla's guard drops the
  second press.

## KB10 in the original game (2026-11-13)

Both KB10 tests pass in the original (`bbtales.py --env game -k KB10`, Autopilot 2.9.0 from the store): the second
wait-all request doesn't push a second backstep, so there is no stale menu entry and nothing holds the battle or the
keys. The original answers `DialogScreen.show` inline, like the real page in `--env ui` and unlike the engine's
headless stub: right after the first press, in the same frame, `DialogScreen.isAnimating()` is true, so vanilla's guard
drops the second press. Probes (`[when, isVisible, isAnimating, menu stack depth, frame]`):

```
["before", false, false, 0, 261], ["after 1st press", false, true, 1, 261], ["after 2nd press", false, true, 1, 261],
["waiting", false, true, 1, 262] … ["waiting", false, true, 1, 270]
menu stack depth after the presses, after Yes = [1, 0]
```

So the engine's FAIL is an engine divergence (its `DialogScreen` doesn't start animating within the `show` call), and
this mechanism isn't the users' case. The file's KB10 tests can't run in the original as written: a closure made inside
a test (a generator) sees the test's locals as null there once the test has yielded (`seen` in the `before` steps:
"indexing null with string"); the run above used a copy keeping that state in a root-table slot
(`~/projects/bbm/bbtales/probes/game/kb10/known_bugs.nut`).

### KB10 hypothesis: a second Enter binding (2026-11-13)

Autopilot binds `keyup.autopilot_dialog` on every `DialogScreen` JS `show` and unbinds on `hide`
(`autopilot/ui/mods/autopilot_new.js:105-128`). Checked whether two shows without a hide bind twice so that Enter
confirms twice and leaves the popup stuck (`~/projects/bbm/bbtales/probes/game/kb10/kb10_bind.nut`, `--env ui` with the real
page and `--env game`):

1. `DialogScreen.show` called twice in one frame (no caller does this; vanilla's and Autopilot's go through
   `showDialogPopup`, whose `isVisible() || isAnimating()` guard holds in both): both run the JS `show`
   (2 `onScreenAnimating` calls, 1 `onScreenShown`), and the page has **2 bindings**. Enter then calls OK twice. The OK
   callback runs once (vanilla clears the listener after the first call). Both fade-outs end (ui: `onScreenHidden`
   twice, so a caller popping its menu backstep there pops twice). Bindings 0 and the popup is gone. In the original
   (no page access; the two bindings' OKs called directly) the result is the same: OK callback once, popup gone,
   menu stack back to its depth, no stale backstep.
2. Wait-all pressed twice, then Enter (ui) or OK (the original): one show, one binding. The waiting round is on,
   the popup is gone, and no backstep is left.

So the double binding needs a double show that nothing in Autopilot or vanilla makes, and even then it doesn't leave
the popup stuck. The hypothesis doesn't explain the Nexus report.

## In the real UI page, jsdom (2026-11-12)

The mod's JS run in the game's page in jsdom under Node (`bbtales.py --env jsdom`, "Variant 1" in
`~/projects/bbm/bbtales/UI_VARIANTS.md`), on the working tree. Tests: `ui_js_buttons.nut`, `ui_js_kb4.nut`:
`./bbtales.py ../mods/autopilot/tales/tale_ui_js_*.nut`.

### KNOWN_BUGS #4 confirmed again (same cause as above)

- Test: `ui_js_kb4::KB4: after a bro with an effect, the next bro's status bar shows none of it` (fails while open).
  Torkel gets Killing Frenzy (`perk_36.png`; no initiative change, so he still acts first), Bertel has no effects;
  each bro, on his turn, has the mouse off the page (`::BBTales_mouseOverUI(false)`) and clicks an empty tile next to
  him once (`tactical_state.onMouseInput`: the path and its costs previewed, not walked).
- Observed: Bertel's bar is shown with Torkel's `perk_36.png`. `-r '!mod_autopilot_new'` (vanilla UI): Bertel's bar is
  hidden and empty, the test passes.
- Vanilla has its own race there, which the fix must not bring back: its fade-out empties the bar when it completes,
  after the next bro's icons may already be in. Without Autopilot, Wendel (after Bertel, with `status_effect_14.png`
  of his own) is shown none of his icons; the test leaves Wendel out for that reason. So the fix is an `empty()`
  in Autopilot's instant hide, not vanilla's animated one.

### Also checked

- `ui_js_buttons::Autopilot's buttons in the turn bar, with their tooltips` passes: the five buttons (wait all,
  cancel, shield wall, ignore, AI) are image buttons in the bar with their icons, and hovering each shows the title and
  description `::Autopilot.Tooltips` gives it.
- The suite with the page (`./bbtales.py --env jsdom -j 8`, the files but `ui_*`, one run against a plain run right after):
  9 tests change status, none from a mod bug:
  1. `known_bugs::A2: AI confirmed with a non-player ally…`, `legends_summons::A2 Legends…` and `edge::KB34 fixed…`
     time out with the battle ended but never left, and their launch's later tests are lost: the popup race of the
     Chromium section above (acting on a popup mid-fade), the same here.
  2. `behaviors::unbag shield…`, `core::AI button: autopilot's agents play a whole battle` fail on an AI battle's
     outcome (the page's animations take frames, the AI's rolls fall otherwise).
  3. `stress_a::vs GoblinRaiders.` hung in round 2 (40000 frames, no script or page error) in 2 of 3 packed runs of
     `tale_stress_a.nut` with the page, the later tests lost; alone, and once packed with probes added, it passed. Not
     investigated further; not seen headless.
  4. Vanilla's turn bar logs `Cannot read properties of undefined (reading 'css'|'velocity')` at
     `turnsequencebar_module.js:996/1011` in many battles: a portrait leaves the bar while its first-slot resize
     animation runs, and the animation's end reads the removed portrait's data. Vanilla's own (no mod code on the
     stack), harmless; listed in `~/projects/bbm/bbtales/known_errors.txt`, so it doesn't fail tests.
