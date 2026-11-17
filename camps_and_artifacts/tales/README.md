# Camps and Artifacts — headless game-scenario tests

Real game scripts on modern-bb-engine through `~/projects/bbm/bbtales` (see its README), the mod
zipped from this working tree. Tests named `CA-KB<n>: ...` follow
`KNOWN_BUGS.md` (#n) and fail while the bug
is open: see `FOUND_BUGS.md`.

```bash
cd ~/projects/bbm/bbtales
./bbtales.py -j 4 ../mods/camps_and_artifacts/tales/tale_*.nut   # 19 tests, 3 launches, ~11 s
./bbtales.py -k CA-KB1 ../mods/camps_and_artifacts/tales/tale_reforged.nut
```

Exit code 1 while the bugs are open: 4 failing tests (CA-KB1 ×2, CA-KB6, CA-KB8).

## Files

Seed `bbtest-battle`, `fresh=1`, Modern Hooks + MSU + stdlib + the mod_hooks shim:

- vanilla launch: `tale_smoke.nut` (boot, a battle, days, save/load); `tale_core.nut` (every artifact
  created, typed, named, its rolled stats kept by a save; artifacts equipped in an AI battle;
  noble and city-state camps built within their caps of 12 and 5 and kept apart from towns
  across a load; a refreshed Chilled restarts its time); `tale_known_bugs.nut` (KB1 with Reforged's -25 head chance set by hand, KB7, KB8, KB9).
- Reforged 0.9.3 launch: `tale_smoke_reforged.nut`; `tale_reforged.nut` (KB1 through MSU's emulator and a
  real save, KB2, KB3, KB6).
- `tale_menu.nut` — KB11: artifacts created in the main menu, without a World.
- `lib/helpers.nut` — `::CAT` helpers: artifact lists, item stats; the shared ones (toughen, equip, a scripted
  `player` for `t.battle`) are the runner's `::Tales` (its README, "Helpers").

Packed and `--isolate` give the same statuses (checked 2026-11-12).

Not covered: KB4 (Legends only), KB5 (the world map's hover tooltip is UI; the Squirrel tooltip
of an allied camp never lists troops, by vanilla design), KB2 with Reforged ≥ 0.9 + Hardened,
the artifact roll in `location.onSpawned`, Sato's Balance branch.
