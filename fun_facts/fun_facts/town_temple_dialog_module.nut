::mods_hookExactClass("ui/screens/world/modules/world_town_screen/town_temple_dialog_module", function (o) {
    local onTreatInjury = o.onTreatInjury;
    o.onTreatInjury = function (_data) {
        local ret = onTreatInjury(_data);

        local entity = ::Tactical.getEntityByID(_data[0]);
        if (!("FunFacts" in entity.m)) return ret;

        local injury = entity.getSkills().getSkillByID(_data[1]);
        entity.m.FunFacts.onTempleUsed(injury.getPrice());

        return ret;
    }
})
