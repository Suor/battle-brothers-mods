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
                local artifacts = clone this.Const.Items.Artifacts;
                local artifact = artifacts[::Math.rand(0, artifacts.len() - 1)];
                this.m.Loot.add(this.new("scripts/items/" + artifact));
                this.logWarning("Spawned an Artifact!");
                return // no more loot
            }
        }
        onSpawned()
    }
})
