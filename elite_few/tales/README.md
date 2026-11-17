# Elite Few — headless game-scenario tests

Real game scripts on modern-bb-engine through `~/projects/bbm/bbtales`, the mod zipped from this
working tree. `EF<n>` / `EF-KB<n>` tests fail while the bug is open: see `FOUND_BUGS.md` and
`KNOWN_BUGS.md`.

```bash
cd ~/projects/bbm/bbtales
./bbtales.py -j 4 ../mods/elite_few/tales/tale_*.nut    # 16 tests, 6 launches, ~8 s; 5 fail (EF-KB1..3, EF1, the control)
```

- `tale_smoke.nut` + `tale_core.nut` (vanilla + frameworks, `fresh=1`): selectMode none/all, the master's
  extra talent, slaves, the wage shown once hired, event bros (eventAll), EF-KB2, EF1.
- `tale_newobject_control.nut` — EF1's control without Elite Few: Adam's mod_hooks calls a
  `mods_hookNewObject` hook twice on a loaded player party (fails by design: shows the cause).
- `tale_reforged_all.nut` — Reforged 0.9.3 with selectMode "all" from before the campaign: EF-KB3, a recruit's 4th
  talent (a `mods_hookNewObject` hook: `::Tales.recruit` goes through `World.getRoster` for it, FOUND_BUGS).
- `tale_smoke_reforged.nut` — smoke under Reforged.
- `lib/helpers.nut` — `::EFT`: settings set and restored, recruits, a contract looping on one screen.
- `lib/cr_bugs_body.nut`, `lib/hardened_kb1_body.nut` — the tests the Clever Recruiter files (vanilla, Legends) and
  the real Hardened files (bug, control) share.

Not covered: KB #6 (tutorial contract; needs the tutorial fight played), Legends (encounters,
untalented), SSU, the real Hardened, UI.
