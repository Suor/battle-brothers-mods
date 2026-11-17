// mode: campaign seed=bbtest-battle fresh=1 launch=discordcp
// mods: mod_crock_pot==0.10.6 mod_camps_and_artifacts@dev stdlib@dev
// include: lib/helpers.nut

// KNOWN_BUGS.md #2 extended: Darxo blames Crock Pot, whose southern villages are
// factions typed OrientalCityState (cp_southern_settlement_faction, not a city_state_faction).

// [faction class, action id, error or null] for every C&A camp action, updated once.
local function updateCampActions() {
    local out = [];
    foreach (f in ::World.FactionManager.getFactions()) {
        if (f == null) continue;
        foreach (a in f.m.Deck) {
            if (a.getID() != "build_citystate_camp_action" && a.getID() != "build_noble_camp_action") continue;
            local err = null;
            try { a.update(false); } catch (e) { err = e; }
            out.push([f.ClassName, a.getID(), err]);
        }
    }
    return out;
}

test("CA-KB2: with Crock Pot, C&A camp actions update without errors, also after a load", function (t) {
    local villages = ::World.FactionManager.getFactions().filter(@(_, f) f != null && f.ClassName == "cp_southern_settlement_faction");
    t.probe("Crock Pot southern village factions", villages.len());
    local first = updateCampActions();
    t.probe("classes with a city-state camp action", ::Tales.uniq(first.filter(@(_, r) r[1] == "build_citystate_camp_action").map(@(r) r[0])));
    t.eq(first.filter(@(_, r) r[2] != null), [], "CA-KB2: errors on a new campaign");
    t.save("ca_kb2_cp");
    yield t.load("ca_kb2_cp");
    local after = updateCampActions();
    t.eq(after.filter(@(_, r) r[2] != null), [], "CA-KB2: errors after a load");
    yield t.days(2, {quiet = true});
});

// Crock Pot's village faction overrides addTrait to skip the city-state actions (file dated 2025-12-12, after
// Darxo's 2025-12-08 repro); without that override the faction gets C&A's action, as vanilla addTrait gives it.
test("CA-KB2 mechanism: C&A's city-state camp action on a Crock Pot village faction throws the users' error", function (t) {
    local f = ::World.FactionManager.getFactions().filter(@(_, f) f != null && f.ClassName == "cp_southern_settlement_faction")[0];
    local a = ::new("scripts/factions/actions/build_citystate_camp_action");
    a.setFaction(f);
    local err = null;
    try { a.update(true); } catch (e) { err = e; }
    t.eq(err, "the index 'ca_getCamps' does not exist", "error");
}, {needs = ["worldgen"]});
