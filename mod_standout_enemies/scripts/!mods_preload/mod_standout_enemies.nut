::mods_registerMod("mod_standout_enemies", 0.3, "Standout Enemies");

local gt = this.getroottable();

// Alias things to make it easier for us inside. These are still global and accessible from outside,
// so if anyone will want to write a mod for this mod then it should be easy enough )
local se = gt.StandoutEnemies <- {};
local Mod = se.Mod <- {}, Rand = se.Rand <- {}, Util = se.Util <- {}, Debug = se.Debug <- {};


local Config = se.Config <- {
    ScaleDays = [80, 90, 100]  // scale varies by days and combat difficulty
}


// Available quirks

local Quirk = se.Quirk <- {
    Fast = {
        Prefix = "Agile",
        XPMult = 1.3,
        function apply(e) {
            // More action points and initiative
            e.m.BaseProperties.ActionPoints += 3;
            e.m.BaseProperties.Initiative += 25;

            // Give adrenaline
            e.m.Skills.add(this.new("scripts/skills/perks/perk_adrenalin"));
            e.m.AIAgent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_adrenaline"));

            // More action points plus adrenaline drains stamina so we add some
            e.m.BaseProperties.Stamina += 25;
            e.m.BaseProperties.FatigueRecoveryRate += 5;

            // Being fast helps hit and not being hit, but reduces damage to compensate
            Mod.offense(e, 10, 0.85);
            Mod.defense(e, 5);
            Mod.bravery(e, 1.3);

            // Slightly red head
            Mod.color(e, "head", "#ffdddd", 0.9);
        }
    },
    Big = {
        Prefix = "Big",
        XPMult = 1.2,
        function apply(e) {
            Mod.offense(e, 0, 1.25);
            Mod.defense(e, -5, 1.7);
            Mod.bravery(e, 1.5);  // More hits need to be brave longer
            Mod.scale(e, 1.12);
        }
    },
    Headshot = {
        Noun = "Headshot",
        XPMult = 1.25,
        function apply(e) {
            e.m.Name = split(e.m.Name, " ")[0] + this.Noun;

            e.m.BaseProperties.HitChance = [65, 35];  // Up from 75/25
            e.m.Skills.add(this.new("scripts/skills/perks/perk_head_hunter"));
        }
    },
    Sly = {
        Prefix = "Sly",
        XPMult = 1.2,
        function apply(e) {
            Mod.offense(e, 5);
            Mod.bravery(e, 1.2);

            e.m.Skills.add(this.new("scripts/skills/racial/goblin_ambusher_racial"));
            e.m.Skills.add(this.new("scripts/skills/perks/perk_dodge"));
            e.m.Skills.add(this.new("scripts/skills/perks/perk_nine_lives"));
        }
    },
    Stubborn = {
        Prefix = "Stubborn",
        XPMult = 1.25,
        function apply(e) {
            Mod.defense(e, 0, 1.2);
            e.m.Skills.add(this.new("scripts/skills/perks/perk_nine_lives"));

            if (e.m.IsResurrected) {
                e.m.ResurrectionChance = 60; // Ressurect 2.5 times on average after first one
                e.m.IsResurrected = false;
            } else {
                e.m.ResurrectionChance = 100;  // Definitely resurrect first time
            }
        }
    },
    Masterwork = {
        Prefix = "Masterwork",
        XPMult = 1.5,
        function apply(e) {
            // More action points and initiave
            e.m.BaseProperties.ActionPoints += 3;
            e.m.BaseProperties.Initiative += 25;

            Mod.offense(e, 10, 1.15);
            Mod.defense(e, 10, 1.7);

            // Half-vampire :)
            e.m.Skills.add(this.new("scripts/skills/racial/vampire_racial"));
            e.m.Skills.add(this.new("scripts/skills/perks/perk_anticipation"));
            e.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));
            e.m.Skills.add(this.new("scripts/skills/perks/perk_nine_lives"));

            // Resurrects like a stubborn one
            if (e.m.IsResurrected) {
                e.setHitpointsPct(0.75);     // Up from 0.45
                e.m.ResurrectionChance = 60; // Ressurect 2.5 times on average after first one
                e.m.IsResurrected = false;
            } else {
                e.m.ResurrectionChance = 100;  // Definitrly resurrect first time
            }

            // Reddish head and body and no hair
            Mod.color(e, "head", "#ffaaaa", 0.9);
            Mod.color(e, "injury", "#ffaaaa", 0.9);
            Mod.color(e, "body", "#ffaaaa", 0.9);
            e.getSprite("hair").Visible = false;
        }
    },
    SkilledNecro = {
        Prefix = "Skilled",
        XPMult = 1.7,
        function apply(e) {
            // This means necromancer will be able to cast 3 spells each turn
            local skills = e.getSkills().getAllSkillsOfType(gt.Const.SkillType.Active);
            foreach (s in skills) {
                if (s.m.ID == "actives.raise_undead" || s.m.ID == "actives.possess_undead") {
                    // this.logInfo("se: necro " + e.getName() + " " + s.m.ID);
                    s.m.ActionPointCost = 2;
                    s.m.FatigueCost = 6;
                }
            }

            // A bit harder to shoot
            e.m.BaseProperties.RangedDefense += 15;

            // Many his zombies die, need extra bravery
            Mod.bravery(e, 1.5);
        }
    },
}

