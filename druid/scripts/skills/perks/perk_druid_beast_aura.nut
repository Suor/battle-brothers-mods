// Beast Aura (Beast group) - every allied animal near the druid stands fearless and emboldened.
// Animals carry druid_beast_aura_effect (added in actor.onPlacedOnMap), which scans for a nearby
// druid holding this perk. The TargetAttractionMult bump marks the druid as a VIP so the AI's
// ai_protect keeps his beasts close.
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
