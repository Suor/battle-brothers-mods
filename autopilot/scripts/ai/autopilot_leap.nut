// Legends' Leap into melee, rolled against engage_melee's walk: jumps when that's the only way to a foe this turn or
// leaves AP for more swings. Landing tiles are scored by engage_melee's tile terms: target value, foes' zones of
// control, height and bad terrain. A reach bro never lands in a zone of control. The jump passes zones of control
// without attacks of opportunity and ignores the path.
// Darkflight's own evaluation assumes a 6-tile, 4 AP jump and dives into crowds, so only its execution is kept.
this.autopilot_leap <- ::inherit("scripts/ai/tactical/behaviors/ai_darkflight", {
    m = {},
    function create()
    {
        m.ID = ::Const.AI.Behavior.ID.AP_Leap;
        m.Order = ::Const.AI.Behavior.Order.AP_Leap;
        m.PossibleSkills = ["actives.legend_leap"];
        m.IsThreaded = false;
        behavior.create();
    }

    function onEvaluate( _entity )
    {
        m.TargetTile = null;
        m.SelectedSkill = null;
        local props = getProperties(), engageID = ::Const.AI.Behavior.ID.EngageMelee;
        local engageMult = props.BehaviorMult[engageID];
        // Whatever holds a bro back from engaging holds back this too
        if (engageMult == 0 || props.PreferWait || getAgent().getBehavior(engageID) == null) return 0;
        if (_entity.m._autopilot.ranged) return 0;
        if (_entity.getActionPoints() < ::Const.Movement.AutoEndTurnBelowAP) return 0;
        if (_entity.getMoraleState() == ::Const.MoraleState.Fleeing) return 0;

        local skill = selectSkill(m.PossibleSkills);
        if (skill == null) return 0;
        local range = _entity.getIdealRange();
        if (queryTargetsInMeleeRange(1, range).len() > 0) return 0;
        local swingAP = cheapestSwing(_entity);
        if (swingAP == null) return 0;
        local swings = @(_ap) _ap < 0 ? -1 : _ap / swingAP;

        local myTile = _entity.getTile(), opponents = [];
        foreach (o in getAgent().getKnownOpponents()) {
            local a = o.Actor;
            if (::std.Util.isNull(a) || !a.isAttackable() || a.getMoraleState() == ::Const.MoraleState.Fleeing) continue;
            opponents.push(a);
        }
        local walkSwings = -1;
        foreach (a in opponents)
            if (myTile.getDistanceTo(a.getTile()) <= 9)
                walkSwings = ::Math.max(walkSwings, swings(::Autopilot.apLeftAfterWalk(_entity, a.getTile(), range)));
        local leapSwings = swings(_entity.getActionPoints() - skill.getActionPointCost());
        if (leapSwings <= walkSwings) return 0;

        local B = ::Const.AI.Behavior, factions = _entity.getAlliedFactions(), best = null, bestScore = 0;
        local tiles = [];
        ::Tactical.queryTilesInRange(myTile, 1, skill.getMaxRange(), false, [], @(_t, _tag) _tag.push(_t), tiles);
        foreach (tile in tiles) {
            if (!skill.isUsableOn(tile)) continue;
            local zocs = tile.getZoneOfControlCountOtherThan(factions);
            if (range > 1 && zocs > 0) continue;
            local value = 0, level = 0;
            foreach (a in opponents) {
                local d = tile.getDistanceTo(a.getTile());
                if (d > range || d < 1) continue;
                local v = queryTargetValue(_entity, a, null);
                if (v > value) { value = v; level = tile.Level - a.getTile().Level; }
            }
            if (value == 0) continue;
            local score = value * B.EngageTargetValueMult + level * B.EngageTerrainLevelBonus
                - zocs * B.EngageMultipleOpponentsPenalty * props.EngageTargetMultipleOpponentsMult
                - (tile.IsBadTerrain ? B.EngageBadTerrainPenalty * props.EngageOnBadTerrainPenaltyMult : 0);
            if (score > bestScore) { best = tile; bestScore = score; }
        }
        if (best == null) return 0;

        m.TargetTile = best;
        m.SelectedSkill = skill;
        return B.Score.AP_Leap * engageMult * (1.0 + bestScore / B.EngageTargetValueMult)
            * ::Autopilot.fatigueScoreMult(_entity, skill.getFatigueCost())
            * (leapSwings > 0 ? B.EngageAndAttackMult : 1.0);
    }

    // AP of the cheapest melee attack the bro has, null if none
    function cheapestSwing( _entity )
    {
        local ap = null;
        foreach (s in _entity.getSkills().queryActives())
            if (s.isAttack() && !s.isRanged() && s.isUsable())
                ap = ap == null ? s.getActionPointCost() : ::Math.min(ap, s.getActionPointCost());
        return ap;
    }
});
