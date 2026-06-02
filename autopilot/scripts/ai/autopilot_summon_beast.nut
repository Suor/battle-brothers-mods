local debug = false;

this.autopilot_summon_beast <- this.inherit("scripts/ai/tactical/behavior", {
    m = {
        PossibleSkills = [
            "actives.druid_summon_beast"
        ],
        Skill = null,
        TargetTile = null,
    },
    function create()
    {
        this.m.ID = this.Const.AI.Behavior.ID.AP_SummonBeast;
        this.m.Order = this.Const.AI.Behavior.Order.AP_SummonBeast;
        this.behavior.create();
    }

    function onEvaluate( _entity )
    {
        this.m.Skill = null;
        this.m.TargetTile = null;

        local score = ::Const.AI.Behavior.Score.AP_SummonBeast;
        score *= this.getProperties().BehaviorMult[this.m.ID];

        if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP) return 0;
        if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing) return 0;

        // selectSkill also checks AP, Fatigue and the skill's own isUsable (cooldown)
        this.m.Skill = this.selectSkill(this.m.PossibleSkills);
        if (this.m.Skill == null) return 0;

        local myTile = _entity.getTile();

        // Distance to the nearest known enemy decides how eager we are and where to plant the beast
        local nearest = 99, nearestTile = null;
        foreach (o in this.getAgent().getKnownOpponents()) {
            local oTile = o.Actor.getTile();
            local d = myTile.getDistanceTo(oTile);
            if (d < nearest) { nearest = d; nearestTile = oTile; }
        }

        // Need a free tile beside us to plant the beast on; prefer the one closest to the foe so
        // it lands on the line between us, screening the bro rather than spawning behind him.
        local bestDist = 99;
        foreach (tile in ::std.Tile.iterAdjacent(myTile)) {
            if (!this.m.Skill.onVerifyTarget(myTile, tile)) continue;
            local d = nearestTile == null ? 0 : tile.getDistanceTo(nearestTile);
            if (this.m.TargetTile == null || d < bestDist) {
                bestDist = d;
                this.m.TargetTile = tile;
            }
        }
        if (this.m.TargetTile == null) return 0;

        // With Hatch use it more, basically on cooldown. Without it - wait for the moment.
        if (this.m.Skill.hasHatch()) {
            if (debug) ::logInfo("summon: hatch, nearest=" + nearest + " score=" + score);
            return score * 2;
        }

        // FIX: use getIdealRange()
        // A melee bro waits for a close foe; a ranged bro keeps his distance, so a foe rarely
        // gets within 4 - screen him far earlier or he'd never get to summon at all.
        local reach = _entity.hasRangedWeapon() ? 7 : 4;
        if (nearest > reach) return 0;
        // Closer foe -> bigger payoff for committing the one summon now
        score *= 1.0 + (reach - nearest).tofloat() / reach;
        if (debug) ::logInfo("summon: single, nearest=" + nearest + " score=" + score);
        return score;
    }

    function onExecute( _entity )
    {
        if (this.Const.AI.VerboseMode) {
            ::logInfo("* " + _entity.getName() + ": Summons a beast!");
        }

        this.m.Skill.use(this.m.TargetTile);

        if (!_entity.isHiddenToPlayer()) {
            this.getAgent().declareAction();
        }

        this.m.Skill = null;
        this.m.TargetTile = null;
        return true;
    }
});
