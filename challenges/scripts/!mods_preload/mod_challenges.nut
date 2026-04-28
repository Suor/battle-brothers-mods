local def = ::Challenges <- {
    ID = "mod_challenges"
    Name = "Challenges"
    Version = "0.1.0"
    Updates = {
        github = "https://github.com/Suor/battle-brothers-mods/tree/master/challenges"
        tagPrefix = "challenges-"
    }
}

local mod = def.mh <- ::Hooks.register(def.ID, def.Version, def.Name);
mod.require("stdlib", "mod_msu >= 1.6.0");

mod.queue(">mod_msu", function () {
    def.Mod <- ::MSU.Class.Mod(def.ID, def.Version, def.Name);

    local msd = ::MSU.System.Registry.ModSourceDomain, upd = def.Updates;
    if ("GitHubTags" in msd) {
        def.Mod.Registry.addModSource(msd.GitHubTags, upd.github, {Prefix = upd.tagPrefix});
        def.Mod.Registry.setUpdateSource(msd.GitHubTags);
    }

    def.conf <- function (_name) {
        return def.Mod.ModSettings.getSetting(_name).getValue();
    }

    local page = def.Mod.ModSettings.addPage("General");
    def.add <- function (_elem) {
        page.addElement(_elem);
        _elem.Data.NewCampaign <- true;
        return _elem;
    }

    ::include("challenges/slider_setting");
    ::include("challenges/loot");
    ::include("challenges/hiring");
    ::include("challenges/costs");
});
