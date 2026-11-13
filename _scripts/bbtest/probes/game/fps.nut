// mode: menu
// mods: mod_modern_hooks
// The original's frame rate and video settings, then with VSync and the frame limiter off (--env game).
test("fps", function (t) {
    local vm = ::Settings.getVideoMode();
    t.log("video " + ::BBTest.repr({VSync = vm.VSync, LimitFrameRate = vm.LimitFrameRate, RefreshRate = vm.RefreshRate,
        W = vm.Width, H = vm.Height, Fullscreen = vm.Fullscreen, Borderless = vm.Borderless}));
    local gs = ::Settings.getGameplaySettings();
    t.log("gameplay " + ::BBTest.repr({FasterAIMovement = gs.FasterAIMovement, FasterPlayerMovement = gs.FasterPlayerMovement,
        AlwaysFocusCamera = gs.AlwaysFocusCamera}));
    local t0 = ::Time.getRealTimeF();
    yield t.frames(120);
    t.log("default: 120 frames in " + (::Time.getRealTimeF() - t0) + " s, getFPS " + ::Time.getFPS());
    vm.VSync = false;
    vm.LimitFrameRate = false;
    ::Settings.setVideoMode(vm);
    yield t.frames(30);
    t0 = ::Time.getRealTimeF();
    yield t.frames(600);
    t.log("no vsync/limit: 600 frames in " + (::Time.getRealTimeF() - t0) + " s, getFPS " + ::Time.getFPS());
    vm = ::Settings.getVideoMode();
    t.log("video now " + ::BBTest.repr({VSync = vm.VSync, LimitFrameRate = vm.LimitFrameRate}));
});
