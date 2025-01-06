// Game stuff
logInfo <- function(s) {
    print(s + "\n")
}
logWarning <- function(s) {
    print("WARN: " + s + "\n")
}
::include <- function (script) {
    return dofile(script + ".nut", true)
}
Math.rand <- @(a, b) ::std.rng.next(a, b);

local Days = 10;
World <- {
    // FactionManager = {
    //     function getFaction(faction) {
    //         return {getType = @() faction, ClassName = "undead_faction"}
    //     }
    // }
    // Assets = {getCombatDifficulty = @() 1}
    function getTime() {
        return {Days = Days}
    }
}

// Modern Hooks mocks
local mod = {
    function require(...) {}
    function conflictWith(...) {}
    function queue(...) {
        local func = vargv.pop();
        if (typeof func == "integer") func = vargv.pop();
        func();
    }
    function hook(_filename, _func) {
        _func({}.setdelegate({_set = @(k,v) null}))
    }
    function hookTree(_filename, _func) {
        _func({}.setdelegate({_set = @(k,v) null}))
    }
}
::Hooks <- {
    JSFiles = []
    QueueBucket = {VeryLate = 4}
    function register(_id, _version, _name) {return mod}
    function getMod(_id) {return mod}
    function hasMod(_id) {return true}
    function registerJS(_filename) {}
    function registerCSS(_filename) {}
}
