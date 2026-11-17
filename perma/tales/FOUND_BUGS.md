# Hackflow's Permanent Injuries — scenario test findings

Checked 2026-11-12 on the working tree (2.0.4). No bugs found.

- PE-KB1 (weapon vanishing on Missing Hand, fixed in 2.0.3/2.0.4): passes in all four set-ups
  (world with free / full bag, in battle, struck down and surviving, restore equipment after a
  swap). In battle the weapon is dropped on the bro's tile; whether the loot screen then returns
  it isn't testable headless.
- PE-KB2 (`isNull` in `onShieldHit`, fixed in 2.0.2): passes.

## Legacy bridge (2026-11-12)

- MSU "Tried to read data beyond … Deserialization Emulator" with MSU + Permanent Injuries + Legacy: not reproduced.
  Legacy 2.13 (Nexus 972, bundles the bridge `mod_legacy_perma_hook` 1.1.9 and `mod_career_stats` 1.0.3; zip
  `~/projects/bbm/bbtales/mods/mod_Legacy-2.13.zip`): `tale_legacy_bridge_perma.nut` (Modern Hooks 0.7.0 + MSU 1.9.0 + mod_hooks + Legacy + perma) —
  two save/load rounds, and one with a permanent injury, log no emulator error; the same with MSU 1.8.0 / Modern
  Hooks 0.6.0 (`-r mod_msu==1.8.0 -r mod_modern_hooks==0.6.0`). Control without perma `tale_legacy_control_perma.nut` passes too. The bridge registers
  and runs its queues, but no "MSU Serialization: Loading Legacy × Perma Hackflow" line appears: the report's
  Legacy version (May 2026) wrote serialization data this one doesn't.
