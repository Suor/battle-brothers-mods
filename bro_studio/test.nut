dofile(getenv("STDLIB_DIR") + "load.nut", true);
dofile("mocks.nut", true);
dofile("scripts/!mods_preload/mod_bro_studio.nut", true);

local Util = ::std.Util, Debug = ::std.Debug;

function assertEq(a, b) {
    if (Util.deepEq(a, b)) return;
    throw "assertEq failed:\na = " + Debug.pp(a) + "b = " + Debug.pp(b);
}

local player = {
    m = {
        Level = 1
        LevelUps = 1
        Attributes = []
        Talents = [0 2 0 2 0 3 0 0]
        Skills = {
            Skills = []
            function hasSkill(id) {return false}
            function add(item) {
                this.Skills.push(item)
            }
        }
    }
    function getName() {
        return "Hackflow"
    }
    function getSkills() {return this.m.Skills}
    function fillAttributeLevelUpValues(_amount, _maxOnly = false, _minOnly = false) {
        if (this.m.Attributes.len() == 0)
        {
            this.m.Attributes.resize(this.Const.Attributes.COUNT);

            for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
            {
                this.m.Attributes[i] = [];
            }
        }

        for( local i = 0; i != this.Const.Attributes.COUNT; i = ++i )
        {
            for( local j = 0; j < _amount; j = ++j )
            {
                if (_minOnly)
                {
                    this.m.Attributes[i].insert(0, 1);
                }
                else if (_maxOnly)
                {
                    this.m.Attributes[i].insert(0, 3);
                }
                else
                {
                    this.m.Attributes[i].insert(0, 2);
                }
            }
        }
    }
    function getBackground() {
        return {
            function getNameOnly() {
                return "Hackflow"
            }
            function onChangeAttributes() {
                return {
                    Hitpoints = [-7, -7]
                    Bravery = [-7, -7]
                    Stamina = [0, 0]
                    Initiative = [15, 20]
                    MeleeSkill = [15, 18]
                    RangedSkill = [10, 10]
                    MeleeDefense = [0, 3]
                    RangedDefense = [10, 10]
                }
            }
            function getExcludedTalents() {
                return [
                    ::Const.Attributes.Initiative,
                    ::Const.Attributes.RangedSkill,
                    ::Const.Attributes.RangedDefense
                ]
            }
            function isUntalented() {return false}
        }
    }
}

local mod = ::BroStudio;
local function setconf(values) {
    foreach (name, value in values) {
        mod.Mod.ModSettings.getSetting(name).Value = value
    }
}


// Attrs
local function genAttributes(_clear = true) {
    if (_clear) player.m.Attributes.clear()
    mod.addAttributeLevelUpValues(player);
    return player.m.Attributes
}

setconf({attrsVeteran = 11, attrsVeteranBoostValue = "off"})
assertEq(genAttributes(), [[2], [2], [2], [2], [2], [2], [2], [2]])

player.m.Level = 12;
assertEq(genAttributes(), []) // 1s will be inserted by default .getAttributeLevelUpValues()

setconf({attrsVeteran = 12})
assertEq(genAttributes(), [[2], [2], [2], [2], [2], [2], [2], [2]])

// Test empty arrays
player.m.Attributes = [[], [], [], [], [], [], [], []];
assertEq(genAttributes(false), [[2], [2], [2], [2], [2], [2], [2], [2]])

// Test 1s filled before
player.m.Attributes = [[1], [1], [1], [1], [1], [1], [1], [1]];
assertEq(genAttributes(false), [[2], [2], [2], [2], [2], [2], [2], [2]])

// Veteran higher than our moved limit
player.m.Level = 13;
assertEq(genAttributes(), [])

// ..., but generating for level 12 = 13 - 2 + 1
player.m.LevelUps = 2;
assertEq(genAttributes(), [[2], [2], [2], [2], [2], [2], [2], [2]])

// Now generating for level 13 = 14 - 2 + 1
player.m.Level = 14;
assertEq(genAttributes(), [])
player.m.LevelUps = 1; // Reset it

// Veteran Boost
player.m.Talents = [3 3 3 3 2 2 1 1];

::rng.reset(11);
setconf({attrsVeteran = 11, attrsVeteranBoostValue = "classic"})
assertEq(genAttributes(), [[2], [2], [1], [3], [1], [2], [1], [2]])

::rng.reset(11);
setconf({attrsVeteran = 11, attrsVeteranBoostValue = "slight"})
assertEq(genAttributes(), [[2], [1], [1], [2], [2], [1], [1], [1]])

::rng.reset(11);
setconf({attrsVeteran = 11, attrsVeteranBoostValue = "high"})
assertEq(genAttributes(), [[2], [2], [2], [3], [2], [2], [1], [1]])
print("Attributes OK\n");


// Perks
for (local l = 1; l <= 22; l++) assertEq(mod.extraPerks(l), 0);

setconf({perksEach = 3, perksNth = 3, perksVeteranNth = 2, perksPreset = "13 16 20"})
assertEq(mod.extraPerks(1), 0)
assertEq(mod.extraPerks(2), 2)
assertEq(mod.extraPerks(3), 2)
assertEq(mod.extraPerks(4), 3)
assertEq(mod.extraPerks(5), 2)
assertEq(mod.extraPerks(6), 2)
assertEq(mod.extraPerks(7), 3)
assertEq(mod.extraPerks(8), 2)
assertEq(mod.extraPerks(9), 2)
assertEq(mod.extraPerks(10), 3)
assertEq(mod.extraPerks(11), 2)
assertEq(mod.extraPerks(12), 0)
assertEq(mod.extraPerks(13), 2)
assertEq(mod.extraPerks(14), 0)
assertEq(mod.extraPerks(15), 1)
assertEq(mod.extraPerks(16), 1)


setconf({perksEach = 1, perksNth = "off", perksVeteranNth = 3, perksPreset = "", perksVeteran = 15})
assertEq(mod.extraPerks(5), 0)
assertEq(mod.extraPerks(11), 0)
assertEq(mod.extraPerks(12), 1)
assertEq(mod.extraPerks(13), 1)
assertEq(mod.extraPerks(14), 1)
assertEq(mod.extraPerks(15), 1)
assertEq(mod.extraPerks(16), 0)
assertEq(mod.extraPerks(17), 0)
assertEq(mod.extraPerks(18), 1)

setconf({perksEach = 2, perksNth = "off", perksVeteranNth = 2, perksPreset = "", perksVeteran = 6})
assertEq(mod.extraPerks(1), 0)
assertEq(mod.extraPerks(2), 1)
assertEq(mod.extraPerks(5), 1)
assertEq(mod.extraPerks(6), 1)
assertEq(mod.extraPerks(7), -1)
assertEq(mod.extraPerks(8), 0)
assertEq(mod.extraPerks(9), -1)
assertEq(mod.extraPerks(10), 0)
assertEq(mod.extraPerks(11), -1)
assertEq(mod.extraPerks(12), 1)
assertEq(mod.extraPerks(13), 0)
print("Perks OK\n");

print("Tests OK\n");
