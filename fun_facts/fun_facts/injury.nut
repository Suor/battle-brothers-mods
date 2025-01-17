::mods_hookExactClass("skills/injury/injury", function (o) {
    local onNewDay = o.onNewDay;
    o.onNewDay = function () {
        local ff = ::FunFacts.s2ff(this), assets = ::World.Assets.get();
        local addMedicine = assets.addMedicine;
        assets.addMedicine = function (_amount) {
            addMedicine(_amount);
            if (_amount < 0) ff.onUseHerbs(-_amount);
        }

        onNewDay();

        assets.addMedicine = addMedicine;
    }
})
