# Challenges — scenario test findings

Checked 2026-11-12 on the working tree (0.5.0): no bugs found. The only known report (no
level-up button with Legends, no log) needs Legends: not tested.

## Legends 19.4.23 (2026-11-12)

Files `tale_legends_bugs_challenges.nut` (`// mods: mod_legends==19.4.23 mod_challenges`) and control `tale_legends_control_challenges.nut`;
shared `legends/level_up_body.nut`. Packed and `--isolate` agree.

- "Can't level up bros, no button" (Legends report): not reproduced in what can be checked headless. A bro with
  4 level-ups gets `levelUp` values and perk points in `convertEntityToUIData` with Challenges, the same as without
  (`CH-KB1 legends`, control pass). The button itself is JS; untestable here.

### CH-L1. Banned followers are still offered under Legends — low (new)

- Test: `legends_bugs_challenges::CH-L1: banned followers are left out of the hire list under Legends` — with
  `ban_follower.cook`/`ban_follower.scout` on, both stay in `getFollowersForUI()`.
- Cause: Legends replaces `retinue_manager.getFollowersForUI` per instance (`mods_hookNewObject`,
  `mod_legends/hooks/retinue/retinue_manager.nut:17`), which shadows the mod's class hook
  (`challenges/followers.nut:54`). Fix if Legends is to be supported: hook with `::mods_hookNewObject` after Legends.
