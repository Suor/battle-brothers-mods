// mode: campaign
// mods: mod_msu stdlib@dev
test("campaign", function (t) { t.eq(t.roster().len() > 0, true); });
