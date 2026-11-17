// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_druid@dev mod_hooks stdlib@dev
// include: lib/kb1_body.nut

test("DR-KB1: a summoned beast is ours, faces right and acts", ::DRKB1.summon);
test("DR-KB1: every beast type is ours, faces right and acts", ::DRKB1.everyType);
