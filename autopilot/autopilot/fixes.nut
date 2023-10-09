// Fix crash after ranged actor killing somebody
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

// For player actors whether somebody is ranged or not is decided by his vision,
// so a throwing guy in a big hat at night night suddenly become melee for AI.
// This makes 2-tile bros start to hide behind :)
::mods_hookBaseClass("ai/tactical/behavior", function(cls) {
    cls = cls.behavior;

    local isRangedUnit = cls.isRangedUnit;
    cls.isRangedUnit = function (_entity) {
        if ("_autopilot" in _entity.m) return _entity.m._autopilot.ranged;
        return isRangedUnit(_entity);
    }
})
