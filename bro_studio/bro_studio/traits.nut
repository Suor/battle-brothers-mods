local mod = ::BroStudio, Util = ::std.Util, Player = ::std.Player;

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

page.add(::MSU.Class.SettingsDivider("traitsDiv"));
// page.add(::MSU.Class.SettingsTitle("traitsTitle", "Repeat"));

page.add(::BroStudio.SliderSetting("traitsNth", "off", ["off", 10, 5, 4, 3],
    "Repeat each N-th level",
    "Starting from but not including the level 1"));
page.add(::MSU.Class.RangeSetting("traitsNthNum", 1, 0, 5, 1, "Number",
    "Will add this number of random traits each Nth level"));

// Expose this function so that it could be called externally or patched
mod.addTraits <- function (_player, _num, _opts = null) {
    _opts = Util.extend({
        good = mod.conf("traitsGood")
        bad = mod.conf("traitsBad")
        soso = mod.conf("traitsSoso")
        stupid = mod.conf("traitsStupid")
    }, _opts || {})

    Player.addTraits(_player, _num, _opts);
}

mod.extraTraits <- function (_level) {
    local nth = mod.conf("traitsNth");
    if (nth != "off" && (_level - 1) % nth == 0) return mod.conf("traitsNthNum");
    return 0;
}
