local debug = false;
local mod = ::Hooks.getMod("mod_autopilot_new");
local Table = ::std.Table, Debug = ::std.Debug;

local function tileStr(_tile) {
    return _tile.X + ", " + _tile.Y;
}
local function corpseRepr(_corpse) {
    return Table.merge(_corpse, {Tile = tileStr(_corpse.Tile)})
}

mod.hook("scripts/ai/tactical/behaviors/ai_raise_undead", function (q) {
    q.m.PossibleSkills.extend([
        "actives.raise_companion" // AC
    ]);

    q.onEvaluate = @(__original) function (_entity) {
        // Function is a generator.
        this.m.Skill = null;
        this.m.TargetTile = null;
        this.m.IsTravelling = false;
        local time = this.Time.getExactTime();
        local scoreMult = this.getProperties().BehaviorMult[this.m.ID];
        if (debug) logInfo("raise: 1 " + scoreMult)

        if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP)
        {
            return this.Const.AI.Behavior.Score.Zero;
        }

        if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing)
        {
            return this.Const.AI.Behavior.Score.Zero;
        }
        if (debug) logInfo("raise: 1.2 " + scoreMult)

        local isPlayer = ::MSU.isKindOf(_entity, "player");
        local agent = _entity.getAIAgent();
        local hasMelee = agent.getProperties().BehaviorMult[::Const.AI.Behavior.ID.EngageMelee] > 0
                      && agent.findBehavior(::Const.AI.Behavior.ID.EngageMelee);
        local notAfraid = hasMelee && _entity.getIdealRange() == 1;
        local bigDanger = ::Const.AI.Behavior.RaiseUndeadMaxDanger * (notAfraid ? 2 : 1);
        local zocCount = _entity.getTile().getZoneOfControlCountOtherThan(_entity.getAlliedFactions());

        // Only player is allowed to do it when having enemy in ZOC
        if (!isPlayer && zocCount > 0) return this.Const.AI.Behavior.Score.Zero;
        if (debug) logInfo("raise: 1.3 " + scoreMult)

        this.m.Skill = this.selectSkill(this.m.PossibleSkills);

        if (this.m.Skill == null)
        {
            return this.Const.AI.Behavior.Score.Zero;
        }
        if (debug) logInfo("raise: 2 " + scoreMult)

        scoreMult = scoreMult * this.getFatigueScoreMult(this.m.Skill);
        local myTile = _entity.getTile();
        local potentialDanger = this.getPotentialDanger(true);
        local currentDanger = 0.0;
        yield null;
        if (debug) logInfo("raise: 3 " + scoreMult + " potentialDanger=" + potentialDanger)

        foreach( t in potentialDanger )
        {
            local d = this.queryActorTurnsNearTarget(t, myTile, _entity);

            if (d.Turns <= 1.0)
            {
                currentDanger = currentDanger + (1.0 - d.Turns);
            }
        }
        if (debug) logInfo("raise: 4 " + scoreMult + " currentDanger=" + currentDanger)

        yield null;
        local corpses = this.Tactical.Entities.getCorpses();

        if (corpses.len() == 0)
        {
            return this.Const.AI.Behavior.Score.Zero;
        }
        if (debug) logInfo("raise: 5 " + scoreMult + " corpses " + corpses.len())

        local potentialCorpses = [];
        local alliedFactions = _entity.getAlliedFactions();

        local n = 0;
        foreach( c in corpses )
        {
            n++;
            if (!c.IsEmpty)
            {
                continue;
            }

            if (!c.IsCorpseSpawned || !c.Properties.get("Corpse").IsResurrectable)
            {
                continue;
            }

            if (this.getAgent().getIntentions().IsDefendingPosition && !this.m.Skill.isInRange(c))
            {
                continue;
            }

            local score = 1.0;
            local dist = c.getDistanceTo(myTile);
            if (debug) logInfo("raise: P1 " + n + " score=" + score + " dist=" + dist)

            if (dist > this.Const.AI.Behavior.RaiseUndeadMaxDistance)
            {
                continue;
            }

            if (this.m.Skill.isInRange(c) && !this.m.Skill.onVerifyTarget(myTile, c))
            {
                continue;
            }
            if (debug) logInfo("raise: P2 " + n + " score=" + score)

            if (this.isAllottedTimeReached(time))
            {
                yield null;
                time = this.Time.getExactTime();
            }
            if (debug) logInfo("raise: P3 " + n + " score=" + score)

            // TODO: vary on weapon quality and armor
            local isWeaponOnGround = false;

            if (c.IsContainingItems)
            {
                foreach( item in c.Items )
                {
                    if (item.isItemType(this.Const.Items.ItemType.MeleeWeapon))
                    {
                        isWeaponOnGround = true;
                        break;
                    }
                }
            }

            score = score + c.Properties.get("Corpse").Value * this.Const.AI.Behavior.RaiseUndeadStrengthMult * (isWeaponOnGround ? 1.0 : this.Const.AI.Behavior.RaiseUndeadNoWeaponMult);
            if (debug) logInfo("raise: P4 " + n + " score=" + score)
            local mag = this.queryOpponentMagnitude(c, this.Const.AI.Behavior.RaiseUndeadMagnitudeMaxRange);
            score = score + mag.Opponents * (1.0 - mag.AverageDistanceScore) * this.Math.maxf(0.5, 1.0 - mag.AverageEngaged) * this.Const.AI.Behavior.RaiseUndeadOpponentValue;
            if (debug) logInfo("raise: P5 " + n + " score=" + score)
            if (debug) Debug.log("raise: mag", mag);

            if (c.hasZoneOfOccupationOtherThan(alliedFactions))
            {
                if (dist <= 2)
                {
                    score = score + this.Const.AI.Behavior.RaiseUndeadNearEnemyNearMeValue;
                    if (debug) logInfo("raise: P6 " + n + " score=" + score)
                }
                else
                {
                    score = score + this.Const.AI.Behavior.RaiseUndeadNearEnemyValue;
                    if (debug) logInfo("raise: P7 " + n + " score=" + score)
                }

                for( local i = 0; i != 6; i = ++i )
                {
                    if (!c.hasNextTile(i))
                    {
                    }
                    else
                    {
                        local tile = c.getNextTile(i);

                        if (tile.IsOccupiedByActor && !tile.hasZoneOfOccupationOtherThan(tile.getEntity().getAlliedFactions()))
                        {
                            if (dist <= 2)
                            {
                                score = score + this.Const.AI.Behavior.RaiseUndeadNearFreeEnemyNearMeValue;
                            }
                            else
                            {
                                score = score + this.Const.AI.Behavior.RaiseUndeadNearFreeEnemyValue;
                            }

                            if (tile.Properties.IsMarkedForImpact || this.hasNegativeTileEffect(tile, tile.getEntity()))
                            {
                                score = score + this.Const.AI.Behavior.RaiseUndeadLockIntoNegativeEffect;
                            }
                        }
                    }
                }
                if (debug) logInfo("raise: P8 " + n + " score=" + score)
            }

            if (currentDanger != 0)
            {
                score = score - dist * this.Const.AI.Behavior.RaiseUndeadDistToMeValue;
            }
            if (debug) logInfo("raise: P9 " + n + " score=" + score)

            potentialCorpses.push({
                Tile = c,
                Distance = dist,
                Score = score
            });
        }
        if (debug) logInfo("raise: 6 " + scoreMult + " potentialCorpses " + potentialCorpses.len())

        if (potentialCorpses.len() == 0)
        {
            return this.Const.AI.Behavior.Score.Zero;
        }
        if (debug) logInfo("raise: 7 " + scoreMult)

        potentialCorpses.sort(this.onSortByScore);
        if (debug) Debug.log("potentialCorpses", potentialCorpses.map(corpseRepr))
        local navigator = this.Tactical.getNavigator();
        local bestTarget;
        local bestIntermediateTile;
        local bestCost = -9999;
        // local bestTiles = 0;
        local n = 0;
        local necroAP = _entity.getActionPoints();
        local skillAP = this.m.Skill.getActionPointCost();
        local maxRange = this.m.Skill.getMaxRange();
        local entityActionPointCosts = _entity.getActionPointCosts();
        local entityFatigueCosts = _entity.getFatigueCosts();


        foreach( t in potentialCorpses )
        {
            n = ++n;
            if (debug) logInfo("raise: C" + n + " 1 " + Debug.pp(corpseRepr(t)))

            if (n > this.Const.AI.Behavior.RaiseUndeadMaxAttempts && bestTarget != null)
            {
                break;
            }

            if (debug) logInfo("raise: C" + n + " 1.5")
            if (this.isAllottedTimeReached(time))
            {
                yield null;
                time = this.Time.getExactTime();
            }

            local score = 0 + t.Score;
            local tiles = 0;
            local intermediateTile;
            if (debug) logInfo("raise: C" + n + " 2 score=" + score)

            if (!this.m.Skill.isInRange(t.Tile))
            {
                if (debug) logInfo("raise: C" + n + " 3 !inrange score=" + score)

                local settings = navigator.createSettings();
                settings.ActionPointCosts = entityActionPointCosts;
                settings.FatigueCosts = entityFatigueCosts;
                settings.FatigueCostFactor = 0.0;
                settings.ActionPointCostPerLevel = _entity.getLevelActionPointCost();
                settings.FatigueCostPerLevel = _entity.getLevelFatigueCost();
                settings.AllowZoneOfControlPassing = false;
                settings.ZoneOfControlCost = this.Const.AI.Behavior.ZoneOfControlAPPenalty;
                settings.AlliedFactions = _entity.getAlliedFactions();
                settings.Faction = _entity.getFaction();

                if (!_entity.getCurrentProperties().IsRooted && navigator.findPath(myTile, t.Tile, settings, maxRange))
                {
                    if (debug) logInfo("raise: C" + n + " 4 findPath score=" + score)

                    local movementCosts = navigator.getCostForPath(_entity, settings, necroAP, _entity.getFatigueMax() - _entity.getFatigue());

                    if (movementCosts.End.hasZoneOfControlOtherThan(_entity.getAlliedFactions())) {
                        continue;
                    }

                    if (movementCosts.IsComplete && !this.m.Skill.onVerifyTarget(movementCosts.End, t.Tile)) {
                        continue;
                    }
                    if (debug) logInfo("raise: C" + n + " 5 score=" + score + " moveTo=" + tileStr(movementCosts.End));
                    if (debug) Debug.log("movementCosts", movementCosts);

                    if (!movementCosts.IsComplete)
                    {
                        intermediateTile = movementCosts.End;
                    }

                    // If we loose ability to raise twice this turn
                    if (movementCosts.IsComplete
                            && necroAP >= skillAP * 2
                            && necroAP - movementCosts.ActionPointsRequired < skillAP * 2
                            && potentialCorpses.len() >= 2) {
                        score -= 10;
                    }
                    // Cannot do it this turn
                    if (!movementCosts.IsComplete
                            || necroAP - movementCosts.ActionPointsRequired < skillAP) {
                        score -= 20;
                    }

                    if (movementCosts.End.IsBadTerrain)
                    {
                        score = score - this.Const.AI.Behavior.RaiseUndeadMoveToBadTerrainPenalty * this.getProperties().EngageOnBadTerrainPenaltyMult;
                    }
                    if (debug) logInfo("raise: C" + n + " 6 score=" + score)

                    if (this.getProperties().EngageOnBadTerrainPenaltyMult != 0.0)
                    {
                        score = score - movementCosts.End.TVLevelDisadvantage;
                    }
                    if (debug) logInfo("raise: C" + n + " 7 score=" + score)

                    score = score - movementCosts.ActionPointsRequired;
                    if (debug) logInfo("raise: C" + n + " 8 score=" + score)
                    score = score + movementCosts.End.Level;
                    if (debug) logInfo("raise: C" + n + " 9 score=" + score)
                    local inAllyZOC = t.Tile.getZoneOfControlCount(_entity.getFaction());
                    score = score + inAllyZOC * this.Const.AI.Behavior.RaiseUndeadAllyZocBonus;
                    if (debug) logInfo("raise: C" + n + " 10 score=" + score)

                    score -= zocCount * 8;
                    if (debug) logInfo("raise: C" + n + " 10a score=" + score)

                    // Score will go only down from here, so can short-circuit
                    if (score <= bestCost) continue;

                    local danger = 0.0;

                    foreach( opponent in potentialDanger )
                    {
                        if (debug) logInfo("raise: C" + n + "op 11 danger=" + danger + " opp=" + opponent.getName())
                        if (this.isAllottedTimeReached(time))
                        {
                            yield null;
                            time = this.Time.getExactTime();
                        }
                        if (debug) logInfo("raise: C" + n + "op 12 danger=" + danger)

                        if (!this.isRangedUnit(opponent))
                        {
                            if (debug) logInfo("raise: C" + n + "op 13 danger=" + danger)

                            local d = this.queryActorTurnsNearTarget(opponent, movementCosts.End, _entity);
                            danger = danger + this.Math.maxf(0.0, 1.0 - d.Turns);
                            if (debug) logInfo("raise: C" + n + "op 13 danger=" + danger)
                            if (debug) Debug.log("d", d);

                            if (d.Turns <= 1.0)
                            {
                                if (d.InZonesOfControl != 0 || opponent.getCurrentProperties().IsRooted)
                                {
                                    score = score - this.Const.AI.Behavior.RaiseUndeadLowDangerPenalty;
                                }
                                else
                                {
                                    score = score - this.Const.AI.Behavior.RaiseUndeadHighDangerPenalty;
                                }
                            }
                            if (debug) logInfo("raise: C" + n + "op 14 score=" + score)
                        }
                        else if (!opponent.getTile().hasZoneOfControlOtherThan(opponent.getAlliedFactions()) && opponent.getTile().getDistanceTo(movementCosts.End) <= opponent.getIdealRange())
                        {
                            // TODO: consider ranged def and opponent ranged skill
                            local alliesOnEnd = movementCosts.End.getZoneOfControlCount(_entity.getFaction());
                            local d = alliesOnEnd > 0 ? 0.5 : 1.0;
                            danger = danger + d;

                            if (debug) logInfo("raise: C" + n + "op 15 danger=" + danger)
                            if (alliesOnEnd == 0)
                            {
                                score = score - this.Const.AI.Behavior.RaiseUndeadHighDangerPenalty;
                            }
                            else
                            {
                                score = score - this.Const.AI.Behavior.RaiseUndeadLowDangerPenalty;
                            }
                            if (debug) logInfo("raise: C" + n + "op 16 score=" + score)
                        }

                        if (debug) logInfo("raise: C" + n + "op 17 score=" + score + " danger=" + danger)
                        if (danger >= bigDanger)
                        {
                            score = -9999;
                            break;
                        }
                        if (debug) logInfo("raise: C" + n + "op 18 score=" + score)
                    }

                    if (debug) logInfo("raise: C" + n + "op 20 score=" + score)
                }
                else
                {
                    continue;
                }
            }
            else
            {
                if (debug) logInfo("raise: C" + n + "op 21 score=" + score)
                if (!isPlayer && currentDanger >= bigDanger) break;
                if (debug) logInfo("raise: C" + n + "op 22 score=" + score)

                if (!this.m.Skill.onVerifyTarget(myTile, t.Tile)) continue;

                if (currentDanger >= bigDanger)
                    score /= t.Distance * t.Distance * 0.5;

                score = score + myTile.Level;
                if (debug) logInfo("raise: C" + n + "op 23 score=" + score)
            }

            if (score > bestCost)
            {
                bestTarget = t.Tile;
                bestCost = score;
                bestIntermediateTile = intermediateTile;
            }
        }
        if (debug) Debug.log("raise: 8",
            {bestTarget=bestTarget, bestCost=bestCost,
             bestIntermediateTile=bestIntermediateTile}, 2);

        if (bestTarget == null)
        {
            return this.Const.AI.Behavior.Score.Zero;
        }
        if (debug) logInfo("raise: 9 " + scoreMult)

        this.m.TargetTile = bestTarget;
        this.m.IsTravelling = !this.m.Skill.isInRange(this.m.TargetTile);

        if (this.m.IsTravelling && bestIntermediateTile != null && bestIntermediateTile.ID == myTile.ID)
        {
            if (debug) logInfo("raise: 9.5 intermediateTile=" + tileStr(bestIntermediateTile) + " myTile=" + tileStr(myTile))
            return this.Const.AI.Behavior.Score.Zero;
        }
        if (debug) logInfo("raise: 10 " + scoreMult)

        if (isPlayer) scoreMult *= ::Math.pow(2, bestCost / 10.0);
        else scoreMult *= 1.0 + bestTarget.Properties.get("Corpse").Value / 25.0;
        if (debug) logInfo("raise: 11 " + scoreMult)
        if (!isPlayer) scoreMult *= ::Math.maxf(0.0, 1.0 - currentDanger / bigDanger);
        if (debug) logInfo("raise: 12 " + scoreMult)
        return ::Const.AI.Behavior.Score.RaiseUndead * scoreMult;
    }
})
