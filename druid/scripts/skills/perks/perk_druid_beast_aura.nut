// Beast Aura (Beast group) - any allied beast near him stands fearless and emboldened (the
// druid_beast_aura_effect carried by beasts reads this perk as the aura source).
//
// FIX: should only affect beast unleashed or summoned by the owner of the perk. Not any ally AI character with
//      protect behavior
// The modest TargetAttractionMult bump marks the druid as a VIP so the AI's ai_protect behaviour
// keeps the leashed beasts close.
this.perk_druid_beast_aura <- this.inherit("scripts/skills/skill", {
    m = {}
    function create() {
        this.m.ID = "perk.druid.beast_aura";
        local perk = ::Const.Perks.LookupMap[this.m.ID];
        this.m.Name = perk.Name;
        this.m.Description = perk.Tooltip;
        this.m.Icon = perk.Icon;
        this.m.IconDisabled = perk.IconDisabled;

        this.m.Type = this.Const.SkillType.Perk;
        this.m.Order = this.Const.SkillOrder.Perk;
    }

    function onUpdate(_properties) {
        _properties.TargetAttractionMult *= ::Const.Druid.Aura.TargetAttractionMult;
    }

    // Tag allied beasts already on the field (e.g. other brothers' war dogs) with the aura
    // receiver. The druid's own summons are tagged as they are called (druid_summon_beast).
    function onCombatStarted() {
        foreach (beast in ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.PlayerAnimals)) {
            if (::std.Util.isNull(beast)) continue;
            if (!beast.getSkills().hasSkill("effects.druid_beast_aura"))
                beast.getSkills().add(::new("scripts/skills/effects/druid_beast_aura_effect"));
        }
    }
})
