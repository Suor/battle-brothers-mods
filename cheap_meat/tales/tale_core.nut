// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_cheap_meat@dev mod_msu stdlib@dev

// Cheap Meat: hires cost 50% (33% with the Recruiter), tryouts 50% (25%), through a town's hire
// dialog and across a load.

local function mults() {
    local a = ::World.Assets.m;
    return [a.HiringCostMult, a.TryoutPriceMult, a.RosterSizeAdditionalMin, a.RosterSizeAdditionalMax];
}

test("hires and tryouts at half price, a hire through the town pays it", function (t) {
    t.eq(mults(), [0.5, 0.5, 0, 0], "[hire, tryout, roster+min, roster+max]");
    local town = ::Tales.townWith("building.crowd");
    town.updateRoster(true);
    local screen = ::Tales.visit(town, "building.crowd");
    local entry = ::World.getRoster(town.getID()).getAll()[0];
    local tryout = entry.getTryoutCost();
    local cost = entry.getHiringCost();
    ::World.Assets.addMoney(10000);
    local money = ::World.Assets.getMoney();
    t.eq(screen.getHireDialogModule().onHireRosterEntry(entry.getID()).Result, 0, "hired");
    t.eq(money - ::World.Assets.getMoney(), ::Math.ceil(cost * 0.5), "paid half of " + cost);
    t.eq(tryout, ::Math.ceil(::Math.max(10, ::Math.min(cost - 25, 25 + cost * 0.1) * 0.5)), "tryout");
    screen.getHireDialogModule().onLeaveButtonPressed();
    ::World.State.getTownScreen().onModuleClosed();
    yield t.frames(10);
});

test("the Recruiter: 33% hires, 25% tryouts, +3..6 recruits; kept by a load", function (t) {
    local recruiter = ::World.Retinue.getFollower("follower.recruiter");
    ::World.Retinue.setFollower(0, recruiter);
    local want = [0.5 * 0.667, 0.25, 3, 6];
    local got = mults();
    t.near(got[0], want[0], 0.0001, "hire mult");
    t.eq(got.slice(1), want.slice(1), "[tryout, roster+min, roster+max]");
    t.eq(recruiter.m.Effects, ["Makes you pay 33% less up front for hiring new men, and 50% less for tryouts",
        "Makes between 3 and 6 additional men available to recruit in every settlement"], "effects text");
    t.save("cm_recruiter");
    yield t.load("cm_recruiter");
    got = mults();
    t.near(got[0], want[0], 0.0001, "hire mult after load");
    t.eq(got.slice(1), want.slice(1), "[tryout, roster+min, roster+max] after load");
});
