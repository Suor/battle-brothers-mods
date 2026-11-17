# Beast Loot — headless game-scenario tests

Real game scripts on modern-bb-engine through `~/projects/bbm/bbtales` (see its README), the mod
zipped from this working tree; vanilla 1.5.2, seed `bbtest-battle`, `fresh=1`, one launch.

```bash
cd ~/projects/bbm/bbtales
./bbtales.py -j 4 ../mods/mod_beast_loot/tales/tale_*.nut   # 4 tests, ~7 s, all pass
```

- `tale_smoke.nut` — boot, a battle, days, save/load.
- `tale_core.nut` — every vanilla origin's `onInit` gives +50 `ExtraLootChance` (Beast Slayers 100),
  checked for all 16 origins; the bonus survives a reset of the assets (hiring a follower) and a
  load.

The Nexus report "doesn't work in latest version or vanilla" (KNOWN_BUGS, others) is not
reproduced: under vanilla 1.5.2 the chance the beasts' `onDeath` rolls against is set as
intended. Not covered: actual loot counts from beast kills (random), Legends.
