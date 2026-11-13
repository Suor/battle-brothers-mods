// mode: campaign
// mods: mod_modern_hooks mod_msu
// How long the original takes to load a campaign save (--env game): a snapshot's cost against worldgen's.
test("load time", function (t) {
    t.save("bbtest_probe");
    ::__lt <- {r0 = ::Time.getRealTimeF()};
    yield t.frames(1);
    local r1 = ::Time.getRealTimeF();
    ::World.State.campaign_menu_module_onLoadPressed("bbtest_probe");
    yield t.until(@() ::BBTest.inWorld() && !::LoadingScreen.isVisible() && ::World.State.m.CampaignToLoadFileName == null, 6000);
    t.log("load took " + (::Time.getRealTimeF() - r1) + " s");
});
