# Standout Enemies — headless game-scenario tests

Real game scripts on modern-bb-engine through `~/projects/bbm/bbtales` (see its README). Tests
named `SE-KB<n>` reproduce `KNOWN_BUGS.md` and fail while the bug is
open; see `FOUND_BUGS.md`.

```bash
cd ~/projects/bbm/bbtales
./bbtales.py -j 4 ../mods/standout_enemies/tales/tale_*.nut     # 6 tests, 1 launch, ~6 s
```

- `tale_core.nut` — quirks on a real world bandit party's troops (the hook needs `Party`; the days
  scale is forced through `Config.ScaleDays`), the Cursed effect stacking and debuffing in battle,
  SE-KB1, SE-KB2.
- `tale_smoke.nut` — boot, an AI battle, 2 days, save/load.
- `lib/helpers.nut` — `::SET`: scripted player, kill-all, sprite colors, party troops as entities.

Packed and `--isolate` give the same statuses. Not covered: undead/goblin strategies, quirks
carried to a corpse and back on resurrection, the wolfrider demount, Russian names.
