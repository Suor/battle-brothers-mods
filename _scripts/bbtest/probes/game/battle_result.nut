// mode: campaign
// mods: mod_modern_hooks mod_msu
// bench/b_battle.nut's battle, its outcome logged: how it ends per env.
test("battle", function (t) {
    foreach (bro in t.roster()) { bro.getBaseProperties().Hitpoints += 300; bro.getSkills().update(); bro.setHitpoints(bro.getHitpointsMax()); }
    yield t.battle({spawn = "BanditRaiders", resources = 60});
    t.log("result " + ::BBTest.repr(t.result));
});
