// Allow verbose mode for our guys, normally there is an extra guard
::mods_hookBaseClass("ai/tactical/agent", function(cls) {
    while(!("pickBehavior" in cls)) cls = cls[cls.SuperName];

    local evaluate = cls.evaluate;
    cls.evaluate = function (_entity) {
      local oldVerbose = Const.AI.VerboseMode;
      Const.AI.VerboseMode = ::Autoplot.Verbose && ("_autopilot" in _entity.m);
      local ret = evaluate(_entity);
      Const.AI.VerboseMode = oldVerbose;
      return ret;
    }
    local execute = cls.execute;
    cls.execute = function (_entity) {
      local oldVerbose = Const.AI.VerboseMode;
      Const.AI.VerboseMode = ::Autoplot.Verbose && ("_autopilot" in _entity.m);
      local ret = execute(_entity);
      Const.AI.VerboseMode = oldVerbose;
      return ret;
    }

    local function wrap_n_call(func) {
      local actor = this.m.Actor;
      if (::Autoplot.Verbose && ("_autopilot" in actor.m)) {
        local oldVerbose = Const.AI.VerboseMode;
        Const.AI.VerboseMode = true;
        actor.m.IsControlledByPlayer = false;
        local ret = func();
        Const.AI.VerboseMode = oldVerbose;
        actor.m.IsControlledByPlayer = true;
        return ret;
      } else {
        return func();
      }
    }

    local pickBehavior = cls.pickBehavior;
    cls.pickBehavior = function() {
      return wrap_n_call(pickBehavior);
    }
    local onTurnStarted = cls.onTurnStarted;
    cls.onTurnStarted = function() {
      return wrap_n_call(onTurnStarted);
    }
    local onTurnResumed = cls.onTurnResumed;
    cls.onTurnResumed = function() {
      return wrap_n_call(onTurnResumed);
    }
});
::mods_hookExactClass("ai/tactical/behaviors/ai_idle", function(cls) {
    local onExecute = cls.onExecute;
    cls.onExecute = function(_entity) {
      if (::Autopilot.Verbose && ("_autopilot" in _entity.m)) {
        local oldVerbose = Const.AI.VerboseMode;
        Const.AI.VerboseMode = true;
        _entity.m.IsControlledByPlayer = false;
        local ret = onExecute(_entity);
        _entity.m.IsControlledByPlayer = true;
        Const.AI.VerboseMode = oldVerbose;
        return ret;
      } else {
        return onExecute(_entity);
      }
    }
});
