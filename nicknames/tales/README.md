# Nicknames — headless game-scenario tests

Real game scripts on modern-bb-engine through `~/projects/bbm/bbtales` (see its README), the mod
zipped from this working tree. Tests named `N<n>: ...` or `KB<n>: ...` describe correct
behaviour and fail while the bug is open: see `FOUND_BUGS.md` and `KNOWN_BUGS.md`.

```bash
cd ~/projects/bbm/bbtales
./bbtales.py -j 8 ../mods/nicknames/tales/tale_*.nut              # all: 47 tests, 8 launches, ~19 s
./bbtales.py --isolate -j 10 ../mods/nicknames/tales/tale_*.nut   # one launch per test, ~30 s
./bbtales.py -k N2 ../mods/nicknames/tales/tale_factors.nut       # one test
```

Exit code 1 while the open bugs are open (11 failing tests: N1–N6, KB1, KB2).

The other mods of a launch come from the runner's mod store by the header's specs (`~/projects/bbm/bbtales/README.md`,
"Mods").

## Files

Vanilla 1.5.2 + Modern Hooks + MSU + stdlib, seed `bbtest-nick`, `fresh=1` (each test starts
from the campaign as it started), one shared launch:

- `tale_core.nut` — starting roster titled; recruits titled with a title among their candidates;
  generated titles recorded and expiring after 14 days (15 world days at speed 16); avoiding
  recent, worn and fallen brothers' titles; settlement roster refresh; hiring records the
  title; save/load; debug logging; N1.
- `tale_factors.nut` — the factor set off real brothers: base attribute ranges, attribute factors,
  MSU weapon types, mastery perks, background/group/cost/type, traits and injuries, the
  Executioner background (HEAD), Black Pyramid IDs (relabelled vanilla skills); N2.
- `tale_content.nut` — the title pool against vanilla content: every factor ID exists (other mods'
  IDs skipped by prefix); N3 (factor sets vanilla can't produce).
- `tale_events.nut` — 0.8.0's deferred titles for event recruits: vanilla `volunteers` and
  `the_horseman` events through the event manager, turned-away recruits; N4, N5.
- `tale_known_bugs.nut` — KNOWN_BUGS #1, #2, #4, #5 (regressions; they fail on the 0.7.0 and
  0.7.1 zips with the users' original errors).

Own launches:

- `tale_no_stdlib.nut` — KNOWN_BUGS #7: Modern Hooks without stdlib (menu).
- `tale_no_msu.nut` — 0.7.0's optional MSU.
- `tale_start_gladiators.nut`, `tale_start_militia.nut` — other origins: titles the origin sets stay,
  twelve starting brothers get distinct titles.
- `tale_reforged_bp.nut` — Reforged 0.9.3 + Black Pyramid 1.4.4 (militia origin): BP phobias reach the
  candidates; N5 at campaign start.
- `tale_hardened_bp_bugs.nut` — KNOWN_BUGS #3 with the reporter's whole set on current versions (on Black Pyramid 0.4
  it was BP's own save bug, fixed in 1.x).
- `tale_known_bugs_ct.nut` — KNOWN_BUGS #1 through a new campaign in the same session: code env only (`::CT`).
- `tale_basics.nut` — the cases of `../test.nut` (mocks) on real brothers.
- `probes/` — measurements, not part of the suite (`n5_duplicates.nut`, N5).
- `tale_setscreen_replaced.nut` — N7 with `events/event.setScreen` replaced outright by `mod_setscreen_stub/`,
  queued after nicknames, as Legends does.
- `tale_onhired_start.nut` — N1 with `mod_onhired_stub/` calling `onHired()` for the starting brothers before and after
  the mod's start loop.
- `tale_compat_hackflow.nut` — with XBE, Hackflow's Perks, Starting Perks by Background: factor IDs
  of those mods exist, starting perks become factors; N6.
- `lib/helpers.nut` — `::NickT` helpers, included by the `// include:` header.

Packed and `--isolate` runs give the same statuses, asserts and probes, and so do repeated
runs (checked 2026-11-11).

Not covered: Rosetta/Russian titles (needs `data_014.dat`, which breaks vanilla 1.5.2 boot on
this install), UI, real Legends.
