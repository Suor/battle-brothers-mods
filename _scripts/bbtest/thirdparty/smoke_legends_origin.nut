// mode: campaign seed=bbtest-battle origin=scenario.legends_noble fresh=1
// mods: mod_legends==19.4.23 stdlib@dev
// include: lib/tp_smoke.nut

::TPSmoke.register(test, ["mod_legends"]);

test("Legends company", function (t) {
    t.eq(::World.Assets.getOrigin().getID(), "scenario.legends_noble", "origin");
    local bgs = [];
    foreach (bro in t.roster()) bgs.push(bro.getBackground().getID());
    t.probe("backgrounds", bgs);
    t.probe("perk tree rows", t.roster()[0].getBackground().getPerkTree().len());
});
