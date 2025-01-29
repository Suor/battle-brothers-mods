local mod = {
    ID = "mod_standout_enemies"
    Name = "Standout Enemies"
    Version = 1.3
}
::mods_registerMod(mod.ID, mod.Version, mod.Name);

local gt = this.getroottable();

// Alias things to make it easier for us inside. These are still global and accessible from outside,
// so if anyone will want to write a mod for this mod then it should be easy enough )
local se = gt.StandoutEnemies <- {};
local Mod = se.Mod <- {};

// Short refs to stdlib
local Rand = ::std.Rand, Str = ::std.Str, Util = ::std.Util;
local Debug = se.Debug <- ::std.Debug.with({prefix = "se: "});

local Config = se.Config <- {
    ScaleDays = 100  // scale varies by days
    ShortNames = {
        "Goblin Skirmisher": "Goblin",
        "Goblin Wolfrider": "Wolfrider",
        "Orc Berserker": "Berserker",
        "Brigand Raider": "Raider",
        "Nomad Outlaw": "Outlaw",
        "Fallen Hero": "Hero",
        "Barbarian Chosen": "Chosen",
        "Barbarian Reaver": "Reaver",
        "Barbarian Thrall": "Thrall",
    }
    function cutName(name) {
        if (name in this.ShortNames) return this.ShortNames[name];
        name = Str.cutprefix(name, "Ancient ");
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
            // More action points and initiative, add stamina and fatigue recovery to compensate
            e.m.BaseProperties.ActionPoints += 3;
            e.m.BaseProperties.Initiative += 25;
            e.m.BaseProperties.Stamina += 25;
            e.m.BaseProperties.FatigueRecoveryRate += 5;

            // Give adrenaline
            e.m.Skills.add(::new("scripts/skills/perks/perk_adrenalin"));
            e.m.AIAgent.addBehavior(::new("scripts/ai/tactical/behaviors/ai_adrenaline"));

            // Being fast helps hit and not being hit, reduce damage to compensate
            Mod.offense(e, 5, 0.9);
            Mod.defense(e, 5, 0.8);
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
            Mod.defense(e, -5, 1.8);
            Mod.bravery(e, 1.5);  // More hits need to be brave longer
            e.m.BaseProperties.Initiative -= Math.rand(5, 10); // Somewhat slow
            e.m.Skills.add(::new("scripts/skills/perks/perk_stalwart"));
            e.m.Skills.add(::new("scripts/skills/traits/iron_jaw_trait"));

            // TODO: double blood amount ?

            // A chance to add some armor upgrade, not for skeletons
            local armor = Mod.getArmor(e), cond = armor ? armor.getArmorMax() : 0;
            if (cond >= 45 && !e.getFlags().has("skeleton") && Rand.chance(0.4)) {
                local upgrades = ["leather_shoulderguards_upgrade" "double_mail_upgrade"];
                if (cond >= 80) upgrades.extend(["mail_patch_upgrade" "metal_plating_upgrade"]);
                if (Mod.isSouthern(e)) {
                    upgrades.extend(["hyena_fur_upgrade"])
                    if (cond >= 100 && Rand.chance(0.5)) upgrades.push("serpent_skin_upgrade");
                } else {
                    upgrades.extend(["direwolf_pelt_upgrade"]);
                    if (cond >= 90 && Rand.chance(0.5)) upgrades.push("additional_padding_upgrade");
                }
                Mod.ensureArmorUpgrade(e, upgrades);
            }

            // Actually bigger sprites and more blood
            Mod.scale(e, 1.15);
            e.m.DecapitateBloodAmount *= 2.0;
        }
    },
    Fearless = {
        Prefix = "Fearless",
        XPMult = 1.15,
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
            e.m.Skills.add(::new("scripts/skills/perks/perk_underdog"))  // Tends to stay last

            // Some little bonus to show yourself properly in battle
            e.m.BaseProperties.Bravery += 20;

            // Get rage effect or add it
            local rage = e.getSkills().getSkillByID("effects.berserker_rage");
            if (!rage) {
                rage = ::new("scripts/skills/effects/berserker_rage_effect");
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
            Mod.offense(e, 10);
            e.m.BaseProperties.RangedDefense += 15;
            e.m.BaseProperties.IsAffectedByNight = false;
            e.m.BaseProperties.HitChance = [50, 50];  // Up from 75/25

            e.m.Skills.add(::new("scripts/skills/perks/perk_head_hunter"));
            e.m.Skills.add(::new("scripts/skills/perks/perk_fast_adaption"));
            e.m.Skills.add(::new("scripts/skills/perks/perk_pathfinder"));
            e.m.Skills.add(::new("scripts/skills/actives/footwork"));
            e.getAIAgent().addBehavior(::new("scripts/ai/tactical/behaviors/ai_disengage"));

            // TODO: nomads/bandits
            Mod.ensureHelmet(e, ["full_leather_cap", "rusty_mail_coif"], 70);
        }
    },
    Quickshot = {
        Noun = "Quickshot",
        XPMult = 1.3,
        function apply(e) {
            // Do 3 quick shots, never aimed one
            local function patchSkill(_skill) {
                // .b is an MSU thing, otherwise their skill.softReset() overwrites changes
                if (_skill.getID() == "actives.quick_shot") {
                    _skill.m.ActionPointCost = 3;
                    if ("b" in _skill) _skill.b.ActionPointCost = 3;
                }
                if (_skill.getID() == "actives.aimed_shot") {
                    _skill.m.IsUsable = false;
                    if ("b" in _skill) _skill.b.IsUsable = false;
                }
            }

            foreach (skill in e.m.Skills.m.Skills) patchSkill(skill);

            // Patch if readded, i.e. bow is unequiped and then equiped again
            local skillsAdd = e.m.Skills.add;
            e.m.Skills.add = function (_skill, _order = 0) {
                patchSkill(_skill);
                skillsAdd(_skill, _order);
            }

            // Add initiative for overwhelm for work properly
            // Do not add fatigue recovery so that this rain of arrows will stop eventually
            e.m.BaseProperties.Initiative += 40;
            e.m.BaseProperties.Stamina += 25;

            // Bad shooter doesn't even try to shoot head
            Mod.offense(e, -10);
            e.m.BaseProperties.RangedDefense += 15;
            e.m.BaseProperties.HitChance = [95, 5];  // Down from 75/25

            // Move around fast and easy
            e.m.BaseProperties.MovementAPCostMult = 0.5
            e.m.BaseProperties.MovementFatigueCostMult = 0.5

            // Overwhelm and all sorts of "quick" perks
            e.m.Skills.add(::new("scripts/skills/perks/perk_overwhelm"));
            e.m.Skills.add(::new("scripts/skills/perks/perk_relentless"));
            e.m.Skills.add(::new("scripts/skills/perks/perk_dodge"));
            e.m.Skills.add(::new("scripts/skills/perks/perk_pathfinder"));
            e.m.Skills.add(::new("scripts/skills/perks/perk_quick_hands"));
            e.m.Skills.add(::new("scripts/skills/actives/footwork"));
            e.m.Skills.add(::new("scripts/skills/traits/athletic_trait"));
            e.getAIAgent().addBehavior(::new("scripts/ai/tactical/behaviors/ai_disengage"));

            // TODO: nomads/bandits
            Mod.ensureHelmet(e, ["open_leather_cap", "full_leather_cap"], 60);

            // Ensure not using a crossbow
            local weapon = Mod.getWeapon(e);
            if (!weapon || weapon.m.ID.find("crossbow") != null) {
                local bow = Mod.isSouthern(e) ? "oriental/composite_bow" : "hunting_bow";
                Mod.setWeapon(e, [bow]);
            }
            local ammo = e.m.Items.getItemAtSlot(::Const.ItemSlot.Ammo);
            if (ammo && ammo.m.AmmoType != ::Const.Items.AmmoType.Arrows) {
                e.m.Items.unequip(ammo);
                e.m.Items.equip(::new("scripts/items/ammo/quiver_of_arrows"));
            }
        }
    },
    Sly = {
        Prefix = "Sly",
        XPMult = 1.3,
        function apply(e) {
            Mod.offense(e, 10);
            e.m.BaseProperties.DamageDirectMult *= 1.1;
            Mod.bravery(e, 1.3);

            // Harder to kill with a ranged weapon and uses overwhelm to defend himself in melee
            e.m.BaseProperties.RangedDefense += 15;
            e.m.Skills.add(::new("scripts/skills/perks/perk_overwhelm"));

            e.m.Skills.add(::new("scripts/skills/racial/goblin_ambusher_racial"));
            e.m.Skills.add(::new("scripts/skills/perks/perk_dodge"));
            e.m.Skills.add(::new("scripts/skills/perks/perk_nine_lives"));
        }
    },
    Stubborn = {
        Prefix = "Stubborn",
        XPMult = 1.25,
        function apply(e) {
            Mod.defense(e, 0, 1.2);
            e.m.Skills.add(::new("scripts/skills/perks/perk_nine_lives"));

            if (!e.m.IsResurrected) {
                // Ensure helmet, these are better than average zombie has
                local helmets = ["dented_nasal_helmet" "rusty_mail_coif"];
                Mod.ensureHelmet(e, helmets, 150);
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
            Mod.defense(e, 15, 1.5);

            // Half-vampire :)
            e.m.Skills.add(::new("scripts/skills/racial/vampire_racial"));
            e.m.Skills.add(::new("scripts/skills/perks/perk_nine_lives"));
            e.m.Skills.add(::new("scripts/skills/perks/perk_nimble"));
            e.m.Skills.add(::new("scripts/skills/perks/perk_steel_brow"));
            e.m.Skills.add(::new("scripts/skills/perks/perk_anticipation"));

            // Resurrects like a stubborn one
            Quirk.Stubborn.stubborn(e, 0.75, 0.35);

            // Reddish head and body and no hair
            Mod.color(e, "head", "#ff9999", 0.9);
            Mod.color(e, "injury", "#ff9999", 0.9);
            Mod.color(e, "body", "#ff9999", 0.9);

            // Ensure helmet and armor, a little bit over nimble often to make these less tough
            local weapons = ["scramasax" "ancient/khopesh" "boar_spear" "hand_axe" "falchion"];
            Mod.ensureWeapon(e, weapons, 500);
            local helmets = ["nasal_helmet_with_rusty_mail" "dented_nasal_helmet" "mail_coif"];
            Mod.ensureHelmet(e, helmets, 200);
            local armors = ["mail_hauberk" "worn_mail_shirt" "patched_mail_shirt"];
            Mod.ensureArmor(e, armors, 400);

            // Cleaned up and bald
            e.getSprite("body_blood").Visible = false;
            e.getSprite("dirt").Visible = false;
            e.onAppearanceChanged <- function( _appearance, _setDirty = true ) {
                _appearance.HideHair = true;
                e.actor.onAppearanceChanged(_appearance, true);
            }
        }
    },
    SkilledNecro = {
        Prefix = "Skilled",
        XPMult = 1.8,
        function apply(e) {
            // This means necromancer will be able to cast 3 spells each turn
            local skills = e.getSkills().getAllSkillsOfType(gt.Const.SkillType.Active);
            foreach (s in skills) {
                if (s.m.ID == "actives.raise_undead" || s.m.ID == "actives.possess_undead") {
                    // MSUs .softReset() breaking this, employ countermeasures,
                    // see https://github.com/MSUTeam/MSU/issues/317
                    if ("b" in s) {
                        s.b.ActionPointCost = 2;
                        s.b.FatigueCost = 6;
                    }
                    s.m.ActionPointCost = 2;
                    s.m.FatigueCost = 6;
                }
            }

            e.m.BaseProperties.RangedDefense += 15; // A bit harder to shoot
            Mod.bravery(e, 1.5); // Many his zombies die, need extra bravery
            // Have some fancy weapon
            Mod.ensureWeapon(e, ["oriental/qatal_dagger", "ancient/khopesh", "rondel_dagger"], 300)
        }
    },
    Cursed = {
        Prefix = "Cursed",
        XPMult = 1.3,
        function apply(e) {
            // Give bravery and defense to make him stay for longer
            Mod.bravery(e, 1.7);
            e.m.BaseProperties.MeleeDefense += 15;
            e.m.Skills.add(::new("scripts/skills/cursed_skill"));
        }
    },
}

