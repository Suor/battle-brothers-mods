local mod = ::Useful <- {
    ID = "mod_useful"
    Name = "Useful Things"
    Version = 0.4
    Debug = ::std.Debug.with({prefix = "u: "})
}
local Util = ::std.Util;
::mods_registerMod(mod.ID, mod.Version, mod.Name);

// A universal item attrs hook
mod.hookItem <- function (script, values) {
    ::mods_hookExactClass(script, function (cls) {mod.hookItemClass(cls, values)})
}
mod.hookItemClass <- function (cls, values) {
    // Reforged/MSU thing breaking named items
    local setValuesBeforeRandomize = Util.getMember(cls, "setValuesBeforeRandomize");
    if (setValuesBeforeRandomize) {
        cls.setValuesBeforeRandomize <- function (_values) {
            Util.extend(_values, values);
            setValuesBeforeRandomize(_values);
        }
        return;
    }

    // Named items
    local randomizeValues = Util.getMember(cls, "randomizeValues");
    if (randomizeValues) {
        cls.randomizeValues <- function () {
            Util.extend(this.m, values);
            randomizeValues();
        }
        return;
    }

    // Normal items
    local create = cls.create;
    cls.create = function () {
        create();
        Util.extend(this.m, values);
    }
}

// This file is named z_* for this to work
local extraDep = ::mods_getRegisteredMod("tnf_refillableNet") ? ", !tnf_refillableNet" : "";

::mods_queue(mod.ID, "stdlib(>=2.0), >mod_msu, >mod_reforged, >sato_balance_mod" + extraDep, function() {
    ::include("useful/flails");
    ::include("useful/goblin");
    ::include("useful/hand_to_hand");
    ::include("useful/nets");
});

// tnf_resistFXResilient messes up with nets otherwise
::mods_registerMod("tnf_refillableNet", 2.0, "Refillable Nets via Useful Things")
