// mode: campaign
// mods: mod_modern_hooks mod_msu
// The original's frame rate on the world map and in a battle under its video settings (--env game).
// Ends in ERROR on purpose: the battle is left running when its wait times out (the runner's quit then).
local settings = [[true, false, 60], [false, false, 60], [false, true, 1000], [false, false, 1000]];
local apply = function (_s) {
    local vm = ::Settings.getVideoMode();
    vm.VSync = _s[0];
    vm.LimitFrameRate = _s[1];
    vm.RefreshRate = _s[2];
    ::Settings.setVideoMode(vm);
};
local meter = function (t, _where) {
    local st = {i = -1, f0 = 0, r0 = 0.0};
    return function () {
        local now = ::Time.getRealTimeF();
        if (st.i >= 0 && now - st.r0 < 3.0) return false;
        if (st.i >= 0) {
            local vm = ::Settings.getVideoMode();
            t.log(_where + ": " + ((::Time.getFrame() - st.f0) / (now - st.r0)) + " fps, set " + ::BBTest.repr(settings[st.i])
                + ", reads VSync " + vm.VSync + " LimitFrameRate " + vm.LimitFrameRate + " RefreshRate " + vm.RefreshRate
                + ", clock k " + ::BBTestRunner.Clock.k + ", world mult " + ::World.getSpeedMult());
        }
        if (++st.i >= settings.len()) return true;
        apply(settings[st.i]);
        st.f0 = ::Time.getFrame();
        st.r0 = ::Time.getRealTimeF();
        return false;
    };
};
test("limiter", function (t) {
    ::World.State.setPause(false);
    local v0 = ::Time.getVirtualTimeF(), r0 = ::Time.getRealTimeF(), f0 = ::Time.getFrame();
    yield t.until(meter(t, "world"), 100000);
    t.log("world: virtual " + (::Time.getVirtualTimeF() - v0) + " s in real " + (::Time.getRealTimeF() - r0) + " s, frames " + (::Time.getFrame() - f0));
    ::World.State.setPause(true);
    ::__lim <- {m = meter(t, "battle"), done = false};
    yield t.battle({spawn = "BanditRaiders", resources = 60, maxFrames = 100000, player = function () {
        if (!::__lim.done) ::__lim.done = ::__lim.m();
        if (::__lim.done) throw "measured";
    }});
});
