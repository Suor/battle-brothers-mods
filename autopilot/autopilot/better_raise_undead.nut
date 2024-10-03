// local Table = ::std.Table, Debug = ::std.Debug;

local function tileStr(_tile) {
    return _tile.X + ", " + _tile.Y;
}
local function corpseRepr(_corpse) {
    return Table.merge(_corpse, {Tile = tileStr(_corpse.Tile)})
}

::mods_hookExactClass("ai/tactical/behaviors/ai_raise_undead", function (cls) {
    cls.onEvaluate = function (_entity)
    {
        // Function is a generator.
        this.m.Skill = null;
        this.m.TargetTile = null;
        this.m.IsTravelling = false;
        local time = this.Time.getExactTime();
        local scoreMult = this.getProperties().BehaviorMult[this.m.ID];
        // logInfo("raise: 1 " + scoreMult)

        if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP)
        {
            return this.Const.AI.Behavior.Score.Zero;
        }

        if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing)
        {
            return this.Const.AI.Behavior.Score.Zero;
        }

        if (_entity.getTile().hasZoneOfControlOtherThan(_entity.getAlliedFactions()))
        {
            return this.Const.AI.Behavior.Score.Zero;
        }

        this.m.Skill = this.selectSkill(this.m.PossibleSkills);

        if (this.m.Skill == null)
        {
            return this.Const.AI.Behavior.Score.Zero;
        }
        // logInfo("raise: 2 " + scoreMult)

        scoreMult = scoreMult * this.getFatigueScoreMult(this.m.Skill);
        local myTile = _entity.getTile();
        local potentialDanger = this.getPotentialDanger(true);
        local currentDanger = 0.0;
        yield null;
        // logInfo("raise: 3 " + scoreMult + " potentialDanger=" + potentialDanger)

        foreach( t in potentialDanger )
        {
            local d = this.queryActorTurnsNearTarget(t, myTile, _entity);

            if (d.Turns <= 1.0)
            {
                currentDanger = currentDanger + (1.0 - d.Turns);
            }
        }
        // logInfo("raise: 4 " + scoreMult + " currentDanger=" + currentDanger)

        yield null;
        local corpses = this.Tactical.Entities.getCorpses();

        if (corpses.len() == 0)
        {
            return this.Const.AI.Behavior.Score.Zero;
        }
        // logInfo("raise: 5 " + scoreMult + " corpses " + corpses.len())

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
            // logInfo("raise: P1 " + n + " score=" + score + " dist=" + dist)

            if (dist > this.Const.AI.Behavior.RaiseUndeadMaxDistance)
            {
                continue;
            }

            if (this.m.Skill.isInRange(c) && !this.m.Skill.onVerifyTarget(myTile, c))
            {
                continue;
            }
            // logInfo("raise: P2 " + n + " score=" + score)

            if (this.isAllottedTimeReached(time))
            {
                yield null;
                time = this.Time.getExactTime();
            }
            // logInfo("raise: P3 " + n + " score=" + score)

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
            // logInfo("raise: P4 " + n + " score=" + score)
            local mag = this.queryOpponentMagnitude(c, this.Const.AI.Behavior.RaiseUndeadMagnitudeMaxRange);
            score = score + mag.Opponents * (1.0 - mag.AverageDistanceScore) * this.Math.maxf(0.5, 1.0 - mag.AverageEngaged) * this.Const.AI.Behavior.RaiseUndeadOpponentValue;
            // logInfo("raise: P5 " + n + " score=" + score)
            // Debug.log("raise: mag", mag);

            if (c.hasZoneOfOccupationOtherThan(alliedFactions))
            {
                if (dist <= 2)
                {
                    score = score + this.Const.AI.Behavior.RaiseUndeadNearEnemyNearMeValue;
                    // logInfo("raise: P6 " + n + " score=" + score)
                }
                else
                {
                    score = score + this.Const.AI.Behavior.RaiseUndeadNearEnemyValue;
                    // logInfo("raise: P7 " + n + " score=" + score)
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
                // logInfo("raise: P8 " + n + " score=" + score)
            }

            if (currentDanger != 0)
            {
                score = score - dist * this.Const.AI.Behavior.RaiseUndeadDistToMeValue;
            }
            // logInfo("raise: P9 " + n + " score=" + score)

            potentialCorpses.push({
                Tile = c,
                Distance = dist,
                Score = score
            });
        }
        // logInfo("raise: 6 " + scoreMult + " potentialCorpses " + potentialCorpses.len())

        if (potentialCorpses.len() == 0)
        {
            return this.Const.AI.Behavior.Score.Zero;
        }
        // logInfo("raise: 7 " + scoreMult)

        potentialCorpses.sort(this.onSortByScore);
        // Debug.log("potentialCorpses", potentialCorpses.map(corpseRepr))
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
            // logInfo("raise: C" + n + " 1 " + Debug.pp(corpseRepr(t)))

            if (n > this.Const.AI.Behavior.RaiseUndeadMaxAttempts && bestTarget != null)
            {
                break;
            }

            // logInfo("raise: C" + n + " 1.5")
            if (this.isAllottedTimeReached(time))
            {
                yield null;
                time = this.Time.getExactTime();
            }

            local score = 0 + t.Score;
            local tiles = 0;
            local intermediateTile;
            // logInfo("raise: C" + n + " 2 score=" + score)

            if (!this.m.Skill.isInRange(t.Tile))
            {
                // logInfo("raise: C" + n + " 3 !inrange score=" + score)

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
                    // logInfo("raise: C" + n + " 4 findPath score=" + score)

                    local movementCosts = navigator.getCostForPath(_entity, settings, necroAP, _entity.getFatigueMax() - _entity.getFatigue());

                    if (movementCosts.End.hasZoneOfControlOtherThan(_entity.getAlliedFactions())) {
                        continue;
                    }

                    if (movementCosts.IsComplete && !this.m.Skill.onVerifyTarget(movementCosts.End, t.Tile)) {
                        continue;
                    }
                    // logInfo("raise: C" + n + " 5 score=" + score + " moveTo=" + tileStr(movementCosts.End));
                    // Debug.log("movementCosts", movementCosts);

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
                    // logInfo("raise: C" + n + " 6 score=" + score)

                    if (this.getProperties().EngageOnBadTerrainPenaltyMult != 0.0)
                    {
                        score = score - movementCosts.End.TVLevelDisadvantage;
                    }
                    // logInfo("raise: C" + n + " 7 score=" + score)

                    score = score - movementCosts.ActionPointsRequired;
                    // logInfo("raise: C" + n + " 8 score=" + score)
                    score = score + movementCosts.End.Level;
                    // logInfo("raise: C" + n + " 9 score=" + score)
                    local inAllyZOC = t.Tile.getZoneOfControlCount(_entity.getFaction());
                    score = score + inAllyZOC * this.Const.AI.Behavior.RaiseUndeadAllyZocBonus;
                    // logInfo("raise: C" + n + " 10 score=" + score)

                    // Score will go only down from here, so can short-circuit
                    if (score <= bestCost) continue;

                    local danger = 0.0;
                    local danger_intermediate = 0.0;

                    foreach( opponent in potentialDanger )
                    {
                        // logInfo("raise: C" + n + "op 11 danger=" + danger + " opp=" + opponent.getName())
                        if (this.isAllottedTimeReached(time))
                        {
                            yield null;
                            time = this.Time.getExactTime();
                        }
                        // logInfo("raise: C" + n + "op 12 danger=" + danger)

                        if (!this.isRangedUnit(opponent))
                        {
                            logInfo("raise: C" + n + "op 13 danger=" + danger)

                            local d = this.queryActorTurnsNearTarget(opponent, movementCosts.End, _entity);
                            danger = danger + this.Math.maxf(0.0, 1.0 - d.Turns);
                            // logInfo("raise: C" + n + "op 13 danger=" + danger)
                            // ::std.Debug.log("d", d);

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
                            // logInfo("raise: C" + n + "op 14 score=" + score)
                        }
                        else if (!opponent.getTile().hasZoneOfControlOtherThan(opponent.getAlliedFactions()) && opponent.getTile().getDistanceTo(movementCosts.End) <= opponent.getIdealRange())
                        {
                            // TODO: consider ranged def and opponent ranged skill
                            local alliesOnEnd = movementCosts.End.getZoneOfControlCount(_entity.getFaction());
                            local d = alliesOnEnd > 0 ? 0.5 : 1.0;
                            danger = danger + d;

                            // logInfo("raise: C" + n + "op 15 danger=" + danger)
                            if (alliesOnEnd == 0)
                            {
                                score = score - this.Const.AI.Behavior.RaiseUndeadHighDangerPenalty;
                            }
                            else
                            {
                                score = score - this.Const.AI.Behavior.RaiseUndeadLowDangerPenalty;
                            }
                            // logInfo("raise: C" + n + "op 16 score=" + score)
                        }

                        // logInfo("raise: C" + n + "op 17 score=" + score + " danger=" + danger + " danger_intermediate="+danger_intermediate)
                        if (danger >= this.Const.AI.Behavior.RaiseUndeadMaxDanger || danger_intermediate >= this.Const.AI.Behavior.RaiseUndeadMaxDanger)
                        {
                            score = -9999;
                            break;
                        }
                        // logInfo("raise: C" + n + "op 18 score=" + score)
                    }

                    // logInfo("raise: C" + n + "op 20 score=" + score)
                }
                else
                {
                    continue;
                }
            }
            else
            {
                // logInfo("raise: C" + n + "op 21 score=" + score)
                if (currentDanger >= this.Const.AI.Behavior.RaiseUndeadMaxDanger) break;
                // logInfo("raise: C" + n + "op 22 score=" + score)

                if (!this.m.Skill.onVerifyTarget(myTile, t.Tile))
                {
                    continue;
                }

                score = score + myTile.Level;
                // logInfo("raise: C" + n + "op 23 score=" + score)
            }

            if (score > bestCost)
            {
                bestTarget = t.Tile;
                bestCost = score;
                // bestTiles = tiles;
                bestIntermediateTile = intermediateTile;
            }
        }
        // ::std.Debug.log("raise: 8",
        //     {bestTarget=bestTarget, bestCost=bestCost,
        //      bestIntermediateTile=bestIntermediateTile}, 2);

        if (bestTarget == null)
        {
            return this.Const.AI.Behavior.Score.Zero;
        }
        // logInfo("raise: 9 " + scoreMult)

        this.m.TargetTile = bestTarget;
        this.m.IsTravelling = !this.m.Skill.isInRange(this.m.TargetTile);

        if (this.m.IsTravelling && bestIntermediateTile != null && bestIntermediateTile.ID == myTile.ID)
        {
            // logInfo("raise: 9.5 intermediateTile=" + tileStr(bestIntermediateTile) + " myTile=" + tileStr(myTile))
            return this.Const.AI.Behavior.Score.Zero;
        }
        // logInfo("raise: 10 " + scoreMult)

        scoreMult = scoreMult * (1.0 + bestTarget.Properties.get("Corpse").Value / 25.0);
        // logInfo("raise: 11 " + scoreMult)
        scoreMult = scoreMult * this.Math.maxf(0.0, 1.0 - currentDanger / this.Const.AI.Behavior.RaiseUndeadMaxDanger);
        // logInfo("raise: 12 " + scoreMult)
        return this.Const.AI.Behavior.Score.RaiseUndead * scoreMult;
    }
});
