::mods_hookExactClass("factions/actions/build_nomad_camp_action", function(cls) {
    local onExecute = cls.onExecute;
    cls.onExecute = function ( _faction ) {
        local camp;
        // local r = this.Math.rand(1, 4);
        local r = this.Math.rand(1, 5);
        local disallowedTerrain = [];

        for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = ++i )
        {
            if (i == this.Const.World.TerrainType.Desert || i == this.Const.World.TerrainType.Oasis || i == this.Const.World.TerrainType.Steppe || i == this.Const.World.TerrainType.Hills)
            {
            }
            else
            {
                disallowedTerrain.push(i);
            }
        }

        if (r == 1)
        {
            local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, disallowedTerrain, 7, 20, 1000, 7, 7, null, 0.0, 0.2);

            if (tile != null)
            {
                camp = this.World.spawnLocation("scripts/entity/world/locations/nomad_tents_location", tile.Coords);
            }
        }
        else if (r == 2)
        {
            local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, disallowedTerrain, 9, 25, 1000, 7, 7, null, 0.0, 0.2);

            if (tile != null)
            {
                camp = this.World.spawnLocation("scripts/entity/world/locations/nomad_hidden_camp_location", tile.Coords);
            }
        }
        else if (r == 3)
        {
            local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, disallowedTerrain, 13, 35, 1000, 7, 7, null, 0.0, 0.2);

            if (tile != null)
            {
                camp = this.World.spawnLocation("scripts/entity/world/locations/nomad_tent_city_location", tile.Coords);
            }
        }
        // START NEW CODE
        else if (r == 4)
        {
            local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, disallowedTerrain, 14, 37, 1000, 7, 7, null, 0.0, 0.2);

            if (tile != null)
            {
                camp = this.World.spawnLocation("scripts/entity/world/locations/nomad_heretic_location", tile.Coords);
            }
        }
        // END NEW CODE
        else
        {
            local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, disallowedTerrain, 9, 25, 1000, 7, 7, null, 0.0, 0.2);

            if (tile != null)
            {
                camp = this.World.spawnLocation("scripts/entity/world/locations/nomad_ruins_location", tile.Coords);
            }
        }

        if (camp != null)
        {
            local banner = this.getAppropriateBanner(camp, _faction.getSettlements(), 10, this.Const.NomadBanners);
            camp.onSpawned();
            camp.setBanner(banner);
            _faction.addSettlement(camp, false);
        }
    }

}
