# Starting Perks by Background — headless game-scenario tests

Real game scripts on modern-bb-engine through `~/projects/bbm/bbtales`, the mod zipped from this
working tree. No bugs found (`FOUND_BUGS.md`).

```bash
cd ~/projects/bbm/bbtales
./bbtales.py -j 8 ../mods/background_perks/tales/tale_*.nut    # 21 tests, 16 launches, ~12 s; all pass
```

- `tale_smoke.nut` + `tale_core.nut` (vanilla + frameworks, `fresh=1`): an apprentice always gets
  Student, recruits of every vanilla background (3 each) get perks without perk points changing,
  the King's Guard event bro (KB #2).
- `origin_<origin>.nut` — KB #1: a campaign with each vanilla origin (all but tutorial and
  random) starts, and every starting bro gets his perk roll (`giveFreePerks` wrapped in
  `beforeCampaign`).
- `tale_smoke_reforged.nut` — smoke under Reforged 0.9.3.

Not covered: Legends (KB #3), Dynamic Perks trees beyond the Reforged smoke, the tutorial and
random origins.
