// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_hooks mod_msu stdlib@dev

test("baseline: events fired in 20 days", function (t) {
    local start = ::Time.getVirtualTimeF();
    yield t.days(20, {quiet = true, speed = 16.0});
    // event.fire() sets CooldownUntil = now + Cooldown: those set past the start fired since
    local fired = ::World.Events.m.Events.filter(@(_, e) e.m.CooldownUntil > start).map(@(e) e.getID());
    fired.sort();
    t.probe("fired", fired);
    t.ok(fired.len() > 0, "some event fired");
});
