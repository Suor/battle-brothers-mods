// mode: campaign
// mods: mod_reforged==0.9.3 stdlib@dev
test("campaign", function (t) { t.eq(t.roster().len() > 0, true); });
