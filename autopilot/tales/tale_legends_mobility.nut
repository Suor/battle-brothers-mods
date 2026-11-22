// mode: campaign seed=bbtest-battle fresh=1 launch=lmob
// mods: mod_legends==19.4.23 mod_autopilot_new@dev mod_ap_probe stdlib@dev
// include: lib/helpers.nut

// Legends' Quick Step (perk Fast) and Leap (perk Juggler) used by bros on AI. One thug, put off the bro
// whose turn comes first; that bro gets the skill and an arming sword (4 AP a swing) or a greatsword.

local function did(_who, _what) {
    return ::APT.autoUses(_who).filter(@(_, u) u.what == _what).len() > 0;
}
// An empty tile _dist off _from, whose way to _from is open
local function tileOff(_from, _dist) {
    local seen = {}, ring = [_from];
    seen[_from.ID] <- true;
    for (local d = 1; d <= _dist; d++) {
        local next = [];
        foreach (r in ring) foreach (n in ::std.Tile.iterAdjacent(r))
            if (!(n.ID in seen) && n.IsEmpty && n.getDistanceTo(_from) == d) { seen[n.ID] <- true; next.push(n); }
        ring = next;
    }
    return ring.len() > 0 ? ring[0] : null;
}
// A tile for the thug: walking up leaves too few AP for a greatsword swing (6 AP), a quick step to start
// with leaves enough
local function stepSwingTile(_e) {
    local from = _e.getTile(), seen = {}, ring = [from];
    seen[from.ID] <- true;
    for (local d = 1; d <= 5; d++) {
        local next = [];
        foreach (r in ring) foreach (n in ::std.Tile.iterAdjacent(r))
            if (!(n.ID in seen)) { seen[n.ID] <- true; next.push(n); }
        ring = next;
        if (d < 2) continue;
        foreach (t in ring) {
            if (!t.IsEmpty) continue;
            local cost = ::Autopilot.walkCost(_e, t, 1);
            if (cost == null || !cost.IsComplete) continue;
            local left = _e.getActionPoints() - cost.ActionPointsRequired;
            local saved = _e.getActionPointCosts()[cost.First.Type] - 1;
            if (left >= 0 && left < 6 && left + saved >= 6) return {tile = t, saved = saved};
        }
    }
    return null;
}
local function mobilityBattle(_t, _skill, _dist, _opts = {}) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    local seen = _t.state.seen <- {};
    local weapon = "weapon" in _opts ? _opts.weapon : "arming_sword";
    local lame = "lame" in _opts && _opts.lame;
    local p = ::APT.pilot({before = [function (_e, t) {
        local seen = t.state.seen;
        seen.bro <- _e.getName();
        ::Tales.equip(_e, "scripts/items/weapons/" + weapon);
        local skill = ::new("scripts/skills/actives/" + _skill);
        _e.getSkills().add(skill);
        seen.skill <- skill.getID();
        _e.setFatigue(0);
        local tile;
        if (_dist == null) {
            local spot = stepSwingTile(_e);
            tile = spot.tile;
            seen.saved <- spot.saved;
        } else tile = tileOff(_e.getTile(), _dist);
        seen.tile <- tile;
        ::Tactical.getNavigator().teleport(::Tales.hostiles()[0], tile, null, null, false);
        if ("noWalk" in _opts) ::APT.noWalk(_e);
        // Bros pass through allies, so it's slow legs that keep him from walking up: 11 AP a tile
        if (lame) foreach (i in ["broken_leg_injury", "cut_achilles_tendon_injury", "burnt_legs_injury",
                "bruised_leg_injury", "sprained_ankle_injury", "injured_knee_cap_injury"])
            _e.getSkills().add(::new("scripts/skills/injury/" + i));
    }, @(_e, t) ::Tales.hostiles()[0].getTile().ID == t.state.seen.tile.ID],
        // Where the leap lands, as the first leap planned
        each = function (_st, t) {
            local seen = t.state.seen;
            if ("landing" in seen || !("bro" in seen)) return;
            local bro = ::Tales.byName(seen.bro), b = bro.getAIAgent().getBehavior(::Const.AI.Behavior.ID.AP_Leap);
            if (b == null || b.m.TargetTile == null) return;
            local tile = b.m.TargetTile, thug = ::Tales.hostiles()[0], skill = bro.getSkills().getSkillByID(seen.skill);
            local nextToThug = ::std.Tile.listAdjacent(thug.getTile()).filter(@(_, x) skill.isUsableOn(x)).len();
            seen.landing <- {thug = tile.getDistanceTo(thug.getTile()), nextToThug = nextToThug,
                zocs = tile.getZoneOfControlCountOtherThan(bro.getAlliedFactions())};
        }});
    return _t.battle({entities = ::Tales.thugs(1), player = p.fn, maxFrames = 30000});
}
local function round1(_who) {
    return ::APT.autoUses(_who).filter(@(_, u) u.round == 1).map(@(u) u.what);
}

test("quick step: outscores the walk when the step buys a greatsword swing", function (t) {
    yield mobilityBattle(t, "legend_quick_step_skill", null, {weapon = "greatsword"});
    local seen = t.state.seen;
    t.eq(seen.skill, "actives.legend_quick_step", "skill ID");
    local scores = ::APT.autoBehaviors(seen.bro)[0].scores;
    t.probe("first pick scores", scores);
    // Saved AP alone give at most this much, the rest is engage's bonus for a swing after the move
    local ratio = scores.autopilot_move_engage / scores.ai_engage_melee;
    t.probe("step / walk", ratio);
    t.eq(ratio > 1.0 + seen.saved / 9.0, true, "the step scores a swing after the move");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

test("quick step: steps, walks up and swings the same turn", function (t) {
    yield mobilityBattle(t, "legend_quick_step_skill", null, {weapon = "greatsword", noWalk = true});
    local bro = t.state.seen.bro;
    // Hit or miss
    local used = ::APProbe.uses.filter(@(_, u) u.who == bro && u.round == 1).map(@(u) u.what);
    t.probe("round 1 skills", used);
    t.eq(used.slice(0, 2), ["actives.legend_quick_step", "actives.overhead_strike"], "steps, then swings");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

test("leap: the only way to a lame bro's thug", function (t) {
    yield mobilityBattle(t, "legend_leap_skill", 3, {lame = true});
    local seen = t.state.seen;
    t.eq(seen.skill, "actives.legend_leap", "skill ID");
    local first = ::APT.autoBehaviors(seen.bro)[0];
    t.probe("first pick scores", first.scores);
    t.eq(first.what, "autopilot_leap", "leaps");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

// Lame, 3 tiles off: the leap could land next to the thug or 2 off him, out of his zone of control
test("leap: a pike bro lands at reach, out of the zone of control", function (t) {
    yield mobilityBattle(t, "legend_leap_skill", 3, {lame = true, weapon = "pike"});
    local seen = t.state.seen;
    t.probe("first pick scores", ::APT.autoBehaviors(seen.bro)[0].scores);
    t.eq([seen.landing.thug, seen.landing.zocs, seen.landing.nextToThug > 0], [2, 0, true],
         "landed 2 off, though a tile next to him was in reach");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});

test("leap: walks when the thug is in walking reach", function (t) {
    yield mobilityBattle(t, "legend_leap_skill", 3);
    local seen = t.state.seen;
    t.probe("round 1", round1(seen.bro));
    t.eq(did(seen.bro, "actives.legend_leap"), false, "no leap");
    t.eq(t.result.survivors.enemies, 0, "company wins");
});
