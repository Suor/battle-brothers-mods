::mods_hookExactClass("ui/screens/world/modules/world_town_screen/town_hire_dialog_module",
        function (cls) {
    local onHireRosterEntry = cls.onHireRosterEntry;
    cls.onHireRosterEntry = function (_entityID) {
        ::FunFacts.Hiring = true
        local ret = onHireRosterEntry(_entityID);
        ::FunFacts.Hiring = false;
        return ret;
    }
})
