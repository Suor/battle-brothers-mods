local mod = ::Hooks.getMod("mod_autopilot_new");
local Actor = ::std.Actor;

// Fix crash with skill loosing container,
// happens when actor looses a skill while evaluating possible targets,
// i.e. weapon breaks as a result of previous attack delayed calc.
mod.hookTree("scripts/skills/skill", function (q) {
    q.onVerifyTarget = @(__original) function (_originTile, _targetTile) {
        if (this.m.Container == null ||  this.m.Container.isNull()) return false;
        return __original(_originTile, _targetTile);
    }
    // Wrap MSU broken weapon bug, i.e. skill loosing container between onEvaluate and onExecute
    q.use = @(__original) function (_targetTile, _forFree = false) {
        if (this.m.Container == null ||  this.m.Container.isNull()) return false;
        return __original(_targetTile, _forFree);
    }
})

// Fix crash after ranged actor killing somebody or enemy dying while ranged actor is thinking
mod.hook("scripts/ai/tactical/behaviors/ai_engage_ranged", function (q) {
    // Walk in the general direction of the closest reachable known opponent. Used as a fallback
    // when the vanilla candidate-tile search produced nothing — usually because no tile within
    // search radius has line of sight to any enemy. Vanilla only enters this branch when enemies
    // are >12 tiles away (see ai_engage_ranged.nut:381–411), which leaves an autopilot ranged
    // bro stuck on Idle when enemies are closer but visually blocked.
    local function walkBlindly(_b, _entity, _maxRange) {
        // Bail if the bro no ranged weapon - wait until switched to ranged.
        // NOTE: might also trigger bug where a guy stepping 1 tile back and forth.
        if (!_entity.isArmedWithRangedWeapon()) return false;
        local navigator = ::Tactical.getNavigator();
        local myTile = _entity.getTile();
        local settings = navigator.createSettings();
        settings.ActionPointCosts = _entity.getActionPointCosts();
        settings.FatigueCosts = _entity.getFatigueCosts();
        settings.FatigueCostFactor = 0.0;
        settings.ActionPointCostPerLevel = _entity.getLevelActionPointCost();
        settings.FatigueCostPerLevel = _entity.getLevelFatigueCost();
        settings.AllowZoneOfControlPassing = false;
        settings.ZoneOfControlCost = ::Const.AI.Behavior.ZoneOfControlAPPenalty;
        settings.AlliedFactions = _entity.getAlliedFactions();
        settings.Faction = _entity.getFaction();
        local stopAt = ::Math.min(12,
            ::Math.max(::Const.AI.Behavior.RangedEngageMinQueryRadius, _maxRange));
        _b.m.ValidTargets.sort(_b.onSortByDistance);
        foreach (target in _b.m.ValidTargets) {
            if (!navigator.findPath(myTile, target.Tile, settings, stopAt)) continue;
            local cost = navigator.getCostForPath(_entity, settings,
                _entity.getActionPoints(), _entity.getFatigueMax() - _entity.getFatigue());
            if (cost.Tiles == 0) continue;
            _b.m.TargetDist = stopAt;
            _b.m.TargetTile = target.Tile;
            _b.m.TargetDanger = 0;
            return true;
        }
        return false;
    }

    local function cleanup(_b) {
        _b.m.ValidTargets = _b.m.ValidTargets.filter(@(_, t) Actor.isAlive(t.Actor));
        _b.m.PotentialDanger = _b.m.PotentialDanger.filter(@(_, a) Actor.isAlive(a));
    }

    q.selectBestTargetTile = @(__original) function (_entity, _maxRange, _considerLineOfFire, _visibleTileNeeded) {
        // The line `targetScore *= BlockedByAllyMult * (1.0 - TargetPriorityHittingAlliesMult)` in
        // vanilla selectBestTargetTile (~line 541) inverts the convention used everywhere else:
        //     lower mult = less willing to hit allies
        // We also extend the range to [-1, 1] so player bros can set mult to -0.9 for an extra
        // strong friendly-fire avoidance (via subtraction in ai_attack_bow etc.). Here we remap
        // [-1, 1] -> [1, 0] so the formula `0.5 * (1 - f(mult))` yields (1 + mult) / 4:
        //     mult=-1.0 -> 0.0 (fully ditched), -0.9 -> 0.025, 0.1 -> 0.275, 1.0 -> 0.5 (lich)
        local props = this.getProperties();
        local savedMult = props.TargetPriorityHittingAlliesMult;
        props.TargetPriorityHittingAlliesMult = (1.0 - savedMult) / 2.0;

        local ret;
        local gen = __original(_entity, _maxRange, _considerLineOfFire, _visibleTileNeeded);

        while (true) {
            // The problem with this is while we go through tiles a target might become invalid,
            // usually after a ranged bro shoots someone and we are evaluating his next shot
            cleanup(this);
            ret = resume gen;
            if (ret != null) {
                props.TargetPriorityHittingAlliesMult = savedMult;
                if (this.m.TargetTile == null && "_autopilot" in _entity.m
                        && this.m.ValidTargets.len() > 0
                        && walkBlindly(this, _entity, _maxRange)) {
                    ::logInfo("autopilot: " + _entity.getName()
                         + " walking blindly toward known enemy");
                }
                return ret;
            }
            yield ret;
        }
    }
})

// Fix melee target or entity breaking (dying, going out of map) between onEvaluate and onExecute
mod.hook("scripts/ai/tactical/behaviors/ai_engage_melee", function (q) {
    q.onExecute = @(__original) function (_entity) {
        if (!Actor.isAlive(_entity)
            || this.m.TargetActor != null && !Actor.isValidTarget(this.m.TargetActor)) return true;
        return __original(_entity);
    }
})

