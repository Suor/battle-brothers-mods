// Fix crash after ranged actor killing somebody
::mods_hookExactClass("ai/tactical/behaviors/ai_engage_ranged", function (o) {
    local function isRelevant(_actor) {
        return !_actor.isNull() && !_actor.m.IsDying && _actor.m.IsAlive;
    }

    local function cleanup(_b) {
        _b.m.ValidTargets = _b.m.ValidTargets.filter(@(_, t) isRelevant(t.Actor));
        _b.m.PotentialDanger = _b.m.PotentialDanger.filter(@(_, a) isRelevant(a));
    }

    // The problem with this is while we go through tiles a target might become invalid,
    // usually after a ranged bro shoots someone and we are evaluating his next shot
    local selectBestTargetTile = o.selectBestTargetTile;
    o.selectBestTargetTile = function (_entity, _maxRange, _considerLineOfFire, _visibleTileNeeded) {
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
});
