// Skip this in game
local gt = getroottable();

if ("dofile" in gt) {
    // Provide this stubs to enable simple testing
    logInfo <- function(s) {
        print(s + "\n")
    }
    Const <- {SkillType = {Active = 1}}
    World <- {
        FactionManager = {
            function getFaction(faction) {
                return {getType = @() faction}
            }
        }
        Assets = {getCombatDifficulty = @() 1}
        function getTime() {
            return {Days = 110}
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
    new <- function (script) {return script}
    createColor <- function (color) {return color}

    // Test run setupEntity for fake party
    local TacticalEntityManager = {setupEntity = function (e, t) {
        print("original: setupEntity for " + t.Script + "\n")
    }};
    function makeEntity(t) {
        return {
            m = {
                Name = t.Script.find("zombie") != null ? "Zombie" : "Necromancer"
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
                    BraveryMult = 1.0
                    IsAffectedByNight = true
                    HitChance = [25 75]
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

    // Test necro zombie party
    setupParty(makeParty(
        "necro-zombie", "undead",
        ["zombie", "zombie", "zombie", "zombie", "zombie", "zombie_knight", "necromancer"]
    ));

    // Test bandits party
    setupParty(makeParty(
        "mixed-bandits", "bandits",
        concat(array(6, "bandit_raider"), array(4, "bandit_marksman"))
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
