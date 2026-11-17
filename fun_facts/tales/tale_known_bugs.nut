// mode: campaign seed=bbtest-battle fresh=1 launch=misc
// mods: mod_fun_facts@dev stdlib@dev
// include: lib/helpers.nut

// Reproductions of KNOWN_BUGS.md entries on vanilla: open ones fail, fixed ones guard against
// regressions. #1, #11, #12 (Reforged) are in tale_reforged.nut, #2 in tale_scenario_mode.nut, #5 and
// #9 in Russian in tale_rosetta.nut, #6 in tale_no_stdlib.nut; #5 and #9 in English in tale_tooltips.nut.

// KNOWN_BUGS #3, open: a hit with no attacker injures a bro.
test("KB3: a bro injured by an attacker-less hit", function (t) {
    ::FFT.reset();
    ::Tales.toughen(null, true);
    local bro = t.state.bro <- t.roster()[0];
    local got = t.state.got <- {};
    yield t.battle({entities = ::Tales.thugs(1), player = ::Tales.scripted([
        function (t) {
            try { ::FFT.hit(t.state.bro, null, 25); } catch (e) { t.state.got.error <- e; }
            t.state.got.injuries <- t.state.bro.getSkills().query(::Const.SkillType.TemporaryInjury).map(@(s) s.getID());
        },
        @(t) ::Tales.killAll(t.roster()[1])
    ])});
    t.eq("error" in got ? got.error : null, null, "error from the hit");
    t.eq(got.injuries.len(), 1, "the hit injured him");
    t.eq(::FFT.stats(bro).Injuries.map(@(r) [r.Injury, r.AttackerClass, r.AttackerName]),
         [[got.injuries[0].slice("injury.".len()), null, null]], "injury recorded with no attacker");
});

// KNOWN_BUGS #11, fixed in 1.0.2: the same hit on an enemy (corpse explosion in Reforged).
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

// KNOWN_BUGS #4, unclear: fallen who died before Fun Facts was installed.
test("KB4: fallen without fun facts load without errors", function (t) {
    local fallen = ::World.Statistics.getFallen();
    foreach (name in ["Old One", "Old Two"])
        fallen.insert(0, {Name = name, Time = 1, TimeWithCompany = 1, Kills = 0, Battles = 1,
            KilledBy = "Killed in battle", Expendable = false});
    t.save("kb4");
    yield t.load("kb4");
    local errors = [];
    local restore = ::Tales.catchErrors(errors);
    t.save("kb4_again");
    yield t.load("kb4_again");
    restore();
    t.eq(errors, [], "errors logged by the second load");
    t.eq(::World.Statistics.getFallen().map(@(f) [f.Name, "FunFacts" in f]),
         [["Old Two", false], ["Old One", false]], "fallen after load");
    t.eq(::World.Statistics.FunFacts_getTooltipForFallen(0).map(@(e) e.text),
         ["Old Two", "Noone remembers anything fun about this dude."], "obituary tooltip");
});

// KNOWN_BUGS #10, fixed in 1.0.0: a FunFacts blob over one flag string (64000 chars).
test("KB10: a huge fun facts blob survives save/load", function (t) {
    local bro = t.roster()[0], ff = bro.m.FunFacts;
    for (local i = 0; i < 3000; i++)
        ff.m.Reducers.push(ff.m.Stats.Kills, {BattleId = i / 5 + 1, IsPlayer = false, Name = "Brigand Thug " + i,
            ClassName = "bandit_thug", XP = 150, Fatality = i % 4, Day = i / 30 + 1, Faction = 22,
            Skill = "actives.thrust", Self = false, Charmed = false});
    local packed = ::std.Packer.pack(ff.pack());
    t.ok(packed.len() > ::std.Flags.ChunkLen, "the blob needs chunks: " + packed.len());
    local before = ::FFT.snapshot(ff);
    t.save("kb10");
    yield t.load("kb10");
    bro = ::Tales.byName(bro.getName());
    t.eq(bro.m.FunFacts.m.Stats.Kills.len(), 3000, "kills after load");
    t.eq(::FFT.snapshot(bro.m.FunFacts), before, "stats after load");
});

// KNOWN_BUGS #7, unclear: saves growing with history. Linear growth, the size per record.
test("KB7: packed size grows linearly with history", function (t) {
    local sizes = [];
    foreach (n in [100, 200, 400]) {
        local ff = ::new("scripts/mods/fun_facts/fun_facts");
        for (local i = 0; i < n; i++) {
            ff.m.Reducers.push(ff.m.Stats.BattlesLog, {Id = i + 1, Kills = 2, XPGained = 300, Fled = 0, Returned = 0,
                Start = {Effects = [], Injured = false, Drugged = false, HpPct = 100}, Added = {}});
            for (local k = 0; k < 2; k++)
                ff.m.Reducers.push(ff.m.Stats.Kills, {BattleId = i + 1, IsPlayer = false, Name = "Brigand Thug",
                    ClassName = "bandit_thug", XP = 150, Fatality = 0, Day = i, Faction = 22,
                    Skill = "actives.thrust", Self = false, Charmed = false});
        }
        sizes.push(::std.Packer.pack(ff.pack()).len());
    }
    t.probe("packed bytes for 100/200/400 battles with 2 kills each", sizes);
    t.ok(sizes[2] - sizes[1] <= 2.1 * (sizes[1] - sizes[0]), "linear growth: " + ::Tales.repr(sizes));
});

// KNOWN_BUGS #13, fixed in 1.0.1: Fun Facts added to a running campaign. The save is made
// with Fun Facts' packing switched off, as one made without the mod would be.
test("KB13: adding the mod to an existing campaign", function (t) {
    ::FFT.reset();
    local pack = ::std.Flags.pack;
    ::std.Flags.pack = function (_flags, _key, _data) {
        if (_key.find("FunFacts") == null) pack(_flags, _key, _data);
    };
    t.save("kb13_nomod");
    ::std.Flags.pack = pack;
    yield t.load("kb13_nomod");
    foreach (bro in t.roster())
        t.eq(bro.m.FunFacts.pack().Battles, 0, bro.getName() + " starts with empty facts");
    ::Tales.toughen(null, true);
    yield t.battle({entities = ::Tales.thugs(2), player = ::Tales.scripted(@(t) ::Tales.killAll(t.roster()[0]))});
    t.eq(::FFT.stats(t.roster()[0]).Kills.map(@(k) k.BattleId), [1, 1], "kills tracked");
    t.eq(::FFT.rosterHints(t.roster()[0]), [], "tooltip works");
});
