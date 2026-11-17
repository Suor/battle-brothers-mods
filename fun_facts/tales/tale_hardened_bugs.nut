// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_hardened==1.26.3 mod_fun_facts@dev stdlib@dev
// include: lib/helpers.nut

// Fun Facts with the current Reforged 0.9.3 + Hardened 1.26.3 (KNOWN_BUGS #1 was reported with
// Reforged ± Hardened; tale_reforged.nut runs 0.8.18 without Hardened).

test("Reforged and Hardened are loaded", function (t) {
    local ids = ["mod_reforged", "mod_hardened", "mod_fun_facts"];
    t.eq(ids.map(@(id) ::Hooks.hasMod(id)), [true, true, true], "registered");
});

// KNOWN_BUGS #1, fixed in the working tree: 1.0.3 threw `the index 'getID' does not exist`
// from Reforged's nested tooltips creating a bro during an event screen.
test("KB1: the vanilla event that crashed, under Hardened", function (t) {
    ::Tales.Autoplay = false;
    local event = ::World.Events.getEvent("event.master_no_use_apprentice");
    event.m.Town = ::World.EntityManager.getSettlements()[0];
    t.eq(::World.Events.fire("event.master_no_use_apprentice", false), true, "event fired");
    local dude = event.m.Dude;
    t.ok(dude != null && dude.m.FunFacts != null, "the apprentice has FunFacts");
    ::Tales.Autoplay = true;
    yield t.until(@() !::World.State.getEventScreen().isVisible() && ::World.Events.m.ActiveEvent == null, 600, "the event answered");
    local hired = t.roster().filter(@(_, b) b.getBackground().getID() == "background.apprentice");
    t.eq(hired.len(), 1, "the apprentice hired");
    hired[0].setTitle("the Test");
    t.eq(hired[0].m.FunFacts.m.Name, hired[0].getName(), "FunFacts name after setTitle");
});

// KNOWN_BUGS #11, fixed in 1.0.2: an attacker-less hit injures an enemy (corpse explosion).
test("KB11: an enemy injured by an attacker-less hit", function (t) {
    ::FFT.reset();
    ::Tales.toughen(null, true);
    local got = t.state.got <- {};
    yield t.battle({entities = ::Tales.thugs(1), player = ::Tales.scripted([
        function (t) {
            local thug = ::Tales.hostiles()[0];
            thug.getBaseProperties().Hitpoints = 300; thug.getSkills().update(); thug.setHitpoints(300);
            ::FFT.hit(thug, null, 25);
            t.state.got.injuries <- thug.getSkills().query(::Const.SkillType.TemporaryInjury).len();
        },
        @(t) ::Tales.killAll(t.roster()[1])
    ])});
    t.eq(got.injuries, 1, "the hit injured the thug");
    t.eq(t.roster().map(@(b) ::FFT.stats(b).InjuriesDealt.len()), [0, 0, 0], "nobody inflicted it");
});

// KNOWN_BUGS #12, fixed in 1.0.0: kills tracked in a Reforged (+ Hardened) AI battle.
test("KB12: an AI battle under Reforged 0.9.3 + Hardened", function (t) {
    ::FFT.reset();
    ::Tales.toughen(null, true);
    local bros = t.roster();
    local errors = [], restore = ::Tales.catchErrors(errors);
    yield t.battle({spawn = "BanditRaiders", resources = 60});
    restore();
    foreach (e in errors) if (e.find("activeEntity null") == null) t.fail("error: " + e);
    t.eq(t.result.survivors.enemies, 0, "company wins");
    foreach (bro in bros)
        t.eq(::FFT.stats(bro).Kills.len(), bro.getLifetimeStats().Kills, bro.getName() + ": kills vs LifetimeStats");
});
