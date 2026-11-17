// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_useful@dev mod_hooks mod_msu stdlib@dev

// Useful Things in the game: item values, flail skills, nets through a battle, goblin weapons,
// hand to hand by level.

local function stats(_script) {
    local w = ::new(_script);
    return [w.m.RegularDamage, w.m.RegularDamageMax, w.m.ArmorDamageMult];
}

test("2H flails hit harder", function (t) {
    t.eq([stats("scripts/items/weapons/two_handed_flail"), ::new("scripts/items/weapons/two_handed_flail").m.Value,
          stats("scripts/items/weapons/two_handed_wooden_flail"), stats("scripts/items/weapons/greenskins/orc_flail_2h")],
         [[55, 95, 1.2], 1700, [40, 65, 0.9], [60, 110, 1.3]], "damage, value");
    local named = ::new("scripts/items/weapons/named/named_two_handed_flail");
    t.ok(named.m.RegularDamage >= 55 && named.m.RegularDamageMax >= 95, "named rolls from the raised base: "
        + named.m.RegularDamage + "-" + named.m.RegularDamageMax);
});

local function flailSkills(_bro) {
    _bro.getSkills().update();
    local s = _bro.getSkills();
    local pound = s.getSkillByID("actives.pound"), thresh = s.getSkillByID("actives.thresh");
    return {fatigue = [pound.getFatigueCost(), thresh.getFatigueCost()], stun = [pound.m.StunChance, thresh.m.StunChance]};
}

// KNOWN_BUGS useful #1 (fixed in 0.7): 2H flails lost Flail Mastery's -25% fatigue.
test("US-KB1 (fixed): Flail Mastery: -25% fatigue and more stun on 2H flails", function (t) {
    foreach (script in ["scripts/items/weapons/two_handed_flail", "scripts/items/weapons/greenskins/orc_flail_2h"]) {
        local bro = t.roster()[0];
        bro.getSkills().removeByID("perk.mastery.flail");
        ::Tales.equip(bro, script);
        local plain = flailSkills(bro);
        bro.getSkills().add(::new("scripts/skills/perks/perk_mastery_flail"));
        local master = flailSkills(bro);
        t.probe(script, [plain, master]);
        t.eq(master, {fatigue = plain.fatigue.map(@(f) ::Math.ceil(f * 0.75)), stun = [50, 30]}, script + " as a master");
        t.eq(plain.stun, [30, 20], script + " stun without the perk");
        bro.getSkills().removeByID("perk.mastery.flail");
    }
});

test("named goblin spear: 3 AP thrust; falchion and bow get their values", function (t) {
    local bro = t.roster()[0];
    ::Tales.equip(bro, "scripts/items/weapons/named/named_goblin_spear");
    local s = bro.getSkills();
    t.eq([s.getSkillByID("actives.thrust").getActionPointCost(), s.getSkillByID("actives.spearwall").getActionPointCost()],
         [3, 3], "thrust, spearwall AP");
    local f = ::new("scripts/items/weapons/named/named_goblin_falchion");
    t.ok(f.m.AdditionalAccuracy >= 10, "falchion accuracy " + f.m.AdditionalAccuracy);
    ::Tales.equip(bro, "scripts/items/weapons/named/named_goblin_heavy_bow");
    t.eq(bro.getSkills().hasSkill("racial.goblin_ambusher"), true, "bow poisons");
});

test("hand to hand grows with the level", function (t) {
    local bro = t.roster()[0];
    local items = bro.getItems();
    foreach (slot in [::Const.ItemSlot.Mainhand, ::Const.ItemSlot.Offhand]) {
        local i = items.getItemAtSlot(slot);
        if (i != null) items.unequip(i);
    }
    local got = [];
    foreach (level in [1, 6, 11]) {
        bro.m.Level = level;
        bro.getSkills().update();
        local p = bro.getCurrentProperties();
        got.push([p.DamageRegularMin, p.DamageRegularMax]);
    }
    t.eq(got, [[5, 10], [15, 20], [25, 30]], "damage at levels 1, 6, 11");
});

test("a thrown net comes back for 6 ammo after the battle", function (t) {
    ::Tales.toughen();
    local bro = t.state.bro <- t.roster()[0];
    ::Tales.equip(bro, "scripts/items/weapons/arming_sword");
    local net = ::Tales.equip(bro, "scripts/items/tools/throwing_net");
    t.eq([net.getAmmo(), net.getAmmoMax(), net.getAmmoCost()], [1, 1, 6], "net ammo");
    bro.getSkills().update();
    t.eq(bro.getSkills().getSkillByID("special.double_grip").canDoubleGrip(), true, "double grip with a net");
    local ammo0 = ::World.Assets.getAmmo();
    local during = t.state.during <- [];
    yield t.battle({entities = ::Tales.thugs(1), fight = false, player = ::Tales.scripted([
        function (t) {
            local e = ::Tales.hostiles()[0];
            local bro = t.state.bro;
            local skill = bro.getSkills().getSkillByID("actives.throw_net");
            skill.onUse(bro, e.getTile());
            skill = bro.getSkills().getSkillByID("actives.throw_net"); // re-equipping the net renews its skills
            local off = bro.getItems().getItemAtSlot(::Const.ItemSlot.Offhand);
            t.state.during.push([off == null ? null : off.getID(), off == null ? null : off.getAmmo(),
                skill.isUsable(), e.getSkills().hasSkill("effects.net")]);
        },
        @() ::Tales.killAll()
    ])});
    t.eq(during, [["tool.throwing_net", 0, false, true]], "[offhand, its ammo, usable, target netted] after the throw");
    local off = bro.getItems().getItemAtSlot(::Const.ItemSlot.Offhand);
    t.eq([off.getID(), off.getAmmo(), off.getName()], ["tool.throwing_net", 1, "Throwing Net"], "net after the battle");
    t.eq(ammo0 - ::World.Assets.getAmmo(), 6, "ammo spent");
});
