// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_background_perks@dev mod_hooks mod_msu stdlib@dev

// Free perks on recruits and event bros, without spending their perk points.

test("an apprentice always gets Student, points untouched", function (t) {
    local bro = ::Tales.recruit("apprentice_background");
    t.eq([bro.getSkills().hasSkill("perk.student"), bro.m.PerkPoints, bro.m.PerkPointsSpent], [true, 0, 0], "student, points, spent");
});

test("recruits of every background get some perks, never spending points", function (t) {
    local perked = 0, spent = [];
    foreach (i, bg in ::Const.CharacterBackgrounds) {
        for (local j = 0; j < 3; j++) {
            local bro = ::Tales.recruit(bg);
            if (bro.getSkills().query(::Const.SkillType.Perk).len() > 0) perked++;
            if (bro.m.PerkPoints != bro.m.Level - 1 || bro.m.PerkPointsSpent != 0) spent.push([bg, bro.m.Level, bro.m.PerkPoints, bro.m.PerkPointsSpent]);
        }
    }
    t.probe("recruits with perks", perked + " of " + ::Const.CharacterBackgrounds.len() * 3);
    t.ok(perked > 0, "some recruits got perks");
    t.eq(spent, [], "recruits whose points differ from a point per level: [bg, level, points, spent]");
});

// BP-KB2 (fixed in 2.4): the King's Guard event bro, made by setStartValuesEx(.., false)
test("BP-KB2: King's Guard event bro is whole", function (t) {
    ::Tales.Autoplay = false;
    ::World.Events.fire("event.kings_guard_1");
    yield t.until(@() ::World.Events.hasActiveEvent(), 300, "the event shows");
    local event = ::World.Events.m.ActiveEvent;
    local dude = event.m.Dude;
    t.eq([dude.getBackground().getID(), dude.getSprite("head").HasBrush, dude.m.Level, dude.m.PerkPoints],
         ["background.cripple", true, 3, 2], "background, head, level, perk points");
    ::World.Events.processInput(0);
    ::Tales.Autoplay = true;
    yield t.frames(30);
    local names = t.roster().map(@(b) b.getName());
    t.eq(names.find(dude.getName()) != null, true, "hired");
});
