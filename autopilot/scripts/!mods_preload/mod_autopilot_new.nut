local mod = ::Autopilot <- {
  ID = "mod_autopilot_new"
  Name = "Autopilot New"
  Version = 2.0
  // Settings
  FreeWake = true // auto break free out of nets and webs and wake allies when unused AP left
  Reload = true   // auto reload when unused AP left
  Verbose = true // show ai debugging for auto bros
}

::mods_registerMod(mod.ID, mod.Version, mod.Name);
::mods_queue(mod.ID, "mod_hooks(>=20), >mod_reforged, !mod_autopilot", function() {
  ::include("autopilot/hooks/tactical_state");
  ::include("autopilot/hooks/turn_sequence_bar");
  ::include("autopilot/better_behavior");
  ::include("autopilot/fixes");
  ::include("autopilot/verbose");
  ::mods_registerJS("autopilot_new.js");
  ::mods_registerCSS("autopilot_new.css");

  // The Meat
  ::mods_hookBaseClass("entity/tactical/actor", function(o) {
    while(!("onTurnStart" in o)) o = o[o.SuperName];
  
    o.addAutoSkill <- function(skillId)
    {
      if(!("autoSkills" in m)) m.autoSkills <- [];
      m.autoSkills.append(skillId);
    }
  
    o.clearAutoSkills <- function()
    {
      if("autoSkills" in m) m.autoSkills.clear();
    }
  
    o.processAutoSkills <- function()
    {
      if (m.MoraleState != Const.MoraleState.Fleeing && "autoSkills" in m)
      {
        local skills = getSkills();
        foreach(id in m.autoSkills)
        {
          local skill = skills.getSkillByID(id);
          if (skill != null && skill.isUsable() && skill.isAffordable())
            skill.use(getTile());
        }
  
        m.autoSkills.clear();
      }
    }
  
    local onTurnStart = o.onTurnStart, onTurnResumed = o.onTurnResumed, onTurnEnd = o.onTurnEnd;
    o.onTurnStart = function()
    {
      onTurnStart();
      processAutoSkills();
    }
  
    o.onTurnResumed = function()
    {
      onTurnResumed();
      processAutoSkills();
    }
  
    o.onTurnEnd = function()
    {
      if(ClassName == "player" && getMoraleState() != Const.MoraleState.Fleeing)
      {
        local skills = getSkills(), tile = getTile();
        local function tryUseSkill(id, t)
        {
          local s = skills.getSkillByID(id);
          return s != null && s.use(t);
        }

        if(::Autopilot.FreeWake || ::Autopilot.Reload)
        {
          // see if we can help ourselves first
          if(::Autopilot.FreeWake) tryUseSkill("actives.break_free", tile);
          if(::Autopilot.Reload)
          {
            foreach(s in ["actives.reload_bolt", "actives.reload_handgonne"]) tryUseSkill(s, tile);
          }

          // then try to help adjacent allies
          if(::Autopilot.FreeWake)
          {
            foreach(s in ["actives.wake_ally", "actives.break_ally_free"])
            {
              local skill = skills.getSkillByID(s);
              if(skill != null && skill.isUsable() && skill.isAffordable())
              {
                for(local dir = 0; dir < 6; dir++)
                {
                  if(tile.hasNextTile(dir))
                  {
                    local adjTile = tile.getNextTile(dir);
                    if(adjTile.IsOccupiedByActor && adjTile.getEntity().isAlliedWith(this))
                    {
                      for(local i = 0; i < 3 && skill.use(adjTile); i++) { }
                    }
                  }
                }
              }
            }
          }
        }

        // finally, use the recover skill if it'd help
        if(getFatigue() > m.CurrentProperties.FatigueRecoveryRate) tryUseSkill("actives.recover", tile);
      }

      onTurnEnd();
      clearAutoSkills();
    }
  });

  ::mods_hookBaseClass("entity/tactical/human", function(o) {
    if("getLevelUps" in o) // if it's the player class...
    {
      o.isUnderAIControl <- function() {return "_oldAgent" in m;}
  
      o.enableAIControl <- function()
      {
        m._oldAgent <- getAIAgent();
        local mode = m._autopilot <- {ranged = false, throwing = false};
        mode.ranged <- isArmedWithRangedWeapon();

        // Check if throwing
        local weapon = m.Items.getItemAtSlot(::Const.ItemSlot.Mainhand);
        mode.throwing <- mode.ranged && weapon.isItemType(Const.Items.ItemType.Ammo);

        // if armed with a throwing weapon, use the melee AI instead of the ranged AI.
        mode.agent <- mode.ranged && !mode.throwing ? "military_ranged" : "military_melee";
        local agent = new("scripts/ai/tactical/agents/" + mode.agent + "_agent");

        // agent.compileKnownAllies optimizes itself to no-op for the player faction, but we need it to work
        agent.compileKnownAllies = function() {
          local instances = this.Tactical.Entities.getAllInstances();
          this.m.KnownAllies = [];
          foreach( i, faction in instances )
          {
            if (faction.len() == 0 || this.m.Actor.getFaction() != i && !this.m.Actor.isAlliedWith(i))
            {
              continue;
            }

            foreach( entity in faction )
            {
              if (entity.isAlive() && !entity.isDying() && entity.isPlacedOnMap())
              {
                this.m.KnownAllies.push(entity);
              }
            }
          }
        }

        // Make backrow more active
        if (!mode.ranged && this.getIdealRange() == 2) {
          agent.m.Properties.BehaviorMult[Const.AI.Behavior.ID.Disengage] = 2.0;
          agent.m.Properties.EngageFlankingMult = 5.0;  // Like wolfrider :)
        }
        if (mode.throwing) {
          // Prefer attacking over engaging, i.e. wandering around
          agent.m.Properties.BehaviorMult[Const.AI.Behavior.ID.EngageMelee] = 0.5;
          // TODO: separate throwing only from hybrids
          // agent.m.Properties.BehaviorMult[Const.AI.Behavior.ID.SwitchToMelee] = 0.5;
          // agent.m.Properties.BehaviorMult[Const.AI.Behavior.ID.Disengage] = 2.0;
          // Otherwise is afraid of "shooting over shoulder"
          agent.m.Properties.TargetPriorityHittingAlliesMult = 1.0;
          // This guys are supposed to hit and injure
          agent.removeBehavior(Const.AI.Behavior.ID.Protect);
        }
        if (mode.ranged) {
          agent.m.Properties.BehaviorMult[Const.AI.Behavior.ID.Disengage] = 5.0;
        }

        // Our behaviors
        agent.addBehavior(this.new("scripts/ai/autopilot_unbag_net"));
        agent.addBehavior(this.new("scripts/ai/autopilot_unbag_shield"));

        // Military agents don't have this
        agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_disengage"));
        agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_throw_net"));
        agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_adrenaline"));
        agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_pickup_weapon"));
        agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_line_breaker"));
        // Disabled since doesn't consult offhand/backpack at all
        // agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_throw_bomb"));

        // military doesn't have it, but bandit does
        agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_deathblow"));

        // Until we properly use standard bearer
        agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_rally"));

        // Only works because we overwrite break_free.onEvaluate() below
        agent.m.Properties.BehaviorMult[Const.AI.Behavior.ID.BreakFree] = 2.5;

        // Look at this for bros having scare stuff
        // TargetPriorityMoraleMult = 0.0,
        // TargetPriorityBraveryMult = 0.0,

        // Should not be needed as long as we set IsControlledByPlayer to true
        agent.removeBehavior(Const.AI.Behavior.ID.Retreat); // retreat is always chosen for players if available, so remove it

        // reduce the chance of friendly fire, affects ranged in a weird manner
        // agent.m.Properties.TargetPriorityHittingAlliesMult *= 0.2;

        // Affects .isPlayerControlled(), which affects many behaviors and logging
        // this.m.IsControlledByPlayer = false;

        agent.finalizeBehaviors();
        agent.setActor(this);
        setAIAgent(agent);
      }
  
      o.cancelAIControl <- function()
      {
        if(isUnderAIControl())
        {
          local agent = getAIAgent();
          if(agent.ClassName != "player_agent")
          {
            if(agent.getID() != Const.AI.Agent.ID.CharmedPlayer) setAIAgent(m._oldAgent);
            local skill = getSkills().getSkillByID("effects.charmed");
            if(skill != null) skill.m.OriginalAgent = m._oldAgent;
          }
          // Return control
          // this.m.IsControlledByPlayer = true;
          delete m._oldAgent;
          delete this.m._autopilot;
        }
      }

      local onDeath = o.onDeath;
      o.onDeath = function(killer, skill, tile, fatalityType)
      {
        this.cancelAIControl(); // if a bro dies while under AI control it may hang around as a "ghost"...
        onDeath(killer, skill, tile, fatalityType);
      }

      local onCombatFinished = o.onCombatFinished;
      o.onCombatFinished = function()
      {
        clearAutoSkills();
        cancelAIControl();
        if("_isIgnored" in m) delete m._isIgnored;
        onCombatFinished();
      }
  
      o.querySwitchableItems <- function()
      {
        local items = [], inv = getItems();
        if(inv.isActionAffordable([])) // if we could afford any kind of action...
        {
          for(local itemType = Const.Items.ItemType, i = 0; i < inv.getUnlockedBagSlots(); i++)
          {
            local item = inv.getItemAtBagSlot(i);
            if(item == null) continue;
            local slot = item.getSlotType();
            if(slot == Const.ItemSlot.None || slot == Const.ItemSlot.Bag) continue;
            local currentItem = inv.getItemAtSlot(slot);
            if(item != null &&
               (item.isItemType(itemType.Weapon) || item.isItemType(itemType.Tool) || item.isItemType(itemType.Shield) ||
                item.isItemType(itemType.Accessory) || (item.isItemType(itemType.Ammo) && item.m.Ammo != 0)) &&
               inv.isActionAffordable(currentItem != null ? [currentItem, item] : [item]))
            {
              items.append(item);
            }
          }
        }
        return items;
      }
    }
  });
  
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
