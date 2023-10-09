this.noble_barracks_location <- this.inherit("scripts/entity/world/location", {
	m = {
	},
	function getDescription()
	{
		return "A barracks of the noble houses, with a regiment of troops training in the yard.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.noble_barracks";
		this.m.LocationType = this.Const.World.LocationType.Lair;
		this.m.CombatLocation.Template[0] = "tactical.human_camp";
		this.m.CombatLocation.CutDownTrees = true;
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.Palisade;
		this.m.IsSpawningDefenders = true;
		this.m.IsAttackable = true;
		this.setDefenderSpawnList(this.Const.World.Spawn.NobleBoss);
		//this.setDefenderSpawnList(this.Const.World.Spawn.BanditDefenders);
		this.m.NamedShieldsList = this.Const.Items.NamedBanditShields;
		this.m.Resources = 300;
		this.m.IsShowingDefenders = true;
		this.m.IsShowingBanner = true;
	}

	function onSpawned()
	{
		this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.CharacterNames) + this.World.EntityManager.getUniqueLocationName([
			"'s Camp",
			"'s Rest",
			"'s Barracks", 
			"'s Muster"
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

	function addSituations()
	{
		return null;
	}

	function isMilitary()
	{
		return false;
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
		body.setBrush("world_fortified_outpost_01");
		local lighting = this.addSprite("lighting");
		lighting.setBrush("world_fortified_outpost_01_light");
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
		this.dropMoney(this.Math.rand(600, 1000), _lootTable);
		this.dropArmorParts(this.Math.rand(30, 45), _lootTable);
		this.dropAmmo(this.Math.rand(0, 70), _lootTable);
		this.dropMedicine(this.Math.rand(0, 20), _lootTable);
		local treasure = [
			"loot/jeweled_crown_item",
			"loot/gemstones_item",
			"loot/golden_chalice_item",
			"loot/ancient_gold_coins_item",
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