// Add names for debugging purposes
foreach (name, quirk in Quirk) quirk.pp <- name;


// Strategies that decide what to do with the whole party

local Strategy = null;  // Forward declaration
Strategy = se.Strategy <- {
    Bandit = {
        Priority = 4,
        MinScale = 0.35,
        MaxScale = 1.2,
        AnyTypes = ["bandit", "nomad"],
        function getPlan(stats, maturity) {
            local num = 1;  // One special bandit for a while
            if (maturity > 0.15)  num = se.getQuirkedNum(stats, this.Types, maturity, 0.45, 0.7);

            local quirks;
            switch (Rand.weighted([50, 50, 100], ["big", "fast", "mixed"])) {
                case "big": quirks = array(num, Quirk.Big); break;
                case "fast": quirks = array(num, Quirk.Fast); break;
                case "mixed": quirks = Rand.choices(num, [Quirk.Fast, Quirk.Big]); break;
            }

            // They don't go together so it's safe to queue both types
            return {bandit = quirks, nomad = quirks};
        }
    },
    Headshot = {
        Priority = 4,
        MinScale = 0.5,
        MaxScale = 1.3,
        AnyTypes = ["bandit_marksman", "noman_archer"],
        function getPlan(stats, maturity) {
            local num = se.getQuirkedNum(stats, this.AnyTypes, maturity, 0.0, 0.4);
            local quirks = array(num, Quirk.Headshot);
            // They don't go together so it's safe to queue both types
            return {bandit_marksman = quirks, noman_archer = quirks}
        }
    }
    BanditMixed = {
        Priority = 8,
        MinScale = 0.6,
        MaxScale = 1.4,
        function getPlan(stats, maturity) {
            if (!("bandit" in stats.Counts || "nomad" in stats.Counts)
                || !("bandit_marksman" in stats.Counts || "nomad_archer" in stats.Counts))
                return null;

            local banditPlan = Strategy.Bandit.getPlan(stats, maturity);
            local headshotPlan = Strategy.Headshot.getPlan(stats, Math.pow(maturity, 1.5));
            return Util.merge(banditPlan, headshotPlan);
        }
    },
    Goblin = {
        Priority = 4,
        MinScale = 0.35,
        MaxScale = 1.1,
        Types = ["goblin"],
        function getPlan(stats, maturity) {
            local num = se.getQuirkedNum(stats, this.Types, maturity, 0.4, 0.66);

            switch (Rand.weighted([75, 33, 100], ["sly", "fast", "mixed"])) {
                case "sly": return {goblin = array(num, Quirk.Sly)};
                case "fast": return {goblin = array(num, Quirk.Fast)};
                case "mixed": return {goblin = Rand.choices(num, [Quirk.Fast, Quirk.Sly, Quirk.Sly])};
            }
        }
    },
    Zombie = {
        Priority = 4,
        MinScale = 0.3,
        MaxScale = 1.1,
        Types = ["zombie"],
        function getPlan(stats, maturity) {
            // Max higher than 1 makes them all special more likely and earlier
            local num = se.getQuirkedNum(stats, this.Types, maturity, 0.5, 1.2);
            if (num == 0) return null;

            local res;
            // switch (Rand.weighted([100, 50, 50], ["stubborn", "big", "mixed"])) {
            switch ("mixed") {
                case "stubborn":
                    res = {zombie = array(num, Quirk.Stubborn)};
                    break;
                case "big":
                    res = {zombie = array(num, Quirk.Big)};
                    break;
                case "mixed":
                    local quirks = [Quirk.Fast, Quirk.Big, Quirk.Stubborn, Quirk.Stubborn];
                    res = {zombie = Rand.choices(num, quirks)};
                    break;
            }

            // Rarely add a masterwork zombie
            if (Rand.chance(maturity - 0.5)) Rand.insert(res.zombie, Quirk.Masterwork);

            // // DEBUG
            // // res.zombie = array(10, Quirk.Masterwork)
            // Rand.insert(res.zombie, Quirk.Masterwork);
            // Rand.insert(res.zombie, Quirk.Masterwork);

            return res;
        }
    },
    Necromancer = {
        Priority = 4,
        MinScale = 0.55,
        MaxScale = 1.2,
        Types = ["necromancer"],
        function getPlan(stats, maturity) {
            local prob = Math.pow(maturity, 0.33) * 0.7;
            local num = Rand.poly(maturity > 0.5 ? 2 : 1, prob);
            if (num == 0) return null;

            // TODO: other quirks and more necromancers
            return {necromancer = array(num, Quirk.SkilledNecro)}
        }
    },
    NecroZombie = {
        Priority = 8,
        MinScale = 0.7,
        MaxScale = 1.5,
        Types = ["zombie", "necromancer"],
        function getPlan(stats, maturity) {
            local necroPlan = Strategy.Necromancer.getPlan(stats, maturity);

            // A little bit less zombies if necro is quirked while scale < 1
            local zombieMaturity = Math.pow(maturity, necroPlan ? 0.25 : 0.2);
            local zombiePlan = Strategy.Zombie.getPlan(stats, zombieMaturity);

            local res = Util.merge(necroPlan, zombiePlan);

            // Each skilled necro might have a masterwork
            if (maturity >= 0.3 && "necromancer" in res) {
                local num = Rand.poly(res.necromancer.len(), 0.5);
                if (num) {
                    if (!("zombie" in res)) res.zombie <- [];
                    for (local i = 0; i < num; i++) Rand.insert(res.zombie, Quirk.Masterwork);
                }
            }

            return res;
        }
    },
}

