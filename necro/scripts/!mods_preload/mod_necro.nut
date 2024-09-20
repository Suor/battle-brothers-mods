local mod = ::Necro <- {
    ID = "mod_necro"
    Name = "Necro (Resurrected)"
    Version = "0.1.0"
}

local hmod = ::Hooks.register(mod.ID, mod.Version, mod.Name);
hmod.queue(function() {
    // if (::Hooks.hasMod("mod_msu")) {
    //     mod.Mod <- ::MSU.Class.Mod(mod.ID, mod.Version, mod.Name);

    //     mod.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.NexusMods,
    //         "https://www.nexusmods.com/battlebrothers/mods/772");
    //     if ("GitHubTags" in ::MSU.System.Registry.ModSourceDomain) {
    //         mod.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.GitHubTags,
    //             "https://github.com/Suor/battle-brothers-mods/tree/master/necro");
    //         mod.Mod.Registry.setUpdateSource(
    //             ::MSU.System.Registry.ModSourceDomain.GitHubTags,
    //             {Prefix = "necro-"}
    //         );
    //     }
    // }

    ::include("necro/skills/actives/raise_undead");

    // Summon necros in swamp, tundra settlements and medium/large too
    hmod.hookTree("scripts/entity/world/settlement", function (q) {
        local num = 0;
        if (q.ClassName.find("_swamp_") != null || q.ClassName.find("_tundra_") != null) num++;
        if (q.ClassName.find("large_") != null) num++;
        if (q.ClassName.find("medium_") != null) num++;

        q.create = @(__original) function () {
            __original();
            for (local i = 0; i < num; i++) this.m.DraftList.push("necro_background");
        }
    })
    // Summon necros during cultist event
    hmod.hook("scripts/entity/world/settlements/situations/cultist_procession_situation",
            function (q) {
        q.onUpdateDraftList = @(__original) function (_draftList) {
            __original(_draftList);
            for (local i = 0; i < 4; i++) _draftList.push("necro_background")
        }
    })
})

// TODO: switch to GithubTags from MSU 1.6.0
hmod.queue(">msu", function () {
     if (!("MSU" in getroottable())) return;
    ::include("necro/hack_msu");
    ::HackMSU.setup(mod, {
        nexus = "https://www.nexusmods.com/battlebrothers/mods/772"
        github = "https://github.com/Suor/battle-brothers-mods/tree/master/necro"
        tagPrefix = "necro-"
    })
});
