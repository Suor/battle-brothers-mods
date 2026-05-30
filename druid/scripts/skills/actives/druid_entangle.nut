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
        # FIX: do not repeat whatever is alredy in ancestor
        this.m.Order = this.Const.SkillOrder.UtilityTargeted;
        this.m.ActionPointCost = 6;
        this.m.FatigueCost = 15;
        this.m.MinRange = 1;
        this.m.MaxRange = 6;
    }

    function getTooltip()
    {
        # FIX: use getDefaultUtilityTooltip(), same in other skills here
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
            },
            {
                id = 6,
                type = "text",
                icon = "ui/icons/vision.png",
                text = "Has a range of " + ::std.Text.positive(this.getMaxRange()) + " tiles"
            }
        ];
    }
});
