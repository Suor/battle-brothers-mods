// mode: campaign seed=bbtest-battle fresh=1 launch=discordv
// mods: mod_ap_probe mod_msu stdlib@dev
// include: lib/helpers.nut lib/kb31_int_body.nut

// KNOWN_BUGS #31 without Autopilot: vanilla's attack_default makes the same call.

test("KB31: an enemy at full integer fatigue with a free attack evaluates attack_default without an error", ::KB31Int);
