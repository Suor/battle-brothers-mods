// mode: campaign seed=bbtest-battle origin=scenario.necro fresh=1
// mods: mod_necro@dev mod_hooks stdlib@dev

// The Necromancer origin.

test("origin: the starting company", function (t) {
    local bgs = t.roster().map(@(b) b.getBackground().getID());
    bgs.sort();
    t.probe("backgrounds", bgs);
    t.eq(t.roster().len(), 5, "necro, apprentice, 3 meat");
    local necro = t.roster().filter(@(_, b) b.getFlags().get("IsPlayerCharacter"));
    t.eq(necro.len(), 1, "one player character");
    t.eq(necro[0].getBackground().getID(), "background.necro", "he is the necro");
    t.eq(necro[0].getSkills().hasSkill("actives.raise_undead"), true, "can raise");
    t.eq([::World.Assets.m.BrothersMax, ::World.Assets.m.BrothersMaxInCombat], [25, 16], "roster limits");
});

// KNOWN_BUGS #4 (fixed in 0.4.2): a crash with 22 bros; 16 of them fight.
test("NE-KB4: 22 bros in the Necro origin, 16 in formation", function (t) {
    local roster = ::World.getPlayerRoster();
    while (roster.getSize() < 22) {
        local bro = roster.create("scripts/entity/tactical/player");
        bro.setStartValuesEx(["beggar_background"]);
    }
    ::World.Assets.updateFormation(true);
    local places = t.roster().map(@(b) b.getPlaceInFormation());
    local inCombat = places.filter(@(_, p) p <= 17).len();
    local unique = {};
    foreach (p in places) unique[p] <- true;
    t.eq([roster.getSize(), inCombat, unique.len()], [22, 16, 22], "[bros, in combat, distinct places]");
    t.eq(places.filter(@(_, p) p == 255).len(), 0, "everyone placed");
    yield t.battle({spawn = "BanditRaiders", resources = 40, fight = false,
        player = ::Tales.scripted([], @(t) t.roster()[0])});
    t.eq(t.result.survivors.player, 16, "16 fought");
});

test("origin: meat is cheap, the rest dear", function (t) {
    local origin = ::World.Assets.getOrigin();
    local meat = ::World.getPlayerRoster().create("scripts/entity/tactical/player");
    meat.setStartValuesEx(["beggar_background"]);
    local knight = ::World.getPlayerRoster().create("scripts/entity/tactical/player");
    knight.setStartValuesEx(["hedge_knight_background"]);
    t.eq([origin.getBroCostMult(meat), origin.getBroCostMult(knight)], [0.6, 1.3], "cost mults");
    t.eq(meat.getDailyCost(), ::Math.floor(meat.m.CurrentProperties.DailyWage * meat.m.CurrentProperties.DailyWageMult * 0.8), "meat wage");
});

test("origin: a raised zombie is chopped when the battle ends", function (t) {
    local necro = t.roster().filter(@(_, b) b.getFlags().get("IsPlayerCharacter"))[0];
    ::Tales.toughen();
    t.state.id <- necro.getID();
    local out = t.state.out <- {};
    yield t.battle({spawn = "BanditRaiders", resources = 40, player = ::Tales.scripted([function (t) {
        local n = ::Tactical.getEntityByID(t.state.id);
        local tile = ::Tales.freeNear(n);
        local thug = ::Tales.spawn("scripts/entity/tactical/enemies/bandit_thug", tile,
            ::World.FactionManager.getFactionOfType(::Const.FactionType.Bandits).getID());
        thug.kill(n, ::Tales.attack(n), ::Const.FatalityType.None);
        n.getSkills().getSkillByID("actives.raise_undead").onUse(n, tile);
        t.state.out.raised <- !tile.IsEmpty && tile.getEntity().getFaction() == ::Const.Faction.PlayerAnimals;
    }], @(t) ::Tactical.getEntityByID(t.state.id))});
    t.eq(out.raised, true, "raised as PlayerAnimals");
    t.eq(t.result.survivors.enemies, 0, "won");
    t.eq(::World.getPlayerRoster().getSize(), 5, "no zombie joins");
});
