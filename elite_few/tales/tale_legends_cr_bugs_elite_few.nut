// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_legends==19.4.23 mod_clever_recruiter==2.1.8 mod_elite_few@dev stdlib@dev
// include: lib/helpers.nut lib/cr_bugs_body.nut

test("EF-KB8 cr218: CR's temp player with Elite Few on all masters builds without an error", ::EFCR.tempPlayer);
test("EF-KB8 cr218: a town's recruits refresh with Elite Few on all masters", ::EFCR.refresh);
test("EF2 cr218: Elite Few rolls a recruit's master once", ::EFCR.masterOnce);
