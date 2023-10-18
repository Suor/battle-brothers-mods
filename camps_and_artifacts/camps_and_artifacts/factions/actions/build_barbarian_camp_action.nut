::mods_hookExactClass("factions/actions/build_barbarian_camp_action", function(cls) {
    local onExecute = cls.onExecute;
    cls.onExecute = function ( _faction ) {
        local camp;
        // local r = this.Math.rand(1, 3);
        local r = this.Math.rand(1, 4);

        if (r == 1)
        {
            local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
                this.Const.World.TerrainType.Mountains
            ], 7, 20, 1000, 7, 7, null, 0.75);

            if (tile != null)
            {
                camp = this.World.spawnLocation("scripts/entity/world/locations/barbarian_shelter_location", tile.Coords);
            }
        }
        else if (r == 2)
        {
            local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
                this.Const.World.TerrainType.Mountains
            ], 9, 25, 1000, 7, 7, null, 0.75);

            if (tile != null)
            {
                camp = this.World.spawnLocation("scripts/entity/world/locations/barbarian_camp_location", tile.Coords);
            }
        }
        else if (r == 3)
        {
            local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
                this.Const.World.TerrainType.Mountains
            ], 13, 35, 1000, 7, 7, null, 0.75);

            if (tile != null)
            {
                camp = this.World.spawnLocation("scripts/entity/world/locations/barbarian_sanctuary_location", tile.Coords);
            }
        }
        // START NEW CODE
        else if (r == 4)
        {
            local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
                this.Const.World.TerrainType.Mountains
            ], 13, 35, 1000, 7, 7, null, 0.75);

            if (tile != null)
            {
                camp = this.World.spawnLocation("scripts/entity/world/locations/barbarian_sacred_grove_location", tile.Coords);
            }
        }
        // END NEW CODE

        if (camp != null)
        {
            local banner = this.getAppropriateBanner(camp, _faction.getSettlements(), 15, this.Const.BarbarianBanners);
            camp.onSpawned();
            camp.setBanner(banner);
            _faction.addSettlement(camp, false);
        }
    }

}
