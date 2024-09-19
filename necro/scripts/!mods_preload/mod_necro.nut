local mod = ::Necro <- {
    ID = "mod_necro"
    Name = "Proper Necro"
    Version = "0.1.0"
}
// local Str = ::std.Str, Text = ::std.Text;

local hmod = ::Hooks.register(mod.ID, mod.Version, mod.Name);
// mod.require("mod_msu >= 1.0.0");
// mod.conflictsWith("mod_bad_mod");
// ::mods_registerMod(mod.ID, mod.Version, mod.Name);
hmod.queue(function() {
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
