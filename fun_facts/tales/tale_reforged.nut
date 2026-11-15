// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_modular_vanilla[russian]==0.8.6 mod_reforged[russian]==0.8.18 mod_fun_facts stdlib@dev
// include: lib/helpers.nut

// KNOWN_BUGS #1 as in its reports: Reforged 0.8.x (0.8.14-0.8.17 in the logs; 0.8.18 is the nearest zip here).

test("Reforged is loaded", function (t) {
    t.eq([::Hooks.hasMod("mod_reforged"), ::Hooks.hasMod("mod_fun_facts")], [true, true], "mods loaded");
});

// KNOWN_BUGS #1, fixed in the working tree (uncommitted): a bro created while an event screen
// is being set up, as master_no_use_apprentice_event and cultist_origin_flock_event do.
test("KB1: the vanilla event that crashed", function (t) {
    ::BBTales.Autoplay = false;
    local event = ::World.Events.getEvent("event.master_no_use_apprentice");
    event.m.Town = ::World.EntityManager.getSettlements()[0];
    local errors = [];
    local fired = ::World.Events.fire("event.master_no_use_apprentice", false);
    t.eq(fired, true, "event fired");
    local dude = event.m.Dude;
    t.ok(dude != null && dude.m.FunFacts != null, "the apprentice has FunFacts");
    ::BBTales.Autoplay = true;
    yield t.until(@() !::World.State.getEventScreen().isVisible() && ::World.Events.m.ActiveEvent == null, 600, "the event answered");
    local hired = t.roster().filter(@(_, b) b.getBackground().getID() == "background.apprentice");
    t.eq(hired.len(), 1, "the apprentice hired");
    // m.Name is only set by setName/setTitle/load since the working tree's fix; nothing reads it before a load
    t.probe("his FunFacts name", [hired[0].m.FunFacts.m.Name, hired[0].getName()]);
    hired[0].setTitle("the Test");
    t.eq(hired[0].m.FunFacts.m.Name, hired[0].getName(), "FunFacts name after setTitle");
});
