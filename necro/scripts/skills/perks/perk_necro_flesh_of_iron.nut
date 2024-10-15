this.perk_necro_flesh_of_iron <- this.inherit("scripts/skills/skill", {
    m = {}
    function create() {
        this.m.ID = "perk.necro.flesh_of_iron";
        local perk = ::Const.Perks.LookupMap[this.m.ID];
        this.m.Name = perk.Name;
        this.m.Description = perk.Tooltip;
        this.m.Icon = perk.Icon;
        this.m.IconDisabled = perk.IconDisabled;

        this.m.Type = this.Const.SkillType.Perk;
        this.m.Order = this.Const.SkillOrder.Perk;
    }

    function onRaiseUndead(_undead) {
        ::logInfo("necro: flesh_of_iron.onRaiseUndead");
        ::Necro.restoreArmorPct(_undead, "head", 0.3);
        ::Necro.restoreArmorPct(_undead, "body", 0.3);
    }
})
