// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_reforged==0.9.3 mod_druid@dev mod_hooks stdlib@dev
// include: lib/kb1_body.nut

// lib/kb1_body.nut under Reforged 0.9.3 (its beasts' stats and AI).

test("DR-KB1 reforged: a summoned beast is ours, faces right and acts", ::DRKB1.summon);
test("DR-KB1 reforged: every beast type is ours, faces right and acts", ::DRKB1.everyType);
