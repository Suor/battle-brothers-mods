this.barbarian_sacred_grove_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "One of the sacred pillars of the barbarian tribes.  The greatest warriors of the north will defend this site if it is threatened.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.barbarian_sacred_grove";
		this.m.LocationType = this.Const.World.LocationType.Lair;
		this.m.IsDespawningDefenders = false;
		this.setDefenderSpawnList(this.Const.World.Spawn.BarbarianCEO);
		this.m.Resources = 500;
		this.m.NamedWeaponsList = this.Const.Items.NamedBarbarianWeapons;
		this.m.NamedArmorsList = this.Const.Items.NamedBarbarianArmors;
		this.m.NamedHelmetsList = this.Const.Items.NamedBarbarianHelmets;
	}

	function onSpawned()
	{
		this.m.Name = "Sacred " + this.World.EntityManager.getUniqueLocationName(this.Const.World.LocationNames.BarbarianSanctuary);
		this.location.onSpawned();
	}

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		this.dropMoney(this.Math.rand(600, 1200), _lootTable);
		this.dropArmorParts(this.Math.rand(40, 60), _lootTable);
		this.dropAmmo(this.Math.rand(0, 50), _lootTable);
		this.dropMedicine(this.Math.rand(10, 25), _lootTable);
		local treasure = [
			"trade/furs_item",
			"trade/furs_item",
			"trade/amber_shards_item",
			"trade/amber_shards_item",
			"loot/silverware_item",
			"loot/silver_bowl_item",
			"loot/bone_figurines_item",
			"loot/valuable_furs_item",
			"loot/bead_necklace_item",
			"loot/looted_valuables_item"
			"loot/valuable_furs_item",
			"loot/bead_necklace_item",
			"loot/looted_valuables_item"
		];
		this.dropFood(this.Math.rand(4, 8), [
			"bread_item",
			"beer_item",
			"dried_fruits_item",
			"ground_grains_item",
			"roots_and_berries_item",
			"pickled_mushrooms_item",
			"smoked_ham_item",
			"mead_item",
			"cured_venison_item",
			"goat_cheese_item"
		], _lootTable);
		this.dropTreasure(this.Math.rand(3, 5), treasure, _lootTable);

		if (this.Const.DLC.Unhold && this.Math.rand(1, 100) <= 10)
		{
			local treasure = [];
			treasure.push("misc/paint_set_item");
			treasure.push("misc/paint_black_item");
			treasure.push("misc/paint_red_item");
			treasure.push("misc/paint_orange_red_item");
			treasure.push("misc/paint_white_blue_item");
			treasure.push("misc/paint_white_green_yellow_item");
			this.dropTreasure(1, treasure, _lootTable);
		}
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_fountain_of_youth");
	}

});

