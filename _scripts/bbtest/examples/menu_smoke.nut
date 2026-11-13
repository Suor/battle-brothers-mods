// mode: menu
// mods: mod_msu stdlib@dev

test("frameworks loaded", function (t) {
    t.ok(::Hooks.hasMod("mod_modern_hooks"), "Modern Hooks registered");
    t.ok(::Hooks.hasMod("mod_msu"), "MSU registered");
    t.ok(::Hooks.hasMod("stdlib"), "stdlib registered");
    t.probe("menu visible", ::RootState.get("MainMenuState").m.MainMenuScreen.isVisible());
    t.probe("rand 1..100", ::Math.rand(1, 100));
});

test("asserts report, not abort", function (t) {
    t.eq([1, 2, {a = 3}], [1, 2, {a = 4}], "deliberate failure");
    t.eq(1 + 1, 2);
});

test("generator waits frames", function (t) {
    local before = ::Time.getRealTime();
    yield t.frames(10);
    t.ok(::Time.getRealTime() > before, "real time advanced");
});
