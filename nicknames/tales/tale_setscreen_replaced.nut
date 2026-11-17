// mode: campaign seed=bbtest-nick fresh=1
// mods: mod_nicknames@dev mod_setscreen_stub mod_msu stdlib@dev
// include: lib/helpers.nut

// N7 with events/event.setScreen replaced outright by a mod queued after nicknames (mod_setscreen_stub/).

test("N7: the stub replaced setScreen", function (t) {
    local src = ::World.Events.getEvent("event.volunteers").setScreen.getinfos().src;
    t.eq(src, "scripts/!mods_preload/mod_setscreen_stub.nut", "setScreen is the stub's");
});

test("N7: event recruits are titled on hire with setScreen replaced", function (t) {
    ::NickT.checkEventRecruits(t, "event.volunteers", @(ev) [ev.m.Dude1, ev.m.Dude2, ev.m.Dude3]);
    ::NickT.checkScreenRecruit(t, "event.volunteers");
});
