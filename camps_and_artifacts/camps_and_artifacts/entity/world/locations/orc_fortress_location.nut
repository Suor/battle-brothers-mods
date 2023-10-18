::mods_hookExactClass("entity/world/locations/orc_fortress_location", function(cls) {
    local create = cls.create;
    cls.create = function () {
        this.location.create();
        this.m.TypeID = "location.orc_fortress";
        // this.m.LocationType = this.Const.World.LocationType.Lair;
        // this.m.CombatLocation.Template[0] = "tactical.orc_camp";
        // this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.None;
        // this.m.CombatLocation.CutDownTrees = true;
        // this.m.IsShowingDefenders = false;
        // this.m.IsShowingBanner = true;
        // this.m.IsDespawningDefenders = false;
        // START NEW CODE
        this.m.LocationType = this.Const.World.LocationType.Lair | this.Const.World.LocationType.Mobile;
        this.setDefenderSpawnList(this.Const.World.Spawn.OrcCEO);
        // END NEW CODE
        this.m.Resources = 500;
        this.m.NamedWeaponsList = this.Const.Items.NamedOrcWeapons;
        this.m.NamedShieldsList = this.Const.Items.NamedOrcShields;
    }

    local onSpawned = cls.onSpawned;
    cls.onSpawned = function () {
        // this.m.Name = "Fortress of the Warlord";
        this.m.Name = "Fortress " + this.World.EntityManager.getUniqueLocationName(this.Const.World.LocationNames.OrcCamp);
        this.location.onSpawned();
        // 
        // for( local i = 0; i < 16; i = ++i )
        // {
        //     this.Const.World.Common.addTroop(this, this.Const.World.Spawn.Troops.OrcYoung, false);
        // }
        // 
        // for( local i = 0; i < 8; i = ++i )
        // {
        //     this.Const.World.Common.addTroop(this, this.Const.World.Spawn.Troops.OrcBerserker, false);
        // }
        // 
        // for( local i = 0; i < 15; i = ++i )
        // {
        //     this.Const.World.Common.addTroop(this, this.Const.World.Spawn.Troops.OrcWarrior, false);
        // }
        // 
        // for( local i = 0; i < 3; i = ++i )
        // {
        //     this.Const.World.Common.addTroop(this, this.Const.World.Spawn.Troops.OrcWarlord, false);
        // }
    }

    local onDropLootForPlayer = cls.onDropLootForPlayer;
    cls.onDropLootForPlayer = function ( _lootTable ) {
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

    local onInit = cls.onInit;
    cls.onInit = function () {
        this.location.onInit();
        local body = this.addSprite("body");
        // body.setBrush("world_orc_camp_04");
        body.setBrush("world_orc_camp_03");
    }

}
