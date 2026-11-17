# Cook and Blacksmith Fix — headless game-scenario tests

```bash
cd ~/projects/bbm/bbtales
./bbtales.py -j 4 ../mods/heal_repair_fix/tales/tale_*.nut    # 10 tests, 3 launches, ~7 s
```

- `tale_core.nut` — healing and repair per hour over 24 hourly ticks of `asset_manager.update` (counted on
  `LastHourUpdated`, not the clock: the original may stop a frame after the hour turns, before its tick), with the mod: camping without a cook
  1.5 hp/h (vanilla 2: `actor.setHitpoints` rounds 1.5 up), cook 3 hp/h, blacksmith 3.6 and
  camping blacksmith 5.4 armor/h.
- `tale_baseline_heal.nut` — the same without the mod (vanilla 1.5.2): 2, 3, 3.6, 5.4.
- `lib/measure.nut`, `tale_smoke.nut`.

Findings (no failing test): on vanilla 1.5.2 the repair half of the mod is a no-op —
`item.improveCondition` keeps fractions, the mod hooks `setCondition`, which the hourly repair no
longer calls — and the README's tables are outdated: the cook now adds +1 hp/h and the blacksmith
×1.2 repair (both were ×1.33). The camping-heal rounding fix still works. The mod's private RNG is
unseeded, so the 1.5 is checked ±0.3.
