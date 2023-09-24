::mods_hookExactClass("ai/tactical/behaviors/ai_engage_melee", function(cls) {
    while(!("evaluate" in cls)) cls = cls[cls.SuperName];

    local evaluate = cls.evaluate;
    cls.evaluate = function(_entity) {
        if (!("_autopilot" in _entity.m)) return evaluate(_entity);

        local done = evaluate(_entity);
        if (done && this.m.IsWaitingBeforeMove) this.m.Score /= 5;
        return done;
    }
});

::mods_hookExactClass("ai/tactical/behaviors/ai_attack_default", function (cls) {
    cls.m.PossibleSkills.extend(["actives.lunge"]);
});

// Debug fatigue score mult
::mods_hookBaseClass("ai/tactical/behavior", function(cls) {
    while (!("getFatigueScoreMult" in cls)) cls = cls[cls.SuperName];

    // ai_adrenaline: "actives.adrenaline"
    // shieldwall: "actives.shieldwall", "actives.grow_shield"
    // ai_defend_rotation: "actives.rotation" "actives.barbarian_fury"
    // ai_defend_knock_back:
    //     "actives.knock_back", "actives.repel", "actives.hook", "actives.serpent_hook"
    // ai_attack_splitshield: "actives.split_shield"
    // ai_rally: "actives.rally_the_troops"
    // ai_disengage: "actives.footwork"
    local altWeights = {
        ai_adrenaline = 0.5
        ai_attack_splitshield = 0.7
        ai_defend_shieldwall = 0.8
        ai_defend_rotation = 0.7
        ai_defend_knock_back = 0.8
        ai_disengage = 0.7
        ai_rally = 0
    }

    local getFatigueScoreMult = cls.getFatigueScoreMult;
    cls.getFatigueScoreMult = function(_skill) {
        local entity = this.getAgent().getActor();
        if (!("_autopilot" in entity.m)) return getFatigueScoreMult(_skill);

        local mult = getFatigueScoreMult(_skill);
        if (!(this.ClassName in altWeights)) return mult;

        // Calculate alternative mult for some skills
        local apPct = _skill.getActionPointCost() / (entity.getActionPointsMax() * 1.0);
        local fatigue = this.Math.max(0, _skill.getFatigueCost() - entity.getCurrentProperties().FatigueRecoveryRate * entity.getCurrentProperties().FatigueRecoveryRateMult * apPct);
        local currentFatigue = entity.getFatigue();
        local maxFatigue = entity.getFatigueMax();

        logInfo("ap: FATIGUE Mult for " + entity.getName() + " " + _skill.getName());
        logInfo("ap: apPct=" + apPct + " fatigue=" + fatigue + " of " + currentFatigue + "/" + maxFatigue);

        // A negative weight will make idle used over this, i.e. save stamina
        // TODO: take into account absolute amount of fatigue left? opponents left?
        local alt = (1.0 * (maxFatigue - currentFatigue - fatigue) / maxFatigue - 0.5);
        local w = altWeights[this.ClassName];
        local mixed = w * alt + (1 - w) * mult;
        logInfo("ap: FATIGUE Mult = " + mult + " alt = " + alt + " mixed = " + mixed);
        return mixed;
    }
});
