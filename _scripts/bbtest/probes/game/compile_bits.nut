// mode: menu
// mods: mod_modern_hooks
// Which construct of autopilot legends_bugs.nut:32 Squirrel 3.0 rejects.
test("bits", function (t) {
    local cases = [
        "local f = function (_st, t) { if (1) { if (1) { t.state.seen.k <- 1; } return; } };",
        "local f = function (_st, t) { if (1) { if (1) { seen.k <- 1; } return; } };",
        "local f = function (_st, t) { if (\"error\" in t.state.seen) { return; } };",
        "local f = function (_st, t) { t.state.seen.k <- 1; };",
        "local f = function (_st, t) { if (!(\"k\" in t.state.seen)) { t.state.seen.k <- 1; } };",
        "local f = function (_st) { if (!(\"k\" in seen)) { seen.k <- 1; } };",
    ];
    foreach (i, c in cases) {
        try { ::compilestring(c); t.probe("case " + i, "ok"); } catch (e) { t.probe("case " + i, e); }
    }
});
