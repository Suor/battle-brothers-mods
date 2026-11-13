// mode: menu
// DialogScreen.show twice in one frame at the main menu, with Autopilot: does the game go on?
// mods: mod_autopilot_new mod_modern_hooks mod_msu
::__ds <- {anim = 0, shown = 0};
{
    local d = ::DialogScreen, a = d.onScreenAnimating, s = d.onScreenShown;
    d.onScreenAnimating = function () { ::__ds.anim++; a.call(this); };
    d.onScreenShown = function () { ::__ds.shown++; s.call(this); };
}
test("double show", function (t) {
    ::DialogScreen.show("Probe", "Shown twice", null);
    t.probe("after the 1st show [visible, animating, animating calls, shown calls]", [::DialogScreen.isVisible(), ::DialogScreen.isAnimating(), ::__ds.anim, ::__ds.shown]);
    ::DialogScreen.show("Probe", "Shown twice", null);
    t.probe("after the 2nd show", [::DialogScreen.isVisible(), ::DialogScreen.isAnimating(), ::__ds.anim, ::__ds.shown]);
    yield t.frames(120);
    t.probe("120 frames later", [::DialogScreen.isVisible(), ::DialogScreen.isAnimating(), ::__ds.anim, ::__ds.shown]);
});
