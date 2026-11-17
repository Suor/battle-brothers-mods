# Nicknames for Everyone — bugs found by the scenario tests

Found 2026-11-11 by the headless scenario tests in this dir, on the working tree (0.8.0 + the
Executioner commit; the uncommitted diff touches only CHANGELOG and Makefile). Code refs:
`mod` = `nicknames/scripts/!mods_preload/mod_nicknames.nut`, `titles` =
`nicknames/nicknames/titles.nut`. Commands run from `~/projects/bbm/bbtales`.
Each test below fails now, identically packed and with `--isolate`. Each was checked against
the vanilla scripts (`~/projects/bbm/base/scripts-base/`) to rule out an engine divergence.

## Status after fixes (2026-11-12)

The user's review notes are quoted. Line refs are to the working tree after the fixes. Tests: engine
`./bbtales.py -j 12 ../mods/nicknames/tales/tale_*.nut` went from 53 tests/11 failing to 54/4 (59/4 with the N7 and N1
stub tests), `--isolate` agrees;
code `./codetest.py ../../nicknames/codetests/*.nut` went from 11 failing to 4. Still failing: KB1, KB2 (open,
not touched) and the N5 tests. `make check` passes.

| # | Note | Status |
| --- | --- | --- |
| N1 | "+1, should beware side-effects of a fix" | **Fixed**: the `startNewCampaign` hook records every starting title in `state.hired` (`mod:314-330`) |
| N2 | "+1. currentProps() were intentional to account for traits" | **Fixed**: equipment's effects are subtracted, traits' kept (`mod:73-87`) |
| N3 | "things not being accessible in vanilla is not a bug. Look at how we test probabilities with a special script" | **Not a bug (by design), informational**: the tests are now reports |
| N4 | "I was worried that try/catch will mess up with stacktraces, but should fix" | **Fixed without try/catch**: no flag, a stack check (`mod:295-307`) |
| N5 | "It's kinda important that the guy from event will have the intended title in many cases. So maybe not a bug" | **Not a bug (by design)**: event recruits keep their intended title; the tests are reports, `N5_duplicates.patch` stays, not planned |
| N6 | "+1" | **Fixed**: a fallback perk aliases to a list of perks (`titles:161-170`, `mod:111-119`) |
| N7 | found while fixing N4 | **Fixed**: the stack check looks at `this` of each frame, not at a `setScreen` hook (`mod:295-307`) |
| N8 | found 2026-11-12 by the code env; "probably bogus, should recheck with engine"; then "Ignore then, not a bug" | **Not a bug (by design)**: confirmed in the engine, 93-100% of companions are titled; the test is a report (below) |

**N1, side effects.**
- Existing campaigns: the state format is unchanged (`hired` is still `{title: count}`). In a campaign started
  before the fix, the starting brothers stay unrecorded; nothing else changes. No backfill on load: when it runs,
  starting brothers who already fell are gone, so it could only record the living, which the roster blocks anyway.
- Double recording can't do harm: `hired` is read only by presence (`foreach (title, _ in state.hired)` in
  `fillTitle`), never by count, and the hook adds a title only when it is absent. So a mod calling `onHired()` for
  starting brothers, inside `__original()` or after the hook, leaves the same titles blocked; the counts just follow
  the `onHired()` calls. `onhired_start::N1` checks both points with a stub mod (`mod_onhired_stub/`): titles kept
  and distinct, `hired` = each title once after our loop, twice after the stub's second call.
