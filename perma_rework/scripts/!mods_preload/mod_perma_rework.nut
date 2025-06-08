local def = ::PermaRework <- {
    ID = "mod_perma_rework"
    Name = "Permanent Injuries Rework"
    Version = "2.0.0"
    Updates = {
        nexus = "https://www.nexusmods.com/battlebrothers/mods/..."
        github = "https://github.com/Suor/battle-brothers-mods/tree/master/perma-rework"
        tagPrefix = "perma-rework-"
    }
}

// ::include("perma_rework/rosetta_ru");

local mod = def.mh <- ::Hooks.register(def.ID, def.Version, def.Name);
mod.queue(function () {
    foreach (file in ::IO.enumerateFiles("perma_rework")) ::include(file);

    for (local i = 0; i < 8; i++) // TODO: remove after debugging
    Const.Injury.Permanent.push({
        ID = "injury.missing_hand",
        Script = "injury_permanent/missing_hand_injury"
    })
})
