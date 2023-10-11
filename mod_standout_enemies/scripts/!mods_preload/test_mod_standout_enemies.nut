// Skip this in game
local gt = getroottable();

if ("dofile" in gt) {
    // Provide this stubs to enable simple testing
    ::include <- function (script) {
        return dofile("../../" + script + ".nut", true)
    }
    logInfo <- function(s) {
        print(s + "\n")
    }
    Const <- {
        SkillType = {Active = 1}
        ItemSlot = {Mainhand = 0, Body = 2, Head = 3, Ammo = 4}
        Items = {AmmoType = {Arrows = 1}}
    }
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
    Math <- {
        minf = @(a, b) a <= b ? a : b
        maxf = @(a, b) a >= b ? a : b
        min = @(a, b) (a <= b ? a : b).tointeger()
        max = @(a, b) (a >= b ? a : b).tointeger()
        function rand(min, max) {
            min = floor(min);
            max = floor(max);
            return (min + floor(gt.rand() * (max - min + 0.99999) / RAND_MAX)).tointeger();
        }
        pow = pow
    }
    new <- function (script) {
        if (script == "scripts/skills/cursed_skill" || script == "scripts/skills/cursed_effect") {
            dofile("../../" + script + ".nut");
        }

        return {
            script = script
            m = {ID = split(script, "/").top(), Value = 150}
            function getID() {return this.m.ID}
            function getName() {return "Fake New Item"}
            function getArmor() {return 39}
            function getArmorMax() {return 80}
            function setArmor(val) {}
        }
    }
    inherit <- function (super, props) {
        return {
            super = super
            props = props
        }
    }
    createColor <- function (color) {return color}

    // Test run setupEntity for fake party
    local TacticalEntityManager = {setupEntity = function (e, t) {
        print("original: setupEntity for " + t.Script + "\n")
    }};
    function makeEntity(t) {
        local name = t.Script.slice(4).toupper();
        return {
            ClassName = name
            m = {
                Name = name
                XP = 100
                IsResurrected = false
                ResurrectionChance = 66
                ResurrectionValue = 2.0
                DecapitateBloodAmount = 1.0
                BaseProperties = {
                    ActionPoints = 7
                    MeleeSkill = 50
                    RangedSkill = 50
                    MeleeDefense = -5
                    RangedDefense = -5
                    Stamina = 100
                    FatigueRecoveryRate = 20
                    Initiative = 40
                    DamageTotalMult = 1.0
                    HitpointsMult = 1.0
                    Bravery = 40
                    BraveryMult = 1.0
                    IsAffectedByNight = true
                    HitChance = [25 75]
                    DamageReceivedTotalMult = 1.0
                    MovementAPCostMult = 1.0
                    MovementFatigueCostMult = 1.0
                }
                Items = {
                    function getItemAtSlot(s) {
                        return Math.rand(0, 1) ? null : {
                            m = {
                                ID = "weapon.crossbow"
                                Value = 350
                                AmmoType = ::Const.Items.AmmoType.Arrows
                            }
                            function getName() {return "Fake Item"}
                            function getArmor() {return 39}
                            function getArmorMax() {return 80}
                            function setArmor(val) {}
                            function getUpgrade() {return null}
                            function setUpgrade(val) {}
                        }
                    }
                    function equip(item) {}
                    function unequip(item) {}
                }
                Skills = {
                    m = {Skills = []}
                    function add(_skill, _order = 0) {}
                    function removeByID (id) {}
                    function update() {}
                    function getAllSkillsOfType(type) {
                        return [
                            makeSkill("actives.raise_undead", {ActionPointCost = 3, FatigueCost = 10})
                            makeSkill("actives.knock", {ActionPointCost = 4, FatigueCost = 15})
                        ]
                    }
                    function getSkillByID(_id) {
                        if (_id == "effects.berserker_rage") {
                            return {addRage = @(r) r}
                        }
                        return null;
                    }
                }
                AIAgent = {
                    function addBehavior (behavior) {}
                }
            }
            getName = @() this.m.Name
            setHitpointsPct = @(h) h
            function hasSprite(part) {
                return true;
            }
            function getSprite(part) {
                return {
                    Scale = 1.0
                    Color = "#FFFFFF"
                    Saturation = 1.0
                    setBrightness = @(b) b
                    Visible = true
                }
            }
            function getSkills() {
                return this.m.Skills
            }
            function getFlags() {
                return {
                    function has(tag) {return false}
                }
            }
            function isAbleToWait() {return true}
            function getAIAgent() {
                return {
                    function addBehavior(_b) {}
                }
            }
        };
    }

    function makeParty(name, faction, troopScripts) {
        local party = {
            m = {
                Troops = troopScripts.map(@(t) {Script = ".../" + t, Variant = 0})
            }
            getName = @() name
            getFaction = @() faction
        };
        foreach (t in party.m.Troops) {
            t.Party <- party.weakref();
        }
        return party
    }

    function makeSkill(id, props) {
        return {
            m = ::std.Util.merge({ID = id}, props)
            b = clone props
            function getID() {return this.m.ID}
        }
    }

    // Mod hooks fake
    ::mods_registerMod <- function (x, y, z=null) {}
    ::mods_queue <- function (x, y, func) {
        func()
    }
    ::mods_hookClass <- function (x, func) {
        func(TacticalEntityManager);
    }
    ::mods_hookBaseClass <- function (x, func) {
        func({onDeath = null, actor = {onResurrected = null}})
    }
    ::mods_hookExactClass <- function (x, func) {
        func({spawnGoblin = null})
    }

    // Load mod script to check for syntax at least
    dofile("../../scripts/!mods_preload/!stdlib.nut", true);
    dofile("mod_standout_enemies.nut", true);

    function setupParty(party) {
        foreach (t in party.m.Troops) {
            TacticalEntityManager.setupEntity(makeEntity(t), t);
        }
    }

    function concat(...){
        local res = [];
        foreach (arr in vargv) res.extend(arr);
        return res
    }

    // Test necro zombie party
    srand(13);
    Days = 95;
    setupParty(makeParty(
        "necro-zombie", "undead",
        concat(array(6, "zombie"), ["zombie_yeoman" "zombie_yeoman" "zombie_knight" "necromancer"])
    ));

    // Test skeletons
    srand(4);
    Days = 95;
    setupParty(makeParty(
        "skeletons", "undead",
        concat(array(6, "skeleton_light"), array(6, "skeleton_medium"), array(6, "skeleton_heavy"))
    ));

    // Test bandits party
    srand(53); // 11
    Days = 95;
    setupParty(makeParty(
        "mixed-bandits", "bandits",
        concat(array(6, "bandit_raider"), array(6, "bandit_marksman"))
    ));

    // Test orcs party
    srand(4);
    Days = 125;
    setupParty(makeParty(
        "horde", "orcs",
        concat(array(4, "orc_warrior"), array(4, "orc_berserker"), array(2, "orc_warlord"))
    ));

    // Test barbarians party
    srand(6);
    Days = 95;
    setupParty(makeParty(
        "barbarian-horde", "barbarians",
        concat(array(4, "barbarian_thrall"),
               array(3, "barbarian_marauder"),
               array(3, "barbarian_champion"))
    ));

    // Testing anything else
    local Debug = StandoutEnemies.Debug;

    // At least check syntax
    new("scripts/skills/cursed_skill");
    new("scripts/skills/cursed_effect");

    // Check something about Squirrel
    local function main() {
        Debug.log("x", {
            x = {y = 2},
            y = {z = {a = {b = 123}}},
            log = [200,300,400,500,600,700,800]
            function a() {}
            function b() {}
        }, {depth = 3, width = 50});
    }

    // main();
}
