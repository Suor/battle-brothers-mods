::mods_hookExactClass("factions/actions/build_bandit_camp_action", function(cls) {
    local onExecute = cls.onExecute;
    cls.onExecute = function ( _faction ) {
        // START NEW CODE
        local settlements = _faction.getSettlements();
        // logInfo("build_bandit_camp_action.onExecute settlements " + settlements.len()
        //      + " " + _faction.getName());
        // END NEW CODE
        local camp;
        // local r = this.Math.rand(1, 3);
        // local minY = this.Const.DLC.Desert ? 0.2 : 0.0;
        local r = this.Math.rand(1, 4);
        local maxY = this.Const.DLC.Wildmen ? 0.75 : 1.0;

        if (r == 1)
        {
            local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
                this.Const.World.TerrainType.Mountains,
                this.Const.World.TerrainType.Snow
            // ], 7, 16, 1000, 7, 7, null, minY, maxY);
            ], 7, 16, 1000, 7, 7, null, 0.0, maxY);

            if (tile != null)
            {
                camp = this.World.spawnLocation("scripts/entity/world/locations/bandit_camp_location", tile.Coords);
            }
        }
        else if (r == 2)
        {
            local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
                this.Const.World.TerrainType.Mountains,
                this.Const.World.TerrainType.Snow
            // ], 6, 12, 1000, 7, 7, null, minY, maxY);
            ], 6, 12, 1000, 7, 7, null, 0.0, maxY);

            if (tile != null)
            {
                camp = this.World.spawnLocation("scripts/entity/world/locations/bandit_hideout_location", tile.Coords);
            }
        }
        else if (r == 3)
        {
            local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
                this.Const.World.TerrainType.Mountains,
                this.Const.World.TerrainType.Snow
            // ], 10, 20, 1000, 7, 7, null, minY, maxY);
            ], 10, 20, 1000, 7, 7, null, 0.0, maxY);

            if (tile != null)
            {
                camp = this.World.spawnLocation("scripts/entity/world/locations/bandit_ruins_location", tile.Coords);
            }
        }
        // START NEW CODE
        else if (r == 4)
        {
            local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
                this.Const.World.TerrainType.Mountains,
                this.Const.World.TerrainType.Snow
            ], 10, 20, 1000, 7, 7, null, 0.0, maxY);

            if (tile != null)
            {
                camp = this.World.spawnLocation("scripts/entity/world/locations/bandit_usurper_location", tile.Coords);
            }
        }
        // END NEW CODE

        if (camp != null)
        {
            local banner = this.getAppropriateBanner(camp, _faction.getSettlements(), 15, this.Const.BanditBanners);
            camp.onSpawned();
            camp.setBanner(banner);
            _faction.addSettlement(camp, false);
        }
    }

}
