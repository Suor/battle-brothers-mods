this.bandit_usurper_location <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "The bastard son of some noble has taken up residence in this abandoned stronghold.  He is raising an army to invade the civilized lands.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.bandit_usurper";
		this.m.LocationType = this.Const.World.LocationType.Lair;
		this.m.IsDespawningDefenders = false;
		this.setDefenderSpawnList(this.Const.World.Spawn.BanditCEO);
		this.m.Resources = 400;
		this.m.NamedShieldsList = this.Const.Items.NamedBanditShields;
	}

	function onSpawned()
	{
		this.m.Name = "New " + this.World.EntityManager.getUniqueLocationName([
			"Hohenfeste",
			"Wolfenfeste",
			"Wolfenstein",
			"Felsfeste",
			"Eisenfeste",
			"Grollfeste",
			"Grubenfeste",
			"Donnerfeste",
			"Erzfeste",
			"Gronenfeste",
			"Sattelfeste",
			"Kammfeste",
			"Turmfeste",
			"Windfeste",
			"Adlerfeste",
			"Brunwald",
			"Heldenfeste",
			"Wurmfeste",
			"Schwertfeste",
			"Lanzenfeste",
			"Falkenstein",
			"Flechtenstein",
			"Himmelsfeste",
			"Steinturm",
			"Gipfelfeste",
			"Zugfeste",
			"Granitfeste",
			"Zinnenfeste",
			"Wackersfeste",
			"Fernsichtfeste",
			"Wildbergfeste"
		]);
		this.location.onSpawned();
	}

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		this.dropMoney(this.Math.rand(2000, 5000), _lootTable);
		this.dropArmorParts(this.Math.rand(50, 80), _lootTable);
		this.dropAmmo(this.Math.rand(30, 100), _lootTable);
		this.dropMedicine(this.Math.rand(10, 30), _lootTable);
		local treasure = [
			"trade/furs_item",
			"trade/copper_ingots_item",
			"trade/cloth_rolls_item",
			"trade/salt_item",
			"trade/amber_shards_item",
			"loot/silverware_item",
			"loot/silver_bowl_item",
			"loot/jeweled_crown_item",
			"loot/signet_ring_item"
		];

		if (this.Const.DLC.Unhold)
		{
			treasure.extend(treasure);
			treasure.extend(treasure);
			treasure.extend(treasure);
			treasure.push("armor_upgrades/metal_plating_upgrade");
			treasure.push("armor_upgrades/metal_pauldrons_upgrade");
			treasure.push("armor_upgrades/mail_patch_upgrade");
			treasure.push("armor_upgrades/leather_shoulderguards_upgrade");
			treasure.push("armor_upgrades/leather_neckguard_upgrade");
			treasure.push("armor_upgrades/joint_cover_upgrade");
			treasure.push("armor_upgrades/heraldic_plates_upgrade");
			treasure.push("armor_upgrades/double_mail_upgrade");
		}

		this.dropFood(this.Math.rand(2, 4), [
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
		this.dropTreasure(this.Math.rand(1, 2), treasure, _lootTable);

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
		body.setBrush("world_stronghold_03_ruins");
	}

});

