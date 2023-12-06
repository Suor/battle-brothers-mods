// Provide this stubs to enable simple testing

// Game stuff
logInfo <- function(s) {
    print(s + "\n")
}
if (!("Const" in getroottable())) ::Const <- {};
Const.Strings <- {
    PerkDescription = {SpecFlail = ""}
}
Const.Perks <- {
    LookupMap = {"perk.mastery.flail": {Tooltip = "..."}}
}

// Mod hooks mock
::mods_registerMod <- function (x, y, z=null) {}
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
        function isUsable() {}
        function canDoubleGrip() {}
        function onAfterUpdate() {}
        function onAnySkillUsed() {}
        function onEquip() {}
        function onUpdate() {}
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
