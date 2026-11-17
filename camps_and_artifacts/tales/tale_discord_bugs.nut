// mode: campaign seed=bbtest-battle fresh=1 launch=discord
// mods: mod_camps_and_artifacts@dev stdlib@dev
// include: lib/helpers.nut

// KNOWN_BUGS.md: "Discord deep search" entries (KB3 extended).

local CaLocations = ["bandit_usurper", "barbarian_sacred_grove", "citystate_barracks", "citystate_stronghold",
    "citystate_tower", "goblin_warrens", "noble_barracks", "noble_stronghold", "noble_tower", "nomad_heretic",
    "undead_damned_city"];

local function templates(_names) {
    local out = {};
    foreach (n in _names)
        out[n] <- ::new("scripts/entity/world/locations/" + n + "_location").getCombatLocation().Template[0];
    return out;
}

// What vanilla arena_contract's "Start" option does to the global (a shallow clone of LocationTemplate).
local function arenaFight() {
    local p = ::Const.Tactical.CombatInfo.getClone();
    p.LocationTemplate = clone ::Const.Tactical.LocationTemplate;
    p.LocationTemplate.Template[0] = "tactical.arena_floor";
}

test("CA-KB3: C&A locations keep their template arrays to themselves", function (t) {
    local global = ::Const.Tactical.LocationTemplate.Template;
    local shared = [];
    foreach (n in CaLocations)
        if (::new("scripts/entity/world/locations/" + n + "_location").getCombatLocation().Template == global) shared.push(n);
    t.eq(shared, [], "locations sharing the global Template array");
    t.eq(global, [null, null], "the global Template after creating every C&A location");
});

test("CA-KB3: after an arena fight C&A locations don't get the arena floor", function (t) {
    arenaFight();
    t.probe("global Template after an arena fight", ::Const.Tactical.LocationTemplate.Template);
    t.probe("vanilla locations without a template", templates(["undead_monolith", "abandoned_fortress", "battlefield"]));
    local got = templates(CaLocations);
    ::Const.Tactical.LocationTemplate.Template[0] = null;
    local floored = [];  // not filter()/keys(): 3.0's tables lack them
    foreach (k, v in got) if (v == "tactical.arena_floor") floored.push(k);
    floored.sort();
    t.eq(floored, [], "CA-KB3: C&A locations with the arena floor");
});

test("CA-KB3: after an arena fight and a reload, a goblin warrens fight gets its own map", function (t) {
    arenaFight();
    t.save("ca_kb3_arena");
    yield t.load("ca_kb3_arena");
    local camp = ::new("scripts/entity/world/locations/goblin_warrens_location");
    local loc = camp.getCombatLocation();
    ::Const.Tactical.LocationTemplate.Template[0] = null;
    t.probe("goblin warrens template after the load", loc.Template);
    t.state.loc <- loc;
    ::Tales.toughen();
    local errors = [], spectators = t.state.spectators <- [];
    local restore = ::Tales.catchErrors(errors);
    foreach (terrain in ["tactical.forest", "tactical.steppe", "tactical.hills"]) for (local seed = 1; seed <= 2; seed++) {
        t.state.terrain <- terrain; t.state.seed <- seed;
        yield t.battle({entities = ::Tales.thugs(2), fight = false, terrain = terrain,
            player = ::Tales.scripted([function (t) {
                local n = 0;
                for (local x = 0; x < 32; x++) for (local y = 0; y < 32; y++) {
                    local e = ::Tactical.getTileSquare(x, y).getEntity();
                    if (e != null && e.ClassName == "arena_spectator") n++;
                }
                t.state.spectators.push([t.state.terrain, t.state.seed, n]);
            }, @() ::Tales.killAll()]),
            setup = function (_p) {
                _p.LocationTemplate = clone this.loc;
                _p.LocationTemplate.Template = clone this.loc.Template;
                _p.MapSeed = this.seed * 7919;
            }.bindenv(t.state)});
    }
    restore();
    t.probe("script errors", errors);
    t.eq(spectators.filter(@(_, s) s[2] > 0), [], "CA-KB3: fights on the arena floor (arena spectators on the map)");
});
