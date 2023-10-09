this.build_barbarian_camp_action <- this.inherit("scripts/factions/faction_action", {
	m = {},
	function create()
	{
		this.m.ID = "build_barbarian_camp_action";
		this.m.IsRunOnNewCampaign = true;
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		local settlements = _faction.getSettlements();

		if (this.World.FactionManager.isGreaterEvil())
		{
			if (settlements.len() > 5)
			{
				return;
			}
		}
		else if (settlements.len() > 7)
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
		local r = this.Math.rand(1, 4);

		if (r == 1)
		{
			local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
				this.Const.World.TerrainType.Mountains
			], 7, 20, 1000, 7, 7, null, 0.75);

			if (tile != null)
			{
				camp = this.World.spawnLocation("scripts/entity/world/locations/barbarian_shelter_location", tile.Coords);
			}
		}
		else if (r == 2)
		{
			local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
				this.Const.World.TerrainType.Mountains
			], 9, 25, 1000, 7, 7, null, 0.75);

			if (tile != null)
			{
				camp = this.World.spawnLocation("scripts/entity/world/locations/barbarian_camp_location", tile.Coords);
			}
		}
		else if (r == 3)
		{
			local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
				this.Const.World.TerrainType.Mountains
			], 13, 35, 1000, 7, 7, null, 0.75);

			if (tile != null)
			{
				camp = this.World.spawnLocation("scripts/entity/world/locations/barbarian_sanctuary_location", tile.Coords);
			}
		}
		else if (r == 4)
		{
			local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
				this.Const.World.TerrainType.Mountains
			], 13, 35, 1000, 7, 7, null, 0.75);

			if (tile != null)
			{
				camp = this.World.spawnLocation("scripts/entity/world/locations/barbarian_sacred_grove_location", tile.Coords);
			}
		}

		if (camp != null)
		{
			local banner = this.getAppropriateBanner(camp, _faction.getSettlements(), 15, this.Const.BarbarianBanners);
			camp.onSpawned();
			camp.setBanner(banner);
			_faction.addSettlement(camp, false);
		}
	}

});

