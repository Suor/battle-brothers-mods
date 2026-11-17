// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_reforged==0.9.3 mod_camps_and_artifacts@dev stdlib@dev
// include: lib/helpers.nut

// Reforged 0.9.3: KNOWN_BUGS KB1, KB2, KB3, KB6.

local function serialize(_item) {
    local out = ::MSU.Class.SerializationEmulator(::MSU.Class.MetaDataEmulator());
    _item.onSerialize(out);
    return out;
}

test("CA-KB1: an artifact fencing sword (-25% head) goes through MSU's serialization emulator", function (t) {
    local sword = ::new("scripts/items/weapons/artifact/artifact_fencing_sword");
    t.eq(sword.m.ChanceToHitHead, -25, "Reforged's fencing head chance");
    local err = null, out = null;
    try { out = serialize(sword); } catch (e) { err = e; }
    t.eq(err, null, "CA-KB1: onSerialize throws in writeU8");
    if (out == null) return;
    local copy = ::new("scripts/items/weapons/artifact/artifact_fencing_sword");
    copy.onDeserialize(::MSU.Class.DeserializationEmulator(::MSU.Class.MetaDataEmulator(), out.getData()));
    t.eq(::CAT.itemStats(copy), ::CAT.itemStats(sword), "round trip");
});

test("CA-KB1: every artifact goes through MSU's serialization emulator", function (t) {
    local bad = [];
    foreach (s in ::CAT.artifactScripts()) {
        local item = ::new(s);
        try { serialize(item); } catch (e) { bad.push(s + ": " + e); }
    }
    t.eq(bad, [], "CA-KB1: artifacts MSU can't serialize");
});

test("artifacts keep their rolled stats across a real save (Reforged)", function (t) {
    local stash = ::World.Assets.getStash();
    stash.resize(stash.getCapacity() + 100);
    local before = [];
    foreach (s in ::CAT.artifactScripts()) {
        local item = ::new(s);
        stash.add(item);
        before.push(::CAT.itemStats(item));
    }
    t.save("ca_rf_items");
    yield t.load("ca_rf_items");
    local after = [];
    foreach (st in before) {
        local i = ::CAT.findInStash(st.ID, st.Name);
        after.push(i == null ? null : ::CAT.itemStats(i));
    }
    t.eq(after, before, "stats after load");
});

// The artifact shield vs the named one of the same look, both under Reforged.
local ShieldPairs = [
    ["artifact_golden_round_shield", "named/named_golden_round_shield"],
    ["artifact_sipar_shield", "named/named_sipar_shield"],
    ["artifact_orc_heavy_shield", "named/named_orc_heavy_shield"],
];

test("CA-KB6: artifact shields are at least as durable as named ones under Reforged", function (t) {
    local got = [], want = [];
    foreach (p in ShieldPairs) {
        local art = ::new("scripts/items/shields/artifact/" + p[0]);
        local named = ::new("scripts/items/shields/" + p[1]);
        got.push([p[0], art.getConditionMax() >= named.getConditionMax()]);
        want.push([p[0], true]);
        t.log(p[0] + " " + art.getConditionMax() + " vs " + p[1] + " " + named.getConditionMax());
    }
    t.eq(got, want, "CA-KB6: artifact durability >= named");
});

// KB2: in the user logs only under Hardened (tale_hardened_bugs_ca.nut).
test("CA-KB2: city-state camp actions update without errors, also after a load", function (t) {
    local run = function () {
        local out = [];
        foreach (f in ::World.FactionManager.getFactions()) {
            if (f == null) continue;
            foreach (a in f.m.Deck) {
                if (a.getID() != "build_citystate_camp_action" && a.getID() != "build_noble_camp_action") continue;
                a.update(false);
                out.push(f.ClassName);
            }
        }
        return out;
    };
    local first = run();
    t.eq(first.filter(@(_, c) c == "city_state_faction").len(), 3, "city states with the action");
    t.save("ca_kb2");
    yield t.load("ca_kb2");
    t.eq(run(), first, "after load");
}, {needs = ["worldgen"]});

// KB3: battle maps sometimes generated as the arena floor entering a C&A location. One fight at
// each C&A location type on the map, 3 map seeds each; a broken map shows as a script error from the map's fill.
local CaTypes = ["location.noble_tower", "location.noble_barracks", "location.noble_stronghold",
    "location.citystate_tower", "location.citystate_barracks", "location.citystate_stronghold",
    "location.nomad_heretic", "location.undead_damned_city", "location.goblin_warrens",
    "location.bandit_usurper", "location.barbarian_sacred_grove", "location.orc_fortress"];

test("CA-KB3: fights at C&A locations get their own map, not the arena floor", function (t) {
    ::Tales.toughen();
    local byType = {};
    foreach (l in ::World.EntityManager.getLocations())
        if (CaTypes.find(l.getTypeID()) != null && !(l.getTypeID() in byType)) byType[l.getTypeID()] <- l;
    local types = [];  // not keys(): 3.0's tables lack it
    foreach (k, _ in byType) types.push(k);
    types.sort();
    t.probe("C&A location types on the map", types);
    local seen = [];
    foreach (typeID, camp in byType) for (local seed = 1; seed <= 3; seed++) {
        local loc = camp.getCombatLocation(), tmpl = t.state.tmpl <- [];
        local restore = ::Tales.tolerateRfAI();
        yield t.battle({entities = ::Tales.thugs(2), fight = false, terrain = "tactical.steppe",
            player = ::Tales.scripted([function (t) {
                local p = ::Tactical.State.m.StrategicProperties;
                t.state.tmpl.push(p.LocationTemplate.Template[0]);
            }, @() ::Tales.killAll()]),
            setup = function (_p) {
                _p.LocationTemplate = clone loc;
                _p.LocationTemplate.Template = clone loc.Template;
                _p.LocationTemplate.OwnedByFaction = camp.getFaction();
                _p.MapSeed = seed * 7919;
            }});
        restore();
        seen.push([typeID, tmpl, t.result.survivors.enemies]);
    }
    t.probe("fights", seen);
    t.eq(seen.filter(@(_, s) s[1].find("tactical.arena_floor") != null || s[2] != 0), [], "arena maps or lost fights");
});
