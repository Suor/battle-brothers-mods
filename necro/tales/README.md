# Proper Necromancer — headless game-scenario tests

Real game scripts on modern-bb-engine through `~/projects/bbm/bbtales` (see its README), the mod
zipped from this working tree. Tests named `NE<n>: ...` (found here) or `NE-KB<n>: ...`
(`KNOWN_BUGS.md`) describe correct behaviour and
fail while the bug is open: see `FOUND_BUGS.md`.

```bash
cd ~/projects/bbm/bbtales
./bbtales.py -j 4 ../mods/necro/tales/tale_*.nut       # 14 tests, 3 launches, ~12 s
./bbtales.py -k NE-KB1 ../mods/necro/tales/tale_known_bugs.nut
```

Exit code 1 while the bugs are open: NE-KB1, NE-KB2, NE1, NE2 fail.

- `tale_smoke.nut` + `tale_known_bugs.nut` — vanilla 1.5.2 + frameworks, seed `bbtest-battle`, `fresh=1`. A
  necro joins the company; in the first player turn the test spawns a thug next to him, kills
  it and raises it with his own Raise Undead (`::Tales.scripted`, then every hostile is killed).
  KB1 (possess on an enemy zombie), KB2 (Mind Meld), KB5 (possess after a battle, regression).
- `tale_origin.nut` — the Necromancer origin: the company, roster limits, KB4 (22 bros, 16 fight),
  hiring cost multipliers, a raised zombie in battle.
- `tale_smoke_reforged.nut` + `tale_reforged.nut` — Reforged 0.9.3: NE1, NE2, the pg.necro perk tree.
  `// allow-errors:` lets NE1's boot error through (the test names it).

Packed and `--isolate` runs give the same statuses and asserts (checked 2026-11-12).

Not covered: the UI (perk tree in `ui/mods/necro.js`), KB3 (raise in a zone of control under
Reforged: maybe by design), KB6 (loot on double raise: no report to repro), Autopilot interplay.