mod.hook("scripts/ai/tactical/behavior", function (q) {
    // Sometimes _tile might be 0 ???
    q.querySpearwallValueForTile = @(__original) function (_entity, _tile) {
        if (!_tile) return 0.0;
        return __original(_entity, _tile);
    }
    // Note the reverse params order
    q.hasNegativeTileEffect = @(__original) function (_tile, _entity) {
        if (!_tile) return 0.0;
        return __original(_tile, _entity);
    }

    // For player actors whether somebody is ranged or not is decided by his vision,
    // so a throwing guy in a big hat at night suddenly becomes not ranged for AI.
    // This makes 2-tile bros start to hide behind such guy :)
    q.isRangedUnit = @(__original) function (_entity) {
        if (typeof _entity == "instance" && _entity.isNull()) return false;
        if ("_autopilot" in _entity.m) {
            return _entity.m._autopilot.ranged || _entity.hasRangedWeapon();
        }
        return __original(_entity);
    }
})

// ai_attack_knockout.getBestTarget() tries to call .getExpectedDamage` on attack of oppotunity of
// the _entity, if there is none combat hangs up
mod.hook("scripts/ai/tactical/behaviors/ai_attack_knock_out", function (q) {
    q.getBestTarget = @(__original) function (_entity, _skill, _targets) {
        local skills = _entity.getSkills();
        local attackSkill = skills.getAttackOfOpportunity();
        if (attackSkill != null) return __original(_entity, _skill, _targets);

        local function mock_getAttackOfOpportunity() {
            return {
                function getActionPointCost() {return 4}
                function getExpectedDamage(target) {
                    return {ArmorDamage = 0, DirectDamage = 0, HitpointDamage = 0, TotalDamage = 0}
                }
            }
        }
        local mock = {
            function getSkills() {
                return {
                    getAttackOfOpportunity = mock_getAttackOfOpportunity
                }.setdelegate(skills)
            }
        }.setdelegate(_entity.get());

        return __original(mock, _skill, _targets);
    }
})


// Fix hang when pickup weapon is selected but entity can't actually equip it (e.g. animals)
mod.hook("scripts/ai/tactical/behaviors/ai_pickup_weapon", function (q) {
    q.onEvaluate = @(__original) function (_entity) {
        if ("_apSkipPickup" in _entity.m) return this.Const.AI.Behavior.Score.Zero;
        return __original(_entity);
    }
    q.onExecute = @(__original) function (_entity) {
        local ret = __original(_entity);
        if (ret && !_entity.isArmed()) {
            ::logWarning("autopilot: " + _entity.getName() + " failed to pick up weapon, disabling");
            _entity.m._apSkipPickup <- true;
        }
        return ret;
    }
})

// The great delayed melee kill fix.
// Same problem as with ranged kill, but the fix is more complicated - we wrap all the known
// opponents and allies into special WeakTableRef descendant, which will save the day when
// some code will try to access bad actor.
mod.hook("scripts/ai/tactical/strategy", function (q) {
    q.onOpponentSighted = @(__original) function (_entity) {
        __original(ActorRef(_entity));
    }
})
mod.hook("scripts/ai/tactical/agent", function (q) {
    q.compileKnownAllies = @(__original) function () {
        __original();
        this.m.KnownAllies = this.m.KnownAllies.map(@(e) ::ActorRef(e));
    }
})

mod.hook("scripts/ai/tactical/behavior", function (q) {
    q.queryTargetValue = @(__original) function (_entity, _target, _skill = null) {
        if (!Actor.isValidTarget(_target)) return 0;
        return __original(_entity, _target, _skill);
    }
    q.queryActorTurnsNearTarget = @(__original) function (_actor, _target, _entity) {
        if (!Actor.isValidTarget(_actor) || !Actor.isValidTarget(_entity)) return {
            Turns = 9000.0
            TurnsWithAttack = 9000.0
            InZonesOfControl = false
            InZonesOfOccupation = false
        }
        return __original(_actor, _target, _entity)
    }
})

local function getBound(_actor, _index) {
    local result = _actor[_index];
    if (typeof result == "function") result = result.bindenv(_actor);
    return result;
}
::ActorRef <- class extends WeakTableRef {
    r_Suffix = "<not-set>";

    constructor(_obj) {
        if (typeof _obj == "instance" && _obj instanceof ::WeakTableRef) {
            _obj = _obj.get()
        }
        if (_obj != null && typeof _obj != "table") throw "Passed something unexpected here";
        if (_obj != null) {
            this.WeakTable = _obj.weakref();
            this.r_Suffix = " of " + _obj.getName();
        }
    }

    function _get(_index) {
        if (_index in this) return this[_index];
        else if (this.WeakTable == null) {
            if (_index in ::ActorFake) {
                ::logWarning("autopilot: null ActorRef, saving " + _index + this.r_Suffix);
                return getBound(::ActorFake, _index);
            }
            ::logWarning("autopilot: null ActorRef, crashing " + _index + this.r_Suffix);
            throw "null ActorRef, index = " + _index + this.r_Suffix;
        }
        else {
            if (_index == "getTile" && !this.WeakTable.isPlacedOnMap()) {
                ::logWarning("autopilot: bad ActorRef, saving " + _index + this.r_Suffix);
                return getBound(::ActorFake, _index);
            }
            return getBound(this.WeakTable, _index);
        }
    }
}
::ActorFake <- {
    function getID() {return "<no-id>"}
    function getTile() {return ::Tactical.getTileSquare(0, 0)}
    function isAlive() {return false}
    function isDying() {return true}
    function isPlacedOnMap() {return false}
    function getAlliedFactions() {return []}
    function getMoraleState() {return ::Const.MoraleState.Fleeing}
    function getAIAgent() {
        return {
            function getEngagementsDeclared(_entity) {return 0}
        }
    }
}
