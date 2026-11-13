// mode: menu
// mods: mod_modern_hooks
// A lambda reading the enclosing varargs function's `vargv` (Elite Few 2.5.0's wrap(): `@() concat_call(_func, [self], vargv)`).
test("lambda reads outer vargv", function (t) {
    local f = function (...) { local g = @() vargv; return g(); };
    t.probe("outer vargv via lambda", f(1, 2));
    local k = function (...) { local self = this; local c = {s = @() [self].extend(vargv)}; return c.s(); };
    t.probe("as in Elite Few (extend result)", k(1, 2));
    local h = function (...) { local g = @(...) vargv; return g(3); };
    t.probe("own vargv", h(1, 2));
});
