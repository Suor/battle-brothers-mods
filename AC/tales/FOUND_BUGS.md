# Accessory Companions — bugs found by the scenario tests

Checked 2026-11-12 on the working tree (2.1). Commands from `~/projects/bbm/bbtales`.

## AC-KB1. Companions have Reach 0 under Reforged — medium (known, confirmed for every type)

- Test: `reforged::AC-KB1: unleashed companions have the Reach of their Reforged kin` —
  `./bbtales.py -k AC-KB1 ../mods/AC/tales/tale_reforged.nut`
- Observed: every companion type unleashed through the real skill has `Reach = 0`; their Reforged
  kin: Wardog/Warhound/Warwolf 4, Direwolf 5, Hyena 4, Spider 3, Snake 7, Nacho 4, Unhold 10,
  Schrat 8, Noodle 14 (Alp 0 both). A fed Nachzehrer also doesn't gain the +2 Reach Reforged's
  `ghoul.grow` gives (`reforged::AC-KB2 ...`, its Reach assert).
- Cause: companions are AC's own classes inheriting `entity/tactical/actor`
  (`AC/scripts/companions/types/*.nut`), so Reforged's per-enemy hooks
  (`3rdparty/reforged/mod_reforged/hooks/entity/tactical/enemies/*.nut`, `onInit` setting
  `BaseProperties.Reach`, plus their perks) never run on them. Under Reforged's reach rules that
  makes every companion lose its reach duels.

## AC-KB2. Tamed Nachzehrer doesn't gain max HP — not reproduced without Hardened

- Vanilla and Reforged: one feast takes a tamed and a wild Nachzehrer from size 1 to 2 and both
  gain +120 max HP. The report was with Hardened (not installed here).

## AC-KB3 (fixed in 2.1) — passes: Tame's hit chance without stdlib is a float, no error.

## Discord deep search entries (2026-11-12)

### AC-KB5. Tamed Alp crash — not reproduced

- Tests (`tale_discord_bugs.nut`, launch `discord`, pass packed and `--isolate`):
  `AC-KB5: a tamed Alp against wild Alps, AI rounds` (6 AI rounds, the tamed Alp alive, both wild ones too),
  `AC-KB5: a tamed Alp kills a wild Alp with Nightmare, then dies to the other` (`kill()` both ways, 3 more
  rounds; the bro's collar slot is empty after, as for a dead wardog). No script error in either.
- Vanilla 1.5.2 has no `alp_shadow` script (the alp's `onDeath` only checks for one), so the shadow branch
  of `companions_alp.onDeath` can't be exercised here.

## AC-KB2 with the real Hardened (2026-11-12) — reproduced

- Test: `hardened_bugs_ac::AC-KB2 hardened: ...` (Reforged 0.9.3 + Hardened 1.26.3; the body of `tale_reforged.nut`'s
  AC-KB2 test). Packed and `--isolate` fail the same.
- Observed: `[size, HP max, Reach]` before `[[1, 80, 2], [1, 120, 2]]` (tame, wild); after one Gruesome Feast the
  wild ghoul grows by `[1, 120]` and the tame one by `[1, 0]`; Reach growth 2 vs 0 (AC-KB1).
- Cause: Hardened replaces the ghoul's per-size stats in its `enemies/ghoul.grow` hook
  (`mod_hardened/hooks/entity/tactical/npcs/beasts/ghoul.nut`, `b.setValues(::Const.Tactical.Actor.HD_GhoulMedium/High)`);
  AC's `companions_nacho` is its own class, so its growth keeps vanilla's (no HP gain). Same root as AC-KB1:
  per-enemy hooks of Reforged/Hardened never reach AC's companion classes.
