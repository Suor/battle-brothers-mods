::mods_hookExactClass("factions/actions/build_bandit_camp_action", function(cls) {
    cls.onUpdate = function( _faction ) {
        local max = 1 + (::Const.DLC.Wildmen ? 9 : 12); // 1 + compensates weird logic there

        if (::World.FactionManager.isCivilWar()
                && ::World.FactionManager.getGreaterEvilStrength() >= 20.0) {
            max += ::Const.DLC.Wildmen ? 3 : 4;
        }
        else if (::World.FactionManager.isGreaterEvil()) {
            max -= ::Const.DLC.Wildmen ? 3 : 4;
        }
        max += max / 4; // Add ~25%

        if (_faction.getSettlements().len() >= max) return
        this.m.Score = 2;
    }

    local onExecute = cls.onExecute;
    cls.onExecute = function (_faction) {
        // logInfo("build_bandit_camp_action")
        // 25% chance to build our special camp
        if (::Math.rand(1, 4) > 1) {onExecute(_faction); return}
        // logInfo("build_bandit_camp_action SPECIAL")

        local camp;
        local minY = this.Const.DLC.Desert ? 0.2 : 0.0;
        local maxY = this.Const.DLC.Wildmen ? 0.75 : 1.0;
        local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
            this.Const.World.TerrainType.Mountains,
            this.Const.World.TerrainType.Snow
        ], 10, 20, 1000, 7, 7, null, minY, maxY);

        if (tile != null) {
            camp = this.World.spawnLocation(
                "scripts/entity/world/locations/bandit_usurper_location", tile.Coords);
        }

        if (camp != null) {
            local banner = this.getAppropriateBanner(
                camp, _faction.getSettlements(), 15, this.Const.BanditBanners);
            camp.onSpawned();
            camp.setBanner(banner);
            _faction.addSettlement(camp, false);
            // logInfo("build_bandit_camp_action DONE")
        }
    }
})

