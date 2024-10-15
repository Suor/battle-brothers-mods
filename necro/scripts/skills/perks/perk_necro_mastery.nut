// Things are implemented in necro_raise_undead skill
this.perk_necro_mastery <- this.inherit("scripts/skills/skill", {
    m = {}
    function create() {
        this.m.ID = "perk.necro.mastery";
        local perk = ::Const.Perks.LookupMap[this.m.ID];
        this.m.Name = perk.Name;
        this.m.Description = perk.Tooltip;
        this.m.Icon = perk.Icon;
        this.m.IconDisabled = perk.IconDisabled;

        this.m.Type = this.Const.SkillType.Perk;
        this.m.Order = this.Const.SkillOrder.Perk;
    }
})
