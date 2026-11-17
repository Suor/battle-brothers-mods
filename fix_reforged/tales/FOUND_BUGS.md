# Fix Reforged — bugs found by the scenario tests

## FR1. Every background's create() errors with Reforged 0.8.x and 0.9.3: `the index 'PerkTreeMultipliers' does not exist` — high (new)

- Test: `tale_smoke_reforged.nut` — on 0.9.3 the error is logged once per background made and the game goes on, as the original's `::new` does: "is loaded" passes, the battle test fails on the errors, plus errors at the campaign start.
- Cause: `fix_reforged/scripts/!mods_preload/mod_fix_reforged.nut:15` assigns
  `this.m.PerkTreeMultipliers = {...}` in `character_background.create`; the field exists in
  Reforged 0.3.6/0.3.7/0.6.2 (`3rdparty/mod_reforged_*.zip`) but not in 0.8.18 nor 0.9.3 (nor their
  frameworks), and `=` on a missing slot throws. The README says "Tested with reforged 0.36"; the
  mod is unreleased (no Nexus link) and was last touched 2024-09 (plus a 2026-05 MSU ref fix).
- Beyond the crash, `::DynamicPerks.Class.PerkTree(...).init({DynamicMap = ...})` would need checking
  against the current framework API.
