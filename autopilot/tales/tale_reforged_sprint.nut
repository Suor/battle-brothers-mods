// mode: campaign seed=bbtest-battle fresh=1 launch=rsprint
// mods: mod_reforged==0.9.3 mod_autopilot_new@dev mod_ap_probe stdlib@dev
// include: lib/helpers.nut

// Reforged's Sprint used by a bro on AI, with an arming sword (4 AP a swing). One thug, put where the bro
// whose turn comes first walks up with AP left, but too few to swing, and sprints up with enough.

// Sprint saves 1 AP a tile, every tile costing 2 AP or more
local function sprintSwingTile(_e) {
    local from = _e.getTile(), seen = {}, ring = [from];
    seen[from.ID] <- true;
    for (local d = 1; d <= 5; d++) {
        local next = [];
        foreach (r in ring) foreach (n in ::std.Tile.iterAdjacent(r))
            if (!(n.ID in seen)) { seen[n.ID] <- true; next.push(n); }
        ring = next;
        if (d < 3) continue;
        foreach (t in ring) {
            if (!t.IsEmpty) continue;
            local cost = ::Autopilot.walkCost(_e, t, 1);
            if (cost == null || !cost.IsComplete) continue;
            local left = _e.getActionPoints() - cost.ActionPointsRequired;
            if (left >= 0 && left < 4 && left + cost.Tiles >= 4) return {tile = t, tiles = cost.Tiles};
        }
    }
    return null;
}
local function sprintBattle(_t, _opts = {}) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    local seen = _t.state.seen <- {};
    local p = ::APT.pilot({before = [function (_e, t) {
        t.state.seen.bro <- _e.getName();
        ::Tales.equip(_e, "scripts/items/weapons/arming_sword");
        _e.getSkills().add(::new("scripts/skills/actives/rf_sprint_skill"));
        _e.setFatigue(0);
        local spot = sprintSwingTile(_e);
        t.state.seen.tile <- spot.tile;
        t.state.seen.tiles <- spot.tiles;
        ::Tactical.getNavigator().teleport(::Tales.hostiles()[0], spot.tile, null, null, false);
        if ("noWalk" in _opts) ::APT.noWalk(_e);
    }, @(_e, t) ::Tales.hostiles()[0].getTile().ID == t.state.seen.tile.ID]});
    return _t.battle({entities = ::Tales.thugs(1), player = p.fn, maxFrames = 30000});
}
// Hit or miss
local function round1(_who) {
    return ::APProbe.uses.filter(@(_, u) u.who == _who && u.round == 1).map(@(u) u.what);
}

test("sprint: outscores the walk that reaches the thug, but not a swing", function (t) {
    yield sprintBattle(t);
    local bro = t.state.seen.bro;
    local scores = ::APT.autoBehaviors(bro)[0].scores;
    t.probe("first pick scores", scores);
    // Saved tiles alone give at most this much, the rest is engage's bonus for a swing after the move
    local ratio = scores.autopilot_move_engage / scores.ai_engage_melee;
    t.probe("sprint / walk", ratio);
    t.eq(ratio > 1.0 + t.state.seen.tiles / 9.0, true, "sprint scores a swing after the move");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

test("sprint: sprints up and swings the same turn", function (t) {
    yield sprintBattle(t, {noWalk = true});
    local bro = t.state.seen.bro;
    t.probe("round 1 picks", ::APT.autoBehaviors(bro).filter(@(_, b) b.round == 1).map(@(b) b.what));
    t.probe("round 1 skills", round1(bro));
    t.eq(round1(bro).slice(0, 2), ["actives.rf_sprint", "actives.slash"], "sprints, then swings");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});
