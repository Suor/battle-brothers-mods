// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_camps_and_artifacts@dev stdlib@dev
// include: lib/helpers.nut

// Core: artifacts are made, named and saved; noble and city-state camps are built, capped and
// kept across a load.

test("every artifact is created, typed and named once in the stash", function (t) {
    local stash = ::World.Assets.getStash();
    stash.resize(stash.getCapacity() + 100);
    local bad = [], names = {};
    foreach (s in ::CAT.artifactScripts()) {
        local item = ::new(s);
        stash.add(item);
        if (!item.isItemType(::Const.Items.ItemType.Artifact) && s.find("/ammo/") == null)
            bad.push(s + ": not Artifact");
        if (item.getName() == "") bad.push(s + ": no name");
        names[item.getName()] <- true;
    }
    t.eq(bad, [], "artifacts");
    t.probe("distinct names", names.len());
});

test("artifacts keep their rolled stats across a save", function (t) {
    local stash = ::World.Assets.getStash();
    stash.resize(stash.getCapacity() + 100);
    local before = [];
    foreach (s in ::CAT.artifactScripts()) {
        local item = ::new(s);
        stash.add(item);
        before.push(::CAT.itemStats(item));
    }
    t.save("ca_items");
    yield t.load("ca_items");
    local after = [];
    foreach (st in before) {
        local i = ::CAT.findInStash(st.ID, st.Name);
        after.push(i == null ? null : ::CAT.itemStats(i));
    }
    t.eq(after, before, "stats after load");
});

test("artifact weapons and armor equip and fight", function (t) {
    ::Tales.toughen();
    local bros = t.roster();
    ::Tales.equip(bros[0], "scripts/items/weapons/artifact/artifact_greatsword");
    ::Tales.equip(bros[1], "scripts/items/weapons/artifact/artifact_warhammer");
    ::Tales.equip(bros[1], "scripts/items/armor/artifact/artifact_golden_scale_armor");
    ::Tales.equip(bros[2], "scripts/items/helmets/artifact/artifact_wolf_helmet");
    ::Tales.equip(bros[2], "scripts/items/shields/artifact/artifact_sipar_shield");
    yield t.battle({spawn = "BanditRaiders", resources = 60});
    t.eq(t.result.survivors.enemies, 0, "won");
    t.eq(t.roster().len(), 3, "nobody died");
});

local function campCounts() {
    local out = {};
    foreach (f in ::World.FactionManager.getFactions()) {
        if (f == null || (f.ClassName != "noble_faction" && f.ClassName != "city_state_faction")) continue;
        local camps = f.ca_getCamps();
        local alive = camps.filter(@(_, c) c.isAlive());
        out[f.getName()] <- {camps = camps.len(), alive = alive.len(),
            settlementsAreTowns = f.getSettlements().filter(@(_, s) !::isKindOf(s, "settlement")).len() == 0};
    }
    return out;
}

test("noble and city-state camps: built, capped, kept by a load", function (t) {
    yield t.days(10, {quiet = true, speed = 16.0});
    local before = campCounts();
    local over = [];
    foreach (name, c in before) {
        local cap = name.find("House") == 0 ? 12 : 5;
        if (c.camps > cap || c.camps == 0 || c.alive != c.camps || !c.settlementsAreTowns) over.push([name, c]);
    }
    t.eq(over, [], "camps within caps, alive, kept apart from towns");
    t.save("ca_camps");
    yield t.load("ca_camps");
    t.eq(campCounts(), before, "camps after load");
});

test("chilled effect: a refresh restarts its time", function (t) {
    local bro = t.roster()[0];
    local skills = bro.getSkills();
    skills.add(::new("scripts/skills/effects/chilled_effect"));
    local fx = skills.getSkillByID("effects.chilled");
    fx.m.TurnsLeft = 1;
    skills.add(::new("scripts/skills/effects/chilled_effect"));
    t.eq(skills.getSkillByID("effects.chilled").m.TurnsLeft, 2, "turns after a second chill");
    skills.removeByID("effects.chilled");
});
