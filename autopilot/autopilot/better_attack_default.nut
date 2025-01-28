local mod = ::Hooks.getMod("mod_autopilot_new");

// This makes AI prefer it more, original value is wrong
mod.hook("scripts/skills/actives/split_man", function (q) {
    q.getExpectedDamage = @(__original) function (_target) {
        return ::std.Table.mapValues(__original(_target), @(_, v) v * 1.5);
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

        if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP) {
            return this.Const.AI.Behavior.Score.Zero;
        }
        if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing) {
            return this.Const.AI.Behavior.Score.Zero;
        }
        if (!this.getAgent().hasVisibleOpponent()) {
            return this.Const.AI.Behavior.Score.Zero;
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
            return this.Const.AI.Behavior.Score.Zero;
        }

        if (this.getAgent().getIntentions().IsChangingWeapons) {
            score *= this.Const.AI.Behavior.AttackAfterSwitchWeaponMult;
        }

        return this.Math.max(0, this.Const.AI.Behavior.Score.Attack * score);
    }

    q.selectBestTargetAndSkill <- function (_entity) {
        local myTile = _entity.getTile();
        local skillFatMults = {}, minRange = 999, maxRange = 0;

        // TODO: fit skills into available AP
        foreach (skillID in this.m.PossibleSkills) {
            local s = _entity.getSkills().getSkillByID(skillID);
            if (s == null || !s.isUsable() || !s.isAffordable()) continue;

            skillFatMults[s] <- this.getFatigueScoreMult(s);
            minRange = Math.min(minRange, s.getMinRange());
            maxRange = Math.max(maxRange, s.getMaxRange() + (s.isRanged() ? myTile.Level : 0));
        }
        if (skillFatMults.len() == 0) return 0;

        local targets = this.queryTargetsInMeleeRange(minRange, maxRange, 4, myTile);
        if (targets.len() == 0) return 0;

        local best = {score = -9000.0, target = null, skills = [], scores = []};
        foreach (target in targets) {
            if (!::std.Actor.isValidTarget(target)) continue;

            local targetTile = target.getTile();

            local skills = [], scores = [];
            foreach (s, fatScoreMult in skillFatMults) {
                if (!s.isInRange(targetTile) || !s.onVerifyTarget(myTile, targetTile)) continue;

                local score = this.scoreTargetAndSkill(_entity, target, s);
                score *= fatScoreMult; // NOTE: this doesn't affect choice in ai_attack_bow
                if (score > 0) {
                    skills.push(s); scores.push(score);
                }
            }
            local targetScore = ::std.Array.max(scores);
            if (targetScore && targetScore > best.score)
                best = {score = targetScore, target = target, skills = skills, scores = scores};
        }

        if (best.score > 0) {
            this.m.TargetTile = best.target.getTile();
            this.m.Skill = ::std.Rand.choice(best.skills, best.scores.map(function (_score) {
                if (_score < best.score * ::Const.AI.Behavior.AttackRangedScoreCutoff) return 0;
                return ::Math.pow(_score, ::Const.AI.Behavior.AttackRangedChancePOW);
            }));
            return best.score;
        }
        return 0.0;
    }

    q.scoreTargetAndSkill <- function (_entity, target, skill) {
        local alliesAdjacent = 0;
        local score = 0.0;

        local targetTile = target.getTile();

        // NOTE: this will always be just [targetTile] for now, which doesn't matter though since
        //       AOE skills have their own behaviors.
        // TODO: use this func to make safe/boring AOEs
        local tilesAffected = skill.getAffectedTiles(targetTile);
        foreach (tile in tilesAffected) {
            if (!tile.IsOccupiedByActor) continue;

            if (_entity.isAlliedWith(tile.getEntity())) {
                if (this.getProperties().TargetPriorityHittingAlliesMult < 1.0) {
                    // TODO: think about these coefficients
                    score -= 1.0 / 6.0 * 4.0 * (1.0 - this.getProperties().TargetPriorityHittingAlliesMult)
                    * tile.getEntity().getCurrentProperties().TargetAttractionMult;
                }
            }
            else {
                score += this.queryTargetValue(_entity, tile.getEntity(), skill);
            }
        }

        if (!skill.isRanged()) return score;

        local myTile = _entity.getTile();

        // Adjust for blocked tiles. Note that blocked by enemy is ok.
        local blockedTiles = this.Const.Tactical.Common.getBlockedTiles(myTile, targetTile, _entity.getFaction());
        foreach (tile in blockedTiles) {
            if (!tile.IsOccupiedByActor || tile.getEntity().isAlliedWith(_entity)) {
                score *= this.Const.AI.Behavior.AttackLineOfFireBlockedMult;
                break;
            }
        }

        // Adjust for a missile diversion
        // NOTE: the vanilla behavior.queryBestRangedTarget() misses this if so throwing guys are
        //       afraid of throwing stuff other the ally's shoulder.
        // TODO: take into account how diversions really work and hit chance,
        //       see skill.divertAttack() and .attackEntity()
        if (myTile.getDistanceTo(targetTile) > 2) {
            // TODO: actors around iter?
            for (local i = 0; i < this.Const.Direction.COUNT; i = ++i) {
                if (!targetTile.hasNextTile(i)) continue;

                local tile = targetTile.getNextTile(i);
                if (!tile.IsOccupiedByActor) continue;

                if (_entity.isAlliedWith(tile.getEntity())) {
                    if (this.getProperties().TargetPriorityHittingAlliesMult < 1.0) {
                        // TODO: think about these coefficients
                        score -= 1.0 / 6.0 * 4.0 * (1.0 - this.getProperties().TargetPriorityHittingAlliesMult) * tile.getEntity().getCurrentProperties().TargetAttractionMult;
                        alliesAdjacent = ++alliesAdjacent;
                    }
                }
                else {
                    score += 1.0 / 6.0 * this.queryTargetValue(_entity, tile.getEntity(), skill) * this.Const.AI.Behavior.AttackRangedHitBystandersMult;
                }
            }
        }
        if (alliesAdjacent > Const.AI.Behavior.AttackRangedMaxAlliesAdjacent) return 0.0;

        // Shoot targets blocked with less that 2 allies first
        if (targetTile.getZoneOfControlCount(_entity.getFaction()) < this.Const.AI.Behavior.RangedEngageIgnoreDangerMinZones)
        {
            score *= 1.0 + (1.0 - this.Math.minf(1.0, this.queryActorTurnsNearTarget(target, myTile, _entity).Turns)) * this.Const.AI.Behavior.AttackDangerMult;
        }

        return score;
    }
})
