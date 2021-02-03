::mods_registerMod("mod_standout_enemies", 0.6, "Standout Enemies");

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
        "Barbarian Chosen": "Chosen",
        "Barbarian Reaver": "Reaver",
    }
    function cutName(name) {
        if (name in this.ShortNames) return this.ShortNames[name];
        return name;
    }
}


// Available quirks

local Quirk;  // Forward declaration
Quirk = se.Quirk <- {
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
        Prefix = "Huge",
        XPMult = 1.2,
        function apply(e) {
            Mod.offense(e, 0, 1.25);
            Mod.defense(e, -5, 1.75);
            Mod.bravery(e, 1.5);  // More hits need to be brave longer
            Mod.scale(e, 1.15);  // Actually bigger sprites :)
        }
    },
    Fearless = {
        Prefix = "Fearless",
        XPMult = 1.2,
        function apply(e) {
            // Vary so that some keep longer
            e.m.BaseProperties.Bravery += Math.rand(25, 50);
        }
    },
    Furious = {
        Prefix = "Furious",
        XPMult = 1.4,
        function apply(e) {
            Mod.offense(e, 5);  // Not really impressive when he misses all the time
            e.m.BaseProperties.MeleeDefense += 5;  // Don't protect from ranged
            e.m.Skills.add(this.new("scripts/skills/perks/perk_underdog"))  // Tends to stay last

            // Some little bonus to show yourself properly in battle
            e.m.BaseProperties.Bravery += 20;

            // Get rage effect or add it
            local rage = e.getSkills().getSkillByID("effects.berserker_rage");
            if (!rage) {
                rage = this.new("scripts/skills/effects/berserker_rage_effect");
                e.m.Skills.add(rage);

                // Adapt actor to work with berserker rage
                e.updateRageVisuals <- function(_rage) {
                    if (_rage > 6) this.setDirty(true);
                }
            }

            // Start with some rage
            rage.addRage(12);

            // Grow rage twice faster
            local addRage = rage.addRage;
            rage.addRage = function(rage) {
                addRage(rage * 2);
            }

            // Add some rage on miss
            rage.onTargetMissed <- function(_skill, _targetEntity) {
                addRage(3);
            }

            // Get some rage on every time being attacked
            rage.onMissed <- function(_attacker, _skill, _dontShake = false) {
                addRage(1);
            }
            rage.onDamageReceived <- function(_attacker, _damageHitpoints, _damageArmor) {
                addRage(3);
            }
        }
    },
    Dreadful = {
        Prefix = "Dreadful",
        XPMult = 3,
        function apply(e) {
            // Won't run, recieve less damage to stay longer
            e.m.BaseProperties.Bravery += 50;
            e.m.BaseProperties.DamageReceivedTotalMult *= 0.66;

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
        XPMult = 1.3,
        function apply(e) {
            e.m.Name = split(e.m.Name, " ")[0] + " " + this.Noun;

            Mod.offense(e, 10);
            e.m.BaseProperties.RangedDefense += 15;

            e.m.BaseProperties.IsAffectedByNight = false;

            e.m.BaseProperties.HitChance = [50, 50];  // Up from 75/25
            e.m.Skills.add(this.new("scripts/skills/perks/perk_head_hunter"));
            e.m.Skills.add(this.new("scripts/skills/perks/perk_fast_adaption"));
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

            if (!e.m.IsResurrected) {
                // Ensure helmet, these are better than average zombie has
                local helmets = ["kettle_hat" "padded_kettle_hat" "dented_nasal_helmet" "mail_coif"];
                Mod.ensureHelmet(e, helmets);
            }
            this.stubborn(e, 0.60, 0.25);
        }
        function stubborn(e, hpPct, armorPct) {
            if (!e.m.IsResurrected) {
                e.m.ResurrectionChance = 100;  // Definitely resurrect first time

                // Make helmet and armor better
                Mod.addArmorPct(e, "head", 0.16);
                Mod.addArmorPct(e, "body", 0.16);
            } else {
                // Adjust resurects
                e.setHitpointsPct(hpPct);    // Up from 0.45
                e.m.ResurrectionChance = 60; // Ressurect 2.5 times on average after first one
                e.m.IsResurrected = false;

                // Regenerate armor a bit
                Mod.addArmorPct(e, "body", armorPct + Rand.range(-0.1, 0.1));
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
            e.m.Skills.add(this.new("scripts/skills/perks/perk_nine_lives"));
            e.m.Skills.add(this.new("scripts/skills/perks/perk_nimble"));
            e.m.Skills.add(this.new("scripts/skills/perks/perk_steel_brow"));
            e.m.Skills.add(this.new("scripts/skills/perks/perk_anticipation"));
            e.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));

            // Resurrects like a stubborn one
            Quirk.Stubborn.stubborn(e, 0.75, 0.35);

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

local Strategy;  // Forward declaration
Strategy = se.Strategy <- {
    Bandit = {
        Priority = 4,
        MinScale = 0.35,
        MaxScale = 1.1,
        AnyTypes = ["bandit", "nomad"],
        function getPlan(stats, maturity) {
            local num = se.getQuirkedNum(stats, this.AnyTypes, maturity, 0.45, 0.75);
            num = num || 1;  // One guaranteed special bandit

            local quirks;
            switch (Rand.weighted([50, 50, 100], ["big", "fast", "mixed"])) {
                case "big": quirks = array(num, Quirk.Big); break;
                case "fast": quirks = array(num, Quirk.Fast); break;
                case "mixed": quirks = Rand.choices(num, [Quirk.Fast, Quirk.Big]); break;
            }

            // They don't go together so it's safe to queue both types to same array
            return {bandit = quirks, nomad = quirks};
        }
    },
    Headshot = {
        Priority = 4,
        MinScale = 0.4,
        MaxScale = 1.2,
        AnyTypes = ["bandit_marksman", "nomad_archer"],
        function getPlan(stats, maturity) {
            local num = se.getQuirkedNum(stats, this.AnyTypes, maturity, 0.15, 0.5);
            if (num == 0) return null;

            // They don't go together so it's safe to queue both types to same array
            local quirks = array(num, Quirk.Headshot);
            return {bandit_marksman = quirks, nomad_archer = quirks}
        }
    }
    Barbarian = {
        Priority = 4,
        MinScale = 0.35,
        MaxScale = 1.1,
        Types = ["barbarian"],
        function getPlan(stats, maturity) {
            local num = se.getQuirkedNum(stats, this.Types, maturity, 0.5, 0.9);
            if (num == 0) return null;

            return {barbarian = array(num, Quirk.Fearless)}
        }
    },
    BarbarianChosen = {
        Priority = 4,
        MinScale = 0.5,
        MaxScale = 1.5,
        Types = ["barbarian_champion"],  // These are called chosen in game
        function getPlan(stats, maturity) {
            local num = se.getQuirkedNum(stats, this.Types, maturity, 0.1, 0.2);
            if (num == 0) return null;

            return {barbarian_champion = array(num, Quirk.Furious)}
        }
    },
    Goblin = {
        Priority = 4,
        MinScale = 0.35,
        MaxScale = 1.2,
        Types = ["goblin"],
        function getPlan(stats, maturity) {
            local num = se.getQuirkedNum(stats, this.Types, maturity, 0.4, 0.75);
            if (num == 0) return null;

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
        AnyTypes = ["orc_warrior", "orc_berserker", "orc_warlord"],
        function getPlan(stats, maturity) {
            local num = se.getQuirkedNum(stats, this.AnyTypes, maturity, 0.5, 1);
            // Good chance for at least one, even early on
            if (num == 0 && Rand.chance(0.5 + maturity * 2)) num++;
            if (num == 0) return null;

            local plan = {};

            // Warlords always take one
            stats.grow(plan, [Quirk.Fearless], [1], ["orc_warlord"]);
            num -= plan.orc_warlord.len();  // There might be no warlord

            // The rest are distributed "honestly"
            local weights = [2 1 1];
            local types = ["orc_warlord" "orc_warrior" "orc_berserker"];
            stats.grow(plan, array(num, Quirk.Fearless), weights, types);

            // Some chance to make a dreadful warlord from scale 0.8,
            // ends in fifty-fifty at scale 2
            if (plan.orc_warlord.len() > 0) {
                local dreadfulMaturity = se.getMaturity(stats.scale, 0.8, 2.0);
                if (dreadfulMaturity >= 0 && Rand.chance(0.1 + dreadfulMaturity * 0.4)) {
                    plan.orc_warlord[0] = Quirk.Dreadful;
                }
            }

            // Small chance to make all quirked berserkers Furious, but usually turn half of them
            local allFury = maturity > 0.5 && Rand.chance(0.15);
            plan.orc_berserker.apply(@(q) allFury || Rand.chance(0.5) ? Quirk.Furious : q);

            return plan;
        }
    },
    Zombie = {
        Priority = 4,
        MinScale = 0.25,
        MaxScale = 1.1,
        AnyTypes = ["zombie", "zombie_good"],
        function getPlan(stats, maturity) {
            // Max higher than 1 makes them all special more likely and earlier
            local num = se.getQuirkedNum(stats, this.AnyTypes, maturity, 0.6, 1.1);
            if (num == 0) return null;

            local quirks;
            switch (Rand.weighted([100, 40, 20, 80], ["stubborn", "big", "fast", "mixed"])) {
                case "stubborn":
                    quirks = array(num, Quirk.Stubborn); break;
                case "big":
                    quirks = array(num, Quirk.Big); break;
                case "fast":
                    quirks = array(num, Quirk.Fast); break;
                case "mixed":
                    local options = [Quirk.Fast, Quirk.Big, Quirk.Stubborn, Quirk.Stubborn];
                    quirks = Rand.choices(num, options);
                    break;
            }

            local plan = {};

            // Rarely add some masterwork zombies
            if (maturity > 0.5 && Rand.chance(maturity * 0.5)) {
                local total = Util.sum(this.AnyTypes.map(stats.count));
                local masters = Rand.poly(total / 8, maturity - 0.5);
                stats.grow(plan, array(masters, Quirk.Masterwork), [1 0], ["zombie_good" "zombie"]);
            }

            stats.grow(plan, quirks, [1 1], ["zombie_good" "zombie"]);

            return plan;
        }
    },
    Necromancer = {
        Priority = 4,
        MinScale = 0.4,
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
        MinScale = 0.5,
        MaxScale = 1.5,
        Types = ["necromancer"],
        AnyTypes = ["zombie", "zombie_good"],
        function getPlan(stats, maturity) {
            local necroPlan = Strategy.Necromancer.getPlan(stats, maturity);

            // A little bit less quirked zombies if necro is quirked
            local zombieMaturity = necroPlan ? se.getMaturity(stats.scale, 0.35, 1.2) : null;
            local zombiePlan = Strategy.Zombie.getPlan(stats, zombieMaturity);

            local plan = Util.merge(necroPlan, zombiePlan);

            // Each skilled necro might have a masterwork
            if (maturity >= 0.25 && "necromancer" in plan) {
                local num = Rand.poly(plan.necromancer.len(), 0.5 + maturity * 0.25);
                if (num) {
                    // Separate masterwork from other quirks
                    local quirks = Util.concat(plan.zombie, plan.zombie_good);
                    num += quirks.filter(@(_, q) q == Quirk.Masterwork).len();
                    quirks = quirks.filter(@(_, q) q != Quirk.Masterwork);

                    // Replan, masterwork goes to good zombies first, the rest a spreaded evenly
                    plan.zombie = [];
                    plan.zombie_good = [];
                    stats.grow(plan, array(num, Quirk.Masterwork), [1 0], ["zombie_good" "zombie"]);
                    stats.grow(plan, quirks, [1 1], ["zombie_good" "zombie"]);
                }
            }

            return plan;
        }
    },
}
// Make passing maturity optional and adding logging to all .getPlan() methods
foreach (_name, strategy in Strategy) {
    local name = _name;  // for closure
    local getPlan = strategy.getPlan;
    strategy.getPlan = function(stats, maturity = null) {
        if (maturity == null) maturity = se.getMaturity(stats.scale, this.MinScale, this.MaxScale);

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

        // Start from 15% of effect and scale to 100% linearly.
        // The things should appear at the MinScale, not days later.
        local mod = 0.15 + 0.85 * maturity;
        local min = minPart * mod * count;
        local max = maxPart * mod * count;
        local roll = Math.rand(min * 100, max * 100 + 99);
        this.logInfo("se: getQuirkedNum min " + min + " max " + (max + 0.99) + " roll " + roll * 0.01);
        return roll / 100;
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
            if (plan) plans.push(plan);
        }

        local finalPlan = se.mergePlans(plans);
        Debug.log("the final plan", finalPlan);
        return party.m.se_Plan <- finalPlan;
    }

    function mergePlans(plans) {
        if (plans.len() == 0) return {};
        if (plans.len() == 1) return plans[0];

        local merged = {};

        foreach (p in plans) {
            foreach (type, quirks in p) {
                if (quirks.len() == 0) continue;  // Empty suggestions are ignored
                if (!(type in merged)) merged[type] <- [];
                merged[type].push(quirks)
            }
        }

        foreach (type, options in merged) {
            merged[type] = Rand.choice(options)
        }

        return merged;
    }

    function getMaturity(scale, min, max) {
        local maturity = (scale - min) / (max - min);
        return Math.maxf(0, Math.minf(1, maturity));  // Cap into [0, 1]
    }

    function partyStats(party) {
        this.logInfo("se: partyStats " + party.getName());

        local faction = this.World.FactionManager.getFaction(party.getFaction());
        local stats;
        stats = {
            FactionType = faction ? faction.ClassName : null,
            Total = party.m.Troops.len()
            Counts = {}
            function count(type) {
                return type in stats.Counts ? stats.Counts[type] : 0;
            }
            function grow(plan, _quirks, _weights, _types) {
                // Clone these to not modify arguments
                local quirks = clone _quirks, weights = clone _weights, types = clone _types;

                // Add empty arrays to plan
                foreach (who in types)
                    if (!(who in plan)) plan[who] <- [];

                for (; quirks.len() > 0;) {
                    if (types.len() == 0) break;
                    local who = types.len() > 1 ? Rand.weighted(weights, types) : types[0];

                    // Shrink types if cap is reached
                    if (!(who in this.Counts) || plan[who].len() >= this.Counts[who]) {
                        local i = types.find(who);
                        weights.remove(i);
                        types.remove(i);
                        continue;
                    }

                    Rand.insert(plan[who], quirks.remove(0));
                }
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

        if (name == "zombie") return "zombie";
        if (Util.startswith(name, "zombie") && name != "zombie_boss") return "zombie_good";
        if (Util.startswith(name, "skeleton")) return "skeleton";
        if (name == "bandit_raider" || name == "bandit_leader") return "bandit";
        if (name == "nomad_outlaw" || name == "nomad_leader") return "nomad";
        if (name == "barbarian_thrall" || name == "barbarian_marauder") return "barbarian";
        // For whatever reason exp name == "goblin_figther" returns false here ???
        if (Util.startswith(name, "goblin")) {
            if (name.find("fighter") || name.find("wolfrider")) return "goblin"
        }
        if (name.find("wolf")) return "wolf";

        // The rest go as is. This includes both ones we want to handle separately
        // and varios scum, including low versions won't be promoted anyway
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

    // Items
    function ensureHelmet(e, options) {
        local helmet = e.m.Items.getItemAtSlot(gt.Const.ItemSlot.Head);
        if (!helmet) {
            helmet = this.new("scripts/items/helmets/" + Rand.choice(options));
            e.m.Items.equip(helmet);
        }
    }

    function addArmorPct(e, part, pct) {
        local slot = part == "head" ? gt.Const.ItemSlot.Head : gt.Const.ItemSlot.Body;
        local piece = e.m.Items.getItemAtSlot(slot);
        if (piece) {
            local armor = piece.getArmor();
            local armorMax = piece.getArmorMax();
            piece.setArmor(Math.min(armorMax, armor + pct * armorMax));
        }
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
    function chance(prob) {
        if (prob <= 0) return false;
        return this.Math.rand(1, 1000) <= prob * 1000;
    }

    function choice(arr) {
        return arr[this.Math.rand(0, arr.len() - 1)];
    }
    function choices(num, arr) {
        local res = [];
        for (local i = 0; i < num; i++) res.push(Rand.choice(arr));
        return res;
    }
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
    function insert(arr, item, num = 1) {
        for (local i = 0; i < num; i++) {
            local index = Math.rand(0, arr.len());
            arr.insert(index, item);
        }
    }

    function poly(tries, prob) {
        if (prob <= 0 || tries == 0) return 0;

        local num = 0;
        for (local i = 0; i < tries; i++)
            if (Rand.chance(prob)) num++;
        return num;
    }
    function range(from, to) {
        return Math.rand(from * 1000, to * 1000) / 1000.0;
    }
})


extend(Util, {
    function startswith(s, sub) {
        if (s.len() < sub.len()) return false;
        return s.slice(0, sub.len()) == sub;
    }

    function concat(...){
        local res = [];
        foreach (arr in vargv) res.extend(arr);
        return res
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
    PP_MAX_LENGTH = 80,

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
            return ppCont(items, level, "{", "}") + endln;
        } else if (typeof data == "array") {
            local items = data.map(@(item) Debug.pp(item, level + 1, funcs));
            return ppCont(items, level, "[", "]") + endln;
        } else if (data == null) {
            return "null" + endln;
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
