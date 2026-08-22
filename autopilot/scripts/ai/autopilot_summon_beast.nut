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

        local spot = ::Autopilot.summonSpot(this, _entity, this.m.Skill);
        if (spot == null) return 0;
        this.m.TargetTile = spot.Tile;

        // With Hatch use it more, basically on cooldown. Without it - wait for the moment.
        if (this.m.Skill.hasHatch()) {
            if (debug) ::logInfo("summon: hatch, nearest=" + spot.Nearest + " score=" + score);
            return score * 2;
        }

        score *= spot.Mult;
        if (debug) ::logInfo("summon: single, nearest=" + spot.Nearest + " score=" + score);
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
