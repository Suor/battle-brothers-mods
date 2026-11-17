# Useful Things — bugs found by the scenario tests

## Legends 19.4.23 (2026-11-12)

- US-KB2 (Legends: `the index 'onUpdate' does not exist` hooking `hand_to_hand`): not reproduced on Legends 19.4.23.
  `legends_bugs_useful::US-KB2 legends` (`// mods: mod_legends==19.4.23 mod_useful`) boots without errors and the level-scaled
  hand-to-hand damage applies ([5,10], [15,20], [25,30] at levels 1, 6, 11). Legends now hooks vanilla's
  `hand_to_hand`/`brawler_background` (`mod_legends/hooks/skills/actives/hand_to_hand.nut`) instead of shipping its
  own classes, so `onUpdate`/`onAnySkillUsed` exist in the chain. The mod's wraps still assume they exist.
- Running the vanilla `tale_core.nut` on Legends (`-r mod_legends==19.4.23`) fails 2
  tests on Legends' own content (no `thrust` on the named goblin spear, nets differ), not on the mod.
