local mod = ::CampsAndArtifacts <- {
    ID = "mod_camps_and_artifacts"
    Name = "Camps and Artifacts"
    Version = 2.0
    Data = {}
};

foreach (file in ::IO.enumerateFiles("camps_and_artifacts/config")) ::include(file);

::mods_registerMod(mod.ID, mod.Version, mod.Name);
::mods_queue(mod.ID, null, function () {
    foreach (file in ::IO.enumerateFiles("camps_and_artifacts/factions/actions")) ::include(file);

    // Fix camps and artifacts
    ::mods_hookExactClass("factions/actions/add_random_situation_action", function(cls) {
        local onUpdate = cls.onUpdate;
        cls.onUpdate = function ( _faction ) {
            local allSettlements = _faction.m.Settlements;
            local realSettlements = _faction.m.Settlements.filter(@(_, s) ::isKindOf(s, "settlement"));
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

    ::mods_hookExactClass("entity/world/location", function(cls) {
        local onSpawned = cls.onSpawned;
        cls.onSpawned = function () {
            local nearestSettlement = 9000;
            local myTile = this.getTile();
            foreach (s in this.World.EntityManager.getSettlements()) {
                local d = myTile.getDistanceTo(s.getTile());
                if (d < nearestSettlement) nearestSettlement = d;
            }

            if (!this.isLocationType(this.Const.World.LocationType.Unique)) {
                local scale = ((this.m.Resources + nearestSettlement * 4) / 5.0 - 37.0);
                local artifact_chance = scale * scale / 2;
                if (::Math.rand(1, 10000) <= artifact_chance) {
                    local artifacts = ::Const.Items.Artifacts;
                    local artifact = artifacts[::Math.rand(0, artifacts.len() - 1)];
                    this.m.Loot.add(this.new("scripts/items/" + artifact));
                    this.logWarning("Spawned an Artifact!");
                    return // no more loot
                }
            }
            onSpawned()
        }
    })
})
