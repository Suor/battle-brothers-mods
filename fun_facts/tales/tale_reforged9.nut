// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_reforged==0.9.3 mod_fun_facts stdlib@dev
// include: lib/helpers.nut

// Fun Facts with the current Reforged 0.9.3 (its loot rules).

// KNOWN_BUGS #1 on the current Reforged: its nested tooltips still wrap getName with getID during events.
test("KB1: the vanilla event that crashed", function (t) {
    ::BBTales.Autoplay = false;
    local event = ::World.Events.getEvent("event.master_no_use_apprentice");
    event.m.Town = ::World.EntityManager.getSettlements()[0];
    local fired = ::World.Events.fire("event.master_no_use_apprentice", false);
    t.eq(fired, true, "event fired");
    local dude = event.m.Dude;
    t.ok(dude != null && dude.m.FunFacts != null, "the apprentice has FunFacts");
    ::BBTales.Autoplay = true;
    yield t.until(@() !::World.State.getEventScreen().isVisible() && ::World.Events.m.ActiveEvent == null, 600, "the event answered");
    local hired = t.roster().filter(@(_, b) b.getBackground().getID() == "background.apprentice");
    t.eq(hired.len(), 1, "the apprentice hired");
    t.probe("his FunFacts name", [hired[0].m.FunFacts.m.Name, hired[0].getName()]);
    hired[0].setTitle("the Test");
    t.eq(hired[0].m.FunFacts.m.Name, hired[0].getName(), "FunFacts name after setTitle");
});

// KNOWN_BUGS #12, fixed in 1.0.0: Reforged's loot rules pass a null killer to actor.onDeath.
test("KB12: kills tracked in a Reforged battle", function (t) {
    ::FFT.reset();
    ::BBT.toughen(null, true);
    local bro = t.state.bro <- t.roster()[0];
    local names = t.state.names <- [];
    yield t.battle({entities = ::BBT.thugs(2), player = ::BBT.scripted(function (t) {
        foreach (e in ::BBT.hostiles()) t.state.names.push(e.getName());
        ::BBT.killAll(t.state.bro);
    })});
    t.eq(::FFT.stats(bro).Kills.map(@(k) [k.Name, k.IsPlayer, k.BattleId]),
         names.map(@(n) [n, false, 1]), "kills");
    t.eq(::FFT.stats(bro).Kills.len(), bro.getLifetimeStats().Kills, "kills vs LifetimeStats");
});

test("KB12: an AI battle under Reforged", function (t) {
    ::FFT.reset();
    ::BBT.toughen(null, true);
    local bros = t.roster();
    // Reforged's AI fixes log this in some headless battles without Fun Facts too
    local errors = [], restore = ::BBT.catchErrors(errors);
    yield t.battle({spawn = "BanditRaiders", resources = 60});
    restore();
    foreach (e in errors) if (e.find("activeEntity null") == null) t.fail("error: " + e);
    t.eq(t.result.survivors.enemies, 0, "company wins");
    foreach (bro in bros) {
        t.eq(::FFT.stats(bro).Kills.len(), bro.getLifetimeStats().Kills, bro.getName() + ": kills vs LifetimeStats");
        t.eq(::FFT.stats(bro).BattlesLog.map(@(r) [r.Id, r.Kills]), [[1, bro.m.CombatStats.Kills]], bro.getName() + ": battle log");
    }
    t.probe("kills", bros.map(@(b) ::FFT.stats(b).Kills.len()));
});
