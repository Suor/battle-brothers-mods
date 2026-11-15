// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_fun_facts stdlib@dev
// include: lib/helpers.nut

// Stat accounting in real battles, checked against the game's own counters (LifetimeStats,
// CombatStats, getRepairRequired()) and against the events the test makes happen.

test("every bro has his own FunFacts", function (t) {
    local bros = t.roster();
    t.eq(bros.len(), 3, "starting company");
    local seen = [];
    foreach (bro in bros) {
        t.ok(bro.m.FunFacts != null, bro.getName() + " has FunFacts");
        t.ok(bro.m.FunFacts.m.Player.get() == bro, bro.getName() + "'s FunFacts point back to him");
        foreach (s in seen) t.ok(s != bro.m.FunFacts.m.Stats.Kills, "Kills arrays aren't shared");
        seen.push(bro.m.FunFacts.m.Stats.Kills);
    }
});

// Each hostile's death as the game reports it to actor.onDeath, recorded per instance on top
// of the hooks, so the test counts kills on its own.
::FFT.recordDeaths <- function (_out) {
    return function () {
        foreach (e in ::BBT.hostiles()) {
            local orig = e.onDeath;
            e.onDeath = function (_killer, _skill, _tile, _fatalityType) {
                _out.push({Name = this.getName(), Killer = _killer == null ? null : _killer.getName(),
                    Skill = _skill == null ? null : _skill.getID(), Fatality = _fatalityType});
                return orig(_killer, _skill, _tile, _fatalityType);
            }
        }
    };
}

test("AI battle: kills, battles and repairs match the game's counters", function (t) {
    ::FFT.reset();
    ::BBT.toughen(null, true);
    local deaths = [], bros = t.roster();
    yield t.battle({spawn = "BanditRaiders", resources = 60, setup = function (p) {
        p.AfterDeploymentCallback = ::FFT.recordDeaths(deaths);
    }});
    t.eq(t.result.survivors.enemies, 0, "company wins");
    local bandits = ::World.FactionManager.getFactionOfType(::Const.FactionType.Bandits).getID();
    local total = 0, byBros = 0, parts = 0.0, oracle = 0.0;
    foreach (bro in bros) {
        local s = ::FFT.stats(bro), name = bro.getName();
        local mine = deaths.filter(@(_, d) d.Killer == name)
                           .map(@(d) {Name = d.Name, Skill = d.Skill, Fatality = d.Fatality});
        // A bro struck down by his own bleeding is in his Kills too, as Self
        local kills = s.Kills.filter(@(_, k) !k.IsPlayer);
        t.eq(kills.map(@(k) {Name = k.Name, Skill = k.Skill, Fatality = k.Fatality}), mine,
             name + ": kills vs the deaths seen");
        t.eq(kills.len(), bro.getLifetimeStats().Kills, name + ": kills vs LifetimeStats");
        t.eq(s.Battles, 1, name + ": battles");
        t.eq(s.BattlesLog.len(), 1, name + ": battle log");
        t.eq(s.BattlesLog[0].Kills, bro.m.CombatStats.Kills, name + ": battle log kills vs CombatStats");
        t.eq(s.BattlesLog[0].XPGained, bro.m.CombatStats.XPGained, name + ": XP gained");
        t.eq(s.BattlesLog[0].Id, 1, name + ": battle id");
        foreach (k in kills)
            t.eq([k.BattleId, k.Self, k.Charmed, k.Faction, k.Day, k.ClassName.find("bandit_")],
                 [1, false, false, bandits, ::World.getTime().Days, 0], name + ": kill record");
        total += kills.len();
        byBros += mine.len();
        if (!bro.isAlive()) continue;
        parts += s.Spent.Parts;
        foreach (item in bro.getItems().getAllItems())
            oracle += (item.getConditionMax() - item.getCondition()) * ::World.Assets.m.ArmorPartsPerArmor;
    }
    t.eq(total, byBros, "every death by a bro is his kill");
    t.probe("deaths", deaths.len());
    t.probe("kills", bros.map(@(b) ::FFT.stats(b).Kills.len()));
    // Condition lost by the gear the bros still have, as the game will repair it.
    t.probe("parts spent vs repair", [parts, oracle, ::World.Assets.getRepairRequired().ArmorParts]);
});

