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
            return {Days = 175}
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

    local party = {
        m = {
            Troops = [
                {Script = ".../zombie", Variant = 0}
                {Script = ".../zombie", Variant = 0}
                {Script = ".../zombie", Variant = 0}
                {Script = ".../zombie", Variant = 0}
                {Script = ".../zombie_knight", Variant = 0}
                {Script = ".../necromancer", Variant = 0}
            ]
        }
        getName = @() "test-party"
        getFaction = @() "undead"
    };
    foreach (t in party.m.Troops) {
        t.Party <- party.weakref();
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

    // Test run setupEntity for fake party
    foreach (t in party.m.Troops) {
        TacticalEntityManager.setupEntity(makeEntity(t), t);
    }

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
