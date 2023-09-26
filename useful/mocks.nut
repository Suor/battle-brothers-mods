// Provide this stubs to enable simple testing

// Game stuff
logInfo <- function(s) {
    print(s + "\n")
}
Const <- {
    // SkillType = {Active = 1}
    // ItemSlot = {Mainhand = 0, Body = 2, Head = 3}
    // CharacterBackgrounds = []
    // CharacterLaborerBackgrounds = []
    // CharacterVillageBackgrounds = []
    // CharacterThiefBackgrounds = []
    // CharacterPiracyBackgrounds = []
    // CharacterVeteranBackgrounds = []
    // Strings = {}
}


// Mod hooks mock
::mods_registerMod <- function (x, y, x) {}
::mods_getRegisteredMod <- function (name) {return false}
::mods_queue <- function (x, y, func) {
    func()
}
::mods_hookClass <- function (x, func) {
    func({});
}
::mods_hookExactClass <- function (x, func) {
    func({
        function create() {}
        function getTooltip() {}
        function onUse() {}
        function canDoubleGrip() {}
    })
}
::mods_hookChildren <- function (x, func) {
    func({})
}
::mods_hookBaseClass <- function (x, func) {
    func({})
}
::mods_hookDescendants <- function (x, func) {
    func({})
}
::mods_hookNewObject <- function (x, func) {
    func({
        setStartValuesEx = @() null
    })
}
::mods_addHook <- function(name, func) {
    func("some/parent", "some/parent/child", {})
}
