# Starting Perks by Background — scenario test findings

Checked 2026-11-12 on the working tree (2.6.2): no bugs found.

- KB #1 (stuck loading a new game, 1.5.1): not reproduced: all 14 vanilla origins (tutorial and
  random left out) start, and every starting bro gets his roll.
- KB #2 (King's Guard event under Legends, fixed in 2.4): the vanilla event `event.kings_guard_1`
  passes: the cripple has a head, level 3, 2 perk points, is hired. The Legends signature isn't testable.
- KB #3 (Legends endless map generation): Legends unavailable.

## Legends 19.4.23 (2026-11-12)

Real Legends 19.4.23 + MSU 1.9.0 + Modern Hooks 0.7.0 (`// mods: mod_legends==19.4.23 mod_background_perks`). Files
`tale_legends_bugs_bg_perks.nut`, control without the mod `tale_legends_control_bg_perks.nut` (passes),
`legends_bp_origin_{beggar,berserker}.nut`. Packed and `--isolate` agree.

### BP-KB4. Legends' extra `setStartValuesEx` args throw — high under Legends (known, reproduced)

- Tests: `legends_bugs_bg_perks::BP-KB4: setStartValuesEx keeps Legends' gender and addEquipment args`,
  `…::BP-KB4: the supposed witch event's bro is female` — `./bbtales.py ../mods/background_perks/tales/tale_legends_bugs_bg_perks.nut`
- Observed: at boot Modern Hooks logs `Mod mod_background_perks (Starting Perks by Background) is wrapping function
  setStartValuesEx in bb class scripts/entity/tactical/player with fewer total parameters (used to be 4, wrapper
  returned function with 2)`. Then the event's own call `setStartValuesEx(::Const.SupposedWitchBackgrounds, true, 1)`
  throws `wrong number of parameters (4 passed, 3 required)` (with `false` as a 4th arg: `5 passed`). Worse than
  the report assumed (gender dropped): the call fails, so the "Good" screen's `start` dies after `roster.create`,
  which fits "a bro is added per click, the option doesn't advance". The control without the mod gives gender 1
  and no equipment.
- Cause: `scripts/!mods_preload/mod_background_perks.nut:133` wraps with `(_backgrounds, _addTraits = true)`;
  Legends' is `(_backgrounds, _addTraits = true, _gender = -1, _addEquipment = true)`
  (`mod_legends/hooks/entity/tactical/player.nut:1224`). Fix: `(_backgrounds, ...)` + `__original.acall([this,
  _backgrounds].extend(vargv))`, or 4 params as Nicknames did.

### BP-L1. Under Legends a recruit throws when he rolls a perk Legends doesn't define — medium (new)

- Tests: `legends_bugs_bg_perks::BP-L1: every perk the mod can roll exists under Legends`,
  `…::BP-L1: recruits of every background get perks without a script error`.
- Observed: 4 of 100 recruits (juggler, thief ×2, miner) threw `the index 'Const' does not exist` from
  `mod_legends/hooks/skills/backgrounds/character_background.nut:856` (`getPerk`) ← Legends' `player.unlockPerk`
  (`player.nut:808`) ← `giveFreePerks` (`mod_background_perks.nut:89`). Unresolvable ids: every `hackflows.*`
  and `necro.*` perk; `ALL` gives every recruit a 1% roll of `hackflows.flesh_on_the_bones`.
- Cause: without Dynamic Perks `canAddPerk` only checks `!hasPerk`, relying on vanilla `unlockPerk` returning false
  for an unknown id; Legends' throws. Fix: also check `id in ::Const.Perks.LookupMap` (or catch).

### BP-KB3. Legends beggar/berserker endless map generation — not reproduced

- `legends_bp_origin_{beggar,berserker}::BP-KB3` pass: both origins start (seed `bbtest-battle`) with the mod.
