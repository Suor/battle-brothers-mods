// mode: campaign
// mods: mod_modern_hooks mod_msu
// Closures made in a test (a generator) see its locals as null in the original: state in ::__fps.
// The original's frame rate through an AI battle, every 2 s of real time (--env game).
test("battle fps", function (t) {
    foreach (bro in t.roster()) { bro.getBaseProperties().Hitpoints += 300; bro.getSkills().update(); bro.setHitpoints(bro.getHitpointsMax()); }
    t.log("hp " + ::BBTest.repr(t.roster().map(@(b) b.getHitpoints())));
    ::__fps <- {f0 = ::Time.getFrame(), r0 = ::Time.getRealTimeF(), v0 = ::Time.getVirtualTimeF(), t = t};
    ::__fps.ap <- ::__autoplay;
    ::__autoplay = function () {
        ::__fps.ap();
        local s = ::__fps, now = ::Time.getRealTimeF();
        if (now - s.r0 < 2.0) return;
        local e = ::BBTest.inBattle() ? ::Tactical.TurnSequenceBar.getActiveEntity() : null;
        local c = "Clock" in ::BBTestRunner ? ::BBTestRunner.Clock : {k = 0, speed = 0, nativeSpeed = ::Time.getVirtualSpeed, viaWorld = null};
        s.t.log(format("%.0f fps, virtual/frame %.4f, virtual/real %.2f, k %.2f, speed %.2f, native %.2f, via world %s, active %s",
            (::Time.getFrame() - s.f0) / (now - s.r0),
            (::Time.getVirtualTimeF() - s.v0) / ::Math.max(1, ::Time.getFrame() - s.f0), (::Time.getVirtualTimeF() - s.v0) / (now - s.r0),
            c.k, c.speed, c.nativeSpeed.call(::Time), "" + c.viaWorld,
            e == null ? "-" : e.getName() + " faction " + e.getFaction()));
        s.f0 = ::Time.getFrame(); s.r0 = now; s.v0 = ::Time.getVirtualTimeF();
    };
    yield t.battle({spawn = "BanditRaiders", resources = 60});
    ::__autoplay = ::__fps.ap;
    t.log("result " + ::BBTest.repr(t.result));
});
