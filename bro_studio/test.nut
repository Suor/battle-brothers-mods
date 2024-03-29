dofile("mocks.nut", true);
dofile("scripts/!mods_preload/!stdlib.nut", true);
dofile("scripts/!mods_preload/mod_bro_studio.nut", true);

local Util = ::std.Util, Debug = ::std.Debug;

function assertEq(a, b) {
    if (Util.deepEq(a, b)) return;
    throw "assertEq failed:\na = " + Debug.pp(a) + "b = " + Debug.pp(b);
}

local player = {
    m = {
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
    function fillAttributeLevelUpValues(level) {}
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
local function assertSkillsNum(num) {
    assertEq(player.getSkills().Skills.len(), num);
    player.getSkills().Skills = [];
}

// Traits
mod.addTraits(player)
assertSkillsNum(0)

::rng.reset(6);
mod.addTraits(player, {num = 1})
assertSkillsNum(1)

::rng.reset(77);
mod.addTraits(player, {num = 3})
assertSkillsNum(3)

// Stupid mode
::rng.reset(77);
mod.addTraits(player, {num = 1, bad = false, stupid = true})
assertSkillsNum(4)
print("Traits OK\n");

// Talents
::rng.reset(9);
mod.fillTalentValues(player, 4);

::rng.reset(9);
mod.fillTalentValues(player, 4, {excluded = "ignored"});

::rng.reset(9);
mod.fillTalentValues(player, 6, {excluded = "strict"});

::rng.reset(9);
mod.fillTalentValues(player, 6, {excluded = "relaxed"});
assertEq(player.m.Talents, [1 1 2 0 1 0 2 1])

::rng.reset(9);
mod.fillTalentValues(player, 6, {excluded = "ignored"});
assertEq(player.m.Talents, [0 0 1 1 2 1 2 1])

::rng.reset(9);
mod.fillTalentValues(player, 4, {weighted = true});
assertEq(player.m.Talents, [0, 1, 3, 0, 3, 0, 2, 0])

::rng.reset(9);
mod.fillTalentValues(player, 6, {weighted = true, excluded = "relaxed"});
assertEq(player.m.Talents, [1 2 1 0 1 0 3 1])

::rng.reset(9);
mod.fillTalentValues(player, 6, {weighted = true, excluded = "strict"});
assertEq(player.m.Talents, [2 1 2 0 1 0 3 0])

::rng.reset(9);
mod.fillTalentValues(player, 6, {weighted = true, excluded = "ignored"});
assertEq(player.m.Talents, [0 0 1 1 1 1 2 3])
print("Talents OK\n");

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
