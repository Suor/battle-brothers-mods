::mods_hookExactClass("factions/actions/build_nomad_camp_action", function(cls) {
    cls.onUpdate = function( _faction ) {
        local max = 1 + 9; // 1 + compensates weird logic there

         if (::World.FactionManager.isGreaterEvil()) max -= 2;
        max += max / 5; // Add ~20%

        if (_faction.getSettlements().len() >= max) return
        this.m.Score = 2;
    }

    local onExecute = cls.onExecute;
    cls.onExecute = function (_faction) {
        logInfo("build_nomad_camp_action")
        // 20% chance to build our special camp
        if (::Math.rand(1, 5) > 1) {onExecute(_faction); return}
        logInfo("build_nomad_camp_action SPECIAL")

        local camp;
        local disallowedTerrain = [];
        for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i){
            if (i != ::Const.World.TerrainType.Desert && i != ::Const.World.TerrainType.Oasis
                && i != ::Const.World.TerrainType.Steppe && i != ::Const.World.TerrainType.Hills)
            {
                disallowedTerrain.push(i);
            }
        }

        local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, disallowedTerrain,
            14, 37, 1000, 7, 7, null, 0.0, 0.2);

        if (tile != null) {
            camp = this.World.spawnLocation(
                "scripts/entity/world/locations/nomad_heretic_location", tile.Coords);
        }

        if (camp != null)
        {
            local banner = this.getAppropriateBanner(
                camp, _faction.getSettlements(), 10, ::Const.NomadBanners);
            camp.onSpawned();
            camp.setBanner(banner);
            _faction.addSettlement(camp, false);
            logInfo("build_nomad_camp_action DONE")
        }
    }
})

