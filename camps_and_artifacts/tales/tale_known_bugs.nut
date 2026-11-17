// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_camps_and_artifacts@dev stdlib@dev
// include: lib/helpers.nut

// KNOWN_BUGS.md: KB1, KB7, KB8, KB9 under vanilla.

test("CA-KB7: a plain handgonne is not Famed", function (t) {
    local gun = ::new("scripts/items/weapons/oriental/handgonne");
    t.eq(gun.isItemType(::Const.Items.ItemType.Named), false, "Named");
    t.eq(gun.isItemType(::Const.Items.ItemType.Artifact), false, "Artifact");
    t.eq(gun.getDescription().find("Famed"), null, "description");
    // the Artifact bit must not share a bit with any other item type
    local art = ::Const.Items.ItemType.Artifact, clash = [];
    foreach (k, v in ::Const.Items.ItemType)
        if (k != "Artifact" && typeof v == "integer" && (v & (v - 1)) == 0 && (v & art) != 0) clash.push(k);
    t.eq(clash, [], "single-bit item types sharing Artifact's bit");
});

local function iceArrows() {
    local a = ::new("scripts/items/ammo/artifact_imbued_arrows");
    a.m.campart_Effect = "ice";
    a.updateIcon();
    return a;
}

test("CA-KB8: freezing arrows chill, and their tooltips say so", function (t) {
    ::Tales.toughen();
    local bro = t.roster()[0];
    ::Tales.equip(bro, "scripts/items/weapons/hunting_bow");
    local arrows = ::Tales.equip(bro, iceArrows());
    local itemText = arrows.getTooltip().filter(@(_, e) e.id == 7)[0].text;
    local fxSkill = bro.getSkills().getSkillByID("special.campart_ice_ammo");
    local shoot = bro.getSkills().getSkillByID("actives.aimed_shot");
    local tip = [];
    fxSkill.onQueryTooltip(shoot, tip);
    t.probe("tooltips", [arrows.getName(), itemText, tip.len() ? tip[0].text : null]);

    local applied = t.state.applied <- [];
    t.state.fxSkill <- fxSkill; t.state.shoot <- shoot;
    yield t.battle({entities = ::Tales.thugs(1), fight = false, player = ::Tales.scripted([
        function (t) {
            local e = ::Tales.hostiles()[0];
            t.state.fxSkill.onTargetHit(t.state.shoot, e, ::Const.BodyPart.Body, 5, 0);
            t.state.applied.push(e.getSkills().hasSkill("effects.chilled"));
            t.state.applied.push(e.getSkills().hasSkill("effects.frozen"));
        },
        @() ::Tales.killAll()
    ])});
    t.eq(applied, [true, false], "a hit applies Chilled, not some freeze");
    // the effect is Chilled; the item and the skill both promise freezing
    t.eq([itemText.find("reez"), tip[0].text.find("reez")], [null, null], "CA-KB8: tooltips promise freezing");
});

test("CA-KB9 (fixed in 3.5.0): artifact armor's +2 fatigue recovery doesn't stack", function (t) {
    ::Tales.toughen();
    local bro = t.roster()[0];
    local rate0 = bro.getCurrentProperties().FatigueRecoveryRate;
    local armor = ::new("scripts/items/armor/artifact/artifact_golden_scale_armor");
    armor.m.AttachedPerk = "scripts/skills/traits/bonus_stam_regen_trait";
    armor.m.APTooltip = "+2 Fatigue Recovery";
    armor.m.APID = "trait.bonus_stam_regen";
    ::Tales.equip(bro, armor);
    local count = @(_bro) _bro.getSkills().getAllSkillsOfType(::Const.SkillType.Trait)
        .filter(@(_, s) s.getID() == "trait.bonus_stam_regen").len();
    local seen = [[count(bro), bro.getCurrentProperties().FatigueRecoveryRate - rate0]];
    for (local i = 0; i < 2; i++) {
        yield t.battle({entities = ::Tales.thugs(1), fight = false, player = ::Tales.scripted(@() ::Tales.killAll())});
        seen.push([count(bro), bro.getCurrentProperties().FatigueRecoveryRate - rate0]);
    }
    local name = bro.getName();
    t.save("ca_kb9");
    yield t.load("ca_kb9");
    bro = t.roster().filter(@(_, b) b.getName() == name)[0];
    seen.push([count(bro), bro.getCurrentProperties().FatigueRecoveryRate - rate0]);
    t.eq(seen, [[1, 2], [1, 2], [1, 2], [1, 2]], "[traits, recovery bonus] before, after 2 battles, after load");
});

// CA-KB1 without Reforged (its 0.9 doesn't boot in the code env): Reforged's -25 head chance set by hand.
test("CA-KB1: an artifact with a negative head chance goes through MSU's serialization emulator", function (t) {
    local sword = ::new("scripts/items/weapons/artifact/artifact_fencing_sword");
    sword.m.ChanceToHitHead = -25;
    local out = ::MSU.Class.SerializationEmulator(::MSU.Class.MetaDataEmulator()), err = null;
    try { sword.onSerialize(out); } catch (e) { err = e; }
    t.eq(err, null, "CA-KB1: onSerialize throws in writeU8");
    if (err != null) return;
    local copy = ::new("scripts/items/weapons/artifact/artifact_fencing_sword");
    copy.onDeserialize(::MSU.Class.DeserializationEmulator(::MSU.Class.MetaDataEmulator(), out.getData()));
    t.eq(::CAT.itemStats(copy), ::CAT.itemStats(sword), "round trip");
});
