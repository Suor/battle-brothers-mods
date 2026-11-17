# Retinue Promotions — bugs found by the scenario tests

Found 2026-11-12 on the working tree (1.3.0). Code refs: `preload` =
`retinue_ups/scripts/!mods_preload/mod_retinue_ups.nut`. Each test fails the same packed and
with `--isolate`. Commands from `~/projects/bbm/bbtales`.

## RU-KB1. Loading an older save keeps the promotion in the follower object — medium (known, reproduced)

- Test: `core::RU-KB1: loading an older save undoes the promotion` — `./bbtales.py -k RU-KB1 ../mods/retinue_ups/tales/tale_core.nut`
- Observed: hire the Trader, save, promote, load the save:
  ```
  ASSERT trader after the load: expected {cost = 3500, effects = 1, hasBase = false, promoted = false},
         got {cost = 10500, effects = 2, hasBase = true, promoted = false}
  ```
  The same follower object survives the load (vanilla `retinue_manager.onDeserialize` only
  clears `Slots`); the flag is gone but cost and effects stay promoted.
- Cause: the `onDeserialize` hook (preload:47-53) calls `ru_onPromote()` for flagged followers
  and never `ru_onDemote()` for the others.

## RU2. A follower demoted and promoted again gets no cost or effects — low/medium

- Test: `core::RU2: a demoted follower promoted again gets the promotion again`
- Observed: promote the Blacksmith, replace him with the Cook, hire him back, promote again:
  ```
  ASSERT promoted again: expected {cost = 6000, effects = 4, hasBase = true, promoted = true},
         got {cost = 3000, effects = 3, hasBase = true, promoted = true}
  ```
  The player pays 3000 again; the flag is set (the loot effect works) but his cost (the refund
  base for More Followers / expanded retinue) and the effect line are missing.
- Cause: `ru_onDemote` (preload:146-150) restores `Cost`/`Effects` but leaves `m.ru_base`, and
  `ru_onPromote` (preload:131-134) returns early when `ru_base` is there. Same leftover as RU-KB1.

## RU1. Ctrl-click on an empty retinue slot throws — low

- Test: `core::RU1: ctrl-click on an empty slot does nothing`
- Observed: `the index 'getID' does not exist` at preload:74.
- Cause: `ru_onSlotCtrlClicked` logs `follower.getID()` before its `follower == null` check;
  `ui/mods/retinue_ups.js:18-19` sends ctrl-clicks for every slot, empty ones too. The UI gets
  no answer; a script error in the log each time.

## Known bugs not reproduced

- RU-KB2 (promotion lost after a load): promote, save, load in the same session → still
  promoted, cost 10500, two effect lines. The users' cases (game restart, Legends 18.2+, More
  Retinue Slots) aren't reproducible here.
- RU-KB3 (fixed in 1.2.2): replacing a non-promoted follower — passes.

## Legends 19.4.23 (2026-11-12)

Files `tale_legends_bugs_retinue.nut` (`// mods: mod_legends==19.4.23 mod_retinue_ups`) and control `tale_legends_control_retinue.nut`
(Legends alone, passes). Packed and `--isolate` agree. A Legends follower whose requirements aren't met is dropped
after a load (its "retinue brother lost" event), so the tests give the Trader 25 trade goods sold and a peddler.

### RU-KB2. Under Legends a promotion loses its cost and effects on load — medium (known, reproduced)

- Test: `legends_bugs_retinue::RU-KB2 legends: a promotion survives save and load`.
- Observed: `got {cost = 3500, effects = 1, hasBase = false, promoted = true}` after the load: the flag is kept,
  the follower is a new object, the promotion's cost and effect lines are gone (the reported "promoted effects
  are gone"; the Promote option isn't offered again since the flag says promoted).
- Cause: Legends' `retinue_manager.onDeserialize` (a `mods_hookNewObject` instance function,
  `mod_legends/hooks/retinue/retinue_manager.nut:151`) shadows the mod's class hook (`preload:47-53`), and it
  re-creates the followers (`clear()` + `create()`), so `ru_onPromote()` never runs on the new objects.

### RU-L1. Under Legends a replaced promoted follower isn't demoted — low (new)

- Test: `legends_bugs_retinue::RU-L1: replacing a promoted follower under Legends demotes it` — the cook replaced
  by the scout stays `[promoted, ru_base] = [true, true]`.
- Cause: Legends' instance `setFollower` (`retinue_manager.nut:45`) shadows the mod's `setFollower` hook (preload:40-45).
  Both are the mod being unsupported on Legends; a Legends hook would need `::mods_hookNewObject` after Legends'.