test("battle ids go up battle by battle", function (t) {
    ::FFT.reset();
    ::BBT.toughen(null, true);
    yield t.battle({entities = ::BBT.thugs(2), player = ::BBT.scripted(@(t) ::BBT.killAll(t.roster()[0]))});
    yield t.battle({entities = ::BBT.thugs(2), player = ::BBT.scripted(@(t) ::BBT.killAll(t.roster()[1]))});
    local a = ::FFT.stats(t.roster()[0]), b = ::FFT.stats(t.roster()[1]);
    t.eq(a.BattlesLog.map(@(r) r.Id), [1, 2], "first bro's battle ids");
    t.eq(a.Kills.map(@(r) r.BattleId), [1, 1], "first bro's kills");
    t.eq(b.Kills.map(@(r) r.BattleId), [2, 2], "second bro's kills");
    t.eq([a.Battles, b.Battles], [2, 2], "battles");
});

test("a bro killed in battle: casualty, obituary, death record", function (t) {
    ::FFT.reset();
    ::BBT.toughen(null, true);
    local victim = t.roster()[0], hero = t.roster()[1];
    local name = victim.getName(), ff = victim.m.FunFacts;
    ::FFT.setSurvival(victim, false);
    t.state.victim <- victim;
    t.state.hero <- hero;
    t.state.ff <- ff;
    local seen = t.state.seen <- {};
    yield t.battle({entities = ::BBT.thugs(2), player = ::BBT.scripted([
        function (t) {
            local thug = ::BBT.hostiles()[0];
            t.state.victim.kill(thug, ::BBT.attack(thug), ::Const.FatalityType.None);
            t.state.seen.killer <- thug.getName();
            local stub = ::Tactical.getCasualtyRoster().getAll().top();
            t.state.seen.stubFF <- stub.m.FunFacts == t.state.ff;
            t.state.seen.stubHints <- ::FFT.hints(stub.getRosterTooltip(), 4);
        },
        @(t) ::BBT.killAll(t.state.hero)
    ])});
    t.eq(t.result.survivors, {player = 2, enemies = 0}, "battle won");
    t.eq(::BBT.byName(name), null, "the victim left the roster");
    t.eq(seen.stubFF, true, "casualty stub carries his FunFacts");
    t.eq(seen.stubHints, ["Died once"], "casualty tooltip on the result screen");
    local idx = ::FFT.fallenByName(name);
    t.eq(idx, 0, "he is the latest fallen");
    local fallen = ::World.Statistics.getFallen()[idx];
    t.ok("FunFacts" in fallen && fallen.FunFacts == ff, "obituary entry carries his FunFacts");
    local s = ff.m.Stats;
    t.eq(s.Deaths.len(), 1, "one death");
    t.eq([s.Deaths[0].Name, s.Deaths[0].ClassName, s.Deaths[0].IsPlayer, s.Deaths[0].Self, s.Deaths[0].BattleId],
         [seen.killer, "bandit_thug", false, false, 1], "death record");
    t.eq([s.Battles, s.BattlesLog.len()], [1, 1], "the fatal battle counts once");
    t.eq(::FFT.fallenHints(idx), ["Died once"], "obituary tooltip");
});

test("save/load keeps every stat of the living and the fallen", function (t) {
    ::FFT.reset();
    ::BBT.toughen(null, true);
    local victim = t.roster()[2], hero = t.roster()[0];
    local victimName = victim.getName();
    ::FFT.setSurvival(victim, false);
    t.state.victim <- victim;
    t.state.hero <- hero;
    yield t.battle({entities = ::BBT.thugs(3), player = ::BBT.scripted([
        @(t) ::FFT.hit(t.state.hero, ::BBT.hostiles()[0], 20),
        @(t) ::FFT.hit(::BBT.hostiles()[0], t.state.hero, 20),
        @(t) t.state.victim.kill(t.state.hero, ::BBT.attack(t.state.hero), ::Const.FatalityType.Decapitated),
        @(t) ::BBT.killAll(t.state.hero, ::Const.FatalityType.Smashed)
    ])});
    local before = {}, fallenBefore = ::FFT.snapshot(::World.Statistics.getFallen()[0].FunFacts);
    foreach (bro in t.roster()) before[bro.getName()] <- ::FFT.snapshot(bro.m.FunFacts);
    local hintsBefore = ::FFT.rosterHints(hero), fallenHintsBefore = ::FFT.fallenHints(0);
    t.eq(::FFT.stats(hero).Kills.len(), 4, "hero's kills: 3 thugs and a bro");
    t.save("ff_roundtrip");
    yield t.load("ff_roundtrip");
    foreach (bro in t.roster())
        t.eq(::FFT.snapshot(bro.m.FunFacts), before[bro.getName()], bro.getName() + "'s stats after load");
    local fallen = ::World.Statistics.getFallen()[0];
    t.eq(fallen.Name, victimName, "fallen after load");
    t.eq("FunFacts" in fallen ? ::FFT.snapshot(fallen.FunFacts) : null, fallenBefore, "fallen stats after load");
    hero = ::BBT.byName(hero.getName());
    t.eq(::FFT.rosterHints(hero), hintsBefore, "roster tooltip after load");
    t.eq(::FFT.fallenHints(0), fallenHintsBefore, "obituary tooltip after load");
    t.eq(hero.m.FunFacts.getProp("PlayerKills").len(), 1, "PlayerKills rebuilt after load");
    t.eq(fallen.FunFacts.getProp("KilledByBros"), 1, "KilledByBros rebuilt after load");
    // A second round trip of what was loaded
    t.save("ff_roundtrip2");
    yield t.load("ff_roundtrip2");
    foreach (bro in t.roster())
        t.eq(::FFT.snapshot(bro.m.FunFacts), before[bro.getName()], bro.getName() + "'s stats after the second load");
});

