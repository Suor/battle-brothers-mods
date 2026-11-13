// mode: campaign seed=bbtest-battle
// mods: mod_msu stdlib@dev

// Sturdier company, so the result doesn't hinge on the roll. The AI flees on low morale,
// hence the resolve.
::BBTest.toughen <- function () {
    foreach (bro in ::World.getPlayerRoster().getAll()) {
        local b = bro.getBaseProperties();
        b.Hitpoints += 300; b.MeleeDefense += 30; b.MeleeSkill += 30; b.Bravery += 200;
        bro.getSkills().update();
        bro.setHitpoints(bro.getHitpointsMax());
    }
}

test("bandits, AI plays both sides", function (t) {
    ::BBTest.toughen()
    local before = t.roster().len();
    yield t.battle({spawn = "BanditRaiders", resources = 60});
    t.probe("result", t.result.result);
    t.eq(t.result.survivors.enemies, 0, "company wins");
    t.eq(t.roster().len(), before, "nobody died");
    t.ok(!::BBTest.inBattle() && ::World.State.isVisible(), "back on the world map");
    t.probe("battle frames", t.result.frames);
});

test("explicit entities", function (t) {
    ::BBTest.toughen();
    local thug = {ID = ::Const.EntityType.BanditThug, Variant = 0, Row = 0,
                  Script = "scripts/entity/tactical/enemies/bandit_thug"};
    yield t.battle({entities = [thug, clone thug], terrain = "tactical.steppe"});
    t.probe("result", t.result);
    t.eq(t.result.survivors.enemies, 0, "both thugs dead");
});

test("scripted player plays the company", function (t) {
    ::BBTest.toughen();
    ::__botPrefer = [];
    yield t.battle({spawn = "BanditRaiders", resources = 40, player = ::__botTick});
    t.probe("result", t.result);
    t.eq(t.result.survivors.enemies, 0, "company wins");
});
