# Hackflow's Translations — headless game-scenario tests

```bash
cd ~/projects/bbm/bbtales
./bbtales.py -j 4 ../mods/translations/tales/tale_*.nut    # 4 tests, 2 launches, ~6 s
```

- `tale_core.nut` — Rosetta 0.4.0 + Settlement Prices Tooltip v6 (`mod_settlement_prices_tooltip-311-6-…zip`,
  copied from the game's data dir to the runner's `mods/`), Russian switched on by hand: its lines
  translated; TR1.
- `tale_smoke.nut` — boot with Rosetta, AI battle, days, save/load.

Not covered: the other six translated mods (Champion Beasts, Background Bonuses, Swifter,
Backgrounds Reforged, Prepare for Battle, Shield Damage); `rosetta -c` checks those files statically.
