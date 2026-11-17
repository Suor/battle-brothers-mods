// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_hardened==1.26.3 mod_camps_and_artifacts@dev stdlib@dev
// include: lib/helpers.nut

// KNOWN_BUGS.md #2: `the index 'ca_getCamps' does not exist` at
// build_citystate_camp_action.nut:12, seen with Reforged + Hardened (+ Crock Pot per Darxo). Real Hardened 1.26.3 on Reforged 0.9.3.

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

local function citystateClasses(_rows) {
    local out = [];
    foreach (r in _rows) if (r[1] == "build_citystate_camp_action" && out.find(r[0]) == null) out.push(r[0]);
    return out;
}

test("CA-KB2: C&A camp actions update without errors, also after a load and days", function (t) {
    local first = updateCampActions();
    t.probe("classes with a city-state camp action", citystateClasses(first));
    t.eq(first.filter(@(_, r) r[2] != null), [], "CA-KB2: errors on a new campaign");
    t.save("ca_kb2_hd");
    yield t.load("ca_kb2_hd");
    local after = updateCampActions();
    t.probe("classes after load", citystateClasses(after));
    t.eq(after.filter(@(_, r) r[2] != null), [], "CA-KB2: errors after a load");
    local restore = ::Tales.tolerateRfAI();
    yield t.days(3, {quiet = true});
    restore();
});
