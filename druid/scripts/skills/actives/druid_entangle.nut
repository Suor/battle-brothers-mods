// Druid's take on the goblin shaman's Root: writhing roots pin an enemy in place.
this.druid_entangle <- this.inherit("scripts/skills/actives/root_skill", {
    m = {},
    function create()
    {
        this.root_skill.create();
        this.m.ID = "actives.druid_entangle";
        this.m.Name = "Entangling Roots";
        this.m.Description = "Call writhing roots from the earth to root an enemy in place,"
                           + " holding them fast for a turn.";
        this.m.Icon = "druid/active_entangle.png";
        this.m.IconDisabled = "druid/active_entangle_sw.png";
        this.m.MaxRange = 6;  // root_skill defaults to 8; everything else is inherited
    }

    function getTooltip()
    {
        local tooltip = this.getDefaultUtilityTooltip();
        tooltip.push({
            id = 6,
            type = "text",
            icon = "ui/icons/vision.png",
            text = "Has a range of " + ::std.Text.positive(this.getMaxRange()) + " tiles"
        });
        return tooltip;
    }
});
