// Beast Aura (Beast group) - the druid's own summoned (or unleashed) beasts stand fearless and
// emboldened near him. They carry the druid_beast_aura_effect (added in druid_summon_beast), which
// reads this perk as the aura source but only on its own master - so the aura never spills onto
// other brothers' war dogs or any other player-allied beast.
//
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
})
