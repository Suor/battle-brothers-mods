::mods_registerMod("mod_elite_few", 2.0);

// Replaces the original TheEliteFew and should load after any talent modifying mods
::mods_queue("mod_elite_few",
        "mod_hooks(>=19), !TheEliteFewCore, >mod_ultrabros, >mod_weightedTalents",
        function() {
    // Configuration
    local masterMultiplier = 3;
    local masterGuaranteed = false;
    local masterSlaves = false;
    local adjustDifficulty = true;

    // Support old submodules for now
    foreach (mod in ::mods_getRegisteredMods()) {
        if(mod.Name == "TheEliteAddon2x") { masterMultiplier = 2; }
        else if (mod.Name == "TheEliteAddon5x") { masterMultiplier = 5; }
        else if (mod.Name == "TheEliteAddon10x") { masterMultiplier = 10; }
        else if (mod.Name == "TheEliteAddon20x") { masterMultiplier = 20; }
        if(mod.Name == "TheEliteAddonCheat") { masterGuaranteed = true; }
        if(mod.Name == "TheEliteAddonSlaves") { masterSlaves = true; }
        if(mod.Name == "TheEliteAddonEasy") { adjustDifficulty = false;}
    }
    this.logInfo("ef: Elite Few (Compatible) Configured with multiplier: "
        + masterMultiplier + " Cheat: " + masterGuaranteed +  " Slaves: " + masterSlaves
        + " Difficulty Adjustment: " + adjustDifficulty);

    local function isRangedBg(_background) {
        local c = _background.onChangeAttributes();
        local melee = c.MeleeSkill[0], ranged = c.RangedSkill[0];
        return ranged > 0 && ranged - melee >= 10;
    }

    local function rollMaster(_background) {
        local backgroundID = _background.getID();

        if (!masterSlaves && backgroundID == "background.slave") return false;
        if (masterGuaranteed) return true;

        local rangedbg = isRangedBg(_background) ? 20 : 0;
        local chances = Math.max(30, 100 - 2 * _background.m.DailyCost - rangedbg);
        local roll = rng.next(1,  chances);
        this.logInfo("ef: roll for " + backgroundID + " chances=" + chances
            + " roll=" + roll + (roll <= masterMultiplier ? " MASTER" : ""));
        return roll <= masterMultiplier;
    }

    ::mods_hookNewObject("entity/tactical/player", function (o) {
        local fillTalentValues = o.fillTalentValues;
        o.fillTalentValues = function() {
            fillTalentValues();

            local background = this.getBackground();
            if (!this.getSkills().hasSkill("trait.master")) return;
            if (background != null && background.isUntalented()) return;

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
        }
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

        local lowHighGap = {
            Hitpoints = 10
            Bravery = 10
            Stamina = 10
            MeleeSkill = 10
            RangedSkill = 10
            MeleeDefense = 5
            RangedDefense = 5
            Initiative = 10
        };

        // buildAttributes() happens after background is added, so it's convenient to both roll
        // for master trait and hack buildAttributes() themselves.
        local buildAttributes = o.buildAttributes;
        o.buildAttributes = function() {
            local master = rollMaster(this);
            if (!master) return buildAttributes();

            local trait = this.new("scripts/skills/traits/master_trait");
            this.getContainer().add(trait);
            // The master trait won't be queried for excluded so we copy those to the background
            this.m.Excluded.extend(trait.m.Excluded);

            // Patching this globally messes some mods like Background Attribute Ranges.
            // Will also break the isRangedBg() above.
            local onChangeAttributes = this.onChangeAttributes;
            this.onChangeAttributes = function () {
                local c = onChangeAttributes();
                // Make low bound equal high
                foreach (attr, bonuses in c) bonuses[0] = lowHighGap[attr] + bonuses[1];
                return c;
            }
            buildAttributes()
            this.onChangeAttributes = onChangeAttributes;
        }
    });

    // Adjust player party strength (affects enemy scaling), to not make our life too easy
    ::mods_hookNewObjectOnce("entity/world/player_party", function (o) {
        local updateStrength = o.updateStrength;
        o.updateStrength = function() {
            updateStrength();
            if (!adjustDifficulty) return;

            local roster = this.World.getPlayerRoster().getAll();

            local scaleMax = this.World.Assets.getBrothersScaleMax();
            if (roster.len() > scaleMax) {
                roster.sort(this.onLevelCompare);
                roster = roster.slice(0, scaleMax);
            }

            foreach (bro in roster) {
                if (bro.getSkills().hasSkill("trait.master")) {
                    local coef = (bro.getBackground().m.DailyCost * 0.5 + 25) / 100;
                    this.m.Strength += bro.getLevel() * coef * 2.0;
                }
            }
        }
    });
});
