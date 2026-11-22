// engage_melee planned as if moving with a skill that makes moves cheaper, rolled against the plain walk as usual.
// While planning, tweak() sets the bro's costs and budget to what they are after the skill and returns what to
// restore; untweak() restores it before each yield, so nothing else sees it. adjustScore() turns engage's score
// for the planned path into the move's.
this.autopilot_move_engage <- ::inherit("scripts/ai/tactical/behaviors/ai_engage_melee", {
    // By skill ID, a table to hook for other skills of the kind
    Moves = {
        // Reforged: -1 AP a tile for x1.5 fatigue, until any skill is used
        "actives.rf_sprint": {
            Effect = null
            function tweak(_entity, _behavior) {
                local p = _entity.getCurrentProperties();
                local saved = [p.MovementAPCostAdditional, p.MovementFatigueCostMult, _entity.m.Fatigue];
                if (Effect == null) Effect = ::new("scripts/skills/effects/rf_sprint_effect");
                Effect.onUpdate(p);
                _entity.m.Fatigue += _behavior.m.MoveSkill.getFatigueCost();
                return saved;
            }
            function untweak(_entity, _saved) {
                local p = _entity.getCurrentProperties();
                p.MovementAPCostAdditional = _saved[0];
                p.MovementFatigueCostMult = _saved[1];
                _entity.m.Fatigue = _saved[2];
            }
            // An AP saved a tile, for a third of the sprinted path's fatigue, which is x1.5 the walk's
            function adjustScore(_entity, _behavior, _score, _path) {
                local fatigue = _behavior.m.MoveSkill.getFatigueCost() + _path.Fatigue / 3.0;
                return _score * ::Autopilot.fatigueScoreMult(_entity, fatigue)
                    * (1.0 + _path.Tiles.tofloat() / _entity.getActionPointsMax());
            }
            function use(_entity, _behavior) {
                _behavior.m.MoveSkill.use(_entity.getTile());
            }
        }
        // Legends: a tile for 1 AP, once a turn, outside of ZoC
        "actives.legend_quick_step": {
            // The least a step saves over walking a tile, impassable 0 aside
            function tweak(_entity, _behavior) {
                local skill = _behavior.m.MoveSkill, apMin = 99, fatigueMin = 99;
                local ap = _entity.getActionPointCosts(), fatigue = _entity.getFatigueCosts();
                for (local i = 1; i < ap.len(); i++) {
                    apMin = ::Math.min(apMin, ap[i]);
                    fatigueMin = ::Math.min(fatigueMin, fatigue[i]);
                }
                local saved = [_entity.m.ActionPoints, _entity.m.Fatigue];
                _entity.m.ActionPoints += ::Math.max(0, apMin - skill.getActionPointCost());
                _entity.m.Fatigue += ::Math.max(0, skill.getFatigueCost() - fatigueMin);
                return saved;
            }
            function untweak(_entity, _saved) {
                _entity.m.ActionPoints = _saved[0];
                _entity.m.Fatigue = _saved[1];
            }
            // What the first tile of the path really costs, instead of the least
            function adjustScore(_entity, _behavior, _score, _path) {
                local skill = _behavior.m.MoveSkill, tile = _path.First;
                if (!skill.isUsableOn(tile)) return 0;
                local ap = _entity.getActionPointCosts()[tile.Type] - skill.getActionPointCost();
                local fatigue = skill.getFatigueCost() - _entity.getFatigueCosts()[tile.Type];
                return _score * ::Autopilot.fatigueScoreMult(_entity, fatigue)
                    * (1.0 + ap.tofloat() / _entity.getActionPointsMax());
            }
            function use(_entity, _behavior) {
                local b = _behavior;
                b.m.MoveSkill.use(::Autopilot.walkCost(_entity, b.m.TargetTile, b.m.TargetDistance).First);
            }
        }
    },
    m = {
        PossibleSkills = [], // Charges and such, using a skill ends a sprint
        MoveSkill = null
    },
    function create()
    {
        ai_engage_melee.create();
        m.ID = ::Const.AI.Behavior.ID.AP_MoveEngage;
        m.Order = ::Const.AI.Behavior.Order.AP_MoveEngage;
    }

    function onEvaluate( _entity )
    {
        m.MoveSkill = null;
        local props = getProperties();
        // Whatever holds a bro back from engaging holds back this too, ranged agents have no engage
        local engageID = ::Const.AI.Behavior.ID.EngageMelee, engageMult = props.BehaviorMult[engageID];
        if (engageMult == 0 || props.PreferWait || getAgent().getBehavior(engageID) == null) return 0;
        local ids = [];
        foreach (id, _ in Moves) ids.push(id);
        local skill = selectSkill(ids);
        if (skill == null) return 0;
        m.MoveSkill = skill;
        local move = Moves[skill.getID()];

        local engage = ai_engage_melee.onEvaluate(_entity), score, saved;
        while (true) {
            saved = move.tweak(_entity, this);
            try { score = resume engage; }
            catch (e) { move.untweak(_entity, saved); throw e; }
            move.untweak(_entity, saved);
            if (score != null) break;
            yield null;
        }
        // Waiting ends a sprint
        if (score > 0 && m.TargetTile != null && !m.IsWaitingBeforeMove) {
            // The path engage planned, which it keeps to itself
            saved = move.tweak(_entity, this);
            local path = ::Autopilot.walkCost(_entity, m.TargetTile, m.TargetDistance);
            move.untweak(_entity, saved);
            score = path == null || path.Tiles == 0 ? 0 : move.adjustScore(_entity, this, score * engageMult, path);
        } else score = 0;
        if (score <= 0) m.MoveSkill = null;
        return score;
    }

    function onExecute( _entity )
    {
        if (m.IsFirstExecuted) {
            if (m.MoveSkill != null) {
                Moves[m.MoveSkill.getID()].use(_entity, this);
                m.MoveSkill = null;
            }
            // The walk is planned from where the skill has put the bro
            if (::Tactical.getNavigator().isTravelling(_entity)) return false;
            if (_entity.getTile().getDistanceTo(m.TargetTile) <= m.TargetDistance) return true;
        }
        return ai_engage_melee.onExecute(_entity);
    }
});
