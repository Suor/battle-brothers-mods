// mode: campaign seed=bbtest-battle origin=scenario.raiders
// mods: mod_stupid_game@dev mod_hooks mod_msu stdlib@dev

test("raiders start at peace with the noble houses", function (t) {
    local rel = ::World.FactionManager.getFactionsOfType(::Const.FactionType.NobleHouse).map(@(f) f.getPlayerRelation());
    t.eq(rel, array(rel.len(), 50.0), "noble relations");
});
