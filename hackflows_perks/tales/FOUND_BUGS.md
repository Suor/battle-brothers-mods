# Hackflow's Perks — bugs found by the scenario tests

Checked 2026-11-12 on the working tree (1.6.3). Commands from `~/projects/bbm/bbtales`.

## HP-KB2. Sato's Lone Wolf and Nimble texts lost — low (known, cause found; an interaction)

- Test: `sato::HP-KB2: Sato's Lone Wolf and mastery texts survive the added perks` —
  `./bbtales.py ../mods/hackflows_perks/tales/tale_sato.nut`; control `tale_sato_control.nut` passes.
- Observed (Sato 2.3.1): `[Lone Wolf, Nimble, Sword Mastery, Dagger Mastery] show Sato's texts: expected [true, true, true, true], got [false, false, true, true]`.
- Cause: Sato patches tooltips by a fixed tree position: `local perk = ::Const.Perks.Perks[4][2];
  if (perk.ID == "perk.lone_wolf") ...` (`3rdparty/sato_balance_mod/script_hooks/mod_sb_perks.nut:27` at tag v2.3.1).
  This mod inserts Bloody Harvest at row 4 position 0 and Balance after Overwhelm
  (`hackflows_perks/scripts/config/z_hackflows_perks.nut`, `addPerk(4, ...)`), so Lone Wolf moves
  to `[4][4]` and Sato's check silently skips it; likewise Nimble (`[5][2]`, Sato 2.3.1) moves to `[5][3]` after Full Force. Only the tooltip text is lost: Sato's
  `lone_wolf_effect` hook (10%, 2 tiles) still applies, so the tree describes the vanilla perk.
  Sato 1.4.1 didn't patch Nimble's text, 2.3.1 does. Appending to the rows instead of inserting would avoid it.

## HP1. Full Force never reaches Reforged's "large" perk group — low (new)

- Test: `reforged::HP1: perks are added to Reforged's perk groups`
- Observed: `groups the mod targets that Reforged lacks: expected [], got ["pg.rf_large"]`.
- Cause: `hackflows_perks/scripts/!mods_preload/mod_hackflows_perks.nut:146` maps `"pg.rf_large"`,
  which Reforged 0.8.18 and 0.9.3 don't have; the wrapper of
  `PerkGroups.add` just never sees it, silently.

## Known bugs that pass

- HP-KB1 (Stabilized can't be picked): unlocking through the character screen spends the point
  and adds the perk naked (bonus 0), in medium (mail shirt + full helm, 34 fatigue: bonus 25) and
  heavy armor (bonus 0), tooltip builds; in battle a thug's hit is ×0.75. Not reproduced on
  vanilla: likely another mod.
- HP-KB3 (fixed in 1.6.3): all six perks registered under vanilla.

## Noticed, not tested

- `perk_hackflows_potential.addPerkTrees` (copied from Reforged's Realized Potential) re-adds
  overflowing perks with `tier = i + 1` where `i` is the perk's position in the row, not the row.

## Reforged 0.9.3 (2026-11-12)

- HP1 still open on Reforged 0.9.3 (and with Hardened 1.26.3): `reforged::HP1` fails the same way,
  `groups the mod targets that Reforged lacks: got ["pg.rf_large"]`. The rest of the Reforged suite passes.
