local debug = false;

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

        if (_entity.getActionPoints() < ::Const.Movement.AutoEndTurnBelowAP) return 0;
        if (_entity.getMoraleState() == ::Const.MoraleState.Fleeing) return 0;

        // This also checks whether there is enough AP and Fatigue
        this.m.Skill = this.selectSkill(this.m.PossibleSkills);
        if (this.m.Skill == null) return 0;
        if (debug) ::logInfo("tame 4: " + score);

        score *= this.getFatigueScoreMult(this.m.Skill);
        if (debug) ::logInfo("tame 5: " + score);

        // Hurt or injured, give up
        if (_entity.getHitpointsPct() < 0.5
                || _entity.getSkills().hasSkillOfType(::Const.SkillType.TemporaryInjury)) {
             return 0;
        }
        if (debug) ::logInfo("tame 6: " + score);

        // Find tile and count allies and enemies
        local myTile = _entity.getTile(), bestChance = 0, us = 1, enemies = 0;
        foreach (actor in ::std.Tile.iterAdjacentActors(myTile)) {
            if (actor.isAlliedWith(_entity)) {us++; }
            else {
                enemies++;
                if (this.m.Skill.onVerifyTarget(myTile, actor.getTile())) {
                    local chance = this.m.Skill.getHitchance(actor);
                    if (chance > bestChance) {
                        this.m.TargetTile = actor.getTile();
                        this.m.TargetEntity = actor;
                        bestChance = chance;
                    }
                }
            }
        }
        if (debug) ::std.Debug.log("tame 7: ", {us = us, enemies = enemies, chance = bestChance});
        if (enemies >= us && enemies != 1) return 0;
        if (debug) ::logInfo("tame 8: " + score);
        if (this.m.TargetTile == null) return 0;
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
