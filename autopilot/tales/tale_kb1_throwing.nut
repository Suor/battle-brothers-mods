// mode: campaign seed=bbtest-battle fresh=1 launch=kb1
// mods: mod_autopilot_new@dev mod_ap_probe stdlib@dev
// include: lib/helpers.nut

// KNOWN_BUGS #1 in a launch of its own: a stuck AI turn runs its battle to maxFrames.

test("KB1: empty quiver and a throwing weapon in the bag: the archer's AI turn ends", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    ::APT.emptyQuiverArcher(["scripts/items/weapons/throwing_axe"]);
    local p = ::APT.pilot();
    yield t.battle({entities = ::Tales.thugs(3), player = p.fn, maxFrames = 30000});
    t.eq(p.st.stuck, [], "no stuck turn");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});
