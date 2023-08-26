::VAP <- {
    ID = "mod_vap"
    Name = "Veteran Attrs and Perks"
    Version = "2.1.0"
};

::mods_registerMod(::VAP.ID, ::VAP.Version, ::VAP.Name);
::mods_queue(::VAP.ID, "mod_hooks(>=17), mod_msu(>=1.2.6)", function() {
    ::VAP.Mod <- ::MSU.Class.Mod(::VAP.ID, ::VAP.Version, ::VAP.Name);

    // pages
    local page = ::VAP.Mod.ModSettings.addPage("General");

    // helpers
    local function add(elem) {
        page.addElement(elem);
        elem.Data.NewCampaign <- true;
        return elem;
    }
    local function safeToInteger(n) {
        try {
            return n.tointeger();
        } catch (err) {
            this.logWarning("vap: ERROR failed to convert to number: " + n);
            return 0;
        }
    }

    local talentDiv = add(::MSU.Class.RangeSetting("TalentDiv", 3, 2, 5, 1, "Talent Divisor"));
    talentDiv.setDescription("Non-veterans get 0.5 per level per star on average. "
                           + "Veterans will get this times less.");
    ::VAP.getTalentValue <- function () {
        return 0.5 / talentDiv.getValue();
    }

    add(::MSU.Class.SettingsDivider("Div1"));

    // perks
    local perksMode = add(::MSU.Class.EnumSetting(
        "PerksMode", "preset", ["none" "preset" "every nth"], "Perks Mode"));
    add(::MSU.Class.SettingsSpacer("PerksSpacer", "35rem", "8rem"));
    local perksPreset = add(::MSU.Class.StringSetting("PerksPreset", "13, 16, 20, 25, 31",
        "Give a perk on these levels", "Level numbers separated by space or comma"));
    local perksNth = add(::MSU.Class.RangeSetting("PerksNth", 2, 1, 10, 1, "Every Nth Level",
        "Starting from but not including 11"));

    if (::mods_getRegisteredMod("mod_ultrabros")) {
        foreach(setting in [perksMode, perksPreset, perksNth])
            setting.lock("This is overtaken by Ultra Bros");
    }

    ::VAP.getGivePerk <- function () {
        local mode = perksMode.getValue();
        if (mode == "none") {
            this.logInfo("vap: perks " + mode);
            return @(l) false;
        }
        if (mode == "preset") {
            local preset = perksPreset.getValue();
            this.logInfo("vap: perks " + mode + " " + preset);
            local levels_ = split(preset, ", ");
            local levels = levels_.map(safeToInteger);
            return @(l) levels.find(l) != null;
        }
        if (mode == "every nth") {
            local n = safeToInteger(perksNth.getValue());
            this.logInfo("vap: perks " + mode + " " + n);
            local afterLevel = 11;
            return @(l) l > afterLevel && (l - afterLevel) % n == 0;
        }
        this.logWarning("vap: ERROR unknown perk mode: " + mode);
        return @(l) false;
    }

  // Older code or The Meat of it
  local patchPlayer = function(obj) {
    // Prevent from patching twice.
    // Not sure how this happens, but it does sometimes for new hires, who get levels later.
    if("addExtraPerks" in obj) return;

    // this.logInfo("vap: patching a player object " + obj.getName());

    // Give rolls of 2 on veteran levels to attrs with talents sometimes
    local getAttributeLevelUpValues = obj.getAttributeLevelUpValues;
    obj.getAttributeLevelUpValues = function() {
      // only do this once, also filled in already for non-veteran levels
      if(m.Attributes[0].len() == 0) {
          // this.logInfo("vap: extra attrs values " + obj.getName());

          local talentValue = ::VAP.getTalentValue();
          local extra = function(t, bonus = 0) {
            local chance = talentValue * 2 * t * (1 + bonus) * 100;
            return Math.rand(0, chance + 99) / 100;
          }
          for (local i = 0; i < Const.Attributes.COUNT; i++) {
            local bonus = i == Const.Attributes.Initiative ? 0.5 : 0;
            this.m.Attributes[i].insert(0, 1 + extra(m.Talents[i], bonus));
          }
      }
      return getAttributeLevelUpValues()
    }

    // Add an extra perk point for each odd level
    local updateLevel = obj.updateLevel;
    obj.updateLevel = function() {
      // this.logInfo("vap: update level for " + this.getName());
      local level = m.Level;
      updateLevel();
      this.addExtraPerks(level);
    }

    // Perks are added manually there, breaking the abstraction
    local onHired = obj.onHired;
    obj.onHired = function() {
      // this.logInfo("vap: hired " + this.getName());
      onHired();
      this.addExtraPerks(1);
    }

    obj.addExtraPerks <- function(level) {
      if (level >= m.Level) return;

      // this.logInfo("vap: Leveling up " + this.getName() + " from " + level + " to " + m.Level);
      // give a perk point for certain levels
      local givePerk = ::VAP.getGivePerk();
      for (; ++level <= m.Level;) {
        // this.logInfo("vap: givePerk(" + level + ") = " + givePerk(level));
        if (givePerk(level)) m.PerkPoints++;
      }
    }
  }

  ::mods_hookNewObject("entity/tactical/player", patchPlayer);

  // Need to hook this too since perks are added there too,
  // breaking updateLevel() abstraction
  ::mods_hookBaseClass("scenarios/world/starting_scenario", function(cls) {
    // this.logInfo("vap: hook starting_scenario");

    local onSpawnAssets = "onSpawnAssets" in cls ? cls.onSpawnAssets : null;
    cls.onSpawnAssets <- function()
    {
      if (onSpawnAssets) onSpawnAssets();
      local roster = World.getPlayerRoster().getAll();
      foreach (bro in roster) bro.addExtraPerks(1);
    }
  });
});
