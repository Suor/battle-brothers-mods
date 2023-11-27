// Allow verbose mode for our guys
local function wrap(_func, _switchControlled = false) {
    return function (_entity = null) {
        local hasArg = !!_entity;
        local actor = _entity || this.m.Actor;
        if (("_autopilot" in actor.m) && ::Autopilot.conf("verbose")) {
            // Switch to verbose mode and flip the IsControlledByPlayer flag
            // so that things won't be supressed
            local oldVerbose = Const.AI.VerboseMode;
            Const.AI.VerboseMode = true;
            if (_switchControlled) actor.m.IsControlledByPlayer = false;

            local ret = hasArg ? _func(_entity) : _func();

            // Switch things back
            if (_switchControlled) actor.m.IsControlledByPlayer = true;
            Const.AI.VerboseMode = oldVerbose;

            return ret;
        } else {
            return hasArg ? _func(_entity) : _func();
        }
    }
}

::mods_hookBaseClass("ai/tactical/agent", function (agent) {
    while (!("evaluate" in agent)) agent = agent[agent.SuperName];

    agent.evaluate = wrap(agent.evaluate);
    agent.execute = wrap(agent.execute);
    agent.pickBehavior = wrap(agent.pickBehavior, true);
    agent.onTurnStarted = wrap(agent.onTurnStarted, true);
    agent.onTurnResumed = wrap(agent.onTurnResumed, true);
});
// Need to do this separately because it is executed outside of those above sometimes
::mods_hookExactClass("ai/tactical/behaviors/ai_idle", function (ai_idle) {
    ai_idle.onExecute = wrap(ai_idle.onExecute, true);
});