- Origins that add brothers later (events, Legends origins' recruits) go through `onHired()` as before.
- Other mods: Reforged's militia start has two "the Conscript"; the title is recorded once (see N5).
  Legends' and Reforged's own `startNewCampaign` work runs inside `__original()`, before the hook records.
- Renaming events: a starting brother renamed later leaves his old title in `hired`, so it counts as "fallen" and
  is blocked. Hired brothers have always worked this way.
- KB1 interplay: before KB1's fix, `loadState()` returned a cached state from an earlier campaign in the same session,
  and the hook saved it into the new campaign at start. KB1 is fixed (2026-11-13) by resetting `def.State` before
  `__original()`, so the hook records into the new campaign's own state.
- Tests that compared `state.hired` with `{}` / `{X = 1}` now compare with the state before the test's own actions
  (`tale_events.nut`, `tale_known_bugs.nut`, `saves.nut`, both approaches). A mock regression is in `test.nut`
  ("startNewCampaign records starting titles").

**N2, approach.** `getCurrentProperties()` stays, so traits, background, perks and injuries count as before. What
equipment adds is computed by running only the `SkillType.Item` skills (`generic_item`, which calls the item's
`onUpdateProperties`: armor and helmet weight on Stamina, shields' defense, helmet Vision) on a clone of the
base properties, and it is subtracted. Only item code runs; other skills' `onUpdate` isn't called outside
`skills.update()`, so MSU's scheduled changes aren't touched. Verified by
`factors::N2` (30 armored recruits: factors equal to those without equipment) and the new
`factors::traits' effects on attributes count, armored or not` (hedge knights and sellswords with `fat` (Stamina
-10, Hitpoints +10), armored: factors equal to those from their unequipped current properties; for 22 of 30 the
trait changes the factors, so traits still count; this test fails without the fix). Item effects
are assumed additive, as in vanilla. A mod item with a multiplicative attribute effect would be subtracted
only approximately.

**N3, reframed.** The three `content::N3` tests are now `N3 report: ...` and only probe what they find
(`t.probe("sets", ...)`), in both approaches. `calc_prob.py` shows such sets as "-" / "1 in inf" (checked:
`background.thief + trait.paranoid`, `background.retired_soldier + cost.low`, `trait.strong + trait.tiny` are 0
without mods). It ignores trait stat modifiers for `attr.*` (a documented approximation), so it gives
`trait.paranoid + attr.Initiative.high` 1 in 453, while the engine report says paranoid's -30 Initiative makes that
set unreachable. N2 kept traits' effects, so the trait + attribute report is unchanged.
`calc_prob.py`'s perk fallback model now follows N6 (a fallback counts for every perk it stands in for;
`--selftest` passes).

**N4, approach and stack traces.** With try/catch and a rethrow, the log shows the trace of the rethrow, not of the
error. Measured on the engine (Squirrel 3.2. Its `sqvm.cpp` calls the error handler only when no `try` is on the
stack (`!traps`) or `notifyallexceptions` is set; Squirrel 3.0.4 of the game is assumed to have the same condition, not checked against its source): an event screen
whose `start()` calls a helper that throws logs `buggyHelper <- start <- setScreen (event.nut:158) <- our wrapper`
with the original code. With `try { __original(...) } catch (e) { inEvent = false; throw e; }` it logs only
`mod_nicknames.nut:307 <- the test`: the event's frames are lost. So there is no flag to reset now:
`inEvent()` walks `getstackinfos()` for a frame running a method of an event, contract or encounter (see N7).
Nothing is caught, and there is no wrapper, so the log shows the original stack as is. Cost: one stack walk per
`setStartValuesEx` outside the campaign start, measured ~20 µs at 16 frames deep in codetest's Squirrel 3.2
(the earlier name check ~11 µs), not on the game's VM.

**N5, findings.**
- Events that give their recruit an intended title, set after `setStartValuesEx` and therefore kept: melon_thief
  ("the Melon Mugger"), imprisoned_wildman ("the Animal"), sacrificed_man ("the Sacrifice"), pimp_vs_harlot ("the
  Pimp"), the_horseman ("the Filly Fiddler"), civilwar_deserter ("the Honorable"), fire_juggler ("the Fire
  Juggler"), pirates ("the Sailor", "the Mariner"), lone_wolf_origin_squire ("the Squire"), oathbreaker ("the
  Oathbreaker"), retired_gladiator ("the Wolf"). Of these, only "the Wolf" (a vanilla background title) and "the
  Animal" (the mod's pool) can also come from title generation. All are one-off events, so a duplicate there is very
  unlikely.
- Vanilla-rolled titles: `character_background.onAdded` gives a background title with 25% (`rand(0, 3) == 3`, 44
  backgrounds have `m.Titles`), southern backgrounds a `LastNames` title with 50%, and `addTitle()` gives 10% per
  trait with titles. Measured with `probes/n5_duplicates.nut` in the code env (volunteers event, 20 events per roster, 15
  rosters of town recruits from 12 common backgrounds): 618 of 2700 event recruits (23%) came with a vanilla title.
  Only 11 of them (0.4% of event recruits) duplicated a living brother's title: 1/900, 5/900, 5/900 at roster sizes
  6/12/20. Duplicates grow with the roster.
- Recommendation: keep event titles. Handle only duplicates: on hire (and at the campaign start, for origins like
  Reforged's militia with two "the Conscript"), refill a title that another living brother already wears. Intended
  titles survive unless they are already worn. The patch is trivial: a `wornByAnother()` helper and two conditions.
  It is **not applied**, it is in `N5_duplicates.patch` (`git apply nicknames/tales/N5_duplicates.patch` from
  `mods/`). With it, `events::N5` and `reforged_bp::N5` pass, and `events`, `core`, `reforged_bp`, `start_*`, the
  mock tests and all code tests are unchanged otherwise. Not covered: a vanilla-rolled title equal to a fallen
  brother's or a recently generated one. That is less visible than two living brothers with the same title.

**N7: with real Legends, event recruits weren't deferred (fixed).** Under Legends 19.4.23 (Modern Hooks 0.7.0, MSU 1.9.0), a brother
created in an event screen's `start()` was titled at once: Legends replaces `events/event.setScreen` outright
(`::mods_hookBaseClass`, `mod_legends/hooks/events/event.nut:10` in 19.4.23, the same in the user's clone) over the
mod's wrapper, whatever the queue order. Its `event_manager.update`, which sets after-battle screens, is replaced
too, so wrapping another caller wouldn't do.
- Fix: no hooks. `inEvent()` (`mod:295-307`) is true when a frame's `this` is an `event`, `contract` or `encounter`
  (`::isKindOf`), so any `setScreen()`, `processInput()` or `fire()`, whoever wrote or replaced it, counts. Event
  and contract bros are made by those objects' own code in vanilla, Legends 19.4.23 and Reforged 0.9.3; Legends
  and other mods replacing methods keep `this`, so neither the load nor the queue order matters. Legends 16.x
  (`base/mod_legends_beta_16.3.3...zip`) ships the whole `scripts/events/event` and `event_manager` instead of
  hooks; the class name stays `event`.
- Wider than before: a bro made in an event's `onPrepare()` or option `getResult()` is deferred now too. That is
  safe when the event hires him with `onHired()`, as all vanilla events do; one added to the player roster without
  `onHired()` stays untitled, as one made in a screen already did.
- Rejected: "the bro is in `World.getTemporaryRoster()`" (where all vanilla, Legends and Reforged events make
  recruits) breaks the suite's town recruits, made in the temporary roster.
- Tests, failing before and passing after: `legends_bugs::N7` (real Legends: vanilla `volunteers`, Legends'
  `legend_trader_recruitment`, a screen set directly), `setscreen_replaced::N7` (a stub mod replacing
  `setScreen` outright, queued after nicknames, `mod_setscreen_stub/`). `events::N7` passes before and after, also
  on Reforged 0.9.3 (`-r mod_reforged==0.9.3`, with `setscreen_replaced` too). `legends_stub` (encounter) and
  `legends_bugs::KB4` pass.

**N7 in the original game** (2026-11-12, `~/projects/bbm/bbtales/bbtales.py --env game`: the Steam build 1.5.2.3 under
Proton, its Squirrel 3.0.4):
- `inEvent()` works there: `getstackinfos(i).locals` has `this` for every script frame, the method's object in a
  method (`probes/n7_stack.nut`, "N7 probe": a copy of `inEvent()` is true under an event's method, false outside).
- `events::N7`, both `setscreen_replaced` tests and `onhired_start` pass there, as in the engine and code envs.
- Cost (`probes/n7_stack.nut`, "N7 bench"): 200k calls at a stack depth of 34 frames, none of them an event's (the
  walk goes to the bottom), against a control loop calling an empty function, the two alternating 3 rounds a launch,
  3 launches, timed by the game's live clock (`Time.getExactTime`), the whole game pinned to CPU 2 (one thread of
  a P-core: the game runs on one CPU). Net of the control: **69–79 µs a call, median 72** (9 rounds); the control
  loop 0.04–0.09 µs a call. The engine, the same probe on another P-core, by launch walls: 58 µs median
  (`~/projects/bbm/bbtales/RESOURCES.md`, "The original game"). It runs once per `setStartValuesEx` outside the campaign start: for a town's dozen
  recruits roughly 1 ms (rough estimate: the real stack depth there wasn't measured).
- A tail call drops its frame in both VMs: in `function () { return inEvent(); }` that function's `this` isn't on the
  stack any more (the probe first missed the event that way). So an event method that ends with `return
  someone.makeBro()` (a tail call to code whose `this` isn't the event) wouldn't count as in an event. No vanilla,
  Legends or Reforged event recruit is known to be made that way; not checked across all their events.

## N1. Starting brothers' titles aren't recorded as hired, so a fallen one's title comes back — medium

- Test: `core::N1: starting brothers' titles count as hired` —
  `./bbtales.py -k N1 ../mods/nicknames/tales/tale_core.nut`
- Observed: after the campaign starts, `state.hired` is `{}`; none of the starting titles are
  in it, neither the mod's own ("No Tomorrow") nor the origin's ("the Red", "the Falcon").
  With the "No Tomorrow" brother gone and the 14-day window over, 20 `fillTitle()` calls on
  a brother who has it among his candidates pick it 3 times.
  ```
  ASSERT starting titles missing from state.hired: expected [], got ["No Tomorrow", "the Red", "the Falcon"]
  ASSERT times the fallen No Tomorrow was picked again: expected 0, got 3
  ```
  The same steps for a brother hired in town pick his title 0 times (`core::a gone brother's
  title isn't given again` passes).
- Expected: the starting company's titles count as hired, as the README promises ("avoids
  reusing nicknames already taken by living or fallen brothers"). The starting brothers are
  the ones most likely to fall early.
- Cause: vanilla never calls `onHired()` for the starting roster (no scenario's
  `onSpawnAssets` does); the `startNewCampaign` hook (`mod:313-321`) fills empty titles but
  doesn't add the roster's titles to `state.hired` the way `onHired` does (`mod:353-357`).

## N2. Starting armor turns on "low stamina" titles — medium

- Test: `factors::N2: attribute factors don't depend on the starting equipment` —
  `./bbtales.py -k N2 ../mods/nicknames/tales/tale_factors.nut`
- Observed: of 30 recruits of armored backgrounds (hedge knight, sellsword, squire, retired
  soldier, deserter, militia), 21 have different `attr.*` factors equipped and bare, always
  `attr.Stamina.low` added by the armor:
  ```
  background.hedge_knight Stamina 77/109: ["attr.Bravery.high", "attr.Stamina.low"] vs bare ["attr.Bravery.high"]
  background.sellsword Stamina 70/97: ["attr.RangedDefense.high", "attr.Stamina.low"] vs bare ["attr.RangedDefense.high"]
  background.squire Stamina 85/104: ["attr.MeleeDefense.high", "attr.Stamina.low"] vs bare ["attr.MeleeDefense.high"]
  ```
  A hedge knight with a rolled Stamina of 109 (top of his range) counts as "low stamina".
- Expected: attribute factors judge the rolled attributes against the ranges they were rolled
  from, as `BaseAttrRanges` (`mod:44-54`) and the mock tests (`makeBro(..., baseProps)`) assume.
  `attr.Stamina.low` is in 25 title sets and `attr.Stamina.high` in 21: armored recruits get
  "Huffpuff"-type titles and lose the stamina-talent ones.
- Cause: `buildFactorSet` reads `_bro.getCurrentProperties()` (`mod:73`); `setStartValuesEx`
  has already equipped the recruit and updated the skills, and armor and helmets subtract
  their weight from `_properties.Stamina` (vanilla `items/armor/armor.nut:361`,
  `items/helmets/helmet.nut:351`). `getBaseProperties()` would hold the rolled values (traits'
  modifiers would then drop out too; see N3c for the opposite case).

## N3. Factor sets that vanilla generation can't produce — not a bug (by design), informational

**Under Reforged 0.9.3 + XBE 0.8 (+ its Reforged patch 0.7.2) + Bro Studio 1.3.2 with 1 extra trait and
permanent injuries** (2026-11-13, `probes/n3_combo.nut`, same rules as below, plus every loaded mod's IDs):
- Bro Studio's extra trait and injury are added before the mod titles a recruit (its hooks run inside ours), so they
  are factors (checked on 30 recruits). Starting brothers get the trait but no injury.
- Bro Studio's "Respect excludes" (default on) uses vanilla's one-way check, so every exclusion set stays dead:
  the 48 vanilla ones below, unchanged by Reforged, plus 14 of XBE's backgrounds:
  ```
  Hothead: background.hackflows_cook excludes trait.impatient
  Slapdash: background.hackflows_carpenter excludes trait.clumsy
  the Anchor: background.hackflows_pirate excludes trait.hesitant
  the Dauber: background.hackflows_painter excludes trait.dumb
  the Ember: background.hackflows_blacksmith excludes trait.tiny
  the Hoe: background.hackflows_gardener excludes trait.dumb
  the Offal: background.hackflows_cook excludes trait.bloodthirsty
  the Poison: background.hackflows_cook excludes trait.clumsy
  the Poison: background.hackflows_herbalist excludes trait.bloodthirsty
  the Rogue Bear: background.hackflows_drifter excludes trait.brute
  the Sliver: background.hackflows_carpenter excludes trait.tiny
  the Thimble: background.hackflows_con_artist excludes trait.tiny
  the Tooth-Puller: background.hackflows_surgeon excludes trait.strong
  the Turncoat: background.hackflows_dissenter excludes trait.disloyal
  ```
  With excludes off, all 62 open.
- Still dead: Gramps (a retired soldier costs 15), the Twitchy (paranoid's -30 Initiative, other traits give back
  at most 10), and 3 sets on `injury.missing_hand`, which isn't in `::Const.Injury.Permanent`, the pool Bro Studio
  draws from: the Stub, the Handless, Hand-and-a-Half.
- Opened: the 63 other injury sets (vanilla never generates a permanent injury, so all 66 were dead there; starting
  brothers still can't have them), and Hardhead, Makepeace, Head-On (brute's -5 MeleeSkill is made up by a second
  trait, which vanilla's up to 2 traits allow too: N3c overstated these).
- Total dead: 67 sets (62 + Gramps + the Twitchy + 3 missing_hand), 3 titles dead altogether: the Cap, the Wildling (its other set is on an absent mod), the Stub. Another 64 sets name IDs of
  mods not loaded (Legends, Hackflow's Perks and others).

Tests in `tale_content.nut`: `./bbtales.py -k N3 ../mods/nicknames/tales/tale_content.nut`. Only
vanilla IDs are checked; sets with other mods' IDs are skipped. These are dead sets: the title
can never come from them (it may from its other sets).

a. `N3: vanilla factor sets are possible` — 48 sets need a trait the background excludes
   (`setStartValuesEx` adds a trait only if no skill already there, background first,
   excludes it) or two traits excluding each other both ways. One title is unreachable in
   vanilla altogether: **"the Cap"** (`titles:3357`: thief + paranoid, thief + superstitious).
   The list (title: reason):
   ```
   Black Bone: background.slave excludes trait.strong
   Buckshot: trait.strong and trait.tiny exclude each other
   Come Hither: background.peddler excludes trait.cocky
   Full of Holes: trait.bleeder and trait.survivor exclude each other
   Longstride: background.messenger excludes trait.huge
   the Balalaika: background.minstrel excludes trait.dumb
   the Beaten: trait.ailing and trait.survivor exclude each other
   the Beetle: trait.tiny and trait.tough exclude each other
   the Cabbagehead: trait.tiny and trait.tough exclude each other
   the Cannon Fodder: background.brawler excludes trait.fat
   the Cannon Fodder: trait.deathwish and trait.survivor exclude each other
   the Cap: background.thief excludes trait.paranoid
   the Cap: background.thief excludes trait.superstitious
   the Crowbar: background.miner excludes trait.strong
   the Crust: background.beggar excludes trait.fat
   the Crybaby: trait.craven and trait.fainthearted exclude each other
   the Cuckoo: trait.irrational and trait.optimist exclude each other
   the Cutlet: background.brawler excludes trait.ailing
   the Cutlet: trait.ailing and trait.survivor exclude each other
   the Disgrace: background.paladin excludes trait.drunkard
   the Doormat: trait.craven and trait.fainthearted exclude each other
   the Fat Hog: trait.fat and trait.strong exclude each other
   the Gristle: trait.iron_jaw and trait.tiny exclude each other
   the Gristle: trait.tiny and trait.tough exclude each other
   the Hermit: background.wildman excludes trait.paranoid
   the Holy Roller: background.monk excludes trait.bloodthirsty
   the Hoof: background.shepherd excludes trait.sure_footing
   the Hornet: trait.brute and trait.tiny exclude each other
   the Horseradish: trait.brute and trait.tiny exclude each other
   the Hypocrite: background.monk excludes trait.disloyal
   the Jackal: background.ratcatcher excludes trait.greedy
   the Loser: trait.pessimist and trait.survivor exclude each other
   the Old-Timer: background.retired_soldier excludes trait.tough
   the Pick: background.miner excludes trait.strong
   the Quack: background.butcher excludes trait.clumsy
   the Rotten Stub: trait.ailing and trait.survivor exclude each other
   the Rot Tooth: trait.bloodthirsty and trait.weasel exclude each other
   the Sprat: background.fisherman excludes trait.tiny
   the Toastmaster: background.minstrel excludes trait.dumb
   the Torn Hide: trait.bleeder and trait.tough exclude each other
   the Trouble: trait.irrational and trait.pessimist exclude each other
   the Weed: trait.pessimist and trait.survivor exclude each other
   the Wet Hen: trait.craven and trait.fainthearted exclude each other
   the Wildling: background.wildman excludes trait.tiny
   the Wolf Cub: background.apprentice excludes trait.bloodthirsty
   the Wolfhound: background.houndmaster excludes trait.hate_beasts
   the Woodsprite: background.wildman excludes trait.paranoid
   the Yardstick: background.tailor excludes trait.huge
   ```
   Caveat: mods adding traits after generation (Bro Studio's extra trait, Legends' own
   exclusion lists) may make some of these reachable; in vanilla they are not.
b. `N3: background-bound factors agree with the background` — "Gramps" (`titles:1807`):
   `[background.retired_soldier, cost.low]`, but a retired soldier's `DailyCost` is 15 and
   `cost.low` needs ≤ 10.
c. `N3: trait + attribute sets are reachable` — the kind 0.8.0 fixed for tough + Hitpoints.low
   (commit `a76953e`): the trait shifts the attribute past the threshold.
   ```
   the Twitchy (titles:384): trait.paranoid moves Initiative by -30 -> attr.Initiative.high unreachable
   Hardhead (titles:2798), Makepeace (titles:2826), Head-On (titles:3595): trait.brute moves MeleeSkill by -5 -> attr.MeleeSkill.high unreachable
   ```
   (`.high` needs ≥ the range top − 2 with 3 talent stars.) If N2 is fixed by reading base
   properties, these become reachable and this check should change with it.

## N4. A script error inside any event screen stops titling recruits for the session — low

- Test: `events::N4: an error inside an event screen doesn't stop titling recruits` —
  `./bbtales.py -k N4 ../mods/nicknames/tales/tale_events.nut`
- Observed: after an event screen whose `start()` throws, a recruit made in town gets no title
  (`ASSERT a town recruit made after the broken event has a title`).
- Expected: an error in someone's event only affects that event.
- Cause: the `setScreen` wrappers (`mod:297-306`) do `inEvent = true; __original(...);
  inEvent = false;` without `try`; an error unwinds past the reset and `inEvent` stays true, so
  every later `setStartValuesEx` defers (`mod:335`, `mod:342`). Town recruits then show no
  nickname in the hire screen and get one only on hire, and those with a vanilla-rolled title
  keep it (see N5). Errors in modded events are common (KNOWN_BUGS #4 was one inside
  `setScreen`). The test restores the flag with a screen that completes.

## N5. An event recruit keeps a vanilla-rolled title, even one a living brother wears — not a bug (by design)

Event recruits keep their intended title (the user's call, 2026-11-13). The tests are reports now:
`events::N5 report: an event recruit keeps a vanilla-rolled title`, `reforged_bp::N5 report: repeated starting
titles`. `N5_duplicates.patch` stays, not planned.

- Was: `events::N5: an event recruit doesn't get a living brother's title` —
  `./bbtales.py -k N5 ../mods/nicknames/tales/tale_events.nut`
- Observed: the vanilla `volunteers` event's houndmaster gets "the Kennelmaster" from vanilla
  generation (houndmaster `m.Titles`); with a roster brother wearing "the Kennelmaster", the
  recruit is hired as a second "the Kennelmaster"
  (`ASSERT hired recruit's title differs from the brother wearing the Kennelmaster`).
- Expected: like a town recruit, whose vanilla-rolled title `fillTitle` replaces with one
  checked against the roster, recent and fallen titles.
- Cause: event recruits are deferred (`mod:335/342`) and filled on hire only when the title is
  empty (`mod:349`), so a title vanilla rolled in `setStartValuesEx` (background or trait
  `m.Titles`, `addTitle()`) survives unchecked. Telling it from a title the event set itself
  (e.g. "the Filly Fiddler", which must stay; `events::an event's own title for its recruit is
  kept` passes) needs remembering the title as `setStartValuesEx` left it. The same goes for
  starting brothers, whose non-empty titles the `startNewCampaign` hook keeps (`mod:320`): with
  Reforged, the militia origin starts with two "the Conscript", neither from the mod —
  `reforged_bp::N5: starting brothers' titles are distinct`
  (`./bbtales.py -k N5 ../mods/nicknames/tales/tale_reforged_bp.nut`):
  `ASSERT repeated starting titles: expected [], got ["the Conscript"]`. That was Reforged 0.8.18; on 0.9.3 the
  militia's starting titles are distinct and the test passes, so `events::N5` is the one failing.

## N6. A Starting Perks fallback standing in for several perks aliases to only one — low

- Test: `compat_hackflow::N6: every Starting Perks fallback aliases to each perk it stands in
  for` — `./bbtales.py -k N6 ../mods/nicknames/tales/tale_compat_hackflow.nut` (XBE, Hackflow's
  Perks and Starting Perks by Background loaded).
- Observed: 12 of the 53 fallback→perk pairs are lost, e.g.
  ```
  rf_survival_instinct -> nine_lives (kept perk.dodge)
  rf_survival_instinct -> underdog (kept perk.dodge)
  hold_out -> recover (kept perk.steel_brow)
  rf_promised_potential -> gifted (kept perk.student)
  ```
- Expected: a brother with a fallback perk matches the titles of every perk it stands in
  for (the mock test only checks a fallback with a single canonical perk).
- Cause: `def.Aliases` maps a factor to one factor; `titles:162-166` assigns
  `Aliases["perk." + fallback] <- "perk." + canonical` per pair, so the last canonical in
  `BgPerks.fallbacks`' iteration order wins. Matters mostly with Reforged, where the `rf_*`
  fallbacks are the perks recruits actually get.

## N8. A brother whose factors match no title stays untitled — not a bug (by design)

Ignored (the user's call, 2026-11-13). The roster check is a report now: `no_msu::N8 report: starting brothers left
untitled` (`untitled = []` on the current roll in both envs); `probes/n8_companions.nut` measures the rates.


- Was: `no_msu::without MSU recruits are titled, weapons aren't factors` failed in `--env code` (its roll of the
  starting company): `ASSERT Rudolf titled`. Rudolf is an early-access companion with no traits; his factors
  `attr.Hitpoints.high, background.companion, group.combat, type.melee` match no title, and the companion
  backgrounds have no `m.Titles`, so `buildCandidates()` is empty and `fillTitle()` returns (`// shouldn't happen`).
- How often (code env, 300 recruits per background): without MSU 36 `companion_1h`, 19 `companion_2h`, 25
  `companion_ranged` have no candidates; with MSU 25 `companion_ranged` (`weapon.crossbow` adds none), 0 of the
  other two; 0 of farmhand, daytaler, militia, sellsword, thief, hunter, brawler, monk, squire either way. So in
  the default origin's company an untitled brother is a common roll; the engine's seed `bbtest-nick` just misses it.
- Expected: every brother titled ("Nicknames for Everyone").
- Rechecked in the engine (2026-11-13, `probes/n8_companions.nut`, 300 recruits per background, both envs): not a
  code-env artifact. Untitled after generation, engine without MSU: 19 `companion_1h`, 16 `companion_2h`, 16
  `companion_ranged` (no candidates: 24, 22, 24; vanilla's 1-in-4 sellsword title from `onAdded` covers the rest);
  with MSU: 0, 0, 14 (`companion_ranged`, factors `background.companion, group.combat, type.ranged,
  weapon.crossbow`). The code env gives the same rates. So 93-100% of companions are titled, which is why they're
  seen with titles; the untitled are mostly crossbowmen with no talent or trait factors.
- Not planned: e.g. titles for `background.companion` / `group.combat` alone, or a generic fallback pool.

## Known bugs (KNOWN_BUGS.md) — repro status

| # | Status | Test |
| --- | --- | --- |
| 1 | **Fixed** (2026-11-13, uncommitted: world_state's `onDeserialize` and `startNewCampaign` drop `def.State`, so each campaign reads its own flag): both KB1 tests pass in code and engine. Before: after loading a save made before a hire, `loadState().hired` still has the hired title (`{Goldie = 1}`), and the next title written saves it into the loaded campaign's flags. Also leaks into `fresh=1` reloads, hence `::NickT.resetState()` in the tests. | `known_bugs::KB1: title state doesn't leak into a loaded save` |
| 2 | **Fixed** (2026-11-13, `key` for `_key` in `logOut()`): the test passes in code and engine. Before: `logOut()` threw `the index '_key' does not exist` after removing the batch flags; `nicknames.factors` and the `nicknames.candidates*` flags stayed. | `known_bugs::KB2: logOut() prints and clears the debug log` |
| 3 | **Not ours, fixed in Black Pyramid 1.x**: Black Pyramid 0.4's own save bug (`~/projects/bbm/bbtales/OTHER_MODS_RESULTS.md`); the Nicknames part was never reproduced (Reforged + BP 0.4, 8 recruits, a day, save, load: titles and state intact). The BP 0.4 test is removed; BP 1.4.4 below. | — (was `reforged_bp_kb3`) |
| 4 | **Fixed, regression test**: vanilla's own King's Guard event (the one Legends hooks) recruit is titled on hire with the event's talents; `setStartValuesEx(.., false)` outside events too. On the 0.7.0 and 0.7.1 zips both fail with the users' `the index '0' does not exist`. Legends itself not loaded. | `known_bugs::KB4: ...` (2 tests) |
| 5 | **Fixed, regression test**: a trait inheriting `skill` (as Black Pyramid's do) and a background with `Titles` removed from its delegate chain. Fails on the 0.7.0 zip with `the index 'Titles' does not exist`, as reported. | `known_bugs::KB5: ...` |
| 6 | **Fixed, regression test against a Legends stub**: with `mod_legends` registered and a 4-parameter `setStartValuesEx`, the final wrapper keeps all 4 parameters and passes `_gender`/`_addEquipment` through. Real Legends not testable (no installed zip, source needs a full build). | `legends_stub::KB6: ...` |
| 7 | **Fixed, regression test**: without stdlib, Modern Hooks logs "mod_nicknames (Nicknames for Everyone) requires stdlib (stdlib)" and raises its quitting popup; no script error from the mod. | `no_stdlib::KB7: ...` |

## Known bugs with real third-party mods (2026-11-12)

Real mods from `bbtales/mods/` (`VERSIONS.md`): Legends 19.4.23, Reforged 0.9.3, Hardened 1.26.3,
Black Pyramid 1.4.4 eng, Davkul Rising RF/HD compat 0.4 (Nexus 986, copied as `mod_Davkul_Rising_Rf_Hd_compat-0.4.zip`).
No new bugs.

| # | Status | Tests |
| --- | --- | --- |
| 3 | **Not reproduced** with the reporter's set (Reforged 0.9.3 + Hardened + BP 1.4.4 incl. Undead Curse, Elemental Reforged, Reforged Rogues + Davkul Rising compat, militia origin): 10 hired recruits, 3 of them turned into BP's undead forms (skeleton, mummy, necrosavant: background replaced by `uc_*_background`), 2 days, save, load, a day, save, load: titles, backgrounds, hired state intact, no errors. Undead forms have candidates and keep their titles. | `hardened_bp_bugs::KB3: ...` (3 tests) |
| 4 | **Fixed, regression with real Legends**: Legends' King's Guard (its own `setStartValuesEx(.., false)` + `Talents = []`) recruit is titled on hire, roster UI data builds, survives save/load. With the 0.7.1 zip (`git archive nicknames-0.7.1`) it errors with the users' `the index '0' does not exist`. | `legends_bugs::KB4: ...` |
| 6 | **Fixed, regression with real Legends**: the final `setStartValuesEx` keeps Legends' 4 parameters, `_addEquipment = false` honoured; no Modern Hooks "fewer total parameters" warning in the boot log. | `legends_bugs::KB6: ...` |

`--isolate` and packed agree (all pass).

**KB1, side effects besides session-wide uniqueness** (code reading of `loadState`, `recordGenerated`, `fillTitle`
and the `startNewCampaign` hook, 2026-11-13; the user asked if the leak is maybe desirable):
1. The loaded campaign's own state is ignored, and the next write (any recruit titled, a hire, a campaign start)
   overwrites its `nicknames.state` flag with the session's. Loading another campaign's save loses its record for
   good: its fallen brothers' titles are no longer blocked and can come back, the opposite of uniqueness.
2. Titles of the previous campaign or of a later point of the same one ("hired" is never trimmed) count as fallen
   in the loaded one: blocked for good, saved into its flags, and they stay after a restart.
3. "Generated" days come from another timeline. Loading an earlier save, or starting a new campaign after a long
   one, leaves days later than today: those titles are skipped as "recent" until today passes their day + 14, e.g.
   for ~150 days in a new campaign after day 150. Every town recruit's title is recorded, so that's many titles.
4. Blocking is a preference (`fillTitle` falls back level by level), so a bro is never left untitled; what changes is
   the distribution: brothers with few candidates are pushed to their less likely titles or onto the fallback.
5. The leak persists only through the save it was written into; a restart and loading an untouched save is clean.

**KB1, what happens on load** (code reading, 2026-11-13; the user asked why titles are lost):
- Bros' own titles are not lost: vanilla saves `m.Title` with each bro, and the mod never touches it on load.
- The mod's state `{generated, hired}` is saved in the campaign's `World.Flags["nicknames.state"]`, and loading a save
  restores that flag correctly.
- But `loadState()` (`mod:145-150`) reads the flag only while `def.State` is null, i.e. once per game session; after
  that it returns the cached table. No hook on load or `startNewCampaign` resets it, so the loaded flag is never read.
- So the session keeps using the previous campaign's (or a later point's) `generated`/`hired`, and the first
  `saveState()` (a town recruit titled, a hire, a campaign start) overwrites the loaded campaign's flag with it.
  What is lost is the loaded campaign's own record: its fallen brothers' titles and recent recruits' titles.
- Fixed 2026-11-13 (uncommitted), the leak isn't kept: `onDeserialize` and `startNewCampaign` of world_state reset
  `def.State`, so the next `loadState()` reads the current world's flag; a save without it starts empty, as does a
  new campaign.

