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
    cls.m.PossibleSkills.extend(["actives.lunge"]);
});

// Adjust fatigue score mult
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
        ai_disengage = 0.3
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

        // A negative weight will make idle used over this, i.e. save stamina
        // TODO: take into account absolute amount of fatigue left? opponents left?
        local alt = (1.0 * (maxFatigue - currentFatigue - fatigue) / maxFatigue - 0.5);
        local w = altWeights[this.ClassName];
        local mixed = w * alt + (1 - w) * mult;
        // logInfo("ap: FATIGUE Mult = " + mult + " alt = " + alt + " mixed = " + mixed);
        return mixed;
    }
});


// ::mods_hookExactClass("ai/tactical/behaviors/ai_attack_default", function(cls) {
//     local onEvaluate = cls.onEvaluate;
//     cls.onEvaluate = function(_entity) {
//         this.m.TargetTile = null;
//         this.m.Skill = null;
//         local score = this.getProperties().BehaviorMult[this.m.ID];
//         logInfo("ai_attack_default: 1 " + score);

//         if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP)
//         {
//             return this.Const.AI.Behavior.Score.Zero;
//         }
//         logInfo("ai_attack_default: 2 " + score);

//         if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing)
//         {
//             return this.Const.AI.Behavior.Score.Zero;
//         }
//         logInfo("ai_attack_default: 3 " + score);

//         if (!this.getAgent().hasVisibleOpponent())
//         {
//             return this.Const.AI.Behavior.Score.Zero;
//         }
//         logInfo("ai_attack_default: 4 " + score);

//         this.m.Skill = this.selectSkill(this.m.PossibleSkills);

//         if (this.m.Skill == null)
//         {
//             return this.Const.AI.Behavior.Score.Zero;
//         }
//         logInfo("ai_attack_default: 5 " + score);

//         score = score * this.getFatigueScoreMult(this.m.Skill);
//         local myTile = _entity.getTile();
//         logInfo("ai_attack_default: 6 " + score);

//         local targets = this.queryTargetsInMeleeRange(this.m.Skill.getMinRange(), this.m.Skill.getMaxRange() + (this.m.Skill.isRanged() ? myTile.Level : 0), this.m.Skill.getMaxLevelDifference());
//         if (targets.len() == 0)
//         {
//             return this.Const.AI.Behavior.Score.Zero;
//         }
//         logInfo("ai_attack_default: 7 " + score);

//         local bestTarget;

//         if (this.m.Skill.isRanged())
//         {
//             bestTarget = this.queryBestRangedTarget(_entity, this.m.Skill, targets);
//         }
//         else
//         {
//             bestTarget = this.queryBestMeleeTarget(_entity, this.m.Skill, targets);
//         }

//         if (bestTarget.Target == null)
//         {
//             return this.Const.AI.Behavior.Score.Zero;
//         }
//         logInfo("ai_attack_default: 7.5 " + bestTarget.Score);
//         logInfo("ai_attack_default: 8 " + score);

//         if (this.getAgent().getIntentions().IsChangingWeapons)
//         {
//             score = score * this.Const.AI.Behavior.AttackAfterSwitchWeaponMult;
//         }
//         logInfo("ai_attack_default: 9 " + score);

//         this.m.TargetTile = bestTarget.Target.getTile();
//         logInfo("ai_attack_default: 10 " + this.Const.AI.Behavior.Score.Attack * bestTarget.Score * score);
//         return this.Math.max(0, this.Const.AI.Behavior.Score.Attack * bestTarget.Score * score);
//     }

//     local behavior = cls.behavior;
//     // local queryBestRangedTarget = behavior.queryBestRangedTarget;
//     behavior.queryBestRangedTarget = function(_entity, _skill, _targets, _maxRange = 0 )
//     {
//         local bestTarget;
//         local bestScore = -9000;
//         local myTile = _entity.getTile();
//         local ret = {
//             Score = 0.0,
//             Target = null
//         };

//         foreach( target in _targets )
//         {
//             local name = target.getName();
//             local mainhand = target.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
//             if (mainhand != null) name += " with " + mainhand.getName();
//             logInfo("queryRanged: 1 " + name);

//             local targetTile = target.getTile();

//             if (_skill != null)
//             {
//                 if (!_skill.isUsableOn(targetTile))
//                 {
//                     logInfo("queryRanged: 2 " + name + " not usable");
//                     continue;
//                 }
//             }
//             else if (!targetTile.IsVisibleForEntity || myTile.getDistanceTo(targetTile) > _maxRange + this.Math.max(0, myTile.Level - targetTile.Level))
//             {
//                 logInfo("queryRanged: 3 " + name + " out of range");
//                 continue;
//             }

//             local score = this.queryTargetValue(_entity, target, _skill);
//             local alliesAdjacent = 0;
//             local blockedTiles = this.Const.Tactical.Common.getBlockedTiles(myTile, targetTile, _entity.getFaction());
//             logInfo("queryRanged: 4 " + name + " score=" + score);

//             foreach( tile in blockedTiles )
//             {
//                 if (!tile.IsOccupiedByActor || tile.getEntity().isAlliedWith(_entity))
//                 {
//                     score = score * this.Const.AI.Behavior.AttackLineOfFireBlockedMult;
//                     logInfo("queryRanged: 4.5 " + name + " score=" + score
//                         + " scared of hitting " + tile.getEntity().getName());
//                     break;
//                 }
//             }
//             logInfo("queryRanged: 5 " + name + " score=" + score);

//             // Should be here:
//             // if (myTile.getDistanceTo(targetTile) > 2)

//             for( local i = 0; i < this.Const.Direction.COUNT; i = ++i )
//             {
//                 if (!targetTile.hasNextTile(i))
//                 {
//                 }
//                 else
//                 {
//                     local tile = targetTile.getNextTile(i);

//                     if (tile.IsEmpty)
//                     {
//                     }
//                     else if (tile.IsOccupiedByActor)
//                     {
//                         if (tile.getEntity().isAlliedWith(_entity))
//                         {
//                             if (this.getProperties().TargetPriorityHittingAlliesMult < 1.0)
//                             {
//                                 score = score - 1.0 / 6.0 * 4.0 * (1.0 - this.getProperties().TargetPriorityHittingAlliesMult);
//                                 logInfo("queryRanged: 5.5 " + name + " score=" + score
//                                     + " scared of hitting " + tile.getEntity().getName());
//                             }

//                             alliesAdjacent = ++alliesAdjacent;
//                         }
//                         else
//                         {
//                             score = score + 1.0 / 6.0 * this.queryTargetValue(_entity, tile.getEntity(), null) * this.Const.AI.Behavior.AttackRangedHitBystandersMult;
//                         }
//                     }
//                 }
//             }
//             logInfo("queryRanged: 6 " + name + " score=" + score);


//             if (this.getProperties().TargetPriorityHittingAlliesMult < 1.0 && alliesAdjacent > this.Const.AI.Behavior.AttackRangedMaxAlliesAdjacent)
//             {
//                 logInfo("queryRanged: 7 " + name + " score=" + score);
//                 continue;
//             }

//             if (score > bestScore)
//             {
//                 bestTarget = target;
//                 bestScore = score;
//             }
//         }

//         if (bestTarget != null)
//         {
//             ret.Score = bestScore;
//             ret.Target = bestTarget;
//         }

//         return ret;
//     }
// })
