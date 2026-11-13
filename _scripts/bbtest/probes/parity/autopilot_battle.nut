// mode: campaign seed=bbtest-parity
// mods: mod_autopilot_new stdlib@dev
// include: ../../../../autopilot/scenarios/lib/helpers.nut

// Autopilot New plays the company (its AI button), the AI the bandits.
test("bandits", function (t) {
    ::BBT.toughen();
    yield t.battle({spawn = "BanditRaiders", resources = 60, player = ::APT.pilot().fn});
    t.probe("result", t.result);
});
