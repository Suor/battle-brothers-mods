// mode: campaign seed=bbtest-nick fresh=1
// mods: mod_nicknames@dev mod_msu stdlib@dev
// include: lib/helpers.nut

// The factor set buildFactorSet() reads off real brothers: attributes, weapons, backgrounds.

local function stripItems(_bro) {
    local items = _bro.getItems();
    foreach (slot in ["Mainhand", "Offhand", "Head", "Body", "Accessory"]) {
        local item = items.getItemAtSlot(::Const.ItemSlot[slot]);
        if (item != null) items.unequip(item);
    }
    _bro.getSkills().update();
}

test("generated base attributes lie in the ranges the mod assumes", function (t) {
    ::NickT.resetState();
    local bgs = ["farmhand_background", "sellsword_background", "hedge_knight_background",
        "beggar_background", "hunter_background", "monk_background", "wildman_background",
        "adventurous_noble_background", "cripple_background", "squire_background"];
    local out = [];
    for (local i = 0; i < 60; i++) {
        local bro = ::NickT.recruit([bgs[i % bgs.len()]]);
        local change = bro.getBackground().onChangeAttributes();
        local props = bro.getBaseProperties();
        foreach (attr, br in ::Nicknames.BaseAttrRanges) {
            local low = br[0] + change[attr][0], high = br[1] + change[attr][1];
            if (props[attr] < low || props[attr] > high)
                out.push(bro.getBackground().getID() + " " + attr + "=" + props[attr] + " not in " + low + ".." + high);
        }
    }
    t.eq(out, []);
    ::World.getTemporaryRoster().clear();
});

// BUG N2: attr.* factors are read from getCurrentProperties() right after setStartValuesEx()
// has equipped the recruit, so armor weight lowers Stamina and turns attr.Stamina.* on and off.
test("N2: attribute factors don't depend on the starting equipment", function (t) {
    ::NickT.resetState();
    local bgs = ["hedge_knight_background", "sellsword_background", "squire_background",
        "retired_soldier_background", "deserter_background", "militia_background"];
    local diffs = [];
    for (local i = 0; i < 30; i++) {
        local bro = ::NickT.recruit([bgs[i % bgs.len()]]);
        local equipped = ::NickT.factorsWithPrefix(::Nicknames.buildFactorSet(bro), "attr.");
        local stamina = bro.getCurrentProperties().Stamina;
        stripItems(bro);
        local bare = ::NickT.factorsWithPrefix(::Nicknames.buildFactorSet(bro), "attr.");
        if (!::Tales.equal(equipped, bare))
            diffs.push(bro.getBackground().getID() + " Stamina " + stamina + "/" + bro.getCurrentProperties().Stamina
                + ": " + ::Tales.repr(equipped) + " vs bare " + ::Tales.repr(bare));
    }
    t.probe("examples", diffs.slice(0, ::Math.min(3, diffs.len())));
    t.eq(diffs.len(), 0, "recruits whose attr factors change when unequipped");
    ::World.getTemporaryRoster().clear();
});

test("traits' effects on attributes count, armored or not", function (t) {
    ::NickT.resetState();
    local bad = [], byTrait = 0;
    for (local i = 0; i < 30; i++) {
        local bro = ::NickT.recruit(["hedge_knight_background", "sellsword_background"]);
        if (!bro.getSkills().hasSkill("trait.fat"))
            bro.getSkills().add(::new("scripts/skills/traits/fat_trait"));  // Stamina -10, Hitpoints +10
        local equipped = ::NickT.factorsWithPrefix(::Nicknames.buildFactorSet(bro), "attr.");
        stripItems(bro);
        local want = ::NickT.attrFactors(bro, bro.getCurrentProperties());
        if (!::Tales.equal(equipped, want)) bad.push(::Tales.repr(equipped) + " vs " + ::Tales.repr(want));
        if (!::Tales.equal(want, ::NickT.attrFactors(bro, bro.getBaseProperties()))) byTrait++;
    }
    t.eq(bad, []);
    t.probe("recruits whose attr factors the trait changes", byTrait);
    t.ok(byTrait > 0, "the trait changes some recruit's attr factors");
    ::World.getTemporaryRoster().clear();
});

test("attribute factors follow the base attributes and talents", function (t) {
    ::NickT.resetState();
    // Without equipment, traits aside, current and base properties agree, so the rule applies to both.
    local bad = [];
    for (local i = 0; i < 40; i++) {
        local bro = ::World.getTemporaryRoster().create("scripts/entity/tactical/player");
        bro.setStartValuesEx(["farmhand_background", "daytaler_background", "miller_background"], false);
        bro.fillTalentValues();
        stripItems(bro);
        local got = ::NickT.factorsWithPrefix(::Nicknames.buildFactorSet(bro), "attr.");
        local want = ::NickT.attrFactors(bro, bro.getBaseProperties());
        if (!::Tales.equal(got, want)) bad.push(::Tales.repr(got) + " vs " + ::Tales.repr(want));
    }
    t.eq(bad, []);
    ::World.getTemporaryRoster().clear();
});

