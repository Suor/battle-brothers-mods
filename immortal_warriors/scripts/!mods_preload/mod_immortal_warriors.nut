local mod = ::ImmortalWarriors <- {
    ID = "mod_immortal_warriors"
    Name = "Immortal Warriors"
    Version = "0.1.1"
};
local Rand = ::std.Rand.using(::rng), Util = ::std.Util, Table = ::std.Table;
local Debug = ::std.Debug.with({prefix = "iw: "}).noop();

::mods_registerMod(mod.ID, mod.Version, mod.Name);
::mods_queue(mod.ID, "mod_hooks(>=20), stdlib(>=2.5), mod_msu(>=1.5.0)", function () {
    mod.Mod <- ::MSU.Class.Mod(mod.ID, mod.Version, mod.Name);

    local page = mod.Mod.ModSettings.addPage("General");
    local function add(elem) {
        page.addElement(elem);
        elem.Data.NewCampaign <- true;
    }
    mod.conf <- function(name) {
        return mod.Mod.ModSettings.getSetting(name).getValue();
    }

    add(::MSU.Class.RangeSetting("number", 3, 0, 7, 1, "Number of Immortals",
        "Start with this number of soul jars."));
    add(::MSU.Class.EnumSetting("retainLevels", "half", ["none" "half" "all"],
        "Retain Levels Upon Rebirth",
        "Retain some levels upon death and resurrection."));
    // add(::MSU.Class.SettingsSpacer("numberSpacer", "35rem", "8rem"));
    add(::MSU.Class.SettingsDivider("numberDiv"));

    // TODO: update bros immediately after settings change
    add(::MSU.Class.SettingsTitle("power", "Immortal Power"));
    add(::MSU.Class.RangeSetting("levels", 0, 0, 10, 1, "Extra Levels",
        "Give this number of levels."));
    add(::MSU.Class.RangeSetting("traits", 0, 0, 5, 1, "Extra Traits",
        "Give this number of good traits."));
    add(::MSU.Class.RangeSetting("talents", 0, 0, 5, 1, "Boost Talents",
        "Give or improve talents this number of times."));
    add(::MSU.Class.SettingsSpacer("talentsSpacer", "35rem", "8rem"));
    add(::MSU.Class.RangeSetting("ap", 0, 0, 6, 3, "Extra AP",
        "Give this number of extra action points. Added gradually on levels 3, 6 and 9."));
    add(::MSU.Class.RangeSetting("fatigueRecovery", 0, 0, 6, 1, "Extra Fatigue Recovery"));

    add(::MSU.Class.RangeSetting("skill", 0, 0, 20, 5, "Bonus Skill",
        "Give this amount of melee and ranged skill."));
    add(::MSU.Class.RangeSetting("defense", 0, 0, 20, 5, "Bonus Defense",
        "Give this amount of melee and ranged defense."));

    // add(::MSU.Class.SettingsTitle("resurrection", "Resurrection"));

    // Give jars on start
    ::mods_hookBaseClass("scenarios/world/starting_scenario", function (cls) {
        local onSpawnAssets = "onSpawnAssets" in cls
            ? cls.onSpawnAssets : cls.starting_scenario.onSpawnAssets;
        cls.onSpawnAssets <- function () {
            onSpawnAssets();

            local stash = this.World.Assets.getStash();
            for (local i = 0; i < mod.conf("number"); i++) {
                local jar = ::new("scripts/items/special/immortal_soul_jar");
                jar.m.immortal_Index = i;
                stash.add(jar);
            }
        }
    })

    ::mods_hookExactClass("states/world_state", function (cls) {
        local startNewCampaign = cls.startNewCampaign;
        cls.startNewCampaign = function() {
            startNewCampaign();
            mod._ImmortalInfo <- {};
        }

        local onSerialize = cls.onSerialize;
        cls.onSerialize = function(_out) {
            local packed = Util.pack(mod._ImmortalInfo);
            this.m.Flags.set("ImmortalWarriors", packed);
            return onSerialize(_out);
        }

        local onDeserialize = cls.onDeserialize;
        cls.onDeserialize = function (_in) {
            onDeserialize(_in);

            local packed = this.m.Flags.get("ImmortalWarriors");
            mod._ImmortalInfo <- packed ? Util.unpack(packed) : {};
            // We copy all non-filled fields here in case new ones appear
            foreach (_, info in mod._ImmortalInfo) {
                Table.setDefaults(info, mod.DefaultInfo);
            }
        }
    });

    ::mods_hookExactClass("entity/tactical/player", function (cls) {
        // TODO: serialize or flags
        cls.m.immortal_extraALUV <- 0;

        local fillAttributeLevelUpValues = cls.fillAttributeLevelUpValues;
        cls.fillAttributeLevelUpValues = function ( _amount, _maxOnly = false, _minOnly = false ) {
            fillAttributeLevelUpValues(_amount, _maxOnly, _minOnly);
            if (_maxOnly || _minOnly) this.m.immortal_extraALUV += _amount;
        }

        local setAttributeLevelUpValues = cls.setAttributeLevelUpValues;
        cls.setAttributeLevelUpValues = function (_v) {
            setAttributeLevelUpValues(_v);
            if (this.m.immortal_extraALUV > 0) this.m.immortal_extraALUV--;
        }
    });

    ::include("scripts/i_immortal_warriors_levelup_changes");
    ::LevelUpChanges.onLevel(function (_player, _level) {
        if (!_player.getSkills().hasSkill("trait.immortal_warrior")) return;
        if (::Math.rand(1, 100) > 33) return;

        local injury = ::std.Player.removePermanentInjury(_player);
        if (!injury) return;

        _player.addLevelUpChanges("Immortal overcomes", [{
            id = injury.getID()
            icon = injury.getIcon()
            removed = true
            tooltip = injury.getTooltip()
        }])
    })

});


