// mode: campaign fresh=1
// mods: mod_modern_hooks mod_msu
// A roster of its own for recruits, in tests separated by fresh=1 reloads (--env game hung on ::BBT.recruit's
// fixed id 9999 in the second such test). Here: one fixed id, as BBT.recruit had.
::__rr <- {next = 9000};
local function recruit() {
    local roster = null;
    try { roster = ::World.getRoster(9999); } catch (e) {}
    if (roster == null) roster = ::World.createRoster(9999);
    local bro = roster.create("scripts/entity/tactical/player");
    bro.setStartValuesEx(["farmhand_background"]);
    return bro;
}
test("first", function (t) { t.ok(recruit() != null); });
test("second, after a reload", function (t) { t.ok(recruit() != null); });
test("third, after a reload", function (t) { t.ok(recruit() != null); });
