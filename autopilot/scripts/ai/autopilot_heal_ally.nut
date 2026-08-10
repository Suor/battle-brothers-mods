local debug = false;

// Skills that put an ally back together. Their worth is the target's wound plus whatever else
// they wash off, on the same scale: 1.0 = an ally at death's door.
local healSkills = {
    "actives.druid_regrowth": {
        Blocker = "effects.druid_regrowth", // already mending, a second one adds nothing
        DoTWeight = 0.0,
        Cures = {},
    },
    "actives.bp_aug.laying_on_hands": {     // BP Augmenteds, Qi Energy perk
        Blocker = null,
        DoTWeight = 0.35,                   // per stack of poison or bleeding it washes off
        // The hexe pipes every wound she takes into her slave, so cutting the link is worth a turn
        Cures = {"effects.hex_slave": 1.2},
    },
};

local possibleSkills = [];
foreach (skillID, _ in healSkills) possibleSkills.push(skillID);

this.autopilot_heal_ally <- this.inherit("scripts/ai/tactical/behavior", {
    m = {
        PossibleSkills = possibleSkills,
        Skill = null,
        TargetTile = null,
    },
    function create()
    {
        this.m.ID = this.Const.AI.Behavior.ID.AP_HealAlly;
        this.m.Order = this.Const.AI.Behavior.Order.AP_HealAlly;
        this.behavior.create();
    }

    // How much this ally stands to gain from that skill right now.
    function rateTarget( _ally, _info )
    {
        local skills = _ally.getSkills();
        if (_info.Blocker != null && skills.hasSkill(_info.Blocker)) return 0.0;

        local rate = 1.0 - _ally.getHitpointsPct();
        if (_info.DoTWeight > 0) {
            rate += _info.DoTWeight * skills.getSkillsByFunction(
                @(s) s.isType(::Const.SkillType.DamageOverTime)).len();
        }
        foreach (effectID, weight in _info.Cures) {
            if (skills.hasSkill(effectID)) rate += weight;
        }
        return rate;
    }

    function onEvaluate( _entity )
    {
        this.m.Skill = null;
        this.m.TargetTile = null;

        if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP) return 0;
        if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing) return 0;

        this.m.Skill = this.selectSkill(this.m.PossibleSkills);
        if (this.m.Skill == null) return 0;

        local score = ::Const.AI.Behavior.Score.AP_HealAlly;
        score *= this.getProperties().BehaviorMult[this.m.ID];
        score *= this.getFatigueScoreMult(this.m.Skill);

        // Pick whoever gains the most from it
        local info = healSkills[this.m.Skill.getID()], myTile = _entity.getTile(), best = 0.0;
        foreach (ally in this.getAgent().getKnownAllies()) {
            if (!::std.Actor.isAlive(ally)) continue;
            local allyTile = ally.getTile();
            // isUsableOn also checks target-tile visibility, which use() requires but onVerifyTarget doesn't.
            if (!this.m.Skill.isUsableOn(allyTile, myTile)) continue;

            local rate = this.rateTarget(ally, info);
            if (rate > best) {
                best = rate;
                this.m.TargetTile = allyTile;
            }
        }

        // Don't waste it on a scratch - wait until someone is meaningfully hurt.
        if (this.m.TargetTile == null || best < 0.25) return 0;

        score *= 1.0 + best;
        if (debug) ::logInfo("heal_ally: " + this.m.Skill.getID() + " rate=" + best + " score=" + score);
        return score;
    }

    function onExecute( _entity )
    {
        if (this.Const.AI.VerboseMode) {
            ::logInfo("* " + _entity.getName() + ": Mends an ally with " + this.m.Skill.getID() + "!");
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
