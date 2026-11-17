# Proper Druid — scenario test findings

Checked 2026-11-12 on the working tree (0.5.2). No bugs found.

## DR-KB1. Summoned beasts idle / facing wrong way / "both hostile and not" — not reproduced

- Tests: `known_bugs::DR-KB1: ...` (2) and `known_bugs_reforged::DR-KB1 reforged: ...` (2).
- Every beast type, vanilla and Reforged: faction `PlayerAnimals`, allied with the player and the
  druid, has an AI agent, body sprite flipped, and it spends AP within its first two rounds.
- The report (0.5.1, no log) likely needs another mod (XBE? an AI overhaul) or a load-order
  condition; a log with the mod list is needed.

## Reforged 0.9.3 / Hardened 1.26.3 (2026-11-12)

- DR-KB1 still not reproduced: `tale_known_bugs_reforged.nut` and `tale_smoke_reforged.nut` pass on Reforged 0.9.3 and with
  Hardened 1.26.3 (`-r mod_reforged==0.9.3 -r mod_hardened==1.26.3`). Legends is unsupported; the vanilla `tale_known_bugs.nut` also passes on Legends.

## `origin::...a battle and a save/load keep the druids' perks` in the original (2026-11-13) — not a Druid bug

- The full `--env game` run failed it: `[regrowth, beastform] after load: expected [[true, false], [false, true]],
  got [[false, true]]` — one bro left (the Wolf), not a perk lost: the Bear (43 base HP) had died in the AI-fought
  battle (`won` passed, the roster wasn't checked). That run's dir was pruned; the evidence is re-runs of the same
  flow dumping both druids' title, HP, level, perk points and druid skills at the start, after `::Tales.toughen`, the
  battle, `t.save` and `t.load` (engine once, original twice): both druids survive in each, and the dumps after
  the battle, after the save and after the load are identical in both envs (Bear: `perk.druid.regrowth`,
  `actives.druid_regrowth`, `actives.druid_summon_beast`; Wolf: `perk.druid.beastform`, `actives.druid_summon_beast`).
  The original's battles ran to the 36000-frame limit and cost the Bear 50–112 of his 243 HP (the engine's: 25),
  so his death is a matter of rolls.
- Perks persist by the vanilla path (`unlockPerk` adds the skill, the skill container serializes it; the Druid
  scripts have no `onSerialize`/`onDeserialize` of their own); `perk_druid_beastform.onAdded` re-runs on load and is
  idempotent. The start is the same in both envs (same names, HP, skills).
- The test now kills the bandits on the first player turn (`::Tales.scripted`) and checks both survive and each
  druid's perks by title after the load: passes in code, engine, jsdom, ui and the original.
