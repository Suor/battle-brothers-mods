// mode: campaign
// mods: mod_msu stdlib@dev
test("days", function (t) { local d = ::World.getTime().Days; yield t.days(5); t.eq(::World.getTime().Days, d + 5); });
