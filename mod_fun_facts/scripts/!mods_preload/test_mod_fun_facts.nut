// Skip this in game
local gt = getroottable();

if ("dofile" in gt) {
    // Provide this stubs to enable simple testing
    logInfo <- function(s) {
        print(s + "\n")
    }
    Const <- {
        SkillType = {Active = 1}
        ItemSlot = {Body = 2, Head = 3}
    }

    // Mod hooks fake
    ::mods_registerMod <- function (x, y, x) {}
    ::mods_queue <- function (x, y, func) {
        func()
    }
    ::mods_hookClass <- function (x, func) {
        func(TacticalEntityManager);
    }
    ::mods_hookBaseClass <- function (x, func) {
        func({})
    }
    ::mods_hookNewObject <- function (x, func) {
        // func({});
    }

    // Load mod script to check for syntax at least
    dofile("mod_vap.nut", true);
}
