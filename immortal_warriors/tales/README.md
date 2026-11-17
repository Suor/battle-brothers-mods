# Immortal Warriors — headless game-scenario tests

Through `~/projects/bbm/bbtales` (see its README). `IW<n>` tests fail while the bug is open, see
`FOUND_BUGS.md`.

```bash
cd ~/projects/bbm/bbtales
./bbtales.py -j 8 ../mods/immortal_warriors/tales/tale_*.nut    # 20 tests, 15 launches, ~8 s
```

- `tale_core.nut` — jars in the starting stash, imbuing, a death outside battle (as vanilla events do)
  and in battle returning the soul, rebirth with name/title/half the levels/deeds, save/load of
  the info; IW1, IW2.
- `origin_*.nut` — KNOWN_BUGS #1: each of the 13 vanilla origins (besides early access, tutorial,
  random) starts with 3 jars. All pass: not reproduced on vanilla; the report is Legends' Lone Wolf
  (Legends isn't runnable here).
- `tale_smoke.nut` — boot, AI battle, days, save/load.

Packed and `--isolate` agree. Not covered: anatomist mutations and arena/North Expansion traits
kept across rebirth, the level-up injury heal (JS-side level-up changes), MSU settings UI.
