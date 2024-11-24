local mod = ::Hooks.getMod("mod_autopilot_new");

mod.hook("scripts/states/tactical_state", function (q) {
    q.m.autopilot_IsInputLocked <- false;

    q.helper_handleContextualKeyInput = @(__original) function (key) {
        if (helper_handleDeveloperKeyInput(key)) return true;

        // V. allow cancel during enemy's turn
        if (key.getKey() == 32 && key.getState() == 0 && key.getModifier() != 1 &&
              !isInLoadingScreen() && !isBattleEnded()) {
            Tactical.TurnSequenceBar.onCancelButtonPressed();
            return true;
        }

        local result = __original(key);
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

    q.swapToItem <- function (entity, item) {
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

    q.turnsequencebar_onEntitySkillClicked = @(__original) function (skillId) {
        local activeEntity = this.Tactical.TurnSequenceBar.getActiveEntity();
        if (activeEntity == null || activeEntity.getSkills().getSkillByID(skillId) != null) {
            __original(skillId);
        }
        else if (!isInputLocked()) {
            local item = activeEntity.getItems().getItemByInstanceID(skillId);
            if (item) swapToItem(activeEntity, item);
        }
    }

    q.setActionStateBySkillIndex = @(__original) function (index) {
        local e = this.Tactical.TurnSequenceBar.getActiveEntity(), itemIndex = -1;
        if (e != null && !isInputLocked()) itemIndex = index - e.getSkills().queryActives().len();
        if (itemIndex >= 0) {
            local items = e.querySwitchableItems();
            if(itemIndex < items.len()) swapToItem(e, items[itemIndex]);
        } else {
            __original(index);
        }
    }

    q.isInputLocked = @(__original) function () {
        return this.m.autopilot_IsInputLocked || __original()
    }
    q.updateCurrentEntity = @(__original) function () {
        if (this.m.IsGameFinishable && this.isBattleEnded()) {return;}
        if (this.m.IsGamePaused) {return;}

        local e = Tactical.TurnSequenceBar.getActiveEntity();
        if (e == null) {
            Tactical.TurnSequenceBar.initNextTurn();
            return;
        }

        if (::Autopilot.isUnderAIControl(e)) {
            local pos = Tactical.TurnSequenceBar.getTurnPosition();

            this.m.autopilot_IsInputLocked = true;
            __original()
            this.m.autopilot_IsInputLocked = false;

            // If not finished turn and should then finish it
            if ((e.getAIAgent().isFinished() || !e.isAlive())
                    && Tactical.TurnSequenceBar.getTurnPosition() == pos) {
                Tactical.TurnSequenceBar.initNextTurn();
            }
        } else {
            __original()
        }
    }

    q.turnsequencebar_onCheckEnemyRetreat = @(__original) function () {
        if (Tactical.TurnSequenceBar.m.IsOnAI) {
            // Do not show "run them down" popup if on AI, this flag pevents it.
            // The flag should return to false if enemy not retreating.
            this.m.IsEnemyRetreatDialogShown = true;
            __original();
            this.m.IsEnemyRetreatDialogShown = Tactical.Entities.isEnemyRetreating();
        } else {
            __original()
        }
    }

    // Breaks when trying to retreat in auto mode otherwise
    q.tactical_flee_screen_onFleePressed = @(__original) function () {
        Tactical.TurnSequenceBar.cancelAutoActions()
        __original()
    }
})