se.getQuirkedNum <- function (stats, types, maturity, minPart, maxPart) {
    local count = Util.sum(types.map(@(t) t in stats.Counts ? stats.Counts[t] : 0));
    if (count == 0) return 0;

    local min = minPart * maturity * count;
    local max = maxPart * maturity * count;
    if (max < 1) return Rand.chance(Math.pow(max, 0.1) / 2) ? 1 : 0;
    return Math.rand(min, max)
}

// Sorted by descending priority to start from the highest and skip tail if possible
local SortedStrategies = [];
foreach (name, strategy in Strategy) {
    strategy.Name <- name
    SortedStrategies.push(strategy);
}
SortedStrategies.sort(@(a, b) b.Priority <=> a.Priority);


se.getPlan <- function(party) {
    // Plan for each party once
    if ("se_Plan" in party.m) return party.m.se_Plan;
    this.logInfo("se: getPlan " + party.getName());

    local stats = se.partyStats(party);
    local scaleDays = Config.ScaleDays[gt.World.Assets.getCombatDifficulty()];
    local scale = 1.0 * gt.World.getTime().Days / scaleDays;
    this.logInfo("se: scale " + scale);

    local plans = [], weights = [], priority = 9000;
    foreach (strategy in SortedStrategies) {
        // this.logInfo("se: evaluating strategy " + strategy.Name);
        if (strategy.MinScale > scale) continue;

        if ((strategy.Priority < priority) && plans.len()) break;
        priority = strategy.Priority;

        if ("Types" in strategy && !Util.all(strategy.Types, @(t) t in stats.Counts)) continue;
        if ("AnyTypes" in strategy && !Util.any(strategy.Types, @(t) t in stats.Counts)) continue;

        local maturity = (scale - strategy.MinScale) / (strategy.MaxScale - strategy.MinScale);
        maturity = Math.minf(1, maturity);  // Cap it to 1
        local plan = strategy.getPlan(stats, maturity);
        if (!plan) continue;

        Debug.log("plan for " + strategy.Name + "(" + maturity + ")", plan);
        plans.push(plan);
        weights.push("Weight" in strategy ? strategy.Weight : 100);
    }

    local res = party.m.se_Plan <- plans.len() ? Rand.weighted(weights, plans) : {};
    Debug.log("the chosen plan", res);
    return res;
}

se.partyStats <- function(party) {
    this.logInfo("se: partyStats " + party.getName());

    local stats = {
        FactionType = this.World.FactionManager.getFaction(party.getFaction()).getType(),
        Total = party.m.Troops.len(),
        Counts = {},
    }

    // foreach (t in party.world_entity.m.Troops) {
    foreach (t in party.m.Troops) {
        local type = se.getTroopType(t);
        if (type in stats.Counts) stats.Counts[type]++;
        else stats.Counts[type] <- 1;
    }

    // // Descending by num, to easily get the most numerous
    // stats.ByNum <- Util.mapTable(stats.Counts, @(type, cnt) {Type = type, Num = cnt});
    // stats.ByNum.sort(@(a, b) b.Num <=> a.Num);

    Debug.log("stats", stats);
    return stats;
}

