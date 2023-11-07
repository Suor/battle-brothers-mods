::mods_hookExactClass("ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar",
        function (cls) {
    cls.m.CancelPending <- false;
    cls.m.IsWaitingRound <- false;
    cls.m.IsOnAI <- false;

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

    // Q: do we need these?
    // local onNextTurnButtonPressed = cls.onNextTurnButtonPressed;
    // cls.onNextTurnButtonPressed = function () {
    //     if (!this.isHumanControlled()) return;
    //     onNextTurnButtonPressed()
    // }

    // local onWaitTurnButtonPressed = cls.onWaitTurnButtonPressed;
    // cls.onWaitTurnButtonPressed = function () {
    //     if (!this.isHumanControlled()) return;
    //     onWaitTurnButtonPressed()
    // }

    // local onEndTurnAllButtonPressed = cls.onEndTurnAllButtonPressed;
    // cls.onEndTurnAllButtonPressed = function () {
    //     if (this.m.IsSkippingRound || !isHumanControlled()) return;
    //     onEndTurnAllButtonPressed()
    // }

    cls.onWaitTurnAllButtonPressed <- function () {
        if(this.m.IsSkippingRound || this.m.IsWaitingRound || !isHumanControlled()) return;

        this.Tactical.State.showDialogPopup("Wait",
            "Have all your characters wait until the second phase?", function ()
        {
            this.m.IsWaitingRound = true;
            this.m.JSHandle.call("setWaitTurnAllButtonVisible", false);
            this.initNextTurnBecauseOfWait();
        }.bindenv(this), null);
    }

    cls.onShieldWallButtonPressed <- function () {
        if(this.m.IsSkippingRound || !isHumanControlled()) return;

        this.Tactical.State.showDialogPopup("Shield Wall",
            "Have all your characters shieldwall this turn if they can?", function ()
        {
            foreach (e in this.m.CurrentEntities) {
                if (e.isPlayerControlled() && !e.m.IsTurnDone) e.addAutoSkill("actives.shieldwall");
            }
            this.getActiveEntity().processAutoSkills();
        }.bindenv(this), null);
    }

    cls.onIgnoreButtonPressed <- function () {
        if(this.m.IsSkippingRound || !isHumanControlled()) return;
        this.getActiveEntity().m._isIgnored <- true;
        this.initNextTurn();
    }

    cls.onCancelButtonPressed <- function () {
        if (m.IsLocked || !isHumanControlled()) m.CancelPending = true;
        else cancelAutoActions();
    }

    cls.cancelAutoActions <- function (cancelIgnorance = true) {
        foreach (e in m.AllEntities) {
            if (e.isPlayerControlled() || "isUnderAIControl" in e && e.isUnderAIControl()) {
                if (cancelIgnorance) e.m._isIgnored <- false;
                e.clearAutoSkills();
                e.setSkipTurn(false);
                e.cancelAIControl();
            }
        }

        m.IsOnAI = false;
        m.IsSkippingRound = false;
        m.IsWaitingRound = false;
        m.JSHandle.call("setEndTurnAllButtonVisible", true);
        m.JSHandle.call("setWaitTurnAllButtonVisible", true);
        m.CancelPending = false;
    }

    cls.onAIButtonPressed <- function () {
        if (m.IsSkippingRound || !isHumanControlled()) {return;}

        Tactical.State.showDialogPopup("AI Control", "Turn control over to the AI?", function ()
        {
            cancelAutoActions(false); // reset changes we may have made (except ignoring bros)
            m.IsOnAI = true;
            foreach(e in m.AllEntities) {
                if (e.isPlayerControlled() && e.getAIAgent().ClassName == "player_agent"
                    && !e.isGuest() && (!("_isIgnored" in e.m) || !e.m._isIgnored))
                {
                    e.enableAIControl();
                    // For next line from Adam: seems to cause intermittent crashes...
                    // But works fine for me so far.
                    e.getAIAgent().onTurnStarted();
                }
            }
        }.bindenv(this), null);
    }

    // The cancel needs to be here to prevent auto skills, those are called indirectly from here
    local onEntityEntersFirstSlot = cls.onEntityEntersFirstSlot;
    cls.onEntityEntersFirstSlot = function (_entityId) {
        if (m.CancelPending) cancelAutoActions();
        return onEntityEntersFirstSlot(_entityId)
    }

    local onEntityEnteredFirstSlotFully = cls.onEntityEnteredFirstSlotFully;
    cls.onEntityEnteredFirstSlotFully = function (_entityId) {
        onEntityEnteredFirstSlotFully(_entityId);

        local entity = this.findEntityByID(this.m.CurrentEntities, _entityId);
        if (entity) {
            local e = entity.entity;
            if (e.isPlayerControlled()) {
                if ("_isIgnored" in e.m && e.m._isIgnored) initNextTurn();
                else if (m.IsWaitingRound) entityWaitTurn(e);
            }
        }
    }

    local convertEntityToUIData = cls.convertEntityToUIData;
    cls.convertEntityToUIData = function (_entity, isLastEntity = false) {
        local ret = convertEntityToUIData(_entity);
        // Either auto controlled player or non-player entity
        local isPlayer = _entity.isPlayerControlled();
        local onAuto = !m.CancelPending && (
            m.IsSkippingRound || m.IsWaitingRound && !_entity.isWaitActionSpent()
            || ("_isIgnored" in _entity.m && _entity.m._isIgnored)
            || !isHumanControlled(_entity));
        ret.isEnemy = !isPlayer || isPlayer && onAuto || Tactical.State.isAutoRetreat()
        return ret;
    }

    local convertEntitySkillsToUIData = cls.convertEntitySkillsToUIData;
    cls.convertEntitySkillsToUIData = function (_entity) {
        local ret = convertEntitySkillsToUIData(_entity);
        if (ret == null) return ret;

        foreach (item in _entity.querySwitchableItems())
            ret.push({
                id = item.getInstanceID()
                imagePath = "ui/items/" + item.getIcon()
                isUsable = true
                isAffordable = true // already filetered to be affordable
            });
        return ret;
    }
})
