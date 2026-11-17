// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_elite_few@dev stdlib@dev
// include: lib/helpers.nut

// Master rolls, their talents and attributes, the wage, the party strength and event bros,
// driven through the MSU settings (restored after each test).

test("selectMode none: nobody is a master", function (t) {
    local masters = ::EFT.with({selectMode = "none"}, function () {
        local n = 0;
        for (local i = 0; i < 30; i++) if (::EFT.isMaster(::Tales.recruit())) n++;
        return n;
    });
    t.eq(masters, 0, "masters among 30");
});

test("selectMode all: a master gets an extra talent and top attribute rolls", function (t) {
    local plain = ::EFT.with({selectMode = "none"}, @() ::Tales.recruit());
    local bro = ::EFT.with({selectMode = "all"}, @() ::Tales.recruit());
    t.eq([::EFT.isMaster(plain), ::EFT.isMaster(bro)], [false, true], "master trait");
    t.eq([::Tales.talentCount(plain), ::Tales.talentCount(bro)], [3, 4], "talents");
    local stars = bro.m.Talents.filter(@(_, v) v > 0 && v <= 3);
    t.eq(stars.len(), 4, "talents are 1-3 stars");
    // farmhand_background's ranges with the low bound raised to high + gap
    local c = bro.getBackground().onChangeAttributes();
    local b = bro.getBaseProperties();
    t.ok(b.Hitpoints >= ::Const.AttributesLevelUp[::Const.Attributes.Hitpoints].Min, "hitpoints");
    t.probe("master base", [b.Hitpoints, b.Bravery, b.Stamina, b.MeleeSkill, b.RangedSkill, b.MeleeDefense, b.RangedDefense, b.Initiative]);
    t.probe("plain base", [plain.getBaseProperties().Hitpoints, plain.getBaseProperties().MeleeSkill]);
});

test("slaves are never masters unless allowed", function (t) {
    local n = ::EFT.with({selectMode = "all"}, function () {
        local masters = 0;
        for (local i = 0; i < 5; i++) if (::EFT.isMaster(::Tales.recruit("slave_background"))) masters++;
        return masters;
    });
    t.eq(n, 0, "slave masters");
});

test("the master wage shows only once hired", function (t) {
    local bro = ::EFT.with({selectMode = "all"}, @() ::Tales.recruit());
    bro.getSkills().update();
    local before = bro.getDailyCost();
    bro.m.HireTime = 1.0;
    bro.getSkills().update();
    t.eq(bro.getDailyCost() - before, 9 * bro.getCurrentProperties().DailyWageMult * ::World.Assets.m.DailyWageMult, "wage raise");
});

local function eventWith(_start) {
    local e = ::new("scripts/events/events/broken_cart_event");
    return [e, {ID = "EFT", Text = "", Image = "", List = [], Characters = [], Options = [], start = _start}];
}

test("eventAll: a bro made in an event screen is a master", function (t) {
    local made = [];
    ::EFT.with({selectMode = "none", eventAll = true}, function () {
        local es = eventWith(function (_event) { made.push(::Tales.recruit()); });
        es[0].setScreen(es[1]);
        made.push(::Tales.recruit());
    });
    t.eq(made.map(::EFT.isMaster), [true, false], "in the screen, after it");
});

// EF-KB2: the setScreen wrapper resets its flag without try/finally, so an error in a screen
// (another mod's, as in the user logs) leaves every later bro an "event bro".
test("EF-KB2: an error in an event screen doesn't leave the event flag on", function (t) {
    // The wrapper's native acall logs the error even though it's caught.
    t.expectErrors("a broken event");
    local bro = ::EFT.with({selectMode = "none", eventAll = true}, function () {
        local es = eventWith(function (_event) { throw "a broken event"; });
        try { es[0].setScreen(es[1]); } catch (e) {}
        return ::Tales.recruit();
    });
    t.eq(::EFT.isMaster(bro), false, "a town recruit after the broken event is a master");
});

// EF1: the master bonus to the party strength counts twice after a load: Adam's mod_hooks calls
// mods_hookNewObject hooks on the loaded player party twice (World.getPlayerEntity and
// onCampaignLoaded), so updateStrength is wrapped twice (tale_newobject_control.nut shows it without
// Elite Few). Packed, every test but the first runs on a reloaded campaign, so all three double.
test("EF1: master strength bonus stays the same across loads", function (t) {
    local add = function () {
        local party = ::World.State.getPlayer();
        local bro = ::World.getPlayerRoster().getAll()[0];
        if (!::EFT.isMaster(bro)) bro.getSkills().add(::new("scripts/skills/traits/master_trait"));
        bro.m.Level = 5;
        local coef = ::Math.min(50, bro.getBackground().m.DailyCost * 0.5 + 25) / 100.0;
        local off = ::EFT.with({adjustStrength = false}, function () { party.updateStrength(); return party.m.Strength; });
        party.updateStrength();
        return [party.m.Strength - off, 4 * coef * 2.0];
    };
    local adds = [add()];
    t.save("ef1");
    yield t.load("ef1");
    adds.push(add());
    yield t.load("ef1");
    adds.push(add());
    t.eq(adds.map(@(a) a[0]), adds.map(@(a) a[1]), "bonus (level 5 master) before and after two loads");
});
