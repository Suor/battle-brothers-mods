this.necro_raise_undead <- this.inherit("scripts/skills/actives/raise_undead", {
    m = {},

    function create() {
        this.raise_undead.create()
        this.m.Description = "Raises a corpse to fight for you as undead."
                           + "Will attack your enemies but otherwise cannot really be controlled."
        this.m.IconDisabled = "skills/active_26_sw.png";
        this.m.SoundVolume = 1.5;   // More loud
        this.m.ActionPointCost = 5; // Cannot raise three in a single turn anymore
        this.m.FatigueCost = 20;    // Need to stay fit :)
        this.m.MinRange = 1;
        this.m.MaxRange = 4; // Not 99 anymore
    }

    function getTooltip() {
        return [
            {
                id = 1,
                type = "title",
                text = this.getName()
            },
            {
                id = 2,
                type = "description",
                text = this.getDescription()
            },
            {
                id = 3,
                type = "text",
                text = this.getCostString()
            }
            {
                id = 6,
                type = "text",
                icon = "ui/icons/vision.png",
                text = "Has a range of " + ::std.Text.positive(this.getMaxRange())
            }
        ];
    }

    function onAfterUpdate(_properties) {
        local hasMastery = this.getContainer().hasSkill("perk.necro.mastery");
        this.m.ActionPointCost = hasMastery ? 4 : 5;
        this.m.FatigueCost = hasMastery ? 15 : 20;

        local hasRange = this.getContainer().hasSkill("perk.necro.range");
        if (hasRange) this.m.MaxRange *= 2;
    }

    function spawnUndead(_user, _tile) {
        local p = _tile.Properties.get("Corpse");
        // Leave our mark
        p.necro_master <- ::MSU.asWeakTableRef(_user);
        p.Faction = _user.getFaction();
        // Raise as an animal, i.e. no control
        if (p.Faction == ::Const.Faction.Player) p.Faction = ::Const.Faction.PlayerAnimals;
        local e = this.Tactical.Entities.onResurrect(p, true);
        if (e == null) return

        e.getSprite("socket").setBrush(_user.getSprite("socket").getBrush().Name);
    }
});
