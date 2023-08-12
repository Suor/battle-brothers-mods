::mods_hookExactClass("skills/perks/perk_nine_lives", function (o) {
    local setSpent = o.setSpent;
    o.setSpent = function (_f) {
        local wasSpent = this.m.IsSpent;
        setSpent(_f);
        if (!wasSpent && this.m.IsSpent) {
            local actor = this.getContainer().getActor();
            if ("FunFacts" in actor.m) actor.m.FunFacts.onNineLivesUse();
        }
    }

    local onDeath = "onDeath" in o ? o.onDeath : null;
    o.onDeath <- function (_fatalityType) {
        this.m.Died = true;
        if (onDeath) onDeath(_fatalityType);
    }

    local onCombatStarted = o.onCombatStarted;
    o.onCombatStarted = function () {
        this.m.Died <- false;
        return onCombatStarted()
    }

    local onCombatFinished = o.onCombatFinished;
    o.onCombatFinished = function () {
        if (this.m.IsSpent && !this.m.Died) {
            local actor = this.getContainer().getActor();
            if ("FunFacts" in actor.m) actor.m.FunFacts.onNineLivesSave();
        }

        return onCombatFinished()
    }
});
