// Passive flag - read by druid_summon_beast to give summoned beasts envenomed bites.
this.perk_druid_venom <- this.inherit("scripts/skills/skill", {
    m = {}
    function create() {
        this.m.ID = "perk.druid.venom";
        local perk = ::Const.Perks.LookupMap[this.m.ID];
        this.m.Name = perk.Name;
        this.m.Description = perk.Tooltip;
        this.m.Icon = perk.Icon;
        this.m.IconDisabled = perk.IconDisabled;

        this.m.Type = this.Const.SkillType.Perk;
        this.m.Order = this.Const.SkillOrder.Perk;
    }
})
