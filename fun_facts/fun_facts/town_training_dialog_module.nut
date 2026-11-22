::mods_hookExactClass("ui/screens/world/modules/world_town_screen/town_training_dialog_module", function (o) {
    local onTrain = o.onTrain;
    o.onTrain = function (_data) {
        // Legends and others price training their own way, the money spent is what counts
        local money = ::World.Assets.getMoney();
        local ret = onTrain(_data);

        local entity = ::Tactical.getEntityByID(_data[0]);
        local paid = money - ::World.Assets.getMoney();
        if (paid > 0 && "FunFacts" in entity.m) entity.m.FunFacts.onTrained(paid);

        return ret;
    }
})
