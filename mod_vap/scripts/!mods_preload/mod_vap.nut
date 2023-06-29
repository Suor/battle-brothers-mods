// Uncomment a section below with a desired behavior and comment out the other one.
// Adjust variables to your liking.

// Each star gives this amount on average on top of 1 you get as veteran.
// I.e. with 1 star you will get 2 every 4th level, with 2 stars every other, etc.
// If the value * stars > 1 you might get more than 2 sometimes.
// This value is doubled for initiative.
local talentValue = 0.25;

// Give an extra perk on listed levels
local perkLevels = [13, 16, 20, 25, 31];
local givePerk = @(l) perkLevels.find(l) != null;

//// Give an extra perk every N levels after a certain one
// local N = 3, afterLevel = 11;
// local givePerk = @(l) l > afterLevel && (l - afterLevel) % N == 0;


::mods_registerMod("mod_vap", 1.7, "Veteran attrs and perks");
::mods_queue("mod_vap", "mod_hooks(>=17)", function() {
  this.logInfo("vap: loading");

  local patchPlayer = function(obj) {
    // Prevent from patching twice.
    // Not sure how this happens, but it does sometimes for new hires, who get levels later.
    if("addExtraPerks" in obj) return;

    this.logInfo("vap: patching a player object " + obj.getName());

    // Give rolls of 2 on veteran levels to attrs with talents sometimes
    local getAttributeLevelUpValues = obj.getAttributeLevelUpValues;
    obj.getAttributeLevelUpValues = function() {
      // only do this once, also filled in already for non-veteran levels
      if(m.Attributes[0].len() == 0) {
          this.logInfo("vap: extra attrs values " + obj.getName());

          local extra = function(t, bonus = 0) {
            local chance = talentValue * 2 * t * (1 + bonus) * 100;
            return Math.rand(0, chance + 99) / 100;
          }
          for( local i = 0; i != Const.Attributes.COUNT; i = ++i ) {
            local bonus = i == Const.Attributes.Initiative ? 1 : 0;
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
      this.logInfo("vap: hired " + this.getName());
      onHired();
      this.addExtraPerks(1);
    }

    obj.addExtraPerks <- function(level) {
      if (level >= m.Level) return;

      this.logInfo("vap: Leveling up " + this.getName() + " from " + level + " to " + m.Level);
      // give a perk point every for certain levels
      for (; ++level <= m.Level;)
        if (givePerk(level)) m.PerkPoints++;
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
