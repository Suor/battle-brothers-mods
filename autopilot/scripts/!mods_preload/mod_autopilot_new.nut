local mod = ::Autopilot <- {
    ID = "mod_autopilot_new"
    Name = "Autopilot New"
    Version = "2.4.0"
    Updates = {
        nexus = "https://www.nexusmods.com/battlebrothers/mods/675"
        github = "https://github.com/Suor/battle-brothers-mods/tree/master/autopilot"
        tagPrefix = "autopilot-new-"
    }
    function isUnderAIControl(_actor) {return "_autopilot" in _actor.m}
}

::mods_registerMod(mod.ID, mod.Version, mod.Name);
::mods_queue(mod.ID, "mod_hooks(>=20), mod_msu(>=1.5.0), >mod_reforged, !mod_autopilot",
    function () {

  mod.Mod <- ::MSU.Class.Mod(mod.ID, mod.Version, mod.Name);
  mod.conf <- function (name) {
      return mod.Mod.ModSettings.getSetting(name).getValue();
  }

  // mod.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.NexusMods,
  //     "https://www.nexusmods.com/battlebrothers/mods/675");
  // mod.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.GitHubTags,
  //     "https://github.com/Suor/battle-brothers-mods/tree/master/autopilot",
  //     {Prefix = "autopilot-new-"}
  // );
  // mod.Mod.Registry.setUpdateSource(::MSU.System.Registry.ModSourceDomain.GitHubTags);

  ::include("autopilot/hack_msu");
  ::HackMSU.setup(mod, mod.Updates);

  // Settings
  local page = mod.Mod.ModSettings.addPage("Autopilot");

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

  ::MSU.Skills.addEvent("onSetupAI", function (_agent) {}, false, true);

  ::include("autopilot/hooks/actor");
  ::include("autopilot/hooks/player");
  ::include("autopilot/hooks/tactical_state");
  ::include("autopilot/hooks/tooltip_events");
  ::include("autopilot/hooks/turn_sequence_bar");
  ::include("autopilot/better_behavior");
  ::include("autopilot/better_raise_undead");
  ::include("autopilot/fixes");
  ::include("autopilot/verbose");
  ::mods_registerJS("autopilot_new.js");
  ::mods_registerCSS("autopilot_new.css");

  ::include("autopilot/debug");
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
