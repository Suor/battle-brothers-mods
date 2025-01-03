local mod = ::Hooks.getMod("mod_autopilot_new");

mod.hook("scripts/ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar",
        function (q) {
    q.m.CancelPending <- false;
    if (!q.m.contains("IsWaitingRound")) q.m.IsWaitingRound <- false; // Reforged fix
    q.m.IsOnAI <- false;

    q.isHumanControlled <- function (_entity = null) {
        if (_entity == null) _entity = getActiveEntity();
        return _entity != null && _entity.isPlayerControlled()
            && (_entity.getAIAgent() == null || _entity.getAIAgent().ClassName == "player_agent");
    }
    q.canAuto <- function (_entity = null) {
        if (_entity == null) _entity = getActiveEntity();
        return this.isHumanControlled(_entity)
            && !_entity.isGuest() && (!("_isIgnored" in _entity.m) || !_entity.m._isIgnored)
            && (::Autopilot.conf("player") || !_entity.getSkills().hasSkill("trait.player"));
    }

    q.initNextRound = @(__original) function () {
        __original();
        if (this.m.AllEntities.len() > 0) {
            this.m.IsWaitingRound = false;
            this.m.JSHandle.call("setWaitTurnAllButtonVisible", true);
        }
    }

    q.onWaitTurnAllButtonPressed <- function () {
        if(this.m.IsSkippingRound || this.m.IsWaitingRound || !isHumanControlled()) return;

        this.Tactical.State.showDialogPopup("Wait",
            "Have all your characters wait until the second phase?", function ()
        {
            this.m.IsWaitingRound = true;
            this.m.JSHandle.call("setWaitTurnAllButtonVisible", false);
            this.initNextTurnBecauseOfWait();
        }.bindenv(this), null);
    }

    q.onShieldWallButtonPressed <- function () {
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

    q.onIgnoreButtonPressed <- function () {
        if(this.m.IsSkippingRound || !isHumanControlled()) return;
        this.getActiveEntity().m._isIgnored <- true;
        this.initNextTurn();
    }

    q.onCancelButtonPressed <- function () {
        if (m.IsLocked || !isHumanControlled()) m.CancelPending = true;
        else cancelAutoActions();
    }

    q.cancelAutoActions <- function (cancelIgnorance = true) {
        foreach (e in m.AllEntities) {
            if (e.isPlayerControlled() || ::Autopilot.isUnderAIControl(e)) {
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

    q.onAIButtonPressed <- function () {
        if (m.IsSkippingRound || !canAuto()) {return;}

        Tactical.State.showDialogPopup("AI Control", "Turn control over to the AI?", function ()
        {
            cancelAutoActions(false); // reset changes we may have made (except ignoring bros)
            m.IsOnAI = true;
            m.JSHandle.call("showStatsPanel", false);
            foreach(e in m.AllEntities) {
                if (canAuto(e)) {
                    e.enableAIControl();
                    // For next line from Adam: seems to cause intermittent crashes...
                    // But works fine for me so far.
                    e.getAIAgent().onTurnStarted();
                }
            }
        }.bindenv(this), null);
    }

    // The cancel needs to be here to prevent auto skills, those are called indirectly from here
    q.onEntityEntersFirstSlot = @(__original) function (_entityId) {
        if (m.CancelPending) cancelAutoActions();
        return __original(_entityId)
    }

    q.onEntityEnteredFirstSlotFully = @(__original) function (_entityId) {
        __original(_entityId);

        local entity = this.findEntityByID(this.m.CurrentEntities, _entityId);
        if (entity) {
            local e = entity.entity;
            if (e.isPlayerControlled()) {
                // NOTE: this works unless you just changed settings, not really needed though.
                // m.JSHandle.call("setAIButtonVisible", canAuto(e));
                if ("_isIgnored" in e.m && e.m._isIgnored) initNextTurn();
                else if (m.IsWaitingRound) entityWaitTurn(e);
            }
        }
    }

    q.convertEntityToUIData = @(__original) function (_entity, isLastEntity = false) {
        local ret = __original(_entity);
        // Either auto controlled player or non-player entity
        local isPlayer = _entity.isPlayerControlled();
        local onAuto = !m.CancelPending && (
            m.IsSkippingRound || m.IsWaitingRound && !_entity.isWaitActionSpent()
            || ("_isIgnored" in _entity.m && _entity.m._isIgnored)
            || !isHumanControlled(_entity));
        ret.isEnemy = !isPlayer || isPlayer && onAuto || Tactical.State.isAutoRetreat()
        return ret;
    }

    q.convertEntitySkillsToUIData = @(__original) function (_entity) {
        local ret = __original(_entity);
        if (ret == null || !("querySwitchableItems" in _entity)) return ret;

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
