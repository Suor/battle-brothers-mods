# Immortal Warriors — bugs found by the scenario tests

Found 2026-11-12 on the working tree (0.2.1). Code: `trait` =
`immortal_warriors/scripts/skills/traits/immortal_warrior_trait.nut`, `jar` =
`immortal_warriors/scripts/items/special/immortal_soul_jar.nut`, `preload` =
`immortal_warriors/scripts/!mods_preload/mod_immortal_warriors.nut`. Both fail packed and `--isolate`.

## IW1. Kills and battles of earlier lives are counted again on every rebirth — medium

- Test: `core::IW1: deeds are counted once across rebirths`
- Observed: 5 kills in the first life, 3 in the second → `expected 8, got 13`.
- Cause: the jar gives the new body the soul's totals (`jar` onUse: `stats.Kills += info.Kills`,
  same for Battles), then the trait's `onDeath` adds the body's whole LifetimeStats to the info
  again (`info.Kills += stats.Kills`). The jar description ("crushed N foes") and the next body's
  stats grow by all earlier lives each death. Fix: assign (`info.Kills = stats.Kills`) or add only
  what this body earned.

## IW2. "Boost Talents" keeps old rows for a bro who already levelled — low/medium

- Test: `core::IW2: talents boost rerolls the rows of a brother who already levelled`
- Observed: a level-3 bro (2 level-ups taken), `talents` = 1, jar used:
  `immortal_extraALUV` is −2 and each attribute has 16 level-up rows, expected 0 and 8.
- Cause: the `setAttributeLevelUpValues` hook (`preload`, the `entity/tactical/player` hook)
  decrements `immortal_extraALUV` on every level-up, not only for the gifted/potion rows that
  `fillAttributeLevelUpValues(_, maxOnly|minOnly)` added. It goes negative, and `boostTalents`'
  `v.slice(0, extraALUV)` then keeps all but the last 2 old rows as "extras" in front of the
  reroll: the next 6 level-ups roll with the pre-boost talents. The field isn't serialized either
  (0 again after a load). Only with the non-default `talents` setting.

## Legends 19.4.23 (2026-11-12)

### IW-KB1. Vanilla origins Legends re-hooks start without the soul jars — medium (known, reproduced on Legends)

- Tests: `legends_iw_{early_access,lone_wolf,legends_noble,legends_beggar}.nut`
  (`// mods: mod_legends==19.4.23 mod_immortal_warriors`) — `./bbtales.py ../mods/immortal_warriors/tales/tale_legends_iw_*.nut`.
  Packed and `--isolate` agree.
- Observed: `scenario.lone_wolf` and `scenario.early_access` start with 0 jars (expected 3); Legends' own
  `scenario.legends_noble` and `scenario.legends_beggar` get 3. The origin's `onSpawnAssets` is
  `mod_legends/hooks/tales/world/<origin>_scenario.nut` for the failing two and
  `scripts/!mods_preload/mod_immortal_warriors.nut` for the passing ones.
- Cause: the jars come from a `mods_hookBaseClass("tales/world/starting_scenario")` wrapper of `onSpawnAssets`
  (`mod_immortal_warriors.nut:61-73`); Legends replaces `onSpawnAssets` of every vanilla scenario with
  `mods_hookExactClass`, which lands on the leaf class and shadows the base-class wrapper. Fix: hook the leaves
  (`mods_hookDescendants`/Modern Hooks `hookTree`) or give the jars from `world_state.startNewCampaign`.
