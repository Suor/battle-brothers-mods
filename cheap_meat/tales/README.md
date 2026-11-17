# Cheap Meat — headless game-scenario tests

Real game scripts on modern-bb-engine through `~/projects/bbm/bbtales` (see its README), the mod
zipped from this working tree; vanilla 1.5.2, seed `bbtest-battle`, `fresh=1`, one launch.

```bash
cd ~/projects/bbm/bbtales
./bbtales.py -j 4 ../mods/cheap_meat/tales/tale_*.nut   # 4 tests, ~7 s, all pass
```

- `tale_smoke.nut` — boot, a battle, days, save/load.
- `tale_core.nut` — hire and tryout multipliers 0.5; a hire through a town's hire dialog charges
  half the price, the tryout price follows; the Recruiter makes them 0.33/0.25 with +3..6
  recruits, its effect texts say so; all kept by a load.

No bugs found, no known bugs. Not covered: the hire dialog's UI.
