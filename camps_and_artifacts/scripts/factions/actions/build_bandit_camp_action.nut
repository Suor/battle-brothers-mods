this.build_bandit_camp_action <- this.inherit("scripts/factions/faction_action", {
	m = {},
	function create()
	{
		this.m.ID = "build_bandit_camp_action";
		this.m.IsRunOnNewCampaign = true;
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		local settlements = _faction.getSettlements();
		logInfo("build_bandit_camp_action.onUpdate settlements "
			+ settlements.len() + " score " + this.m.Score + " " + _faction.getName());

		if (this.World.FactionManager.isCivilWar() && this.World.FactionManager.getGreaterEvilStrength() >= 20.0)
		{
			if (settlements.len() > (this.Const.DLC.Wildmen ? 12 : 16))
			{
				return;
			}
		}
		else if (this.World.FactionManager.isGreaterEvil())
		{
			if (settlements.len() > (this.Const.DLC.Wildmen ? 6 : 8))
			{
				return;
			}
		}
		else if (settlements.len() > (this.Const.DLC.Wildmen ? 9 : 12))
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
		local settlements = _faction.getSettlements();
		logInfo("build_bandit_camp_action.onExecute settlements " + settlements.len()
			 + " " + _faction.getName());
		local camp;
		local r = this.Math.rand(1, 4);
		local maxY = this.Const.DLC.Wildmen ? 0.75 : 1.0;

		if (r == 1)
		{
			local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
				this.Const.World.TerrainType.Mountains,
				this.Const.World.TerrainType.Snow
			], 7, 16, 1000, 7, 7, null, 0.0, maxY);

			if (tile != null)
			{
				camp = this.World.spawnLocation("scripts/entity/world/locations/bandit_camp_location", tile.Coords);
			}
		}
		else if (r == 2)
		{
			local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
				this.Const.World.TerrainType.Mountains,
				this.Const.World.TerrainType.Snow
			], 6, 12, 1000, 7, 7, null, 0.0, maxY);

			if (tile != null)
			{
				camp = this.World.spawnLocation("scripts/entity/world/locations/bandit_hideout_location", tile.Coords);
			}
		}
		else if (r == 3)
		{
			local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
				this.Const.World.TerrainType.Mountains,
				this.Const.World.TerrainType.Snow
			], 10, 20, 1000, 7, 7, null, 0.0, maxY);

			if (tile != null)
			{
				camp = this.World.spawnLocation("scripts/entity/world/locations/bandit_ruins_location", tile.Coords);
			}
		}
		else if (r == 4)
		{
			local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries, [
				this.Const.World.TerrainType.Mountains,
				this.Const.World.TerrainType.Snow
			], 10, 20, 1000, 7, 7, null, 0.0, maxY);

			if (tile != null)
			{
				camp = this.World.spawnLocation("scripts/entity/world/locations/bandit_usurper_location", tile.Coords);
			}
		}

		if (camp != null)
		{
			local banner = this.getAppropriateBanner(camp, _faction.getSettlements(), 15, this.Const.BanditBanners);
			camp.onSpawned();
			camp.setBanner(banner);
			_faction.addSettlement(camp, false);
		}
	}

});