se.setupEntity <- function (plan, e, t) {
    local type = se.getTroopType(t);
    if (type in plan && plan[type].len()) {
        local quirk = plan[type].remove(0);
        se.applyQuirk(e, quirk);
    }
}

se.applyQuirk <- function(e, quirk) {
    this.logInfo("se: Apply " + quirk.pp + " to " + e.getName());
    e.m.se_Quirk <- quirk;  // Save to transfer to corpse and reapply on resurrection

    if ("Prefix" in quirk) e.m.Name = quirk.Prefix + " " + se.cutName(e.m.Name);
    e.m.XP *= quirk.XPMult;
    e.m.ResurrectionValue *= quirk.XPMult;  // More valuable to raise
    quirk.apply(e);

    // Update from base properties to current and e.m.props
    e.m.Skills.update();
}

se.ShortNames <- {
    "Goblin Skirmisher": "Goblin",
    "Goblin Wolfrider": "Wolfrider",
    "Brigand Raider": "Raider"
    "Fallen Hero": "Hero"
}

se.cutName <- function(name) {
    if (name in se.ShortNames) return se.ShortNames[name];
    return name;
}

se.getTroopType <- function(t) {
    if (t.Variant != 0) return "champion";  // Skip champions

    local nameParts = split(t.Script, "/");
    local name = nameParts[nameParts.len() - 1];

    if (Util.startswith(name, "zombie") && name != "zombie_boss") return "zombie";
    if (Util.startswith(name, "skeleton")) return "skeleton";
    if (Util.startswith(name, "orc")) return "orc";
    if (name == "bandit_raider" || name == "bandit_leader") return "bandit";
    if (name == "nomad_outlaw" || name == "nomad_leader") return "nomad";
    // For whatever reason exp name == "goblin_figther" returns false here ???
    if (Util.startswith(name, "goblin")) {
        if (name.find("fighter") || name.find("wolfrider")) return "goblin"
    }
    if (name == "goblin_figther" || name == "goblin_wolfrider") return "goblin";
    if (name.find("wolf")) return "wolf";

    // varios scum, including low versions won't be promoted anyway
    return name;
}


// Since we use forward declarations we can't override, we should extend tables.
local function extend(dst, src) {
    foreach (key, value in src) {
        dst[key] <- value
    }
    return dst;
}


// Modification shortcuts

extend(Mod, {
    function offense(e, skill, damageMult = 1.0) {
        local b = e.m.BaseProperties;
        b.MeleeSkill += skill;
        b.RangedSkill += skill;
        b.DamageTotalMult *= damageMult;
    }

    function defense(e, def, hpMult = 1.0) {
        local b = e.m.BaseProperties;
        b.MeleeDefense += def;
        b.RangedDefense += def;
        b.HitpointsMult *= hpMult;
    }

    function bravery(e, braveryMult) {
        e.m.BaseProperties.BraveryMult *= braveryMult;
    }

    // Presentation
    function scale(e, scaleMult) {
        // This doesn't take care of the corpse size unfortunately
        local parts = [
            "body" "tattoo_body" "injury_body"
            "armor" "surcoat" "armor_upgrade_back" "armor_upgrade_front"
            "head" "closed_eyes" "eye_rings" "tattoo_head" "beard" "beard_top" "hair" "injury"
            "helmet" "helmet_damage"
            "body_blood" "accessory" "accessory_special"
            "permanent_injury_1" "permanent_injury_2" "permanent_injury_3" "permanent_injury_4"
            "bandage_1" "bandage_2" "bandage_3"
            "background" "quiver" "shaft" "dirt"
        ];
        foreach (part in parts) {
            if (e.hasSprite(part)) e.getSprite(part).Scale *= scaleMult;
        }
    }

    function color(e, part, color, brightness = 1, saturation = 1) {
        local sprite = e.getSprite(part);
        sprite.Color = this.createColor(color);
        sprite.setBrightness(brightness);
        sprite.Saturation = saturation;
    }
})


// Utilities

