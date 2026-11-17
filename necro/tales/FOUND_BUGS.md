# Proper Necromancer — bugs found by the scenario tests

Found 2026-11-12 on the working tree (0.5.2). Commands run from `~/projects/bbm/bbtales`.
Each test fails now, the same packed and with `--isolate`; vanilla scripts were read to rule out
engine divergences.

## NE-KB2. Mind Meld skips stackable perks — medium (known, cause found)

- Test: `known_bugs::NE-KB2: Mind Meld gives the raised zombie the necro's Fast Adaptation` —
  `./bbtales.py -k NE-KB2 ../mods/necro/tales/tale_known_bugs.nut`
- Observed: necro with Fast Adaptation + Mind Meld raises a thug; the zombie's perks are
  `["perk.battle_forged"]` (its own), `ASSERT raised zombie has perk.fast_adaption: expected true, got false`.
- Cause: `perk_necro_mind_meld.onRaiseUndead` (`necro/scripts/skills/perks/perk_necro_mind_meld.nut`)
  iterates `getContainer().getAllSkillsOfType(Perk)`, and vanilla's `getAllSkillsOfType` drops
  hidden skills (`skill_container.nut:336`, `!skill.isHidden()`). Stackable perks hide themselves
  at 0 stacks (vanilla `perk_fast_adaption` sets `IsHidden = true` in `create` and
  `IsHidden = Stacks == 0` in `onUpdate`; Reforged's stacking perks do the same), so outside the
  moment they have stacks they are never melded. Iterating `m.Skills` (minus garbage) fixes it.

## NE-KB1. Possess targets enemy undead — medium (known, confirmed)

- Test: `known_bugs::NE-KB1: possess can't target an enemy zombie, can a raised one`
- Observed: `possess: [raised, enemy]: expected [true, false], got [true, true]`.
- Cause: the mod keeps vanilla `possess_undead_skill.onVerifyTarget`, which checks only the
  `zombie_minion` flag (`skills/actives/possess_undead_skill.nut:59-79`); the base check rejects
  allies only for attacks (`IsAttack` is false here).
- Note: a raised zombie can't be possessed until it has risen (~1 s of game time).

## NE1. Necromastery uses the perk group's icon: an MSU error at boot under Reforged — low (new)

- Test: `reforged::NE1: no necro perk shares its icon with the pg.necro perk group`
- Observed at boot with Reforged: `ImagePath coui://gfx/necro/perk_mastery.png already set by mod
  mod_dynamic_perks with tooltipID PerkGroup+pg.necro! Skipping this image keyword.`
- Cause: `perk.necro.mastery` (`necro/scripts/config/z_necro.nut:32`) and `pg.necro`
  (`necro/scripts/necro_pg.nut:7`) share `necro/perk_mastery.png`; MSU's nested tooltips key image
  keywords by path, so one of the two loses its hover tooltip and an error goes to the log on
  every start (users send these logs).

## NE2. Possess perk overwrites its icon with the disabled one — low (new)

- Test: `reforged::NE2: Possess perk keeps its enabled icon`
- Observed: `[Icon, IconDisabled]` = `["necro/perk_possess_sw.png", "necro/perk_possess_sw_sw.png"]`.
- Cause: typo in `necro/scripts/skills/perks/perk_necro_possess.nut:9` — `this.m.Icon = perk.IconDisabled;`
  instead of `this.m.IconDisabled = ...`. The skill instance shows the greyed icon wherever the
  instance's icon is used (Reforged/MSU perk lists, tooltips); `IconDisabled` then gets derived as
  `_sw_sw.png`, a missing file.

## Known bugs that pass

- NE-KB4 (22 bros in the Necro origin, fixed in 0.4.2): 22 bros, 16 placed in combat, a battle
  with 16 — passes (the original crash was in the UI, untestable here).
- NE-KB5 (possess stuck after a battle, fixed in 0.2.1): passes.

## Reforged 0.9.3 / Hardened 1.26.3 (2026-11-12)

- Skipped report "Hardened breaks perks" (no log): not reproduced. `hardened_necro::NE-HD` (Reforged 0.9.3 +
  Hardened 1.26.3): a necromancer unlocks every necro perk. The Reforged suite (`tale_reforged.nut`, `tale_smoke_reforged.nut`)
  on 0.9.3, with and without Hardened (`-r mod_reforged==0.9.3 [-r mod_hardened==1.26.3]`), keeps its statuses: NE1, NE2 still fail, the rest pass.
- Under Legends (`tale_known_bugs.nut` with `-r mod_legends==19.4.23`) NE-KB1/NE-KB2
  fail as on vanilla; Legends is unsupported.
