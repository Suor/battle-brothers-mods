::FunFacts <- {
    ID = "mod_fun_facts"
    Name = "Fun Facts"
    Version = "0.1.2"
	// ActiveUser = null,
	// ActiveTarget = null,
	// MinHitChance = 5,
	// MaxHitChance = 95,
	// evaluateRanks = null,
	// DummyStats = ::new("scripts/mods/fun_facts/fun_facts")
	// IsLoading = false,
	LastFallen = null
};
::FunFacts.Debug <- ::std.Debug.with({prefix = "ff: "})

::mods_registerMod(::FunFacts.ID, ::FunFacts.Version, ::FunFacts.Name);
::mods_queue(::FunFacts.ID, "mod_msu(>=1.2.0)", function() {
	::FunFacts.Mod <- ::MSU.Class.Mod(::FunFacts.ID, ::FunFacts.Version, ::FunFacts.Name);

	::FunFacts.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.GitHub, "https://github.com/Suor/battle-brothers-mods");
	// ::FunFacts.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.NexusMods, "https://www.nexusmods.com/battlebrothers/mods/...");
	::FunFacts.Mod.Registry.setUpdateSource(::MSU.System.Registry.ModSourceDomain.GitHub);

	// local currentStatGetter;

	// local function compareByStat(_a, _b)
	// {
	// 	return _b.m.FunFacts_Stats[currentStatGetter]() <=> _a.m.FunFacts_Stats[currentStatGetter]();
	// }

	// ::FunFacts.evaluateRanks = function()
	// {
	// 	if (::FunFacts.IsLoading) return;
	// 	local bros = ::World.getPlayerRoster().getAll();
	// 	local ranks = clone ::FunFacts.DummyStats.m.Ranks;
	// 	foreach (statKey, statArray in ::FunFacts.DummyStats.m.Ranks)
	// 	{
	// 		local clonedBros = clone bros;
	// 		ranks[statKey] = clonedBros;
	// 		currentStatGetter = "get" + statKey;
	// 		clonedBros.sort(compareByStat);

	// 		local lastChange = 0;
	// 		for (local i = 0; i < clonedBros.len(); ++i)
	// 		{
	// 			if (clonedBros[i].m.FunFacts_Stats[currentStatGetter]() != clonedBros[lastChange].m.FunFacts_Stats[currentStatGetter]())
	// 			{
	// 				lastChange = i;
	// 			}
	// 			clonedBros[i].m.FunFacts_Stats.m.Ranks[statKey] = lastChange + 1;
	// 		}
	// 	}
	// }

	::FunFacts.Mod.Tooltips.setTooltips({
		Fallen = ::MSU.Class.CustomTooltip(@(_data) ::World.Statistics.FunFacts_getTooltipForFallen(_data.FunFacts_Idx))
	});

	foreach (file in ::IO.enumerateFiles("fun_facts")) {
		this.logInfo("ff: loading " + file);
		::include(file);
	}
	// ::include("fun_facts/actor");
	// ::include("fun_facts/player");
	// ::include("fun_facts/player_corpse_stub");
	// ::include("fun_facts/stats_collector");
	// ::include("fun_facts/statistics_manager");
	// ::include("fun_facts/tactical_state");
	// ::include("fun_facts/world_obituary_screen");
	// ::include("fun_facts/world_player_roster");
	// ::include("fun_facts/world_state");

	::mods_registerJS("fun_facts/world_obituary_screen.js");
});