test("MSU weapon type of the main hand becomes a factor", function (t) {
    ::NickT.resetState();
    local bro = ::NickT.recruit(["farmhand_background"]);
    stripItems(bro);
    bro.getItems().equip(::new("scripts/items/weapons/arming_sword"));
    t.eq(::NickT.factorsWithPrefix(::Nicknames.buildFactorSet(bro), "weapon."), ["weapon.sword"]);
    stripItems(bro);
    bro.getItems().equip(::new("scripts/items/weapons/hunting_bow"));
    t.eq(::NickT.factorsWithPrefix(::Nicknames.buildFactorSet(bro), "weapon."), ["weapon.bow"]);
    stripItems(bro);
    t.eq(::NickT.factorsWithPrefix(::Nicknames.buildFactorSet(bro), "weapon."), [], "unarmed");
    ::World.getTemporaryRoster().clear();
});

test("mastery perks count as weapon factors", function (t) {
    ::NickT.resetState();
    local bro = ::NickT.recruit(["farmhand_background"]);
    stripItems(bro);
    bro.getSkills().add(::new("scripts/skills/perks/perk_mastery_dagger"));
    t.eq(::NickT.factorsWithPrefix(::Nicknames.buildFactorSet(bro), "weapon."), ["weapon.dagger"]);
    t.ok(::NickT.has(::NickT.titles(bro), "the Stinger"), "dagger title among candidates");
    ::World.getTemporaryRoster().clear();
});

test("background, groups, cost and type factors", function (t) {
    ::NickT.resetState();
    local bro = ::NickT.recruit(["beggar_background"]);
    local fs = ::Nicknames.buildFactorSet(bro);
    t.eq(::NickT.factorsWithPrefix(fs, "background."), ["background.beggar"]);
    t.eq(::NickT.factorsWithPrefix(fs, "group."), ["group.lowborn", "group.pauper"]);
    t.eq(::NickT.factorsWithPrefix(fs, "cost."), ["cost.low"]);
    t.eq(::NickT.factorsWithPrefix(fs, "type."), ["type.melee"]);

    bro = ::NickT.recruit(["hunter_background"]);
    fs = ::Nicknames.buildFactorSet(bro);
    t.eq(::NickT.factorsWithPrefix(fs, "type."), ["type.ranged"]);

    bro = ::NickT.recruit(["hedge_knight_background"]);
    fs = ::Nicknames.buildFactorSet(bro);
    t.eq(::NickT.factorsWithPrefix(fs, "group."), ["group.combat"]);
    t.eq(::NickT.factorsWithPrefix(fs, "cost."), ["cost.high"]);
    ::World.getTemporaryRoster().clear();
});

test("traits and permanent injuries are factors", function (t) {
    ::NickT.resetState();
    local bro = ::NickT.recruit(["farmhand_background"]);
    foreach (s in bro.getSkills().getAllSkillsOfType(::Const.SkillType.Trait))
        if (s.getID().find("trait.") == 0) bro.getSkills().remove(s);
    bro.getSkills().add(::new("scripts/skills/traits/tiny_trait"));
    bro.getSkills().add(::new("scripts/skills/traits/bright_trait"));
    bro.getSkills().add(::new("scripts/skills/injury_permanent/missing_eye_injury"));
    local fs = ::Nicknames.buildFactorSet(bro);
    t.eq(::NickT.factorsWithPrefix(fs, "trait."), ["trait.bright", "trait.tiny"]);
    t.eq(::NickT.factorsWithPrefix(fs, "injury."), ["injury.missing_eye"]);
    local titles = ::NickT.titles(bro);
    t.ok(::NickT.has(titles, "the Imp"), "tiny + bright combo");
    t.ok(::NickT.has(titles, "One-Eye"), "missing eye");
    ::World.getTemporaryRoster().clear();
});

test("Executioner background has its titles", function (t) {
    ::NickT.resetState();
    local bro = ::NickT.recruit(["executioner_background"]);
    t.eq(bro.getBackground().getID(), "background.executioner");
    t.ok(::NickT.has(::NickT.titles(bro), "the Block"), "the Block among candidates");
    t.ok(bro.getTitle() != "", "titled");
    ::World.getTemporaryRoster().clear();
});

test("Black Pyramid elemental factors match titles", function (t) {
    ::NickT.resetState();
    // No Black Pyramid here: a vanilla trait and perk relabelled with its IDs.
    local bro = ::NickT.recruit(["farmhand_background"]);
    local fear = ::new("scripts/skills/traits/fear_beasts_trait");
    fear.m.ID = "trait.elem_fear_fire";
    bro.getSkills().add(fear);
    local affinity = ::new("scripts/skills/perks/perk_student");
    affinity.m.ID = "perk.elem_fire_affinity";
    bro.getSkills().add(affinity);
    local titles = ::NickT.titles(bro);
    t.ok(::NickT.has(titles, "the Singed"), "fire phobia title");
    t.ok(::NickT.has(titles, "the Salamander"), "fire affinity title");
    ::World.getTemporaryRoster().clear();
});
