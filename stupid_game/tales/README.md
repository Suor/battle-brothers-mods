# Stupid Game — headless game-scenario tests

```bash
cd ~/projects/bbm/bbtales
./bbtales.py -j 4 ../mods/stupid_game/tales/tale_*.nut    # 6 tests, 4 launches, ~8 s
```

- `tale_raiders.nut` — the Raiders origin starts with every noble house at relation 50.
- `tale_reforged_pauper.nut` — Reforged 0.9.3: backgrounds costing ≤10 a day get `pg.rf_pauper`,
  Discovered Talent has no prerequisites.
- `tale_smoke.nut`, `tale_smoke_reforged.nut` — boot, AI battle, days, save/load.

Not covered: the README's modset (autoplay with Autopilot etc.).
