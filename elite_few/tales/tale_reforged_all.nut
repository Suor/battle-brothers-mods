// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_reforged==0.9.3 mod_elite_few@dev stdlib@dev
// include: lib/helpers.nut

// EF-KB3: Reforged with selectMode "all" set before the campaign, the way the users had it:
// MSU's dummy player (made for nested tooltips) is rolled a master too.

beforeCampaign(function () {
    ::getModSetting("mod_elite_few", "selectMode").set("all");
});

test("EF-KB3: the campaign starts with selectMode all and the dummy player is no master", function (t) {
    t.eq(t.roster().map(::EFT.isMaster), [true, true, true], "starting bros are masters");
    local dummy = ::MSU.getDummyPlayer();
    t.ok(dummy != null, "dummy player made");
    t.eq(::EFT.isMaster(dummy), false, "dummy player is a master");
    // a perk tooltip goes through the dummy player
    local perk = ::Const.Perks.LookupMap["perk.rf_vigorous_assault"];
    t.ok(perk != null, "a Reforged perk");
});

test("selectMode all under Reforged: a recruit is a master with 4 talents", function (t) {
    local bro = ::Tales.recruit();
    t.eq([::EFT.isMaster(bro), ::Tales.talentCount(bro)], [true, 4], "master, talents");
});
