// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_reforged==0.9.3 mod_career_stats==1.0.2 mod_fun_facts stdlib@dev
// include: lib/helpers.nut

// KNOWN_BUGS #8: "Career Stats and Fun Facts are both incompatible" (Reforged, 2026-05). Career
// Stats 1.0.2 (Nexus 569, the newest) with Reforged 0.9.3. The Squirrel side; the obituary
// tooltip clash is in both mods' JS (FOUND_BUGS F-KB8), which doesn't run headless.

test("KB8: both mods loaded", function (t) {
    t.eq([::Hooks.hasMod("mod_fun_facts"), ::mods_getRegisteredMod("mod_career_stats") != null], [true, true], "registered");
    foreach (bro in t.roster()) t.ok(bro.m.FunFacts != null && bro.m.CareerStats_Stats != null, bro.getName() + ": both stats");
});

test("KB8: a battle with a death: both mods' tooltips, obituary and save/load", function (t) {
    ::FFT.reset();
    ::BBT.toughen(null, true);
    local victim = t.roster()[0], hero = t.roster()[1];
    local name = victim.getName();
    ::FFT.setSurvival(victim, false);
    t.state.victim <- victim;
    t.state.hero <- hero;
    yield t.battle({entities = ::BBT.thugs(2), player = ::BBT.scripted([
        @(t) ::FFT.hit(::BBT.hostiles()[0], t.state.hero, 20),
        function (t) { local thug = ::BBT.hostiles()[0]; t.state.victim.kill(thug, ::BBT.attack(thug), ::Const.FatalityType.None); },
        @(t) ::BBT.killAll(t.state.hero)
    ])});
    t.eq(t.result.survivors.enemies, 0, "battle won");
    hero = ::BBT.byName(hero.getName());
    local tip = hero.getRosterTooltip();
    local texts = tip.map(@(e) e.text);
    t.probe("hero tooltip ids", tip.map(@(e) e.id));
    t.ok(texts.filter(@(_, x) x.find("DMG Dealt") != null).len() == 1, "Career Stats line in the roster tooltip");
    t.eq(::FFT.rosterHints(hero).len() > 0, true, "Fun Facts lines in the roster tooltip");
    t.eq(hero.m.CareerStats_Stats.m.Stats.Battles, 1, "Career Stats counted the battle");
    t.eq(::FFT.stats(hero).Battles, 1, "Fun Facts counted the battle");
    local idx = ::FFT.fallenByName(name);
    t.eq(idx, 0, "the victim is the latest fallen");
    local fallen = ::World.Statistics.getFallen()[idx];
    t.eq(["FunFacts" in fallen, "CareerStats_Stats" in fallen], [true, true], "the fallen carries both");
    local cs = ::FFT.obituaryTooltip(idx, "mod_career_stats", "CareerStats_Idx");
    t.ok(cs.len() > 1, "Career Stats obituary tooltip");
    local expected = [name, "Died once"];
    expected.extend(cs.slice(1));
    t.eq(::FFT.obituaryTooltip(idx, "mod_fun_facts", "FunFacts_Idx"), expected,
         "Fun Facts obituary tooltip, Career Stats' lines appended");
    local ui = ::World.State.m.ObituaryScreen.convertFallenToUIData().Fallen[idx];
    t.eq(["FunFacts_Idx" in ui, "CareerStats_Idx" in ui, "FunFacts" in ui, "CareerStats_Stats" in ui],
        [true, true, false, false], "obituary row data for both mods' JS");
    local before = [::FFT.snapshot(hero.m.FunFacts), hero.m.CareerStats_Stats.m.Stats.Battles];
    t.save("kb8");
    yield t.load("kb8");
    hero = ::BBT.byName(hero.getName());
    t.eq([::FFT.snapshot(hero.m.FunFacts), hero.m.CareerStats_Stats.m.Stats.Battles], before, "both after load");
    fallen = ::World.Statistics.getFallen()[0];
    t.eq(["FunFacts" in fallen, "CareerStats_Stats" in fallen], [true, true], "the fallen carries both after load");
    ui = ::World.State.m.ObituaryScreen.convertFallenToUIData().Fallen[0];
    t.eq(["FunFacts_Idx" in ui, "CareerStats_Idx" in ui], [true, true], "obituary row data after load");
});
