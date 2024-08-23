local mod = ::BroStudio <- {
    ID = "mod_bro_studio"
    Name = "Bro Studio"
    Version = "1.1.0"
    Debug = false //::std.Debug.with({prefix = "studio: "})
}
local Rand = ::std.Rand.using(::rng); // Use non Math rng generator to preserve seeds better

::mods_registerMod(mod.ID, mod.Version, mod.Name);
::mods_queue(mod.ID, "stdlib(>=1.8), mod_hooks(>=20), mod_msu(>=1.2.6), !mod_vap, !mod_ultrabros",
        function() {
    mod.Mod <- ::MSU.Class.Mod(mod.ID, mod.Version, mod.Name);
    mod.conf <- function (name) {
        return mod.Mod.ModSettings.getSetting(name).getValue();
    }
    mod.addPage <- function (title) {
        local page = mod.Mod.ModSettings.addPage(title);
        return {
            function add(elem) {
                page.addElement(elem);
                elem.Data.NewCampaign <- true;
                return elem;
            }
        }
    }

    ::include("bro_studio/slider_setting");
    ::include("bro_studio/attrs");
    ::include("bro_studio/perks");
    ::include("bro_studio/traits");
    ::mods_registerJS("bro_studio.js");

    local starting = false;
    local function rollTalentsNum() {
        local min = mod.conf("talentsMin");
        local max = mod.conf("talentsMax");
        local chance = mod.conf("talentsChance");
        return min + Rand.poly(max - min, chance / 100.0);
    }

    local function onLevels(_player, _prevLevel) {
        if (_prevLevel >= _player.m.Level) return;

        this.logInfo("studio: Leveling up " + _player.getName()
                     + " from " + _prevLevel + " to " + _player.m.Level);
        // give extra perk points for certain levels
        for (local level = _prevLevel; ++level <= _player.m.Level;) {
            _player.m.PerkPoints += mod.extraPerks(level);
            mod.addTraits(_player, mod.extraTraits(level));
        }
    }

    ::mods_hookExactClass("entity/tactical/player", function (cls) {
        local fillTalentValues = cls.fillTalentValues;
        if (::mods_getRegisteredMod("mod_legends")) {
            cls.fillTalentValues = function (_num, _force = false) {
                fillTalentValues(_num, _force); // Move Math.rand() seed ...
                if (!starting) {
                    local opts = {force = _force || mod.conf("talentsRandomStart")};
                    mod.fillTalentValues(this, rollTalentsNum(), opts);
                }
            }
        } else {
            cls.fillTalentValues = function () {
                fillTalentValues(); // Move Math.rand() seed the same way as prior this patch
                if (!starting) mod.fillTalentValues(this, rollTalentsNum());
            }
        }

        local onHired = cls.onHired;
        cls.onHired = function () {
            onHired();
            mod.addTraits(this, mod.conf("traitsNum"));
            onLevels(this, 1);
        }

        local updateLevel = cls.updateLevel;
        cls.updateLevel = function () {
            local level = m.Level;
            updateLevel();
            onLevels(this, level);
        }

        local getAttributeLevelUpValues = cls.getAttributeLevelUpValues;
        cls.getAttributeLevelUpValues = function () {
            mod.addAttributeLevelUpValues(this);
            return getAttributeLevelUpValues()
        }
    })

    // On setting up a new campaign all sort of things are hard coded,  typical is to  call
    // .setStartValuesEx() and assign LevelUps, PerkPoints by hand, etc
    ::mods_hookBaseClass("scenarios/world/starting_scenario", function (cls) {
        local onSpawnAssets = "onSpawnAssets" in cls
            ? cls.onSpawnAssets : cls.starting_scenario.onSpawnAssets;
        cls.onSpawnAssets <- function () {
            starting = true;
            onSpawnAssets();
            starting = false;

            // Set up starting bros
            local roster = World.getPlayerRoster().getAll();
            foreach (bro in roster) {
                // Need to reroll talents here because some scenarios assign them by hand
                // after the player.setStartValuesEx() call
                if (mod.conf("talentsRandomStart")) mod.fillTalentValues(bro, rollTalentsNum());
                mod.addTraits(bro, mod.conf("traitsNum"));
                onLevels(bro, 1);
            }
        }
    })
})
