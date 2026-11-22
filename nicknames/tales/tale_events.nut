// mode: campaign seed=bbtest-nick fresh=1
// mods: mod_nicknames@dev mod_msu stdlib@dev
// include: lib/helpers.nut

// 0.8.0: brothers an event or contract creates get their title on hire, not at creation.

local function fireEvent(_id) {
    ::Tales.Autoplay = false;
    local ev = ::World.Events.getEvent(_id);
    if (!::World.Events.fire(_id, false)) throw "event " + _id + " didn't fire";
    return ev;
}

local function answer(_option) {
    ::World.Events.processInput(_option);
}

local function done() {
    ::Tales.Autoplay = true;
}

test("event recruits are titled on hire, distinct and fitting", function (t) {
    ::NickT.resetState();
    local ev = fireEvent("event.volunteers");
    local dudes = [ev.m.Dude1, ev.m.Dude2, ev.m.Dude3];
    t.probe("titles while shown", dudes.map(@(d) d.m.Title));
    answer(0);  // "Welcome aboard."
    done();
    local titles = dudes.map(@(d) d.m.Title), seen = {};
    foreach (i, d in dudes) {
        t.ok(d.m.Title != "", d.getName() + " titled on hire");
        t.ok(!(d.m.Title in seen), d.m.Title + " repeats");
        seen[d.m.Title] <- true;
        t.ok(::NickT.has(::NickT.titles(d), d.m.Title), d.m.Title + " fits");
        t.eq(::Nicknames.loadState().hired[d.m.Title], 1, "hired " + d.m.Title);
    }
    t.eq(t.roster().len(), 6, "roster size");
});

test("an event's own title for its recruit is kept", function (t) {
    ::NickT.resetState();
    local hired = clone ::Nicknames.loadState().hired;
    local ev = ::World.Events.getEvent("event.the_horseman");
    ev.setScreen(ev.getScreen("C"));
    local title = ::Tales.tr({en = "the Filly Fiddler", ru = "Конелюб"});
    t.eq(ev.m.Dude.m.Title, title);
    ev.processInput(0);  // "Welcome aboard, you horse whore."
    t.eq(ev.m.Dude.m.Title, title, "after hire");
    hired[title] <- 1;
    t.eq(::Nicknames.loadState().hired, hired);
    ev.clear();
});

test("an event recruit turned away leaves no trace", function (t) {
    ::NickT.resetState();
    local before = ::NickT.keys(::Nicknames.loadState().generated);
    local hired = clone ::Nicknames.loadState().hired;
    local ev = fireEvent("event.volunteers");
    answer(1);  // "We're good, thanks."
    done();
    t.eq(::NickT.keys(::Nicknames.loadState().generated), before, "generated titles");
    t.eq(::Nicknames.loadState().hired, hired, "hired");
});

test("recruits made after an event are titled at once again", function (t) {
    ::NickT.resetState();
    fireEvent("event.volunteers");
    answer(1);
    done();
    local bro = ::NickT.recruit(["farmhand_background"]);
    t.ok(bro.m.Title != "", "titled at creation");
    t.eq(::Nicknames.loadState().generated[bro.m.Title].days, [::World.getTime().Days]);
    ::World.getTemporaryRoster().clear();
});

// BUG N4: setScreen() hooks set the inEvent flag around the original without try/finally;
// an error in a screen's start() (any mod's event bug) leaves it set for the whole session,
// and from then on every recruit is created untitled.
test("N4: an error inside an event screen doesn't stop titling recruits", function (t) {
    ::NickT.resetState();
    local ev = ::World.Events.getEvent("event.volunteers");
    local broken = {ID = "Broken", Text = "", Image = "", List = [], Characters = [], Options = [],
        function start(_event) { throw "a buggy event"; }};
    try { ev.setScreen(broken); } catch (e) { t.log("event screen threw: " + e); }
    ev.clear();
    local bro = ::NickT.recruit(["farmhand_background"]);
    t.ok(bro.m.Title != "", "a town recruit made after the broken event has a title");
    // Undo for the tests after this: a screen that completes clears the flag.
    ev.setScreen({ID = "Ok", Text = "", Image = "", List = [], Characters = [], Options = [],
        function start(_event) {}});
    ev.clear();
    ::World.getTemporaryRoster().clear();
});

// N5, not a bug: an event recruit keeps a title vanilla rolled in setStartValuesEx() (background or
// trait titles, ~10% each), unchecked against the roster, as events' intended titles must stay.
test("N5 report: an event recruit keeps a vanilla-rolled title", function (t) {
    ::NickT.resetState();
    local dude = null;
    for (local i = 0; i < 40 && dude == null; i++) {
        local ev = fireEvent("event.volunteers");
        foreach (d in [ev.m.Dude1, ev.m.Dude2, ev.m.Dude3])
            if (d.m.Title != "") dude = d;
        if (dude == null) {
            answer(1);
            yield ::NickT.eventIdle(t);
        }
    }
    if (!t.ok(dude != null, "an event recruit with a vanilla-rolled title")) return done();
    local title = dude.m.Title;
    t.roster()[0].setTitle(title);
    answer(0);  // hire all three
    done();
    t.probe("rolled title", title);
    t.probe("kept", dude.m.Title == title);
});

// N7: detection doesn't rely on a setScreen wrapper (Legends replaces setScreen); tale_setscreen_replaced.nut and
// tale_legends_bugs.nut run the same checks with setScreen replaced.
test("N7: event recruits are titled on hire, not when made", function (t) {
    ::NickT.checkEventRecruits(t, "event.volunteers", @(ev) [ev.m.Dude1, ev.m.Dude2, ev.m.Dude3]);
    ::NickT.checkScreenRecruit(t, "event.volunteers");
});
