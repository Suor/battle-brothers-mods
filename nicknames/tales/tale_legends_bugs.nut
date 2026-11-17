// mode: campaign seed=bbtest-nick fresh=1
// mods: mod_legends==19.4.23 mod_nicknames@dev stdlib@dev
// include: lib/helpers.nut

// The Legends-only known bugs against real Legends 19.4.23.

test("Legends and Nicknames are loaded, starting titles set", function (t) {
    t.eq([::Hooks.hasMod("mod_legends"), ::Hooks.hasMod("mod_nicknames")], [true, true], "registered");
    t.probe("Legends", ::Legends.Version);
    local titles = t.roster().map(@(b) b.getTitle());
    t.probe("starting titles", titles);
    foreach (title in titles) t.ok(typeof title == "string", "a title string");
});

// KNOWN_BUGS #6, fixed in 0.5.2: the wrapper keeps Legends' 4 parameters and passes them on.
test("KB6: setStartValuesEx keeps Legends' parameters", function (t) {
    ::NickT.resetState();
    local bro = ::World.getTemporaryRoster().create("scripts/entity/tactical/player");
    t.eq(bro.setStartValuesEx.getinfos().parameters,
        ["this", "_backgrounds", "_addTraits", "_gender", "_addEquipment"], "final wrapper's parameters");
    bro.setStartValuesEx(["sellsword_background"], true, 1, false);
    t.eq(bro.getItems().getAllItems().len(), 0, "_addEquipment = false honoured");
    t.ok(bro.getTitle() != "", "titled");
    ::World.getTemporaryRoster().clear();
});

// KNOWN_BUGS #4, fixed in 0.8.0: Legends' King's Guard makes the bro with
// setStartValuesEx(.., false) and empty talents; 0.7.x threw `the index '0' does not exist`.
test("KB4: Legends' King's Guard recruit is titled, shows in the roster, survives a save", function (t) {
    ::NickT.resetState();
    yield ::NickT.eventIdle(t);
    ::Tales.Autoplay = false;
    local n = t.roster().len();
    t.ok(::World.Events.fire("event.kings_guard_1", false), "event fired");
    local ev = ::World.Events.getEvent("event.kings_guard_1");
    local dude = ev.m.Dude;
    t.eq(dude.getFlags().get("IsKingsGuard"), true, "Legends' version of the event");
    t.eq(dude.getTitle(), "", "no title while shown");
    ::World.Events.processInput(0);  // "We have a place for you, friend." -> C
    ::World.Events.processInput(0);  // hires him
    ::Tales.Autoplay = true;
    t.eq(t.roster().len(), n + 1, "hired");
    t.ok(dude.getTitle() != "", "titled on hire: " + dude.getTitle());
    t.ok(::UIDataHelper.convertEntityToUIData(dude, null) != null, "roster UI data builds");
    local name = dude.getName();
    t.save("kb4l");
    yield t.load("kb4l");
    t.eq(t.roster().len(), n + 1, "roster after load");
    local found = t.roster().filter(@(_, b) b.getName() == name);
    t.eq(found.len(), 1, "the King's Guard after load");
});

// BUG N7: Legends replaces events/event.setScreen outright, so a setScreen wrapper didn't detect event recruits.
test("N7: Legends' and vanilla event recruits are titled on hire, not when made", function (t) {
    yield ::NickT.eventIdle(t);
    ::NickT.checkEventRecruits(t, "event.volunteers", @(ev) [ev.m.Dude1, ev.m.Dude2, ev.m.Dude3]);
    yield ::NickT.eventIdle(t);
    ::NickT.checkEventRecruits(t, "event.legend_trader_recruitment", @(ev) [ev.m.Trader]);
    ::NickT.checkScreenRecruit(t, "event.volunteers");
});
