// mode: campaign seed=bbtest-battle fresh=1 launch=discord
// mods: mod_autopilot_new@dev mod_ap_probe stdlib@dev
// include: lib/helpers.nut lib/kb31_int_body.nut

// KNOWN_BUGS "Discord deep search" entries with Autopilot; tale_discord_bugs_vanilla.nut runs KB31 without it.

test("KB31: an enemy at full integer fatigue with a free attack evaluates attack_default without an error", ::KB31Int);
