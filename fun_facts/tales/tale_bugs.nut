// mode: campaign seed=bbtest-battle fresh=1 launch=bugs
// mods: mod_fun_facts@dev stdlib@dev
// include: lib/helpers.nut

// Bugs found by these scenarios (FOUND_BUGS.md): each test describes the correct behaviour
// and fails while the bug is open.

test("F1: a bro struck down who survives counts the battle once", function (t) {
    ::FFT.reset();
    ::Tales.toughen(null, true);
    local bro = t.roster()[0], name = bro.getName();
    ::FFT.setSurvival(bro, true);
    t.state.bro <- bro;
    local seen = t.state.seen <- {};
    yield t.battle({entities = ::Tales.thugs(1), player = ::Tales.scripted([
        function (t) {
            local thug = ::Tales.hostiles()[0];
            t.state.bro.kill(thug, ::Tales.attack(thug), ::Const.FatalityType.None);
            t.state.seen.survivor <- ::Tactical.getSurvivorRoster().getAll().map(@(b) b.getName());
        },
        @(t) ::Tales.killAll(t.roster()[1])
    ])});
    t.eq(seen.survivor, [name], "struck down, in the survivor roster");
    t.ok(::Tales.byName(name) != null, "back in the roster after the victory");
    t.eq(bro.getSkills().query(::Const.SkillType.PermanentInjury).len(), 1, "with a permanent injury");
    t.eq(bro.getLifetimeStats().Battles, 1, "vanilla counts one battle");
    local s = ::FFT.stats(bro);
    t.eq(s.Battles, 1, "Fun Facts battles");
    t.eq(s.BattlesLog.map(@(r) r.Id), [1], "battle log ids");
});

// The other way a struck-down bro goes: the company retreats, vanilla leaves him to die.
test("F1: a bro struck down and left to die keeps the battle and the death", function (t) {
    ::FFT.reset();
    ::Tales.toughen(null, true);
    local bro = t.roster()[0], name = bro.getName();
    ::FFT.setSurvival(bro, true);
    t.state.bro <- bro;
    // setup: the code env prohibits fleeing by default, the game's scripted combat doesn't
    yield t.battle({entities = ::Tales.thugs(1), player = ::Tales.scripted([
        function (t) {
            local thug = ::Tales.hostiles()[0];
            t.state.bro.kill(thug, ::Tales.attack(thug), ::Const.FatalityType.None);
        },
        @() ::Tactical.State.flee()
    ]), setup = @(_p) _p.IsFleeingProhibited = false});
    t.eq(t.result.result, ::Const.Tactical.CombatResult.PlayerRetreated, "the company retreated");
    t.eq(::Tales.byName(name), null, "off the roster");
    local idx = ::FFT.fallenByName(name), fallen = ::World.Statistics.getFallen()[idx];
    t.eq(fallen.KilledBy, ::Tales.tr({en = "Left to die", ru = "Был брошен на поле боя"}), "fallen record");
    local s = fallen.FunFacts.m.Stats;
    t.eq([s.Battles, s.BattlesLog.map(@(r) r.Id)], [1, [1]], "his battle");
    t.eq(s.Deaths.map(@(d) [d.Fatality, d.ClassName]), [[::Const.FatalityType.Unconscious, "bandit_thug"]], "his death");
    t.eq(::FFT.fallenHints(idx), ["Died once"], "obituary tooltip");
    t.save("f1_left");
    yield t.load("f1_left");
    idx = ::FFT.fallenByName(name);
    t.eq(::World.Statistics.getFallen()[idx].FunFacts.m.Stats.BattlesLog.len(), 1, "his battle after a load");
});

test("F2: kill verbs: a gutted bro is gutted, a smashed one smashed", function (t) {
    ::FFT.reset();
    ::Tales.toughen(null, true);
    local k1 = t.roster()[0], a = t.roster()[1], k2 = t.roster()[2], b = ::Tales.hireTough("farmhand_background", 3, null, true);
    local an = a.getName(), bn = b.getName();
    ::FFT.setSurvival(a, false);
    ::FFT.setSurvival(b, false);
    t.state.k1 <- k1;
    t.state.a <- a;
    t.state.k2 <- k2;
    t.state.b <- b;
    yield t.battle({entities = ::Tales.thugs(1), player = ::Tales.scripted([
        @(t) t.state.a.kill(t.state.k1, ::Tales.attack(t.state.k1), ::Const.FatalityType.Disemboweled),
        @(t) t.state.b.kill(t.state.k2, ::Tales.attack(t.state.k2), ::Const.FatalityType.Smashed),
        @(t) ::Tales.killAll(t.state.k1)
    ])});
    t.eq([::FFT.stats(k1).Kills[0].Fatality, ::FFT.stats(k2).Kills[0].Fatality],
         [::Const.FatalityType.Disemboweled, ::Const.FatalityType.Smashed], "kill records");
    t.eq(::FFT.rosterHints(k1), ["Unwittingly gutted " + ::FFT.ally(an)], "tooltip of the one who gutted");
    t.eq(::FFT.rosterHints(k2), ["Unwittingly smashed " + ::FFT.ally(bn)], "tooltip of the one who smashed");
});

