// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_legends==19.4.23 mod_fun_facts@dev stdlib@dev
// include: lib/helpers.nut

// Fun Facts on real Legends 19.4.23 (Legends brings its own mod_hooks, no shim here).

test("Legends and Fun Facts are loaded", function (t) {
    t.eq([::Hooks.hasMod("mod_legends"), ::Hooks.hasMod("mod_fun_facts")], [true, true], "registered");
    foreach (bro in t.roster()) t.ok(bro.m.FunFacts != null, bro.getName() + " has FunFacts");
});

// KNOWN_BUGS #13, fixed in 1.0.1: Legends calls onBeforeCombatResult on every alive bro, also
// one whose onCombatStart never ran (a Vala, a bro added mid-battle); 1.0.0 threw
// `the index 'Start' does not exist` at fun_facts.nut:158.
test("KB13: a bro without onCombatStart at Legends' battle end", function (t) {
    ::FFT.reset();
    ::Tales.toughen(null, true);
    local hero = t.roster()[0], odd = t.roster()[1];
    t.state.hero <- hero;
    t.state.odd <- odd;
    yield t.battle({entities = ::Tales.thugs(2), player = ::Tales.scripted([
        function (t) { t.state.odd.m.FunFacts.m.TmpCombat = null; },
        @(t) ::Tales.killAll(t.state.hero)
    ])});
    t.eq(t.result.survivors.enemies, 0, "battle won");
    t.eq([::FFT.stats(odd).Battles, ::FFT.stats(odd).BattlesLog.len()], [1, 1], "the battle counted for him");
    t.eq(::FFT.stats(hero).Kills.len(), 2, "hero's kills");
    t.ok(::FFT.rosterHints(odd).len() >= 0, "his tooltip builds");
});

// KNOWN_BUGS #13, the other half: Fun Facts added to a running Legends campaign.
test("KB13: adding the mod to an existing Legends campaign", function (t) {
    ::FFT.reset();
    local pack = ::std.Flags.pack;
    ::std.Flags.pack = function (_flags, _key, _data) {
        if (_key.find("FunFacts") == null) pack(_flags, _key, _data);
    };
    t.save("kb13l_nomod");
    ::std.Flags.pack = pack;
    yield t.load("kb13l_nomod");
    foreach (bro in t.roster())
        t.eq(bro.m.FunFacts.pack().Battles, 0, bro.getName() + " starts with empty facts");
    ::Tales.toughen(null, true);
    yield t.battle({entities = ::Tales.thugs(2), player = ::Tales.scripted(@(t) ::Tales.killAll(t.roster()[0]))});
    t.eq(::FFT.stats(t.roster()[0]).Kills.map(@(k) k.BattleId), [1, 1], "kills tracked");
    t.eq(::FFT.rosterHints(t.roster()[0]), [], "tooltip works");
});

test("an AI battle under Legends: kills match the game's counters", function (t) {
    ::FFT.reset();
    ::Tales.toughen(null, true);
    local bros = t.roster();
    yield t.battle({spawn = "BanditRaiders", resources = 60});
    t.eq(t.result.survivors.enemies, 0, "company wins");
    foreach (bro in bros) {
        t.eq(::FFT.stats(bro).Kills.len(), bro.getLifetimeStats().Kills, bro.getName() + ": kills vs LifetimeStats");
        t.eq(::FFT.stats(bro).BattlesLog.len(), 1, bro.getName() + ": battle log");
    }
});

// KNOWN_BUGS #7 (saves slower until load hangs, Legends, ~day 110) and #10 (save corrupted on a
// long campaign, Legends): a long history on every bro and a hundred fallen through a Legends save.
test("KB7/KB10: long histories through a Legends save and load", function (t) {
    ::FFT.reset();
    local mk = function (ff, battles) {
        for (local i = 0; i < battles; i++) {
            ff.m.Reducers.push(ff.m.Stats.BattlesLog, {Id = i + 1, Kills = 2, XPGained = 300, Fled = 0, Returned = 0,
                Start = {Effects = [], Injured = false, Drugged = false, HpPct = 100}, Added = {}});
            for (local k = 0; k < 2; k++)
                ff.m.Reducers.push(ff.m.Stats.Kills, {BattleId = i + 1, IsPlayer = false, Name = "Brigand Thug",
                    ClassName = "bandit_thug", XP = 150, Fatality = 0, Day = i / 3, Faction = 22,
                    Skill = "actives.thrust", Self = false, Charmed = false});
        }
    };
    foreach (bro in t.roster()) mk(bro.m.FunFacts, 300);
    local fallen = ::World.Statistics.getFallen();
    for (local i = 0; i < 100; i++) {
        local ff = ::new("scripts/mods/fun_facts/fun_facts");
        mk(ff, 50);
        fallen.push({Name = "Fallen " + i, Time = 1, TimeWithCompany = 1, Kills = 100, Battles = 50, KilledBy = "a thug",
            Expendable = false, FunFacts = ff});
    }
    local before = {};
    foreach (bro in t.roster()) before[bro.getName()] <- ::FFT.snapshot(bro.m.FunFacts);
    t.save("kb7l");
    yield t.load("kb7l");
    foreach (bro in t.roster())
        t.eq(::FFT.snapshot(bro.m.FunFacts), before[bro.getName()], bro.getName() + "'s stats after load");
    local loaded = ::World.Statistics.getFallen().filter(@(_, f) "FunFacts" in f && f.Name.find("Fallen ") == 0);
    t.eq(loaded.len(), 100, "fallen with facts after load");
    t.eq(loaded.map(@(f) f.FunFacts.m.Stats.Kills.len()).reduce(@(a, b) a + b), 100 * 100, "fallen kills after load");
    t.probe("packed bytes of one living bro", ::std.Packer.pack(t.roster()[0].m.FunFacts.pack()).len());
});

// Legends adds its own lessons (ids 100+) that bypass vanilla's onTrain body.
test("training hall under Legends: both kinds of lessons paid for", function (t) {
    local bro = t.roster()[0];
    local town = ::Tales.townWith("building.training_hall");
    t.ok(town != null, "a town with a training hall");
    local screen = ::Tales.visit(town, "building.training_hall");
    local module = screen.getTrainingDialogModule();
    module.queryRosterInformation(); // grants the intensive training trait
    ::World.Assets.addMoney(10000);
    local prices = [];
    foreach (id in [0, 100]) {
        local m = ::World.Assets.getMoney();
        module.onTrain([bro.getID(), id]);
        prices.push(m - ::World.Assets.getMoney());
    }
    t.ok(prices[0] > 0 && prices[1] > 0, "paid for both");
    t.eq(::FFT.stats(bro).Spent.Training, prices, "Spent.Training vs money paid");
});
