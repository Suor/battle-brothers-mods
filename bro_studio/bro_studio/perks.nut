local mod = ::BroStudio;

// Settings, Perks page
local page = mod.addPage("Perks");

page.add(::MSU.Class.RangeSetting("perksEach", 1, 0, 5, 1, "Perks given each level",
    "On levels from to 2 to Veteran Level, i.e. 10 times by default."));
page.add(::BroStudio.SliderSetting("perksNth", "off", ["off" 5 4 3 2], "Add a perk each N-th level",
    "Starting from but not including level 1 and not after the Veteran Level"));

// Veterans
page.add(::MSU.Class.SettingsDivider("perksDiv"));
page.add(::MSU.Class.SettingsTitle("perksVeteranTitle", "Veterans"));

page.add(::MSU.Class.RangeSetting("perksVeteran", 11, 1, 21, 1, "Veteran Level for Perks"));
page.add(::MSU.Class.SettingsSpacer("perksVeteranSpacer", "35rem", "8rem"));

page.add(::BroStudio.SliderSetting("perksVeteranNth", "off", ["off", 10, 5, 4, 3, 2, 1],
    "Add a perk each N-th veteran level",
    "Starting from but not including the Veteran Level"));
page.add(::MSU.Class.StringSetting("perksPreset", "",
    "Give a perk on these levels", "Level numbers separated by space or comma"));

// Conf "interpreter"
local function safeToInteger(n) {
    try {
        return n.tointeger();
    } catch (err) {
        this.logWarning("studio: ERROR failed to convert to number: " + n);
        return 0;
    }
}
mod.extraPerks <- function(level) {
    local perks = 0;
    local veteranLevel = mod.conf("perksVeteran");

    if (level == 1) {
        // pass
    } else if (level <= veteranLevel) {
        perks += mod.conf("perksEach");
        local nth = mod.conf("perksNth");
        if (nth != "off" && (level - 1) % nth == 0) perks++;
    } else {
        local nth = mod.conf("perksVeteranNth");
        if (nth != "off" && (level - veteranLevel) % nth == 0) perks++;
    }

    // These are added by the game itself
    if (level > 1 && level <= ::Const.XP.MaxLevelWithPerkpoints) perks--;

    local preset = mod.conf("perksPreset");
    if (preset) {
        local levels = split(preset, ", ").filter(@(_, v) v != "").map(safeToInteger);
        if (levels.find(level) != null) perks++;
    }

    return perks;
}
