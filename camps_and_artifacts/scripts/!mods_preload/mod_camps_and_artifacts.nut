local mod = ::CampsAndArtifacts <- {
    ID = "mod_camps_and_artifacts"
    Name = "Camps and Artifacts"
    Version = 2.0
    Data = {}
};
::mods_registerMod(mod.ID, mod.Version, mod.Name);
::mods_queue(mod.ID, null, function () {
    // Fix camps and artifacts
    ::mods_hookExactClass("factions/actions/add_random_situation_action", function(cls) {
        local onUpdate = cls.onUpdate;
        cls.onUpdate = function ( _faction ) {
            local allSettlements = _faction.m.Settlements;
            local realSettlements = _faction.m.Settlements.filter(@(_, s) ::isKindOf(s, "settlement"));
            logInfo("Faction " + _faction.getName() + " settlements " + _faction.m.Settlements.len()
                    + " real " + realSettlements.len());
            if (realSettlements.len() > 0) {
                _faction.m.Settlements = realSettlements;
                onUpdate(_faction)
                _faction.m.Settlements = allSettlements;
            } else {
                std.towns <- _faction.m.Settlements;
                std.Debug.log("settlements", _faction.m.Settlements);
                onUpdate(_faction)
            }
        }
    })
})
