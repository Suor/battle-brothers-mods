# Bro Studio — bugs found by the scenario tests

Found 2026-11-12 on the working tree (1.3.2). Each test fails the same packed and with
`--isolate`. Commands from `~/projects/bbm/bbtales`.

## BS1. "Add good traits" off still adds good traits — medium (new; the bug is in stdlib)

- Test: `core::BS1: no good traits when good traits are off` — `./bbtales.py -k BS1 ../mods/bro_studio/tales/tale_core.nut`
- Observed: `::BroStudio.addTraits(bro, 1, {good = false, bad = true, soso = true})` on 100
  recruits: 50 got a good trait (`trait.eagle_eyes`, `trait.teamplayer`, `trait.quick`, …).
- Cause: Bro Studio passes the `traitsGood` setting as `_opts.good` (`bro_studio/traits.nut`),
  but `::std.Player.addTraits` (`~/projects/bbm/stdlib/stdlib/player.nut:179-195`) filters its
  pool only by `bad` and `soso`; `good` is never read.

## Known bugs not reproduced

- BS-KB1 (veteran gets full rolls with bulk XP): XP for levels 12→15 at once, and 1→14 at once,
  give all-1 veteran rows on the veteran levels; with attrsVeteran 15 rolls are full up to 15
  and veteran after. The "blue vial" item is unknown, so its path (a level reset?) isn't covered.
- BS-KB2 (Hardened crash with injured recruits): 200 recruits with a permanent injury under
  Reforged 0.9.3, one hired and fought a battle: no error (with Hardened: below).
- BS-KB3 (Clumsy as a positive trait): 300 good-only rolls, no bad or so-so trait.
- BS-KB6 (talents min/max, fixed in 1.0.1): 300 recruits with 3..5 / 50%: 72 × 3, 149 × 4, 79 × 5.

## Discord deep search entries (2026-11-12)

### BS-KB1 extension (Gifted / Blue Vial max rows on a veteran) — not reproduced

- Tests (`tale_discord_bugs.nut`, launch `discord`, pass packed and `--isolate`):
  - `BS-KB1: Gifted on a level-12 bro keeps its max row`: rows for Gifted + levels 13–14 are
    `[[4, 4, 4, 5, 3, 4, 3, 4], [1×8], [1×8]]`, the max row first.
  - `BS-KB1: Gifted after the level-up screen was opened on a pending veteran level`: the veteran row built
    first, then Gifted: `[[max], [1×8]]`, one max row.
- Gifted inserts its row at the front (`fillAttributeLevelUpValues(1, true)`), so Bro Studio's
  `isVeteranAttrs` sees a non-veteran front row and leaves the rows alone. Reforged's Blue Vial and
  Discovered Talent (the thread's other two sources) weren't tried.

## Real Hardened and Legends (2026-11-12)

- BS-KB2 (Hardened) — not reproduced: `hardened_bugs_bro_studio::BS-KB2 hardened: 200 injured recruits generate` and
  `...: every permanent injury on a hired bro survives a battle and a load` (all 11 of `::Const.Injury.Permanent`,
  two battles, save/load) pass on Reforged 0.9.3 + Hardened 1.26.3.
- BS-KB4 (Legends, fixed in 1.3.1) — regression passes on Legends 19.4.23: `legends_bugs_bro_studio::BS-KB4 legends: ...`
  (no Modern Hooks error at boot; recruits get injuries and 4 talents; an injured hire fights, save/load).
