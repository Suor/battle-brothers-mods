# Hackflow's Perks — headless game-scenario tests

Real game scripts on modern-bb-engine through `~/projects/bbm/bbtales` (see its README), the mod
zipped from this working tree. `HP-KB<n>` = `KNOWN_BUGS.md`; `HP<n>`
found here.

```bash
cd ~/projects/bbm/bbtales
./bbtales.py -j 4 ../mods/hackflows_perks/tales/tale_*.nut     # 12 tests, 4 launches, ~8 s
```

Exit code 1 while HP-KB2 and HP1 are open.

- `tale_smoke.nut` + `tale_known_bugs.nut` — vanilla (no Reforged): KB1 (Stabilized unlocked through the
  character screen's `general_onUnlockPerk`, naked / medium / heavy armor, and its damage
  multipliers in battle), KB3 (fixed in 1.6.3: perks registered without Reforged).
- `tale_smoke_reforged.nut` + `tale_reforged.nut` — Reforged 0.9.3: HP1 (perks added to Reforged's
  perk groups), Promised Potential replaced by the graded one, its level-5 stage, save/load.
- `tale_sato.nut` — KB2 with Sato's Balance Mod 2.3.1 (compiled, `mod_sato_balance-2.3.1.zip`);
  `tale_sato_control.nut` — the same check with Sato's mod alone (passes).
- `lib/helpers.nut` — `::HPT`.

Packed and `--isolate` agree (checked 2026-11-12).

Not covered: the UI (perk tree), Balance / Battle Flow / Full Force / Bloody Harvest / Flesh on the
Bones mechanics beyond registration.
