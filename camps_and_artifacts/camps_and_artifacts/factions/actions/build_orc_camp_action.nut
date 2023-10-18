::mods_hookExactClass("factions/actions/build_orc_camp_action", function(cls) {
    local onUpdate = cls.onUpdate;
    cls.onUpdate = function ( _faction ) {
        local settlements = _faction.getSettlements();

        if (this.World.FactionManager.isGreenskinInvasion() && this.World.FactionManager.getGreaterEvilStrength() >= 20.0)
        {
            if (settlements.len() > 20)
            {
                return;
            }
        }
        // else if (settlements.len() > 12 + (this.Const.DLC.Desert ? 2 : 0))
        else if (settlements.len() > 12)
        {
            return;
        }

        this.m.Score = 2;
    }

    local onExecute = cls.onExecute;
    cls.onExecute = function ( _faction ) {
        local camp;
        local r;
        // local minY = this.Const.DLC.Desert ? 0.15 : 0.0;

        if (_faction.getSettlements().len() == 0)
        {
            // r = 6;
            r = 7;
        }
        else if (this.World.FactionManager.isGreenskinInvasion())
        {
            // r = this.Math.rand(0, 5);
            r = this.Math.rand(0, 6);
        }
        else
        {
            // r = this.Math.rand(1, 5);
            r = this.Math.rand(1, 6);
        }
// 
        if (r == 0 || r == 1)
        {
            local tile;

            if (this.World.FactionManager.isGreenskinInvasion())
            {
                tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
                    this.Const.World.TerrainType.Mountains,
                    this.Const.World.TerrainType.Snow
                // ], 8, 20, 20, 7, 7, null, minY);
                ], 8, 20, 20);
            }
            else
            {
                tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
                    this.Const.World.TerrainType.Mountains,
                    this.Const.World.TerrainType.Snow
                // ], 15, 1000, 20, 7, 7, null, minY);
                ], 15, 1000, 20);
            }

            if (tile != null)
            {
                camp = this.World.spawnLocation("scripts/entity/world/locations/orc_camp_location", tile.Coords);
            }
        }
        else if (r == 2)
        {
            local tile;

            if (this.World.FactionManager.isGreenskinInvasion())
            {
                tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
                    this.Const.World.TerrainType.Forest,
                    this.Const.World.TerrainType.Mountains
                ], 7, 18, 40);
            }
            else
            {
                tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
                    this.Const.World.TerrainType.Forest,
                    this.Const.World.TerrainType.Mountains
                ], 10, 1000, 40);
            }

            if (tile != null)
            {
                camp = this.World.spawnLocation("scripts/entity/world/locations/orc_cave_location", tile.Coords);
            }
        }
        else if (r == 3)
        {
            local tile;

            if (this.World.FactionManager.isGreenskinInvasion())
            {
                tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
                    this.Const.World.TerrainType.Mountains,
                    this.Const.World.TerrainType.Snow
                // ], 8, 18, 20, 7, 7, null, minY);
                ], 8, 18, 20);
            }
            else
            {
                tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
                    this.Const.World.TerrainType.Mountains,
                    this.Const.World.TerrainType.Snow
                // ], 14, 30, 20, 7, 7, null, minY);
                ], 14, 30, 20);
            }

            if (tile != null)
            {
                camp = this.World.spawnLocation("scripts/entity/world/locations/orc_ruins_location", tile.Coords);
            }
        }
        else if (r == 4)
        {
            local tile;

            if (this.World.FactionManager.isGreenskinInvasion())
            {
                tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
                    this.Const.World.TerrainType.Mountains
                // ], 6, 14, 30, 7, 7, null, minY);
                ], 6, 14, 30);
            }
            else
            {
                tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
                    this.Const.World.TerrainType.Mountains
                // ], 10, 20, 30, 7, 7, null, minY);
                ], 10, 20, 30);
            }

            if (tile != null)
            {
                camp = this.World.spawnLocation("scripts/entity/world/locations/orc_hideout_location", tile.Coords);
            }
        }
        // else if (r == 5 || r == 6)
        else if (r == 5)
        {
            local tile;

            if (this.World.FactionManager.isGreenskinInvasion())
            {
                // tile = this.getTileToSpawnLocation(r == 6 ? 1000 : this.Const.Factions.BuildCampTries, [
                //     this.Const.World.TerrainType.Mountains,
                //     this.Const.World.TerrainType.Snow
                // ], 15, 30, 30, 7, 7, null, minY);
                // START NEW CODE
                tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
                    this.Const.World.TerrainType.Mountains
                ], 6, 1000, 30);
                // END NEW CODE
            }
            else
            {
                // tile = this.getTileToSpawnLocation(r == 6 ? 1000 : this.Const.Factions.BuildCampTries, [
                //     this.Const.World.TerrainType.Mountains,
                //     this.Const.World.TerrainType.Snow
                // ], 25, 1000, 20, 7, 7, null, minY);
                // START NEW CODE
                tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
                    this.Const.World.TerrainType.Mountains
                ], 10, 1000, 30);
                // END NEW CODE
            }
            // 
            // if (tile != null && _faction.getSettlements().len() == 0)
            // {
            //     local goblins = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Goblins).getSettlements();
            // 
            //     foreach( s in goblins )
            //     {
            //         if (s.getTile().getDistanceTo(tile) <= 25)
            //         {
            //             return;
            //         }
            //     }
            // }

            if (tile != null)
            {
                camp = this.World.spawnLocation("scripts/entity/world/locations/orc_settlement_location", tile.Coords);
            }
        }
        // START NEW CODE
        else if (r == 6 || r == 7)
        {
            local tile;

            if (this.World.FactionManager.isGreenskinInvasion())
            {
                tile = this.getTileToSpawnLocation(r == 7 ? 1000 : this.Const.Factions.BuildCampTries, [
                    this.Const.World.TerrainType.Mountains,
                    this.Const.World.TerrainType.Snow
                ], 15, 1000, 40);
            }
            else
            {
                tile = this.getTileToSpawnLocation(r == 7 ? 1000 : this.Const.Factions.BuildCampTries, [
                    this.Const.World.TerrainType.Mountains,
                    this.Const.World.TerrainType.Snow
                ], 15, 1000, 40);
            }

            if (tile != null)
            {
                camp = this.World.spawnLocation("scripts/entity/world/locations/orc_fortress_location", tile.Coords);
            }
        }
        // END NEW CODE

        if (camp != null)
        {
            local banner = this.getAppropriateBanner(camp, _faction.getSettlements(), 15, this.Const.OrcBanners);
            camp.onSpawned();
            camp.setBanner(banner);
            _faction.addSettlement(camp, false);
        }
    }

}
