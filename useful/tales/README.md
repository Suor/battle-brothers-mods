# Useful Things — headless game-scenario tests

Real game scripts on modern-bb-engine through `~/projects/bbm/bbtales` (see its README), the mod
zipped from this working tree; vanilla 1.5.2, seed `bbtest-battle`, `fresh=1`, one launch.

```bash
cd ~/projects/bbm/bbtales
./bbtales.py -j 4 ../mods/useful/tales/tale_*.nut   # 7 tests, ~8 s, all pass
```

- `tale_smoke.nut` — boot, a battle, days, save/load.
- `tale_core.nut` — 2H flail values; Flail Mastery on 2H flails: -25% fatigue (ceil, as vanilla's
  `getFatigueCost`) and +20/+10 stun on Pound/Thresh (KNOWN_BUGS useful #1, fixed in 0.7:
  `US-KB1`); named goblin spear 3 AP Thrust and Spearwall, falchion accuracy, goblin bow
  poison; hand to hand damage at levels 1/6/11; a throwing net thrown in battle (stays in hand
  as used, its skill unusable, the target netted), restored after the battle for 6 ammo;
  double grip with a net.
- `lib/helpers.nut` — `::UST` helpers (equip, a scripted `player` that kills every enemy).

No bugs found. Without Camps and Artifacts Modern Hooks warns that
`artifact_two_handed_flail` was never processed for hooks (a hook on a class that doesn't
exist): harmless. Not covered: Reforged (Kingfisher net ammo), swallow-whole through a net, the
weasel trait, the lindwurm shields.
