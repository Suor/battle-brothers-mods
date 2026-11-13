// bbtest's driver in the original game (bbtest.py --env game): what engine/bbtest.rs does, from inside the game.
// Packed by bbtest.py as scripts/!mods_preload/zzz_bbtest_runner.nut of the launch's runner zip, next to bbtest/
// (the launch's config _launch.nut, the scripts to load at the main menu). A real-time event every millisecond
// fires once a frame in every state (menu, world, battle): one runner step each. Results are log rows, read from
// log.html; markers start with BBTEST_RUNNER (bbtest.py turns them into the engine's RUNNER lines).
::include("bbtest/_launch");

::BBTestRunner.Phase <- "boot";
::BBTestRunner.Frames <- 0;     // frames of the current phase
::BBTestRunner.TestFrames <- 0;
::BBTestRunner.Inside <- null;  // what the last step was running: still set at the next one when it raised
::BBTestRunner.Loaded <- false;  // the scripts are, the autoplay with them: it runs every frame from then on
::BBTestRunner.PhaseStart <- 0.0;  // real time the current phase began

// Silent even where a sound device is reachable (launch.sh hides them).
foreach (ch in ::Const.Sound.Channel) ::Settings.setSoundVolume(ch, 0.0);
// Watched on the user's display (BBGAME_SHOW): a window, not fullscreen; not saved to the prefix's config.
if (::BBTestRunner.Show) {
    local vm = ::Settings.getVideoMode();
    vm.Fullscreen = false;
    vm.Borderless = false;
    ::Settings.setVideoMode(vm);
}

::BBTestRunner.say <- function (_s) {
    ::logInfo("BBTEST_RUNNER " + _s);
}

::BBTestRunner.mark <- function (_what) {
    ::BBTestRunner.say("TIME " + _what + " " + ::Time.getRealTimeF());
}

::BBTestRunner.inWorld <- function () {
    return ("State" in ::World) && ::World.State != null && ::World.State.getPlayer() != null && !::LoadingScreen.isVisible();
}

::BBTestRunner.menu <- function () {
    return ("RootState" in ::getroottable()) ? ::RootState.get("MainMenuState") : null;
}

// Quit as the main menu's Quit does; the log is complete only after a clean shutdown. With a campaign the world
// state is finished first: finishing the main menu alone doesn't end the game then.
::BBTestRunner.quit <- function (_code) {
    ::BBTestRunner.say("EXIT " + _code);
    ::BBTestRunner.Phase = "done";
    // A battle left running (a test timed out in it) keeps the game up, logging errors, once the world is gone.
    if (::BBTest.inBattle()) ::Tactical.State.finish();
    if (("State" in ::World) && ::World.State != null) ::World.State.finish();
    ::BBTestRunner.menu().finish();
}

::BBTestRunner.stop <- function (_why) {
    ::BBTestRunner.say("STOPPED " + _why);
    ::BBTestRunner.quit(2);
}

::BBTestRunner.loadScripts <- function () {
    foreach (s in ::BBTestRunner.Scripts) {
        try {
            ::include(s);
        } catch (e) {
            ::BBTestRunner.say("SCRIPT_FAILED " + s + ": " + e);
        }
    }
}

::BBTestRunner.step <- function () {
    local r = ::BBTestRunner;
    r.Frames++;
    switch (r.Phase) {
        case "boot":
            if (r.Frames == 1) r.mark("boot");
            local mm = r.menu();
            if (mm == null || mm.m.MainMenuScreen == null || !mm.m.MainMenuScreen.isVisible() || mm.m.MainMenuScreen.isAnimating())
                return;
            r.Phase = "menu";
            r.Frames = 0;
            // No mouse moves over the headless window: the world's hover tooltip needs a position.
            ::Cursor.setPosition(640, 360);
            return;
        case "menu":
            if (r.Frames < 30) return;
            r.mark("menu");
            r.loadScripts();
            r.Loaded = true;
            if (r.Mode != "campaign") return r.startTests();
            ::BBTest.runBeforeCampaign();
            r.Frames = 0;
            r.PhaseStart = ::Time.getRealTimeF();
            if (r.Load != null) {
                // A snapshot (bbtest.py --snapshot): the campaign a launch with the same seed, origin and mods saved.
                ::RootState.get("MainMenuState").campaign_menu_module_onLoadPressed(r.Load);
                r.Phase = "starting";
                return;
            }
            ::BBTest.newCampaign();
            r.Phase = "new";
            return;
        case "new":
            r.mark("start");
            ::BBTest.startCampaign(r.Seed, r.Origin);
            r.Phase = "starting";
            return;
        case "starting":
            if (r.inWorld()) {
                r.mark("world");
                r.Phase = "intro";
                r.Frames = 0;
                r.PhaseStart = ::Time.getRealTimeF();
                if (r.Load != null) r.campaignStarted();  // a save has no intro event
                return;
            }
            if (("MSU" in ::getroottable()) && ::MSU.SettingsScreen.isVisible()) ::MSU.SettingsScreen.onSaveButtonPressed({});
            if (::Time.getRealTimeF() - r.PhaseStart > 120) r.stop("the campaign didn't start in 120 s");
            return;
        case "intro":
            // Past the origin's intro event (shown 1 s of real time in), answered by the autoplay.
            local since = ::Time.getRealTimeF() - r.PhaseStart;
            if (since < 1.5 || (::World.State.getEventScreen().isVisible() && since < 10)) return;
            return r.campaignStarted();
        case "tests":
            if (::BBTest.Finished) {
                r.mark("done");
                r.say("FRAMES " + r.TestFrames);
                return r.quit(0);
            }
            if (r.TestFrames++ >= r.MaxFrames) return r.stop("not finished after " + r.TestFrames + " frames");
            r.holdTimeout();
            r.Inside = "tick";
            ::BBTest.tick();
            r.Inside = null;
            return;
    }
}

