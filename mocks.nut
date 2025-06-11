dofile(getenv("STDLIB_DIR") + "load.nut", true); // Also have some mocks, like Math

Math.rand <- @(a, b) ::std.rng.next(a, b);

// Game stuff
::Const.XP <- {
    MaxLevelWithPerkpoints = 11
}
// Game stuff
World <- {
    function getTime() {
        return {Days = 10}
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
            Registry = {
                function addModSource(_domain, _url, _opts = {}) {}
                function setUpdateSource(_domain) {}
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
::MSU.System <- {
    Registry = {
        ModSourceDomain = {NexusMods = "NexusMods", GitHubTags = "GithubTags"}
    }
}
