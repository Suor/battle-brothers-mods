// mode: campaign
// mods: mod_msu stdlib@dev
test("battle", function (t) {
    foreach (bro in t.roster()) { bro.getBaseProperties().Hitpoints += 300; bro.getSkills().update(); bro.setHitpoints(bro.getHitpointsMax()); }
    yield t.battle({spawn = "BanditRaiders", resources = 60});
    t.ok(t.result.result != null);
});
