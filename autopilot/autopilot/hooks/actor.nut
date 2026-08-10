local mod = ::Hooks.getMod("mod_autopilot_new");

mod.hook("scripts/entity/tactical/actor", function (q) {
    q.addAutoSkill <- function(skillId) {
        if(!("autoSkills" in m)) m.autoSkills <- [];
        m.autoSkills.append(skillId);
    }

    q.clearAutoSkills <- function() {
        if("autoSkills" in m) m.autoSkills.clear();
    }

    q.processAutoSkills <- function() {
        if (m.MoraleState != Const.MoraleState.Fleeing && "autoSkills" in m)
        {
            local skills = getSkills();
            foreach(id in m.autoSkills)
            {
                local skill = skills.getSkillByID(id);
                if (skill != null && skill.isUsable() && skill.isAffordable())
                    skill.use(getTile());
            }

            m.autoSkills.clear();
        }
    }

    q.onTurnStart = @(__original) function () {
        __original();
        processAutoSkills();
    }

    q.onTurnResumed = @(__original) function () {
        __original();
        processAutoSkills();
    }

    q.onTurnEnd = @(__original) function () {
        if (ClassName == "player" && getMoraleState() != Const.MoraleState.Fleeing
                && !::Tactical.State.isAutoRetreat() && isPlacedOnMap()) {
            local freewake = ::Autopilot.conf("freewake"), reload = ::Autopilot.conf("reload");
            local bandages = ::Autopilot.conf("bandages");
            local skills = getSkills(), tile = getTile();
            local function tryUseSkill(id, t) {
                local s = skills.getSkillByID(id);
                return s != null && s.use(t);
            }

            // see if we can help ourselves first
            if (freewake) tryUseSkill("actives.break_free", tile);
            if (bandages) tryUseSkill("actives.bandage_ally", tile); // reaches range 0, i.e. self
            if (reload) {
                foreach (s in ["actives.reload_bolt", "actives.reload_handgonne"])
                    tryUseSkill(s, tile);
            }

            // then try to help adjacent allies
            local allySkills = [];
            if (freewake) allySkills.extend(["actives.wake_ally", "actives.break_ally_free"]);
            if (bandages) allySkills.push("actives.bandage_ally");
            foreach(s in allySkills)
            {
                foreach(ally in ::std.Tile.iterAdjacentActors(tile))
                {
                    // A spent bandage removes its item and this skill with it, so the next
                    // bandage's skill is a different object — refetch it every time.
                    local skill = skills.getSkillByID(s);
                    if(skill == null || !skill.isUsable() || !skill.isAffordable()) break;

                    if(!ally.isAlliedWith(this)) continue;

                    local tries = s == "actives.bandage_ally" ? 1 : 3;
                    for(local i = 0; i < tries && skill.use(ally.getTile()); i++) { }
                }
            }

            // finally, use the recover skill if it'd help
            if (getFatigue() > m.CurrentProperties.FatigueRecoveryRate)
                tryUseSkill("actives.recover", tile);
        }

        __original();
        clearAutoSkills();
    }
})
