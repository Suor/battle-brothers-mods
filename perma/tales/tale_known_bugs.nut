// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_perma_hackflow@dev mod_hooks mod_msu stdlib@dev
// include: lib/helpers.nut

// KNOWN_BUGS.md: #1 (fixed in 2.0.3/2.0.4) a weapon vanishing when a bro loses a
// hand, #2 (fixed in 2.0.2) onShieldHit with a non-WeakTableRef attacker. Plus Missing Hand basics.

test("PE-KB1: out of battle a crossbow goes to the bag, with a full bag to the stash", function (t) {
    local bros = t.roster();
    local a = bros[0], b = bros[1];
    local bow = ::Tales.equip(a, "scripts/items/weapons/light_crossbow");
    ::PeT.loseHand(a);
    local bow2 = ::Tales.equip(b, "scripts/items/weapons/light_crossbow");
    local items = b.getItems();
    for (local i = 0; i < items.getUnlockedBagSlots(); i++)
        if (items.getItemAtBagSlot(i) == null) items.addToBag(::new("scripts/items/weapons/knife"));
    ::PeT.loseHand(b);
    t.eq([::PeT.whereIs(bow), ::PeT.whereIs(bow2)], ["bag", "stash"], "[free bag, full bag]");
    t.eq(a.getItems().getData()[::Const.ItemSlot.Offhand][0], -1, "offhand blocked");
    t.eq(a.getItems().equip(::new("scripts/items/shields/buckler_shield")), false, "can't take a shield");
});

test("PE-KB1: losing a hand in battle drops the crossbow on the tile, not into nothing", function (t) {
    ::Tales.toughen();
    local bro = t.roster()[0], id = t.state.id <- bro.getID();
    local bow = t.state.bow <- ::Tales.equip(bro, "scripts/items/weapons/light_crossbow");
    local out = t.state.out <- {};
    yield t.battle({spawn = "BanditRaiders", resources = 40, player = ::Tales.scripted([function (t) {
        local b = ::Tactical.getEntityByID(t.state.id);
        local bow = t.state.bow;
        ::PeT.loseHand(b);
        t.state.out.during <- ::PeT.whereIs(bow);
        t.state.out.onTile <- b.getTile().Items.find(bow) != null;
    }], @(t) ::Tactical.getEntityByID(t.state.id))});
    t.eq([out.during, out.onTile], ["tile", true], "[where, on the bro's tile]");
    // Not checked: the runner leaves the loot screen untaken, so it's "gone" after any battle.
    t.probe("after the battle", ::PeT.whereIs(bow));
});

// The second user report: "restore equipment" on, a 2H sword swapped for a 1H one mid-battle,
// then the hand lost: vanilla tries to put the greatsword back into the hands at battle end.
// The arming sword was in the bag when the battle started, so it goes back there.
test("PE-KB1: restore equipment after a swap keeps the greatsword", function (t) {
    local settings = ::Settings.getGameplaySettings();
    local restore = settings.RestoreEquipment;
    settings.RestoreEquipment = true;
    ::Tales.toughen();
    local bro = t.roster()[0], id = t.state.id <- bro.getID();
    local great = t.state.great <- ::Tales.equip(bro, "scripts/items/weapons/greatsword");
    local arming = t.state.arming <- ::new("scripts/items/weapons/arming_sword");
    bro.getItems().addToBag(arming);
    local out = t.state.out <- {};
    yield t.battle({spawn = "BanditRaiders", resources = 40, player = ::Tales.scripted([function (t) {
        local b = ::Tactical.getEntityByID(t.state.id), items = b.getItems();
        local great = t.state.great;
        local arming = t.state.arming;
        items.removeFromBag(arming);
        items.unequip(great);
        items.addToBag(great);
        items.equip(arming);
        ::PeT.loseHand(b);
        t.state.out.during <- [::PeT.whereIs(great), ::PeT.whereIs(arming)];
    }], @(t) ::Tactical.getEntityByID(t.state.id))});
    settings.RestoreEquipment = restore;
    t.eq(::Settings.getGameplaySettings().RestoreEquipment, restore, "setting restored");
    t.eq(out.during, ["bag", "mainhand"], "during battle [greatsword, arming sword]");
    t.eq([::PeT.whereIs(great), ::PeT.whereIs(arming)], ["bag", "bag"], "after battle [greatsword, arming sword]");
});

// KNOWN_BUGS #2: Lunge passes the attacker as a plain instance, not a WeakTableRef.
test("PE-KB2: a shield hit from a plain-instance attacker", function (t) {
    ::Tales.toughen();
    local bro = t.roster()[0], id = t.state.id <- bro.getID();
    ::Tales.equip(bro, "scripts/items/shields/wooden_shield");
    local out = t.state.out <- {};
    yield t.battle({spawn = "BanditRaiders", resources = 40, player = ::Tales.scripted([function (t) {
        local b = ::Tactical.getEntityByID(t.state.id), thug = ::Tales.hostiles()[0];
        thug.getSkills().add(::new("scripts/skills/injury_permanent/missing_finger_injury"));
        b.getSkills().add(::new("scripts/skills/injury_permanent/missing_finger_injury"));
        for (local i = 0; i < 20; i++) {
            b.getItems().onShieldHit(thug, ::Tales.attack(thug));          // a plain instance
            b.getItems().onShieldHit(::MSU.asWeakTableRef(thug), ::Tales.attack(thug));
        }
        t.state.out.ok <- true;
    }], @(t) ::Tactical.getEntityByID(t.state.id))});
    t.eq(out, {ok = true}, "no error");
});

// The first user report: a bro struck down who survives with Missing Hand (vanilla's
// isReallyKilled adds the injury while he is still on the map), holding a crossbow.
test("PE-KB1: struck down with a crossbow, survives with Missing Hand", function (t) {
    ::Tales.toughen();
    local bro = t.roster()[0], id = t.state.id <- bro.getID();
    local bow = t.state.bow <- ::Tales.equip(bro, "scripts/items/weapons/light_crossbow");
    bro.getBaseProperties().SurviveWithInjuryChanceMult = 1000.0;
    bro.getSkills().update();
    local perm = ::Const.Injury.Permanent;
    ::Const.Injury.Permanent = perm.filter(@(_, i) i.ID == "injury.missing_hand");
    local out = t.state.out <- {};
    yield t.battle({spawn = "BanditRaiders", resources = 40, player = ::Tales.scripted([function (t) {
        local b = ::Tactical.getEntityByID(t.state.id), thug = ::Tales.hostiles()[0];
        local tile = b.getTile();
        local bow = t.state.bow;
        b.kill(thug, ::Tales.attack(thug), ::Const.FatalityType.None);  // vanilla rolls survival only for None
        t.state.out.during <- [b.getSkills().hasSkill("injury.missing_hand"), ::PeT.whereIs(bow), tile.Items.find(bow) != null];
    }], @() ::Tales.hostiles()[0])});
    ::Const.Injury.Permanent = perm;
    t.eq(out.during, [true, "tile", true], "[missing hand, where, on his tile]");
    t.eq(::Tales.byId(id) != null, true, "he survived");
});
