this.build_noble_camp_action <- this.inherit("scripts/factions/faction_action", {
	m = {},
	function create()
	{
		this.m.ID = "build_noble_camp_action";
		this.m.IsRunOnNewCampaign = true;
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		local num = _faction.ca_getCamps().len();
		if (num >= 12) return;
		this.m.Score = 2;
	}

	function onExecute( _faction )
	{
		local camp;
		local r = this.Math.rand(1, 3);
		local minY = this.Const.DLC.Desert ? 0.2 : 0.0;
		local maxY = 1.0;

		local scripts = [
			"scripts/entity/world/locations/noble_tower_location"
			"scripts/entity/world/locations/noble_barracks_location"
			"scripts/entity/world/locations/noble_stronghold_location"
		]
		local script = scripts[Math.rand(0, scripts.len() - 1)]
		local tile = this.getTileToSpawnLocation(100, [], 1, 9, 9, 2, 2, null, minY, maxY);
		if (tile != null) {
			camp = this.World.spawnLocation(script, tile.Coords);
		}

		if (camp != null)
		{
			local banner = "banner_noble_"+_faction.getBannerString();
			camp.onSpawned();
			camp.setFaction( _faction.m.ID )
			camp.setBanner(banner);
			_faction.ca_addCamp(camp);
		}
	}
})
