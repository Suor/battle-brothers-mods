# Camps and Artifacts — bugs reproduced by the scenario tests

Checked 2026-11-12 on the working tree (3.6.0 + "always give ammo for artifact throwing weapons"),
vanilla 1.5.2 and Reforged 0.8.18 on modern-bb-engine. Commands run from
`~/projects/bbm/bbtales`. Each test below fails now, the same packed and with
`--isolate`. No new bugs were found; the three below are KNOWN_BUGS entries
(`KNOWN_BUGS.md` #1, #6, #8).

## CA-KB1. An artifact fencing sword can't go through MSU's serialization emulator (Reforged) — medium

- Tests: `reforged::CA-KB1: an artifact fencing sword (-25% head) goes through MSU's serialization emulator`,
  `reforged::CA-KB1: every artifact goes through MSU's serialization emulator` —
  `./bbtales.py -k CA-KB1 ../mods/camps_and_artifacts/tales/tale_reforged.nut`
  (Reforged 0.9.3: same failures); without Reforged, -25 set by hand: `known_bugs::CA-KB1: an artifact with a
  negative head chance goes through MSU's serialization emulator` (also in the code env, where Reforged 0.9 doesn't boot).
- Observed:
  ```
  ASSERT CA-KB1: onSerialize throws in writeU8: expected null, got "The value of the variable '-25' is not acceptable"
  ASSERT CA-KB1: artifacts MSU can't serialize: expected [], got ["scripts/items/weapons/artifact/artifact_fencing_sword: The value of the variable '-25' is not acceptable"]
  ```
  The users' error, word for word. Only the fencing sword: under Reforged its `ChanceToHitHead`
  is -25 (`artifact_fencing_sword.nut`, the Reforged branch of `create`), and
  `randomizeValues` never raises a negative one.
- Cause: `scripts/items/weapons/artifact/artifact_weapon.nut` `onSerialize` writes
  `_out.writeU8(this.m.ChanceToHitHead)`; MSU's emulator rejects values outside 0..255. The 3.5.1
  fix only remaps 231 → -25 on deserialize, which covers the game's own writer: a real
  save/load keeps -25 (`reforged::artifacts keep their rolled stats across a real save` passes).
- Expected: any writer works; e.g. write `ChanceToHitHead + 256` when negative (still U8, the
  existing deserialize remap reads it back) or clamp at 0 for the emulator.

## CA-KB6. Artifact shields are far less durable than named ones under Reforged — medium (balance)

- Test: `reforged::CA-KB6: artifact shields are at least as durable as named ones under Reforged`
- Observed (condition max before the random roll, which can at most double it):
  ```
  artifact_golden_round_shield 50 vs named/named_golden_round_shield 300
  artifact_sipar_shield 60 vs named/named_sipar_shield 300
  artifact_orc_heavy_shield 72 vs named/named_orc_heavy_shield 300
  ```
- Cause: `scripts/items/shields/artifact/*.nut` hard-code vanilla conditions; Reforged raises the
  base shields 3–6× (`3rdparty/reforged/mod_reforged/hooks/items/shields/`), and the named ones
  inherit that. The Reforged branch of each artifact shield only sets `ReachIgnore`.
- The schrat shield has no named counterpart and isn't compared.

## CA-KB8. Freezing ammo: tooltips promise freezing, the hit chills — low (cosmetic)

- Test: `known_bugs::CA-KB8: freezing arrows chill, and their tooltips say so`
- Observed: `PROBE tooltips = ["Freezing Arrows", "Freezes target on hit", "Will freeze a target on hit"]`;
  a hit adds `effects.chilled` (asserted, passes).
  ```
  ASSERT CA-KB8: tooltips promise freezing: expected [null, null], got [1, 6]
  ```
- Cause: `scripts/items/ammo/artifact_ammo.nut` (`effects.ice.Tooltip`) and
  `scripts/skills/special/campart_ice_ammo.nut` (`onQueryTooltip`, `m.Description`).

## Not reproduced

- **KB2** (`ca_getCamps` missing on a city state): with vanilla, Reforged 0.8.18, and Hardened
  1.18.3 forced onto Reforged 0.8.18 (it requires ≥ 0.9.0; its version error allowed), every
  city state has `ca_getCamps`, the camp actions update without errors before and after a
  load. The real setup (Reforged ≥ 0.9 + Hardened + Dynamic Spawns ≥ 0.5) isn't available.
  Note for the repro recipe: `"ca_getCamps" in faction` is false even when the method works (BB
  objects are tables with delegates, `in` doesn't look there): call it instead.
- **KB3** (arena floor maps): 33 fights (11 C&A location types × 3 map seeds, Reforged) built
  their maps without errors, with the location's template (or none, for the 4 types without
  one). Started through `startScriptedCombat` with the location's `CombatLocation`, not by
  walking into the location.
- **KB7** (Famed handgonne): a vanilla handgonne isn't Named, nor Artifact, its description has
  no "Famed", and no single-bit item type shares Artifact's bit. Legends/SSU not available.

## Discord deep search entries (2026-11-12)

`tale_discord_bugs.nut` (vanilla, launch `discord`) and `tale_discord_bugs_crock_pot.nut` (Reforged 0.8.18 + Crock Pot 0.8.0
then; since 2026-11-12 Reforged 0.9.3 + Crock Pot 0.10.6, same statuses). Same statuses packed and `--isolate`.

### CA-KB3. After an arena fight, four C&A locations build the arena floor — fixed in C&A (vanilla's root)

- Tests: `discord_bugs::CA-KB3: after an arena fight C&A locations don't get the arena floor`,
  `discord_bugs::CA-KB3: after an arena fight and a reload, a goblin warrens fight gets its own map` —
  `./bbtales.py ../mods/camps_and_artifacts/tales/tale_discord_bugs.nut`
- Observed:
  ```
  PROBE global Template after an arena fight = ["tactical.arena_floor", null]
  PROBE vanilla locations without a template = {abandoned_fortress = "tactical.arena_floor", battlefield = "tactical.arena_floor", undead_monolith = "tactical.arena_floor"}
  ASSERT CA-KB3: C&A locations with the arena floor: expected [], got ["bandit_usurper", "barbarian_sacred_grove", "goblin_warrens", "undead_damned_city"]
  PROBE goblin warrens template after the load = ["tactical.arena_floor", null]
  ASSERT CA-KB3: fights on the arena floor (arena spectators on the map): expected [], got [["tactical.forest", 2, 103], ["tactical.steppe", 1, 156], ...]
  ```
  After the save/load (Darxo's path) the global stays tainted for the session, a new goblin warrens gets
  `tactical.arena_floor`, and fights started with its `CombatLocation` are arena maps (100–157 spectators).
  The users' crash (`the index 'setFlipped' does not exist` at `tactical_arena_floor.nut`) didn't happen
  headless: it needs `tile.spawnObject` to return null on a tile the template can't use, which never
  happened in these 5 maps.
- Cause, verified: vanilla `arena_contract.nut:557-560` ("Start" option) does
  `p.LocationTemplate = clone this.Const.Tactical.LocationTemplate; p.LocationTemplate.Template[0] = "tactical.arena_floor"`,
  a shallow clone, so it writes into the global `::Const.Tactical.LocationTemplate.Template`.
  `location.create()` (`entity/world/location.nut:196-197`) clones the table *and* its `Template`, so
  every location created later copies the tainted `[0]`; those that never set `Template[0]` keep it:
  C&A's `bandit_usurper`, `barbarian_sacred_grove`, `goblin_warrens`, `undead_damned_city` and vanilla's
  `undead_monolith`, `abandoned_fortress`, `battlefield`.
- Part of the Discord claim is wrong for vanilla 1.5.2: C&A's other locations do **not** taint the global
  (`discord_bugs::CA-KB3: C&A locations keep their template arrays to themselves` passes: each location has
  its own array, the global stays `[null, null]` after creating all 11), because `location.create()`
  clones `Template` too.
- Fixed in C&A: the four set `this.m.CombatLocation.Template[0]` to the map of their vanilla kin —
  goblin warrens `tactical.goblin_camp` (as goblin_city), bandit usurper `tactical.human_camp` (bandit_hideout),
  sacred grove `tactical.barbarian_camp` (barbarian_sanctuary), damned city `tactical.ruins` (undead_necropolis).

### CA-KB2 with Crock Pot — not reproduced; Crock Pot's village faction is the trigger, since fixed there

- Test: `discord_bugs_crock_pot::CA-KB2: with Crock Pot, C&A camp actions update without errors, also after a load`
  passes: 3 Crock Pot southern-village factions (`cp_southern_settlement_faction`, typed `OrientalCityState`),
  only the 3 `city_state_faction`s have `build_citystate_camp_action`, no error before or after a load or in 2 days.
- Mechanism (`...CA-KB2 mechanism: ...` passes): the action on a Crock Pot village faction throws
  `the index 'ca_getCamps' does not exist`, the users' error. Crock Pot gives that faction the
  `OrientalCityState` trait (`mod_crock_pot/hooks/factions/faction_manager.nut:90-91`), and vanilla
  `faction.addTrait` (also called in `onDeserialize`) would add C&A's action; Crock Pot 0.8.0 overrides
  `addTrait` to skip the city-state actions (`scripts/factions/cp_southern_settlement_faction.nut:116-129`,
  file dated 2025-12-12, four days after Darxo's 2025-12-08 repro). So older Crock Pot versions hit it.
  C&A could still guard (`build_citystate_camp_action.onUpdate`: skip factions that aren't `city_state_faction`).

## Real Hardened / Crock Pot / Legends (2026-11-12)

Mods from `~/projects/bbm/bbtales/mods/VERSIONS.md`: Reforged 0.9.3, Hardened 1.26.3, Crock Pot 0.10.6, Legends 19.4.23.
Packed and `--isolate` give the same statuses.

### CA-KB2 (Hardened, Crock Pot) — not reproduced

- Tests: `hardened_bugs_ca::CA-KB2: ...` (Reforged 0.9.3 + Hardened), `hardened_cp_bugs_ca::CA-KB2: ...` (+ Crock Pot
  0.10.6, 3 southern village factions): both pass — every faction's camp action updates without an error on a new
  campaign, after a save/load and over 3 days; only `city_state_faction` has `build_citystate_camp_action`.
  Hardened adds nothing to the path; Crock Pot ≥ 0.8.0 keeps its villages away from the action
  (`discord_bugs_crock_pot::CA-KB2 mechanism` shows what older Crock Pot hit).

### CA-KB16 (Legends) — reproduced, two failing tests

- `legends_bugs_ca::CA-KB16 legends: artifact body armors are Legends layered armor`: all 9 artifact body armors are
  vanilla `armor`, none a `legend_armor` (a starting Legends bro wears `legend_armor_gambeson`).
- `legends_bugs_ca::CA-KB16 legends: armor attachments C&A camps drop fit a bro's layered armor`: each of the 8 vanilla
  `armor_upgrades/*` the C&A locations put in their loot (e.g. `bandit_usurper_location.nut:81-88`) throws
  `the index '-1' does not exist` in its `onUse` on a bro in Legends armor: Legends' `legend_armor.setUpgrade`
  (`scripts/items/legend_armor/legend_armor.nut:444`) indexes `m.Blocked[_upgrade.getType()]`, and a vanilla upgrade's
  type is -1. So camp-dropped attachments are unusable (a script error in the real game) under Legends.
- The garrison part (camps using static vanilla spawn lists) isn't tested.

### CA-KB7 (Legends) — not reproduced

- `legends_bugs_ca::CA-KB7 legends: a plain Handgonne isn't Famed` passes: no Named/Artifact flag, no "Famed" in the
  tooltip. The report also had SSU, which doesn't boot on Legends 19.4.

### CA-KB4 (Legends) — not reproduced

- `legends_bugs_ca::CA-KB4 legends: ...`: three AI-vs-AI battles against Legends' `Barbarians` spawn (200 resources)
  with C&A loaded end without errors (16 700–27 500 frames each). The report's native crash had no log; C&A's
  sacred grove party wasn't used.

### CA-KB17 (SSU) — not feasible; Legends part passes

- SSU 8.5.2 doesn't boot on Legends 19.4.23 (`~/projects/bbm/bbtales/mods/VERSIONS.md`). With Legends alone
  `legends_bugs_ca::CA-KB17 legends: every faction updates without errors, also after a load` passes.
