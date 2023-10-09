this.noble_stronghold_location <- this.inherit("scripts/entity/world/location", {
	m = {
	},
	function getDescription()
	{
		return "A stronghold of the noble houses.  An army waits behind its gates and untold riches in its keep";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.noble_stronghold";
		this.m.LocationType = this.Const.World.LocationType.Lair;
		this.m.CombatLocation.Template[0] = "tactical.human_camp";
		this.m.CombatLocation.CutDownTrees = true;
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.Palisade;
		this.m.IsSpawningDefenders = true;
		this.m.IsAttackable = true;
		this.setDefenderSpawnList(this.Const.World.Spawn.NobleCEO);
		//this.setDefenderSpawnList(this.Const.World.Spawn.BanditDefenders);
		this.m.NamedShieldsList = this.Const.Items.NamedBanditShields;
		this.m.Resources = 500;
		this.m.IsShowingDefenders = true;
		this.m.IsShowingBanner = true;
	}

	function onSpawned()
	{
		this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.CharacterNames) + this.World.EntityManager.getUniqueLocationName([
			"'s Bulwark",
			"'s Fortress",
			"'s Holdfast", 
			"'s Castle"
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
		body.setBrush("world_stronghold_02");
		local lighting = this.addSprite("lighting");
		lighting.setBrush("world_stronghold_02_light");
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
		this.dropMoney(this.Math.rand(1600, 2000), _lootTable);
		this.dropArmorParts(this.Math.rand(45, 54), _lootTable);
		this.dropAmmo(this.Math.rand(0, 100), _lootTable);
		this.dropMedicine(this.Math.rand(0, 40), _lootTable);
		local treasure = [
			"loot/jeweled_crown_item",
			"loot/gemstones_item",
			"loot/golden_chalice_item",
			"loot/ancient_gold_coins_item"
		];

		if (this.Const.DLC.Unhold)
		{
			treasure.extend(treasure);
			treasure.extend(treasure);
			treasure.extend(treasure);
			treasure.extend(treasure);
			treasure.extend(treasure);
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

