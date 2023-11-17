local mod = ::Autopilot <- {
  ID = "mod_autopilot_new"
  Name = "Autopilot New"
  Version = 2.1
  // Settings
  FreeWake = true // auto break free out of nets and webs and wake allies when unused AP left
  Reload = true   // auto reload when unused AP left
  Verbose = true // show ai debugging for auto bros
}

::mods_registerMod(mod.ID, mod.Version, mod.Name);
::mods_queue(mod.ID, "mod_hooks(>=20), >mod_reforged, !mod_autopilot", function() {
  ::include("autopilot/hooks/actor");
  ::include("autopilot/hooks/player");
  ::include("autopilot/hooks/tactical_state");
  ::include("autopilot/hooks/turn_sequence_bar");
  ::include("autopilot/better_behavior");
  ::include("autopilot/fixes");
  ::include("autopilot/verbose");
  ::mods_registerJS("autopilot_new.js");
  ::mods_registerCSS("autopilot_new.css");

  // The Meat
  ::mods_hookNewObject("ui/screens/tooltip/tooltip_events", function(o) {
    local queryTooltipData = o.general_queryUIElementTooltipData;
    o.general_queryUIElementTooltipData = function(entityId, elementId, elementOwner)
    {
      local tooltip = queryTooltipData(entityId, elementId, elementOwner);
      if(tooltip != null) return tooltip;
      if(elementId == "tactical-screen.turn-sequence-bar-module.WaitTurnAllButton")
      {
        return [
          {
            id = 1,
            type = "title",
            text = "Mass Wait Turn (H)"
          },
          {
            id = 2,
            type = "description",
            text = "Pauses all characters' turns and moves them to the end of the queue, if they haven't waited already. Waiting this turn will also have them act later next round."
          }
        ];
      }
      else if(elementId == "tactical-screen.turn-sequence-bar-module.IgnoreButton")
      {
        return [
          {
            id = 1,
            type = "title",
            text = "Ignore"
          },
          {
            id = 2,
            type = "description",
            text = "Ends this character's turn and causes him to be ignored on future turns."
          }
        ];
      }
      else if(elementId == "tactical-screen.turn-sequence-bar-module.CancelButton")
      {
        return [
          {
            id = 1,
            type = "title",
            text = "Cancel (V)"
          },
          {
            id = 2,
            type = "description",
            text = "Cancels effects such as End Round, Mass Wait, Mass Shield Wall, Ignore, and AI Control."
          }
        ];
      }
      else if(elementId == "tactical-screen.turn-sequence-bar-module.ShieldWallButton")
      {
        return [
          {
            id = 1,
            type = "title",
            text = "Mass Shield Wall (N)"
          },
          {
            id = 2,
            type = "description",
            text = "Makes all characters automatically use the Shieldwall skill at the start of their turn this round, if possible."
          }
        ];
      }
      else if(elementId == "tactical-screen.turn-sequence-bar-module.AIButton")
      {
        return [
          {
            id = 1,
            type = "title",
            text = "AI Control"
          },
          {
            id = 2,
            type = "description",
            text = "Ends the current character's turn and gives control of the party to the AI."
          }
        ];
      }
  
      return null;
    }
  
    local querySkillTooltipFunc = o.onQuerySkillTooltipData;
    o.onQuerySkillTooltipData = function(entityId, skillId)
    {
      local tooltip = querySkillTooltipFunc(entityId, skillId);
      if(tooltip == null)
      {
        local entity = Tactical.getEntityByID(entityId), item = entity.getItems().getItemByInstanceID(skillId);
        if(item != null)
        {
          local currentItem = entity.getItems().getItemAtSlot(item.getSlotType());
          tooltip = [
            {
              id = 1,
              type = "title",
              text = "Switch to " + item.getName()
            },
            {
              id = 2,
              type = "description",
              text = "Quickly switch to another item from your bag."
            },
            {
              id = 3,
              type = "text",
              text = "Costs [b][color=" + Const.UI.Color.PositiveValue + "] " +
                     entity.getItems().getActionCost(currentItem != null ? [currentItem, item] : [item]) + "[/color][/b] AP to switch."
            }
          ];
        }
      }
      return tooltip;
    }
  });
  
  // allow player AI to break free from webs & nets
  ::mods_hookBaseClass("ai/tactical/behavior", function(o) {
    if("PossibleSkills" in o.m && o.m.PossibleSkills.len() == 1 &&
       o.m.PossibleSkills[0] == "actives.break_free")
    {
      o.onEvaluate = function(_entity)
      {
        this.m.Skill = null;
        local score = this.getProperties().BehaviorMult[this.m.ID];
  
        if (_entity.getActionPoints() < this.Const.Movement.AutoEndTurnBelowAP)
        {
          return this.Const.AI.Behavior.Score.Zero;
        }
  
        if (_entity.isPlayerControlled() && _entity.getMoraleState() != this.Const.MoraleState.Fleeing && !this.Tactical.State.isAutoRetreat() &&
            (_entity.getAIAgent() == null || _entity.getAIAgent().ClassName == "player_agent"))
        {
          return this.Const.AI.Behavior.Score.Zero;
        }
  
        if (!_entity.getCurrentProperties().IsRooted)
        {
          return this.Const.AI.Behavior.Score.Zero;
        }
  
        this.m.Skill = this.selectSkill(this.m.PossibleSkills);
  
        if (this.m.Skill == null || this.m.Skill.getChance() <= 30 && _entity.getTile().hasZoneOfControlOtherThan(_entity.getAlliedFactions()))
        {
          return this.Const.AI.Behavior.Score.Zero;
        }
  
        score = score * this.getFatigueScoreMult(this.m.Skill);

        if (this.m.Skill.getChance() <= 30 && _entity.getTile().hasZoneOfControlOtherThan(_entity.getAlliedFactions()))
        {
          return this.Const.AI.Behavior.Score.Zero;
        }

        return this.Const.AI.Behavior.Score.BreakFree * score;
      }
    }
  });
});
