::mods_hookExactClass("factions/actions/build_orc_camp_action", function(cls) {
    cls.onUpdate = function( _faction ) {
        local max = 1 + 12; // 1 + compensates weird logic there

        if (this.World.FactionManager.isGreenskinInvasion()
                && this.World.FactionManager.getGreaterEvilStrength() >= 20.0) {
            max += 8;
        } else if (::Const.DLC.Desert) {
            max += 2;
        }
        max += max / 5; // Add ~20%

        if (_faction.getSettlements().len() >= max) return
        this.m.Score = 2;
    }

    local onExecute = cls.onExecute;
    cls.onExecute = function (_faction) {
        // logInfo("build_orc_camp_action")
        // 20% chance to build our special camp
        if (::Math.rand(1, 5) > 1) {onExecute(_faction); return}
        // logInfo("build_orc_camp_action SPECIAL")

        local camp;
        local minY = this.Const.DLC.Desert ? 0.15 : 0.0;
        local disallowedTerrain = [
            this.Const.World.TerrainType.Mountains,
            this.Const.World.TerrainType.Snow
        ];

        local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, disallowedTerrain,
            15, 75, 40, 7, 7);
        if (tile != null) {
            camp = ::World.spawnLocation(
                "scripts/entity/world/locations/orc_fortress_location", tile.Coords);
        }
        if (camp != null) {
            local banner = this.getAppropriateBanner(
                camp, _faction.getSettlements(), 15, this.Const.OrcBanners);
            camp.onSpawned();
            camp.setBanner(banner);
            _faction.addSettlement(camp, false);
            // logInfo("build_orc_camp_action DONE")
        }
    }
})

