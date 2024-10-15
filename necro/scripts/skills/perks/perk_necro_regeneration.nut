this.perk_necro_regeneration <- this.inherit("scripts/skills/skill", {
    m = {}
    function create() {
        this.m.ID = "perk.necro.regeneration";
        local perk = ::Const.Perks.LookupMap[this.m.ID];
        this.m.Name = perk.Name;
        this.m.Description = perk.Tooltip;
        this.m.Icon = perk.Icon;
        this.m.IconDisabled = perk.IconDisabled;

        this.m.Type = this.Const.SkillType.Perk;
        this.m.Order = this.Const.SkillOrder.Perk;
    }

    function onRaiseUndead(_undead) {
        ::logInfo("necro: regeneration.onRaiseUndead");
        local skill = ::new("scripts/skills/racial/necro_regeneration");
        if (this.m.Container.hasSkill("perk.necro.flesh_of_iron")) skill.m.HealArmor = true;
        _undead.m.Skills.add(skill);
    }
})
