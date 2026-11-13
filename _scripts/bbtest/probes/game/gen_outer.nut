// mode: menu
// mods: mod_modern_hooks
// A closure made inside a test (a generator) reading the test's local: before and after the test yields.
test("closure in a generator", function (t) {
    local x = 5;
    local f = function () { return x; };
    local before = f();
    yield t.frames(1);
    t.probe("before yield, after yield", [before, f()]);
});
test("closure in a plain test", function (t) {
    local x = 5;
    local f = function () { return x; };
    t.probe("plain", f());
});
test("array extend returns", function (t) {
    t.probe("typeof [1].extend([2])", typeof [1].extend([2]));
    t.probe("typeof [1].push(2)", typeof [1].push(2));
});
