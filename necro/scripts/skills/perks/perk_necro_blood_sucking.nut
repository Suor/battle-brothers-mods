this.perk_necro_blood_sucking <- this.inherit("scripts/skills/skill", {
    m = {}
    function create() {
        this.m.ID = "perk.necro.blood_sucking";
        local perk = ::Const.Perks.LookupMap[this.m.ID];
        this.m.Name = perk.Name;
        this.m.Description = perk.Tooltip;
        this.m.Icon = perk.Icon;
        this.m.IconDisabled = perk.IconDisabled;

        this.m.Type = this.Const.SkillType.Perk;
        this.m.Order = this.Const.SkillOrder.Perk;
    }

    function onRaiseUndead(_undead) {
        ::logInfo("necro: blood_sucking.onRaiseUndead");
        local skill = ::new("scripts/skills/racial/vampire_racial");
        skill.m.IsRemovedAfterBattle = true;
        _undead.m.Skills.add(skill);
    }
})
