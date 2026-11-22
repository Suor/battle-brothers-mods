// mode: campaign seed=bbtest-battle fresh=1 launch=tcc
// mods: mod_legends==19.4.23 time_crossing_commando mod_autopilot_new@dev mod_ap_probe stdlib@dev
// include: lib/helpers.nut

// Time-Crossing Commando: its sniper rifle's shots and reload, used by a bro on AI.

local function rifleBattle(_t, _loaded) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    local place = 18;
    foreach (bro in _t.roster()) if (bro.getName() != "Bertel") bro.setPlaceInFormation(place++);
    local bertel = ::Tales.byName("Bertel");
    ::Tales.equip(bertel, "scripts/items/weapons/sniper_rifle");
    ::Tales.equip(bertel, "scripts/items/ammo/sniper_rifle_ammo");
    if (!_loaded) bertel.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand).setAmmo(0);
    local p = _t.state.p <- ::APT.pilot();
    return _t.battle({entities = ::Tales.thugs(2), player = p.fn, maxFrames = 30000});
}

test("a bro with the sniper rifle shoots", function (t) {
    yield rifleBattle(t, true);
    local uses = ::Tales.uniq(::APT.autoUses("Bertel").map(@(u) u.what), true);
    t.probe("Bertel's uses", uses);
    t.eq(uses.filter(@(_, u) u.find("actives.sniper_rifle_") == 0 && u != "actives.sniper_rifle_reload").len() > 0,
         true, "a rifle shot");
    t.eq(t.state.p.st.stuck, [], "no stuck turn");
});

test("an empty magazine: the bro reloads it", function (t) {
    yield rifleBattle(t, false);
    local uses = ::APT.autoUses("Bertel").map(@(u) u.what);
    t.probe("Bertel's uses", uses);
    local rifle = ::Tales.byName("Bertel").getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
    t.eq([uses.find("actives.sniper_rifle_reload") != null, rifle.getAmmo() > 0], [true, true], "reloaded, loaded");
    t.eq(t.state.p.st.stuck, [], "no stuck turn");
});
