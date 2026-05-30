// Bestow Regrowth on an ally. Only one ally may carry it at a time, so this first strips
// it from whoever holds it now, then grants it to the new target. No duration.
this.druid_regrowth <- this.inherit("scripts/skills/skill", {
    m = {},
    function create()
    {
        this.m.ID = "actives.druid_regrowth";
        this.m.Name = "Regrowth";
        this.m.Description = "Channel nature's vigor into an ally, mending their wounds turn"
                           + " after turn. Only one ally can carry it — bestowing it anew"
                           + " stops the previous one from mending.";
        this.m.Icon = "druid/perk_regrowth.png";
        this.m.IconDisabled = "druid/perk_regrowth_sw.png";
        this.m.SoundOnUse = [
            "sounds/enemies/unhold_regenerate_01.wav"
        ];
        this.m.Type = this.Const.SkillType.Active;
        this.m.Order = this.Const.SkillOrder.UtilityTargeted;
        this.m.IsActive = true;
        this.m.IsTargeted = true;
        this.m.IsStacking = false;
        this.m.IsAttack = false;
        this.m.IsRanged = false;
        this.m.IsUsingHitchance = false;
        this.m.IsTargetingActor = true;
        this.m.IsDoingForwardMove = false;
        this.m.ActionPointCost = 5;
        this.m.FatigueCost = 20;
        this.m.MinRange = 1;
        this.m.MaxRange = 4;
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
                id = 3,
                type = "text",
                text = this.getCostString()
            }
        ];
    }

    function isViableTarget(_user, _target)
    {
        return _target.isAlliedWith(_user) && ::std.Actor.isAlive(_target);
    }

    function onVerifyTarget(_originTile, _targetTile)
    {
        if (!this.skill.onVerifyTarget(_originTile, _targetTile)) return false;
        if (!_targetTile.IsOccupiedByActor) return false;
        return this.isViableTarget(this.getContainer().getActor(), _targetTile.getEntity());
    }

    // Strip Regrowth from any current bearer so only one ally carries it.
    function clearExisting()
    {
        foreach (faction in [this.Const.Faction.Player, this.Const.Faction.PlayerAnimals]) {
            foreach (actor in this.Tactical.Entities.getInstancesOfFaction(faction)) {
                if (actor.getSkills().hasSkill("effects.druid_regeneration")) {
                    actor.getSkills().removeByID("effects.druid_regeneration");
                }
            }
        }
    }

    function onUse(_user, _targetTile)
    {
        if (!_targetTile.IsOccupiedByActor) return false;
        local target = _targetTile.getEntity();

        this.clearExisting();
        target.getSkills().add(this.new("scripts/skills/effects/druid_regeneration_effect"));
        target.setDirty(true);

        if (!target.isHiddenToPlayer()) {
            this.Tactical.EventLog.log(
                this.Const.UI.getColorizedEntityName(target) + " is wreathed in healing growth"
            );
        }
        return true;
    }
});
