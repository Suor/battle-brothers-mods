local mod = ::Hooks.getMod("mod_autopilot_new");

// Add our behaviors
::MSU.AI.addBehavior("AP_UnbagNet", "AP.UnbagNet", 35, 100);
::MSU.AI.addBehavior("AP_UnbagShield", "AP.UnbagShield", 36, 400);
::MSU.AI.addBehavior("AP_UnleashDog", "AP.UnleashDog", 37, 200);
::MSU.AI.addBehavior("AP_Tame", "AP.Tame", 38, 400);
::MSU.AI.addBehavior("AP_AttackAlternate", "AP.AttackAlternate",
    ::Const.AI.Behavior.Order.AttackDefault - 1, ::Const.AI.Behavior.Score.Attack * 2);

// Prefer doing something else than wandering around/waiting
mod.hook("scripts/ai/tactical/behaviors/ai_engage_melee", function (q) {
    q.evaluate = @(__original) function (_entity) {
        if (!("_autopilot" in _entity.m)) return __original(_entity);

        local done = __original(_entity);
        if (done && this.m.IsWaitingBeforeMove && _entity.getIdealRange() == 2) this.m.Score /= 5;
        return done;
    }
});

mod.hook("scripts/ai/tactical/behaviors/ai_attack_default", function (q) {
    q.m.PossibleSkills.extend([
        "actives.lunge"
        // CleverFool's mod
        "actives.gae_buidhe_thrust"
        "actives.gae_dearg_thrust"
        // Fantasy Brothers
        "actives.xxitem_leftsaa_skill" // Dual Attack
        "actives.sb_devablow_skill"
        // Looks like these are already added
        // "actives.xx_a" // Cut with Ring blade
        // "actives.xx_b" // Throw Ring blade
    ]);
    // Rifle shoot moved to ai_attack_bow
    local pos = q.m.PossibleSkills.find("actives.xxitem_rifleaa_skill");
    if (pos != null) q.m.PossibleSkills.remove(pos)
})
mod.hook("scripts/ai/tactical/behaviors/ai_attack_bow", function (q) {
    q.m.PossibleSkills.extend([
        // Fantasy Brothers
        "actives.xxitem_rifleaa_skill"
    ]);
})
mod.hook("scripts/ai/tactical/behaviors/ai_attack_handgonne", function (q) {
    q.m.PossibleSkills.extend([
        // Fantasy Brothers
        "actives.sb_fireball_skill"
    ])
})

mod.hook("scripts/ai/tactical/behaviors/ai_engage_ranged", function (q) {
    q.m.PossibleSkills.extend([
        // Fantasy Brothers
        "actives.xxitem_rifleaa_skill"
        "actives.xxitem_deadbookaa_skill"
    ]);
})

mod.hook("scripts/ai/tactical/behaviors/ai_attack_split", function (q) {
    q.m.PossibleSkills.extend([
        "actives.excalibur_split" // CleverFool's mod
    ]);
});
mod.hook("scripts/ai/tactical/behaviors/ai_defend_rotation", function (q) {
    q.m.PossibleSkills.extend([
        "actives.spin" // Heroic Scenario Pack
    ]);
});
mod.hook("scripts/ai/tactical/behaviors/ai_boost_stamina", function (q) {
    q.m.PossibleSkills.extend([
        "actives.nem_barbarian_drum" // North Expansion Mod
    ]);
});

// Adjust fatigue score mult
mod.hook("scripts/ai/tactical/behavior", function (q) {
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
        autopilot_tame = 0.5
    }
    q.getFatigueScoreMult = @(__original) function (_skill) {
        local entity = this.getAgent().getActor();
        if (!("_autopilot" in entity.m)) return __original(_skill);

        local mult = __original(_skill);
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
