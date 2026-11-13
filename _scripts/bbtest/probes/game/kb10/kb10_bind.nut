// mode: campaign seed=bbtest-battle fresh=1 launch=kb
// mods: mod_autopilot_new mod_ap_probe stdlib@dev
// include: lib/helpers.nut
// KB10 hypothesis: Autopilot binds keyup.autopilot_dialog on every DialogScreen JS show and unbinds on hide; two
// shows without a hide would bind twice, so Enter confirms twice. Counts the JS shows (onScreenAnimating calls before
// the screen is up), the page's bindings (--env ui), and what Enter (ui) or two OKs (the original, no page access) do.
// State in ::__kb, not test locals: closures made in a generator lose its locals after a yield in the original.

local function endBattle(_st) {
    if (::APT.dialogShown()) { ::APT.cancelDialog(); return false; }
    if (!("killed" in _st)) { _st.killed <- true; ::APT.killHostiles(); }
}

local function watch() {
    local d = ::DialogScreen;
    ::__kb.orig <- {animating = d.onScreenAnimating, shown = d.onScreenShown, hidden = d.onScreenHidden};
    d.onScreenAnimating = function () { ::__kb.animating++; ::__kb.orig.animating.call(this); };
    d.onScreenShown = function () { ::__kb.shown++; ::__kb.orig.shown.call(this); };
    d.onScreenHidden = function () { ::__kb.hidden++; ::__kb.orig.hidden.call(this); };
}

local function unwatch() {
    local d = ::DialogScreen;
    d.onScreenAnimating = ::__kb.orig.animating;
    d.onScreenShown = ::__kb.orig.shown;
    d.onScreenHidden = ::__kb.orig.hidden;
}

local function bindings() {
    if (!("BBTest_js" in ::getroottable())) return "no page";
    return ::__kb.t.js("(($._data(document, 'events') || {}).keyup || []).filter(function (h) { return h.namespace === 'autopilot_dialog'; }).length");
}

// Enter on the page (ui), or what each binding does on Enter, once per JS show (the original).
local function enter() {
    if ("BBTest_js" in ::getroottable()) {
        ::__kb.t.js("($(document).trigger($.Event('keyup', {which: KeyConstants.Return})), 0)");
        return "Enter keyup on the page";
    }
    local n = ::__kb.animating;  // each hide's fade-out counts too
    for (local i = 0; i < n; i++) ::DialogScreen.onOkPressed();
    return n + " x onOkPressed";
}

local function steps(_show) {
    return [
        function (_e) {
            watch();
            ::__kb.depth0 <- ::Tactical.State.m.MenuStack.m.Stack.len();
            _show();
            ::__kb.log.push(["after the show calls", ::DialogScreen.isVisible(), ::DialogScreen.isAnimating(), ::__kb.animating]);
        },
        function (_e) {
            if (!::APT.dialogReady()) return false;
            ::__kb.log.push(["dialog up: JS shows (animating calls), shown calls, bindings, menu stack depth",
                ::__kb.animating, ::__kb.shown, bindings(), ::Tactical.State.m.MenuStack.m.Stack.len() - ::__kb.depth0]);
            ::__kb.log.push(["pressed", enter()]);
        },
        function (_e) {
            if (::APT.dialogShown()) return false;
            ::__kb.frames++;
            if (::__kb.frames < 60) return false;  // a second fade-out's end, if any
            ::__kb.log.push(["dialog gone: ok callbacks, hidden calls, bindings, menu stack depth, waiting round",
                ::__kb.ok, ::__kb.hidden, bindings(), ::Tactical.State.m.MenuStack.m.Stack.len() - ::__kb.depth0,
                ::Tactical.TurnSequenceBar.m.IsWaitingRound]);
            unwatch();
            while (::Tactical.State.m.MenuStack.hasBacksteps()) ::Tactical.State.m.MenuStack.pop();
        },
    ];
}

local function fresh(t) {
    ::__kb <- {t = t, animating = 0, shown = 0, hidden = 0, ok = 0, frames = 0, log = []};
}

// The pilot as the autoplay's player directly: t.battle wraps `player` in bbtest.nut's callWith, which needs an
// array.extend() that returns the array (3.0's returns null).
local function battle(t, p) {
    local w = t.battle({entities = ::APT.thugs(3), player = p.fn, maxFrames = 6000});
    ::__autoplayPlayer = p.fn;
    return w;
}

test("KB10 bind: DialogScreen.show called twice in one frame (as through an unguarded caller)", function (t) {
    ::APT.toughen();
    fresh(t);
    local p = ::APT.pilot({press = false, each = endBattle, before = steps(function () {
        local okCb = function () { ::__kb.ok++; };
        local hidden = function () { ::Tactical.State.m.MenuStack.pop(); };
        ::DialogScreen.show("Probe", "Shown twice", hidden, okCb, null);
        ::Tactical.State.m.MenuStack.push(function () { ::DialogScreen.hide(); }, function () { return !::DialogScreen.isAnimating(); });
        ::DialogScreen.show("Probe", "Shown twice", hidden, okCb, null);
    })});
    yield battle(t, p);
    foreach (row in ::__kb.log) t.probe("kb10", row);
});

test("KB10 bind: wait-all pressed twice, then Enter", function (t) {
    ::APT.toughen();
    fresh(t);
    local p = ::APT.pilot({press = false, each = endBattle, before = steps(function () {
        ::Tactical.TurnSequenceBar.onWaitTurnAllButtonPressed();
        ::Tactical.TurnSequenceBar.onWaitTurnAllButtonPressed();
        // the popup's OK is Autopilot's wait-all callback; count it through IsWaitingRound below
    })});
    yield battle(t, p);
    foreach (row in ::__kb.log) t.probe("kb10", row);
});
