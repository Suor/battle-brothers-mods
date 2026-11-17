// EF-KB1 with the real Hardened 1.26.3 on Reforged 0.9.3, shared by tale_hardened_bugs_elite_few.nut and its control
// without Elite Few, tale_hardened_real_control_ef.nut: Hardened's contract.setScreen hook restarts a screen only when
// ::Hardened.getFunctionCaller() is "processInput"; behind Elite Few's setScreen wrapper the caller is its concat_call.

local function spyCaller() {
    local callers = [];
    local orig = ::Hardened.getFunctionCaller;
    ::Hardened.getFunctionCaller = function (_skip = 0) {
        local ret = orig(_skip);   // this wrapper is anonymous, getFunctionCaller skips it
        callers.push(ret);
        return ret;
    };
    return {callers = callers, restore = @() ::Hardened.getFunctionCaller = orig};
}

::EFKB1 <- {};

::EFKB1.loopRound <- function (t) {
    local c = ::EFT.loopContract();
    c.setScreen("EFT_Loop");
    local spy = spyCaller();
    c.processInput(0);
    spy.restore();
    t.probe("callers seen by Hardened", spy.callers);
    t.eq(c.m.EFT_Starts, 2, "EF-KB1: screen restarted by the option");
}

// Vanilla's Negotiation screen (negotiation_templates.nut): "We need to be paid more" returns "Negotiation" again;
// its start() rebuilds the text and options, so a round that doesn't restart it shows the old screen.
::EFKB1.negotiation <- function (t) {
    local c = ::EFT.loopContract();
    local neg = null;
    foreach (s in c.m.Screens) if (s.ID == "Negotiation") neg = s;
    local starts = {n = 0};
    local start = neg.start;
    neg.start = function () { starts.n++; return start(); };
    c.setScreen("Negotiation");
    t.eq(starts.n, 1, "first show");
    t.probe("options", c.m.ActiveScreen.Options.len());
    local spy = spyCaller();
    local next = c.processInput(1);
    spy.restore();
    t.probe("callers seen by Hardened", spy.callers);
    t.probe("active screen", c.m.ActiveScreen == null ? null : c.m.ActiveScreen.ID);
    t.eq(starts.n, 2, "EF-KB1: the next negotiation round ran start()");
}
