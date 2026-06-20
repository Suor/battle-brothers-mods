// The receiving half of Beast Aura: rides every allied animal (added in actor.onPlacedOnMap).
// While any allied druid holding Beast Aura stands within range it emboldens the animal with
// Resolve and lets it stand fearless (the actor.checkMorale hook in mod_druid floors morale while
// active). Inert otherwise.
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

    // Active while any allied druid holding Beast Aura stands within range - like captain_effect
    // scanning for a nearby leader. Not scoped to the animal's own master, so it reaches every
    // player-allied animal.
    function hasSourceNear()
    {
        local actor = this.getContainer().getActor();
        if (!actor.isPlacedOnMap() || !actor.isAlliedWithPlayer()) return false;
        if (("State" in this.Tactical) && this.Tactical.State.isBattleEnded()) return false;

        local myTile = actor.getTile();
        foreach (druid in this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player))
        {
            if (!::std.Actor.isAlive(druid) || !druid.isPlacedOnMap()) continue;
            if (!druid.getSkills().hasSkill("perk.druid.beast_aura")) continue;
            if (druid.getTile().getDistanceTo(myTile) <= ::Const.Druid.Aura.Range) return true;
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
