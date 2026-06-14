// Venom (ungrouped, adapts to your path). The behaviour lives elsewhere:
//   - Nature side: a passive flag read by druid_summon_beast (envenomed bite for the summons);
//     this file is inert there.
//   - Beast side (Beastform): onCombatStarted (below) puts the coat on the druid himself instead,
//     and his summons stop getting it.
// Venom and Beast Rage are mutually exclusive (see isPerkBlocked).
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
        // Beast variant: a Beastform druid carries the venom himself. The racial coat is
        // removed after battle, so it is reapplied each combat.
        if (this.m.Container.hasSkill("perk.druid.beastform")
            && !this.m.Container.hasSkill("racial.druid_venom")) {
            this.m.Container.add(::new("scripts/skills/racial/druid_venom"));
        }
    }
})