test("F3: a shield destroyed in battle isn't charged as armor parts", function (t) {
    ::FFT.reset();
    ::Tales.toughen(null, true);
    local bro = t.state.bro <- t.roster()[0];
    ::Tales.equip(bro, "scripts/items/shields/wooden_shield");
    yield t.battle({entities = ::Tales.thugs(1), player = ::Tales.scripted([
        @(t) t.state.bro.getItems().getItemAtSlot(::Const.ItemSlot.Offhand).applyShieldDamage(1000, false),
        @(t) ::Tales.killAll(t.state.bro)
    ])});
    t.eq(bro.getItems().getItemAtSlot(::Const.ItemSlot.Offhand), null, "the shield is gone");
    t.eq(::World.Assets.getRepairRequired().ArmorParts, 0, "nothing to repair");
    t.eq(::FFT.stats(bro).Spent.Parts, 0.0, "parts charged to the bro");
});

// With the Blacksmith retinue vanilla drops the destroyed shield at condition 0, it comes back as loot
test("F3: a destroyed shield the Blacksmith keeps is charged its repair", function (t) {
    ::FFT.reset();
    ::Tales.toughen(null, true);
    local bro = t.state.bro <- t.roster()[0];
    ::Tales.equip(bro, "scripts/items/shields/wooden_shield");
    local max = bro.getItems().getItemAtSlot(::Const.ItemSlot.Offhand).getConditionMax();
    ::World.Assets.m.IsBlacksmithed = true;
    yield t.battle({entities = ::Tales.thugs(1), player = ::Tales.scripted([
        @(t) t.state.bro.getItems().getItemAtSlot(::Const.ItemSlot.Offhand).applyShieldDamage(1000, false),
        @(t) ::Tales.killAll(t.state.bro)
    ])});
    ::World.Assets.m.IsBlacksmithed = false;
    t.eq(bro.getItems().getItemAtSlot(::Const.ItemSlot.Offhand), null, "the shield is off the bro");
    t.eq(::FFT.stats(bro).Spent.Parts, max * ::World.Assets.m.ArmorPartsPerArmor, "parts charged to the bro");
});

test("F4: battle ids restart from the loaded save", function (t) {
    ::FFT.reset();
    ::Tales.toughen(null, true);
    t.save("f4_before");
    yield t.battle({entities = ::Tales.thugs(1), player = ::Tales.scripted(@(t) ::Tales.killAll(t.roster()[0]))});
    t.eq(::FFT.stats(t.roster()[0]).BattlesLog.map(@(r) r.Id), [1], "first battle's id");
    yield t.load("f4_before");
    ::Tales.toughen(null, true);
    yield t.battle({entities = ::Tales.thugs(1), player = ::Tales.scripted(@(t) ::Tales.killAll(t.roster()[0]))});
    local s = ::FFT.stats(t.roster()[0]);
    t.eq(s.BattlesLog.map(@(r) r.Id), [1], "the loaded campaign's first battle");
    t.eq(s.Kills.map(@(r) r.BattleId), [1], "its kill");
});

// F4's other trigger: a new campaign in the same session.
test("F4: battle ids restart in a new campaign", function (t) {
    ::FFT.reset();
    ::Tales.toughen(null, true);
    yield t.battle({entities = ::Tales.thugs(1), player = ::Tales.scripted(@(t) ::Tales.killAll(t.roster()[0]))});
    t.eq(::FFT.stats(t.roster()[0]).BattlesLog.map(@(r) r.Id), [1], "first campaign's battle");
    yield t.newCampaign({seed = "second"});
    ::Tales.toughen(null, true);
    yield t.battle({entities = ::Tales.thugs(1), player = ::Tales.scripted(@(t) ::Tales.killAll(t.roster()[0]))});
    t.eq(::FFT.stats(t.roster()[0]).BattlesLog.map(@(r) r.Id), [1], "the new campaign's first battle");
});

// F4 investigation: do the carried-over ids spoil any counts? Saves loaded out of order, in one
// session and across a restart (the cache reset), each bro's numbers checked against vanilla's.
test("F4: counts stay right through saves loaded out of order", function (t) {
    ::FFT.reset();
    ::Tales.toughen(null, true);
    local fight = @(t) t.battle({entities = ::Tales.thugs(1), player = ::Tales.scripted(@(t) ::Tales.killAll(t.roster()[0]))});
    local check = function (t, _label, _battles, _ids) {
        local ids = [];
        foreach (bro in t.roster()) {
            local s = ::FFT.stats(bro), life = bro.getLifetimeStats();
            t.eq([s.Battles, s.BattlesLog.len(), s.Kills.len()], [life.Battles, life.Battles, life.Kills],
                 _label + ": " + bro.getName() + " vs vanilla");
            ids.push(s.BattlesLog.map(@(r) r.Id));
        }
        t.eq(t.roster()[0].getLifetimeStats().Battles, _battles, _label + ": battles");
        t.eq(ids[0], _ids, _label + ": ids");
    };
    t.save("f4_a");
    yield fight(t);
    t.save("f4_b");                                    // 1 battle
    yield t.load("f4_a");
    ::Tales.toughen(null, true);
    yield fight(t);
    yield fight(t);
    t.save("f4_c");                                    // 2 battles
    yield t.load("f4_c");
    check(t, "a + 2 in session", 2, [1, 2]);
    ::FFT.reset();                                     // a game restart
    yield t.load("f4_b");
    ::Tales.toughen(null, true);
    yield fight(t);
    check(t, "b + 1 after restart", 2, [1, 2]);
    yield t.load("f4_c");                              // a later save in the same session
    ::Tales.toughen(null, true);
    yield fight(t);
    t.save("f4_d");
    yield t.load("f4_d");
    check(t, "c + 1 after b", 3, [1, 2, 3]);
});

