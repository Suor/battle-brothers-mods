// mode: menu
// mods: mod_nicknames mod_msu stdlib@dev

// N7 in the VM that runs the scenarios (the original's Squirrel 3.0.4 with --env game): does getstackinfos()
// give each script frame's `this` in `locals`, as inEvent() needs, and what does a call cost?
// inEvent() is a local of the mod's preload file: this is a verbatim copy of it.
local function inEvent() {
    for (local i = 2, info = null; (info = ::getstackinfos(i)) != null; i++) {
        local self = "this" in info.locals ? info.locals["this"] : null;
        if (typeof self == "table" && (::isKindOf(self, "event") || ::isKindOf(self, "contract")
                || ::isKindOf(self, "encounter")))
            return true;
    }
    return false;
}

test("N7 probe: frames' locals have this", function (t) {
    local frames = [];
    local obj = {Name = "obj"};
    obj.walk <- function () {
        for (local i = 1, info = null; (info = ::getstackinfos(i)) != null; i++) {
            local self = "this" in info.locals ? info.locals["this"] : null;
            frames.push(info.func + " this=" + (self == null ? "none" : typeof self + ("Name" in self ? ":" + self.Name : "")));
        }
    };
    obj.walk();
    t.probe("frames", frames);
    t.eq(frames[0], "unknown this=table:obj", "the method's frame: this is the object");

    local ev = ::new("scripts/events/events/adopt_wardog_event");
    ev.bbtalesProbe <- function () {
        local r = inEvent();
        return r;
    };
    t.eq(ev.bbtalesProbe(), true, "inEvent() under an event's method");
    t.eq(inEvent(), false, "inEvent() outside events");
});

// µs a call of inEvent() at stack depth ~30 (nothing on the stack is an event: the walk goes to the bottom),
// against a control loop calling an empty function. Rounds alternate the two; times by the game's live clock.
test("N7 bench: inEvent() at depth 30", function (t) {
    local n = 200000;
    local b = {Frames = 0};
    b.deep <- function (_depth, _fn, _n) {
        // Not `return this.deep(...)`: a tail call would reuse the frame.
        if (_depth > 0) {
            local r = this.deep(_depth - 1, _fn, _n);
            return r;
        }
        local t0 = ::Time.getExactTime();
        for (local i = 0; i < _n; i++) _fn();
        return ::Time.getExactTime() - t0;
    };
    b.deep(28, function () {
        for (local i = 0; ::getstackinfos(i) != null; i++) b.Frames = i;
    }, 1);
    t.probe("stack depth at the calls", b.Frames);
    local empty = function () { return false; };
    for (local round = 0; round < 3; round++) {
        local control = b.deep(28, empty, n), calls = b.deep(28, inEvent, n);
        t.probe("round " + round + " us/call", {inEvent = calls * 1e6 / n, control = control * 1e6 / n,
            net = (calls - control) * 1e6 / n});
    }
});
