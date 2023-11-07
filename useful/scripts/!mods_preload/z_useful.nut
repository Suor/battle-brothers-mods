local mod = ::Useful <- {
    ID = "mod_useful"
    Name = "Useful Things"
    Version = 0.2
    Debug = ::std.Debug.with({prefix = "u: "})
}
local Util = ::std.Util;
::mods_registerMod(mod.ID, mod.Version, mod.Name);

local function getMember(table, key) {
    while (!(key in table) && "SuperName" in table) table = table[table.SuperName];
    return key in table ? table[key] : null;
}

// A universal item attrs hook
mod.hookItem <- function (script, values) {
    ::mods_hookExactClass(script, function (cls) {mod.hookItemClass(cls, values)})
}
mod.hookItemClass <- function (cls, values) {
    local randomizeValues = getMember(cls, "randomizeValues");
    if (randomizeValues) {
        cls.randomizeValues <- function () {
            Util.extend(this.m, values);
            randomizeValues();
        }
    } else {
        local create = cls.create;
        cls.create = function () {
            create();
            Util.extend(this.m, values);
        }
    }
}

// This file is named z_* for this to work
local extraDep = ::mods_getRegisteredMod("tnf_refillableNet") ? ", !tnf_refillableNet" : "";

::mods_queue(mod.ID, "stdlib, >sato_balance_mod" + extraDep, function() {
    ::include("useful/flails");
    ::include("useful/goblin");
    ::include("useful/hand_to_hand");
    ::include("useful/nets");
});

// tnf_resistFXResilient messes up with nets otherwise
::mods_registerMod("tnf_refillableNet", 2.0, "Refillable Nets via Useful Things")
