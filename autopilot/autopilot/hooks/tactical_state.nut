::mods_hookExactClass("states/tactical_state", function (cls) {
    local helper_handleContextualKeyInput = cls.helper_handleContextualKeyInput;
    cls.helper_handleContextualKeyInput = function (key) {
        if (helper_handleDeveloperKeyInput(key)) return true;

        // V. allow cancel during enemy's turn
        if (key.getKey() == 32 && key.getState() == 0 && key.getModifier() != 1 &&
              !isInLoadingScreen() && !isBattleEnded()) {
            Tactical.TurnSequenceBar.onCancelButtonPressed();
            return true;
        }

        local result = helper_handleContextualKeyInput(key);
        if (!result && key.getState() == 0 && key.getModifier() != 1 && !isInCharacterScreen()) {
            if (key.getKey() == 18) { // H
                Tactical.TurnSequenceBar.onWaitTurnAllButtonPressed();
                return true;
            }
            else if (key.getKey() == 24) { // N
                Tactical.TurnSequenceBar.onShieldWallButtonPressed();
                return true;
            }
        }
        
        return result;
    }

    cls.swapToItem <- function (entity, item) {
        if (m.CurrentActionState != null) {
            Tooltip.reload();
            Tactical.TurnSequenceBar.deselectActiveSkill();
            Tactical.getHighlighter().clear();
            m.CurrentActionState = null;
            m.SelectedSkillID = null;
            updateCursorAndTooltip();
        }

        m.CharacterScreen.onEquipBagItem([entity.getID(), item.getInstanceID()]);
    }

    local onSkillClickedFunc = cls.turnsequencebar_onEntitySkillClicked;
    cls.turnsequencebar_onEntitySkillClicked = function(skillId) {
        local activeEntity = this.Tactical.TurnSequenceBar.getActiveEntity();
        if (activeEntity == null || activeEntity.getSkills().getSkillByID(skillId) != null) {
            onSkillClickedFunc(skillId);
        }
        else if (!isInputLocked()) {
            local item = activeEntity.getItems().getItemByInstanceID(skillId);
            if (item) swapToItem(activeEntity, item);
        }
    }

    local setActionStateBySkillIndex = cls.setActionStateBySkillIndex;
    cls.setActionStateBySkillIndex = function (index) {
        local e = this.Tactical.TurnSequenceBar.getActiveEntity(), itemIndex = -1;
        if (e != null && !isInputLocked()) itemIndex = index - e.getSkills().queryActives().len();
        if (itemIndex >= 0) {
            local items = e.querySwitchableItems();
            if(itemIndex < items.len()) swapToItem(e, items[itemIndex]);
        } else {
            setActionStateBySkillIndex(index);
        }
    }

    cls.updateCurrentEntity = function () {
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
