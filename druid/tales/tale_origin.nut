// mode: campaign seed=bbtest-battle origin=scenario.druid fresh=1
// mods: mod_druid@dev mod_hooks stdlib@dev

// The Druids origin: the Bear and the Wolf.

test("origin: the Bear and the Wolf", function (t) {
    local got = t.roster().map(@(b) [b.getTitle(), b.getLevel(), b.getBackground().getID(),
        b.getSkills().hasSkill("perk.druid.regrowth"), b.getSkills().hasSkill("perk.druid.beastform"),
        b.getSkills().hasSkill("actives.druid_summon_beast")]);
    t.eq(got, [["the Bear", 3, "background.hackflows_druid", true, false, true],
               ["the Wolf", 3, "background.hackflows_druid", false, true, true]], "[title, level, bg, regrowth, beastform, summon]");
    t.eq(::World.Assets.m.BrothersMax, 12, "roster limit");
});

test("origin: a battle and a save/load keep the druids' perks", function (t) {
    // An AI-fought battle may kill the Bear (43 base HP) in the original: the company kills them at once instead.
    yield t.battle({spawn = "BanditRaiders", resources = 60, player = ::Tales.scripted([], @() null)});
    t.eq(t.result.survivors, {enemies = 0, player = 2}, "won, both alive");
    t.save("druids");
    yield t.load("druids");
    t.eq(t.roster().map(@(b) [b.getTitle(), b.getSkills().hasSkill("perk.druid.regrowth"), b.getSkills().hasSkill("perk.druid.beastform")]),
        [["the Bear", true, false], ["the Wolf", false, true]], "[title, regrowth, beastform] after load");
});
