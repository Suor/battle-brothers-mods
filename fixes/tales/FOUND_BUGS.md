# Hackflow's Fixes — bugs found by the scenario tests

Found 2026-11-12 on the working tree (0.5.0, unreleased).

## FX1. Under Reforged without Adam's mod_hooks the mod errors in its queue — medium

- Test: `reforged_noshim::FX1: reforged without mod_hooks: shields keep vanilla condition` —
  `./bbtales.py ../mods/fixes/tales/tale_reforged_noshim.nut`
- Observed: boot logs `the index 'mods_hookDescendants' does not exist` / `Mod mod_fixes ... had an
  error ... during queue function 2 [Before: mod_reforged]`; shields keep Reforged's sizes
  (`faction_heater_shield = [150, 150]` instead of `[32, 32]`, etc.). With the mod_hooks shim
  loaded (`tale_reforged.nut`) it passes.
- Cause: `fixes/scripts/!mods_preload/mod_fixes.nut:121` uses `::mods_hookDescendants` in a Modern
  Hooks mod that doesn't require `mod_hooks`; Reforged doesn't need mod_hooks, so its users may
  not have it. Use `mod.hookTree` (mind CLAUDE.md's note on where the wrapper fires) or require mod_hooks.
- Also: the ammo tooltip uses `::std.Text` but stdlib isn't required either (the README's install
  line is commented out).
