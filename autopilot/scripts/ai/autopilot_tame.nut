local debug = true;

this.autopilot_tame <- this.inherit("scripts/ai/tactical/behavior", {
    m = {
        DefaultChance = 3.0
        PossibleSkills = [
            "actives.companions_tame" // AC
        ]
        Skill = null
        TargetTile = null
        TargetEntity = null
    },
    function create()
    {
        this.m.ID = ::Const.AI.Behavior.ID.AP_Tame;
        this.m.Order = ::Const.AI.Behavior.Order.AP_Tame;
        if ("Companions" in ::Const) this.m.DefaultChance = ::Const.Companions.TameChance.Default / 10;
        this.behavior.create();
    }

    function onEvaluate( _entity )
    {
        this.m.TargetTile = null;
        this.m.TargetEntity = null;

        local score = ::Const.AI.Behavior.Score.AP_Tame;
        score *= this.getProperties().BehaviorMult[this.m.ID];
        if (debug) ::logInfo("tame 1: " + score);

        if (_entity.getActionPoints() < ::Const.Movement.AutoEndTurnBelowAP) {
            return ::Const.AI.Behavior.Score.Zero;
        }
        if (debug) ::logInfo("tame 2: " + score);
        if (_entity.getMoraleState() == ::Const.MoraleState.Fleeing) {
            return ::Const.AI.Behavior.Score.Zero;
        }
        if (debug) ::logInfo("tame 3: " + score);

        // This also checks whether there is enough AP and Fatigue
        this.m.Skill = this.selectSkill(this.m.PossibleSkills);
        if (this.m.Skill == null) return ::Const.AI.Behavior.Score.Zero;
        if (debug) ::logInfo("tame 4: " + score);

        score *= this.getFatigueScoreMult(this.m.Skill);
        if (debug) ::logInfo("tame 5: " + score);
        // TODO: higher score for Houndmaster

        // Hurt or injured, give up
        if (_entity.getHitpointsPct() < 0.5
                || _entity.getSkills().hasSkillOfType(::Const.SkillType.TemporaryInjury)) {
             return ::Const.AI.Behavior.Score.Zero;
        }
        if (debug) ::logInfo("tame 6: " + score);

        // Find tile and count allies and enemies
        local myTile = _entity.getTile(), targetTile = null, bestChance = 0;
        for (local i = 0; i < ::Const.Direction.COUNT; i++) {
            if (!myTile.hasNextTile(i)) continue;

            local tile = myTile.getNextTile(i);
            if (debug) ::logInfo("tame 7: tile " + i + " verify " + this.m.Skill.onVerifyTarget(myTile, tile));
            if (this.m.Skill.onVerifyTarget(myTile, tile)) {
                local beast = tile.getEntity();
                local chance = this.m.Skill.getHitchance(beast);
                if (chance > bestChance) {
                    this.m.TargetTile = tile;
                    this.m.TargetEntity = beast;
                    bestChance = chance;
                }
            }
        }
        if (debug) ::logInfo("tame 8: " + score);
        if (this.m.TargetTile == null) return ::Const.AI.Behavior.Score.Zero;
        if (debug) ::logInfo("Tame chance: " + bestChance + ", beast: " + this.m.TargetEntity.getName());

        // All modifiers (beastmaster, hp, effects) go in chance
        score *= bestChance / this.m.DefaultChance;
        if (debug) ::logInfo("tame 9: " + score);

        return score;
    }

    function onExecute( _entity )
    {
        if (::Const.AI.VerboseMode) {
            this.logInfo("* " + _entity.getName()
                + ": Trying to tame " + this.m.TargetEntity.getName() + "!");
        }

        this.m.Skill.use(this.m.TargetTile);

        if (!_entity.isHiddenToPlayer()) {
            this.getAgent().declareAction();
        }

        this.m.TargetTile = null;
        this.m.TargetEntity = null;
        return true;
    }
});
