// mode: campaign seed=bbtest-battle fresh=1 launch=kb31v
// mods: mod_ap_probe mod_msu stdlib@dev
// include: lib/helpers.nut lib/kb31_body.nut

// KNOWN_BUGS #31 without Autopilot, to tell its share from vanilla's (the test is in lib/kb31_body.nut).

test("KB31: an enemy at full fatigue with a free attack evaluates attack_default without an error", ::KB31);
