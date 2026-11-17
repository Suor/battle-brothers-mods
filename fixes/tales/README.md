# Hackflow's Fixes — headless game-scenario tests

Through `~/projects/bbm/bbtales`. `FX<n>` fails while open, see `FOUND_BUGS.md`.

```bash
cd ~/projects/bbm/bbtales
./bbtales.py -j 4 ../mods/fixes/tales/tale_*.nut    # 5 tests, 3 launches, ~8 s
```

- `tale_core.nut` (vanilla) — the Ammunition tooltip's "Short of N ammo" line, Nimble's armor fatigue line.
- `tale_reforged.nut` — with Reforged 0.9.3 (+ mod_hooks shim): vanilla shield conditions restored.
- `tale_reforged_noshim.nut` — FX1: the same without Adam's mod_hooks.
- `tale_smoke.nut` — boot, AI battle, days, save/load.

Not covered: enemies shown right after a load (rendering), despawning units without a home
settlement, Shield Expert halving Reforged shield damage, the schrat shield, `ProjectileType` repair.
