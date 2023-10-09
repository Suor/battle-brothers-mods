this.build_goblin_camp_action <- this.inherit("scripts/factions/faction_action", {
	m = {},
	function create()
	{
		this.m.ID = "build_goblin_camp_action";
		this.m.IsRunOnNewCampaign = true;
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		local settlements = _faction.getSettlements();

		if (this.World.FactionManager.isGreenskinInvasion() && this.World.FactionManager.getGreaterEvilStrength() >= 20.0)
		{
			if (settlements.len() > 20)
			{
				return;
			}
		}
		else if (settlements.len() > 12)
		{
			return;
		}

		this.m.Score = 2;
	}

	function onClear()
	{
	}

	function onExecute( _faction )
	{
		local camp;
		local r;

		if (_faction.getSettlements().len() == 0)
		{
			r = 7;
		}
		else if (this.World.FactionManager.isGreenskinInvasion())
		{
			r = this.Math.rand(0, 3);
		}
		else
		{
			r = this.Math.rand(1, 6);
		}

		if (r == 0 || r == 1)
		{
			local tile;

			if (this.World.FactionManager.isGreenskinInvasion())
			{
				tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
					this.Const.World.TerrainType.Mountains
				], 8, 20, 20);
			}
			else
			{
				tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
					this.Const.World.TerrainType.Mountains
				], 15, 1000, 20);
			}

			if (tile != null)
			{
				camp = this.World.spawnLocation("scripts/entity/world/locations/goblin_camp_location", tile.Coords);
			}
		}
		else if (r == 2)
		{
			local tile;

			if (this.World.FactionManager.isGreenskinInvasion())
			{
				tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
					this.Const.World.TerrainType.Mountains
				], 12, 30, 20);
			}
			else
			{
				tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
					this.Const.World.TerrainType.Mountains
				], 20, 1000, 20);
			}

			if (tile != null)
			{
				camp = this.World.spawnLocation("scripts/entity/world/locations/goblin_outpost_location", tile.Coords);
			}
		}
		else if (r == 3)
		{
			local tile;

			if (this.World.FactionManager.isGreenskinInvasion())
			{
				tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
					this.Const.World.TerrainType.Mountains
				], 8, 18, 20);
			}
			else
			{
				tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
					this.Const.World.TerrainType.Mountains
				], 14, 30, 20);
			}

			if (tile != null)
			{
				camp = this.World.spawnLocation("scripts/entity/world/locations/goblin_ruins_location", tile.Coords);
			}
		}
		else if (r == 4)
		{
			local tile;

			if (this.World.FactionManager.isGreenskinInvasion())
			{
				tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
					this.Const.World.TerrainType.Mountains
				], 6, 14, 30);
			}
			else
			{
				tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
					this.Const.World.TerrainType.Mountains
				], 10, 20, 30);
			}

			if (tile != null)
			{
				camp = this.World.spawnLocation("scripts/entity/world/locations/goblin_hideout_location", tile.Coords);
			}
		}
		else if (r == 5)
		{
			local disallowedTerrain = [];

			for( local i = 0; i != this.Const.World.TerrainType.COUNT; i = ++i )
			{
				if (i == this.Const.World.TerrainType.Mountains || i == this.Const.World.TerrainType.Hills)
				{
				}
				else
				{
					disallowedTerrain.push(i);
				}
			}

			local tile;

			if (this.World.FactionManager.isGreenskinInvasion())
			{
				tile = this.getTileToSpawnLocation(r == 6 ? 1000 : this.Const.Factions.BuildCampTries, disallowedTerrain, 20, 40, 20);
			}
			else
			{
				tile = this.getTileToSpawnLocation(r == 6 ? 1000 : this.Const.Factions.BuildCampTries, disallowedTerrain, 25, 1000, 20);
			}

			if (tile != null && _faction.getSettlements().len() == 0)
			{
				local orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getSettlements();

				foreach( s in orcs )
				{
					if (s.getTile().getDistanceTo(tile) <= 25)
					{
						return;
					}
				}
			}

			if (tile != null)
			{
				camp = this.World.spawnLocation("scripts/entity/world/locations/goblin_settlement_location", tile.Coords);
			}
		}
		else if (r == 6 || r == 7)
		{
			local disallowedTerrain = [];

			for( local i = 0; i != this.Const.World.TerrainType.COUNT; i = ++i )
			{
				if (i == this.Const.World.TerrainType.Mountains || i == this.Const.World.TerrainType.Hills)
				{
				}
				else
				{
					disallowedTerrain.push(i);
				}
			}

			local tile;

			if (this.World.FactionManager.isGreenskinInvasion())
			{
				tile = this.getTileToSpawnLocation(r == 6 ? 1000 : this.Const.Factions.BuildCampTries, disallowedTerrain, 20, 40, 20);
			}
			else
			{
				tile = this.getTileToSpawnLocation(r == 6 ? 1000 : this.Const.Factions.BuildCampTries, disallowedTerrain, 25, 1000, 20);
			}

			if (tile != null && _faction.getSettlements().len() == 0)
			{
				local orcs = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs).getSettlements();

				foreach( s in orcs )
				{
					if (s.getTile().getDistanceTo(tile) <= 25)
					{
						return;
					}
				}
			}

			if (tile != null)
			{
				camp = this.World.spawnLocation("scripts/entity/world/locations/goblin_warrens_location", tile.Coords);
			}
		}

		if (camp != null)
		{
			local banner = this.getAppropriateBanner(camp, _faction.getSettlements(), 15, this.Const.GoblinBanners);
			camp.onSpawned();
			camp.setBanner(banner);
			_faction.addSettlement(camp, false);
		}
	}

});

