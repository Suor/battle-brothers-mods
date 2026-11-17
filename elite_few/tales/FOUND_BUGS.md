# Elite Few — bugs found by the scenario tests

Found 2026-11-12 on the working tree (2.5.0). Code refs: `preload` =
`elite_few/scripts/!mods_preload/z_elite_few.nut`. Each test fails the same packed and with
`--isolate`. Commands from `~/projects/bbm/bbtales`.

## EF-KB1. Hardened sees `acall`, not `processInput`, as setScreen's caller — medium (known, reproduced with a stub)

- Test: `hardened_stub::EF-KB1: ...` — `./bbtales.py ../mods/elite_few/tales/hardened_{stub,control}.nut`
- Observed, with `mod_hardened_stub` (Hardened's hook and its `getFunctionCaller`, copied):
  ```
  ASSERT callers seen by the hook: expected ["processInput"], got ["acall"]
  ASSERT screen restarted by the option: expected 2, got 1
  ```
  Without Elite Few (`hardened_control.nut`) the same test passes. So a negotiation round that
  lands on the same screen isn't restarted: Hardened's empty-dialog soft lock.
- Cause: `markInScreen` (preload:72-77) replaces `setScreen` with `wrap()`, which calls the
  original through `concat_call` → `acall`; Hardened's hook (applied inside it) walks the stack
  to the first named frame and finds `acall` (on the original maybe `concat_call`; neither is
  `processInput`).

## EF-KB2. An error inside an event screen leaves every later bro an "event bro" — medium (known, reproduced)

- Test: `core::EF-KB2: an error in an event screen doesn't leave the event flag on`
- Observed (selectMode none, eventAll on): after an event whose screen throws, a plain recruit:
  `ASSERT a town recruit after the broken event is a master: expected false, got true`.
- Cause: preload:74-76 sets `inEventOrContract = true`, calls the original, resets it, without
  try/finally.
- Note: the deliberate `a broken event` error passes the native `acall` of the wrapper and is
  logged as a SCRIPT_ERROR even though caught; the test expects it (`t.expectErrors`).

## EF-KB3. MSU's dummy player is rolled a master under Reforged — low (known, partly reproduced)

- Test: `reforged_all::EF-KB3: ...`
- Observed: with selectMode "all" set before the campaign, the campaign starts normally (no
  endless loading here, Reforged 0.8.18) and `::MSU.getDummyPlayer()` has `trait.master`:
  `ASSERT dummy player is a master: expected false, got true`.
- Cause: the `buildAttributes` wrap (preload:178-200) rolls every background, including MSU's
  `msu_dummy_player_background` (whose `setStartValuesEx(.., false)` means "no traits").

## EF1. The master bonus to party strength doubles after a load — low/medium (new)

- Test: `core::EF1: master strength bonus stays the same across loads`
- Observed: a level 5 master farmhand adds 2.56 to `player_party.m.Strength`; after a load 5.12:
  `expected [2.56, 2.56, 2.56], got [5.12, 5.12, 5.12]` (packed: every test after the first
  already runs on a reloaded campaign; isolated: `[2.56, 5.12, 5.12]`). Enemy scaling is
  then computed from the doubled bonus for the rest of the session.
- Cause: `mods_hookNewObject("entity/world/player_party", ...)` (preload:206) wraps the party's
  `updateStrength` per object; on a campaign load Adam's mod_hooks fires the "new" hook for the
  player party twice — from its `World.getPlayerEntity` override (a new party object) and from
  its `onCampaignLoaded` pass over all parties (`!!redirect.nut` in `mod_hooks`, the same code in
  21.2 as in the runner's copy). `tale_newobject_control.nut` shows it without Elite Few
  (`[1, 2, 2]` wrapper calls per `updateStrength`). Not an engine divergence: script-only code
  paths. A class hook (`mods_hookExactClass`/Modern Hooks) or a guard like VAP's would avoid it.

## Recruit's 4th talent only in the engine (2026-11-13) — low, a test harness difference, not a mod bug

- `reforged_all::selectMode all under Reforged: a recruit is a master with 4 talents` failed only in the original
  (`--env game`): `expected [true, 4], got [true, 3]`. The master trait comes from a `mods_hookExactClass` on the
  background (applies everywhere); the extra talent from `mods_hookNewObject("entity/tactical/player")` (preload:132),
  which legacy mod_hooks fires only for `create()` of the rosters its `World.getRoster`/`getPlayerRoster` wrappers
  return, not of `World.createRoster`'s.
- `::Tales.recruit` made the roster with `createRoster` once `World.getRoster(id)` raised (the original), so no hook;
  the engine returns a roster for a missing id, so it went through the wrapper. `probes/game/ef_roster_hooks.nut`:
  `[master, talents]` for createRoster / getRoster / getPlayerRoster are `[true, 3]`, `[true, 4]`, `[true, 4]` in
  both, Tales.recruit `[true, 4]` engine vs `[true, 3]` original. Settlements make recruits through `getRoster`, so
  players get the talent. `::Tales.recruit` now creates through `getRoster` too.

## Known bugs not tested

- #6 (tutorial contract, fixed in 2.4.1): needs the tutorial's first fight played.
- #4 SSU, #5 Legends 19: mods not available.

## Discord deep search entries (2026-11-12)

### EF-KB8. Clever Recruiter + Elite Few: `No overload matching this argument list found` — not ours, fixed in Clever Recruiter 2.1.8

- Clever Recruiter 2.1.6's bug, fixed in 2.1.8; its tests (`discord_bugs_cr.nut`, CR 2.1.6) are removed. What they
  showed (both passed, packed and `--isolate`):
  - `EF-KB8: Clever Recruiter's temp player with Elite Few on all masters builds without an error`: with
    `selectMode = all` the campaign start (CR's `world_state.onInit`) and a repeat of its temp-player block
    make the temp player a master without an error.
  - `EF-KB8 mechanism: a zero-argument ::Math.rand() under CR's swapped rand throws the users' error` — it does.
- Why vanilla is safe: both users' logs are Legends 18.2.7, where `skill_container.update` calls
  `setHitpointsPct` → `onUpdateInjuryLayer` → `actor.setDirty` (`this.Math.rand() + this.Math.rand()`).
  CR no-ops only `setHitpoints` on its temp player, so in vanilla adding `trait.master` never reaches
  `setDirty`. CR's swapped `Math.rand` calls the saved native as `::CleverRecruiter.RealRand()`, and the
  overload dispatcher looks the arity's leaf up on `this` (the CR table), so any zero-argument call fails.
  CR's bug, triggered by EF adding a skill during CR's swap; EF could skip rolling while
  `::CleverRecruiter.RealRand != null`.
- Engine note: CR's `::World.createRoster("mod_clever_recruiter")` fails headless (the engine wants an
  integer id); the test wraps `createRoster`/`getRoster`/`deleteRoster` with `::toHash`.

### Not tested

- #9 (Legends 18 + PTR `fillTalentValues` arg count), #10 (Legends/SSU Deathwish on masters): Legends/SSU.

## Real Hardened, Legends, Clever Recruiter 2.1.8 (2026-11-12)

Mods from `~/projects/bbm/bbtales/mods/VERSIONS.md`: Reforged 0.9.3 + Hardened 1.26.3, Legends 19.4.23, Clever Recruiter
2.1.8. Packed and `--isolate` give the same statuses.

### EF-KB1 — reproduced with the real Hardened

- `hardened_bugs_elite_few::EF-KB1 real Hardened: a negotiation round landing on the same screen restarts it` and
  `...: vanilla negotiation, asking for more pay restarts the screen` fail: `::Hardened.getFunctionCaller()` (spied)
  returns `acall`, so Hardened's `contract.setScreen` hook (`mod_hardened/hooks/contracts/contract.nut:79-90`) forces
  `_restartIfAlreadyActive = false`, and "We need to be paid more for this." (vanilla
  `negotiation_templates.nut`, returns `"Negotiation"`) doesn't run the screen's `start()` again:
  `ASSERT EF-KB1: the next negotiation round ran start(): expected 2, got 1`. The screen keeps the previous round's
  text and options: the users' soft lock.
- Control `tale_hardened_real_control_ef.nut` (same tests without Elite Few): both pass, caller `processInput`.

### EF2. With Clever Recruiter 2.1.8 every recruit is rolled for master twice — medium (new)

- Test: `cr218_cr_bugs_elite_few::EF2 cr218: Elite Few rolls a recruit's master once` (vanilla + CR 2.1.8).
- Observed (selectMode roll, multiplier 20, 40 sellswords): 80 rolls, 38 masters (Legends, one roll each: 23);
  `ASSERT EF2: recruits whose master trait doesn't match the real roll: expected 0, got 5`.
- Cause: CR 2.1.8's `character_background.buildAttributes` hook (`clever_recruiter/character_background.nut`) calls
  the original twice for every player (its `CleverRecruiter_MaxAttributes` is set in `player.create`): once with
  every `Math.rand` pinned to its max, then for real. Elite Few's `buildAttributes` wrap (preload:178-200) is inside
  it and rolls (its own rng) and adds `trait.master` each time, so the master chance is roughly doubled and a bro
  can keep the trait from the max pass with non-master attributes. Under Legends the wrap order differs and only
  one roll happens (`legends_cr_bugs_elite_few::EF2` passes). EF-side fix: skip `rollMaster` while
  `::CleverRecruiter.RealRand != null` (CR's pinned pass).

### EF-KB8 — not reproduced with CR 2.1.8 (fixed on CR's side)

- `legends_cr_bugs_elite_few::EF-KB8 cr218: ...` (Legends) and `cr218_cr_bugs_elite_few::EF-KB8 cr218: ...`
  (vanilla) pass: CR's `initBaseAttributes` and a town's `updateRoster(true)` with selectMode all. CR 2.1.8 calls the
  saved native as `RealRand.call(::Math)`, so a zero-argument `Math.rand()` no longer fails, and uses an integer
  roster id (`::toHash`), so the runner's roster-id workaround isn't needed.

### EF-KB10 (Legends) — reproduced

- `legends_bugs_elite_few::EF-KB10 legends: no master rolls Deathwish`: 39 of 600 masters get `trait.deathwish`
  (plain sellswords: 17 of 600). Legends gives it −3 Melee Defense
  (`mod_legends/hooks/skills/traits/deathwish_trait.nut`); `master_trait.nut` excludes neither it nor makes it dubious.

### EF-KB5, EF-KB9 (Legends) — not reproduced

- `legends_bugs_elite_few::EF-KB5 legends: ...` passes: 30 masters have 4 talents each (plain bros 3) and higher mean
  attributes on all 8 (e.g. Melee Skill 58.1 vs 51.7).
- `legends_bugs_elite_few::EF-KB9 legends: ...` passes: Legends 19.4's `fillTalentValues(_num, _force = false)` through
  EF's wrapper with `(3)`, `(3, false)`, `(2, true)`. The report was Legends 18 + PTR; PTR has no current version.

### EF-KB4 (SSU) — not feasible: SSU 8.5.2 doesn't boot on Legends 19.4.23.
