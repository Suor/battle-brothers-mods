local mod = ::Hooks.getMod("mod_autopilot_new");

local stdTile = {
    function iterAdjacent(_tile) {
        for (local i = 0; i < ::Const.Direction.COUNT; i++) {
            if (_tile.hasNextTile(i)) yield _tile.getNextTile(i);
        }
    }
    function iterAdjacentActors(_tile) {
        foreach (tile in this.iterAdjacent(_tile)) {
            if (tile.IsOccupiedByActor) yield tile.getEntity();
        }
    }
}
local function mapValues(_table, _func) {
    local res = {};
    foreach (k, v in _table) res[k] <- _func(k, v);
    return res;
}


// This makes AI prefer it more, original value is wrong
mod.hook("scripts/skills/actives/split_man", function (q) {
    q.getExpectedDamage = @(__original) function (_target) {
        return mapValues(__original(_target), @(_, v) v * 1.5);
    }
})
// skills/actives/deathblow_skill

mod.hook("scripts/ai/tactical/behaviors/ai_attack_default", function (q) {
    q.onEvaluate = @(__original) function (_entity) {
        // TODO: apply for our bros only unless conf is set
        // TODO: think about using it for subclasses
        if (this.ClassName != "ai_attack_default") return __original(_entity);

        this.m.TargetTile = null;
        this.m.Skill = null;
        local score = this.getProperties().BehaviorMult[this.m.ID];

        if (_entity.getActionPoints() < ::Const.Movement.AutoEndTurnBelowAP) {
            return ::Const.AI.Behavior.Score.Zero;
        }
        if (_entity.getMoraleState() == ::Const.MoraleState.Fleeing) {
            return ::Const.AI.Behavior.Score.Zero;
        }
        if (!this.getAgent().hasVisibleOpponent()) {
            return ::Const.AI.Behavior.Score.Zero;
        }

        // In vanilla code a skill is selected first and then target is selected.
        // This has several bad consequences:
        // 1. If skills has different ranges and skill with lower range is selected then an actor
        //    will just end turn even if father away enemies are hittable with some other skill.
        //    The most notable example is Swordstaff from Reforged.
        // 2. A chosen skill might be bad against all the targets.
        //
        // Here we score all the skills against all available targets and choose after. Also fix
        // some other bugs along the way.
        score *= this.selectBestTargetAndSkill(_entity);
        if (this.m.TargetTile == null || this.m.Skill == null) {
            return ::Const.AI.Behavior.Score.Zero;
        }

        // TODO: move it back to selectBestTargetAndSkill?
        score *= this.getFatigueScoreMult(this.m.Skill);

        if (this.getAgent().getIntentions().IsChangingWeapons) {
            score *= ::Const.AI.Behavior.AttackAfterSwitchWeaponMult;
        }

        return this.Math.max(0, this.Const.AI.Behavior.Score.Attack * score);
    }

    q.selectBestTargetAndSkill <- function (_entity) {
        local myTile = _entity.getTile();

        // TODO: fit skills into available AP
        local options = [];
        foreach (skillID in this.m.PossibleSkills) {
            local s = _entity.getSkills().getSkillByID(skillID);
            if (s == null || !s.isUsable() || !s.isAffordable()) continue;

            local targets = this.queryTargetsInMeleeRange(
                s.getMinRange(),
                s.getMaxRange() + (s.isRanged() ? myTile.Level : 0),
                s.getMaxLevelDifference(),
                myTile
            );
            // Debug.logRepr("skill=" + s.ClassName + " targets", targets);

            local best = s.isRanged() ? this.bad_queryBestRangedTarget(_entity, s, targets)
                                      : this.queryBestMeleeTarget(_entity, s, targets);
            if (best.Target == null) continue;

            best.Value <- this.queryTargetValue(_entity, best.Target, s);
            best.Hitchance <- s.getHitchance(best.Target);
            best.Damage <- s.getExpectedDamage(best.Target);
            best.Attract <- best.Target.getCurrentProperties().TargetAttractionMult;
            best.FatMult <- this.getFatigueScoreMult(s);
            // Debug.logRepr("best", best);

            options.push({target = best.Target, skill = s, score = best.Score});
        }
        if (options.len() == 0) return 0;

        // Debug.logRepr("options", options);

        // How we choose a skill is borrowed from ai_attack_bow, we do it for different options
        // though not for different skills inside target.
        local scores =  options.map(@(_r) _r.score)
        local weights = scores.map(@(_s) ::Math.pow(_s, ::Const.AI.Behavior.AttackRangedChancePOW));
        local cutoff = ::std.Array.max(weights) * ::Const.AI.Behavior.AttackRangedScoreCutoff;
        local choice = ::std.Rand.choice(options, weights.map(@(_w) _w < cutoff ? 0 : _w));
        // Debug.logRepr("choice", choice);

        this.m.TargetTile = choice.target.getTile();
        this.m.Skill = choice.skill;
        return choice.score;
        // return choice.skill.isRanged() ? ::Math.maxf(0.1, choice.score + ::std.Array.max(scores))
        //                                : choice.score;
    }
})

