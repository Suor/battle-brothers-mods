// Grants the Regrowth active while the perk is held.
this.perk_druid_regrowth <- this.inherit("scripts/skills/skill", {
    m = {}
    function create() {
        this.m.ID = "perk.druid.regrowth";
        local perk = ::Const.Perks.LookupMap[this.m.ID];
        this.m.Name = perk.Name;
        this.m.Description = perk.Tooltip;
        this.m.Icon = perk.Icon;
        this.m.IconDisabled = perk.IconDisabled;

        this.m.Type = this.Const.SkillType.Perk;
        this.m.Order = this.Const.SkillOrder.Perk;
    }

    function onAdded() {
        if (!this.m.Container.hasSkill("actives.druid_regrowth"))
            this.m.Container.add(::new("scripts/skills/actives/druid_regrowth"));
    }

    function onRemoved() {
        this.m.Container.removeByID("actives.druid_regrowth");
    }
})
