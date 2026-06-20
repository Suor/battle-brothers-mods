local def = ::Challenges <- {
    ID = "mod_challenges"
    Name = "Challenges"
    Version = "0.2.0"
    Updates = {
        nexus = "https://www.nexusmods.com/battlebrothers/mods/1010"
        github = "https://github.com/Suor/battle-brothers-mods/tree/master/challenges"
        tagPrefix = "challenges-"
    }
}

local mod = def.mh <- ::Hooks.register(def.ID, def.Version, def.Name);
mod.require("stdlib", "mod_msu >= 1.6.0");
// ">mod_necro": wrap outside necro's isDroppedAsLoot, which briefly stamps Player then restores it.
mod.queue(">mod_msu", ">mod_EIMO", ">mod_consume", ">mod_smartLoot", ">mod_necro", function () {
    ::Hooks.registerJS("ui/mods/challenges/loot_panel.js");
    ::Hooks.registerJS("ui/mods/challenges/hire_dialog.js");
    ::Hooks.registerCSS("ui/mods/challenges/loot_panel.css");

    def.Mod <- ::MSU.Class.Mod(def.ID, def.Version, def.Name);

    local msd = ::MSU.System.Registry.ModSourceDomain, upd = def.Updates;
    if ("GitHubTags" in msd) {
        def.Mod.Registry.addModSource(msd.GitHubTags, upd.github, {Prefix = upd.tagPrefix});
        def.Mod.Registry.setUpdateSource(msd.GitHubTags);
    }

    def.conf <- function (_name) {
        return def.Mod.ModSettings.getSetting(_name).getValue();
    }

    def.addPage <- function (_id, _name = null) {
        local page = def.Mod.ModSettings.addPage(_id, _name);
        return function (_elem) {
            page.addElement(_elem);
            _elem.Data.NewCampaign <- true;
            return _elem;
        }
    }
    def.add <- def.addPage("General");
    def.addGear <- def.addPage("Hiring & Gear");

    ::include("challenges/slider_setting");
    ::include("challenges/loot");
    ::include("challenges/hiring");
    ::include("challenges/gear");
    ::include("challenges/costs");
    ::include("challenges/enemies");
    ::include("challenges/followers");
});
