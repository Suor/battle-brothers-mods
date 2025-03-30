local mod = ::BroStudio <- {
    ID = "mod_bro_studio"
    Name = "Bro Studio"
    Version = "1.2.0"
    Debug = false //::std.Debug.with({prefix = "studio: "})
}
local Rand = ::std.Rand.using(::std.rng); // Use non Math rng generator to preserve seeds better

local mh = ::Hooks.register(mod.ID, mod.Version, mod.Name);
mh.require("stdlib >= 2.0", "mod_msu >= 1.2.6");
mh.conflictWith("mod_vap", "mod_ultrabros");
mh.queue(">stdlib", ">mod_msu", function () {
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
    ::Hooks.registerJS("ui/mods/bro_studio.js");

    local starting = false;
    local function rollTalentsNum() {
        local min = mod.conf("talentsMin");
        local max = mod.conf("talentsMax");
        local chance = mod.conf("talentsChance");
        return min + Rand.poly(max - min, chance / 100.0);
    }

    ::include("scripts/i_bro_studio_levelup_changes");

    local function onLevels(_player, _prevLevel) {
        if (_prevLevel >= _player.m.Level) return;

        this.logInfo("studio: Leveling up " + _player.getName()
                     + " from " + _prevLevel + " to " + _player.m.Level);
        // give extra perk points for certain levels
        for (local level = _prevLevel; ++level <= _player.m.Level;) {
            _player.m.PerkPoints += mod.extraPerks(level);
            local added = mod.addTraits(_player, mod.extraTraits(level));
            if (level > 1) _player.addLevelUpChanges("Bro Studio adds", added)
        }
    }

    mh.hook("scripts/entity/tactical/player", function (q) {
        if (::Hooks.hasMod("mod_legends")) {
            q.fillTalentValues = @(__original) function (_num, _force = false) {
                __original(_num, _force); // Move Math.rand() seed ...
                if (!starting) {
                    local opts = {force = _force || mod.conf("talentsRandomStart")};
                    mod.fillTalentValues(this, rollTalentsNum(), opts);
                }
            }
        } else {
            q.fillTalentValues = @(__original) function () {
                __original(); // Move Math.rand() seed the same way as prior this patch
                if (!starting) mod.fillTalentValues(this, rollTalentsNum());
            }
        }

        q.onHired = @(__original) function () {
            __original();
            mod.addTraits(this, mod.conf("traitsNum"));
            onLevels(this, 1);
        }

        q.updateLevel = @(__original) function () {
            local level = m.Level;
            __original();
            onLevels(this, level);
        }

        q.getAttributeLevelUpValues = @(__original) function () {
            mod.addAttributeLevelUpValues(this);
            return __original()
        }
    })

    // On setting up a new campaign all sort of things are hard coded,  typical is to  call
    // .setStartValuesEx() and assign LevelUps, PerkPoints by hand, etc
    mh.hookTree("scripts/scenarios/world/starting_scenario", function (q) {
        q.onSpawnAssets = @(__original) function () {
            starting = true;
            __original();
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
