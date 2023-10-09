this.goblin_warrens_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "A goblin warrens breaks ground here. An underground civilization spanning miles of tunnels stands ready to defend it.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.goblin_warrens";
		this.m.LocationType = this.Const.World.LocationType.Lair;
		this.m.IsDespawningDefenders = false;
		this.setDefenderSpawnList(this.Const.World.Spawn.GoblinCEO);
		this.m.Resources = 500;
	}

	function onSpawned()
	{
		this.m.Name = "Great " + this.World.EntityManager.getUniqueLocationName(this.Const.World.LocationNames.GoblinBase);
		this.location.onSpawned();
	}

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		this.dropMoney(this.Math.rand(0, 100), _lootTable);
		this.dropArmorParts(this.Math.rand(10, 20), _lootTable);
		this.dropAmmo(this.Math.rand(25, 100), _lootTable);
		this.dropMedicine(this.Math.rand(0, 10), _lootTable);
		this.dropFood(this.Math.rand(4, 8), [
			"strange_meat_item",
			"roots_and_berries_item",
			"pickled_mushrooms_item"
		], _lootTable);
		this.dropTreasure(this.Math.rand(2, 3), [
			"trade/salt_item",
			"trade/dies_item",
			"trade/amber_shards_item",
			"loot/silverware_item",
			"loot/silver_bowl_item",
			"loot/ancient_gold_coins_item",
			"loot/silver_bowl_item",
			"loot/signet_ring_item",
			"loot/goblin_carved_ivory_iconographs_item",
			"loot/goblin_minted_coins_item",
			"loot/goblin_rank_insignia_item"
		], _lootTable);
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_goblin_camp_04");
	}

});

