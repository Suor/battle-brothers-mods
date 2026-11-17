// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_bro_studio@dev mod_hooks stdlib@dev
// allow-errors: stdlib \(stdlib\) version 2\.6 is outdated for mod_bro_studio
// allow-errors: Errors occured when validating mod compatibility, the game was therefore not loaded correctly
// include: lib/helpers.nut

// Talents, traits, injuries, perks and veteran attribute rolls on generated and leveled bros.
// The launch boots past an engine divergence (allow-errors above): Modern Hooks compares the
// literal 2.6 of stdlib's version with "2.6".tofloat(), which the engine keeps in 64 bits;
// Modern Hooks doesn't quit headless, so the mod's queue still runs (first test checks it).

test("the mod's queue ran despite the version error", function (t) {
    t.eq(["Mod" in ::BroStudio, "addTraits" in ::BroStudio, "fillTalentValues" in ::BroStudio], [true, true, true], "queue ran");
    t.eq(::BST.setting("talentsMin").getValue(), 3, "a setting");
});

// BS-KB6 (fixed in 1.0.1): talent min/max/chance
test("BS-KB6: talents spread between min and max", function (t) {
    local counts = ::BST.with({talentsMin = 3, talentsMax = 5, talentsChance = 50}, function () {
        local c = {};
        for (local i = 0; i < 300; i++) {
            local n = ::Tales.talentCount(::Tales.recruit());
            c[n] <- (n in c ? c[n] : 0) + 1;
        }
        return c;
    });
    t.probe("talent counts", counts);
    local keys = []; foreach (k, _ in counts) keys.push(k); keys.sort();
    t.eq(keys, [3, 4, 5], "talent counts seen");
});

test("talents 0..0 leaves bros untalented", function (t) {
    local n = ::BST.with({talentsMin = 0, talentsMax = 0}, @() ::Tales.talentCount(::Tales.recruit()));
    t.eq(n, 0, "talents");
});

local function bad() { return ::std.Player.BadTraitIds; }
local function soso() { return ::std.Player.SosoTraitIds; }

// BS-KB3: Clumsy (or any bad/so-so trait) given while only good traits are allowed.
test("BS-KB3: only good traits when bad and so-so are off", function (t) {
    local wrong = [];
    for (local i = 0; i < 300; i++) {
        local bro = ::Tales.recruit();
        local got = ::BST.traitIds(::BroStudio.addTraits(bro, 1, {good = true, bad = false, soso = false}));
        foreach (id in got) if (bad().find(id) != null || soso().find(id) != null) wrong.push(id);
    }
    t.eq(wrong, [], "bad or so-so traits added");
});

// BS1: the "Add good traits" setting is ignored: std.Player.addTraits never reads _opts.good.
test("BS1: no good traits when good traits are off", function (t) {
    local good = [];
    for (local i = 0; i < 100; i++) {
        local bro = ::Tales.recruit();
        foreach (id in ::BST.traitIds(::BroStudio.addTraits(bro, 1, {good = false, bad = true, soso = true})))
            if (::std.Player.traitType(id) == "GOOD") good.push(id);
    }
    t.eq(good.len(), 0, "good traits added: " + ::Tales.repr(good.slice(0, ::Math.min(5, good.len()))));
});

test("traitsNum adds traits to recruits", function (t) {
    local n = ::BST.with({traitsNum = 0}, @() ::Tales.recruit().getSkills().query(::Const.SkillType.Trait).len());
    local m = ::BST.with({traitsNum = 3}, @() ::Tales.recruit().getSkills().query(::Const.SkillType.Trait).len());
    t.probe("traits 0 / 3", [n, m]);
    t.ok(m >= 3, "at least 3 traits with traitsNum 3");
});

test("permanent injuries make recruits cheaper", function (t) {
    local bro = ::BST.with({permChance = 100}, @() ::Tales.recruit());
    local injuries = bro.getSkills().query(::Const.SkillType.PermanentInjury);
    t.eq(injuries.len(), 1, "one permanent injury");
    local injured = bro.getHiringCost();
    foreach (i in injuries) bro.getSkills().remove(i.get());
    t.eq(injured, ::Math.ceil(bro.getHiringCost() * 0.7), "hiring cost x0.7");
});

test("perksEach gives extra perk points on level-ups", function (t) {
    local bro = ::BST.with({perksEach = 2}, function () {
        local b = ::Tales.recruit();
        b.m.XP = ::Const.LevelXP[4];
        b.updateLevel();
        return b;
    });
    t.eq([bro.m.Level, bro.m.PerkPoints], [5, 8], "level 5: 4 vanilla + 4 extra points");
});

// BS-KB1: a veteran getting XP worth several levels at once must still roll veteran values.
test("BS-KB1: bulk XP past the veteran level gives veteran rolls", function (t) {
    local bro = ::Tales.recruit();
    local rows = ::BST.levelTo(bro, 12);
    t.eq(rows.len(), 11, "level-ups to 12");
    t.eq(rows[10], [1, 1, 1, 1, 1, 1, 1, 1], "level 12 is veteran");
    local more = ::BST.levelTo(bro, 15);
    t.eq(more, [[1, 1, 1, 1, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1, 1, 1]], "levels 13-15 at once");

    local fresh = ::Tales.recruit();
    local all = ::BST.levelTo(fresh, 14);
    t.eq(all.slice(10), [[1, 1, 1, 1, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1, 1, 1], [1, 1, 1, 1, 1, 1, 1, 1]], "levels 12-14 of 1 → 14 at once");
    t.ok(all.slice(0, 10).filter(@(_, r) r[0] > 1).len() > 0, "levels 2-11 are full rolls");
});

test("attrsVeteran 15 gives full rolls up to 15", function (t) {
    local rows = ::BST.with({attrsVeteran = 15}, function () {
        local bro = ::Tales.recruit();
        return ::BST.levelTo(bro, 17);
    });
    local full = rows.map(@(r) r[0] > 1 || r[4] > 1);
    t.probe("full roll per level 2..17", full);
    t.eq(full.slice(14), [false, false], "levels 16-17 veteran");
    t.eq(full.slice(10, 14).find(true) != null, true, "levels 12-15 got full rolls");
});
