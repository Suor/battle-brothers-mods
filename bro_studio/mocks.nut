// Provide this stubs to enable simple testing

// Helpers, maybe should just use stdlib
::Str <- {
    function startswith(s, sub) {
        if (s.len() < sub.len()) return false;
        return s.slice(0, sub.len()) == sub;
    }
    function endswith(s, sub) {
        if (s.len() < sub.len()) return false;
        return s.slice(-sub.len()) == sub;
    }
}

// Basic things
::IO <- {
    _files = null
    function enumerateFiles(prefix) {
        if (this._files == null) this._files = dofile("tests/_files.nut");

        foreach (name in this._files) {
            if (!Str.startswith(name, prefix) || !Str.endswith(name, ".nut")) continue;
            yield name.slice(0, -4)
        }
    }
}
::include <- function (script) {
    return dofile(script + ".nut", true)
}
::new <- function (script) {
    return {}
    return dofile(script + ".nut", true)
    // if (script == "scripts/skills/cursed_skill" || script == "scripts/skills/cursed_effect") {
    //     dofile("../../" + script + ".nut");
    // }

    return {
        script = script
        function getArmor() {return 39}
        function getArmorMax() {return 80}
        function setArmor(val) {}
    }
}
::inherit <- function (super, props) {
    return {
        super = super
        props = props
    }
}
Math <- {
    minf = @(a, b) a <= b ? a : b
    maxf = @(a, b) a >= b ? a : b
    min = @(a, b) (a <= b ? a : b).tointeger()
    max = @(a, b) (a >= b ? a : b).tointeger()
    function rand(min, max) {
        min = floor(min);
        max = floor(max);
        return (min + floor(::rand() * (max - min + 0.99999) / RAND_MAX)).tointeger();
    }
    pow = pow
}

