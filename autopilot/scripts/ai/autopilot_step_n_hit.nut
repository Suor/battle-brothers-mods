// Step-and-hit: for autopilot 2-tile melee bros, find a destination tile within current AP
// budget that lets us attack a known opponent this turn, then move there and attack.
//
// Why this exists: ai_engage_melee:78-97 makes 2-tile bros wait every turn for any 1-tile ally
// with AP still to act, even when the bro could just step in and hit now. Rather than patching
// engage_melee, this behavior fires earlier with a real plan; engage_melee remains as the
// fallback for open-ended positioning.
//
// Guardrails (kept conservative):
//   - Never leave own ZoC (that's ai_disengage's job).
//   - Never step onto a tile in opponent ZoC.
//   - Activates only when current AP/fatigue covers both the step path and the attack.
//
// Logging is gated by ::Const.AI.VerboseMode (autopilot mod's "verbose" setting flips this on
// per autopilot bro). To debug "why didn't it fire", enable verbose and watch log.html.

this.autopilot_step_n_hit <- ::inherit("scripts/ai/tactical/behaviors/ai_attack_default", {
    m = {
        TargetTile = null,    // destination tile to step onto
        TargetActor = null,   // opponent to attack after the step
        Skill = null,         // attack skill chosen at evaluate time
        IsMoving = false
    },

    function create() {
        this.m.ID = ::Const.AI.Behavior.ID.AP_StepNHit;
        this.m.Order = ::Const.AI.Behavior.Order.AP_StepNHit;
        this.behavior.create();
    }

    function onTurnStarted() {
        this.m.TargetTile = null;
        this.m.TargetActor = null;
        this.m.Skill = null;
        this.m.IsMoving = false;
    }

    function snh_log(_entity, _msg) {
        if (::Const.AI.VerboseMode) this.logInfo("step_n_hit[" + _entity.getName() + "]: " + _msg);
    }
    function snh_bail(_entity, _reason) {
        this.snh_log(_entity, "skip: " + _reason);
        return ::Const.AI.Behavior.Score.Zero;
    }

    function onEvaluate(_entity) {
        this.m.TargetTile = null;
        this.m.TargetActor = null;
        this.m.Skill = null;
        this.m.IsMoving = false;

        // Silent skips for bros that aren't this behavior's audience — these fire on every roster
        // eval, no signal to log.
        if (_entity.m._autopilot.ranged) return ::Const.AI.Behavior.Score.Zero;
        if (_entity.getIdealRange() != 2) return ::Const.AI.Behavior.Score.Zero;

        if (!_entity.isArmedWithMeleeWeapon()) return this.snh_bail(_entity, "no melee weapon");
        if (_entity.getActionPoints() < ::Const.Movement.AutoEndTurnBelowAP) return this.snh_bail(_entity, "AP below auto-end threshold");
        if (!this.getAgent().hasKnownOpponent()) return this.snh_bail(_entity, "no known opponent");
        if (_entity.getMoraleState() == ::Const.MoraleState.Fleeing) return this.snh_bail(_entity, "fleeing");
        if (_entity.getCurrentProperties().IsRooted) return this.snh_bail(_entity, "rooted");

        local myTile = _entity.getTile();
        if (myTile.getZoneOfControlCountOtherThan(_entity.getAlliedFactions()) > 0) {
            return this.snh_bail(_entity, "in opponent ZoC (would AoO on leave)");
        }

        local skill = this.snh_pickAttackSkill(_entity);
        if (skill == null) return ::Const.AI.Behavior.Score.Zero;  // logged inside picker

        local apForAttack = skill.getActionPointCost();
        local fullAP = _entity.getActionPoints();
        local fullFat = _entity.getFatigueMax() - _entity.getFatigue();

        local navigator = this.Tactical.getNavigator();
        local settings = this.snh_buildSettings(_entity, navigator);
        local myDanger = this.snh_isTileInDanger(_entity, myTile);

        local candidates = [];
        local opponents = this.getAgent().getKnownOpponents();

        // Counters for diagnosis when no candidate is picked.
        local examined = 0, rejNotEmpty = 0, rejOccupied = 0, rejZoc = 0, rejSkillUsable = 0,
              rejDanger = 0, rejNoPath = 0, rejCostIncomplete = 0, rejWrongEnd = 0,
              rejOverBudget = 0, rejTargetValue = 0;

        foreach (op in opponents) {
            if (op.Actor == null || !::std.Actor.isAlive(op.Actor)) continue;
            local target = op.Actor;
            if (!target.isAttackable()) continue;
            local targetTile = target.getTile();
            if (!targetTile.IsVisibleForEntity) continue;

            // Stand-and-attack: current tile is a valid candidate when already in attack range.
            // Preserves height advantage / lets us choose between staying and stepping based on
            // tile quality rather than always moving.
            if (skill.isUsableOn(targetTile, myTile)) {
                local s = this.snh_scorePlan(_entity, target, skill, 0, myTile);
                if (s > 0) candidates.push({Tile = myTile, Target = target, Skill = skill, Score = s});
            }

            foreach (destTile in queryDestinationsInRange(targetTile, skill.getMinRange(), skill.getMaxRange())) {
                if (destTile.ID == myTile.ID) continue;
                examined++;

                if (!destTile.IsEmpty) { rejNotEmpty++; continue; }
                if (destTile.IsOccupiedByActor) { rejOccupied++; continue; }
                if (destTile.getZoneOfControlCountOtherThan(_entity.getAlliedFactions()) > 0) {
                    rejZoc++; continue;
                }
                if (!skill.isUsableOn(targetTile, destTile)) { rejSkillUsable++; continue; }
                if (!myDanger && this.snh_isTileInDanger(_entity, destTile)) {
                    rejDanger++; continue;
                }

                if (!navigator.findPath(myTile, destTile, settings, 0)) { rejNoPath++; continue; }
                local cost = navigator.getCostForPath(_entity, settings, fullAP, fullFat);
                if (!cost.IsComplete) { rejCostIncomplete++; continue; }
                if (cost.End.ID != destTile.ID) { rejWrongEnd++; continue; }
                // IsComplete just means a path exists; verify it leaves room for the attack.
                if (fullAP - cost.ActionPointsRequired < apForAttack) {
                    std.Debug.log("snh: movementCost", cost);
                    rejOverBudget++; continue; }
                // if (fullFat - cost.Tiles * maxFatPerTile < fatigueForAttack) { rejOverBudget++; continue; }

                local s = this.snh_scorePlan(_entity, target, skill, cost.ActionPointsRequired, destTile);
                if (s <= 0) { rejTargetValue++; continue; }

                candidates.push({Tile = destTile, Target = target, Skill = skill, Score = s});
            }
        }

        if (candidates.len() == 0) {
            this.snh_log(_entity, "no candidates (examined=" + examined
                + " rej notEmpty=" + rejNotEmpty + " occupied=" + rejOccupied
                + " zoc=" + rejZoc + " skillUsable=" + rejSkillUsable
                + " danger=" + rejDanger + " noPath=" + rejNoPath
                + " costIncomplete=" + rejCostIncomplete + " wrongEnd=" + rejWrongEnd
                + " overBudget=" + rejOverBudget + " targetValue=" + rejTargetValue
                + ") myDanger=" + myDanger + " skill=" + skill.getID()
                + " fullAP=" + fullAP + " fullFat=" + fullFat + " apForAttack=" + apForAttack);
            return ::Const.AI.Behavior.Score.Zero;
        }

        // Weighted-random pick (same shape as ai_attack_bow / better_attack_default), but with
        // a stronger pow so tile-quality differences (height, terrain effects) dominate.
        local pow = 5.0;
        local maxScore = candidates[0].Score;
        foreach (c in candidates) if (c.Score > maxScore) maxScore = c.Score;
        local threshold = maxScore * ::Const.AI.Behavior.AttackRangedScoreCutoff;
        local weights = candidates.map(@(c) c.Score < threshold ? 0 : ::Math.pow(c.Score, pow));
        local choice = ::std.Rand.choice(candidates, weights);

        this.m.TargetTile = choice.Tile;
        this.m.TargetActor = choice.Target;
        this.m.Skill = choice.Skill;

        local behaviorMult = this.getProperties().BehaviorMult[this.m.ID];
        local fatigueMult = this.getFatigueScoreMult(choice.Skill);
        local finalScore = ::Math.max(0, ::Const.AI.Behavior.Score.AP_StepNHit
                                          * choice.Score * behaviorMult * fatigueMult);
        this.snh_log(_entity, "picked dest=(" + choice.Tile.SquareCoords.X + ","
            + choice.Tile.SquareCoords.Y + ") target=" + choice.Target.getName()
            + " skill=" + choice.Skill.getID() + " innerScore=" + choice.Score
            + " mult(behavior=" + behaviorMult + " fatigue=" + fatigueMult
            + ") finalScore=" + finalScore
            + " candidates=" + candidates.len() + " maxInner=" + maxScore);
        return finalScore;
    }

    function onExecute(_entity) {
        local navigator = this.Tactical.getNavigator();

        if (this.m.IsFirstExecuted) {
            this.snh_log(_entity, "execute: target=("
                + this.m.TargetTile.SquareCoords.X + ","
                + this.m.TargetTile.SquareCoords.Y + ") attacking="
                + this.m.TargetActor.getName()
                + " ap=" + _entity.getActionPoints()
                + " fat=" + _entity.getFatigue() + "/" + _entity.getFatigueMax()
                + " skillAP=" + this.m.Skill.getActionPointCost()
                + " skillFat=" + this.m.Skill.getFatigueCost());
            this.getAgent().adjustCameraToTarget(this.m.TargetTile);

            this.m.IsFirstExecuted = false;
            if (this.m.TargetTile.ID == _entity.getTile().ID) {
                // Stand-and-attack - skip the movement phase.
                this.m.IsMoving = false;
                return false;
            }

            local settings = this.snh_buildSettings(_entity, navigator);
            if (!navigator.findPath(_entity.getTile(), this.m.TargetTile, settings, 0)) {
                this.logWarning("step_n_hit[" + _entity.getName()
                    + "]: failed to plan path, skipping");
                this.m.TargetTile = null;
                this.m.TargetActor = null;
                this.m.Skill = null;
                return true;
            }

            this.m.IsMoving = true;
            return false;
        }

        if (this.m.IsMoving) {
            if (!navigator.travel(_entity, _entity.getActionPoints(),
                    _entity.getFatigueMax() - _entity.getFatigue())) {
                this.snh_log(_entity, "execute: travel finished at ("
                    + _entity.getTile().SquareCoords.X + ","
                    + _entity.getTile().SquareCoords.Y + ")");
                this.m.IsMoving = false;
                return false;
            }
            return false;
        }

        local target = this.m.TargetActor;
        local skill = this.m.Skill;
        if (::std.Actor.isValidTarget(target) && skill != null
            && skill.isUsableOn(target.getTile()))
        {
            this.snh_log(_entity, "execute: attacking " + target.getName()
                + " with " + skill.getID());
            skill.use(target.getTile());
            this.getAgent().declareAction();
            if (skill.getDelay() != 0) {
                this.getAgent().declareEvaluationDelay(skill.getDelay());
            }
        }
        else {
            // We validated this would work at evaluate time, so a skip here is a bug — dump full
            // state so we can pin down where the prediction diverged from reality.
            local myTile = _entity.getTile();
            local tgtTile = target != null ? target.getTile() : null;
            this.logWarning("step_n_hit[" + _entity.getName()
                + "]: post-move skip attack (target.alive="
                + (target != null ? ::std.Actor.isAlive(target) : "null-target")
                + " skill=" + (skill != null ? skill.getID() : "null")
                + " affordable=" + (skill != null ? skill.isAffordable() : "n/a")
                + " usable=" + (skill != null && target != null
                    ? skill.isUsableOn(target.getTile()) : "n/a")
                + " ap=" + _entity.getActionPoints()
                + " skillAP=" + (skill != null ? skill.getActionPointCost() : "n/a")
                + " fat=" + _entity.getFatigue() + "/" + _entity.getFatigueMax()
                + " skillFat=" + (skill != null ? skill.getFatigueCost() : "n/a")
                + " myTile=(" + myTile.SquareCoords.X + "," + myTile.SquareCoords.Y + "@" + myTile.Level + ")"
                + " plannedTile=(" + this.m.TargetTile.SquareCoords.X + ","
                    + this.m.TargetTile.SquareCoords.Y + "@" + this.m.TargetTile.Level + ")"
                + " targetTile=" + (tgtTile != null
                    ? "(" + tgtTile.SquareCoords.X + "," + tgtTile.SquareCoords.Y + "@" + tgtTile.Level + ")"
                    : "null")
                + " dist=" + (tgtTile != null ? myTile.getDistanceTo(tgtTile) : "n/a")
                + ")");
        }

        this.m.TargetTile = null;
        this.m.TargetActor = null;
        this.m.Skill = null;
        return true;
    }

    function snh_scorePlan(_entity, _target, _skill, _apCost, _tile) {
        // Mirror vanilla engage_melee's tile preferences: high ground bonus / low ground penalty
        // Q: maybe revert mult to vanilla ones and just jack up weights pow to 10?
        local v = this.queryTargetValue(_entity, _target, _skill);
        if (v <= 0) return 0;
        local targetTile = _target.getTile();
        local s = v - _apCost * 0.05;
        s = _tile.Level - targetTile.Level > 0 ? s * 1.5 : s / 1.5;
        if (_tile.IsBadTerrain) s *= 0.6; // Q: EngageBadTerrainPenalty?
        // Fire / poison clouds / catapult-mark tiles - discourage drastically.
        // TODO: should follow EngageOnBadTerrainPenaltyMult, and maybe somehow
        //       Const.AI.Behavior.EngageBadTerrainEffectPenalty - but need to adjust for scale
        if (hasNegativeTileEffect(_tile, _entity) || _tile.Properties.IsMarkedForImpact) s *= 0.3;
        return s;
    }

    function snh_pickAttackSkill(_entity) {
        // Iterate the bro's actual skill container. Vanilla selectSkill walks ai_attack_default's
        // ID whitelist — that's O(60-ish) string lookups even though a bro usually has 1-2 weapon
        // attacks. We can do the right thing in O(skills.len) and own the filter so logging is
        // straightforward when nothing qualifies.
        //
        // Profile we accept: active, attack, weapon-skill, single-target, melee, reach ≥ 2,
        // currently usable + affordable. Special skills (Reap/Swing/Split/Lunge) usually fail
        // IsTargeted-only or have their own behaviors at higher Order — so they won't slip in.
        local candidates = [];
        foreach (s in _entity.getSkills().m.Skills) {
            if (s == null) continue;
            if (!s.m.IsActive) continue;
            if (!s.m.IsAttack) continue;
            if (!s.m.IsWeaponSkill) continue; // ?
            if (!s.m.IsTargeted) continue;
            if (s.m.IsRanged) continue;
            if (s.getMaxRange() < 2) continue;
            if (!s.isUsable()) continue;
            if (!s.isAffordable()) continue;
            candidates.push(s);
        }

        if (candidates.len() == 0) {
            this.snh_log(_entity, "no usable 2-reach melee attack");
            return null;
        }

        // TODO: this is a placeholder while we get the behavior running end-to-end. Proper choice
        // would be weighted random over candidates × (dest tile, target) tuples, scored by
        // expected damage / hit chance / target value (cf. better_attack_default.selectBestTargetAndSkill).
        // For now: cheapest AP first, fatigue as tiebreak — keeps the most budget for the step.
        candidates.sort(function (a, b) {
            local da = a.getActionPointCost() - b.getActionPointCost();
            if (da != 0) return da;
            return a.getFatigueCost() - b.getFatigueCost();
        });
        return candidates[0];
    }

    function snh_buildSettings(_entity, _navigator) {
        local s = _navigator.createSettings();
        s.ActionPointCosts = _entity.getActionPointCosts();
        s.FatigueCosts = _entity.getFatigueCosts();
        s.FatigueCostFactor = 1.0;
        s.ActionPointCostPerLevel = _entity.getLevelActionPointCost();
        s.FatigueCostPerLevel = _entity.getLevelFatigueCost();
        s.MaxLevelDifference = _entity.getMaxTraversibleLevels();
        s.AllowZoneOfControlPassing = false;
        s.ZoneOfControlCost = ::Const.AI.Behavior.ZoneOfControlAPPenalty;
        s.AlliedFactions = _entity.getAlliedFactions();
        s.Faction = _entity.getFaction();
        return s;
    }

    function snh_isTileInDanger(_entity, _tile) {
        local opponents = this.getAgent().getKnownOpponents();
        foreach (op in opponents) {
            local opp = op.Actor;
            if (!::std.Actor.isAlive(opp)) continue;
            if (opp.isNonCombatant()) continue;
            if (opp.getMoraleState() == ::Const.MoraleState.Fleeing) continue;
            if (opp.getCurrentProperties().IsStunned) continue;
            if (this.queryActorTurnsNearTarget(opp, _tile, _entity).TurnsWithAttack <= 1.0) {
                return true;
            }
        }
        return false;
    }
});
