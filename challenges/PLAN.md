# Challenges Mod — Plan

## Status

Initial implementation done. Needs testing.

## Architecture

Bro Studio style: each domain file (`loot.nut`, `hiring.nut`, `costs.nut`) owns
both its MSU settings and its hooks. Settings are on a single "General" page.
Uses a copied `SliderSetting` from Bro Studio (renamed to `Challenges_Slider`).

## Settings

All settings: left = no challenge (default), right = hardest.

### Loot
- `weaponDropChance` — weapon/shield drop rate: 100% → 0%
- `armorDropChance` — armor/helmet drop rate: 100% → 0%
- `maxItemsPerBattle` — cap on equipment drops per battle: off → none (0)
- `lootGoldComp` — gold compensation for blocked drops: full → none
- `protectNamed` — named items always drop (checkbox, default on)

### Hiring
- `hiringRequirement` — need N×hiring cost in gold to see a bro: none → 20×
  - Low-wage (≤8g/day) backgrounds always visible regardless

### Costs
- `foodPriceMult` — food price multiplier: 1× → 20×
- `wageMult` — wages multiplier: 1× → 10×

## Key Hook Points

| Hook | Class | Purpose |
|---|---|---|
| `isDroppedAsLoot` | `starting_scenario` (hookTree) | Drop chance + max cap |
| `onCombatStarted` | `starting_scenario` (hookTree) | Reset per-battle counter |
| `onUpdateDraftList` | `starting_scenario` (hookTree) | Filter expensive backgrounds |
| `getPrice` | `scripts/items/item` (hookTree) | Food price multiplier |
| `getDailyCost` | `scripts/entity/tactical/player` | Wage multiplier |

## Things to Verify During Testing

1. **Loot**: `_item.m.SlotType` — confirm field name (vs `getSlot()`)
2. **Loot**: `_item.m.Price` — confirm this is the base value to use for gold comp
3. **Loot**: `::Const.ItemSlot.Mainhand` — confirm capitalization (MainHand vs Mainhand)
4. **Loot**: `_item.m.ConditionMax` — confirm field name
5. **Loot**: `onCombatStarted` — confirm method exists on starting_scenario
6. **Hiring**: `bg.m.DailyWage` — confirm background objects have this property when instantiated
7. **Hiring**: `bg.m.HiringCost` — confirm background objects have this property
8. **Hiring**: `_list.remove(i)` — confirm array remove by index works in Squirrel
9. **Costs**: `this.m.FoodValue` — confirm food items have this property (alternatively: `this.m.IsFood`)
10. **Costs**: `getPrice` — confirm this is the price method used by settlement shops when player buys food

## Known Gaps

- Gold compensation shows in wallet silently; no visual feedback in loot screen
- BgCostCache in hiring.nut persists across sessions (fine, costs don't change)
- If background scripts use a different path prefix (e.g. hackflows mods), the
  `::new("scripts/entity/tactical/backgrounds/" + bgId)` will fail gracefully
  (returns true = allowed, safe fallback)
