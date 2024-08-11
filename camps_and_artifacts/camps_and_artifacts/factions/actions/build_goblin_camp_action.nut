::mods_hookExactClass("factions/actions/build_goblin_camp_action", function(cls) {
    cls.onUpdate = function( _faction ) {
        local max = 1 + 12; // 1 + compensates weird logic there

        if (this.World.FactionManager.isGreenskinInvasion()
                && this.World.FactionManager.getGreaterEvilStrength() >= 20.0) {
            max += 8;
        }
        max += max / 5; // Add ~20%

        if (_faction.getSettlements().len() >= max) return
        this.m.Score = 2;
    }

    local onExecute = cls.onExecute;
    cls.onExecute = function (_faction) {
        // logInfo("build_goblin_camp_action")
        // 20% chance to build our special camp
        if (::Math.rand(1, 5) > 1) {onExecute(_faction); return}
        // logInfo("build_goblin_camp_action SPECIAL")

        local camp;
        local minY = this.Const.DLC.Desert ? 0.2 : 0.0;
        local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [],
            20, 40, 20, 7, 7, null, minY);

        if (tile != null) {
            camp = this.World.spawnLocation(
                "scripts/entity/world/locations/goblin_warrens_location", tile.Coords);
        }
        if (camp != null) {
            local banner = this.getAppropriateBanner(
                camp, _faction.getSettlements(), 15, ::Const.GoblinBanners);
            camp.onSpawned();
            camp.setBanner(banner);
            _faction.addSettlement(camp, false);
            // logInfo("build_goblin_camp_action DONE")
        }
    }
})
