// mode: campaign fresh=1
// mods: mod_modern_hooks mod_msu
// A roster of its own for recruits, in tests separated by fresh=1 reloads (--env game hung on ::BBT.recruit's
// fixed id 9999 in the second such test). Here each call takes a new id.
::__rr <- {next = 9000};
local function recruit() {
    local id = ::__rr.next++;
    local roster = ::World.createRoster(id);
    local bro = roster.create("scripts/entity/tactical/player");
    bro.setStartValuesEx(["farmhand_background"]);
    return bro;
}
test("first", function (t) { t.ok(recruit() != null); });
test("second, after a reload", function (t) { t.ok(recruit() != null); });
test("third, after a reload", function (t) { t.ok(recruit() != null); });
