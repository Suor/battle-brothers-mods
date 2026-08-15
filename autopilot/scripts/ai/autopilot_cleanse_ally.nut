local debug = false;

// What each skill can take off an ally and what taking it off is worth: 1.0 = worth the whole
// action. The AP price is folded in - undenting armor eats 7 of 9 AP for a mild debuff.
local cureWeights = {
    "actives.bandage_ally": {          // vanilla, from the bandage accessory
        "effects.bleeding": 0.35,      // per stack, and stacks pile up
        "injury.cut_artery": 0.5,      // 3 hp a turn for the rest of the battle, then days of healing
        "injury.cut_throat": 0.5,
        "injury.grazed_neck": 0.4,
    },
    "actives.break_ally_free": {       // vanilla, every bro has it
        "effects.kraken_ensnare": 1.5, // rooted, no skills at all, and 10-15 direct damage a tick
        "effects.web": 1.0,            // rooted, halved damage and defenses, and draws attacks
        "effects.net": 0.95,
        "effects.rooted": 0.9,
    },
    "actives.wake_ally": {
        "effects.sleeping": 1.2        // stunned for up to 4 turns
    },
    "actives.rf_adjust_dented_armor_ally": {
        "effects.rf_dented_armor": 0.25
    },
};

local possibleSkills = [];
foreach (skillID, _ in cureWeights) possibleSkills.push(skillID);

this.autopilot_cleanse_ally <- this.inherit("scripts/ai/tactical/behavior", {
    m = {
        PossibleSkills = possibleSkills,
        Skill = null,
        TargetTile = null,
    },
    function create()
    {
        this.m.ID = this.Const.AI.Behavior.ID.AP_CleanseAlly;
        this.m.Order = this.Const.AI.Behavior.Order.AP_CleanseAlly;
        this.behavior.create();
    }

    // Sums up what this skill would actually take off that ally right now.
    function rateTarget( _ally, _cures )
    {
        local total = 0.0;
        foreach (effect in _ally.getSkills().getSkillsByFunction(@(s) s.getID() in _cures)) {
            // Only wounds taken this battle are still fresh enough to bandage away.
            if (effect.isType(::Const.SkillType.Injury) && !effect.isFresh()) continue;
            total += _cures[effect.getID()];
        }
        return total;
    }

    function onEvaluate( _entity )
    {
        this.m.Skill = null;
        this.m.TargetTile = null;

        if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP) return 0;
        if (_entity.getMoraleState() == this.Const.MoraleState.Fleeing) return 0;

        local myTile = _entity.getTile(), best = 0.0;
        foreach (skillID in this.m.PossibleSkills) {
            // Bandages are a consumable, so spending them stays under the player's control
            if (skillID == "actives.bandage_ally" && !::Autopilot.conf("bandages")) continue;

            local skill = _entity.getSkills().getSkillByID(skillID);
            if (skill == null || !skill.isUsable() || !skill.isAffordable()) continue;

            local fatigueMult = this.getFatigueScoreMult(skill);
            if (fatigueMult <= 0) continue;
            local cures = cureWeights[skillID];

            foreach (ally in this.getAgent().getKnownAllies()) {
                if (!::std.Actor.isAlive(ally)) continue;
                local allyTile = ally.getTile();
                // isUsableOn also checks the skill's own target rules and tile visibility.
                if (!skill.isUsableOn(allyTile, myTile)) continue;

                local weight = this.rateTarget(ally, cures);
                if (weight == 0) continue;
                // Pinned with foes on top of them, or nearly dead - then it can't wait a turn.
                weight *= 1.0 + 0.25 * allyTile.getZoneOfControlCountOtherThan(_entity.getAlliedFactions());
                weight *= 1.0 + (1.0 - ally.getHitpointsPct());
                weight *= fatigueMult;

                if (weight > best) {
                    best = weight;
                    this.m.Skill = skill;
                    this.m.TargetTile = allyTile;
                }
            }
        }

        if (this.m.Skill == null) return 0;

        local score = ::Const.AI.Behavior.Score.AP_CleanseAlly * best
            * this.getProperties().BehaviorMult[this.m.ID];
        if (debug) ::logInfo("cleanse: " + this.m.Skill.getID() + " weight=" + best + " score=" + score);
        return score;
    }

    function onExecute( _entity )
    {
        if (this.Const.AI.VerboseMode) {
            ::logInfo("* " + _entity.getName() + ": Cures an ally with " + this.m.Skill.getID() + "!");
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
