this.location <- this.inherit("scripts/entity/world/world_entity", {
	m = {
		Description = "",
		LocationType = 0,
		TypeID = "",
		Banner = "banner_beasts_01",
		DefenderSpawnList = null,
		DefenderSpawnDay = 0,
		RoamerSpawnList = null,
		CombatLocation = null,
		Resources = 0,
		LastSpawnTime = -1000.0,
		Loot = null,
		NamedWeaponsList = null,
		NamedShieldsList = null,
		NamedArmorsList = null,
		NamedHelmetsList = null,
		ArtifactList = null,
		OnDiscovered = null,
		OnEnter = null,
		OnDestroyed = null,
		OnEnterCallback = null,
		IsSpawningDefenders = true,
		IsDespawningDefenders = true,
		IsScalingDefenders = true,
		IsShowingDefenders = true,
		IsShowingBanner = true,
		IsShowingLabel = false,
		IsVisited = false,
		IsBattlesite = false,
		IsDroppingLoot = true
	},
	function isLocationType( _t )
	{
		return (this.m.LocationType & _t) != 0;
	}

	function getLocationType()
	{
		return this.m.LocationType;
	}

	function getTypeID()
	{
		return this.m.TypeID;
	}

	function isLocation()
	{
		return true;
	}

	function isEnterable()
	{
		return false;
	}

	function isIsolated()
	{
		return false;
	}

	function isActive()
	{
		return true;
	}

	function isShowingDefenders()
	{
		return this.m.IsShowingDefenders || this.World.Assets.getOrigin().getID() == "scenario.rangers";
	}

	function isVisited()
	{
		return this.m.IsVisited;
	}

	function getBanner()
	{
		return this.m.Banner;
	}

	function getDescription()
	{
		return this.m.Description;
	}

	function getResources()
	{
		return this.m.Resources;
	}

	function getLoot()
	{
		return this.m.Loot;
	}

	function getCombatLocation()
	{
		return this.m.CombatLocation;
	}

	function getStrength()
	{
		if (this.m.Strength != 0)
		{
			return this.m.Strength;
		}
		else
		{
			return this.m.Resources;
		}
	}

	function getRoamerSpawnList()
	{
		if (this.m.RoamerSpawnList != null)
		{
			return this.m.RoamerSpawnList;
		}
		else
		{
			return this.m.DefenderSpawnList;
		}
	}

	function getLastSpawnTime()
	{
		return this.m.LastSpawnTime;
	}

	function setDefenderSpawnList( _l )
	{
		this.m.DefenderSpawnList = _l;
	}

	function setResources( _r )
	{
		this.m.Resources = _r;
	}

	function setActive( _f )
	{
	}

	function setVisited( _f )
	{
		this.m.IsVisited = _f;
	}

	function setDropLoot( _l )
	{
		this.m.IsDroppingLoot = _l;
	}

	function setOnEnterCallback( _c )
	{
		this.m.OnEnterCallback = _c;
	}

	function getOnEnterCallback()
	{
		return this.m.OnEnterCallback;
	}

	function getDefenderSpawnList()
	{
		return this.m.DefenderSpawnList;
	}

	function resetDefenderSpawnDay()
	{
		this.m.DefenderSpawnDay = this.World.getTime().Days;
	}

	function getOwner()
	{
		return null;
	}

	function addFaction( _f )
	{
		this.setFaction(_f);
	}

	function removeFaction( _f )
	{
		this.setFaction(0);
	}

	function create()
	{
		this.world_entity.create();
		this.m.IsAttackable = true;
		this.m.IsAttackableByAI = false;
		this.m.IsShowingStrength = false;
		this.m.CombatLocation = clone this.Const.Tactical.LocationTemplate;
		this.m.CombatLocation.Template = clone this.Const.Tactical.LocationTemplate.Template;
		this.m.Loot = this.new("scripts/items/stash_container");
		this.m.Loot.setResizable(true);
	}

	function setLastSpawnTimeToNow()
	{
		this.m.LastSpawnTime = this.Time.getVirtualTimeF();
		this.m.DefenderSpawnDay = 0;

		if (!this.isHiddenToPlayer())
		{
			this.onVisibleToPlayer();
		}
	}

	function spawnFireAndSmoke( _pos = null )
	{
		if (_pos == null)
		{
			_pos = this.getPos();
		}

		if (this.Const.World.SmokeParticles.len() != 0)
		{
			local smoke = this.Const.World.SmokeParticles;

			for( local i = 0; i < smoke.len(); i = ++i )
			{
				this.World.spawnParticleEffect(smoke[i].Brushes, smoke[i].Delay, smoke[i].Quantity, smoke[i].LifeTime, smoke[i].SpawnRate, smoke[i].Stages, this.createVec(_pos.X, _pos.Y - 30), -200 + this.Const.World.ZLevel.Particles);
			}

			local fire = this.Const.World.FireParticles;

			for( local i = 0; i < fire.len(); i = ++i )
			{
				this.World.spawnParticleEffect(fire[i].Brushes, fire[i].Delay, fire[i].Quantity, fire[i].LifeTime, fire[i].SpawnRate, fire[i].Stages, this.createVec(_pos.X, _pos.Y - 30), -200 + this.Const.World.ZLevel.Particles - 3);
			}
		}
	}

	function setBanner( _banner )
	{
		this.m.Banner = _banner;

		if (this.hasSprite("location_banner"))
		{
			this.getSprite("location_banner").setBrush(_banner);
		}
	}

	function getTooltip()
	{

		if (this.m.IsSpawningDefenders && this.m.DefenderSpawnList != null && this.m.Resources != 0)
		{
			if (!(this.m.Troops.len() != 0 && this.m.DefenderSpawnDay != 0 && this.World.getTime().Days - this.m.DefenderSpawnDay < 10))
			{
				this.createDefenders();
			}
		}

		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];

		if (!this.isAlliedWithPlayer())
		{
			if (this.isShowingDefenders() && !this.isHiddenToPlayer() && this.m.Troops.len() != 0 && this.getFaction() != 0)
			{
				ret.extend(this.getTroopComposition());
			}
			else
			{
				ret.push({
					id = 20,
					type = "text",
					icon = "ui/orientation/player_01_orientation.png",
					text = "Unknown garrison"
				});
			}

			ret.push({
				id = 21,
				type = "hint",
				icon = "ui/orientation/terrain_orientation.png",
				text = "This location is " + this.Const.Strings.TerrainAlternative[this.getTile().Type]
			});

			if (this.isShowingDefenders() && this.getCombatLocation().Template[0] != null && this.getCombatLocation().Fortification != 0 && !this.getCombatLocation().ForceLineBattle)
			{
				ret.push({
					id = 20,
					type = "hint",
					icon = "ui/orientation/palisade_01_orientation.png",
					text = "This location has fortifications"
				});
			}
		}

		return ret;
	}

	function getSounds( _all = true )
	{
		return [];
	}

	function setLootScaleBasedOnResources( _r )
	{
		local resources = this.m.Resources * this.Math.minf(3.0, 1.0 + this.World.getTime().Days * 0.0075) * this.Const.Difficulty.EnemyMult[this.World.Assets.getCombatDifficulty()];
		this.m.LootScale = this.Math.minf(1.0, _r / resources);
	}

	function onEnter()
	{
		if (!this.m.IsVisited && this.m.OnEnter != null)
		{
			this.m.IsVisited = true;
			this.World.Events.fire(this.m.OnEnter);
			return false;
		}
		else if (this.m.OnEnterCallback != null)
		{
			this.m.OnEnterCallback(this);
			return false;
		}
		else
		{
			this.m.IsVisited = true;
			return true;
		}
	}

	function onLeave()
	{
	}

	function onRaided()
	{
	}

	function onBeforeCombatStarted()
	{
		this.world_entity.onBeforeCombatStarted();

		if (this.m.IsSpawningDefenders && this.m.DefenderSpawnList != null && this.m.Resources != 0)
		{
			if (this.m.Troops.len() != 0 && this.m.DefenderSpawnDay != 0 && this.World.getTime().Days - this.m.DefenderSpawnDay < 10)
			{
				return;
			}

			this.createDefenders();
		}

		if (this.m.Troops.len() == 0)
		{
			this.logWarning("Location forfeited combat - no defenders in spawnlist!");
			this.onCombatLost();
		}
	}

	function onCombatLost()
	{
		local tile = this.getTile();

		if (this.m.IsDestructible && this.m.IsBattlesite)
		{
			if (this.Const.World.TerrainScript[tile.Type] != "")
			{
				tile.clearAllBut(this.Const.World.DetailType.Road | this.Const.World.DetailType.Shore | this.Const.World.DetailType.Footprints);
				local t = this.MapGen.get(this.Const.World.TerrainScript[tile.Type]);
				t.fill({
					X = tile.SquareCoords.X,
					Y = tile.SquareCoords.Y,
					W = 1,
					H = 1,
					IsEmpty = false
				}, null, 2);

				if (tile.HasRoad && "onRoadPass" in t)
				{
					t.onRoadPass({
						X = tile.SquareCoords.X,
						Y = tile.SquareCoords.Y,
						W = 1,
						H = 1,
						IsEmpty = false
					});
				}
			}
		}

		if (this.m.IsDestructible)
		{
			this.World.EntityManager.onWorldEntityDestroyed(this, true);
		}

		this.world_entity.onCombatLost();

		if (this.m.IsDestructible && !this.m.IsBattlesite)
		{
			local battlefield = this.World.spawnLocation("scripts/entity/world/locations/battlefield_location", tile.Coords);
			battlefield.setSize(1);
		}

		if (this.m.OnDestroyed != null)
		{
			this.World.Events.fire(this.m.OnDestroyed);
			this.m.IsVisited = true;
			return false;
		}
	}

	function onCombatWon()
	{
		this.world_entity.onCombatWon();

		if (this.m.IsDespawningDefenders)
		{
			this.m.Troops = [];
		}
	}

	function onDropLootForPlayer( _lootTable )
	{
		this.world_entity.onDropLootForPlayer(_lootTable);
		local loot = this.m.Loot.getItems();

		foreach( item in loot )
		{
			if (item != null)
			{
				_lootTable.push(item);
			}
		}
	}

	function onSpawned()
	{
		local nearestSettlement = 9000;
		local myTile = this.getTile();

		foreach( s in this.World.EntityManager.getSettlements() )
		{
			local d = myTile.getDistanceTo(s.getTile());

			if (d < nearestSettlement)
			{
				nearestSettlement = d;
			}
		}

		if (!this.isLocationType(this.Const.World.LocationType.Unique))
		{
			local num = 0;

			local artifact_chance = ((this.m.Resources + nearestSettlement * 4) / 5.0 - 37.0) * ((this.m.Resources + nearestSettlement * 4) / 5.0 - 37.0) / 2;
			local artifact_roll = this.Math.rand(1, 10000);
			if (artifact_roll <= artifact_chance)
			{
				local artifacts = clone this.Const.Items.Artifacts;

				this.m.Loot.add(this.new("scripts/items/" + artifacts[this.Math.rand(0, artifacts.len() - 1)]));
				this.logWarning("Spawned an Artifact!");
				num = 3;
			}

			for( local chance = (this.m.Resources + nearestSettlement * 4) / 5.0 - 37.0; num < 2;  )
			{
				local r = this.Math.rand(1, 100);

				if (r <= chance)
				{
					chance = chance - r;
					num = ++num;
					local type = this.Math.rand(20, 100);

					if (type <= 40)
					{
						local weapons = clone this.Const.Items.NamedWeapons;

						if (this.m.NamedWeaponsList != null && this.m.NamedWeaponsList.len() != 0)
						{
							weapons.extend(this.m.NamedWeaponsList);
							weapons.extend(this.m.NamedWeaponsList);
						}

						this.m.Loot.add(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
					}
					else if (type <= 60)
					{
						local shields = clone this.Const.Items.NamedShields;

						if (this.m.NamedShieldsList != null && this.m.NamedShieldsList.len() != 0)
						{
							shields.extend(this.m.NamedShieldsList);
							shields.extend(this.m.NamedShieldsList);
						}

						this.m.Loot.add(this.new("scripts/items/" + shields[this.Math.rand(0, shields.len() - 1)]));
					}
					else if (type <= 80)
					{
						local helmets = clone this.Const.Items.NamedHelmets;

						if (this.m.NamedHelmetsList != null && this.m.NamedHelmetsList.len() != 0)
						{
							helmets.extend(this.m.NamedHelmetsList);
							helmets.extend(this.m.NamedHelmetsList);
						}

						this.m.Loot.add(this.new("scripts/items/" + helmets[this.Math.rand(0, helmets.len() - 1)]));
					}
					else if (type <= 100)
					{
						local armor = clone this.Const.Items.NamedArmors;

						if (this.m.NamedArmorsList != null && this.m.NamedArmorsList.len() != 0)
						{
							armor.extend(this.m.NamedArmorsList);
							armor.extend(this.m.NamedArmorsList);
						}

						this.m.Loot.add(this.new("scripts/items/" + armor[this.Math.rand(0, armor.len() - 1)]));
					}
				}
				else
				{
					break;
				}
			}
		}
	}

	function onInit()
	{
		this.world_entity.onInit();
		this.setRenderedTop(false);
		this.setVisibleInFogOfWar(true);

		if (this.m.LocationType != this.Const.World.LocationType.Settlement)
		{
			this.World.EntityManager.addLocation(this);
		}

		this.getTile().IsOccupied = true;
		local label_name = this.addLabel("name");
		label_name.Visible = false;
		label_name.Text = this.getName();
	}

	function onAfterInit()
	{
		local selection = this.addSprite("location_banner");
		selection.Visible = this.m.IsShowingBanner;
		this.setSpriteScaling("location_banner", false);
		this.world_entity.onAfterInit();
		this.onUpdate();
	}

	function onFinish()
	{
		this.world_entity.onFinish();
		this.getTile().IsOccupied = false;

		if (this.m.LocationType != this.Const.World.LocationType.Settlement)
		{
			this.World.EntityManager.removeLocation(this);
		}

		if (this.World.FactionManager.getFaction(this.getFaction()) != null && this.m.LocationType != this.Const.World.LocationType.AttachedLocation)
		{
			this.World.FactionManager.getFaction(this.getFaction()).removeSettlement(this);
		}
	}

	function onDiscovered()
	{
		this.world_entity.onDiscovered();
		this.getTile().clearAllBut(this.Const.World.DetailType.Road | this.Const.World.DetailType.Shore);
		this.getLabel("name").Visible = this.Const.World.AI.VisualizeNameOfLocations && this.m.IsShowingLabel;

		if (!this.isHiddenToPlayer() && this.getTypeID() != "location.battlefield")
		{
			this.World.Statistics.getFlags().increment("LocationsDiscovered");

			if (this.World.Retinue.hasFollower("follower.cartographer"))
			{
				this.World.Retinue.getFollower("follower.cartographer").onLocationDiscovered(this);
			}

			this.World.Ambitions.onLocationDiscovered(this);
		}

		if (this.m.OnDiscovered != null)
		{
			this.World.Events.fire(this.m.OnDiscovered);
		}
	}

	function onVisibleToPlayer()
	{
		if (!this.m.IsSpawningDefenders || this.m.DefenderSpawnList == null || this.isAlliedWithPlayer())
		{
			return;
		}

		if (this.m.Troops.len() != 0 && this.m.DefenderSpawnDay != 0 && this.World.getTime().Days - this.m.DefenderSpawnDay < 10)
		{
			return;
		}

		this.createDefenders();
	}

	function createDefenders()
	{
		local resources = this.m.Resources;

		if (this.m.IsScalingDefenders)
		{
			resources = resources * this.Math.minf(3.0, 1.0 + this.World.getTime().Days * 0.0075);
		}

		if (!this.isAlliedWithPlayer())
		{
			resources = resources * this.Const.Difficulty.EnemyMult[this.World.Assets.getCombatDifficulty()];
		}

		if (this.Time.getVirtualTimeF() - this.m.LastSpawnTime <= 60.0)
		{
			resources = resources * 0.75;
		}

		local best;
		local bestCost = -9000;

		foreach( party in this.m.DefenderSpawnList )
		{
			if (party.Cost > resources)
			{
				continue;
			}

			if (best == null || party.Cost > bestCost)
			{
				best = party;
				bestCost = party.Cost;
			}
		}

		local potential = [];

		foreach( party in this.m.DefenderSpawnList )
		{
			if (party.Cost > resources || party.Cost < bestCost * 0.75)
			{
				continue;
			}

			potential.push(party);
		}

		if (potential.len() != 0)
		{
			best = potential[this.Math.rand(0, potential.len() - 1)];
		}

		if (best == null)
		{
			bestCost = 9000;

			foreach( party in this.m.DefenderSpawnList )
			{
				if (this.Math.abs(party.Cost - resources) < bestCost)
				{
					best = party;
					bestCost = this.Math.abs(party.Cost - resources);
				}
			}
		}

		if (best != null)
		{
			this.m.Troops = [];

			if (this.Time.getVirtualTimeF() - this.m.LastSpawnTime <= 60.0)
			{
				this.m.DefenderSpawnDay = this.World.getTime().Days - 7;
			}
			else
			{
				this.m.DefenderSpawnDay = this.World.getTime().Days;
			}

			foreach( t in best.Troops )
			{
				for( local i = 0; i != t.Num; i = ++i )
				{
					this.Const.World.Common.addTroop(this, t, false);
				}
			}

			this.updateStrength();
		}
	}

	function onSerialize( _out )
	{
		this.world_entity.onSerialize(_out);
		_out.writeU32(this.m.DefenderSpawnDay);
		_out.writeF32(this.m.LastSpawnTime);
		_out.writeU16(this.m.Resources);
		_out.writeString(this.m.Banner);
		_out.writeBool(this.m.IsVisited);
		this.m.Loot.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.world_entity.onDeserialize(_in);
		this.m.DefenderSpawnDay = _in.readU32();
		this.m.LastSpawnTime = _in.readF32();
		this.m.Resources = _in.readU16();
		this.m.Banner = _in.readString();
		this.m.IsVisited = _in.readBool();
		this.m.Loot.onDeserialize(_in);
		this.getLabel("name").Visible = this.Const.World.AI.VisualizeNameOfLocations && this.m.IsShowingLabel;
		this.onUpdate();
	}

});

