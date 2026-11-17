// mode: campaign seed=bbtest-battle fresh=1 launch=kb31
// mods: mod_autopilot_new@dev mod_ap_probe stdlib@dev
// include: lib/helpers.nut lib/kb31_body.nut

// KNOWN_BUGS #31 with Autopilot; tale_kb31_vanilla.nut runs the same without it (the test is in lib/kb31_body.nut).

test("KB31: an enemy at full fatigue with a free attack evaluates attack_default without an error", ::KB31);
