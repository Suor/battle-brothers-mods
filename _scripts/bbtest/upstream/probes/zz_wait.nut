// mode: menu
// Not a probe: holds bbtest's launch open for the probes' scheduled events (1.5 s of real time).
test("wait", function (t) {
    ::__probeEnd <- ::Time.getRealTimeF() + 1.5;  // not a local: see generator_outer.nut
    yield t.until(@() ::Time.getRealTimeF() >= ::__probeEnd, 100000);
});
