local mod = ::CampsAndArtifacts <- {
    ID = "mod_camps_and_artifacts"
    Name = "Camps and Artifacts (Reworked)"
    Version = 3.0
    Data = {}
};
// TODO: fix weapons reach
// TODO: add missing artifact versions of named stuff
// TODO: add extra:
//   - artifact bolo
//   - artifact 2h orc axe
//   - artifact 2h orc chain
//   - artifact goblin impaler
local function choice(options) {
    return options[::Math.rand(0, options.len() - 1)];
}

mod.createRandomName <- function () {
    if (this.m.PrefixList.len() > 0 && ::Math.rand(1, 100) <= 70) {
        return choice(this.m.PrefixList) + " " + choice(this.m.NameList)
    }
    else {
        return choice(this.m.NameList)
    }
}


foreach (file in ::IO.enumerateFiles("camps_and_artifacts/config")) ::include(file);

::mods_registerMod(mod.ID, mod.Version, mod.Name);
::mods_queue(mod.ID, null, function () {
    ::include("camps_and_artifacts/factions/faction");
    foreach (file in ::IO.enumerateFiles("camps_and_artifacts/factions/actions")) ::include(file);
    ::include("camps_and_artifacts/entity/world/locations/orc_fortress_location");

    ::mods_hookExactClass("entity/world/location", function(cls) {
        local onSpawned = cls.onSpawned;
        cls.onSpawned = function () {
            logWarning("Spawned " + this.ClassName + " resources " + this.m.Resources);
            local nearestSettlement = 9000;
            local myTile = this.getTile();
            foreach (s in this.World.EntityManager.getSettlements()) {
                local d = myTile.getDistanceTo(s.getTile());
                if (d < nearestSettlement) nearestSettlement = d;
            }

            local scale = ((this.m.Resources + nearestSettlement * 4) / 5.0 - 37.0);
            if (scale > 0 && !this.isLocationType(this.Const.World.LocationType.Unique)) {
                local artifact_chance = scale * scale / 2;
                logWarning("camps: artifact chance " + (artifact_chance/100.0) + " scale " + scale
                     + " nearestSettlement " + nearestSettlement + " resources " + this.m.Resources);
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
