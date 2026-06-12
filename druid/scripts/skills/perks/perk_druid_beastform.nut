// Beastform - the Fighter gate. A one-time, permanent transformation: physical bonuses in
// exchange for losing heavy shields, helmets, body armor and all ranged weapons. The equipment
// ban is enforced by the item_container.equip hook in mod_druid; here we apply the stat bonuses,
// strip anything now forbidden, and (if Fantasy Bros assets are present) take on a beast look.
this.perk_druid_beastform <- this.inherit("scripts/skills/skill", {
    m = {}
    function create() {
        this.m.ID = "perk.druid.beastform";
        local perk = ::Const.Perks.LookupMap[this.m.ID];
        this.m.Name = perk.Name;
        this.m.Description = perk.Tooltip;
        this.m.Icon = perk.Icon;
        this.m.IconDisabled = perk.IconDisabled;

        this.m.Type = this.Const.SkillType.Perk;
        this.m.Order = this.Const.SkillOrder.Perk;
    }

    // Runs on unlock and on every load; both the strip and the look are idempotent (the equip
    // ban keeps anything forbidden from creeping back, and setBrush just resets the same sprites).
    function onAdded() {
        local actor = this.m.Container.getActor();
        if (::std.Util.isNull(actor)) return;
        ::Druid.applyBeastform(actor);
    }

    function onUpdate(_properties) {
        local B = ::Const.Druid.Beastform;
        _properties.MeleeSkillMult *= B.MeleeSkillMult;
        _properties.MeleeDefenseMult *= B.MeleeDefenseMult;
        _properties.HitpointsMult *= B.HitpointsMult;
    }
})
