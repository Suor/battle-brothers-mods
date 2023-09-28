::BroGen <- {
    ID = "mod_brogen"
    Name = "BroGen"
    Version = 0.1
    // Flags
    Debug = true
}
::mods_registerMod(::BroGen.ID, ::BroGen.Version, ::BroGen.Name);

::include("brogen/traits");
// ::mods_queue(::BroGen.ID, "mod_hooks(>=20)", function () {
//     ::include("brogen/hackflows_perks");
// })

// Expose this function so that it could be called externally or patched
function BroGen::setupPlayer(_player) {}


::mods_queue(::BroGen.ID, "mod_hooks(>=20)", function() {
    local starting = false;
    ::mods_hookExactClass("entity/tactical/player", function (cls) {
        local baseSetStartValuesEx = cls.setStartValuesEx;
        cls.setStartValuesEx = function ( _backgrounds ) {
            baseSetStartValuesEx(_backgrounds);
            if (!starting) ::BroGen.setupPlayer(this);
        };

        local onHired = cls.onHired;
        cls.onHired = function() {
          onHired();
          ::BroGen.addTraits(this);
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
                ::BroGen.setupPlayer(bro);
                ::BroGen.addTraits(bro);
            }
        }
    });
})
