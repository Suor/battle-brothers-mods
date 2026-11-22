local mod = ::Hooks.getMod("mod_autopilot_new");

// Add our behaviors
::MSU.AI.addBehavior("AP_UnbagNet", "AP.UnbagNet", 35, 100);
::MSU.AI.addBehavior("AP_UnbagShield", "AP.UnbagShield", 36, 400);
::MSU.AI.addBehavior("AP_UnleashDog", "AP.UnleashDog", 37, 200);
::MSU.AI.addBehavior("AP_Tame", "AP.Tame", 38, 400);
::MSU.AI.addBehavior("AP_SwapQuiver", "AP.SwapQuiver", 39, 400);
::MSU.AI.addBehavior("AP_SummonBeast", "AP.SummonBeast", 40, 400);
::MSU.AI.addBehavior("AP_HealAlly", "AP.HealAlly", 41, 250);
// Score is per unit of cure weight, so 1.0 (worth the whole action) lands on par with attacking
::MSU.AI.addBehavior("AP_CleanseAlly", "AP.CleanseAlly", 42, ::Const.AI.Behavior.Score.Attack);
::MSU.AI.addBehavior("AP_VoiceOfDavkul", "AP.VoiceOfDavkul",
    ::Const.AI.Behavior.Order.BoostStamina, ::Const.AI.Behavior.Score.Rally);
::MSU.AI.addBehavior("AP_AttackAlternate", "AP.AttackAlternate",
    ::Const.AI.Behavior.Order.AttackDefault - 1, ::Const.AI.Behavior.Score.Attack * 2);
::MSU.AI.addBehavior("AP_StepNHit", "AP.StepNHit",
    ::Const.AI.Behavior.Order.AttackDefault - 1, ::Const.AI.Behavior.Score.Attack);
// Moves that compete with engage_melee's walk
::MSU.AI.addBehavior("AP_Leap", "AP.Leap",
    ::Const.AI.Behavior.Order.EngageMelee - 1, ::Const.AI.Behavior.Score.Engage);
// Scored as engage_melee is, ordered before it to leave agent intentions to the walk
::MSU.AI.addBehavior("AP_MoveEngage", "AP.MoveEngage",
    ::Const.AI.Behavior.Order.EngageMelee - 1, ::Const.AI.Behavior.Score.Engage);

// When a 2-tile bro evaluates ai_engage_melee, make longer-reach non-ranged allies of the
// same faction report ideal range 2. The PreferCarefulEngage orbit-around-ally branch
// (ai_engage_melee.nut:207) then skips them via its `a.getIdealRange() == 2` clause — without
// this, a 2-tile bro orbits a whip wielder and ends up at a spot where nothing is in reach.
local mimicReach2Faction = -1;

mod.hook("scripts/entity/tactical/actor", function (q) {
    q.getIdealRange = @(__original) function () {
        local r = __original();
        if (r > 2 && mimicReach2Faction == this.getFaction() && !this.hasRangedWeapon()) return 2;
        return r;
    }
});

// Prefer doing something else than wandering around/waiting
mod.hook("scripts/ai/tactical/behaviors/ai_engage_melee", function (q) {
    // Reforged Juggernaut's charge, same shape as vanilla actives.charge
    q.m.PossibleSkills.push("actives.rf_swordmaster_charge");

    q.evaluate = @(__original) function (_entity) {
        if (!("_autopilot" in _entity.m)) return __original(_entity);

        local prev = mimicReach2Faction;
        if (_entity.getIdealRange() == 2) mimicReach2Faction = _entity.getFaction();
        local done;
        try { done = __original(_entity); }
        catch (e) { mimicReach2Faction = prev; throw e; }
        mimicReach2Faction = prev;

        if (done && this.m.IsWaitingBeforeMove && _entity.getIdealRange() == 2) this.m.Score /= 5;
        return done;
    }
});

