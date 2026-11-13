// mode: campaign seed=bbtest-parity
// mods: mod_msu stdlib@dev

test("bandits", function (t) {
    ::BBT.toughen();
    yield t.battle({spawn = "BanditRaiders", resources = 60});
    t.probe("result", t.result);
});

test("direwolves in a forest", function (t) {
    ::BBT.toughen();
    yield t.battle({spawn = "Direwolves", resources = 60, faction = "Beasts", terrain = "tactical.forest"});
    t.probe("result", t.result);
});
