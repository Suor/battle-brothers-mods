# Vanilla bugs

Bugs of the game itself (1.5.2) found while testing mods: what a mod must work around, or what makes a mod's bug
show. Paths are under `~/projects/bbm/base/data_001/scripts/`.

## V1. Food bought in a market records a day of freshness less than was paid — ~1% of purchases

- The shop's buy (`ui/screens/world/modules/world_town_screen/town_shop_dialog_module.nut:386-389`, `onSwapItem`)
  charges `getBuyPrice()` with full freshness (market food has `BestBefore = 0`, `items/supplies/food_item.nut:84-87`),
  then `Stash.add` → `onAddedToStash("player")` sets `BestBefore = now + GoodForDays * 105` (`food_item.nut:179`),
  then `BoughtAtPrice = getBuyPrice()` (`:186`).
- `getSpoilInDays()` is integer `Math.max(1, (BestBefore - now) / SecondsPerDay)` (`:81`) on f32: at some times
  `now + 1260` rounds down, 11.9999981 days truncate to 11, and the value drops by a day's share (ham: 149 paid,
  136 recorded at `Time.setVirtualTime(2919.301)`). About 20 of 2056 times sampled over 0–200000 s.
- Shows as: the item tooltip's "bought for"; any mod reading `getBuyPrice()` after the purchase.
- Worked around: Fun Facts (`fun_facts/fun_facts/buys.nut`, the price taken before `onAddedToStash`); test
  `fun_facts/tales/tale_economy.nut`, "buying supplies in a marketplace".

## V2. An arena fight taints the global location template for the session

- `contracts/contracts/arena_contract.nut:557-560` does `p.LocationTemplate = clone ::Const.Tactical.LocationTemplate`
  then sets `Template[0] = "tactical.arena_floor"`: `clone` is shallow, so the global's `Template` array gets the
  arena floor. Every location created afterwards without its own `Template[0]` fights on the arena floor.
  `defend_holy_site_contract.nut:323-330` does the same with `tactical.southern_ruins`.
- Vanilla's own victims: the locations that leave `Template[0]` at the global's default, all of `legendary/` and
  `abandoned_fortress`, `battlefield`, `undead_monolith` (Darxo's repro: the Black Monolith).
- Shows as: C&A CA-KB3 (`camps_and_artifacts/tales/FOUND_BUGS.md`), and in vanilla `abandoned_fortress`,
  `battlefield`, `undead_monolith`.

## V3. Unguarded division in the AI's fatigue score — latent

- `ai/tactical/behavior.nut`, `getFatigueScoreMult`: `fatigue / (max - current)` divides by zero at full fatigue.
  Vanilla's `getFatigueMax()` is a float (NaN, score 0, no error); a mod making it an integer turns it into a crash.
- Shows as: Autopilot KB31 with Hardened (`autopilot/tales/FOUND_BUGS.md`).
