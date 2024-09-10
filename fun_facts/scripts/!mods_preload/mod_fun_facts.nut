::FunFacts <- {
    ID = "mod_fun_facts"
    Name = "Fun Facts"
    Version = "0.2.0"
    LastFallen = null
    BattleId = null
};
::FunFacts.Debug <- ::std.Debug.with({prefix = "ff: "})
::FunFacts.getBattleId <- function() {
    if (this.BattleId) return this.BattleId;

    local bros = ::World.getPlayerRoster().getAll();
    local fallen = ::World.Statistics.getFallen();
    local ffs = bros.map(@(b) b.m.FunFacts);
    ffs.extend(fallen.filter(@(_, f) "FunFacts" in f).map(@(f) f.FunFacts));

    local maxId = 0;
    foreach (ff in ffs) {
        local lastId = ff.getLastBattleId();
        if (lastId != null && lastId > maxId) maxId = lastId;
    }

    this.BattleId = maxId + 1;
    return this.BattleId;
}
::FunFacts.incrBattleId <- function() {
    if (this.BattleId) this.BattleId++;
}

::mods_registerMod(::FunFacts.ID, ::FunFacts.Version, ::FunFacts.Name);
::mods_queue(::FunFacts.ID, "stdlib(>=1.51), mod_msu(>=1.2.0)", function() {
    ::FunFacts.Mod <- ::MSU.Class.Mod(::FunFacts.ID, ::FunFacts.Version, ::FunFacts.Name);

    ::FunFacts.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.GitHub, "https://github.com/Suor/battle-brothers-mods");
    // ::FunFacts.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.NexusMods, "https://www.nexusmods.com/battlebrothers/mods/...");
    ::FunFacts.Mod.Registry.setUpdateSource(::MSU.System.Registry.ModSourceDomain.GitHub);


    // local currentStatGetter;

    // local function compareByStat(_a, _b)
    // {
    //     return _b.m.FunFacts_Stats[currentStatGetter]() <=> _a.m.FunFacts_Stats[currentStatGetter]();
    // }

    // ::FunFacts.evaluateRanks = function()
    // {
    //     if (::FunFacts.IsLoading) return;
    //     local bros = ::World.getPlayerRoster().getAll();
    //     local ranks = clone ::FunFacts.DummyStats.m.Ranks;
    //     foreach (statKey, statArray in ::FunFacts.DummyStats.m.Ranks)
    //     {
    //         local clonedBros = clone bros;
    //         ranks[statKey] = clonedBros;
    //         currentStatGetter = "get" + statKey;
    //         clonedBros.sort(compareByStat);

    //         local lastChange = 0;
    //         for (local i = 0; i < clonedBros.len(); ++i)
    //         {
    //             if (clonedBros[i].m.FunFacts_Stats[currentStatGetter]() != clonedBros[lastChange].m.FunFacts_Stats[currentStatGetter]())
    //             {
    //                 lastChange = i;
    //             }
    //             clonedBros[i].m.FunFacts_Stats.m.Ranks[statKey] = lastChange + 1;
    //         }
    //     }
    // }

    ::FunFacts.Mod.Tooltips.setTooltips({
        Fallen = ::MSU.Class.CustomTooltip(
            @(_data) ::World.Statistics.FunFacts_getTooltipForFallen(_data.FunFacts_Idx))
    });

    foreach (file in ::IO.enumerateFiles("fun_facts")) ::include(file);
    ::mods_registerJS("fun_facts/world_obituary_screen.js");
});
