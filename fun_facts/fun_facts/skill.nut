::mods_hookBaseClass("skills/skill", function (cls) {
    local function getFunFacts(skill) {
        local actor = skill.getContainer().getActor();
         return "FunFacts" in actor.m ? actor.m.FunFacts : null;
    }

    local onAdded = ::mods_getMember(cls, "onAdded");
    cls.onAdded <- function () {
        local ff = getFunFacts(this);
        if (ff) ff.onSkillAdded(this);
        return onAdded();
    }
})
