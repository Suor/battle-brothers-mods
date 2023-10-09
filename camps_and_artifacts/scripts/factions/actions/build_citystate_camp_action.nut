this.build_citystate_camp_action <- this.inherit("scripts/factions/faction_action", {
	m = {},
	function create()
	{
		this.m.ID = "build_citystate_camp_action";
		this.m.IsRunOnNewCampaign = true;
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		local settlements = _faction.getSettlements();
		// logInfo("build_citystate_camp_action.onExecute settlements " + settlements.len()
		//  + " score " + this.m.Score + " " + _faction.getName());

		if (this.World.FactionManager.isCivilWar() && this.World.FactionManager.getGreaterEvilStrength() >= 20.0)
		{
			if (settlements.len() > (this.Const.DLC.Wildmen ? 4 : 5))
			{
				return;
			}
		}
		else if (this.World.FactionManager.isGreaterEvil())
		{
			if (settlements.len() > (this.Const.DLC.Wildmen ? 4 : 5))
			{
				return;
			}
		}
		else if (settlements.len() > (this.Const.DLC.Wildmen ? 4 : 5))
		{
			return;
		}

		this.m.Score = 2;
	}

	function onClear()
	{
	}

	function setFaction( _faction )
	{
		this.m.Faction = this.WeakTableRef(_faction);		
	}

	function onExecute( _faction )
	{
		local settlements = _faction.getSettlements();
		logInfo("build_citystate_camp_action.onExecute settlements " + settlements.len()
			+ " " + _faction.getName());
		local camp;
		local r = this.Math.rand(1, 3);
		local minY = 0.0;
		local maxY = 1.0;

		if (r == 1)
		{
			local tile = this.getTileToSpawnLocation(100, [], 1, 9, 9, 2, 1, null, minY, maxY);
			if (tile != null)
			{	
				camp = this.World.spawnLocation("scripts/entity/world/locations/citystate_tower_location", tile.Coords);
			}
		}
		else if (r == 2)
		{
			local tile = this.getTileToSpawnLocation(100, [], 1, 9, 9, 2, 1, null, minY, maxY);

			if (tile != null)
			{
				camp = this.World.spawnLocation("scripts/entity/world/locations/citystate_barracks_location", tile.Coords);
			}
		}
		else if (r == 3)
		{
			local tile = this.getTileToSpawnLocation(100, [], 1, 9, 9, 2, 1, null, minY, maxY);

			if (tile != null)
			{
				camp = this.World.spawnLocation("scripts/entity/world/locations/citystate_stronghold_location", tile.Coords);
			}
		}

		if (camp != null)
		{
			local banner = "banner_noble_"+_faction.getBannerString();
			camp.onSpawned();
			camp.setFaction( _faction.m.ID )
			camp.setBanner(banner);
			_faction.addSettlement(camp, false);
		}
		logInfo("END build_citystate_camp_action.onExecute settlements " + settlements.len()
			+ " " + _faction.getName());
	}

});

