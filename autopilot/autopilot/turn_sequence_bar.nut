local Debug = ::std.Debug.with({prefix = "ap: "})

local function logEntity(_func, _entity) {
    local getName = ::std.Util.getMember(_entity, "getName");
    logInfo(_func + " " + _entity
        + " ClassName=" + ("ClassName" in _entity ? _entity.ClassName : "")
        + " name=" + (getName ? getName() : ""))
}

::mods_hookExactClass("ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar",
        function (cls) {
    cls.m.CancelPending <- false;
    cls.m.IsWaitingRound <- false;

    cls.isHumanControlled <- function (entity = null) {
        if (entity == null) entity = getActiveEntity();
        return entity != null && entity.isPlayerControlled()
            && (entity.getAIAgent() == null || entity.getAIAgent().ClassName == "player_agent");
    }

    local initNextRound = cls.initNextRound;
    cls.initNextRound = function () {
        initNextRound();
        if (this.m.AllEntities.len() > 0) {
            this.m.IsWaitingRound = false;
            this.m.JSHandle.call("setWaitTurnAllButtonVisible", true);
        }
    }

    local initNextTurn = cls.initNextTurn;
    cls.initNextTurn = function (_force = false) {
        local activeEntity = this.m.CurrentEntities[0];
        initNextTurn(_force);
        this.m.IsLastEntityPlayerControlled = activeEntity.isPlayerControlled()
            || "isUnderAIControl" in activeEntity && activeEntity.isUnderAIControl();
    }

    local onNextTurnButtonPressed = cls.onNextTurnButtonPressed;
    cls.onNextTurnButtonPressed = function () {
        if (!this.isHumanControlled()) return;
        this.initNextTurn();
    }

    local onWaitTurnButtonPressed = cls.onWaitTurnButtonPressed;
    cls.onWaitTurnButtonPressed = function () {
        if (!this.isHumanControlled()) return;
        this.entityWaitTurn(this.getActiveEntity());
    }

    local onEndTurnAllButtonPressed = cls.onEndTurnAllButtonPressed;
    cls.onEndTurnAllButtonPressed = function () {
        // if (this.m.IsSkippingRound || this.getActiveEntity() == null || !this.getActiveEntity().isPlayerControlled())
        if (this.m.IsSkippingRound || !isHumanControlled())
        {
            return;
        }

        this.Tactical.State.showDialogPopup("End Round", "Have all your characters skip their turn until the next round starts?", function ()
        {
            this.m.IsSkippingRound = true;
            this.m.JSHandle.call("setEndTurnAllButtonVisible", false);
            // START NEW CODE
            this.m.JSHandle.call("setWaitTurnAllButtonVisible", false);
            // END NEW CODE

            foreach( e in this.m.CurrentEntities )
            {
                if (e.isPlayerControlled())
                {
                    e.setSkipTurn(true);
                }
            }

            this.initNextTurn();
        }.bindenv(this), null);
    }

    cls.onWaitTurnAllButtonPressed <- function () {
        if(this.m.IsSkippingRound || this.m.IsWaitingRound || !isHumanControlled())
        {
            return;
        }

        this.Tactical.State.showDialogPopup("Wait", "Have all your characters wait until the second phase?", function ()
        {
            this.m.IsWaitingRound = true;
            this.m.JSHandle.call("setWaitTurnAllButtonVisible", false);
            this.initNextTurnBecauseOfWait();
        }.bindenv(this), null);
    }

    cls.onShieldWallButtonPressed <- function () {
        if(this.m.IsSkippingRound || !isHumanControlled())
        {
            return;
        }

        this.Tactical.State.showDialogPopup("Shield Wall", "Have all your characters shieldwall this turn if they can?", function ()
        {
            foreach( e in this.m.CurrentEntities )
            {
                if (e.isPlayerControlled() && !e.m.IsTurnDone) e.addAutoSkill("actives.shieldwall");
            }

            this.getActiveEntity().processAutoSkills();
        }.bindenv(this), null);
    }

    cls.onIgnoreButtonPressed <- function () {
        if(this.m.IsSkippingRound || !isHumanControlled())
        {
            return;
        }

        this.getActiveEntity().m._isIgnored <- true;
        this.initNextTurn();
    }

    cls.onCancelButtonPressed <- function () {
        if(m.IsLocked || !isHumanControlled()) m.CancelPending = true;
        else cancelAutoActions();
    }

    cls.cancelAutoActions <- function (cancelIgnorance = true) {
        // local entity = this.getActiveEntity();
        // logEntity("cancelAutoActions", entity);

        m.IsSkippingRound = false;
        m.IsWaitingRound = false;
        Tactical.State.m.IsEnemyRetreatDialogShown = true; // show the "enemy retreating" popup again

        foreach(e in m.AllEntities)
        {
            if(e.isPlayerControlled() || "isUnderAIControl" in e && e.isUnderAIControl())
            {
                e.clearAutoSkills();
                if(cancelIgnorance) e.m._isIgnored <- false;
                e.setSkipTurn(false);
                e.cancelAIControl();
            }
        }

        m.JSHandle.call("setEndTurnAllButtonVisible", true);
        m.JSHandle.call("setWaitTurnAllButtonVisible", true);
        m.JSHandle.call("setAIButtonVisible", true);
        m.CancelPending = false;
    }

    cls.onAIButtonPressed <- function () {
        if(m.IsSkippingRound || !isHumanControlled())
        {
            return;
        }

        Tactical.State.showDialogPopup("AI Control", "Turn control over to the AI?", function ()
        {
            cancelAutoActions(false); // reset changes we may have made (except ignoring bros)
            m.JSHandle.call("setEndTurnAllButtonVisible", false);
            m.JSHandle.call("setWaitTurnAllButtonVisible", false);
            m.JSHandle.call("setAIButtonVisible", false);
            Tactical.State.m.IsEnemyRetreatDialogShown = true; // don't show the "enemy retreating" popup
            foreach(e in m.AllEntities)
            {
                if (e.isPlayerControlled() && e.getAIAgent().ClassName == "player_agent" && !e.isGuest() &&
                    (!("_isIgnored" in e.m) || !e.m._isIgnored))
                {
                    e.enableAIControl();
                    e.getAIAgent().onTurnStarted();
                    // agent.onTurnStarted(); // seems to cause intermittent crashes...
                    //initNextTurn();
                }
            }
        }.bindenv(this), null);
    }

    local onEntityEntersFirstSlot = cls.onEntityEntersFirstSlot;
    cls.onEntityEntersFirstSlot = function (_entityId) {
        // local entity = this.findEntityByID(this.m.AllEntities, _entityId);
        // logEntity("onEntityEntersFirstSlot", entity);

        if(m.CancelPending) cancelAutoActions();
        return onEntityEntersFirstSlot(_entityId)
    }

    local onEntityEnteredFirstSlotFully = cls.onEntityEnteredFirstSlotFully;
    cls.onEntityEnteredFirstSlotFully = function (_entityId) {
        local entity = this.findEntityByID(this.m.CurrentEntities, _entityId);

        if (entity)
        {
            if (this.m.OnEntityEnteredFirstSlotFullyListener != null)
            {
                this.m.OnEntityEnteredFirstSlotFullyListener(entity.entity);
            }

            this.m.IsLocked = false;
            // START NEW CODE
            local e = entity.entity;
            if(e.isPlayerControlled())
            {
                if("_isIgnored" in e.m && e.m._isIgnored) initNextTurn();
                else if(m.IsWaitingRound) onWaitTurnButtonPressed();
            }
            // END NEW CODE
        }
    }

    local convertEntityToUIData = cls.convertEntityToUIData;
    cls.convertEntityToUIData = function (_entity, isLastEntity = false) {
        // logEntity("convertEntityToUIData", _entity);
        // START NEW CODE
        // if it is or will be human controlled
        local humanControlled = _entity.isPlayerControlled() && (_entity.getAIAgent() == null || _entity.getAIAgent().ClassName == "player_agent" || m.CancelPending);
        // END NEW CODE
        local result = {
            id = _entity.getID(),
            name = _entity.getName(),
            nameOnly = _entity.getNameOnly(),
            levelImagePath = _entity.getLevelImagePath(),
            imageOffsetX = _entity.isDiscovered() ? _entity.getImageOffsetX() : 0,
            imageOffsetY = _entity.isDiscovered() ? _entity.getImageOffsetY() : 0,
            actionPoints = _entity.getActionPoints(),
            actionPointsMax = _entity.getActionPointsMax(),
            hitpoints = _entity.getHitpoints(),
            hitpointsMax = _entity.getHitpointsMax(),
            morale = _entity.getMoraleState(),
            moraleMax = this.Const.MoraleState.COUNT - 1,
            moraleLabel = this.Const.MoraleStateName[_entity.getMoraleState()],
            fatigue = _entity.getFatigue(),
            fatigueMax = _entity.getFatigueMax(),
            armorHead = _entity.getArmor(this.Const.BodyPart.Head),
            armorHeadMax = _entity.getArmorMax(this.Const.BodyPart.Head),
            armorBody = _entity.getArmor(this.Const.BodyPart.Body),
            armorBodyMax = _entity.getArmorMax(this.Const.BodyPart.Body),
            // isEnemy = !_entity.isPlayerControlled() || this.Tactical.State.isAutoRetreat(),
            isEnemy = !humanControlled || this.Tactical.State.isAutoRetreat(),
            isHiddenToPlayer = _entity.isHiddenToPlayer() || _entity.getFaction() != 1 && this.Settings.getGameplaySettings().FasterAIMovement || this.Tactical.State.isAutoRetreat(),
            isWaitActionSpent = !this.canEntityWait(_entity)
        };

        if (_entity.isDiscovered())
        {
            result.imagePath <- _entity.getImagePath();
        }
        else
        {
            result.imagePathFoW <- _entity.getImagePath();
        }

        return result;
    }

    local convertEntitySkillsToUIData = cls.convertEntitySkillsToUIData;
    cls.convertEntitySkillsToUIData = function (_entity) {
        // logEntity("convertEntitySkillsToUIData", _entity);
        // logInfo("ap: isPlayerControlled " + _entity.isPlayerControlled());
        // logInfo("ap: isHumanControlled " + isHumanControlled(_entity));
        if (_entity.isPlayerControlled())
        {

            local result = [];
            local activeSkills = _entity.getSkills().queryActives();

            foreach( skill in activeSkills )
            {
                if (skill.isHidden())
                {
                    continue;
                }

                local isSkillAffordable = skill.isAffordable();

                if (this.m.ActiveEntityCostsPreview != null && this.m.ActiveEntityCostsPreview.id == _entity.getID())
                {
                    isSkillAffordable = skill.isAffordablePreview();
                }

                result.push({
                    id = skill.getID(),
                    imagePath = skill.getIcon(),
                    isUsable = skill.isUsable() && skill.isAffordable(),
                    isAffordable = isSkillAffordable
                });
            }

            // START NEW CODE
            foreach(item in _entity.querySwitchableItems())
                result.push({ id = item.getInstanceID(), imagePath = "ui/items/" + item.getIcon(), isUsable = true, isAffordable = true });

            // END NEW CODE
            return result;
        }

        return null;
    }
})
