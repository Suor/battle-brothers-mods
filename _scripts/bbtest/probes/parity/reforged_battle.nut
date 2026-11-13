// mode: campaign seed=bbtest-parity
// mods: mod_reforged==0.9.3 stdlib@dev

test("bandits", function (t) {
    ::BBT.toughen();
    yield t.battle({spawn = "BanditRaiders", resources = 60});
    t.probe("result", t.result);
});
