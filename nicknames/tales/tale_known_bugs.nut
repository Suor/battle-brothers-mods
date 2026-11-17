// mode: campaign seed=bbtest-nick fresh=1
// mods: mod_nicknames@dev mod_msu stdlib@dev
// include: lib/helpers.nut

// Reproductions of KNOWN_BUGS.md entries: open ones fail, fixed ones guard against regressions.
// #6 (Legends' 4-parameter setStartValuesEx) is in known_bugs_legends.nut, #7 in tale_no_stdlib.nut.

// KNOWN_BUGS #1, fixed: def.State is a root-table cache, reset on load.
test("KB1: title state doesn't leak into a loaded save", function (t) {
    ::NickT.resetState();
    t.save("kb1_before");
    local hiredBefore = clone ::Nicknames.loadState().hired;
    local bro = ::NickT.recruit(["sellsword_background"]);
    local title = bro.getTitle();
    ::NickT.hire(bro);
    local hired = clone hiredBefore;
    hired[title] <- 1;
    t.eq(::Nicknames.loadState().hired, hired, "hired before the load");
    yield t.load("kb1_before");
    // What the mod sees right after loading the earlier save
    t.eq(::Nicknames.loadState().hired, hiredBefore, "hired after loading a save that has none of " + title);
    t.eq(::Nicknames.loadState().generated.rawin(title), false, title + " generated after the load");
    // The next title written puts the stale state into the loaded campaign's flags
    ::NickT.recruit(["farmhand_background"]);
    ::World.getTemporaryRoster().clear();
    local saved = ::std.Flags.unpack(::World.Flags, ::Nicknames.FlagState);
    ::std.Flags.pack(::World.Flags, ::Nicknames.FlagState, saved);
    t.eq(saved.hired, hiredBefore, "hired in the loaded campaign's flags");
});

// KNOWN_BUGS #2, open: logOut() refers to an undefined _key.
test("KB2: logOut() prints and clears the debug log", function (t) {
    ::NickT.resetState();
    ::Nicknames.Debug = true;
    ::NickT.recruit(["farmhand_background"]);
    ::Nicknames.Debug = false;
    t.eq(::World.Flags.has("nicknames.factors.0"), true, "a factors batch is logged");
    try {
        ::Nicknames.logOut();
    } catch (e) {
        t.fail("logOut() threw: " + e);
    }
    t.eq([::World.Flags.has("nicknames.factors"), ::World.Flags.has("nicknames.factors.0"),
          ::World.Flags.has("nicknames.candidates"), ::World.Flags.has("nicknames.candidates.0")],
         [false, false, false, false], "log flags removed");
    ::Nicknames.Logs = {factors = {idx = null, items = []}, candidates = {idx = null, items = []}};
    ::World.getTemporaryRoster().clear();
});

// KNOWN_BUGS #4, fixed in 0.8.0: King's Guard makes its recruit with setStartValuesEx(.., false),
// leaving m.Talents empty, and sets talents afterwards. Vanilla has the same event as Legends.
test("KB4: King's Guard recruit gets a title on hire", function (t) {
    ::NickT.resetState();
    ::Tales.Autoplay = false;
    t.ok(::World.Events.fire("event.kings_guard_1", false), "event fired");
    local ev = ::World.Events.getEvent("event.kings_guard_1");
    local dude = ev.m.Dude;
    t.eq(dude.getTitle(), "", "no title while shown");
    ::World.Events.processInput(0);  // "We have a place for you, friend." -> C
    ::World.Events.processInput(0);  // "We'll see." hires him
    ::Tales.Autoplay = true;
    t.eq(t.roster().len(), 4, "hired");
    t.ok(dude.getTitle() != "", "titled on hire");
    t.ok(::NickT.has(::NickT.titles(dude), dude.getTitle()), dude.getTitle() + " fits");
    t.eq(dude.getTalents()[::Const.Attributes.MeleeDefense], 3, "event's talents in place");
});

test("KB4: a recruit made without talents outside events is titled", function (t) {
    ::NickT.resetState();
    local bro = ::World.getTemporaryRoster().create("scripts/entity/tactical/player");
    bro.setStartValuesEx(["cripple_background"], false);
    t.eq(bro.m.Talents, [], "no talents");
    t.ok(bro.getTitle() != "", "titled");
    ::World.getTemporaryRoster().clear();
});

// KNOWN_BUGS #5, fixed in 0.7.1: traits and backgrounds of other mods lacking m.Titles (Black
// Pyramid's traits inherit skill, not character_trait). m reaches Titles through its delegates.
local function withoutTitles(_m, _fn) {
    local holder = _m;
    while (holder != null && !holder.rawin("Titles")) holder = holder.getdelegate();
    local saved = holder.Titles;
    delete holder.Titles;
    try { _fn(); } catch (e) { holder.Titles <- saved; throw e; }
    holder.Titles <- saved;
}

test("KB5: a trait and a background without m.Titles don't break titling", function (t) {
    ::NickT.resetState();
    local bro = ::NickT.recruit(["farmhand_background"]);
    local trait = ::new("scripts/skills/effects/dazed_effect");  // inherits skill directly
    trait.m.ID = "trait.tiny";
    trait.m.Type = ::Const.SkillType.Trait;
    bro.getSkills().add(trait);
    withoutTitles(bro.getBackground().m, function () {
        t.eq(["Titles" in bro.getBackground().m, "Titles" in trait.m], [false, false], "no Titles slots");
        bro.setTitle("");
        ::Nicknames.fillTitle(bro);
        t.ok(bro.getTitle() != "", "titled");
        t.ok(::NickT.has(::NickT.titles(bro), "Shorty"), "the mod's own trait titles still apply");
    });
    ::World.getTemporaryRoster().clear();
});
