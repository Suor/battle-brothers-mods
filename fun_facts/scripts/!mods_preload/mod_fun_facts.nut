local mod = ::FunFacts <- {
    ID = "mod_fun_facts"
    Name = "Fun Facts"
    Version = "1.1.0"
    Updates = {
        nexus = "https://www.nexusmods.com/battlebrothers/mods/764"
        github = "https://github.com/Suor/battle-brothers-mods/tree/master/fun_facts"
        tagPrefix = "fun-facts-"
    }
    // In the campaign's flags: ids keep growing through loads, whoever holds the last one
    BattleIdFlag = "FunFacts.BattleId"

    // Switcheroo flags
    LastFallen = null
    Hiring = false
}
mod.getBattleId <- function() {
    // Main-menu scenarios have no campaign, so no battles to number
    if (!("Statistics" in ::World) || ::World.Statistics == null) return 0;
    local id = ::World.Flags.get(this.BattleIdFlag);
    if (id) return id;

    // A save from before the flag continues after its records
    local bros = ::World.getPlayerRoster().getAll();
    local fallen = ::World.Statistics.getFallen();
    local ffs = bros.map(@(b) b.m.FunFacts);
    ffs.extend(fallen.filter(@(_, f) "FunFacts" in f).map(@(f) f.FunFacts));

    local maxId = 0;
    foreach (ff in ffs) {
        local lastId = ff.getLastBattleId();
        if (lastId != null && lastId > maxId) maxId = lastId;
    }

    ::World.Flags.set(this.BattleIdFlag, maxId + 1);
    return maxId + 1;
}
mod.incrBattleId <- function() {
    local id = this.getBattleId();
    if (id) ::World.Flags.set(this.BattleIdFlag, id + 1);
}
mod.s2ff <- function (_skill) {
    local actor = _skill.getContainer().getActor();
     return "FunFacts" in actor.m ? actor.m.FunFacts : {}.setdelegate({_get = @(k) @(...) null});
}

// TODO: finish moving to Modern Hooks, beware of hooks' slightly different semantics
::mods_registerMod(mod.ID, mod.Version, mod.Name);
// Pandora's Hobby replaces town_temple_dialog_module.onTreatInjury wholesale, we wrap it on top
::mods_queue(mod.ID, "mod_hooks(>=20), stdlib(>=2.4), mod_msu(>=1.6.0), >mod_reforged, >mod_pandoras_hobby, >mod_career_stats", function() {
    // Modern Hooks runs this even with a requirement missing, its popup reports that
    if (!("std" in getroottable())) return;
    mod.Debug <- ::std.Debug.with({prefix = "ff: "})
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