// The bro who fought the last battle alone leaves: the next id still goes up, after a load too.
test("F4: battle ids aren't reused after the bro with the highest one leaves", function (t) {
    ::Tales.toughen(null, true);
    local fight = @(t) t.battle({entities = ::Tales.thugs(1), player = ::Tales.scripted(@(t) ::Tales.killAll(t.roster()[0]))});
    yield fight(t);
    local bros = t.roster(), lone = bros[0], places = bros.map(@(b) b.getPlaceInFormation());
    foreach (i, bro in bros) if (bro != lone) bro.setPlaceInFormation(18 + i);
    yield fight(t);
    t.eq(::FFT.stats(lone).BattlesLog.map(@(r) r.Id), [1, 2], "the lone fighter's ids");
    ::World.getPlayerRoster().remove(lone);
    foreach (i, bro in bros) if (bro != lone) bro.setPlaceInFormation(places[i]);
    t.save("f4_left");
    yield t.load("f4_left");
    ::Tales.toughen(null, true);
    yield fight(t);
    t.eq(::FFT.stats(t.roster()[0]).BattlesLog.map(@(r) r.Id), [1, 3], "after he left");
});

// A save from before the counter was kept in the campaign: it starts from the records.
test("F4: an old save without the counter continues from its records", function (t) {
    ::Tales.toughen(null, true);
    local fight = @(t) t.battle({entities = ::Tales.thugs(1), player = ::Tales.scripted(@(t) ::Tales.killAll(t.roster()[0]))});
    yield fight(t);
    if (::World.Flags.has("FunFacts.BattleId")) ::World.Flags.remove("FunFacts.BattleId");
    t.save("f4_old");
    yield t.load("f4_old");
    ::Tales.toughen(null, true);
    yield fight(t);
    yield fight(t);
    t.eq(::FFT.stats(t.roster()[0]).BattlesLog.map(@(r) r.Id), [1, 2, 3], "ids");
});

test("F7: deaths vanilla deals with no killer log no errors", function (t) {
    ::FFT.reset();
    ::Tales.toughen(null, true);
    local bro = t.roster()[0], name = bro.getName();
    ::FFT.setSurvival(bro, false);
    t.state.bro <- bro;
    local errors = [];
    local restore = ::Tales.catchErrors(errors);
    yield t.battle({entities = ::Tales.thugs(1), player = ::Tales.scripted([
        // tactical_state.onBattleEnded does this to charmed or sleeping bros on a defeat
        @(t) t.state.bro.kill(null, null, ::Const.FatalityType.Suicide),
        @(t) ::Tales.killAll(t.roster()[0])
    ])});
    restore();
    t.eq(::Tales.byName(name), null, "he died");
    t.eq(::FFT.ff(bro).m.Stats.Deaths.map(@(d) [d.Name, d.Fatality]),
         [[null, ::Const.FatalityType.Suicide]], "the death is recorded");
    t.eq(errors, [], "errors logged");
});

// Stats from before v3 (no Self in kill and death records) are migrated on load by comparing
// the record's name with the bro's own, m.Name: right for the living, set before unpack().
test("F8: a fallen bro's pre-v3 suicide isn't taken for friendly fire", function (t) {
    local bro = t.roster()[0], name = bro.getName();
    local v2 = {Version = 2, Deaths = [{BattleId = 1, IsPlayer = true, Name = name, ClassName = "player",
        XP = 150, Fatality = 0, Day = 1}]};
    bro.m.FunFacts.m.Stats = v2;
    local ff = ::new("scripts/mods/fun_facts/fun_facts");
    ff.m.Stats = clone v2;
    ::World.Statistics.getFallen().insert(0, {Name = name, Time = 1, TimeWithCompany = 1, Kills = 0, Battles = 1,
        KilledBy = "Killed in battle", Expendable = false, FunFacts = ff});
    t.save("f8");
    yield t.load("f8");
    bro = ::Tales.byName(name);
    t.eq([bro.m.FunFacts.m.Stats.Deaths[0].Self, bro.m.FunFacts.getProp("KilledByBros")], [true, 0], "living bro");
    local fallen = ::World.Statistics.getFallen()[0].FunFacts;
    t.eq([fallen.m.Stats.Deaths[0].Self, fallen.getProp("KilledByBros")], [true, 0], "fallen bro");
    t.eq(::FFT.fallenHints(0), ["Died once"], "obituary tooltip");
});
