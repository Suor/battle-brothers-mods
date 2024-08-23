// Add our behaviors
local function addBehavior(_id, _name, _order, _score) {
    if (_id in ::Const.AI.Behavior.ID) throw "Aleady have behavior with ID = " + _id;

    ::Const.AI.Behavior.ID[_id] <- ::Const.AI.Behavior.ID.COUNT;
    ::Const.AI.Behavior.ID.COUNT += 1;

    ::Const.AI.Behavior.Name.push(_name);
    ::Const.AI.Behavior.Order[_id] <- _order;
    ::Const.AI.Behavior.Score[_id] <- _score;
}
addBehavior("AP_UnbagNet", "UnbagNet", 35, 100);
addBehavior("AP_UnbagShield", "UnbagShield", 36, 400);

// Prefer doing something else than wandering around/waiting
::mods_hookExactClass("ai/tactical/behaviors/ai_engage_melee", function(cls) {
    while(!("evaluate" in cls)) cls = cls[cls.SuperName];

    local evaluate = cls.evaluate;
    cls.evaluate = function(_entity) {
        if (!("_autopilot" in _entity.m)) return evaluate(_entity);

        local done = evaluate(_entity);
        if (done && this.m.IsWaitingBeforeMove && _entity.getIdealRange() == 2) this.m.Score /= 5;
        return done;
    }
});

::mods_hookExactClass("ai/tactical/behaviors/ai_attack_default", function (cls) {
    cls.m.PossibleSkills.extend([
        "actives.lunge"
        // CleverFool's mod
        "actives.gae_buidhe_thrust"
        "actives.gae_dearg_thrust"
    ]);
});
::mods_hookExactClass("ai/tactical/behaviors/ai_attack_split", function (cls) {
    cls.m.PossibleSkills.extend([
        "actives.excalibur_split" // CleverFool's mod
    ]);
});
::mods_hookExactClass("ai/tactical/behaviors/ai_defend_rotation", function (cls) {
    cls.m.PossibleSkills.extend([
        "actives.spin" // Heroic Scenario Pack
    ]);
});

// Adjust fatigue score mult
::mods_hookBaseClass("ai/tactical/behavior", function(cls) {
    cls = cls.behavior;

    // Lower these behaviors scores more significantly with fatigue cost/left considerations
    local altWeights = {
        ai_adrenaline = 0.5
        ai_attack_splitshield = 0.7
        ai_defend_knock_back = 0.8
        ai_defend_rotation = 0.7
        ai_defend_shieldwall = 0.8
        ai_disengage = 0.3
        ai_rally = 0
        ai_line_breaker = 0.5
    }
    local getFatigueScoreMult = cls.getFatigueScoreMult;
    cls.getFatigueScoreMult = function(_skill) {
        local entity = this.getAgent().getActor();
        if (!("_autopilot" in entity.m)) return getFatigueScoreMult(_skill);

        local mult = getFatigueScoreMult(_skill);
        if (this.ClassName == "ai_disengage"
                && "_autopilot" in entity.m && entity.m._autopilot.ranged) return mult;
        if (!(this.ClassName in altWeights) || altWeights[this.ClassName] == 0) return mult;

        // Calculate alternative mult for some skills
        local apPct = _skill.getActionPointCost() / (entity.getActionPointsMax() * 1.0);
        local fatigue = this.Math.max(0, _skill.getFatigueCost() - entity.getCurrentProperties().FatigueRecoveryRate * entity.getCurrentProperties().FatigueRecoveryRateMult * apPct);
        local currentFatigue = entity.getFatigue();
        local maxFatigue = entity.getFatigueMax();

        // A negative weight will make idle used over this, i.e. save stamina
        // TODO: take into account absolute amount of fatigue left? opponents left?
        local alt = (1.0 * (maxFatigue - currentFatigue - fatigue) / maxFatigue - 0.5);
        local w = altWeights[this.ClassName];
        local mixed = w * alt + (1 - w) * mult;
        // logInfo("ap: FATIGUE Mult = " + mult + " alt = " + alt + " mixed = " + mixed);
        return mixed;
    }
})


// ::mods_hookExactClass("ai/tactical/behaviors/ai_engage_melee", function (cls) {
//     // local won't work
//     function debughook(event, file, line, func) {
//         if (event == 'l' && func == "onEvaluate") {
//             ::logInfo("LINE line [" + line + "] func [" + func + "] file ["+ file + "]");
//         }
//     }

//     local onEvaluate = cls.onEvaluate;
//     cls.onEvaluate = function( _entity ) {
//         local ret;
//         local gen = onEvaluate(_entity);
//         logInfo("DEBUG ON");

//         while (true) {
//             ::setdebughook(debughook);
//             ret = resume gen;
//             ::setdebughook(null);
//             // Proxy "results"
//             if (ret != null) return ret;
//             yield ret;
//         }
//     }
// });
