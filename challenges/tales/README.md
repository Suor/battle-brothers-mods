# Challenges — headless game-scenario tests

Real game scripts on modern-bb-engine through `~/projects/bbm/bbtales`, the mod zipped from this
working tree. No bugs found (`FOUND_BUGS.md`).

```bash
cd ~/projects/bbm/bbtales
./bbtales.py -j 4 ../mods/challenges/tales/tale_*.nut    # 10 tests, 1 launch, ~7 s; all pass
```

- `tale_smoke.nut` + `tale_core.nut` (vanilla + frameworks, `fresh=1`): food price and wage multipliers,
  enemy scaling, banned followers, shields / two-handers refused at equip, the hiring
  requirement over a town's roster refresh, loot at 0% drop (gold instead), loot with the
  defaults, a random cap of 1.
- `lib/helpers.nut` — `::CHT`: settings, a scripted player killing every enemy on the first turn
  (a real `EnemyDestroyed`), the found loot summarized by a real-time ticker before the battle is left.

Not covered: the manual loot choice (cap with "choose at random" off: the loot screen's
`onSwapItem` / `onLeaveButtonPressed` and the capped outline are UI-driven), No Tryout / No
Firing (JS: `ui/mods/challenges/hiring.js`), EIMO / Consume / Pandora's Hobby integration,
the Legends level-up report.
