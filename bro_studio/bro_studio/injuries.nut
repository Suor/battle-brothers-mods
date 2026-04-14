local mod = ::BroStudio;
local Rand = ::std.Rand.using(::std.rng);

// Settings, Injuries page
local page = mod.addPage("Injuries");

page.add(::BroStudio.SliderSetting("injuriesNth",
    "off", ["off", 100, 50, 33, 25, 20, 15, 10, 5, 1], null,
    "Permanent injury each N-th bro",
    "Newly recruited bros may come with a permanent injury and will be cheaper to hire"));

mod.addInjury <- function (_player) {
    local nth = mod.conf("injuriesNth");
    if (nth == "off") return false;
    if (Rand.int(1, nth) != 1) return false;

    local injuries = ::Const.Injury.Permanent;
    local inj = Rand.choice(injuries);
    _player.getSkills().add(::new("scripts/skills/" + inj.Script));
    return true;
}