// Game stuff
logInfo <- function(s) {
    print(s + "\n")
}
Const <- {
    SkillType = {Active = 1}
    ItemSlot = {Mainhand = 0, Body = 2, Head = 3}
    CharacterBackgrounds = []
    CharacterLaborerBackgrounds = []
    CharacterVillageBackgrounds = []
    CharacterThiefBackgrounds = []
    CharacterPiracyBackgrounds = []
    CharacterVeteranBackgrounds = []
    Strings = {}
}
Const.CharacterTraits <- [
    [
        "trait.eagle_eyes",
        "scripts/skills/traits/eagle_eyes_trait"
    ],
    [
        "trait.short_sighted",
        "scripts/skills/traits/short_sighted_trait"
    ],
    [
        "trait.tough",
        "scripts/skills/traits/tough_trait"
    ],
    [
        "trait.strong",
        "scripts/skills/traits/strong_trait"
    ],
    [
        "trait.hesitant",
        "scripts/skills/traits/hesitant_trait"
    ],
    [
        "trait.quick",
        "scripts/skills/traits/quick_trait"
    ],
    [
        "trait.tiny",
        "scripts/skills/traits/tiny_trait"
    ],
    [
        "trait.cocky",
        "scripts/skills/traits/cocky_trait"
    ],
    [
        "trait.clumsy",
        "scripts/skills/traits/clumsy_trait"
    ],
    [
        "trait.fearless",
        "scripts/skills/traits/fearless_trait"
    ],
    [
        "trait.fat",
        "scripts/skills/traits/fat_trait"
    ],
    [
        "trait.dumb",
        "scripts/skills/traits/dumb_trait"
    ],
    [
        "trait.bright",
        "scripts/skills/traits/bright_trait"
    ],
    [
        "trait.drunkard",
        "scripts/skills/traits/drunkard_trait"
    ],
    [
        "trait.fainthearted",
        "scripts/skills/traits/fainthearted_trait"
    ],
    [
        "trait.bleeder",
        "scripts/skills/traits/bleeder_trait"
    ],
    [
        "trait.ailing",
        "scripts/skills/traits/ailing_trait"
    ],
    [
        "trait.determined",
        "scripts/skills/traits/determined_trait"
    ],
    [
        "trait.dastard",
        "scripts/skills/traits/dastard_trait"
    ],
    [
        "trait.deathwish",
        "scripts/skills/traits/deathwish_trait"
    ],
    [
        "trait.fragile",
        "scripts/skills/traits/fragile_trait"
    ],
    [
        "trait.insecure",
        "scripts/skills/traits/insecure_trait"
    ],
    [
        "trait.optimist",
        "scripts/skills/traits/optimist_trait"
    ],
    [
        "trait.pessimist",
        "scripts/skills/traits/pessimist_trait"
    ],
    [
        "trait.superstitious",
        "scripts/skills/traits/superstitious_trait"
    ],
    [
        "trait.brave",
        "scripts/skills/traits/brave_trait"
    ],
    [
        "trait.dexterous",
        "scripts/skills/traits/dexterous_trait"
    ],
    [
        "trait.sure_footing",
        "scripts/skills/traits/sure_footing_trait"
    ],
    [
        "trait.asthmatic",
        "scripts/skills/traits/asthmatic_trait"
    ],
    [
        "trait.iron_lungs",
        "scripts/skills/traits/iron_lungs_trait"
    ],
    [
        "trait.craven",
        "scripts/skills/traits/craven_trait"
    ],
    [
        "trait.greedy",
        "scripts/skills/traits/greedy_trait"
    ],
    [
        "trait.gluttonous",
        "scripts/skills/traits/gluttonous_trait"
    ],
    [
        "trait.spartan",
        "scripts/skills/traits/spartan_trait"
    ],
    [
        "trait.athletic",
        "scripts/skills/traits/athletic_trait"
    ],
    [
        "trait.brute",
        "scripts/skills/traits/brute_trait"
    ],
    [
        "trait.irrational",
        "scripts/skills/traits/irrational_trait"
    ],
    [
        "trait.clubfooted",
        "scripts/skills/traits/clubfooted_trait"
    ],
    [
        "trait.loyal",
        "scripts/skills/traits/loyal_trait"
    ],
    [
        "trait.disloyal",
        "scripts/skills/traits/disloyal_trait"
    ],
    [
        "trait.bloodthirsty",
        "scripts/skills/traits/bloodthirsty_trait"
    ],
    [
        "trait.iron_jaw",
        "scripts/skills/traits/iron_jaw_trait"
    ],
    [
        "trait.survivor",
        "scripts/skills/traits/survivor_trait"
    ],
    [
        "trait.impatient",
        "scripts/skills/traits/impatient_trait"
    ],
    [
        "trait.swift",
        "scripts/skills/traits/swift_trait"
    ],
    [
        "trait.night_blind",
        "scripts/skills/traits/night_blind_trait"
    ],
    [
        "trait.night_owl",
        "scripts/skills/traits/night_owl_trait"
    ],
    [
        "trait.paranoid",
        "scripts/skills/traits/paranoid_trait"
    ],
    [
        "trait.hate_greenskins",
        "scripts/skills/traits/hate_greenskins_trait"
    ],
    [
        "trait.hate_undead",
        "scripts/skills/traits/hate_undead_trait"
    ],
    [
        "trait.hate_beasts",
        "scripts/skills/traits/hate_beasts_trait"
    ],
    [
        "trait.fear_beasts",
        "scripts/skills/traits/fear_beasts_trait"
    ],
    [
        "trait.fear_undead",
        "scripts/skills/traits/fear_undead_trait"
    ],
    [
        "trait.fear_greenskins",
        "scripts/skills/traits/fear_greenskins_trait"
    ],
    [
        "trait.teamplayer",
        "scripts/skills/traits/teamplayer_trait"
    ],
    [
        "trait.weasel",
        "scripts/skills/traits/weasel_trait"
    ],
    [
        "trait.huge",
        "scripts/skills/traits/huge_trait"
    ],
    [
        "trait.lucky",
        "scripts/skills/traits/lucky_trait"
    ]
];


local Days = 110;
World <- {
    FactionManager = {
        function getFaction(faction) {
            return {getType = @() faction, ClassName = "undead_faction"}
        }
    }
    Assets = {getCombatDifficulty = @() 1}
    function getTime() {
        return {Days = Days}
    }
}
createColor <- function (color) {return color}

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
        onHired = @() null
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
local function makeInput(cls, name, args) {
    return {
        Class = cls, Name = name, Value = args[0],
        Args = args, Data = {}, Description = ""
        function setDescription(text) {this.Description = text}
        function lock(reason) {}
        function getValue() {
            return this.Value
        }
    }
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
    function RangeSetting(name, ...) {return makeInput("RangeSetting", name, vargv)}
    function BooleanSetting(name, ...) {return makeInput("BooleanSetting", name, vargv)}
    function EnumSetting(name, ...) {return makeInput("EnumSetting", name, vargv)}
    function StringSetting(name, ...) {return makeInput("StringSetting", name, vargv)}
    function SettingsDivider(name, ...) {return makeInput("SettingsDivider", name, vargv)}
    function SettingsSpacer(name, ...) {return makeInput("SettingsSpacer", name, vargv)}
}
