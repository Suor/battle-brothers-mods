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
        return {
            script = script
            function getArmor() {return 39}
            function getArmorMax() {return 80}
            function setArmor(val) {}
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
                }
                Items = {
                    function getItemAtSlot(s) {
                        return Math.rand(0, 1) ? null : {
                            function getArmor() {return 39}
                            function getArmorMax() {return 80}
                            function setArmor(val) {}
                        }
                    }
                    function equip(item) {}
                }
                Skills = {
                    function add(skill) {}
                    function update() {}
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
                return {
                    function getAllSkillsOfType(type) {
                        return [
                            {m = {ID = "actives.raise_undead", ActionPointCost = 3, FatigueCost = 10}}
                            {m = {ID = "actives.knock", ActionPointCost = 4, FatigueCost = 15}}
                        ]
                    }
                    function getSkillByID(_id) {
                        if (_id == "effects.berserker_rage") {
                            return {addRage = @(r) r}
                        }
                        return null;
                    }
                }
            }
        };
    }

    function makeParty(name, faction, troopScripts) {
        print("hi\n")
        print(troopScripts + "\n");
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

    // Mod hooks fake
    ::mods_registerMod <- function (x, y, x) {}
    ::mods_queue <- function (x, y, func) {
        func()
    }
    ::mods_hookClass <- function (x, func) {
        func(TacticalEntityManager);
    }
    ::mods_hookBaseClass <- function (x, func) {
        func({})
    }

    // Load mod script to check for syntax at least
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

    // Test bandits party
    setupParty(makeParty(
        "mixed-bandits", "bandits",
        concat(array(6, "bandit_raider"), array(4, "bandit_marksman"))
    ));

    // Test orcs party
    Days = 190;
    setupParty(makeParty(
        "horde", "orcs",
        concat(array(4, "orc_warrior"), array(6, "orc_berserker"), array(2, "orc_warlord"))
    ));

    // Test necro zombie party
    Days = 110;
    setupParty(makeParty(
        "necro-zombie", "undead",
        ["zombie", "zombie", "zombie", "zombie", "zombie", "zombie_knight", "necromancer"]
    ));

    // Test barbarians party
    setupParty(makeParty(
        "barbarian-horde", "barbarians",
        concat(array(4, "barbarian_thrall"),
               array(3, "barbarian_marauder"),
               array(5, "barbarian_champion"))
    ));

    // Testing anything else
    local Debug = StandoutEnemies.Debug;

    // Check something about Squirrel
    local function main() {
        // Debug.log("x", {
        //     x = {y = 2},
        //     log = [200,300,400,500,600,700,800]
        // });
    }

    main();
}
