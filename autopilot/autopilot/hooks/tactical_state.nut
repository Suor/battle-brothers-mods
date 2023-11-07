::mods_hookExactClass("states/tactical_state", function (cls) {
    cls.m.autopilot_IsInputLocked <- false;

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

    local isInputLocked = cls.isInputLocked;
    cls.isInputLocked = function () {
        return this.m.autopilot_IsInputLocked || isInputLocked()
    }
    local updateCurrentEntity = cls.updateCurrentEntity;
    cls.updateCurrentEntity = function () {
        if (this.m.IsGameFinishable && this.isBattleEnded()) {return;}
        if (this.m.IsGamePaused) {return;}

        local e = Tactical.TurnSequenceBar.getActiveEntity();
        if (e == null) {
            Tactical.TurnSequenceBar.initNextTurn();
            return;
        }

        if ("isUnderAIControl" in e && e.isUnderAIControl()) {
            local pos = Tactical.TurnSequenceBar.getTurnPosition();

            this.m.autopilot_IsInputLocked = true;
            updateCurrentEntity()
            this.m.autopilot_IsInputLocked = false;

            // If not finished turn and should then finish it
            if ((e.getAIAgent().isFinished() || !e.isAlive())
                    && Tactical.TurnSequenceBar.getTurnPosition() == pos) {
                Tactical.TurnSequenceBar.initNextTurn();
            }
        } else {
            updateCurrentEntity()
        }
    }

    local turnsequencebar_onCheckEnemyRetreat = cls.turnsequencebar_onCheckEnemyRetreat;
    cls.turnsequencebar_onCheckEnemyRetreat = function () {
        if (Tactical.TurnSequenceBar.m.IsOnAI) {
            // Do not show "run them down" popup if on AI, this flag pevents it.
            // The flag should return to false if enemy not retreating.
            this.m.IsEnemyRetreatDialogShown = true;
            turnsequencebar_onCheckEnemyRetreat();
            this.m.IsEnemyRetreatDialogShown = Tactical.Entities.isEnemyRetreating();
        } else {
            turnsequencebar_onCheckEnemyRetreat()
        }
    }

    // Breaks when trying to retreat in auto mode otherwise
    local tactical_flee_screen_onFleePressed = cls.tactical_flee_screen_onFleePressed;
    cls.tactical_flee_screen_onFleePressed = function () {
        Tactical.TurnSequenceBar.cancelAutoActions()
        tactical_flee_screen_onFleePressed()
    }
})
