# Retinue Promotions — headless game-scenario tests

Real game scripts on modern-bb-engine through `~/projects/bbm/bbtales` (see its README), the mod
zipped from this working tree. Tests named `RU<n>: ...` / `RU-KB<n>: ...` describe correct
behaviour and fail while the bug is open: see `FOUND_BUGS.md` and
`KNOWN_BUGS.md`.

```bash
cd ~/projects/bbm/bbtales
./bbtales.py -j 4 ../mods/retinue_ups/tales/tale_*.nut    # 14 tests, 2 launches, ~8 s; 3 fail (RU1, RU2, RU-KB1)
```

- `tale_smoke.nut` + `tale_core.nut` (one launch: vanilla + frameworks, `fresh=1`): promotion through the
  campfire screen's Squirrel handler (money, name, tooltip hint), the bounty hunter, drill
  sergeant and cook effects, demotion on replacement, RU1, RU2, RU-KB1/2/3.
- `tale_smoke_reforged.nut` — the same smoke under Reforged 0.9.3.

Not covered: the ctrl-click itself (UI JS), RU-KB2's "restart the game" (a load in the same
session is tested; a fresh process isn't), Legends and More Retinue Slots (not available), the
scavenger/trader/lookout/surgeon effects.