test("friendly fire: the killer's PlayerKills, the victim's KilledByBros", function (t) {
    ::FFT.reset();
    ::BBT.toughen(null, true);
    local killer = t.roster()[0], victim = t.roster()[1];
    local kn = killer.getName(), vn = victim.getName();
    ::FFT.setSurvival(victim, false);
    t.state.killer <- killer;
    t.state.victim <- victim;
    yield t.battle({entities = ::BBT.thugs(1), player = ::BBT.scripted([
        @(t) t.state.victim.kill(t.state.killer, ::BBT.attack(t.state.killer), ::Const.FatalityType.Decapitated),
        @(t) ::BBT.killAll(t.roster()[1])
    ])});
    local ks = ::FFT.stats(killer);
    local pk = killer.m.FunFacts.getProp("PlayerKills");
    t.eq(pk.len(), 1, "one player kill");
    t.eq([pk[0].Name, pk[0].IsPlayer, pk[0].Self, pk[0].Fatality], [vn, true, false, 1], "player kill record");
    local idx = ::FFT.fallenByName(vn);
    local vff = ::World.Statistics.getFallen()[idx].FunFacts;
    t.eq(vff.getProp("KilledByBros"), 1, "victim killed by a bro");
    t.eq([vff.m.Stats.Deaths[0].Name, vff.m.Stats.Deaths[0].IsPlayer, vff.m.Stats.Deaths[0].Self],
         [kn, true, false], "victim's death record");
    t.eq(::FFT.fallenHints(idx), ["Died once from a hand of a bro"], "victim's obituary tooltip");
    t.eq(::FFT.rosterHints(killer), ["Unwittingly chopped " + ::FFT.ally(vn)], "killer's roster tooltip");
});

test("a bro who kills himself isn't a friendly-fire victim", function (t) {
    ::FFT.reset();
    ::BBT.toughen(null, true);
    local bro = t.roster()[0], name = bro.getName(), ff = bro.m.FunFacts;
    ::FFT.setSurvival(bro, false);
    t.state.bro <- bro;
    yield t.battle({entities = ::BBT.thugs(1), player = ::BBT.scripted([
        @(t) t.state.bro.kill(t.state.bro, ::BBT.attack(t.state.bro), ::Const.FatalityType.None),
        @(t) ::BBT.killAll(t.roster()[0])
    ])});
    local s = ff.m.Stats;
    t.eq([s.Deaths.len(), s.Deaths[0].Self, s.Kills.len(), s.Kills[0].Self], [1, true, 1, true], "self records");
    t.eq([ff.getProp("PlayerKills").len(), ff.getProp("KilledByBros")], [0, 0], "no friendly fire");
    t.eq(::FFT.fallenHints(::FFT.fallenByName(name)), ["Died once"], "obituary tooltip");
});

