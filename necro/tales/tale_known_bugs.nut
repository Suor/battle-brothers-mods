// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_necro@dev mod_hooks stdlib@dev

// KNOWN_BUGS.md: #1 possess on enemy undead, #2 Mind Meld, #5 possess after a
// battle (regression). A necro joins the company; the steps run in the first player turn.

local function setup(t) {
    ::Tales.toughen();
    local necro = ::Tales.hireTough("necro_background", 13);
    foreach (id in ["perk.necro.possess", "perk.necro.mind_meld", "perk.fast_adaption"])
        necro.getSkills().add(::new(::Const.Perks.LookupMap[id].Script));
    return necro.getID();
}

// Kills a thug spawned next to the necro and raises it with his own Raise Undead.
local function raiseNext(_necro, _out) {
    local tile = ::Tales.freeNear(_necro);
    local thug = ::Tales.spawn("scripts/entity/tactical/enemies/bandit_thug", tile,
        ::World.FactionManager.getFactionOfType(::Const.FactionType.Bandits).getID());
    thug.kill(_necro, ::Tales.attack(_necro), ::Const.FatalityType.None);
    local raise = _necro.getSkills().getSkillByID("actives.raise_undead");
    _out.raiseUsable <- raise.onVerifyTarget(_necro.getTile(), tile);
    raise.onUse(_necro, tile);
    _out.raised <- tile.IsEmpty ? null : tile.getEntity();
}

test("NE-KB1: possess can't target an enemy zombie, can a raised one", function (t) {
    t.state.id <- setup(t);
    local out = t.state.out <- {};
    local steps = [function (t) {
        local out = t.state.out;
        local necro = ::Tactical.getEntityByID(t.state.id);
        raiseNext(necro, out);
        local tile = ::Tales.freeNear(necro);
        local enemy = ::Tales.spawn("scripts/entity/tactical/enemies/zombie", tile,
            ::World.FactionManager.getFactionOfType(::Const.FactionType.Zombies).getID());
        out.enemy <- enemy;
    }, ::Tales.wait(120), function (t) {
        local out = t.state.out;
        local necro = ::Tactical.getEntityByID(t.state.id);
        local enemy = out.enemy;
        local possess = necro.getSkills().getSkillByID("actives.possess_undead");
        out.flags <- [enemy.getFlags().has("zombie_minion"), out.raised.getFlags().has("zombie_minion")];
        out.factions <- [enemy.isAlliedWith(necro), out.raised.getFaction() == ::Const.Faction.PlayerAnimals];
        out.verify <- [possess.onVerifyTarget(necro.getTile(), out.raised.getTile()),
                       possess.onVerifyTarget(necro.getTile(), enemy.getTile())];
        out.raisedState <- [out.raised.isAttackable(), out.raised.isAlive(), out.raised.isDying()];
        delete out.enemy;
    }];
    yield t.battle({spawn = "BanditRaiders", resources = 40,
        player = ::Tales.scripted(steps, @(t) ::Tactical.getEntityByID(t.state.id))});
    t.eq(out.raiseUsable, true, "the corpse can be raised");
    t.eq(out.flags, [true, true], "both are zombie minions");
    t.eq(out.factions, [false, true], "enemy is hostile, raised is ours");
    t.probe("raised [attackable, alive, dying]", out.raisedState);
    t.eq(out.verify, [true, false], "possess: [raised, enemy]");
});

test("NE-KB2: Mind Meld gives the raised zombie the necro's Fast Adaptation", function (t) {
    t.state.id <- setup(t);
    local out = t.state.out <- {};
    local steps = [function (t) {
        local out = t.state.out;
        local necro = ::Tactical.getEntityByID(t.state.id);
        raiseNext(necro, out);
        local ids = [];
        foreach (sk in out.raised.getSkills().getAllSkillsOfType(::Const.SkillType.Perk)) ids.push(sk.getID());
        out.perk <- out.raised.getSkills().hasSkill("perk.fast_adaption");
        out.ids <- ids;
    }];
    yield t.battle({spawn = "BanditRaiders", resources = 40,
        player = ::Tales.scripted(steps, @(t) ::Tactical.getEntityByID(t.state.id))});
    t.probe("raised perks", out.ids);
    t.eq(out.perk, true, "raised zombie has perk.fast_adaption");
});

test("NE-KB5: possessing ends with the battle, possess is usable in the next one", function (t) {
    local id = t.state.id <- setup(t);
    local out = t.state.out <- {};
    local steps = [function (t) {
        local out = t.state.out;
        local necro = ::Tactical.getEntityByID(t.state.id);
        raiseNext(necro, out);
        local possess = necro.getSkills().getSkillByID("actives.possess_undead");
        possess.onUse(necro, out.raised.getTile());
        out.during <- [necro.getSkills().hasSkill("effects.possessing_undead"), possess.isUsable()];
    }];
    local killer = @(t) ::Tactical.getEntityByID(t.state.id);
    yield t.battle({spawn = "BanditRaiders", resources = 40, player = ::Tales.scripted(steps, killer)});
    t.eq(out.during, [true, false], "while possessing: [effect, usable]");
    t.eq(::Tales.byId(id).getSkills().hasSkill("effects.possessing_undead"), false, "effect gone after battle");
    local next = t.state.next <- {};
    yield t.battle({spawn = "BanditRaiders", resources = 40, player = ::Tales.scripted([function (t) {
        local p = ::Tactical.getEntityByID(t.state.id).getSkills().getSkillByID("actives.possess_undead");
        t.state.next.usable <- p.isUsable();
    }], killer)});
    t.eq(next.usable, true, "possess usable in the next battle");
});
