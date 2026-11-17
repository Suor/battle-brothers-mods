# More Blood — headless game-scenario tests

```bash
cd ~/projects/bbm/bbtales
./bbtales.py -j 4 ../mods/more_blood/tales/tale_*.nut    # 4 tests, 2 launches, ~6 s
```

- `tale_core.nut` (with events_delayed_fix) — actor blood amounts doubled, splatter particles doubled; MB1.
- `tale_smoke.nut` — boot, AI battle, days, save/load.

Not covered: what the particles look like (no rendering).