// The meat
mod.DefaultInfo <- {
    Name = null
    Title = null
    Level = 0
    Battles = 0
    Kills = 0
    Deaths = 0
}
mod.getImmortalInfo <- function (_i) {
    // if ("_ImmortalInfo" in mod) return null;
    local n = mod.conf("number");
    if (_i >= n) throw "No info for immortal numero " + _i + ", only have " + n + " of them";

    if (!(_i in this._ImmortalInfo)) this._ImmortalInfo[_i] <- clone this.DefaultInfo;
    return this._ImmortalInfo[_i];
}

mod.boostTalents <- function (_player, _num) {
    if (_num <= 0) return;

    Debug.log("talents before", _player.m.Talents);
    local talents = _player.m.Talents;
    local options = [0 1 2 3 4 5 6 7].filter(@(_, t) talents[t] < 3);

    for (local i = 0; i < _num; i++) {
        local o = Rand.index(options.len());
        local t = options[o];
        talents[t] = ::Math.max(talents[t] + 1, Rand.choice([1 2 3], [50 25 25]));
        if (talents[t] == 3) {
            options.remove(o);
            if (options.len() == 0) break;
        }
    }
    Debug.log("talents after", _player.m.Talents);

    // Since this.m.Attributes are already filled in according to old talents we need to reroll.
    // NOTE: there might be Gifted or Blue Vial rows, which we need to preserve.
    Debug.log("boostTalents before", _player.m.Attributes);
    local extras = _player.m.Attributes.map(@(v) v.slice(0, _player.m.immortal_extraALUV));
    Debug.log("extras before", extras);
    _player.m.Attributes.clear();
    _player.fillAttributeLevelUpValues(
        ::Const.XP.MaxLevelWithPerkpoints - _player.getLevel()
        + _player.m.LevelUps - _player.m.immortal_extraALUV
    );
    Debug.log("boostTalents rolled", _player.m.Attributes);
    for (local i = 0; i < ::Const.Attributes.COUNT; i++) {
        extras[i].extend(_player.m.Attributes[i]);
        _player.m.Attributes[i] = extras[i];
    }
    Debug.log("boostTalents after", _player.m.Attributes);
}

// TODO: get rid of this
::mods_queue(mod.ID, "mod_hooks(>=20), stdlib(>=2.0), mod_msu(>=1.5.0)", function () {
    ::include("scripts/i_immortal_warriors_hack_msu");
    ::HackMSU.setup(mod, {
        nexus = "https://www.nexusmods.com/battlebrothers/mods/763"
        github = "https://github.com/Suor/battle-brothers-mods/tree/master/immortal_warriors"
        tagPrefix = "immortal-"
    })
})
