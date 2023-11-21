::EliteFew <- {
    ID = "mod_elite_few"
    Name = "Elite Few - Master Bros"
    Version = "2.3.1"
};

// Replaces the original TheEliteFew and should load after any talent modifying mods
::mods_registerMod(::EliteFew.ID, ::EliteFew.Version, ::EliteFew.Name);
::mods_queue(::EliteFew.ID,
        "mod_hooks(>=20), !TheEliteFewCore,"
            + " >mod_ultrabros, >mod_bro_studio, >mod_weightedTalents, >mod_legends",
        function() {

    ::EliteFew.Mod <- ::MSU.Class.Mod(::EliteFew.ID, ::EliteFew.Version, ::EliteFew.Name);

    local page = ::EliteFew.Mod.ModSettings.addPage("General");
    local function add(elem) {
        page.addElement(elem);
        elem.Data.NewCampaign <- true;
    }
    ::EliteFew.conf <- function(name) {
        return ::EliteFew.Mod.ModSettings.getSetting(name).getValue();
    }

    add(::MSU.Class.EnumSetting("selectMode", "roll", ["roll" "all" "none"], "Select masters",
        "Select which bros become masters" +
        "\n\n[color=#1e468f]roll[/color] - anyone has a small chance from 1 in 100 to 1 in 30, " +
            "depending on the strength of one's background" +
        "\n[color=#8f1e1e]all[/color] - all bros are masters, for testing or cheating" +
        "\n[color=#222222]none[/color] - no new masters"
    ));
    add(::MSU.Class.RangeSetting("multiplier", 1, 1, 20, 1, "Chance multiplier",
        "Make each bro's chances to be a master this times higher. " +
        "Only applies if the setting to the left is set to \"roll\"." +
        "\n\n[color=#1e861e]1[/color] is for a normal game," +
        "\n[color=#1e468f]2-5[/color] is skewing into fun > balance," +
        "\n[color=#8f1e1e]10-20[/color] is close to cheating, also makes normal bros barely useful."
    ));
    // add(::MSU.Class.BooleanSetting("rangedBonus", true, "Higher chance for ranged bros", "..."))
    add(::MSU.Class.BooleanSetting("allowSlaves", false, "Allow slaves",
        "Slaves will never be masters unless this is set"));

    add(::MSU.Class.SettingsDivider("div1"));
    add(::MSU.Class.SettingsTitle("gameplayEffect", "Gameplay effects"))
    add(::MSU.Class.BooleanSetting("adjustStrength", true, "Adjust party strength",
        "Increase party strength if you have master bros." +
        " This affects enemy scaling, sending larger groups of enemies at you"
    ));
    add(::MSU.Class.BooleanSetting("excludeDubious", false, "Exclude dubious traits",
        "I.e. ones that not entirely negative like fat or impatient"));

    // A helper to wrap methods with unknown number of arguments, i.e. vanilla/legends distinction
    local function wrap(_func, _wrapper) {
        local function concat_call(func, args, vargs) {
            args.extend(vargs);  // Can modify it because we only pass anonymous arrays below
            return func.acall(args)
        }

        return function (...) {
            local self = this;
            local call = {
                super = @() concat_call(_func, [self], vargv)   // vargv from the func above
                func = @(...) concat_call(_func, [self], vargv) // lazy bindenv()
            }
            return concat_call(_wrapper, [this call], vargv);
        }
    }

    local function isRangedBg(_background) {
        local c = _background.onChangeAttributes();
        local melee = c.MeleeSkill[0], ranged = c.RangedSkill[0];
        return ranged > 0 && ranged - melee >= 10;
    }

    local function rollMaster(_background) {
        local backgroundID = _background.getID();

        if (::EliteFew.conf("selectMode") == "none") return false;
        if (backgroundID == "background.slave" && !::EliteFew.conf("allowSlaves")) return false;
        if (::EliteFew.conf("selectMode") == "all") return true;

        local multiplier = ::EliteFew.conf("multiplier")
        local rangedbg = isRangedBg(_background) ? 20 : 0;
        local chances = Math.max(30, 100 - 2 * _background.m.DailyCost - rangedbg);
        local roll = rng.next(1,  chances);
        this.logInfo("ef: roll for " + backgroundID + " chances=" + chances
            + " roll=" + roll + (roll <= multiplier ? " MASTER" : ""));
        return roll <= multiplier;
    }

    local isBackgroundUntalented = ::mods_getRegisteredMod("mod_legends")
        ? @(b) b.isBackgroundType(Const.BackgroundType.Untalented)
        : @(b) b.isUntalented()

    ::mods_hookNewObject("entity/tactical/player", function (o) {
        o.fillTalentValues = wrap(o.fillTalentValues, function(call, _num=3, _force=false) {
            call.super();

            local background = this.getBackground();
            if (!this.getSkills().hasSkill("trait.master")) return;
            if (!_force && background != null && isBackgroundUntalented(background)) return;

            local talents = this.m.Talents;
            // ::std.Debug.log("talents before", talents);
            local excluded = background ? background.getExcludedTalents() : [];

            // Add a new talent
            local left = [0 1 2 3 4 5 6 7].filter(@(_, t) talents[t] == 0);
            local options = left.filter(@(_, t) excluded.find(t) == null);
            if (options.len() == 0) options = left;
            if (options.len() > 0) {
                local stat = options[rng.next(0, options.len() - 1)];
                talents[stat] = 1; // The particular value is rolled below
            }

            // Reroll stars with higher 2-3 star probability
            for (local stat = 0; stat < this.Const.Attributes.COUNT; stat++) {
                if (talents[stat] == 0) continue;

                local roll = rng.next(1, 100);
                talents[stat] = roll <= 10 ? 1 : roll <= 60 ? 2 : 3;
            }
            // ::std.Debug.log("talents after", talents);
        })
    });

    ::mods_hookExactClass("skills/backgrounds/character_background", function(o) {
        local onUpdate = o.onUpdate;
        o.onUpdate = function(_properties) {
            onUpdate(_properties);

            // No easy access to DailyCost in traits, so we patch this
            if (this.m.DailyCost != 0 && !this.getContainer().hasSkill("trait.player")
                                      && this.getContainer().hasSkill("trait.master")) {
                _properties.DailyWage += 9;
            }
        }

        local attrGaps = {
            Hitpoints = 10
            Bravery = 10
            Stamina = 10
            MeleeSkill = 10
            RangedSkill = 10
            MeleeDefense = 5
            RangedDefense = 5
            Initiative = 10
        };
        // For Legends
        local zombieGaps = clone attrGaps;
        zombieGaps.MeleeDefense = 0;
        zombieGaps.RangedDefense = 0;

        // buildAttributes() happens after background is added, so it's convenient to both roll
        // for master trait and hack buildAttributes() themselves.
        o.buildAttributes = wrap(o.buildAttributes, function (call, _tag=null, _attrs=null) {
            // NOTE: the Legends _attrs param also contains ranges.
            //       Low and high bounds are always the same there though, so ignoring them is ok.
            local master = rollMaster(this);
            if (!master) return call.super();

            local trait = this.new("scripts/skills/traits/master_trait");
            this.getContainer().add(trait);
            // The master trait won't be queried for excluded so we copy those to the background
            this.m.Excluded.extend(trait.m.Excluded);

            // Patching this globally messes some mods like Background Attribute Ranges.
            // Will also break the isRangedBg() above.
            local gaps = _tag == "zombie" ? zombieGaps : attrGaps;
            local onChangeAttributes = this.onChangeAttributes;
            this.onChangeAttributes = function () {
                local c = onChangeAttributes();
                // Make low bound equal high
                foreach (attr, bonuses in c) bonuses[0] = gaps[attr] + bonuses[1];
                return c;
            }
            local ret = call.super();
            this.onChangeAttributes = onChangeAttributes;
            return ret;
        })
    });

    // Adjust player party strength (affects enemy scaling), to not make our life too easy
    ::mods_hookNewObject("entity/world/player_party", function (o) {
        o.updateStrength = wrap(o.updateStrength, function(call, ...) {
            call.super();
            if (!::EliteFew.conf("adjustStrength")) return;

            local roster = this.World.getPlayerRoster().getAll();

            local scaleMax = this.World.Assets.getBrothersScaleMax();
            if (roster.len() > scaleMax) {
                roster.sort(this.onLevelCompare);
                roster = roster.slice(0, scaleMax);
            }

            foreach (bro in roster) {
                if (bro.getSkills().hasSkill("trait.master")) {
                    // NOTE: Legends has formulas depending on difficulty, ignore that for now.
                    //       They also ignore .getBrothersScaleMax() from above.
                    local coef = Math.min(50, bro.getBackground().m.DailyCost * 0.5 + 25) / 100.0;
                    this.m.Strength += (bro.getLevel() - 1) * coef * 2.0;
                }
            }
        })
    });
});
