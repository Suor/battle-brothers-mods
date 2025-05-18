local mod = ::Hooks.getMod("mod_autopilot_new");

// Allow verbose mode for our guys
local function wrap(_func, _hasArg = true, _switchControlled = false) {
    local function wrapper(_entity = null) {
        local actor = _entity || this.m.Actor;
        if (("_autopilot" in actor.m) && ::Autopilot.conf("verbose")) {
            // Switch to verbose mode and flip the IsControlledByPlayer flag
            // so that things won't be supressed
            local oldVerbose = Const.AI.VerboseMode;
            Const.AI.VerboseMode = true;
            if (_switchControlled) actor.m.IsControlledByPlayer = false;

            local ret = _hasArg ? _func(_entity) : _func();

            // Switch things back
            if (_switchControlled) actor.m.IsControlledByPlayer = true;
            Const.AI.VerboseMode = oldVerbose;

            return ret;
        } else {
            return _hasArg ? _func(_entity) : _func();
        }
    }
    return _hasArg ? function (_entity) {return wrapper(_entity)}
                   : function () {return wrapper()}
}

mod.rawHook("scripts/ai/tactical/agent", function (p) {
    p.evaluate = wrap(p.evaluate);
    p.execute = wrap(p.execute);
    p.pickBehavior = wrap(p.pickBehavior, false, true);
    p.onTurnStarted = wrap(p.onTurnStarted, false, true);
    p.onTurnResumed = wrap(p.onTurnResumed, false, true);
});
// Need to do this separately because it is executed outside of those above sometimes
mod.rawHook("scripts/ai/tactical/behaviors/ai_idle", function (p) {
    p.onExecute = wrap(p.onExecute, true, true);
});