// Add names for debugging purposes
foreach (name, quirk in Quirk) quirk.pp <- name;


// Strategies that decide what to do with the whole party

local Strategy;  // Forward declaration
Strategy = se.Strategy <- {
    Bandit = {
        MinScale = 0.35,
        MaxScale = 1.15,
        AnyTypes = ["bandit", "nomad"],
        function getPlan(stats, maturity) {
            local num = se.getQuirkedNum(stats, this.AnyTypes, maturity, 0.4, 0.8);
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
    }
    Skeleton = {
        MinScale = 0.3
        MaxScale = 1.1
        AnyTypes = ["skeleton_light" "skeleton_medium" "skeleton_heavy"]
        function getPlan(stats, maturity) {
            local num = se.getQuirkedNum(stats, this.AnyTypes, maturity, 0.2, 0.4);
            local cursed = num / (Math.rand(1, 4) + (num >= 6 ? 1 : 0));
            num -= cursed;

            local plan = {};
            if (cursed > 0) stats.grow(plan, array(cursed, Quirk.Cursed), [4 2 1], this.AnyTypes);
            if (num > 0) stats.grow(plan, array(num, Quirk.Big), [4 2 1], this.AnyTypes);
            return plan;
        }
    }
    Shot = {
        MinScale = 0.4,
        MaxScale = 1.2,
        AnyTypes = ["bandit_marksman", "nomad_archer"],
        function getPlan(stats, maturity) {
            local scenario = Rand.weighted([55, 35, 10], ["head", "fast", "mixed"]);
            local min, max;
            switch (scenario) {
                case "head": min = 0.15; max = 0.5; break;
                case "fast": min = 0.3; max = 1; break;
                case "mixed": min = 0.2; max = 0.75; break;
            }

            local num = se.getQuirkedNum(stats, this.AnyTypes, maturity, min, max);
            if (num == 0) return null;

            local quirks;
            switch (scenario) {
                case "head": quirks = array(num, Quirk.Headshot); break;
                case "fast": quirks = array(num, Quirk.Quickshot); break;
                case "mixed": quirks = Rand.choices(num, [Quirk.Headshot, Quirk.Quickshot]); break;
            }

            // They don't go together so it's safe to queue both types to same array
            return {bandit_marksman = quirks, nomad_archer = quirks}
        }
    }
    Barbarian = {
        MinScale = 0.35,
        MaxScale = 1.1,
        Types = ["barbarian"],
        function getPlan(stats, maturity) {
            local num = se.getQuirkedNum(stats, this.Types, maturity, 0.6, 0.9);
            if (num == 0) return null;

            return {barbarian = Rand.choices(num, [Quirk.Fearless, Quirk.Fearless, Quirk.Big])}
        }
    },
    BarbarianChosen = {
        MinScale = 0.75,
        MaxScale = 1.5,
        Types = ["barbarian_champion"],  // These are called chosen in game
        function getPlan(stats, maturity) {
            local num = se.getQuirkedNum(stats, this.Types, maturity, 0.1, 0.2);
            if (num == 0) return null;

            return {barbarian_champion = array(num, Quirk.Furious)}
        }
    },
    Goblin = {
        MinScale = 0.35,
        MaxScale = 1.2,
        Types = ["goblin"],
        function getPlan(stats, maturity) {
            local num = se.getQuirkedNum(stats, this.Types, maturity, 0.4, 0.75);
            if (num == 0) return null;

            local plan = {};

            // Sometimes add some masterwork zombies
            if (maturity > 0.5 && Rand.chance(maturity * 0.5)) {
                local cursed = Rand.poly(num / 3, maturity - 0.5);
                num -= cursed;
                this.logInfo("se: Cursed goblins " + cursed + " maturity " + maturity + " scale " + stats.scale);
                stats.grow(plan, array(cursed, Quirk.Cursed), [1], ["goblin"]);
            }

            local quirks = [];
            switch (Rand.weighted([75, 33, 100], ["sly", "fast", "mixed"])) {
                case "sly": quirks = array(num, Quirk.Sly);
                case "fast": quirks = array(num, Quirk.Fast);
                case "mixed": quirks = Rand.choices(num, [Quirk.Fast, Quirk.Sly, Quirk.Sly]);
            }
            return stats.grow(plan, quirks, [1], ["goblin"]);
        }
    },
    Orc = {
        MinScale = 0.6,
        MaxScale = 1.6,
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
                if (dreadfulMaturity > 0 && Rand.chance(0.1 + dreadfulMaturity * 0.4)) {
                    plan.orc_warlord[0] = Quirk.Dreadful;
                }
            }

            // Small chance to make more berserkers Furious, but usually turn about one third
            local moreFury = maturity > 0.75 && Rand.chance(0.15 * maturity);
            plan.orc_berserker.apply(@(q) Rand.chance(moreFury ? 0.75 : 0.35) ? Quirk.Furious : q);

            return plan;
        }
    },
    Ghoul = {
        MinScale = 0.3,
        MaxScale = 1.1,
        Types = ["ghoul"],
        function getPlan(stats, maturity) {
            local num = se.getQuirkedNum(stats, this.Types, maturity, 0.5, 0.9);
            if (num == 0) return null;

            switch (Rand.weighted([33, 50, 100], ["sly", "fast", "mixed"])) {
                case "sly": return {ghoul = array(num, Quirk.Sly)};
                case "fast": return {ghoul = array(num, Quirk.Fast)};
                case "mixed": return {ghoul = Rand.choices(num, [Quirk.Fast, Quirk.Sly])};
            }
        }
    },
    Zombie = {
        MinScale = 0.25,
        MaxScale = 1.1,
        AnyTypes = ["zombie", "zombie_good"],
        function getPlan(stats, maturity) {
            // Max higher than 1 makes them all special more likely and earlier
            local num = se.getQuirkedNum(stats, this.AnyTypes, maturity, 0.45, 1.15);
            if (num == 0) return null;

            local plan = {};

            // Sometimes add some masterwork zombies
            if (maturity > 0.5 && Rand.chance(maturity * 0.5)) {
                // NOTE: maybe need to rework this calculation
                local masters = Rand.poly(num / 4, maturity - 0.4);
                this.logInfo("se: Masterwork zombie " + masters + " maturity " + maturity + " scale " + stats.scale);
                stats.grow(plan, array(masters, Quirk.Masterwork), [1 0], ["zombie_good" "zombie"]);
                num -= masters;
            }

            // Once in a while they are all stubborn, which makes for a long battle.
            // More common though we demonstrate variety.
            local quirks;
            switch (Rand.weighted([16, 24, 21, 39], ["stubborn", "big", "fast", "mixed"])) {
                case "stubborn":
                    quirks = array(num, Quirk.Stubborn); break;
                case "big":
                    quirks = array(num, Quirk.Big); break;
                case "fast":
                    quirks = array(num, Quirk.Fast); break;
                case "mixed":
                    quirks = Rand.choices(num, [Quirk.Fast, Quirk.Big, Quirk.Stubborn]);
                    break;
            }
            stats.grow(plan, quirks, [1 1], ["zombie_good" "zombie"]);
            return plan;
        }
    },
    Necromancer = {
        MinScale = 0.4,
        MaxScale = 1.2,
        Types = ["necromancer"],
        function getPlan(stats, maturity) {
            local prob = Math.pow(maturity, 0.33) * 0.7;
            local num = Rand.poly(maturity > 0.5 ? 2 : 1, prob);
            if (num == 0) return null;

            return {necromancer = array(num, Quirk.SkilledNecro)}
        }
    },
    NecroZombie = {
        Priority = 10
        MinScale = 0.5
        MaxScale = 1.5
        Types = ["necromancer"]
        AnyTypes = ["zombie" "zombie_good"]
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

                    // Replan, masterwork goes to good zombies first, the rest is spreaded evenly
                    plan.zombie = [];
                    plan.zombie_good = [];
                    stats.grow(plan, array(num, Quirk.Masterwork), [1 0], ["zombie_good" "zombie"]);
                    stats.grow(plan, quirks, [1 1], ["zombie_good" "zombie"]);
                }
            }

            return plan;
        }
    }
    // Test = {
    //     Priority = 100
    //     MinScale = 0.0
    //     MaxScale = 1.0
    //     AnyTypes = ["bandit" "nomad" "zombie" "zombie_good" "goblin"
    //                 "skeleton_light"  "skeleton_medium" "skeleton_heavy"
    //                 "orc_warrior"  "orc_berserker" "orc_warlord"]
    //     function getPlan(stats, maturity) {
    //         local weights = array(this.AnyTypes.len(), 1);
    //         return stats.grow({}, array(5, Quirk.Cursed), weights, this.AnyTypes);
    //     }
    // }
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
    // strategy.Name <- name
    if (!("Priority" in strategy)) strategy.Priority <- 0;
    SortedStrategies.push(strategy);
}
SortedStrategies.sort(@(a, b) b.Priority <=> a.Priority);


