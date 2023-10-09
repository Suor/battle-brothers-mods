this.citystate_tower_location <- this.inherit("scripts/entity/world/location", {
	m = {
	},
	function getDescription()
	{
		return "A watchtower of the noble houses, the eyes by which the nobles keep watch over their lands";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.citystate_tower";
		this.m.LocationType = this.Const.World.LocationType.Lair;
		this.m.CombatLocation.Template[0] = "tactical.human_camp";
		this.m.CombatLocation.CutDownTrees = true;
		this.m.IsSpawningDefenders = true;
		this.m.IsAttackable = true;
		this.setDefenderSpawnList(this.Const.World.Spawn.Southern);
		//this.setDefenderSpawnList(this.Const.World.Spawn.BanditDefenders);
		this.m.NamedShieldsList = this.Const.Items.NamedSouthernShields;
		this.m.Resources = 170;
		this.m.IsShowingDefenders = true;
		this.m.IsShowingBanner = true;
	}

	function onSpawned()
	{
		this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.SouthernOfficerTitles) + this.World.EntityManager.getUniqueLocationName([
			"'s Tower",
			"'s Post",
			"'s Watch", 
			"'s Refuge"
			]);
		this.location.onSpawned();
	}

	function updateSituations()
	{
		return false
	}

	function hasSituation( _id )
	{
		return false
	}

	function isMilitary()
	{
		return false;
	}

	function getAttachedLocations()
	{
		return [];
	}

	function getSituations()
	{
		return [];
	}

	function addSituations()
	{
		return null;
	}

	function isIsolatedFromRoads()
	{
		return true;
	}

	function isConnectedToByRoads( _s )
	{
		return false;
	}

	function isIsolated()
	{
		return false;
	}
	
	function isCoastal()
	{
		return false;
	}

	function getSize()
	{
		return 0
	}

	function getActiveAttachedLocations()
	{
		return []
	}

	function onInit()
	{
		this.location.onInit();
		local banner = this.addSprite("banner");
		this.setSpriteOffset("banner", this.createVec(-8, 55));
		local body = this.addSprite("body");
		body.setBrush("world_southern_watchtower");
		local lighting = this.addSprite("lighting");
		lighting.setBrush("world_southern_watchtower_lights");
		this.registerThinker();
	}

	function onFinish()
	{
		this.location.onFinish();
		this.unregisterThinker();
	}

	function isParty()
	{
		return true;
	}

	function getController()
	{
		return null;
	}

	function onUpdate()
	{
		local lighting = this.getSprite("lighting");

		if (lighting.IsFadingDone)
		{
			if (lighting.Alpha == 0 && this.World.getTime().TimeOfDay >= 4 && this.World.getTime().TimeOfDay <= 7)
			{
				lighting.Color = this.createColor("ffffff00");

				if (this.World.getCamera().isInsideScreen(this.getPos(), 0))
				{
					lighting.fadeIn(5000);
				}
				else
				{
					lighting.Alpha = 255;
				}
			}
			else if (lighting.Alpha != 0 && this.World.getTime().TimeOfDay >= 0 && this.World.getTime().TimeOfDay <= 3)
			{
				if (this.World.getCamera().isInsideScreen(this.getPos(), 0))
				{
					lighting.fadeOut(4000);
				}
				else
				{
					lighting.Alpha = 0;
				}
			}
		}
	}

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		this.dropMoney(this.Math.rand(200, 500), _lootTable);
		this.dropArmorParts(this.Math.rand(15, 30), _lootTable);
		this.dropAmmo(this.Math.rand(0, 30), _lootTable);
		this.dropMedicine(this.Math.rand(0, 5), _lootTable);
		local treasure = [
			"trade/furs_item",
			"trade/copper_ingots_item",
			"trade/cloth_rolls_item",
			"trade/salt_item",
			"trade/amber_shards_item",
			"loot/silverware_item",
			"loot/silver_bowl_item",
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

	function onSerialize( _out )
	{
		this.location.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.location.onDeserialize(_in);
	}

});

