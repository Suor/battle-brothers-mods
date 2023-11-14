::mods_hookExactClass("entity/world/locations/orc_fortress_location", function(cls) {
    local create = cls.create;
    cls.create = function () {
        create()
        this.m.LocationType = this.Const.World.LocationType.Lair | this.Const.World.LocationType.Mobile;
        this.setDefenderSpawnList(this.Const.World.Spawn.OrcCEO);
    }

    local onSpawned = cls.onSpawned;
    cls.onSpawned = function () {
        this.m.Name = "Fortress " + this.World.EntityManager.getUniqueLocationName(this.Const.World.LocationNames.OrcCamp);
        this.location.onSpawned();
    }

    local onDropLootForPlayer = cls.onDropLootForPlayer;
    cls.onDropLootForPlayer = function (_lootTable) {
        this.location.onDropLootForPlayer(_lootTable);
        this.dropArmorParts(this.Math.rand(25, 50), _lootTable);
        this.dropMedicine(this.Math.rand(0, 6), _lootTable);
        this.dropFood(this.Math.rand(4, 8), [
            "strange_meat_item"
        ], _lootTable);
        this.dropTreasure(this.Math.rand(3, 4), [
            "trade/furs_item",
            "trade/furs_item",
            "trade/uncut_gems_item",
            "trade/dies_item",
            "loot/white_pearls_item"
        ], _lootTable);
        // _lootTable.push(this.new("scripts/items/helmets/legendary/emperors_countenance"));
    }
})
