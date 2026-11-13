// mode: campaign
// mods: mod_modern_hooks mod_msu
test("campaign", function (t) { t.eq(t.roster().len() > 0, true); });
