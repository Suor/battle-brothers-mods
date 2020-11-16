::mods_registerMod("mod_standout_enemies", 0.33, "Standout Enemies");

local gt = this.getroottable();

// Alias things to make it easier for us inside. These are still global and accessible from outside,
// so if anyone will want to write a mod for this mod then it should be easy enough )
local se = gt.StandoutEnemies <- {};
local Mod = se.Mod <- {}, Rand = se.Rand <- {}, Util = se.Util <- {}, Debug = se.Debug <- {};


local Config = se.Config <- {
    ScaleDays = [80, 90, 100]  // scale varies by days and combat difficulty
    ShortNames = {
        "Goblin Skirmisher": "Goblin",
        "Goblin Wolfrider": "Wolfrider",
        "Brigand Raider": "Raider",
        "Fallen Hero": "Hero",
    }
    function cutName(name) {
        if (name in this.ShortNames) return this.ShortNames[name];
        return name;
    }
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
    Fearless = {
        Prefix = "Fearless",
        XPMult = 1.2,
        function apply(e) {
            // Vary so that some keep longer
            e.m.BaseProperties.Bravery += Math.rand(20, 50);
        }
    },
    Dreadful = {
        Prefix = "Dreadful",
        XPMult = 4,
        function apply(e) {
            e.m.BaseProperties.Bravery += 50;

            // Cheaper warcry with double effect and high priority, makes bros run
            local warcry = e.getSkills().getSkillByID("actives.warcry");
            if (warcry) {
                warcry.m.FatigueCost = 5;

                // Double effect
                local onDelayedEffect = warcry.onDelayedEffect;
                warcry.onDelayedEffect = function(_tag) {
                    onDelayedEffect(_tag);
                    onDelayedEffect(_tag);
                }

                // Use it more often
                e.m.AIAgent.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.Warcry] = 5;
            }
        }
    },
    Headshot = {
        Noun = "Headshot",
        XPMult = 1.25,
        function apply(e) {
            e.m.Name = split(e.m.Name, " ")[0] + this.Noun;

            Mod.offense(e, 5);
            e.m.BaseProperties.HitChance = [65, 35];  // Up from 75/25
            e.m.Skills.add(this.new("scripts/skills/perks/perk_head_hunter"));
        }
    },
    Sly = {
        Prefix = "Sly",
        XPMult = 1.25,
        function apply(e) {
            Mod.offense(e, 10);
            e.m.BaseProperties.DamageDirectMult *= 1.1;
            Mod.bravery(e, 1.3);

            // Harder to kill with a ranged weapon and uses overwhelm to defend himself in melee
            e.m.BaseProperties.RangedDefense += 15;
            e.m.Skills.add(this.new("scripts/skills/perks/perk_overwhelm"));

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
                // TODO: make bigger for fallen hero?
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
            if (maturity > 0.15)  num = se.getQuirkedNum(stats, this.AnyTypes, maturity, 0.45, 0.7);

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
        MinScale = 0.4,
        MaxScale = 1.3,
        AnyTypes = ["bandit_marksman", "noman_archer"],
        function getPlan(stats, maturity) {
            local num = se.getQuirkedNum(stats, this.AnyTypes, maturity, 0.05, 0.45);
            local quirks = array(num, Quirk.Headshot);
            // They don't go together so it's safe to queue both types
            return {bandit_marksman = quirks, noman_archer = quirks}
        }
    }
    BanditMixed = {
        Priority = 8,
        MinScale = 0.4,
        MaxScale = 1.3,
        function getPlan(stats, maturity) {
            if (!("bandit" in stats.Counts || "nomad" in stats.Counts)
                || !("bandit_marksman" in stats.Counts || "nomad_archer" in stats.Counts))
                return null;

            local banditPlan = Strategy.Bandit.getPlan(stats);
            local headshotPlan = Strategy.Headshot.getPlan(stats);
            return Util.merge(banditPlan, headshotPlan);
        }
    },
    Goblin = {
        Priority = 4,
        MinScale = 0.35,
        MaxScale = 1.1,
        Types = ["goblin"],
        function getPlan(stats, maturity) {
            local num = se.getQuirkedNum(stats, this.Types, maturity, 0.4, 0.7);

            switch (Rand.weighted([75, 33, 100], ["sly", "fast", "mixed"])) {
                case "sly": return {goblin = array(num, Quirk.Sly)};
                case "fast": return {goblin = array(num, Quirk.Fast)};
                case "mixed": return {goblin = Rand.choices(num, [Quirk.Fast, Quirk.Sly, Quirk.Sly])};
            }
        }
    },
    Orc = {
        Priority = 4,
        MinScale = 0.5,
        MaxScale = 1.5,
        AnyTypes = ["orc", "orc_warlord"],
        function getPlan(stats, maturity) {
            local num = se.getQuirkedNum(stats, this.AnyTypes, maturity, 0.5, 1);
            // Good chance for at least one, even early on
            if (num == 0 && Rand.chance(0.33 + maturity * 2)) num++;
            if (num == 0) return null;

            // Warlords take their share first, 1 is guaranteed
            local warlords = stats.count("orc_warlord");
            local warlordsQuirks = [];
            if (warlords) {
                local warlordsNum = 1 + Rand.poly(Math.min(num, warlords) - 1, 0.5);
                num -= warlordsNum;

                // Some chance to make a dreadful warlord from scale 0.9,
                // ends in fifty-fifty at scale 2
                local dreadfulMaturity = sf.maturity(stats.scale, 0.9, 2.0);
                if (dreadfulMaturity > 0 && Rand.chance(0.1 + dreadfulMaturity * 0.4)) {
                    warlordsQuirks.push(Quirk.Dreadful);
                    warlordsNum--;
                }
                warlordsQuirks.extend(array(warlordsNum, Quirk.Fearless));
            }

            // Mix fearless with ordinary orcs,
            // also ensures we'll distribute these between berserkers and warriors
            local quirks = array(num, Quirk.Fearless);
            for (local i = stats.Counts["orc"] - num; i > 0; i-- ) {
                Rand.insert(quirks, null)
            }

            return {orc = quirks, orc_warlord = warlordsQuirks};
        }
    },
    Greenskin = {
        Priority = 8,
        MinScale = 0.5,
        MaxScale = 1.5,
        Types = ["orc", "goblin"]
        function getPlan(stats, maturity) {
            local orcPlan = Strategy.Orc.getPlan(stats);
            local goblinPlan = Strategy.Goblin.getPlan(stats);
            return Util.merge(orcPlan, goblinPlan);
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
            switch (Rand.weighted([100, 40, 80], ["stubborn", "big", "mixed"])) {
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

            // A little bit less quirked zombies if necro is quirked
            local zombieMaturity = necroPlan ? se.getMaturity(stats.scale, 0.35, 1.2) : null;
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
// Make passing maturity optional
foreach (_name, strategy in Strategy) {
    local name = _name;  // for closure
    local getPlan = strategy.getPlan;
    strategy.getPlan = function(stats, maturity = null) {
        if (maturity == null) maturity = se.getMaturity(stats.scale, this.MinScale, this.MaxScale);
        if (maturity == 0) return null;

        local plan = getPlan(stats, maturity)
        Debug.log("plan for " + name + "(" + maturity + ")", plan);
        return plan;
    }
}

// Sorted by descending priority to start from the highest and skip tail if possible
local SortedStrategies = [];
foreach (name, strategy in Strategy) {
    strategy.Name <- name
    SortedStrategies.push(strategy);
}
SortedStrategies.sort(@(a, b) b.Priority <=> a.Priority);


// Since we use forward declarations we can't override, we should extend tables.
local function extend(dst, src) {
    foreach (key, value in src) {
        dst[key] <- value
    }
    return dst;
}

extend(se, {
    function getQuirkedNum(stats, types, maturity, minPart, maxPart) {
        local count = Util.sum(types.map(stats.count));
        if (count == 0) return 0;

        local min = minPart * maturity * count;
        local max = maxPart * maturity * count;
        this.logInfo("getQuirkedNum min " + min + " max " + max);
        if (max < 1) return Rand.chance(Math.pow(max, 0.1) / 2) ? 1 : 0;
        return Math.rand(min, max)
    }

    function getPlan(party) {
        // Plan for each party once
        if ("se_Plan" in party.m) return party.m.se_Plan;
        this.logInfo("se: getPlan " + party.getName());

        local stats = se.partyStats(party);
        local scaleDays = Config.ScaleDays[gt.World.Assets.getCombatDifficulty()];
        stats.scale <- 1.0 * gt.World.getTime().Days / scaleDays;
        Debug.log("stats", stats, false);

        local plans = [], weights = [], priority = 9000;
        foreach (strategy in SortedStrategies) {
            if (strategy.MinScale > stats.scale) continue;

            if ((strategy.Priority < priority) && plans.len()) break;
            priority = strategy.Priority;

            // TODO: should I move this into Quirk.getPlan() decorator?
            if ("Types" in strategy && !Util.all(strategy.Types, stats.count)) continue;
            if ("AnyTypes" in strategy && !Util.any(strategy.AnyTypes, stats.count)) continue;

            local plan = strategy.getPlan(stats);
            if (!plan) continue;

            // local maturity = se.getMaturity(stats.scale, strategy.MinScale, strategy.MaxScale);
            // Debug.log("plan for " + strategy.Name + "(" + maturity + ")", plan);
            plans.push(plan);
            weights.push("Weight" in strategy ? strategy.Weight : 100);
        }

        local res = party.m.se_Plan <- plans.len() ? Rand.weighted(weights, plans) : {};
        Debug.log("the chosen plan", res);
        return res;
    }

    function getMaturity(scale, min, max) {
        local maturity = (scale - min) / (max - min);
        return Math.maxf(0, Math.minf(1, maturity));  // Cap into [0, 1]
    }

    function partyStats(party) {
        this.logInfo("se: partyStats " + party.getName());

        local stats;
        stats = {
            FactionType = this.World.FactionManager.getFaction(party.getFaction()).getType(),
            Total = party.m.Troops.len(),
            Counts = {},
            function count(type) {
                return type in stats.Counts ? stats.Counts[type] : 0;
            }
        }

        foreach (t in party.m.Troops) {
            local type = se.getTroopType(t);
            if (type in stats.Counts) stats.Counts[type]++;
            else stats.Counts[type] <- 1;
        }

        return stats;
    }

    function setupEntity(plan, e, t) {
        local type = se.getTroopType(t);
        if (type in plan && plan[type].len()) {
            local quirk = plan[type].remove(0);
            if (quirk != null) se.applyQuirk(e, quirk);
        }
    }

    function applyQuirk(e, quirk) {
        this.logInfo("se: Apply " + quirk.pp + " to " + e.getName());

        // Save to transfer to corpse and reapply on resurrection,
        // also used to transfer to surviving goblin of goblin wolfrider
        e.m.se_Quirk <- quirk;

        if ("Prefix" in quirk) e.m.Name = quirk.Prefix + " " + Config.cutName(e.m.Name);
        e.m.XP *= quirk.XPMult;
        if ("ResurrectionValue" in e.m) e.m.ResurrectionValue *= quirk.XPMult; // More valuable

        quirk.apply(e);

        // Update from base properties to current and e.m.*
        e.m.Skills.update();
    }

    function getTroopType(t) {
        if (t.Variant != 0) return "champion";  // Skip champions

        local nameParts = split(t.Script, "/");
        local name = nameParts[nameParts.len() - 1];

        if (Util.startswith(name, "zombie") && name != "zombie_boss") return "zombie";
        if (Util.startswith(name, "skeleton")) return "skeleton";
        if (name == "orc_berserker" || name == "orc_warrior") return "orc";
        if (name == "bandit_raider" || name == "bandit_leader") return "bandit";
        if (name == "nomad_outlaw" || name == "nomad_leader") return "nomad";
        // For whatever reason exp name == "goblin_figther" returns false here ???
        if (Util.startswith(name, "goblin")) {
            if (name.find("fighter") || name.find("wolfrider")) return "goblin"
        }
        if (name.find("wolf")) return "wolf";

        // varios scum, including low versions won't be promoted anyway
        return name;
    }
})


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

    function keys(data) {
        local res = [];
        foreach (key, _ in data) res.push(key);
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

    function pp(data, level = 0, funcs = true) {
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

            local items = [];
            foreach (k, v in data) {
                if (!funcs && typeof v == "function") continue;
                items.push(k + " = " + Debug.pp(v, level + 1, funcs))
            }
            // local items = Util.mapTable(data, @(k, v) k + " = " + Debug.pp(v, level + 1));
            return ppCont(items, level, "{", "}") + endln;
        } else if (typeof data == "array") {
            local items = data.map(@(item) Debug.pp(item, level + 1, funcs));
            return ppCont(items, level, "[", "]") + endln;
        } else {
            return "" + data + endln;  // More robust than .tostring()
        }
    }

    function log(name, data, funcs = true) {
        this.logInfo("<pre>se: " + name + " = " + Debug.pp(data, 0, funcs) + "</pre>");
    }
})


::mods_queue("mod_standout_enemies", null, function()
{
    this.logInfo("se: loading");

    ::mods_hookClass("entity/tactical/tactical_entity_manager", function(cls) {
        this.logInfo("se: hook tactical_entity_manager");

        local setupEntity = cls.setupEntity;
        cls.setupEntity = function(e, t) {
            setupEntity(e, t);

            // Arena doesn't have party, simply skip
            if (!("Party" in t)) return;

            this.logInfo("se: setupEntity " + e.getName() + " party " + t.Party.getName());
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

    // Since actor hook doesn't reach descendant of descendants
    // and hooking goblin_wolfrider yields random shit, we do it this way
    ::mods_hookBaseClass("entity/tactical/goblin", function(cls) {
        // Make demounted goblin inherit a quirk
        if ("spawnGoblin" in cls) {
            this.logInfo("se: fixing spawnGoblin");

            local spawnGoblin = cls.spawnGoblin;
            cls.spawnGoblin <- function (_info) {
                spawnGoblin(_info);

                if ("se_Quirk" in this.m) {
                    local goblin = _info.Tile.getEntity();
                    se.applyQuirk(goblin, this.m.se_Quirk);
                }
            }
        }
    })
});