test("injuries suffered and inflicted", function (t) {
    ::FFT.reset();
    ::BBT.toughen(null, true);
    local bro = t.roster()[0], other = t.roster()[1];
    t.state.bro <- bro;
    t.state.other <- other;
    local got = t.state.got <- {};
    yield t.battle({entities = ::BBT.thugs(2), player = ::BBT.scripted([
        function (t) {
            local thug = ::BBT.hostiles()[0];
            t.state.got.attacker <- thug.getName();
            ::FFT.hit(t.state.bro, thug, 25);
            t.state.got.suffered <- t.state.bro.getSkills().query(::Const.SkillType.TemporaryInjury).map(@(s) s.getID());
        },
        function (t) {
            local thug = ::BBT.hostiles()[1];
            thug.getBaseProperties().Hitpoints = 300; thug.getSkills().update(); thug.setHitpoints(300);
            t.state.got.target <- thug.getName();
            ::FFT.hit(thug, t.state.other, 25);
            t.state.got.inflicted <- thug.getSkills().query(::Const.SkillType.TemporaryInjury).map(@(s) s.getID());
        },
        @(t) ::BBT.killAll(t.state.other)
    ])});
    local s = ::FFT.stats(bro), o = ::FFT.stats(other);
    t.eq(got.suffered.len(), 1, "the hit injured the bro");
    t.eq(s.Injuries.map(@(r) ["injury." + r.Injury, r.AttackerClass, r.AttackerName, r.BattleId]),
         [[got.suffered[0], "bandit_thug", got.attacker, 1]], "injuries suffered");
    t.eq(got.inflicted.len(), 1, "the hit injured the thug");
    t.eq(o.InjuriesDealt.map(@(r) ["injury." + r.Injury, r.TargetClass, r.TargetName, r.BattleId]),
         [[got.inflicted[0], "bandit_thug", got.target, 1]], "injuries inflicted");
    t.eq([s.InjuriesDealt.len(), o.Injuries.len()], [0, 0], "nothing else");
});

test("nine lives: a save", function (t) {
    ::FFT.reset();
    ::BBT.toughen(null, true);
    local bro = t.roster()[0];
    bro.getSkills().add(::new("scripts/skills/perks/perk_nine_lives"));
    t.state.bro <- bro;
    local hp = t.state.hp <- {};
    yield t.battle({entities = ::BBT.thugs(1), player = ::BBT.scripted([
        function (t) { ::FFT.hit(t.state.bro, ::BBT.hostiles()[0], 1000); t.state.hp.after <- t.state.bro.getHitpoints(); },
        @(t) ::BBT.killAll(t.state.bro)
    ])});
    t.ok(hp.after > 0, "nine lives kept him alive");
    local s = ::FFT.stats(bro);
    t.eq([s.NineLivesUses, s.NineLivesSaves], [1, 1], "uses, saves");
    t.eq(::FFT.rosterHints(bro).filter(@(_, h) h.find("nine lives") != null), ["Saved by nine lives once"], "tooltip");
});

test("nine lives: used, then died anyway", function (t) {
    ::FFT.reset();
    ::BBT.toughen(null, true);
    local bro = t.roster()[0], name = bro.getName(), ff = bro.m.FunFacts;
    ::FFT.setSurvival(bro, false);
    bro.getSkills().add(::new("scripts/skills/perks/perk_nine_lives"));
    t.state.bro <- bro;
    yield t.battle({entities = ::BBT.thugs(1), player = ::BBT.scripted([
        @(t) ::FFT.hit(t.state.bro, ::BBT.hostiles()[0], 1000, ::BBT.attack(::BBT.hostiles()[0])),
        @(t) ::FFT.hit(t.state.bro, ::BBT.hostiles()[0], 1000, ::BBT.attack(::BBT.hostiles()[0])),
        @(t) ::BBT.killAll(t.roster()[0])
    ])});
    t.eq(::BBT.byName(name), null, "he died");
    t.eq([ff.m.Stats.NineLivesUses, ff.m.Stats.NineLivesSaves], [1, 0], "uses, saves");
    local hints = ::FFT.fallenHints(::FFT.fallenByName(name));
    t.eq(hints.filter(@(_, h) h.find("nine lives") != null), ["Used nine lives once, died anyway"], "obituary");
});