Util.extend(se, {
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
        stats.scale <- 1.0 * gt.World.getTime().Days / Config.ScaleDays;
        Debug.log("stats", stats, {funcs = false});

        local plans = [], priority = 9000;
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

                while (quirks.len() > 0 && types.len() > 0) {
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

                return plan;
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
        // // In case two parties are combined we may try to apply 2 quirks to one enemy
        // if ("se_Quirk" in e.m) return;

        local type = se.getTroopType(t);
        if (type in plan && plan[type].len()) {
            local quirk = plan[type].remove(0);
            if (quirk != null) {
                se.applyQuirk(e, quirk);
                se.quirkName(e, quirk);
            }
        }
    }

    function applyQuirk(e, quirk) {
        this.logInfo("se: Apply " + quirk.pp + " to " + e.getName());

        // Save to transfer to corpse and reapply on resurrection,
        // also used to transfer to surviving goblin of goblin wolfrider
        e.m.se_Quirk <- quirk;

        e.m.XP *= quirk.XPMult;
        if ("ResurrectionValue" in e.m) e.m.ResurrectionValue *= quirk.XPMult; // More valuable

        quirk.apply(e);

        // Update from base properties to current and e.m.*
        e.m.Skills.update();
    }

    function quirkName(e, quirk) {
        local prevName = e.m.Name;
        if ("Prefix" in quirk) e.m.Name = quirk.Prefix + " " + Config.cutName(e.m.Name);
        // if ("Noun" in quirk) e.m.Name = ::std.Re.find(e.m.Name, @"^(.+?)\b\w*$") + quirk.Noun;
        if ("Noun" in quirk) e.m.Name = split(e.m.Name, " -")[0] + " " + quirk.Noun;
        ::logInfo("se: name " + prevName + " -> " + e.m.Name);
    }

    function getTroopType(t) {
        if (t.Variant != 0) return "champion";  // Skip champions

        local nameParts = split(t.Script, "/");
        local name = nameParts[nameParts.len() - 1];

        if (name == "zombie") return "zombie";
        if (Str.startswith(name, "zombie") && name != "zombie_boss") return "zombie_good";
        if (Str.startswith(name, "skeleton_medium")) return "skeleton_medium";
        if (Str.startswith(name, "skeleton_heavy")) return "skeleton_heavy";
        if (name == "bandit_raider" || name == "bandit_leader") return "bandit";
        if (name == "nomad_outlaw" || name == "nomad_leader") return "nomad";
        if (name == "barbarian_thrall" || name == "barbarian_marauder") return "barbarian";
        // For whatever reason exp name == "goblin_figther" returns false here ???
        if (Str.startswith(name, "goblin")) {
            if (name.find("fighter") || name.find("wolfrider")) return "goblin"
        }
        if (name == "wolf" || name == "direwolf") return "wolf";
        if (name == "hyena" || name == "hyena_high") return "hyena";

        // The rest go as is. This includes both ones we want to handle separately
        // and varios scum, including low versions won't be promoted anyway
        return name;
    }
})


