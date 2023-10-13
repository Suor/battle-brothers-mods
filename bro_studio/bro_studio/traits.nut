local mod = ::BroStudio, Rand = ::std.Rand.using(::rng), Util = ::std.Util;

// Settings, Traits page
local page = mod.addPage("Traits");

page.add(::MSU.Class.RangeSetting("traitsNum", 0, 0, 5, 1, "Number",
    "Will add this number of random traits after a bro is hired"));
page.add(::MSU.Class.SettingsSpacer("traitsSpacer", "35rem", "8rem"));

page.add(::MSU.Class.BooleanSetting("traitsGood", true, "Add good traits",
    "Allow adding good traits"));
page.add(::MSU.Class.BooleanSetting("traitsBad", true, "Add bad traits",
    "Allow adding bad traits"));
page.add(::MSU.Class.BooleanSetting("traitsSoso", true, "Add so-so traits",
    "Allow adding traits having both significant upsides and downsides"));
page.add(::MSU.Class.BooleanSetting("traitsStupid", false, "Stupid Mode",
    "Compensate each bad or so-so trait added with a good one"));


// Expose data and some behaviors for other mods to modify or use, also helps with testing :)
mod.BadTraitIds <- [
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
mod.SosoTraitIds <- [
    "trait.drunkard"
    "trait.fat"
    "trait.impatient"
    "trait.huge"
    "trait.tiny"
    "trait.paranoid"
    // Legends
    "trait.aggressive"
    "trait.legend_diurnal"
    "trait.light"
];

mod.traitType <- function (traitId) {
    if (mod.SosoTraitIds.find(traitId) != null) return "SOSO";
    if (mod.BadTraitIds.find(traitId) != null) return "BAD";
    return "GOOD";
}

// Expose this function so that it could be called externally or patched
mod.addTraits <- function (_player, _opts = null) {
    _opts = Util.extend({
        num = mod.conf("traitsNum")
        good = mod.conf("traitsGood")
        bad = mod.conf("traitsBad")
        soso = mod.conf("traitsSoso")
        stupid = mod.conf("traitsStupid")
    }, _opts || {})

    if (_opts.num == 0) return;

    local pool = ::Const.CharacterTraits.filter(function (_, t) {
        if (!_opts.bad && mod.BadTraitIds.find(t[0]) != null) return false;
        if (!_opts.soso && mod.SosoTraitIds.find(t[0]) != null) return false;
        return !_player.getSkills().hasSkill(t[0]);
    });

    local added = 0, good = 0, notGood = 0;
    foreach (trait in Rand.itake(pool)) {
        if (mod.Debug) {
            local type = mod.traitType(trait[0]);
            ::logInfo("studio: bro " + _player.getName() + " got " + trait[0] + " " + type);
        }
        _player.getSkills().add(::new(trait[1]));
        added++;
        // In stupid mode each bad or so-so trait must be compensated with a good one
        if (_opts.stupid) (mod.traitType(trait[0]) == "GOOD") ? good++ : notGood++;
        if (added >= _opts.num && (!_opts.stupid || good >= notGood && good >= _opts.num)) break;
    }
}
