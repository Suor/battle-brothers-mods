::mods_hookExactClass("skills/perks/perk_nine_lives", function (o) {
    local function getFunFacts(skill) {
        local actor = skill.getContainer().getActor();
         return "FunFacts" in actor.m ? actor.m.FunFacts : null;
    }

    local setSpent = o.setSpent;
    o.setSpent = function (_f) {
        local wasSpent = this.m.IsSpent;
        setSpent(_f);
        if (!wasSpent && this.m.IsSpent) {
            local ff = getFunFacts(this);
            if (ff) ff.onNineLivesUse();
        }
    }

    local onDeath = "onDeath" in o ? o.onDeath : null;
    o.onDeath <- function (_fatalityType) {
        // Might be triggered out of combat, say by an event
        if ("ff_Died" in this.m && getFunFacts(this)) this.m.ff_Died = true;
        if (onDeath) onDeath(_fatalityType);
    }

    local onCombatStarted = o.onCombatStarted;
    o.onCombatStarted = function () {
        if (getFunFacts(this)) this.m.ff_Died <- false;
        return onCombatStarted()
    }

    local onCombatFinished = o.onCombatFinished;
    o.onCombatFinished = function () {
        local ff = getFunFacts(this);
        if (this.m.IsSpent && ff && !this.m.ff_Died) if (ff) ff.onNineLivesSave();

        return onCombatFinished()
    }
});
