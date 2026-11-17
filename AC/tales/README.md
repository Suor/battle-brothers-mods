# Accessory Companions — headless game-scenario tests

Real game scripts on modern-bb-engine through `~/projects/bbm/bbtales` (see its README), the mod
zipped from this working tree. `AC-KB<n>` = `KNOWN_BUGS.md`.

```bash
cd ~/projects/bbm/bbtales
./bbtales.py -j 4 ../mods/AC/tales/tale_*.nut       # 9 tests, 3 launches, ~10 s
```

Exit code 1 while AC-KB1 is open: `reforged::AC-KB1` and the Reach assert of `reforged::AC-KB2` fail.

- `tale_smoke.nut` + `tale_core.nut` — vanilla + frameworks: tame a direwolf (Tame is a ~3% roll at 1 HP,
  retried on fresh wolves), keep the collar through a save, unleash it next battle, leash back;
  KB2 (a tamed Nachzehrer feasts and grows like a wild one).
- `tale_smoke_reforged.nut` + `tale_reforged.nut` — Reforged 0.9.3: KB1 (Reach of every companion type
  vs the Reforged beast of its kind), KB2 again (size, HP and Reach growth).
- `tale_no_stdlib.nut` — KB3 (fixed in 2.1): Tame's hit chance without stdlib.
- `lib/helpers.nut` — `::ACT`: collars made as Tame makes them (`wardog_item.setType`), unleashed
  through the real `actives.unleash_companion` skill.

Packed and `--isolate` agree (checked 2026-11-12).

Not covered: Hardened (KB2 was reported with it; not installed), companions' level-ups, quirks,
the UI.
