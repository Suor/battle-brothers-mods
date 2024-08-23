// Provide this stubs to enable simple testing.
// Requires stdlib/tests/mocks.nut to be loaded first.

// Game stuff
logInfo <- function(s) {
    print(s + "\n")
}
::Const.XP <- {
    MaxLevelWithPerkpoints = 11
}

// Mod hooks mock
::mods_registerMod <- function (x, y, z = null) {}
::mods_getRegisteredMod <- function (name) {return false}
::mods_queue <- function (x, y, func) {
    func()
}
::mods_hookClass <- function (x, func) {
    func({});
}
::mods_hookExactClass <- function (x, func) {
    func({
        startNewCampaign = @() null
        setStartValuesEx = @() null
        fillTalentValues = @() null
        onHired = @() null
        updateLevel = @() null
        getAttributeLevelUpValues = @() null
    })
}
::mods_hookChildren <- function (x, func) {
    func({})
}
::mods_hookBaseClass <- function (x, func) {
    func({
        starting_scenario = {
            function onSpawnAssets() {}
        }
    })
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
::mods_registerJS <- function (name) {}

::rng_new <- ::std.rng_new;
::rng <- ::rng_new(1);


// Mock MSU
local function makePage(name) {
    local settings = this;
    local page = {
        elements = []
        function addElement(elem) {
            this.elements.push(elem);
            settings.inputs[elem.Name] <- elem;
        }
    }
    this.pages.push(page);
    return page;
}
::Mocks <- {};
::Mocks.Input <- class {
    Name = null
    Value = null
    Description = ""
    Data = {}
    constructor (_id, ...) {
        this.Name = _id;
        this.Value = vargv.len() > 0 ? vargv[0] : null;
    }
    function setDescription(text) {this.Description = text}
    function lock(reason) {}
    function getValue() {return this.Value}
}
::MSU <- {};
::MSU.Class <- {
    function Mod(id, version, name) {
        return {
            ModSettings = {
                pages = []
                inputs = {}
                addPage = makePage
                function getSetting(name) {
                    return this.inputs[name];
                }
            }
        }
    }
    RangeSetting = class extends ::Mocks.Input { Type = "Range" }
    BooleanSetting = class extends ::Mocks.Input { Type = "Boolean" }
    EnumSetting = class extends ::Mocks.Input { Type = "Enum" }
    StringSetting = class extends ::Mocks.Input { Type = "String" }
    SettingsTitle = class extends ::Mocks.Input { Type = "Title" }
    SettingsDivider = class extends ::Mocks.Input { Type = "Divider" }
    SettingsSpacer = class extends ::Mocks.Input { Type = "Spacer" }
}
