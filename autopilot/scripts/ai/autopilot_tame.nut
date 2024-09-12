this.autopilot_tame <- this.inherit("scripts/ai/tactical/behavior", {
    m = {
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
        this.behavior.create();
    }

    function onEvaluate( _entity )
    {
        this.m.TargetTile = null;
        this.m.TargetEntity = null;

        local score = ::Const.AI.Behavior.Score.AP_Tame;
        score *= this.getProperties().BehaviorMult[this.m.ID];

        if (_entity.getActionPoints() < ::Const.Movement.AutoEndTurnBelowAP) {
            return ::Const.AI.Behavior.Score.Zero;
        }
        if (_entity.getMoraleState() == ::Const.MoraleState.Fleeing) {
            return ::Const.AI.Behavior.Score.Zero;
        }

        // This also checks whether there is enough AP and Fatigue
        this.m.Skill = this.selectSkill(this.m.PossibleSkills);
        if (this.m.Skill == null) return ::Const.AI.Behavior.Score.Zero;

        score *= this.getFatigueScoreMult(this.m.Skill);
        // TODO: higher score for Houndmaster

        // Hurt or injured, give up
        if (_entity.getHitpointsPct() < 0.5
                || _entity.getSkills().hasSkillOfType(::Const.SkillType.TemporaryInjury)) {
             return ::Const.AI.Behavior.Score.Zero;
        }

        // Find tile and count allies and enemies
        local myTile = _entity.getTile(), targetTile = null, bestChance = 0;
        for (local i = 0; i < ::Const.Direction.COUNT; i++) {
            if (!myTile.hasNextTile(i)) continue;

            local tile = myTile.getNextTile(i);
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
        if (this.m.TargetTile == null) return ::Const.AI.Behavior.Score.Zero;
        ::logInfo("Tame chance: " + bestChance + ", beast: " + this.m.TargetEntity.getName());

        // modAccessoryCompanions is a AC_legends thing
        local defaultChance = "modAccessoryCompanions" in getroottable()
            ? ::modAccessoryCompanions.TameChance
            : ::Const.Companions.TameChance.Default;
        // All modifiers (beastmaster, hp, effects) go in chance
        score *= bestChance / (defaultChance / 10);

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
