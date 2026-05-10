local mod = ::HackflowsTranslations <- {
    ID = "mod_hackflows_translations"
    Name = "Hackflow's Translations"
    Version = "0.1.0"
}
local mh = mod.mh <- ::Hooks.register(mod.ID, mod.Version, mod.Name);
mh.require("mod_rosetta >= 0.2.0");
mh.queue(function() {
    ::include("hackflows_translations/champion_beasts");
    ::include("hackflows_translations/settlement_prices_tooltip");
    ::include("hackflows_translations/background_bonuses");
    ::include("hackflows_translations/swifter");
    ::include("hackflows_translations/backgrounds_reforged");
    ::include("hackflows_translations/prepare_for_battle");
    ::include("hackflows_translations/shield_damage");
});
