local mod = ::FixReforged <- {
    ID = "mod_reforged_fix"
    Name = "Reforged Fix"
    Version = 0.1
    // Debug = ::std.Debug.with({prefix = "u: "})
}
// local Util = ::std.Util;
::mods_registerMod(mod.ID, mod.Version, mod.Name);

::mods_queue(mod.ID, "mod_reforged, >mod_hackflows_perks, >msu", function () {
    // Make vanilla backgrounds get dynamic perks
    ::mods_hookExactClass("skills/backgrounds/character_background", function (cls) {
        local create = cls.create;
        cls.create = function () {
            this.m.PerkTreeMultipliers = {
                "pg.rf_resilient": 3,
                "pg.rf_trained": 2,
            };
            this.m.PerkTree = ::new(::DynamicPerks.Class.PerkTree).init({
                DynamicMap = {
                    "pgc.rf_exclusive_1": [],
                    "pgc.rf_shared_1": [],
                    "pgc.rf_weapon": [],
                    "pgc.rf_armor": [],
                    "pgc.rf_fighting_style": []
                }
            });
            create();
        }
    })

    ::mods_hookExactClass("entity/world/player_party", function (cls) {
        local updateStrength = cls.updateStrength;
        cls.updateStrength = function () {
            updateStrength();
            this.m.Strength *= 1.5;
        }
    })
})
