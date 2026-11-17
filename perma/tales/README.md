# Hackflow's Permanent Injuries — headless game-scenario tests

Real game scripts on modern-bb-engine through `~/projects/bbm/bbtales` (see its README), the mod
zipped from this working tree. `PE-KB<n>` = `KNOWN_BUGS.md`.

```bash
cd ~/projects/bbm/bbtales
./bbtales.py -j 4 ../mods/perma/tales/tale_*.nut      # 9 tests, 2 launches, ~7 s
```

All pass.

- `tale_smoke.nut` + `tale_known_bugs.nut` — vanilla + frameworks: Missing Hand with a crossbow out of
  battle (bag; full bag → stash; offhand blocked, no shield), in battle (dropped on the bro's
  tile), struck down and surviving with it (forced through `::Const.Injury.Permanent`), "restore
  equipment" on with a greatsword swapped for an arming sword mid-battle; KB2 (`onShieldHit`
  with a plain-instance and a WeakTableRef attacker, both with Missing Finger).
- `tale_smoke_reforged.nut` — Reforged 0.9.3 smoke.
- `lib/helpers.nut` — `::PeT`, incl. `whereIs(item)`.

Packed and `--isolate` agree (checked 2026-11-12).

Not covered: where an item dropped in battle ends up after it — the runner never takes the loot
screen, so such items are "gone" after any battle (probed, not asserted); other permanent
injuries' effects; the UI.
