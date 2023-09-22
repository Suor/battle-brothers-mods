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
::mods_queue(mod.ID, null, function() {
  ::include("autopilot/better_behavior");
  ::include("autopilot/fixes");
  ::include("autopilot/verbose");

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
      o.isUnderAIControl <- function()
      {
        return "_oldAgent" in m;
      }
  
      o.enableAIControl <- function()
      {
        this.m._autopilot <- true;
        m._oldAgent <- getAIAgent();
        local isRanged = isArmedWithRangedWeapon();
        local agentType = isRanged ? "military_ranged" : "bandit_melee";
        // if armed with a throwing weapon, use the melee AI instead of the ranged AI
        // military is a bit more defensive so use it for throwing bros instead of bandit.
        if(isRanged) {
          local weapon = m.Items.getItemAtSlot(Const.ItemSlot.Mainhand);
          if (weapon.isItemType(Const.Items.ItemType.Ammo)) agentType = "military_melee";
        }
        local agent = new("scripts/ai/tactical/agents/"+ agentType + "_agent");

        // agent.compileKnownAllies optimizes itself to no-op for the player faction, but we need it to work
        agent.compileKnownAllies = function()
        {
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
        if (!isRanged && this.getIdealRange() == 2) {
          agent.m.Properties.EngageFlankingMult = 5.0;  // Like wolfrider :)
          // // Note sure about these
          // agent.m.Properties.OverallFormationMult = 0.0;
          // agent.m.Properties.OverallDefensivenessMult = 0.0;
          //
          // agent.m.Properties.IgnoreTargetValueOnEngage = true;  // do not wait
          // agent.m.Properties.PreferCarefulEngage = false;  // do not hide at all
          // // Global shit
          //    EngageCoverWithReachWeaponMult (global shit)
          //    Const.AI.Behavior.EngageDistancePenaltyMult = 0.0;
        }

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

        // TODO: use adrenaline less
        //       fix the link to original mod in README

        // Until we properly use standard bearer
        agent.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_rally"));

        // Use shield wall and split shield less
        agent.m.Properties.BehaviorMult[Const.AI.Behavior.ID.Shieldwall] = 0.75;
        agent.m.Properties.BehaviorMult[Const.AI.Behavior.ID.SplitShield] = 0.75;
        agent.m.Properties.BehaviorMult[Const.AI.Behavior.ID.KnockBack] = 0.75;

        // Don't need for bandits
        // agent.m.Properties.OverallDefensivenessMult = 1.0;
        // agent.m.Properties.OverallFormationMult = 1.0;

        // Look at this for bros having scare stuff
        // TargetPriorityMoraleMult = 0.0,
        // TargetPriorityBraveryMult = 0.0,

        // Should not be needed as long as we set IsControlledByPlayer to true
        agent.removeBehavior(Const.AI.Behavior.ID.Retreat); // retreat is always chosen for players if available, so remove it
        agent.m.Properties.TargetPriorityHittingAlliesMult *= 0.2; // reduce the chance of friendly fire

        // Affects .isPlayerControlled(), which affects many behaviors and logging
        // this.m.IsControlledByPlayer = false;

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
  
  ::mods_hookNewObject("states/tactical_state", function(o) {
    local handleKey = o.helper_handleContextualKeyInput;
    o.helper_handleContextualKeyInput = function(key)
    {
      if(helper_handleDeveloperKeyInput(key)) return true;
  
      if(key.getKey() == 32 && key.getState() == 0 && key.getModifier() != 1 &&
         !isInLoadingScreen() && !isBattleEnded()) // V. allow cancel during enemy's turn
      {
        Tactical.TurnSequenceBar.onCancelButtonPressed();
        return true;
      }
  
      local result = handleKey(key);
      if (!result && key.getState() == 0 && key.getModifier() != 1 && !isInCharacterScreen())
      {
        if(key.getKey() == 18) // H
        {
          Tactical.TurnSequenceBar.onWaitTurnAllButtonPressed();
          return true;
        }
        else if(key.getKey() == 24) // N
        {
          Tactical.TurnSequenceBar.onShieldWallButtonPressed();
          return true;
        }
      }
      
      return result;
    }
  
    o.swapToItem <- function(entity, item)
    {
      if(m.CurrentActionState != null)
      {
        Tooltip.reload();
        Tactical.TurnSequenceBar.deselectActiveSkill();
        Tactical.getHighlighter().clear();
        m.CurrentActionState = null;
        m.SelectedSkillID = null;
        updateCursorAndTooltip();
      }
  
      m.CharacterScreen.onEquipBagItem([entity.getID(), item.getInstanceID()]);
    }
  
    local onSkillClickedFunc = o.turnsequencebar_onEntitySkillClicked;
    o.turnsequencebar_onEntitySkillClicked = function(skillId)
    {
      local activeEntity = this.Tactical.TurnSequenceBar.getActiveEntity();
      if(activeEntity == null || activeEntity.getSkills().getSkillByID(skillId) != null)
      {
        onSkillClickedFunc(skillId);
      }
      else if(!isInputLocked())
      {
        local item = activeEntity.getItems().getItemByInstanceID(skillId);
        if(item) swapToItem(activeEntity, item);
      }
    }
  
    local setStateByIndexFunc = o.setActionStateBySkillIndex;
    o.setActionStateBySkillIndex = function(index)
    {
      local e = this.Tactical.TurnSequenceBar.getActiveEntity(), itemIndex = -1;
      if(e != null && !isInputLocked()) itemIndex = index - e.getSkills().queryActives().len();
      if(itemIndex >= 0)
      {
        local items = e.querySwitchableItems();
        if(itemIndex < items.len()) swapToItem(e, items[itemIndex]);
      }
      else
      {
        setStateByIndexFunc(index);
      }
    }
  
    o.updateCurrentEntity = function()
    {
      if (this.m.IsGameFinishable && this.isBattleEnded())
      {
        return;
      }
  
      if (this.m.IsGamePaused)
      {
        return;
      }
  
      local activeEntity = this.Tactical.TurnSequenceBar.getActiveEntity();
  
      if (activeEntity == null)
      {
        this.Tactical.TurnSequenceBar.initNextTurn();
        return;
      }
  
      activeEntity.onUpdate();
  
      local agent = activeEntity.getAIAgent();
      if (!activeEntity.isPlayerControlled() || this.m.IsAutoRetreat ||
          agent != null && agent.ClassName != "player_agent")
      {
        this.setInputLocked(true);
  
        if (agent != null)
        {
          if (!this.m.IsAIPaused)
          {
            if (!this.Const.AI.ParallelizationMode || !agent.isEvaluating())
            {
              agent.think();
            }
  
            if (agent.isFinished() || !activeEntity.isAlive())
            {
              this.Tactical.TurnSequenceBar.initNextTurn();
            }
          }
        }
        else
        {
          this.Tactical.TurnSequenceBar.initNextTurn();
        }
      }
      else
      {
        if (agent != null && !this.m.IsAIPaused)
        {
          if (!agent.isFinished())
          {
            this.setInputLocked(true);
  
            if (!this.Const.AI.ParallelizationMode || !agent.isEvaluating())
            {
              agent.think();
            }
          }
          else if (!activeEntity.isAlive() || activeEntity.getMoraleState() == this.Const.MoraleState.Fleeing)
          {
            this.Tactical.TurnSequenceBar.initNextTurn();
          }
          else
          {
            this.setInputLocked(false);
          }
        }
        else
        {
          this.setInputLocked(false);
        }
  
        if (!this.isInputLocked())
        {
          switch(this.m.CurrentActionState)
          {
          case this.Const.Tactical.ActionState.SkillSelected:
          case this.Const.Tactical.ActionState.ComputePath:
          case null:
            if (activeEntity.isTurnDone())
            {
              this.Tactical.TurnSequenceBar.initNextTurn();
            }
            else if (!this.Tactical.getNavigator().isTravelling(activeEntity) && !activeEntity.isPlayingRenderAnimation())
            {
              this.Tactical.getShaker().shake(activeEntity, activeEntity.getTile(), 1);
            }
  
            break;
  
          case this.Const.Tactical.ActionState.TravelPath:
            if (!this.Tactical.getNavigator().travel(activeEntity, activeEntity.getActionPoints(), activeEntity.getFatigueMax() - activeEntity.getFatigue()))
            {
              this.Cursor.setCursor(this.Const.UI.Cursor.Hand);
              this.m.CurrentActionState = null;
              this.m.ActiveEntityNeedsUpdate = true;
  
              if (activeEntity.isAlive() && activeEntity.getTile().Level > this.Tactical.getCamera().Level)
              {
                this.Tactical.getCamera().Level = activeEntity.getTile().Level;
              }
            }
  
            if (activeEntity.isAlive() && this.m.ActiveEntityNeedsUpdate)
            {
              this.Tactical.TurnSequenceBar.updateEntity(activeEntity.getID());
              this.m.ActiveEntityNeedsUpdate = false;
            }
  
            break;
          }
        }
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

        return this.Const.AI.Behavior.Score.BreakFree;
      }
    }
  });
});
