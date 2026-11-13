// mode: campaign
// mods: mod_msu stdlib@dev
test("day", function (t) { local d = ::World.getTime().Days; yield t.days(1); t.eq(::World.getTime().Days, d + 1); });
