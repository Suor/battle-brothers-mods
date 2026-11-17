# Bro Renamer — headless game-scenario tests

```bash
cd ~/projects/bbm/bbtales
./bbtales.py -j 4 ../mods/renamer/tales/tale_*.nut    # 3 tests, 1 launch, ~5 s
```

- `tale_core.nut` — hires through `onHired`: "Farmer I/II", "Knight I" (aliases), the old title kept in
  a flag, numbering continued past a fallen "Farmer II", Roman numerals past ten.
- `tale_smoke.nut` — boot, AI battle, days, save/load.
