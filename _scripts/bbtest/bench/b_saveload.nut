// mode: campaign
// mods: mod_msu stdlib@dev
test("saveload", function (t) { t.save("b"); yield t.load("b"); t.ok(t.roster().len() > 0); });
