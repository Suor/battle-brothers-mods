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

    // MSU stubs
    local function makePage(name) {
        return {
            elements = []
            function addElement(elem) {
                this.elements.push(elem);
            }
        }
    }
    local function makeInput(cls, args) {
        return {
            Class = cls, Args = args, Data = {},
            Description = ""
            function setDescription(text) {this.Description = text}
            function lock(reason) {}
        }
    }
    ::MSU <- {};
    ::MSU.Class <- {
        function Mod(id, version, name) {
            return {
                ModSettings = {addPage = makePage}
            }
        }
        function RangeSetting(...) {return makeInput("RangeSetting", vargv)}
        function EnumSetting(...) {return makeInput("EnumSetting", vargv)}
        function StringSetting(...) {return makeInput("StringSetting", vargv)}
        function SettingsDivider(...) {return makeInput("SettingsDivider", vargv)}
        function SettingsSpacer(...) {return makeInput("SettingsSpacer", vargv)}
    }

    // Mod hooks fake
    ::mods_registerMod <- function (x, y, x) {}
    ::mods_getRegisteredMod <- function (name) {return true}
    ::mods_queue <- function (x, y, func) {
        func()
    }
    ::mods_hookClass <- function (x, func) {
        func(TacticalEntityManager);
    }
    ::mods_hookBaseClass <- function (x, func) {
        func({
            function onSpawnAssets() {}
        })
    }
    ::mods_hookNewObject <- function (x, func) {
        // func({});
    }

    // Load mod script to check for syntax at least
    dofile("mod_vap.nut", true);
    print("Tests OK\n");
}
