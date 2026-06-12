# Beast Branch — handoff

Status: **implemented** (was design-only in `plan.md`). Builds clean: `make test` (Syntax OK +
Tests OK), `make check-gfx` (GFX OK), `rosetta -qc druid/rosetta_ru.nut .` (Rosetta OK). Not yet
verified in-game — the toolchain can't run the engine; logic is unit-tested, behaviour is not.

Read alongside `plan.md` (the *what/why*), `facts.md` (code-grounded facts), `user-requests.md`
(verbatim asks). This file is the *where it landed* and *what's left*.

## What shipped

Two mutually exclusive perk groups, chosen implicitly by the first group perk taken:
- **Nature (Supporter):** Regrowth, Hatch, Entangling Roots, Apex Predators
- **Beast (Fighter):** Beastform (gate) → Beast Aura, Beast Rage
- **Venom:** ungrouped, adapts to the side you commit to
- **Pack Leader: removed** (folded into Beast Aura)

Row layout (0-based; char level = Row + 2): Regrowth/Beastform R1, Hatch/Beast Aura R3,
Entangle R4, Venom⟷Beast Rage R5, Apex R6.

### Files
- `scripts/config/z_druid.nut` — perk defs + `::Const.Druid`: `Biomes` (Starter `wolf`,
  `UnlockLevel = 5`), `Beastform`/`Rage`/`Aura` tunables, `GroupPerks`, **`isPerkBlocked`** (the
  single exclusion rule), **`beastformAllows`** (equip limits by fatigue). All numbers are Q5
  balance placeholders.
- `scripts/skills/perks/perk_druid_beastform.nut` — passive transform: `onUpdate` stat mults;
  `onAdded` → `::Druid.applyBeastform` (strip forbidden gear + beast look).
- `scripts/skills/perks/perk_druid_beast_aura.nut` — VIP attraction bump (leash) + `onCombatStarted`
  tags allied beasts with the aura effect.
- `scripts/skills/effects/druid_beast_aura_effect.nut` — carried by beasts; grants Resolve +
  fearless while a Beast-Aura druid is within `Aura.Range`.
- `scripts/skills/perks/perk_druid_beast_rage.nut` — feral-rage clone (vanilla-safe): regen instead
  of damage reduction, +1 stack on miss, shield-drop + roar at `Rage.ShieldDropThreshold`.
- `scripts/skills/perks/perk_druid_venom.nut` — adds the venom coat to the druid himself in
  Beastform (`onCombatStarted`); supporter beasts still get it in `druid_summon_beast`.
- `scripts/skills/actives/druid_summon_beast.nut` — plain `wolf` until level 5, then biome pool;
  Beast Aura → confident + fearless + `ai_protect` leash; every summon carries the aura effect.
- `scripts/!mods_preload/mod_druid.nut` — equip ban (`item_container.equip` hook), `applyBeastform`
  + `applyBeastformLook` (uses the vendored `druid_beast_*` brushes), perk gating
  (`player.unlockPerk` guard + `druid_blocked` stamping in data_helper), `checkMorale` fearless
  floor, BgPerks chances.
- `ui/mods/druid.js` / `druid.css` — JS gate (`isPerkUnlockable` honours `druid_blocked`) + greys
  blocked perks.
- `scripts/scenarios/world/druid_scenario.nut` — "The Wolf and the Bear": two L3 druids (Bear=PC
  with Regrowth, Wolf with Beastform), no hunters/poachers in roster or recruitment
  (`onUpdateDraftList`). Born-to-it intro flavour.
- `druid/rosetta_ru.nut` — RU translations for all of the above.
- `test.nut` / `mocks.nut` — unit tests for `isPerkBlocked`, `beastformAllows`, config.

### Beast look (no Fantasy Brothers dependency)
- `brushes/druid_beast.brush` + `gfx/druid_beast.png` — vendored Baku sprites (body/head/hair +
  `_dead`/`_injured`), sprite ids renamed `druid_beast_*` to avoid colliding with Fantasy Brothers.
- `build_beast_brush.sh` (mod root, **not** in SOURCES) rebuilds them from `../../3rdparty/fantasy`
  via `bbrusher` under wine. Re-run if the asset set changes.
- `brushes` was added to SOURCES in the `Makefile`.

### Perk icons
Real icons made with the `bb-icons` skill (codex subjects → `compose_perk.sh`): Beastform = clawed
paw, Beast Aura = howling wolf + green nimbus, Beast Rage = roaring maw. Workspace:
`gfx/druid/_gen/beastbranch/` (`wip/` subjects+prompts+refs, `out/` finals+previews). Installed over
the placeholders at `gfx/druid/perk_beast*.png` (+`_sw`).

## Gotchas / decisions worth knowing
- **Equip ban is enforced at `item_container.equip`** (returns false) so it covers UI, tactical and
  AI. Forbidden gear already worn at transform is relocated via perma's `missing_hand` algo
  (drop in battle → bag → stash), never lost.
- **Beast Aura leash** uses vanilla `ai_protect` + a modest `TargetAttractionMult` bump on the
  druid. Side effect: foes weigh him slightly heavier as a target. If that's unwanted, a custom
  "stay near master" behaviour would be needed instead.
- **`isPerkBlocked` is the one source of truth**; consulted by both the JS UI gate and the squirrel
  `unlockPerk` safety net. DynamicPerks path only gets the squirrel net (no greying).
- **`bb-icons/scripts/compose_perk.sh` is locally WIP-broken** (`DISCGLOW: unbound variable`, stale
  refs after a glow-preset refactor). I did NOT edit it — worked around with `GLOW=none DISCGLOW=0`.
  Fix that script before the next icon batch.
- Bash **cwd persists between calls** here; `cd` once and relative paths stick.

## Open / follow-up
- **Q5 balance pass (in-game):** Beastform bonuses, Rage formula/threshold (~10), Aura Resolve
  (~10) and radius (~2), Apex strength. All in `::Const.Druid` for easy tuning.
- **In-game verification:** start "The Wolf and the Bear"; check the two druids' perks/talents, the
  greyed-out closed path, equip ban + relocation on taking Beastform, the beast look, Rage stacks +
  shield drop, the summon leash, and that hunters/poachers don't appear for hire.
- **Beast Aura aura→other bros' AC beasts:** covered via `onCombatStarted` tagging all PlayerAnimals;
  confirm AC-unleashed beasts actually land in that faction.
- **Beast stat scaling with level / beast perks at thresholds** — deferred (plan §Скейлинг).
- **AC integration** for beast scaling/looks — still a README "plans" item.
- Decide whether to commit `build_beast_brush.sh` and the `_gen/` workspace.
