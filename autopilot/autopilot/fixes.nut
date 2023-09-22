// Fix crash after ranged actor killing somebody
::mods_hookExactClass("ai/tactical/behaviors/ai_engage_ranged", function (o) {
    local function isRelevant(_actor) {
        return !_actor.isNull() && !_actor.m.IsDying && _actor.m.IsAlive;
    }

    local function cleanup(_b) {
        _b.m.ValidTargets = _b.m.ValidTargets.filter(@(_, t) isRelevant(t.Actor));
        _b.m.PotentialDanger = _b.m.PotentialDanger.filter(@(_, a) isRelevant(a));
    }

    // The problem with this is while we go through tiles a target might become invalid,
    // usually after a ranged bro shoots someone and we are evaluating his next shot
    local selectBestTargetTile = o.selectBestTargetTile;
    o.selectBestTargetTile = function (_entity, _maxRange, _considerLineOfFire, _visibleTileNeeded) {
        local ret;
        local gen = selectBestTargetTile(_entity, _maxRange, _considerLineOfFire, _visibleTileNeeded);

        while (true) {
            cleanup(this);
            ret = resume gen;
            // Proxy "results"
            if (ret != null) return ret;
            yield ret;
        }
    }
});

// Debug fatigue score mult
::mods_hookBaseClass("ai/tactical/behavior", function(cls) {
    while (!("getFatigueScoreMult" in cls)) cls = cls[cls.SuperName];

    local getFatigueScoreMult = cls.getFatigueScoreMult;
    cls.getFatigueScoreMult = function(_skill) {
        local entity = this.getAgent().getActor();
        logInfo("ap: getFatigueScoreMult " + entity.getName() + " " + _skill.getName());
        if (!("_autopilot" in entity.m)) return getFatigueScoreMult(_skill);

        logInfo("ap: FATIGUE Mult for " + entity.getName() + " " + _skill.getName());

        local apPct = _skill.getActionPointCost() / (entity.getActionPointsMax() * 1.0);
        local fatigue = this.Math.max(0, _skill.getFatigueCost() - entity.getCurrentProperties().FatigueRecoveryRate * entity.getCurrentProperties().FatigueRecoveryRateMult * apPct);
        local currentFatigue = entity.getFatigue();
        local maxFatigue = entity.getFatigueMax();
        logInfo("ap: apPct=" + apPct + " fatigue=" + fatigue
           + " of " + currentFatigue + "/" + maxFatigue);

        local mult = getFatigueScoreMult(_skill);
        logInfo("ap: FATIGUE Mult = " + mult);

        return mult;
    }
});
