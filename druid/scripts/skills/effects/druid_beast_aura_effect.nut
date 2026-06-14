// The receiving half of Beast Aura: carried by the druid's own summons (added in
// druid_summon_beast). While its own master holds Beast Aura within range it emboldens the beast
// with Resolve and lets it stand fearless (the actor.checkMorale hook in mod_druid floors morale
// while active). Inert otherwise - see hasSourceNear for the owner-scoping.
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

    // Only the beast's own master emboldens it - the druid who summoned (or unleashed) it, while he
    // holds Beast Aura and stands within range. Other allied Beast-Aura druids do not, so the aura
    // stays scoped to the owner's own pack rather than reaching every player-allied beast.
    function hasSourceNear()
    {
        local actor = this.getContainer().getActor();
        if (!actor.isPlacedOnMap()) return false;
        if (("State" in this.Tactical) && this.Tactical.State.isBattleEnded()) return false;

        local master = actor.druid_master();
        if (master == null || !master.isPlacedOnMap() || !::std.Actor.isAlive(master)) return false;
        if (!master.getSkills().hasSkill("perk.druid.beast_aura")) return false;
        return master.getTile().getDistanceTo(actor.getTile()) <= ::Const.Druid.Aura.Range;
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
