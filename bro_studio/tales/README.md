# Bro Studio — headless game-scenario tests

Real game scripts on modern-bb-engine through `~/projects/bbm/bbtales`, the mod zipped from this
working tree. `BS<n>` / `BS-KB<n>` tests fail while the bug is open: see `FOUND_BUGS.md`.

```bash
cd ~/projects/bbm/bbtales
./bbtales.py -j 4 ../mods/bro_studio/tales/tale_*.nut    # 15 tests, 3 launches, ~10 s; 1 fails (BS1)
```

Every launch boots past an engine divergence: Modern Hooks reports `stdlib (stdlib) version 2.6
is outdated for mod_bro_studio ... >= 2.6` because it compares stdlib's literal `2.6` (f32) with
`"2.6".tofloat()`, which the engine keeps in 64 bits (`docs/differences.md` "Floats in format and
tofloat": not only extreme values, any version like 2.6 that isn't exact in binary). The headers
allow those two errors; Modern Hooks doesn't quit headless, the queue runs (first test checks).

- `tale_smoke.nut` + `tale_core.nut` (vanilla + frameworks, `fresh=1`): talents min/max (BS-KB6), traits
  good-only (BS-KB3), BS1, traitsNum, permanent injuries and the hiring discount, perksEach,
  veteran attribute rolls with bulk XP (BS-KB1), attrsVeteran 15.
- `tale_reforged.nut` — Reforged 0.9.3: 200 injured recruits, one hired and fighting (BS-KB2).
- `tale_smoke_reforged.nut` — smoke under Reforged.
- `lib/helpers.nut` — `::BST`: settings set and restored, recruits, leveling through the
  character screen's level-up calls.

Not covered: Hardened (needs Reforged 0.9), Legends, the UI (slider JS), Rosetta strings.