extend(Rand, {
    chance = @(prob) this.Math.rand(1, 1000) <= prob * 1000,
    choice = @(arr) arr[this.Math.rand(0, arr.len() - 1)],

    function weighted(weights, choices) {
        local total = Util.sum(weights);
        local roll = this.Math.rand(1, 1000) * total / 1000.0;

        local sofar = 0;
        for (local i = 0; i < weights.len(); i++) {
            sofar += weights[i];
            if (roll <= sofar) return choices[i]
        }
        return choices[choices.len() - 1];  // To be safe
    }

    function choices(num, arr) {
        local res = [];
        for (local i = 0; i < num; i++) res.push(Rand.choice(arr));
        return res;
    }

    function insert(arr, item) {
        local index = Math.rand(0, arr.len());
        arr.insert(index, item);
    }

    function poly(tries, prob) {
        local num = 0;
        for (local i = 0; i < tries; i++)
            if (Rand.chance(prob)) num++;
        return num;
    }
})


extend(Util, {
    function startswith(s, sub) {
        if (s.len() < sub.len()) return false;
        return s.slice(0, sub.len()) == sub;
    }

    function mapTable(data, func) {
        local res = [];
        foreach (key, value in data) res.push(func(key, value));
        return res;
    }

    function merge(t1, t2) {
        if (t1 == null) return t2;
        if (t2 == null) return t1;
        return extend(clone t1, t2);
    }

    function sum(arr) {
        return arr.reduce(@(a, b) a + b);
    }

    function all(arr, func) {
        foreach (item in arr) {
            if (!func(item)) return false;
        }
        return true;
    }

    function any(arr, func) {
        foreach (item in arr) {
            if (func(item)) return true;
        }
        return false;
    }
})


// Debug things

local function indent(level, s) {
    return format("%"+ (level * 4) + "s", "") + s;
}

local function join(sep, lines) {
    local s = "";
    foreach (i, line in lines) {
        if (i > 0) s += sep;
        s += line;
    }
    return s;
}

local function joinLength(items, sepLen) {
    if (items.len() == 0) return 0;
    return Util.sum(items.map(@(s) s.len())) + (items.len() - 1) * sepLen;
}

extend(Debug, {
    PP_MAX_LENGTH = 50,

    function pp(data, level = 0) {
        local function ppCont(items, level, start, end) {
            if (joinLength(items, 2) <= this.PP_MAX_LENGTH - level * 4 - 2) {
                return start + join(", ", items) + end;
            } else {
                local lines = [start];
                lines.extend(items.map(@(item) indent(level + 1, item)));
                lines.push(indent(level, end));
                return join("\n", lines);
            }
        }

        if (level > 3) return "...";

        local endln = (level == 0 ? "\n" : "");

        if (typeof data == "table") {
            if ("pp" in data) return data.pp;

            local items = Util.mapTable(data, @(k, v) k + " = " + Debug.pp(v, level + 1));
            return ppCont(items, level, "{", "}") + endln;
        } else if (typeof data == "array") {
            local items = data.map(@(item) Debug.pp(item, level + 1));
            return ppCont(items, level, "[", "]") + endln;
        } else {
            return "" + data + endln;  // More robust than .tostring()
        }
    }

    function log(name, data) {
        this.logInfo("<pre>se: " + name + " = " + Debug.pp(data) + "</pre>");
    }
})


::mods_queue("mod_standout_enemies", null, function()
{
    this.logInfo("se: loading");

    ::mods_hookClass("entity/tactical/tactical_entity_manager", function(cls) {
        this.logInfo("se: hook tactical_entity_manager");

        local setupEntity = cls.setupEntity;
        cls.setupEntity = function(e, t) {
            this.logInfo("se: setupEntity " + e.getName() + " party " + t.Party.getName());

            setupEntity(e, t);
            se.setupEntity(se.getPlan(t.Party), e, t);
        }
    });

    ::mods_hookBaseClass("entity/tactical/actor", function(cls) {
        this.logInfo("se: hook tactical/actor");

        // Save quirk to corpse and reapply on resurrection
        local onDeath = "onDeath" in cls ? cls.onDeath : null;
        cls.onDeath <- function (_killer, _skill, _tile, _fatalityType) {
            if (onDeath) onDeath(_killer, _skill, _tile, _fatalityType);
            if (_tile == null) return;
            if (!("se_Quirk" in this.m)) return;

            local corpse = _tile.Properties.get("Corpse");
            corpse.se_Quirk <- this.m.se_Quirk;
        }

        local onResurrected = "onResurrected" in cls ? cls.onResurrected : null;
        cls.onResurrected <- function (_info) {
            if (onResurrected) onResurrected(_info);
            if ("se_Quirk" in _info) se.applyQuirk(this, _info.se_Quirk);
        }
    })
});
