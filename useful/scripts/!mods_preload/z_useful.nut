local mod = ::Useful <- {
    ID = "mod_useful"
    Name = "Useful Things"
    Version = 0.1
}
::mods_registerMod(mod.ID, mod.Version, mod.Name);

// This file is named z_* for this to work
local extraDep = ::mods_getRegisteredMod("tnf_refillableNet") ? ", !tnf_refillableNet" : "";

::mods_queue(mod.ID, "stdlib" + extraDep, function() {
    ::include("useful/hand_to_hand");
    ::include("useful/nets");
});

// tnf_resistFXResilient messes up with nets otherwise
::mods_registerMod("tnf_refillableNet", 2.0, "Refillable Nets via Useful Things")
