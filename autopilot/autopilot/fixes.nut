// Fix crash with skill loosing container,
// happens when actor looses a skill while evaluating possible targets,
// i.e. weapon breaks as a result of previous attack delayed calc.
::mods_hookBaseClass("skills/skill", function (cls) {
    cls = cls.skill;

    local onVerifyTarget = cls.onVerifyTarget;
    cls.onVerifyTarget = function(_originTile, _targetTile) {
        if (this.m.Container == null ||  this.m.Container.isNull()) return false;
        return onVerifyTarget(_originTile, _targetTile);
    }
})

// Fix crash after ranged actor killing somebody or enemy dying while ranged actor is thinking
::mods_hookExactClass("ai/tactical/behaviors/ai_engage_ranged", function (cls) {
    local function isRelevant(_actor) {
        return !_actor.isNull() && !_actor.m.IsDying && _actor.m.IsAlive;
    }

    local function cleanup(_b) {
        _b.m.ValidTargets = _b.m.ValidTargets.filter(@(_, t) isRelevant(t.Actor));
        _b.m.PotentialDanger = _b.m.PotentialDanger.filter(@(_, a) isRelevant(a));
    }

    // The problem with this is while we go through tiles a target might become invalid,
    // usually after a ranged bro shoots someone and we are evaluating his next shot
    local selectBestTargetTile = cls.selectBestTargetTile;
    cls.selectBestTargetTile = function (_entity, _maxRange, _considerLineOfFire, _visibleTileNeeded) {
        local ret;
        local gen = selectBestTargetTile(_entity, _maxRange, _considerLineOfFire, _visibleTileNeeded);

        while (true) {
            cleanup(this);
            ret = resume gen;
            // Proxy "results"
            if (ret != null) return ret;
            yield ret;
        }
    }
})


::mods_hookBaseClass("ai/tactical/behavior", function(cls) {
    cls = cls.behavior;

    // Sometimes _tile might be 0 ???
    local querySpearwallValueForTile = cls.querySpearwallValueForTile;
    cls.querySpearwallValueForTile = function(_entity, _tile) {
        if (!_tile) return 0.0;
        return querySpearwallValueForTile(_entity, _tile);
    }

    // For player actors whether somebody is ranged or not is decided by his vision,
    // so a throwing guy in a big hat at night night suddenly becomes not ranged for AI.
    // This makes 2-tile bros start to hide behind such guy :)
    local isRangedUnit = cls.isRangedUnit;
    cls.isRangedUnit = function (_entity) {
        if (typeof _entity == "instance" && _entity.isNull()) return false;
        if ("_autopilot" in _entity.m) return _entity.m._autopilot.ranged;
        return isRangedUnit(_entity);
    }
})

// ai_attack_knockout.getBestTarget() tries to call .getExpectedDamage` on attack of oppotunity of
// the _entity, if there is none combat hangs up
::mods_hookExactClass("ai/tactical/behaviors/ai_attack_knock_out", function (cls) {
    local getBestTarget = cls.getBestTarget;
    cls.getBestTarget = function (_entity, _skill, _targets) {
        local skills = _entity.getSkills();
        local attackSkill = skills.getAttackOfOpportunity();
        if (attackSkill != null) return getBestTarget(_entity, _skill, _targets);

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

        return getBestTarget(mock, _skill, _targets);
    }
})
