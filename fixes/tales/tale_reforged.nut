// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_reforged==0.9.3 mod_fixes@dev mod_hooks stdlib@dev

// Reforged's bigger shields brought back to their vanilla condition.
test("reforged: shields keep vanilla condition", function (t) {
    local got = {};
    foreach (s in ["heater_shield", "kite_shield", "wooden_shield", "faction_heater_shield", "faction_kite_shield", "faction_wooden_shield"]) {
        local sh = ::new("scripts/items/shields/" + s);
        got[s] <- [sh.getCondition(), sh.getConditionMax()];
    }
    t.eq(got, {heater_shield = [32, 32], kite_shield = [48, 48], wooden_shield = [24, 24],
        faction_heater_shield = [32, 32], faction_kite_shield = [48, 48], faction_wooden_shield = [24, 24]}, "conditions");
});
