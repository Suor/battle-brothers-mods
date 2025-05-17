local mod = ::FunFacts <- {
    ID = "mod_fun_facts"
    Name = "Fun Facts"
    Version = "1.0.0"
    Updates = {
        nexus = "https://www.nexusmods.com/battlebrothers/mods/764"
        github = "https://github.com/Suor/battle-brothers-mods/tree/master/fun_facts"
        tagPrefix = "fun-facts-"
    }
    BattleId = null

    // Switcheroo flags
    LastFallen = null
    Hiring = false
}
mod.Debug <- ::std.Debug.with({prefix = "ff: "})
mod.getBattleId <- function() {
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
mod.incrBattleId <- function() {
    if (this.BattleId) this.BattleId++;
}
mod.s2ff <- function (_skill) {
    local actor = _skill.getContainer().getActor();
     return "FunFacts" in actor.m ? actor.m.FunFacts : {}.setdelegate({_get = @(k) @(...) null});
}

::mods_registerMod(mod.ID, mod.Version, mod.Name);
::mods_queue(mod.ID, "mod_hooks(>=20), stdlib(>=2.4), mod_msu(>=1.6.0), >mod_reforged", function() {
    mod.Mod <- ::MSU.Class.Mod(mod.ID, mod.Version, mod.Name);

    local msd = ::MSU.System.Registry.ModSourceDomain, upd = mod.Updates;
    mod.Mod.Registry.addModSource(msd.NexusMods, upd.nexus);
    mod.Mod.Registry.addModSource(msd.GitHubTags, upd.github, {Prefix = upd.tagPrefix});
    mod.Mod.Registry.setUpdateSource(msd.GitHubTags);


    // local currentStatGetter;

    // local function compareByStat(_a, _b)
    // {
    //     return _b.m.FunFacts_Stats[currentStatGetter]() <=> _a.m.FunFacts_Stats[currentStatGetter]();
    // }

    // mod.evaluateRanks = function()
    // {
    //     if (mod.IsLoading) return;
    //     local bros = ::World.getPlayerRoster().getAll();
    //     local ranks = clone mod.DummyStats.m.Ranks;
    //     foreach (statKey, statArray in mod.DummyStats.m.Ranks)
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

    mod.Mod.Tooltips.setTooltips({
        Fallen = ::MSU.Class.CustomTooltip(
            @(_data) ::World.Statistics.FunFacts_getTooltipForFallen(_data.FunFacts_Idx))
    });

    foreach (file in ::IO.enumerateFiles("fun_facts")) ::include(file);
    ::mods_registerJS("fun_facts/world_obituary_screen.js");
    ::mods_registerCSS("fun_facts.css");
});
