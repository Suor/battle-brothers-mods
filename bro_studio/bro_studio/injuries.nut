local mod = ::BroStudio;
local Rand = ::std.Rand.using(::std.rng);

// Settings, Injuries page
local page = mod.addPage("Injuries");

page.add(::BroStudio.SliderSetting("permChance",
    0, [0, 1, 2, 3, 4, 5, 6, 10, 20, 100],
       ["off", "1%", "2%", "3%", "4%", "5%", "6%", "10%", "20%", "100%"],
    "Permanent injury chance",
    "Newly recruited bros may come with a permanent injury and will be cheaper to hire"));

mod.addInjury <- function (_player) {
    local chance = mod.conf("permChance");
    if (Rand.int(1, 100) > chance) return false;

    local inj = Rand.choice(::Const.Injury.Permanent);
    _player.getSkills().add(::new("scripts/skills/" + inj.Script));
    return true;
}