// Modification shortcuts

Util.extend(Mod, {
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
    function getWeapon(e) {
        return e.m.Items.getItemAtSlot(gt.Const.ItemSlot.Mainhand);
    }
    function setWeapon(e, options) {
        Mod.ensureWeapon(e, options, 1000000000);
    }
    function ensureWeapon(e, options, value = 0) {
        Mod._ensure(e, gt.Const.ItemSlot.Mainhand, "scripts/items/weapons/", options, value)
    }
    function ensureHelmet(e, options, value = 0) {
        Mod._ensure(e, gt.Const.ItemSlot.Head, "scripts/items/helmets/", options, value)
    }
    function ensureArmor(e, options, value = 0) {
        Mod._ensure(e, gt.Const.ItemSlot.Body, "scripts/items/armor/", options, value)
    }
    function _ensure(e, part, prefix, options, value = 0) {
        local item = e.m.Items.getItemAtSlot(part);
        logInfo("_ensure now " + (item ? item.getName() + " value=" + item.m.Value : null)
            + " expected value=" + value);
        if (!item || item.m.Value < value) {
            if (item) e.m.Items.unequip(item);
            item = ::new(prefix + Rand.choice(options));
            logInfo("_ensure chosen " + item.getName() + " value=" + item.m.Value);
            e.m.Items.equip(item);
        }
    }
    function getArmor(e) {
        return e.m.Items.getItemAtSlot(gt.Const.ItemSlot.Body);
    }
    function ensureArmorUpgrade(e, options) {
        local armor = Mod.getArmor(e);
        if (!armor || armor.getUpgrade()) return;

        local upgrade = ::new("scripts/items/armor_upgrades/" + Rand.choice(options));
        armor.setUpgrade(upgrade);
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

    // Tests
    function isSouthern(e) {
        return "getEthnicity" in e && e.getEthnicity() == 1
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
        if (!e.hasSprite(part)) return;

        local sprite = e.getSprite(part);
        sprite.Color = this.createColor(color);
        sprite.setBrightness(brightness);
        sprite.Saturation = saturation;
    }
})


::mods_queue("mod_standout_enemies", "stdlib, mod_hooks(>=20)", function() {
    this.logInfo("se: loading");
    ::include("scripts/standout_enemies_rosetta_ru");

    ::mods_hookClass("entity/tactical/tactical_entity_manager", function(cls) {
        local setupEntity = cls.setupEntity;
        cls.setupEntity = function(e, t) {
            setupEntity(e, t);

            // Arena doesn't have party, simply skip
            if (!("Party" in t)) return;

            // this.logInfo("se: setupEntity " + e.getName() + " party " + t.Party.getName());
            se.setupEntity(se.getPlan(t.Party), e, t);
        }
    });

    ::mods_hookBaseClass("entity/tactical/actor", function(cls) {
        // Save quirk to corpse and reapply on resurrection
        local onDeath = "onDeath" in cls ? cls.onDeath : cls.actor.onDeath;
        cls.onDeath <- function (_killer, _skill, _tile, _fatalityType) {
            onDeath(_killer, _skill, _tile, _fatalityType);
            if (_tile && "se_Quirk" in this.m) {
                logInfo("Died " + this.getName() + " quirk = " + this.m.se_Quirk.pp);
                local corpse = _tile.Properties.get("Corpse");
                corpse.se_Quirk <- this.m.se_Quirk;
                corpse.Value *= corpse.se_Quirk.XPMult;
            }
        }

        local onResurrected = "onResurrected" in cls ? cls.onResurrected : cls.actor.onResurrected;
        cls.onResurrected <- function (_info) {
            onResurrected(_info);
            if ("se_Quirk" in _info) se.applyQuirk(this, _info.se_Quirk);
        }
    })

    // Make a demounted goblin inherit a quirk
    ::mods_hookExactClass("entity/tactical/enemies/goblin_wolfrider", function(cls) {
        local spawnGoblin = cls.spawnGoblin;
        cls.spawnGoblin = function (_info) {
            spawnGoblin(_info);
            if ("se_Quirk" in this.m) {
                local goblin = _info.Tile.getEntity();
                se.applyQuirk(goblin, this.m.se_Quirk);
            }
        }
    })
})

::mods_queue("mod_standout_enemies", ">msu", function () {
     if (!("MSU" in getroottable())) return;
    ::include("scripts/standout_enemies_hack_msu");
    ::HackMSU.setup(mod, {
        nexus = "https://www.nexusmods.com/battlebrothers/mods/331"
        github = "https://github.com/Suor/battle-brothers-mods/tree/master/standout_enemies"
        tagPrefix = "standout-enemies-"
    })
});
