::mods_registerMod("mod_vap", 1.4, "Veteran attrs and perks buff");
::mods_queue("mod_vap", "mod_hooks(>=17)", function() {
  this.logInfo("vap: loading");

  local patchPlayer = function(obj) {
    this.logInfo("vap: patching a player object " + obj.getName());

    // Prevent from patching twice.
    // Not sure how this happens, but it does sometimes for new hires, who get levels later.
    if("addExtraPerks" in obj) return;

    // Give rolls of 2 on veteran levels to attrs with talents sometimes
    local getAttributeLevelUpValues = obj.getAttributeLevelUpValues;
    obj.getAttributeLevelUpValues = function()
    {
      if(m.Attributes[0].len() != 0) return getAttributeLevelUpValues(); // no bonus if not in veteran levels

      local v = getAttributeLevelUpValues();
      local extra = function(t, bonus = 0)
      {
        if(t == 0) return 0;
        local max = (t == 1 ? 5 : t == 2 ? 3 : 2) - bonus;
        return max <= 1 || Math.rand(1, max) == 1 ? 1 : 0;
      }

      v.hitpointsIncrease += extra(m.Talents[Const.Attributes.Hitpoints]);
      v.braveryIncrease += extra(m.Talents[Const.Attributes.Bravery]);
      v.fatigueIncrease += extra(m.Talents[Const.Attributes.Fatigue]);
      v.initiativeIncrease += extra(m.Talents[Const.Attributes.Initiative], 1);
      v.meleeSkillIncrease += extra(m.Talents[Const.Attributes.MeleeSkill]);
      v.rangeSkillIncrease += extra(m.Talents[Const.Attributes.RangedSkill]);
      v.meleeDefenseIncrease += extra(m.Talents[Const.Attributes.MeleeDefense]);
      v.rangeDefenseIncrease += extra(m.Talents[Const.Attributes.RangedDefense]);
      return v;
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
      this.logInfo("vap: hired " + this.getName());
      onHired();
      this.addExtraPerks(1);
    }

    obj.addExtraPerks <- function(level) {
      if (level >= m.Level) return;

      this.logInfo("vap: Leveling up " + this.getName() + " from " + level + " to " + m.Level);
      // give a perk point every for certain levels
      for (; ++level <= m.Level;)
        if (level >= 14 && level % 3 == 2) m.PerkPoints++;
    }
  }

  ::mods_hookNewObject("entity/tactical/player", patchPlayer);

  // Need to hook this too since perks are added there too,
  // breaking updateLevel() abstraction
  ::mods_hookBaseClass("scenarios/world/starting_scenario", function(cls) {
    this.logInfo("vap: hook starting_scenario");

    local onSpawnAssets = "onSpawnAssets" in cls ? cls.onSpawnAssets : null;
    cls.onSpawnAssets <- function()
    {
      if (onSpawnAssets) onSpawnAssets();
      local roster = World.getPlayerRoster().getAll();
      foreach (bro in roster) bro.addExtraPerks(1);
    }
  });
});
