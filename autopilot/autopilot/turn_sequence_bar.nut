local Debug = ::std.Debug.with({prefix = "ap: "})

::mods_hookExactClass("states/tactical_state", function (cls) {
    local tactical_flee_screen_onFleePressed = cls.tactical_flee_screen_onFleePressed;
    cls.tactical_flee_screen_onFleePressed = function () {
        Tactical.TurnSequenceBar.cancelAutoActions()
        tactical_flee_screen_onFleePressed()
    }
})

::mods_hookExactClass("ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar",
        function (cls) {
    cls.m.CancelPending <- false;
    cls.m.IsWaitingRound <- false;

    cls._debug <- function (_msg, _entity = null) {
        if (_entity == null) _entity = getActiveEntity();
        local getName = ::std.Util.getMember(_entity, "getName");
        local isPlayerControlled = ::std.Util.getMember(_entity, "isPlayerControlled");
        if (_entity != null && isPlayerControlled == null) {
            Debug.log(_msg + " weird " + _entity, _entity);
        }
        logInfo(_msg + " " + _entity
            + " ClassName=" + ("ClassName" in _entity ? _entity.ClassName : "")
            + " name=" + (getName ? _entity.getName() : "")
            + (isPlayerControlled != null && isHumanControlled(_entity) ? " HUMAN" : " AI")
            + (this.m.CancelPending ? " CancelPending": "")
            )
    }

    cls.isHumanControlled <- function (entity = null) {
        if (entity == null) entity = getActiveEntity();
        return entity != null && entity.isPlayerControlled()
            && (entity.getAIAgent() == null || entity.getAIAgent().ClassName == "player_agent");
    }

    local initNextRound = cls.initNextRound;
    cls.initNextRound = function () {
        // _debug("initNextRound")
        // this.m.IsWaitingRound = false;
        initNextRound();
        if (this.m.AllEntities.len() > 0) {
            this.m.IsWaitingRound = false;
            this.m.JSHandle.call("setWaitTurnAllButtonVisible", true);
        }
        // _debug("initNextRound (after)")
    }

    // Should not be needed anymore
    // local initNextTurn = cls.initNextTurn;
    // cls.initNextTurn = function (_force = false) {
    //     _debug("initNextTurn")
    //     local e = this.getActiveEntity();
    //     if (e != null && e.isPlayerControlled() && m.IsWaitingRound) {
    //         if (entityWaitTurn(e)) return
    //     }
    //     // local activeEntity = this.m.CurrentEntities[0];
    //     initNextTurn(_force);
    //     // this.m.IsLastEntityPlayerControlled = activeEntity.isPlayerControlled()
    //     //     || "isUnderAIControl" in activeEntity && activeEntity.isUnderAIControl();
    //     // _debug("initNextTurn (middle)")
    //     // if (m.CancelPending) cancelAutoActions();
    //     _debug("initNextTurn (after)")
    // }

    // // Q: do we need these two?
    // local onNextTurnButtonPressed = cls.onNextTurnButtonPressed;
    // cls.onNextTurnButtonPressed = function () {
    //     _debug("onNextTurnButtonPressed")
    //     if (!this.isHumanControlled()) return;
    //     this.initNextTurn();
    // }

    // local onWaitTurnButtonPressed = cls.onWaitTurnButtonPressed;
    // cls.onWaitTurnButtonPressed = function () {
    //     _debug("onWaitTurnButtonPressed")
    //     if (!this.isHumanControlled()) return;
    //     this.entityWaitTurn(this.getActiveEntity());
    // }

    // Dont really need
    // local onEndTurnAllButtonPressed = cls.onEndTurnAllButtonPressed;
    // cls.onEndTurnAllButtonPressed = function () {
    //     _debug("onEndTurnAllButtonPressed")
    //     // if (this.m.IsSkippingRound || this.getActiveEntity() == null || !this.getActiveEntity().isPlayerControlled())
    //     if (this.m.IsSkippingRound || !isHumanControlled())
    //     {
    //         return;
    //     }

    //     this.Tactical.State.showDialogPopup("End Round", "Have all your characters skip their turn until the next round starts?", function ()
    //     {
    //         this.m.IsSkippingRound = true;
    //         this.m.JSHandle.call("setEndTurnAllButtonVisible", false);
    //         // START NEW CODE
    //         this.m.JSHandle.call("setWaitTurnAllButtonVisible", false);
    //         // END NEW CODE

    //         foreach( e in this.m.CurrentEntities )
    //         {
    //             if (e.isPlayerControlled())
    //             {
    //                 e.setSkipTurn(true);
    //             }
    //         }

    //         this.initNextTurn();
    //     }.bindenv(this), null);
    // }

    cls.onWaitTurnAllButtonPressed <- function () {
        _debug("onWaitTurnAllButtonPressed")
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
        _debug("onCancelButtonPressed")
        if (m.IsLocked || !isHumanControlled()) m.CancelPending = true;
        else cancelAutoActions();
    }

    cls.cancelAutoActions <- function (cancelIgnorance = true) {
        _debug("cancelAutoActions")

        foreach (e in m.AllEntities) {
            if (e.isPlayerControlled() || "isUnderAIControl" in e && e.isUnderAIControl()) {
                if (cancelIgnorance) e.m._isIgnored <- false;
                e.clearAutoSkills();
                e.setSkipTurn(false);
                e.cancelAIControl();
            }
        }

        m.IsSkippingRound = false;
        m.IsWaitingRound = false;
        // Tactical.State.m.IsEnemyRetreatDialogShown = true; // show the "enemy retreating" popup again
        m.JSHandle.call("setEndTurnAllButtonVisible", true);
        m.JSHandle.call("setWaitTurnAllButtonVisible", true);
        // m.JSHandle.call("setAIButtonVisible", true);

        m.CancelPending = false;
        _debug("cancelAutoActions (after)")
    }

    cls.onAIButtonPressed <- function () {
        _debug("onAIButtonPressed")
        if(m.IsSkippingRound || !isHumanControlled()) {return;}

        Tactical.State.showDialogPopup("AI Control", "Turn control over to the AI?", function ()
        {
            cancelAutoActions(false); // reset changes we may have made (except ignoring bros)
            // m.JSHandle.call("setEndTurnAllButtonVisible", false);
            // m.JSHandle.call("setWaitTurnAllButtonVisible", false);
            // m.JSHandle.call("setAIButtonVisible", false);
            // Tactical.State.m.IsEnemyRetreatDialogShown = true; // don't show the "enemy retreating" popup
            foreach(e in m.AllEntities) {
                if (e.isPlayerControlled() && e.getAIAgent().ClassName == "player_agent"
                    && !e.isGuest() && (!("_isIgnored" in e.m) || !e.m._isIgnored))
                {
                    e.enableAIControl();
                    // For next line from Adam: seems to cause intermittent crashes...
                    // But works fine for me so far.
                    e.getAIAgent().onTurnStarted();
                    //initNextTurn(); // do not skip turn
                }
            }
        }.bindenv(this), null);
    }

    // The cancel needs to be here to prevent auto skills, those are called indirectly from here
    local onEntityEntersFirstSlot = cls.onEntityEntersFirstSlot;
    cls.onEntityEntersFirstSlot = function (_entityId) {
        local entity = this.findEntityByID(this.m.CurrentEntities, _entityId);
        _debug("onEntityEntersFirstSlot", entity ? entity.entity : null)

        if(m.CancelPending) cancelAutoActions();
        return onEntityEntersFirstSlot(_entityId)
    }

    local onEntityEnteredFirstSlotFully = cls.onEntityEnteredFirstSlotFully;
    cls.onEntityEnteredFirstSlotFully = function (_entityId) {
        local entity = this.findEntityByID(this.m.CurrentEntities, _entityId);
        _debug("onEntityEnteredFirstSlotFully", entity ? entity.entity : null)
        _debug("onEntityEnteredFirstSlotFully (active)")

        onEntityEnteredFirstSlotFully(_entityId);

        if (entity) {
            local e = entity.entity;
            if (e.isPlayerControlled()) {
                if ("_isIgnored" in e.m && e.m._isIgnored) initNextTurn();
                else if (m.IsWaitingRound) entityWaitTurn(e);
                // onWaitTurnButtonPressed();
            }
        }
        _debug("onEntityEnteredFirstSlotFully (active after)")
    }

    local convertEntityToUIData = cls.convertEntityToUIData;
    cls.convertEntityToUIData = function (_entity, isLastEntity = false) {
        _debug("convertEntityToUIData", _entity)

        local ret = convertEntityToUIData(_entity);
        local onAuto = m.IsWaitingRound || m.IsSkippingRound || !isHumanControlled(_entity);
        local cancel = m.CancelPending && _entity.isPlayerControlled();
        ret.isEnemy = onAuto && !cancel || Tactical.State.isAutoRetreat()
        return ret;
    }

    local convertEntitySkillsToUIData = cls.convertEntitySkillsToUIData;
    cls.convertEntitySkillsToUIData = function (_entity) {
        _debug("convertEntitySkillsToUIData", _entity)
        local ret = convertEntitySkillsToUIData(_entity);
        if (ret == null) return ret;

        foreach(item in _entity.querySwitchableItems())
            ret.push({
                id = item.getInstanceID()
                imagePath = "ui/items/" + item.getIcon()
                isUsable = true
                isAffordable = true // why?
            });
        return ret;
    }
})