test("effects added in battle are counted", function (t) {
    ::FFT.reset();
    ::BBT.toughen(null, true);
    local bro = t.state.bro <- t.roster()[0];
    yield t.battle({entities = ::BBT.thugs(1), player = ::BBT.scripted([
        function (t) {
            t.state.bro.getSkills().add(::new("scripts/skills/effects/stunned_effect"));
            t.state.bro.getSkills().add(::new("scripts/skills/effects/net_effect"));
            t.state.bro.getSkills().add(::new("scripts/skills/effects/dazed_effect"));
        },
        @(t) ::BBT.killAll(t.roster()[1])
    ])});
    local s = ::FFT.stats(bro);
    t.eq(s.BattlesLog[0].Added, {stunned = 1, net = 1, dazed = 1}, "effects in the battle log");
    t.eq(bro.m.FunFacts.getProp("Effects"), {stunned = 1, netted = 1}, "Effects prop");
    t.eq(::FFT.rosterHints(bro).filter(@(_, h) h.find("Was ") == 0).len(), 1, "effects line in the tooltip");
});

test("reserve bros slack, drunk ones noted", function (t) {
    ::FFT.reset();
    ::BBT.toughen(null, true);
    local slacker = t.roster()[2];
    slacker.setPlaceInFormation(20);
    slacker.getSkills().add(::new("scripts/skills/effects_world/drunk_effect"));
    yield t.battle({entities = ::BBT.thugs(1), player = ::BBT.scripted(@(t) ::BBT.killAll(t.roster()[0]))});
    local s = ::FFT.stats(slacker);
    t.eq([s.Battles, s.BattlesSkipped, s.CombatsSkipped.len(), s.BattlesLog.len()], [0, 1, 1, 0], "slacker's counts");
    t.eq(s.CombatsSkipped[0].Effects, ["effects.drunk"], "skipped while drunk");
    t.eq(::FFT.stats(t.roster()[0]).Battles, 1, "a fighter's battles");
    t.eq(::FFT.rosterHints(slacker).filter(@(_, h) h.find("Slacked for") == 0).len(), 1, "slacker's tooltip line");
});

test("fleeing and rallying", function (t) {
    ::FFT.reset();
    ::BBT.toughen(null, true);
    local bro = t.state.bro <- t.roster()[0];
    local states = t.state.states <- [];
    yield t.battle({entities = ::BBT.thugs(1), player = ::BBT.scripted([
        function (t) {
            local bro = t.state.bro;
            for (local i = 0; i < 4; i++) bro.checkMorale(-1, -1000);
            t.state.states.push(bro.getMoraleState());
            for (local i = 0; i < 5 && bro.getMoraleState() == ::Const.MoraleState.Fleeing; i++)
                bro.checkMorale(2, 1000);
            t.state.states.push(bro.getMoraleState());
        },
        @(t) ::BBT.killAll(t.roster()[1])
    ])});
    t.eq(states[0], ::Const.MoraleState.Fleeing, "fled");
    t.ok(states[1] != ::Const.MoraleState.Fleeing, "rallied");
    local rec = ::FFT.stats(bro).BattlesLog[0];
    t.eq([rec.Fled, rec.Returned], [1, 1], "fled, returned");
    t.eq(::FFT.rosterHints(bro).filter(@(_, h) h.find("Fled") == 0).len(), 1, "tooltip line");
});

test("a bro killed outside battle (event) keeps his facts in the obituary", function (t) {
    ::FFT.reset();
    ::BBT.toughen(null, true);
    yield t.battle({entities = ::BBT.thugs(2), player = ::BBT.scripted(@(t) ::BBT.killAll(t.roster()[0]))});
    local bro = t.roster()[0], name = bro.getName(), ff = bro.m.FunFacts;
    // What vanilla events do, e.g. cultist_finale_event, killer_vs_others_event
    ::World.Statistics.addFallen({Name = name, Time = ::World.getTime().Days, TimeWithCompany = 1,
        Kills = 2, Battles = 1, KilledBy = "Sacrificed to Davkul", Expendable = false});
    bro.getItems().transferToStash(::World.Assets.getStash());
    bro.getSkills().onDeath(::Const.FatalityType.None);
    ::World.getPlayerRoster().remove(bro);
    local fallen = ::World.Statistics.getFallen()[0];
    t.ok("FunFacts" in fallen && fallen.FunFacts == ff, "obituary entry carries his FunFacts");
    t.eq(::FFT.fallenHints(0), [], "no fun facts worth a line for two kills");
    t.eq(fallen.FunFacts.m.Stats.Kills.len(), 2, "kills kept");
    // Dismissing a bro afterwards doesn't touch the obituary
    local other = t.roster()[0], otherFF = other.m.FunFacts;
    ::World.getPlayerRoster().remove(other);
    t.ok(::World.Statistics.getFallen()[0].FunFacts == ff, "dismissal doesn't overwrite the last fallen");
});
