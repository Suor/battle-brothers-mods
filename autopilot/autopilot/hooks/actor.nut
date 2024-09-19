::mods_hookExactClass("entity/tactical/actor", function (cls) {
    cls.addAutoSkill <- function(skillId) {
        if(!("autoSkills" in m)) m.autoSkills <- [];
        m.autoSkills.append(skillId);
    }

    cls.clearAutoSkills <- function() {
        if("autoSkills" in m) m.autoSkills.clear();
    }

    cls.processAutoSkills <- function() {
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

    local onTurnStart = cls.onTurnStart;
    cls.onTurnStart = function() {
        onTurnStart();
        processAutoSkills();
    }

    local onTurnResumed = cls.onTurnResumed;
    cls.onTurnResumed = function() {
        onTurnResumed();
        processAutoSkills();
    }

    local onTurnEnd = cls.onTurnEnd;
    cls.onTurnEnd = function() {
        if (ClassName == "player" && getMoraleState() != Const.MoraleState.Fleeing
                && !::Tactical.State.isFleeing()) {
            local freewake = ::Autopilot.conf("freewake"), reload = ::Autopilot.conf("reload");
            local skills = getSkills(), tile = getTile();
            local function tryUseSkill(id, t) {
                local s = skills.getSkillByID(id);
                return s != null && s.use(t);
            }

            // see if we can help ourselves first
            if (freewake) tryUseSkill("actives.break_free", tile);
            if (reload) {
                foreach (s in ["actives.reload_bolt", "actives.reload_handgonne"])
                    tryUseSkill(s, tile);
            }

            // then try to help adjacent allies
            if (freewake) {
                foreach(s in ["actives.wake_ally", "actives.break_ally_free"])
                {
                    local skill = skills.getSkillByID(s);
                    if(skill != null && skill.isUsable() && skill.isAffordable())
                    {
                        for(local dir = 0; dir < 6; dir++)
                        {
                            if(tile.hasNextTile(dir))
                            {
                                local adjTile = tile.getNextTile(dir);
                                if(adjTile.IsOccupiedByActor && adjTile.getEntity().isAlliedWith(this))
                                {
                                    for(local i = 0; i < 3 && skill.use(adjTile); i++) { }
                                }
                            }
                        }
                    }
                }
            }

            // finally, use the recover skill if it'd help
            if (getFatigue() > m.CurrentProperties.FatigueRecoveryRate)
                tryUseSkill("actives.recover", tile);
        }

        onTurnEnd();
        clearAutoSkills();
    }
})
