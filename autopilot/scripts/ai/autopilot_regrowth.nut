local debug = false;

this.autopilot_regrowth <- this.inherit("scripts/ai/tactical/behavior", {
    m = {
        PossibleSkills = [
            "actives.druid_regrowth"
        ],
        Skill = null,
        TargetTile = null,
    },
    function create()
    {
        this.m.ID = this.Const.AI.Behavior.ID.AP_Regrowth;
        this.m.Order = this.Const.AI.Behavior.Order.AP_Regrowth;
        this.behavior.create();
    }

    function onEvaluate( _entity )
    {
        this.m.Skill = null;
        this.m.TargetTile = null;

        local score = ::Const.AI.Behavior.Score.AP_Regrowth;
        score *= this.getProperties().BehaviorMult[this.m.ID];

        if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP) return 0;
        if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing) return 0;

        this.m.Skill = this.selectSkill(this.m.PossibleSkills);
        if (this.m.Skill == null) return 0;
        score *= this.getFatigueScoreMult(this.m.Skill);

        // Pick the most wounded reachable ally that isn't already mending.
        local myTile = _entity.getTile(), bestWound = 0.0;
        foreach (ally in this.getAgent().getKnownAllies()) {
            if (!::std.Actor.isAlive(ally)) continue;
            if (ally.getSkills().hasSkill("effects.druid_regrowth")) continue;
            local allyTile = ally.getTile();
            // isUsableOn also checks target-tile visibility, which use() requires but onVerifyTarget doesn't.
            if (!this.m.Skill.isUsableOn(allyTile, myTile)) continue;

            local wound = 1.0 - ally.getHitpointsPct();
            if (wound > bestWound) {
                bestWound = wound;
                this.m.TargetTile = allyTile;
            }
        }

        // Don't waste it on a scratch - wait until someone is meaningfully hurt.
        if (this.m.TargetTile == null || bestWound < 0.25) return 0;

        score *= 1.0 + bestWound;
        if (debug) ::logInfo("regrowth: wound=" + bestWound + " score=" + score);
        return score;
    }

    function onExecute( _entity )
    {
        if (this.Const.AI.VerboseMode) {
            ::logInfo("* " + _entity.getName() + ": Bestows Regrowth on an ally!");
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