mod.hook("scripts/ai/tactical/behaviors/ai_attack_default", function (q) {
    q.m.PossibleSkills.extend([
        // Vanilla Legendary 1.5.1
        "actives.censer_strike"
        // CleverFool's mod
        "actives.gae_buidhe_thrust"
        "actives.gae_dearg_thrust"
        // Fantasy Brothers
        "actives.xxitem_leftsaa_skill" // Dual Attack
        "actives.sb_devablow_skill"
        // Pandora's Hobby
        "actives.ph_scalpel_stab"    // Bistoury, anatomist's starting weapon
        "actives.ph_vivisect"        // ditto
        "actives.ph_whack"           // Golden Whacker
        "actives.ph_magic_bonk"      // Hexe Wand
        "actives.ph_bro_slap"        // Artificer helm/armor
        "actives.DS_split" // Guts' Dragonslayer: a line strike, also the sword's only one for a single foe
        // Looks like these are already added
        // "actives.xx_a" // Cut with Ring blade
        // "actives.xx_b" // Throw Ring blade
    ]);
    // Reforged has a specialized behavior for lunge
    if (!::Hooks.hasMod("mod_reforged")) q.m.PossibleSkills.push("actives.lunge");

    // Rifle shoot moved to ai_attack_bow
    local pos = q.m.PossibleSkills.find("actives.xxitem_rifleaa_skill");
    if (pos != null) q.m.PossibleSkills.remove(pos)
})
mod.hook("scripts/ai/tactical/behaviors/ai_attack_bow", function (q) {
    q.m.PossibleSkills.extend([
        // Fantasy Brothers
        "actives.xxitem_rifleaa_skill"
        // Reforged, bow mastery
        "actives.rf_arrow_to_the_knee"
        // Time-Crossing Commando
        "actives.sniper_rifle_shot"
        "actives.sniper_rifle_headshot"
    ]);
})
mod.hook("scripts/ai/tactical/behaviors/ai_reload", function (q) {
    q.m.PossibleSkills.push("actives.sniper_rifle_reload"); // Time-Crossing Commando
    // A magazine is reloadable once not full; topping it up is left to the end of turn auto reload
    q.onEvaluate = @(__original) function (_entity) {
        local score = __original(_entity);
        local s = m.Skill;
        if (s != null && s.getID() == "actives.sniper_rifle_reload" && s.getItem().getAmmo() > 0) return 0;
        return score;
    }
})
mod.hook("scripts/ai/tactical/behaviors/ai_attack_handgonne", function (q) {
    q.m.PossibleSkills.extend([
        // Fantasy Brothers
        "actives.sb_fireball_skill"
    ])
})

mod.hook("scripts/ai/tactical/behaviors/ai_engage_ranged", function (q) {
    q.m.PossibleSkills.extend([
        // Fantasy Brothers
        "actives.xxitem_rifleaa_skill"
        "actives.xxitem_deadbookaa_skill"
        // Time-Crossing Commando
        "actives.sniper_rifle_shot"
        "actives.sniper_rifle_headshot"
    ]);
})

mod.hook("scripts/ai/tactical/behaviors/ai_attack_split", function (q) {
    q.m.PossibleSkills.extend([
        "actives.excalibur_split" // CleverFool's mod
        "actives.DS_split"        // Guts' Dragonslayer, Guillotine Strike
    ]);
});
mod.hook("scripts/ai/tactical/behaviors/ai_attack_swing", function (q) {
    q.m.PossibleSkills.extend([
        "actives.censer_castigate" // Vanilla Legendary 1.5.1
        "actives.DS_shatter"       // Guts' Dragonslayer, Decimate
    ]);
});
mod.hook("scripts/ai/tactical/behaviors/ai_attack_thresh", function (q) {
    q.m.PossibleSkills.extend([
        "actives.DS_round_swing" // Guts' Dragonslayer, Steel Crescent
    ]);
});
mod.hook("scripts/ai/tactical/behaviors/ai_attack_splitshield", function (q) {
    q.m.PossibleSkills.extend([
        "actives.DS_split_shield" // Guts' Dragonslayer, Demolish Shield
    ]);
});
mod.hook("scripts/ai/tactical/behaviors/ai_defend_rotation", function (q) {
    q.m.PossibleSkills.extend([
        "actives.spin" // Heroic Scenario Pack
        "actives.rf_dynamic_duo_shuffle" // Reforged
    ]);
});
mod.hook("scripts/ai/tactical/behaviors/ai_boost_morale", function (q) {
    q.m.PossibleSkills.extend([
        "actives.rf_encourage" // Reforged, Supporter perk
    ]);
});
mod.hook("scripts/ai/tactical/behaviors/ai_always_use", function (q) {
    q.m.PossibleSkills.extend([
        "actives.ph_coat_with_spider_poison" // Pandora's Hobby, Poison Pot
    ]);
});
mod.hook("scripts/ai/tactical/behaviors/ai_boost_stamina", function (q) {
    q.m.PossibleSkills.extend([
        "actives.nem_barbarian_drum" // North Expansion Mod
    ]);
});
mod.hook("scripts/ai/tactical/behaviors/ai_recover", function (q) {
    q.m.PossibleSkills.extend([
        "actives.rf_bestial_vigor" // Reforged
    ]);
});
mod.hook("scripts/ai/tactical/behaviors/ai_root", function (q) {
    q.m.PossibleSkills.extend([
        "actives.druid_entangle" // Druid
        "actives.legend_root"    // Legends
    ]);
});

