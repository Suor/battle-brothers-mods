// mode: campaign
// mods: mod_legends==19.4.23 stdlib@dev
test("campaign", function (t) { t.eq(t.roster().len() > 0, true); });
