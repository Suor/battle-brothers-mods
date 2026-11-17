// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_challenges@dev mod_hooks stdlib@dev
// include: lib/helpers.nut

// Each challenge switched on through its MSU setting (restored after), checked against what
// the game does with it off.

test("food price and wages multipliers", function (t) {
    local food = ::new("scripts/items/supplies/bread_item");
    local bro = t.roster()[0];
    local plain = [food.getValue(), bro.getDailyCost()];
    local mult = ::CHT.with({foodPriceMult = 3, wageMult = 2}, @() [food.getValue(), bro.getDailyCost()]);
    t.eq(mult, [::Math.floor(plain[0] * 3), ::Math.floor(plain[1] * 2)], "food price x3, wage x2");
});

test("enemy scaling multiplies the party strength", function (t) {
    local party = ::World.State.getPlayer();
    party.updateStrength();
    local plain = party.m.Strength;
    local scaled = ::CHT.with({enemyScale = 2.0}, function () { party.updateStrength(); return party.m.Strength; });
    t.near(scaled, plain * 2.0, 0.01, "strength x2");
});

test("banned followers are left out of the hire list", function (t) {
    local ids = @() ::World.Retinue.getFollowersForUI().map(@(f) f.ID);
    local all = ids();
    local banned = ::CHT.with({"ban_follower.cook": true, "ban_follower.scout": true}, ids);
    t.eq([all.find("follower.cook") != null, all.find("follower.scout") != null], [true, true], "offered by default");
    t.eq(banned, all.filter(@(_, id) id != "follower.cook" && id != "follower.scout"), "cook and scout gone");
});

test("allowed shields and two-handers", function (t) {
    local bro = t.roster()[0];
    local items = bro.getItems();
    foreach (slot in [::Const.ItemSlot.Mainhand, ::Const.ItemSlot.Offhand]) {
        local old = items.getItemAtSlot(slot);
        if (old != null) items.unequip(old);
    }
    local tryEquip = function (_script) {
        local item = ::new(_script);
        local ok = items.equip(item);
        if (ok) items.unequip(item);
        return ok;
    };
    t.eq(::CHT.with({shieldsAllowed = "none"}, @() [tryEquip("scripts/items/shields/buckler_shield"), tryEquip("scripts/items/shields/wooden_shield")]), [false, false], "none");
    t.eq(::CHT.with({shieldsAllowed = "bucklers"}, @() [tryEquip("scripts/items/shields/buckler_shield"), tryEquip("scripts/items/shields/wooden_shield")]), [true, false], "bucklers");
    t.eq(::CHT.with({shieldsAllowed = "light"}, @() [tryEquip("scripts/items/shields/wooden_shield"), tryEquip("scripts/items/shields/heater_shield")]), [true, false], "light");
    t.eq(::CHT.with({noTwoHandedSwords = true, noTwoHandedHammers = true}, @() [tryEquip("scripts/items/weapons/greatsword"), tryEquip("scripts/items/weapons/two_handed_hammer"), tryEquip("scripts/items/weapons/arming_sword")]), [false, false, true], "2H sword, 2H hammer, arming sword");
    t.eq([tryEquip("scripts/items/shields/heater_shield"), tryEquip("scripts/items/weapons/greatsword")], [true, true], "all allowed by default");
});

test("hiring requirement keeps only affordable or cheap recruits", function (t) {
    local town = ::World.EntityManager.getSettlements()[0];
    local roster = ::World.getRoster(town.getID());
    ::World.Assets.addMoney(-::World.Assets.getMoney() + 1000);
    local limit = 1000 / 10;
    ::CHT.with({hiringRequirement = 10}, function () {
        for (local i = 0; i < 3; i++) town.updateRoster(true);
    });
    local bad = roster.getAll().filter(@(_, b) !(b.getBackground().ClassName in ::Challenges.CheapClasses)
        && b.getDailyCost() > ::Challenges.LowWage && b.getHiringCost() > limit);
    t.probe("roster size", roster.getSize());
    t.eq(bad.map(@(b) [b.getBackground().getID(), b.getHiringCost()]), [], "unaffordable recruits");
    t.ok(roster.getSize() > 0, "someone to hire");
});

test("loot: no equipment drops at 0% chance, gold instead", function (t) {
    local restore = ::CHT.set({weaponDropChance = 0.0, armorDropChance = 0.0});
    yield t.battle({entities = [
        {ID = ::Const.EntityType.BanditThug, Variant = 0, Row = 0, Script = "scripts/entity/tactical/enemies/bandit_thug"},
        {ID = ::Const.EntityType.BanditThug, Variant = 0, Row = 0, Script = "scripts/entity/tactical/enemies/bandit_thug"},
        {ID = ::Const.EntityType.BanditRaider, Variant = 0, Row = 0, Script = "scripts/entity/tactical/enemies/bandit_raider"}],
        player = ::CHT.killAllPlayer()});
    restore();
    t.eq(t.result.result, ::Const.Tactical.CombatResult.EnemyDestroyed, "won");
    local loot = ::CHT.Loot;
    t.probe("loot", loot);
    t.eq(loot.equipment, [], "equipment dropped");
    t.ok(loot.money > 0, "gold compensation");
});

test("loot: equipment drops with the defaults", function (t) {
    yield t.battle({entities = [
        {ID = ::Const.EntityType.BanditThug, Variant = 0, Row = 0, Script = "scripts/entity/tactical/enemies/bandit_thug"},
        {ID = ::Const.EntityType.BanditThug, Variant = 0, Row = 0, Script = "scripts/entity/tactical/enemies/bandit_thug"},
        {ID = ::Const.EntityType.BanditRaider, Variant = 0, Row = 0, Script = "scripts/entity/tactical/enemies/bandit_raider"}],
        player = ::CHT.killAllPlayer()});
    t.eq(t.result.result, ::Const.Tactical.CombatResult.EnemyDestroyed, "won");
    local loot = ::CHT.Loot;
    t.probe("loot", loot);
    t.ok(loot.equipment.len() > 0, "equipment dropped");
    t.eq(loot.money, 0, "no compensation");
});

test("loot: random cap of 1 keeps one piece", function (t) {
    local restore = ::CHT.set({maxItemsPerBattle = 1, chooseAtRandom = true});
    yield t.battle({entities = [
        {ID = ::Const.EntityType.BanditThug, Variant = 0, Row = 0, Script = "scripts/entity/tactical/enemies/bandit_thug"},
        {ID = ::Const.EntityType.BanditThug, Variant = 0, Row = 0, Script = "scripts/entity/tactical/enemies/bandit_thug"},
        {ID = ::Const.EntityType.BanditRaider, Variant = 0, Row = 0, Script = "scripts/entity/tactical/enemies/bandit_raider"}],
        player = ::CHT.killAllPlayer()});
    restore();
    local loot = ::CHT.Loot;
    t.probe("loot", loot);
    t.eq(loot.equipment.len(), 1, "equipment kept");
    t.ok(loot.money > 0, "gold for the rest");
});
