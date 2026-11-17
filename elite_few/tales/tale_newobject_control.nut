// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_hooks mod_msu stdlib@dev

// Control for EF1 without Elite Few: a mods_hookNewObject wrapper of player_party.updateStrength,
// as Elite Few makes it, counted per call before and after loads.

::EFControl <- {Calls = 0, Hooked = 0};
::mods_hookNewObject("entity/world/player_party", function (o) {
    ::EFControl.Hooked++;
    local orig = o.updateStrength;
    o.updateStrength = function (...) {
        ::EFControl.Calls++;
        local args = [this];
        args.extend(vargv);  // a statement: 3.0's extend() returns null
        return orig.acall(args);
    };
});

test("a mods_hookNewObject wrapper runs once per call across loads", function (t) {
    local count = function () {
        ::EFControl.Calls = 0;
        ::World.State.getPlayer().updateStrength();
        return ::EFControl.Calls;
    };
    local calls = [count()];
    t.save("efc");
    yield t.load("efc");
    calls.push(count());
    yield t.load("efc");
    calls.push(count());
    t.probe("hook fired", ::EFControl.Hooked);
    t.eq(calls, [1, 1, 1], "wrapper calls per updateStrength");
});
