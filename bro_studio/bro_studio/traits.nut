local mod = ::BroStudio, Rand = ::std.Rand.using(::rng);

// Expose data and some behaviors for other mods to modify or use,
// also helps with testing :)
mod.Data.BadTraitIds <- [
    "trait.ailing"
    "trait.asthmatic"
    "trait.bleeder"
    "trait.brute"
    "trait.clubfooted"
    "trait.clumsy"
    "trait.cocky"
    "trait.craven"
    "trait.dastard"
    "trait.disloyal"
    "trait.dumb"
    "trait.fainthearted"
    "trait.fear_beasts"
    "trait.fear_greenskins"
    "trait.fear_undead"
    "trait.fragile"
    "trait.gluttonous"
    "trait.greedy"
    "trait.hesitant"
    "trait.insecure"
    "trait.irrational"
    "trait.night_blind"
    "trait.pessimist"
    "trait.short_sighted"
    "trait.superstitious"
    // Legends
    "trait.fear_nobles"
    "trait.frail"
    "trait.legend_appetite_donkey"
    "trait.legend_fear_dark"
    "trait.predictable"
    "trait.slack"
];
mod.Data.SosoTraitIds <- [
    "trait.drunkard"
    "trait.fat"
    "trait.impatient"
    // Legends
    "trait.aggressive"
    "trait.legend_diurnal"
    "trait.light"
    // additional to master
    "trait.huge"
    "trait.tiny"
    "trait.paranoid"
];

mod.traitType <- function (traitId) {
    if (mod.Data.SosoTraitIds.find(traitId) != null) return "SOSO";
    if (mod.Data.BadTraitIds.find(traitId) != null) return "BAD";
    return "GOOD";
}

// Expose this function so that it could be called externally or patched
mod.addTraits <- function (_player, _opt = null) {
    _opt = _opt || {
        num = mod.conf("traitsNum")
        good = mod.conf("traitsGood")
        bad = mod.conf("traitsBad")
        soso = mod.conf("traitsSoso")
        stupid = mod.conf("traitsStupid")
    }

    local pool = ::Const.CharacterTraits.filter(function (_, t) {
        if (!_opt.bad && mod.Data.BadTraitIds.find(t[0]) != null) return false;
        if (!_opt.soso && mod.Data.SosoTraitIds.find(t[0]) != null) return false;
        return !_player.getSkills().hasSkill(t[0]);
    });

    local added = 0, good = 0, notGood = 0;
    foreach (trait in Rand.itake(pool)) {
        if (mod.Debug) {
            local type = mod.traitType(trait[0]);
            ::logInfo("brogen: bro " + _player.getName() + " got " + trait[0]
                + " " + (type != "GOOD" ? type : ""));
        }
        _player.getSkills().add(::new(trait[1]));

        added++;
        // In stupid mode each so-so trait must be compensated with a good one
        if (_opt.stupid) {
            mod.traitType(trait[0]) == "GOOD" ? good++ : notGood++;
        }
        if (added >= _opt.num && (!_opt.stupid || good >= notGood && good >= _opt.num)) break;
    }
}


// Settings, Traits page
local page = mod.Mod.ModSettings.addPage("Traits");
local function add(elem) {
    page.addElement(elem);
    elem.Data.NewCampaign <- true;
    return elem;
}

add(::MSU.Class.RangeSetting("traitsNum", 0, 0, 5, 1, "Number",
    "Will add this number of random traits after a bro is hired"));
add(::MSU.Class.SettingsSpacer("traitsSpacer", "35rem", "8rem"));

add(::MSU.Class.BooleanSetting("traitsGood", true, "Add good traits",
    "Allow adding good traits"));
add(::MSU.Class.BooleanSetting("traitsBad", true, "Add bad traits",
    "Allow adding bad traits"));
add(::MSU.Class.BooleanSetting("traitsSoso", true, "Add so-so traits",
    "Allow adding traits having both significant upsides and downsides"));
add(::MSU.Class.BooleanSetting("traitsStupid", false, "Stupid Mode"));
    // "Compensate each so-so or bad trait added with a good one"));
