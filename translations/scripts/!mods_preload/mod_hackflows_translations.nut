local mod = ::HackflowsTranslations <- {
    ID = "mod_hackflows_translations"
    Name = "Hackflow's Translations"
    Version = "0.1.0"
}
local mh = mod.mh <- ::Hooks.register(mod.ID, mod.Version, mod.Name);
mh.require("mod_rosetta >= 0.2.0");
mh.queue(function() {
    ::include("hackflows_translations/AC");
    ::include("hackflows_translations/champion_beasts");
});
