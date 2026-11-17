// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_hardened==1.26.3 mod_elite_few@dev stdlib@dev
// include: lib/helpers.nut lib/hardened_kb1_body.nut

test("EF-KB1 real Hardened: a negotiation round landing on the same screen restarts it", ::EFKB1.loopRound);
test("EF-KB1 real Hardened: vanilla negotiation, asking for more pay restarts the screen", ::EFKB1.negotiation);