mod.hook("scripts/ai/tactical/behavior", function (q) {
    // q.queryBestRangedTarget = @(__original) function(_entity, _skill, _targets, _maxRange = 0) {
    //     local ret = __original(_entity, _skill, _targets, _maxRange);
    //     Debug.logRepr("original queryBestRangedTarget", {ret=ret, s=_skill, r=_maxRange});
    //     return ret;
    // }

    // Override this to fix "do not throw" other the shoulder bug and for more flexibility
    // q.queryBestRangedTarget = @() function(_entity, _skill, _targets, _maxRange = 0) {
    q.bad_queryBestRangedTarget <- function(_entity, _skill, _targets, _maxRange = 0) {
        local myTile = _entity.getTile();
        local best = {Score = -9000.0, Target = null};

        foreach (target in _targets) {
            local targetTile = target.getTile();

            if (_skill != null) {
                if (!_skill.isUsableOn(targetTile)) continue;
            }
            else if (!targetTile.IsVisibleForEntity
                     || myTile.getDistanceTo(targetTile)
                        > _maxRange + ::Math.max(0, myTile.Level - targetTile.Level)) {
                continue;
            }

            local score = this.scoreRangedTarget(_entity, target, _skill);
            if (score > best.Score) best = {Score = score, Target = target};
        }
        // Debug.logRepr("my queryBestRangedTarget", best);
        return best;
    }

    q.scoreRangedTarget <- function (_entity, _target, _skill) {
        // NOTE: using _skill.getAffectedTiles() and going through them the same way
        //       ai_attack_bow.selectBestTargetAndSkill() does will allow using this for AOE skills.
        //       Such skills will need to define .getAffectedTiles() though.
        local score = this.queryTargetValue(_entity, _target, _skill);

        local myTile = _entity.getTile();
        local targetTile = _target.getTile();

        // Adjust for blocked tiles. Note that blocked by enemy is ok.
        local blockedTiles = ::Const.Tactical.Common.getBlockedTiles(myTile, targetTile, _entity.getFaction());
        foreach (tile in blockedTiles) {
            if (!tile.IsOccupiedByActor || tile.getEntity().isAlliedWith(_entity)) {
                score *= ::Const.AI.Behavior.AttackLineOfFireBlockedMult;
                break;
            }
        }

        // Adjust for a missile diversion
        // NOTE: the vanilla queryBestRangedTarget() misses this > 2 cond so throwing guys are
        //       afraid of throwing stuff other an ally's shoulder.
        // TODO: take into account how diversions really work and hit chance,
        //       see skill.divertAttack() and .attackEntity()
        local alliesAdjacent = 0;
        if (myTile.getDistanceTo(targetTile) > 2) {
            foreach (actor in stdTile.iterAdjacentActors(targetTile)) {
                if (_entity.isAlliedWith(actor)) {
                    if (this.getProperties().TargetPriorityHittingAlliesMult < 1.0) {
                        // TODO: think about these coefficients
                        score -= 1.0 / 6.0 * 4.0 * (1.0 - this.getProperties().TargetPriorityHittingAlliesMult)
                                 * actor.getCurrentProperties().TargetAttractionMult;
                        alliesAdjacent++;
                    }
                }
                else {
                    score += 1.0 / 6.0 * this.queryTargetValue(_entity, actor, _skill)
                             * ::Const.AI.Behavior.AttackRangedHitBystandersMult;
                }
            }
        }
        // Do not need to recheck TargetPriorityHittingAlliesMult here
        if (alliesAdjacent > ::Const.AI.Behavior.AttackRangedMaxAlliesAdjacent) return 0.0;

        // This is an "afraid clause", only makes sense for fully ranged throwing actors
        // // Shoot targets blocked with less that 2 allies first
        // if (targetTile.getZoneOfControlCount(_entity.getFaction()) < ::Const.AI.Behavior.RangedEngageIgnoreDangerMinZones)
        // {
        //     score *= 1.0 + (1.0 - this.Math.minf(1.0, this.queryActorTurnsNearTarget(_target, myTile, _entity).Turns)) * ::Const.AI.Behavior.AttackDangerMult;
        // }

        return score;
    }
})
