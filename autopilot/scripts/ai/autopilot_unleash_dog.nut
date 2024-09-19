this.autopilot_unleash_dog <- this.inherit("scripts/ai/tactical/behavior", {
    m = {
        PossibleSkills = [
            "actives.unleash_wardog"
            "actives.unleash_wolf"
            "actives.unleash_direwolf"   // North Expansion
            "actives.unleash_companion"  // AC Legends
        ],
        Skill = null,
        TargetTile = null,
    },
    function create()
    {
        this.m.ID = this.Const.AI.Behavior.ID.AP_UnleashDog;
        this.m.Order = this.Const.AI.Behavior.Order.AP_UnleashDog;
        this.behavior.create();
    }

    function onEvaluate( _entity )
    {
        this.m.Skill = null;
        this.m.TargetTile = null;

        local score = ::Const.AI.Behavior.Score.AP_UnleashDog;
        score *= this.getProperties().BehaviorMult[this.m.ID];

        if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP) {
            return this.Const.AI.Behavior.Score.Zero;
        }
        if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing) {
            return this.Const.AI.Behavior.Score.Zero;
        }

        // This also checks whether there is enough AP and Fatigue
        this.m.Skill = this.selectSkill(this.m.PossibleSkills);
        if (this.m.Skill == null) return this.Const.AI.Behavior.Score.Zero;
        // score *= this.getFatigueScoreMult(this.m.Skill);
        // TODO: higher score for Houndmaster

        // Find tile and count allies and enemies
        local myTile = _entity.getTile();
        local us = 0, enemies = 0;
        for (local i = 0; i < ::Const.Direction.COUNT; i++) {
            if (!myTile.hasNextTile(i)) continue;

            local tile = myTile.getNextTile(i);
            if (tile.IsOccupiedByActor) {
                if (tile.getEntity().isAlliedWith(_entity)) {us++; }
                else {enemies++; }
            } else if (this.m.Skill.onVerifyTarget(myTile, tile)) {
                if (!this.m.TargetTile) this.m.TargetTile = tile;
            }
        }
        if (this.m.TargetTile == null) return this.Const.AI.Behavior.Score.Zero;

        if (enemies > us + 1) {
            ::logInfo("Defending with dog")
            // TODO: adjust score if having backstabber/underdog
            score *= enemies / (us + 1);
            return score;
        }
        if (enemies > 0 && (_entity.getHitpointsPct() < 0.5
                        || _entity.getSkills().hasSkillOfType(::Const.SkillType.TemporaryInjury))) {
            ::logInfo("Saving myself with dog")
            return score * 2;
        }

        // Go for goblins, geists, alps, fleeing and ranged enemies
        local q = {
            Self = this
            Actor = _entity
            Weak = 0
            Strong = 0
        };
        ::Tactical.queryActorsInRange(myTile, 1, 7, this.onCollectWeak, q);
        delete q.Self;
        delete q.Actor;
        if (q.Weak > q.Strong) {
            ::logInfo("Bullying with dog")
            return score / 2 * (q.Weak - q.Strong) //* this.getFatigueScoreMult(this.m.Skill);
        }

        // Do not feel outnumbered and nobody to bully, maybe unleash just for fun :)
        // NOTE: we need this condition or this will happen all the time on low AP
        if (_entity.getActionPoints() >= _entity.getActionPointsMax()) {
            ::logInfo("Playing with dog")
            return 10 + enemies * score / 10;
        }

        return ::Const.AI.Behavior.Score.Zero;
    }

    function onCollectWeak( _actor, _tag )
    {
        if (!_actor.isAlive() || !_actor.isAttackable())
        {
            return;
        }

        if (!_actor.getTile().IsVisibleForEntity || _actor.isAlliedWith(_tag.Actor))
        {
            return;
        }

        local type = _actor.getType()
        if (type == ::Const.EntityType.Ghost
            || type == ::Const.EntityType.Alp
            || type == ::Const.EntityType.Spider
            || _actor.m.Flags.has("goblin")
            || _actor.getMoraleState() == ::Const.MoraleState.Fleeing
            || _tag.Self.isRangedUnit(_actor))
        {
            _tag.Weak++;
            // _tag.Targets.push(_actor);
        } else {
            _tag.Strong++;
        }
    }

    function onExecute( _entity )
    {
        if (this.Const.AI.VerboseMode) {
            ::logInfo("* " + _entity.getName()
                + ": Unleashes " + this.m.Skill.m.Item.getName() + "!");
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
