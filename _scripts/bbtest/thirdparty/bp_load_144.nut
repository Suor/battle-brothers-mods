// mode: campaign seed=bbtest-nick origin=scenario.militia
// mods: mod_black_pyramid==1.4.4 mod_hooks stdlib@dev
// include: lib/bp_load_body.nut

// Black Pyramid 1.4.4 reads the presence bool always: both loads pass (0.4's bug: OTHER_MODS_RESULTS.md).
::BPLoad.register(test);
