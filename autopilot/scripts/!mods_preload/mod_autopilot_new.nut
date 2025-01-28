local def = ::Autopilot <- {
    ID = "mod_autopilot_new"
    Name = "Autopilot New"
    Version = "2.5.3"
    Updates = {
        nexus = "https://www.nexusmods.com/battlebrothers/mods/675"
        github = "https://github.com/Suor/battle-brothers-mods/tree/master/autopilot"
        tagPrefix = "autopilot-new-"
    }
    function isUnderAIControl(_actor) {return "_autopilot" in _actor.m}
}

local mod = def.mh <- ::Hooks.register(def.ID, def.Version, def.Name);
mod.require("mod_msu >= 1.6.0", "stdlib >= 2.2");
mod.conflictWith("mod_autopilot");
// msu patches skill.use() in a way that reintroduces broken weapon bug, wrapping that
// mod_reforged has a couple of tweaks taken from here, which we need to undo
// mod_sellswords overwrites ai_break_free.onEvaluate()
// mod_fantasybro adds riffle shot to a wrong behavior, we want to move that
mod.queue(">mod_msu", ">mod_reforged", ">mod_sellswords", ">mod_fantasybro", function () {
    def.msu <- ::MSU.Class.Mod(def.ID, def.Version, def.Name);
    def.conf <- function (name) {
            return def.msu.ModSettings.getSetting(name).getValue();
    }

    local msd = ::MSU.System.Registry.ModSourceDomain, upd = def.Updates;
    def.msu.Registry.addModSource(msd.NexusMods, upd.nexus);
    def.msu.Registry.addModSource(msd.GitHubTags, upd.github, {Prefix = upd.tagPrefix});
    def.msu.Registry.setUpdateSource(msd.GitHubTags);

    // Settings
    local page = def.msu.ModSettings.addPage("Autopilot");

    page.addElement(::MSU.Class.BooleanSetting("player", true, "Auto Player Characters",
            "Uncheck this for autopilot mode to skip Player Characters"));

    page.addElement(::MSU.Class.SettingsDivider("behaviorsDiv"));
    page.addElement(::MSU.Class.SettingsTitle("behaviorsTitle", "Behaviors"));

    page.addElement(::MSU.Class.BooleanSetting("dogs", true, "Let The Dogs Out",
            "Use dogs in autopilot mode"));
    page.addElement(::MSU.Class.BooleanSetting("nets", true, "Throw Nets",
            "Use Throwing Nets when in autopilot mode"));
    // page.addElement(::MSU.Class.SettingsDivider("autoDiv"));

    page.addElement(::MSU.Class.BooleanSetting("freewake", true, "Auto break free and wake up",
            "Auto break free out of nets and webs and wake allies when unused AP left"));
    page.addElement(::MSU.Class.BooleanSetting("reload", true, "Auto reload",
            "Auto reload when unused AP left"));
    page.addElement(::MSU.Class.BooleanSetting("verbose", false, "Verbose AI",
            "Show AI debugging for auto bros"));

    foreach (file in ::IO.enumerateFiles("autopilot/hooks")) ::include(file);
    ::include("autopilot/better_attack_default");
    ::include("autopilot/better_behavior");
    ::include("autopilot/better_raise_undead");
    ::include("autopilot/fixes");
    ::include("autopilot/verbose");
    ::Hooks.registerJS("ui/mods/autopilot_new.js");
    ::Hooks.registerCSS("ui/mods/autopilot_new.css");

    // ::include("autopilot/debug");

    // Allow player AI to break free from webs & nets
    mod.hook("scripts/ai/tactical/behaviors/ai_break_free", function (q) {
        q.onEvaluate = @(__original) function (_entity) {
            if (!def.isUnderAIControl(_entity)) return __original(_entity);

            local prevControlled = _entity.m.IsControlledByPlayer;
            _entity.m.IsControlledByPlayer = false;
            local ret = __original(_entity);
            _entity.m.IsControlledByPlayer = prevControlled;
            return ret;
        }
    })
})
