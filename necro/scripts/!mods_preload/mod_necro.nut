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

    // Summon necros in swamp and tundra settlements
    hmod.hookTree("scripts/entity/world/settlement", function (q) {
        if (q.ClassName.find("__swamp__") == null && q.ClassName.find("__tundra__") == null)
            return;

        local num = 1;
        if (q.ClassName.find("large_") != null) num += 3;
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
