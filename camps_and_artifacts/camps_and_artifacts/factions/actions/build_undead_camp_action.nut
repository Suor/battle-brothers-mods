::mods_hookExactClass("factions/actions/build_undead_camp_action", function(cls) {
    cls.onUpdate = function( _faction ) {
        local max = 1 + 11 + (this.Const.DLC.Desert ? 4 : 0); // 1 + compensates weird logic there

        if (this.World.FactionManager.isUndeadScourge()
                && this.World.FactionManager.getGreaterEvilStrength() >= 20.0) {
            max += 8;
        }
        max += max / 5; // Add ~20%

        if (_faction.getSettlements().len() >= max) return
        this.m.Score = 2;
    }

    local onExecute = cls.onExecute;
    cls.onExecute = function (_faction) {
        // logInfo("build_undead_camp_action")
        // 17% chance to build our special camp
        if (::Math.rand(1, 6) > 1) {onExecute(_faction); return}
        // logInfo("build_undead_camp_action SPECIAL")

        local camp;
        local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, [
            ::Const.World.TerrainType.Mountains,
        ], 15, 100);

        if (tile != null) {
            camp = ::World.spawnLocation(
                "scripts/entity/world/locations/undead_damned_city_location", tile.Coords);
        }

        if (camp != null)
        {
            local banner = this.getAppropriateBanner(
                camp, _faction.getSettlements(), 25, this.Const.UndeadBanners);
            camp.onSpawned();
            camp.setBanner(banner);
            _faction.addSettlement(camp, false);
            // logInfo("build_undead_camp_action DONE")
        }
    }
})

