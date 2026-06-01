// Bestow Regrowth on an ally. Only one ally may carry it at a time, so this first strips
// it from whoever holds it now, then grants it to the new target. No duration.
this.druid_regrowth <- this.inherit("scripts/skills/skill", {
    m = {
        // ID of the ally currently carrying our Regrowth, so we strip only our own bearer.
        BearerID = null
    },
    function create()
    {
        this.m.ID = "actives.druid_regrowth";
        this.m.Name = "Regrowth";
        this.m.Description = "Channel nature's vigor into an ally, mending their wounds turn"
                           + " after turn. Only one ally can carry it - bestowing it anew"
                           + " stops the previous one from mending.";
        this.m.Icon = "druid/active_regrowth.png";
        this.m.IconDisabled = "druid/active_regrowth_sw.png";
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
        return this.getDefaultUtilityTooltip();
    }

    function isViableTarget(_user, _target)
    {
        return ::std.Actor.isAlive(_target) && _target.isAlliedWith(_user);
    }

    function onVerifyTarget(_originTile, _targetTile)
    {
        if (!this.skill.onVerifyTarget(_originTile, _targetTile)) return false;
        if (!_targetTile.IsOccupiedByActor) return false;
        return this.isViableTarget(this.getContainer().getActor(), _targetTile.getEntity());
    }

    // Strip Regrowth from this druid's current bearer so only one ally carries ours.
    // Other druids' Regrowth is left alone, even on the same side.
    function clearExisting()
    {
        if (this.m.BearerID == null) return;
        local bearer = this.Tactical.getEntityByID(this.m.BearerID);
        this.m.BearerID = null;
        if (!::std.Util.isNull(bearer)) {
            bearer.getSkills().removeByID("effects.druid_regeneration");
        }
    }

    function onUse(_user, _targetTile)
    {
        if (!_targetTile.IsOccupiedByActor) return false;
        local target = _targetTile.getEntity();

        this.clearExisting();
        target.getSkills().add(::new("scripts/skills/effects/druid_regeneration_effect"));
        this.m.BearerID = target.getID();
        target.setDirty(true);

        if (!target.isHiddenToPlayer()) {
            this.Tactical.EventLog.log(
                this.Const.UI.getColorizedEntityName(target) + " is wreathed in healing growth"
            );
        }
        return true;
    }
});
