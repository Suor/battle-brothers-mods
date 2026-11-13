// mode: campaign
// mods: mod_modern_hooks mod_msu
// How the world's speed mult and the tactical virtual speed relate in the original (--env game).
test("speeds", function (t) {
    t.log("world paused: mult " + ::World.getSpeedMult() + " vspeed " + ::Time.getVirtualSpeed());
    local v0 = ::Time.getVirtualTimeF(), r0 = ::Time.getRealTimeF();
    yield t.days(0.05);
    t.log("days: mult " + ::World.getSpeedMult() + " vspeed " + ::Time.getVirtualSpeed() + " virtual " + (::Time.getVirtualTimeF() - v0)
        + " real " + (::Time.getRealTimeF() - r0));
    ::World.setSpeedMult(3.0);
    t.log("after setSpeedMult(3): mult " + ::World.getSpeedMult() + " vspeed " + ::Time.getVirtualSpeed());
    ::Time.setVirtualSpeed(2.0);
    t.log("after setVirtualSpeed(2): mult " + ::World.getSpeedMult() + " vspeed " + ::Time.getVirtualSpeed());
    ::World.setSpeedMult(0.0);
    ::Time.setVirtualSpeed(1.0);
    foreach (bro in t.roster()) { bro.getBaseProperties().Hitpoints += 300; bro.getSkills().update(); bro.setHitpoints(bro.getHitpointsMax()); }
    local f0 = ::Time.getFrame();
    r0 = ::Time.getRealTimeF();
    v0 = ::Time.getVirtualTimeF();
    yield t.battle({spawn = "BanditRaiders", resources = 60});
    t.log("battle: " + ::BBTest.repr(t.result) + " frames " + (::Time.getFrame() - f0) + " real " + (::Time.getRealTimeF() - r0)
        + " virtual " + (::Time.getVirtualTimeF() - v0) + " fps " + ::Time.getFPS());
});
