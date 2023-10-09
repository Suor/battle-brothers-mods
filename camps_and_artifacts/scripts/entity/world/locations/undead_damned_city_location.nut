this.undead_damned_city_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "Once a thriving human settlement, this place has been defiled and fallen into ruin, turned into a necropolis of the undead. Waves of walking corpses pour forth to spread terror and fear in the surrounding lands.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.undead_damned_city";
		this.m.LocationType = this.Const.World.LocationType.Lair;
		this.setDefenderSpawnList(this.Const.World.Spawn.UndeadCEO);
		this.m.NamedWeaponsList = this.Const.Items.NamedUndeadWeapons;
		this.m.NamedShieldsList = this.Const.Items.NamedUndeadShields;
		this.m.Resources = 500;
	}

	function onSpawned()
	{
		this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.World.LocationNames.BuriedCastle) + " Exhumed";
		this.location.onSpawned();
	}

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		this.dropArmorParts(this.Math.rand(0, 60), _lootTable);
		this.dropTreasure(this.Math.rand(3, 4), [
			"loot/white_pearls_item",
			"loot/jeweled_crown_item",
			"loot/gemstones_item",
			"loot/golden_chalice_item",
			"loot/ancient_gold_coins_item"
		], _lootTable);
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("world_townhall_03_ruins");
	}

});