// Boost rally when step_n_hit also wants to fire, so the weighted-random pick favors rally
// (bannermen / backrow polearm bros otherwise lose rally to step_n_hit too often).
// TODO: make it smarter somehow and maybe more universal?
mod.hook("scripts/ai/tactical/agent", function (q) {
    q.sortBehaviors = @(__original) function () {
        local snh = null, rally = null;
        foreach (b in this.m.Behaviors) {
            if (b.getID() == ::Const.AI.Behavior.ID.AP_StepNHit) snh = b;
            else if (b.getID() == ::Const.AI.Behavior.ID.Rally) rally = b;
        }
        if (snh != null && rally != null && snh.getScore() > 0 && rally.getScore() > 0) {
            rally.m.Score = rally.m.Score * 2.0;
        }
        __original();
    }
});

// Adjust fatigue score mult
mod.hook("scripts/ai/tactical/behavior", function (q) {
    // Lower these behaviors scores more significantly with fatigue cost/left considerations
    local altWeights = {
        ai_adrenaline = 0.5
        ai_attack_splitshield = 0.7
        ai_defend_knock_back = 0.8
        ai_defend_rotation = 0.7
        ai_defend_shieldwall = 0.8
        ai_disengage = 0.3
        ai_rally = 0
        ai_line_breaker = 0.5
        autopilot_tame = 0.5
    }
    q.getFatigueScoreMult = @(__original) function (_skill) {
        local entity = this.getAgent().getActor();
        if (!("_autopilot" in entity.m)) return __original(_skill);

        local mult = __original(_skill);
        if (this.ClassName == "ai_disengage"
                && "_autopilot" in entity.m && entity.m._autopilot.ranged) return mult;
        if (!(this.ClassName in altWeights) || altWeights[this.ClassName] == 0) return mult;

        // Calculate alternative mult for some skills
        local apPct = _skill.getActionPointCost() / (entity.getActionPointsMax() * 1.0);
        local fatigue = this.Math.max(0, _skill.getFatigueCost() - entity.getCurrentProperties().FatigueRecoveryRate * entity.getCurrentProperties().FatigueRecoveryRateMult * apPct);
        local currentFatigue = entity.getFatigue();
        local maxFatigue = entity.getFatigueMax();

        // A negative weight will make idle used over this, i.e. save stamina
        // TODO: take into account absolute amount of fatigue left? opponents left?
        local alt = (1.0 * (maxFatigue - currentFatigue - fatigue) / maxFatigue - 0.5);
        local w = altWeights[this.ClassName];
        local mixed = w * alt + (1 - w) * mult;
        // logInfo("ap: FATIGUE Mult = " + mult + " alt = " + alt + " mixed = " + mixed);
        return mixed;
    }
})

// Legends' backup throws leave a bro without that weapon for the rest of the battle
if (::Hooks.hasMod("mod_legends")) {
    local function hookBackupThrow(_script, _flag) {
        mod.hook("scripts/skills/actives/" + _script, function (q) {
            q.isUsable = @(__original) function () {
                if ((_flag == null || m[_flag]) && !::Autopilot.conf("throwBackup")
                        && ::Autopilot.isUnderAIControl(getContainer().getActor())) return false;
                return __original();
            }
        });
    }
    hookBackupThrow("throw_axe", "IsBackupAxe");
    hookBackupThrow("throw_javelin", "IsBackupSpear");
    hookBackupThrow("legend_throw_knife_skill", null);
}
