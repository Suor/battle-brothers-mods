// Venom (ungrouped, adaptive). As a Supporter it is a passive flag read by druid_summon_beast to
// give summoned beasts envenomed bites. Once the druid walks in Beastform it turns on the druid
// himself: at the start of each battle he gains the same weakening poison-coat, so his own melee
// hits poison the prey. (Venom and Beast Rage are mutually exclusive - see isPerkBlocked.)
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

    function onCombatStarted() {
        local actor = this.m.Container.getActor();
        if (::std.Util.isNull(actor)) return;
        // Fighter variant: a Beastform druid carries the venom himself. The racial coat is
        // removed after battle, so it is reapplied each combat.
        if (this.m.Container.hasSkill("perk.druid.beastform")
            && !this.m.Container.hasSkill("racial.druid_venom")) {
            this.m.Container.add(::new("scripts/skills/racial/druid_venom"));
        }
    }
})
