# Fun Facts — headless game-scenario tests

Real game scripts on modern-bb-engine through `~/projects/bbm/bbtales` (see its README), the mod
zipped from this working tree (HEAD + the uncommitted `setPlayer` change). Tests named
`F<n>: ...` or `KB<n>: ...` describe correct behaviour and fail while the bug is open: see
`FOUND_BUGS.md` and `KNOWN_BUGS.md`.

```bash
cd ~/projects/bbm/bbtales
./bbtales.py -j 8 ../mods/fun_facts/tales/tale_*.nut              # all: 51 tests, 8 launches, ~10 s
./bbtales.py --isolate -j 12 ../mods/fun_facts/tales/tale_*.nut   # one launch per test, ~16 s
./bbtales.py -k F1 ../mods/fun_facts/tales/tale_bugs.nut          # one test
```

Exit code 1 while the bugs are open: 14 failing tests (F1–F8, KB2, KB3, KB4, KB9 ×2) and the
`no_stdlib` launch, which fails at boot (KB6).

The other mods of a launch come from the runner's mod store by the header's specs (`~/projects/bbm/bbtales/README.md`,
"Mods").

## Files

Vanilla 1.5.2 + Modern Hooks + MSU + stdlib + mod_hooks shim, seed `bbtest-battle`, `fresh=1`
(each test starts from the campaign as it started); four launches (`launch=` in the header):

- `tale_core.nut` — accounting in battles against the game's own counters: an AI battle (each
  bandit's death recorded per instance and matched to the killer's records, LifetimeStats,
  CombatStats, XP, battle ids), battle ids across battles, a bro killed in battle (casualty
  stub, obituary entry, death record, tooltips), save/load of the living and the fallen (twice),
  friendly fire (PlayerKills, KilledByBros), suicide, injuries suffered and inflicted, nine
  lives saved / used and died, effects added in battle, reserve bros (slacked, drunk), fleeing
  and rallying, a death outside battle the way vanilla events do it, dismissal.
- `tale_bugs.nut` — F1–F4, F7, F8.
- `tale_economy.nut` — the "Spent" facts against what the assets lose: wages vs money, food vs
  the stash, medicine on an injury, arrows shot, hiring through a town's hire module, healing
  through a temple module, buying food through a marketplace (HEAD's average prices); F5.
- `tale_tooltips.nut` + `tale_known_bugs.nut` — tooltip texts from stats set as a load sets them (kills,
  deaths, injuries, nine lives, fled, slacked, effects, costs and TCO), the roster tooltip,
  the obituary tooltip with and without facts, MSU's `Fallen` tooltip, the obituary screen's
  data; F6, KNOWN_BUGS #3, #4, #5 (English), #7, #9 (English), #10, #11, #13.

Own launches:

- `tale_reforged.nut` — Reforged 0.8.18, as in the reports: KNOWN_BUGS #1 (the vanilla event from the
  user logs fired for real).
- `tale_reforged9.nut` — Reforged 0.9.3: #12 (scripted and AI battles).
- `tale_rosetta.nut` — Rosetta 0.4.0, Russian switched on by hand: #5, #9 in Russian.
- `tale_scenario_mode.nut` — KNOWN_BUGS #2: a kill in the main menu's Combat Basics scenario.
- `tale_no_stdlib.nut` — KNOWN_BUGS #6: the mod without stdlib.
- `tale_ui_page.nut`, `tale_ui_career_stats.nut` — in the real UI page, in jsdom and in Chromium (`// needs: page`, the runner's
  README): the obituary rows' hover tooltips; KNOWN_BUGS #8 in the page (Reforged 0.9.3 + Career Stats).
- `lib/helpers.nut` — `::FFT` helpers, included by the `// include:` header; the shared ones are the runner's
  `::BBT` (its README, "Helpers"): `::BBT.scripted` plays the company in `t.battle`.

Packed and `--isolate` runs give the same statuses and asserts (a generated recruit's name
differs); repeated runs too, except one probe of the Reforged AI battle (kills per bro vary:
the engine's randomness, see the runner README). Checked 2026-11-12.

The same scenarios against the released zip (`mod_fun_facts_1.0.3.zip` in the `// mods:` line)
show which bugs are HEAD's: F1 passes on 1.0.3, F2 and the HEAD-only features (temple list,
buys) don't apply; KB1 fails there with the users' stack. See `FOUND_BUGS.md`.

Not covered: UI/JS (obituary screen, tooltip rendering), real Legends (#13's Vala), Career Stats
(#8, not installed), Pandora's Hobby compat (not installed), Reforged's corpse explosion (#11 is
covered by the same null-attacker hit in vanilla).
