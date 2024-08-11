::mods_hookExactClass("factions/actions/build_barbarian_camp_action", function(cls) {
    cls.onUpdate = function( _faction ) {
        local max = 1 + 7; // 1 + compensates weird logic there

         if (::World.FactionManager.isGreaterEvil()) max -= 2;
        max += max / 4; // Add ~25%

        if (_faction.getSettlements().len() >= max) return
        this.m.Score = 2;
    }

    local onExecute = cls.onExecute;
    cls.onExecute = function (_faction) {
        // logInfo("build_barbarian_camp_action")
        // 25% chance to build our special camp
        if (::Math.rand(1, 4) > 1) {onExecute(_faction); return}
        // logInfo("build_barbarian_camp_action SPECIAL")

        local camp;
        local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
            this.Const.World.TerrainType.Mountains
        ], 13, 35, 1000, 7, 7, null, 0.75);

        if (tile != null) {
            camp = this.World.spawnLocation(
                "scripts/entity/world/locations/barbarian_sacred_grove_location", tile.Coords);
        }

        if (camp != null) {
            local banner = this.getAppropriateBanner(
                camp, _faction.getSettlements(), 15, this.Const.BarbarianBanners);
            camp.onSpawned();
            camp.setBanner(banner);
            _faction.addSettlement(camp, false);
            // logInfo("build_barbarian_camp_action DONE")
        }
    }
})

