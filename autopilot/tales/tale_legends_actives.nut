// mode: campaign seed=bbtest-battle fresh=1 launch=lact
// mods: mod_legends==19.4.23 mod_autopilot_new@dev mod_ap_probe stdlib@dev
// include: lib/helpers.nut

// Legends' actives used by bros on AI: Root and the backup throws of one-handed weapons.

local function did(_who, _what) {
    return ::APT.autoUses(_who).filter(@(_, u) u.what == _what).len() > 0;
}
local function aiBattle(_t, _p, _n = 3) {
    return _t.battle({entities = ::Tales.thugs(_n), player = _p.fn, maxFrames = 30000});
}
// An empty tile _dist off _from with nobody next to it, so a throw there risks no ally
local function tileOff(_from, _dist) {
    local seen = {}, ring = [_from];
    seen[_from.ID] <- true;
    for (local d = 1; d <= _dist; d++) {
        local next = [];
        foreach (r in ring) foreach (n in ::std.Tile.iterAdjacent(r))
            if (!(n.ID in seen)) { seen[n.ID] <- true; next.push(n); }
        ring = next;
    }
    foreach (tile in ring)
        if (tile.IsEmpty && tile.getDistanceTo(_from) == _dist && ::std.Tile.listAdjacentActors(tile).len() == 0)
            return tile;
    return null;
}

test("root: a bro with the Roots perk roots a foe", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    local seen = t.state.seen <- {};
    local p = ::APT.pilot({before = function (_e, t) {
        t.state.seen.bro <- _e.getName();
        _e.getSkills().add(::new("scripts/skills/perks/perk_legend_roots"));
        t.state.seen.granted <- _e.getSkills().hasSkill("actives.legend_root");
    }});
    yield aiBattle(t, p);
    t.probe("bro", seen.bro);
    t.probe("rounds", ::APT.autoUses(seen.bro).filter(@(_, u) u.what == "actives.legend_root").map(@(u) u.round));
    t.eq([seen.granted, did(seen.bro, "actives.legend_root")], [true, true], "granted and used");
    t.eq(p.st.stuck, [], "no stuck turn");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

// The bro whose turn comes first, rooted for the battle with a one-handed weapon, one thug put 3 tiles off: out of
// reach, in the backup throw's, so on his first turn he either throws or idles. The thug is killed after round 2.
local function backupBattle(_t, _weapon, _on) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    ::APT.setting("throwBackup", _on);
    local seen = _t.state.seen <- {};
    local p = _t.state.p <- ::APT.pilot({
        before = [function (_e, t) {
            t.state.seen.bro <- _e.getName();
            ::Tales.equip(_e, "scripts/items/weapons/" + _weapon);
            _e.getSkills().add(::new("scripts/skills/effects/rooted_effect"));
            local tile = t.state.seen.tile <- tileOff(_e.getTile(), 3);
            ::Tactical.getNavigator().teleport(::Tales.hostiles()[0], tile, null, null, false);
        }, @(_e, t) ::Tales.hostiles()[0].getTile().ID == t.state.seen.tile.ID],
        each = function (_st, t) {
            if (::Time.getRound() > 2 && !("killed" in t.state.seen)) {
                t.state.seen.killed <- true;
                ::Tales.killAll();
            }
        }});
    return aiBattle(_t, p, 1);
}
foreach (c in [["hand_axe", "actives.throw_axe"], ["militia_spear", "actives.throw_javelin"],
               ["dagger", "actives.legend_throw_knife"]]) {
    local weapon = c[0], id = c[1];
    test("backup throws on: a " + weapon + " is thrown at a foe out of reach", function (t) {
        yield backupBattle(t, weapon, true);
        local bro = t.state.seen.bro;
        local round1 = ::APT.autoUses(bro).filter(@(_, u) u.round == 1).map(@(u) u.what);
        t.probe("round 1", round1);
        t.eq(round1.slice(0, 1), [id], "throws first");
        t.eq(t.state.p.st.stuck, [], "no stuck turn");
    });
    test("backup throws off: a " + weapon + " is never thrown", function (t) {
        yield backupBattle(t, weapon, false);
        ::APT.resetSettings();
        local bro = t.state.seen.bro;
        t.probe("uses", ::APT.autoUses(bro).map(@(u) u.round + " " + u.what));
        t.eq(did(bro, id), false, "not thrown");
        t.eq(t.state.p.st.stuck, [], "no stuck turn");
    });
}