// Frames run uncapped (vblank off in session.sh), so the virtual clock is sped up by the frame rate over 60: a frame
// advances it as much as at 60 fps, as in the engine, and battles and world days take as many frames as there.
// Speeds the scripts set and read stay theirs; the natives get them times the factor, re-applied every frame.
// During the tests the virtual clock is also set every frame to what the engine's reads: 1/60 s times the speed a
// frame, from where the scripts last set it (the jitter of the frames' real time would decide faction and AI delays).
::BBTestRunner.Clock <- {k = 1.0, last = null, dt = null, speed = ::Time.getVirtualSpeed(), world = ::World.getSpeedMult(), viaWorld = null,
    exact = false, v0 = null, n = 0, baseSpeed = 0.0};
{
    local setV = ::Time.setVirtualSpeed, setW = ::World.setSpeedMult, setT = ::Time.setVirtualTime, c = ::BBTestRunner.Clock;
    ::Time.setVirtualTime = function (_t) { c.v0 = _t.tofloat(); c.n = 0; setT.call(::Time, _t); };
    c.nativeSpeed <- ::Time.getVirtualSpeed;
    ::Time.setVirtualSpeed = function (_v) { c.speed = _v; c.viaWorld = false; setV.call(::Time, _v * c.k); };
    ::Time.getVirtualSpeed = @() c.speed;
    ::World.setSpeedMult = function (_v) { c.speed = c.world = _v; c.viaWorld = true; setW.call(::World, _v * c.k); };
    ::World.getSpeedMult = @() c.world;
    c.tick <- function () {
        local now = ::Time.getRealTimeF();
        // A frame's time is known only once it's over: the factor is from recent frames' average, so jitter evens out.
        if (c.last != null && now > c.last) {
            c.dt = c.dt == null ? now - c.last : c.dt * 0.9 + (now - c.last) * 0.1;
            c.k = ::Math.minf(16.0, ::Math.maxf(1.0, 1.0 / (60.0 * c.dt)));
            // The frame under way already has its real time: its own factor, should the natives move by it.
            if (c.exact) c.k = ::Math.minf(32.0, ::Math.maxf(0.1, 1.0 / (60.0 * (now - c.last))));
        }
        c.last = now;
        if (c.exact) {
            if (c.v0 == null || c.speed != c.baseSpeed) {
                c.v0 = c.v0 == null ? ::Time.getVirtualTimeF() : c.v0 + c.n * c.baseSpeed / 60.0;
                c.n = 0;
                c.baseSpeed = c.speed;
            }
            c.n++;
            setT.call(::Time, c.v0 + c.n * c.baseSpeed / 60.0);
        }
        if (c.viaWorld == true) setW.call(::World, c.world * c.k);
        else if (c.viaWorld == false) setV.call(::Time, c.speed * c.k);
    };
}

// A wait's frame budget assumes 60 frames a second; frames are faster here, so it lasts at least that in real time too.
::BBTestRunner.holdTimeout <- function () {
    local c = ::BBTest.Current;
    if (c == null || c.wait == null) return;
    local w = c.wait;
    if (!("__since" in w)) w.__since <- ::Time.getRealTimeF();
    if (w.frames + 1 >= w.max && ::Time.getRealTimeF() - w.__since < w.max / 60.0) w.frames = w.max - 2;
}

::BBTestRunner.campaignStarted <- function () {
    local r = ::BBTestRunner;
    r.mark("campaign");
    ::World.State.setPause(true);
    if (r.Snapshot != null) ::World.State.saveCampaign(r.Snapshot);
    ::BBTest.onCampaignStarted();
    r.startTests();
}

::BBTestRunner.startTests <- function () {
    ::BBTestRunner.Clock.exact = true;
    ::BBTest.start();
    ::BBTestRunner.Phase = "tests";
}

::BBTestRunner.frame <- function (_) {
    // The next frame's step is scheduled first: an error in this one must not stop the runner.
    ::Time.scheduleEvent(::TimeUnit.Real, 1, ::BBTestRunner.frame, null);
    local r = ::BBTestRunner;
    if (r.Phase == "done") return;
    r.Clock.tick();
    // The world ignores a load within 4 s of real time after the last one: frames are too fast for the waits on it.
    if (r.inWorld() && "CampaignLoadTime" in ::World.State.m) ::World.State.m.CampaignLoadTime = -100.0;
    if (r.Inside != null) {
        local what = r.Inside;
        r.Inside = null;
        if (what == "tick") ::BBTest.tickFailed("an uncaught script error (above)");
        else return r.stop("the " + what + " step raised (the script error above)");
    }
    if (r.Loaded) {
        r.Inside = "autoplay";
        ::__autoplay();
        r.Inside = null;
    }
    r.step();
}

::Time.scheduleEvent(::TimeUnit.Real, 1, ::BBTestRunner.frame, null);

// The world's load and reset and a battle's end clear every scheduled event: the runner's is scheduled again.
{
    local clear = ::Time.clearEvents;
    ::Time.clearEvents = function () {
        clear.call(::Time);
        ::Time.scheduleEvent(::TimeUnit.Real, 1, ::BBTestRunner.frame, null);
    };
}
