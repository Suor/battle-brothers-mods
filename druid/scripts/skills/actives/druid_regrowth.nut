// Bestow Regrowth on an ally. Only one ally may carry it at a time, so this first strips
// it from whoever holds it now, then grants it to the new target. No duration.
this.druid_regrowth <- this.inherit("scripts/skills/skill", {
    m = {
        // ID of the ally currently carrying our Regrowth, so we strip only our own bearer.
        BearerID = null
    },
    function create()
    {
        m.ID = "actives.druid_regrowth";
        m.Name = "Regrowth";
        m.Description = "Channel nature's vigor into an ally, mending their wounds turn"
                           + " after turn, double for beasts and animals. One bearer at a"
                           + " time, and never the undead.";
        m.Icon = "druid/active_regrowth.png";
        m.IconDisabled = "druid/active_regrowth_sw.png";
        m.SoundOnUse = [
            "sounds/enemies/unhold_regenerate_01.wav"
        ];
        m.Type = ::Const.SkillType.Active;
        m.Order = ::Const.SkillOrder.UtilityTargeted;
        m.IsActive = true;
        m.IsTargeted = true;
        m.IsStacking = false;
        m.IsAttack = false;
        m.IsRanged = false;
        m.IsUsingHitchance = false;
        m.IsTargetingActor = true;
        m.IsDoingForwardMove = false;
        m.ActionPointCost = 5;
        m.FatigueCost = 20;
        m.MinRange = 1;
        m.MaxRange = 4;
    }

    function getTooltip()
    {
        return getDefaultUtilityTooltip();
    }

    function isViableTarget(_user, _target)
    {
        return ::std.Actor.isValidTarget(_target)
            && _target.getID() != _user.getID()
            && _target.isAlliedWith(_user)
            && !_target.getFlags().has("undead")
            // Never double up Regrowth - one bearer can't carry two druids' growth at once.
            && !_target.getSkills().hasSkill("effects.druid_regrowth");
    }

    function onVerifyTarget(_originTile, _targetTile)
    {
        if (!skill.onVerifyTarget(_originTile, _targetTile)) return false;
        if (!_targetTile.IsOccupiedByActor) return false;
        return isViableTarget(getContainer().getActor(), _targetTile.getEntity());
    }

    // Strip Regrowth from this druid's current bearer so only one ally carries ours.
    // Other druids' Regrowth is left alone, even on the same side.
    function clearExisting()
    {
        if (m.BearerID == null) return;
        local bearer = ::Tactical.getEntityByID(m.BearerID);
        m.BearerID = null;
        if (!::std.Util.isNull(bearer)) {
            bearer.getSkills().removeByID("effects.druid_regrowth");
        }
    }

    // Entity IDs are not stable across battles, so a stale BearerID could point at an unrelated
    // actor next fight - drop it together with the effect it tracks.
    function onCombatFinished()
    {
        skill.onCombatFinished();
        m.BearerID = null;
    }

    function onUse(_user, _targetTile)
    {
        if (!_targetTile.IsOccupiedByActor) return false;
        local target = _targetTile.getEntity();
        if (!isViableTarget(_user, target)) return false;

        clearExisting();
        target.getSkills().add(::new("scripts/skills/effects/druid_regrowth_effect"));
        m.BearerID = target.getID();
        target.setDirty(true);

        spawnIcon("druid_regrowth", _targetTile);

        if (!target.isHiddenToPlayer()) {
            ::Tactical.EventLog.log(
                ::Const.UI.getColorizedEntityName(target) + " is wreathed in healing growth"
            );
        }
        return true;
    }
});
