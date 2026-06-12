// The receiving half of Beast Aura: carried by allied beasts, it looks for a nearby Beast Aura
// druid (the source) and, while one is in range, emboldens the beast with Resolve and lets it
// stand fearless (the actor.checkMorale hook in mod_druid floors morale while this is active).
// Inert when no aura source is near, so it is safe to hang on every player-allied beast.
this.druid_beast_aura_effect <- this.inherit("scripts/skills/skill", {
    m = {
        IsAuraActive = false
    }
    function create()
    {
        this.m.ID = "effects.druid_beast_aura";
        this.m.Name = "Beast Aura";
        this.m.Icon = "ui/perks/perk_28.png";
        this.m.Type = this.Const.SkillType.StatusEffect;
        this.m.Order = this.Const.SkillOrder.VeryLast;
        this.m.IsActive = false;
        this.m.IsStacking = false;
        this.m.IsRemovedAfterBattle = true;
        this.m.IsHidden = true;
    }

    function isAuraActive()
    {
        return this.m.IsAuraActive;
    }

    function getDescription()
    {
        return "An alpha of the wild stands near. This beast is emboldened and will not flee the field while the aura holds.";
    }

    function getTooltip()
    {
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
                id = 10,
                type = "text",
                icon = "ui/icons/bravery.png",
                text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + ::Const.Druid.Aura.Resolve + "[/color] Resolve"
            }
        ];
    }

    // Is a Beast Aura druid within range? Sources are player-faction actors holding the perk.
    function hasSourceNear()
    {
        local actor = this.getContainer().getActor();
        if (!actor.isPlacedOnMap()) return false;
        if (("State" in this.Tactical) && this.Tactical.State.isBattleEnded()) return false;

        local myTile = actor.getTile();
        local range = ::Const.Druid.Aura.Range;
        local sources = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);
        foreach( src in sources )
        {
            if (::std.Util.isNull(src) || !src.isPlacedOnMap() || !src.isAlive()) continue;
            if (!src.getSkills().hasSkill("perk.druid.beast_aura")) continue;
            if (src.getTile().getDistanceTo(myTile) <= range) return true;
        }
        return false;
    }

    function onUpdate( _properties )
    {
        this.m.IsHidden = !this.m.IsAuraActive;
    }

    function onAfterUpdate( _properties )
    {
        this.m.IsAuraActive = this.hasSourceNear();
        this.m.IsHidden = !this.m.IsAuraActive;
        if (this.m.IsAuraActive)
        {
            _properties.Bravery += ::Const.Druid.Aura.Resolve;
        }
    }

    function onCombatFinished()
    {
        this.skill.onCombatFinished();
        this.m.IsAuraActive = false;
        this.m.IsHidden = true;
    }
});
