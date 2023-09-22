::mods_hookExactClass("ai/tactical/behaviors/ai_engage_melee", function(cls) {
    while(!("evaluate" in cls)) cls = cls[cls.SuperName];

    local evaluate = cls.evaluate;
    cls.evaluate = function(_entity) {
        if (!("_autopilot" in _entity.m)) return evaluate(_entity);

        local done = evaluate(_entity);
        if (done && this.m.IsWaitingBeforeMove) this.m.Score /= 10;
        return done;
    }
});

::mods_hookExactClass("ai/tactical/behaviors/ai_attack_default", function (cls) {
    cls.m.PossibleSkills.extend(["actives.lunge"]);
});

// Debug fatigue score mult
::mods_hookBaseClass("ai/tactical/behavior", function(cls) {
    while (!("getFatigueScoreMult" in cls)) cls = cls[cls.SuperName];

    local getFatigueScoreMult = cls.getFatigueScoreMult;
    cls.getFatigueScoreMult = function(_skill) {
        local entity = this.getAgent().getActor();
        if (!("_autopilot" in entity.m)) return getFatigueScoreMult(_skill);

        logInfo("ap: FATIGUE Mult for " + entity.getName() + " " + _skill.getName());

        local apPct = _skill.getActionPointCost() / (entity.getActionPointsMax() * 1.0);
        local fatigue = this.Math.max(0, _skill.getFatigueCost() - entity.getCurrentProperties().FatigueRecoveryRate * entity.getCurrentProperties().FatigueRecoveryRateMult * apPct);
        local currentFatigue = entity.getFatigue();
        local maxFatigue = entity.getFatigueMax();
        logInfo("ap: apPct=" + apPct + " fatigue=" + fatigue
           + " of " + currentFatigue + "/" + maxFatigue);

        local mult = getFatigueScoreMult(_skill);
        local alt = (1.0 * (maxFatigue - currentFatigue - fatigue) / maxFatigue - 0.5)
        // 0.4 + (1.0 - fatigue / (maxFatigue - currentFatigue)) * 0.6;
        logInfo("ap: FATIGUE Mult = " + mult + " alt = " + alt);

        return mult;
    }
});
