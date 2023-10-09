local mod = ::BroStudio <- {
    ID = "mod_bro_studio"
    Name = "Bro Studio"
    Version = "0.1.0"
    Conf = {}
    Data = {}
    // Flags
    Debug = ::std.Debug.with({prefix = "studio: "})
}
// Expose this function so that it could be called externally or patched
mod.setupPlayer <- function (_player) {}

::mods_registerMod(mod.ID, mod.Version, mod.Name);
// ::mods_queue(mod.ID, "stdlib, mod_hooks(>=20), mod_msu(>=1.2.6), !mod_vap, !mod_ultrabros",
::mods_queue(mod.ID, "stdlib, mod_hooks(>=20), mod_msu(>=1.2.6)",
        function() {
    mod.Mod <- ::MSU.Class.Mod(mod.ID, mod.Version, mod.Name);
    mod.conf <- function (name) {
        return mod.Mod.ModSettings.getSetting(name).getValue();
    }

    // ::include("bro_studio/attrs");
    ::include("bro_studio/traits");

    local starting = false;
    ::mods_hookExactClass("entity/tactical/player", function (cls) {
        local baseSetStartValuesEx = cls.setStartValuesEx;
        cls.setStartValuesEx = function ( _backgrounds ) {
            baseSetStartValuesEx(_backgrounds);
            if (!starting) mod.setupPlayer(this);
        };

        local onHired = cls.onHired;
        cls.onHired = function() {
            onHired();
            mod.addTraits(this);
        }
    });

    // TODO: update this comment
    // On setting up a new campaign all sort of things are hard coded,  typical is to  call
    // .setStartValuesEx() and assign LevelUps and call .fillAttributeLevelUpValues() later,
    // which breaks Gifted
    ::mods_hookExactClass("states/world_state", function (obj) {
        local startNewCampaign = obj.startNewCampaign;
        obj.startNewCampaign = function() {
            starting = true;
            startNewCampaign();
            starting = false;
            local roster = World.getPlayerRoster().getAll();
            foreach (bro in roster) {
                mod.setupPlayer(bro);
                mod.addTraits(bro);
            }
        }
    });
})
