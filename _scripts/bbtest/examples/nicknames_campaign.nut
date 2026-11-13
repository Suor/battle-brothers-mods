// mode: campaign seed=bbtest-nick
// mods: mod_nicknames==0.8.0 mod_msu stdlib@dev

beforeCampaign(function () {
    ::BBTest.Campaign.companyName <- "Nickname Probe";
});

test("roster names", function (t) {
    t.ok(::Hooks.hasMod("mod_nicknames"), "nicknames registered");
    local names = [];
    foreach (bro in t.roster()) names.push(bro.getName() + " | " + bro.getTitle());
    t.probe("roster", names);
    t.eq(names.len(), 3, "early access company size");
    t.probe("company", ::World.Assets.getName());
});

test("a day passes", function (t) {
    local day = ::World.getTime().Days;
    yield t.days(1);
    t.eq(::World.getTime().Days, day + 1);
});

test("uncaught error is reported with stack", function (t) {
    local x = null;
    t.log("about to fail");
    x.boom();
});
