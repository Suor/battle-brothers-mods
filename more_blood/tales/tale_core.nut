// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_events_delayed_fix==0.7 mod_more_blood@dev mod_msu stdlib@dev

test("actors and splatters bleed twice as much", function (t) {
    local m = t.roster()[0].m;
    t.eq([m.DecapitateBloodAmount, m.DeathBloodAmount, m.BloodPoolScale], [2.0, 2.0, 1.5], "actor blood");
    local s = ::Const.Tactical.BloodSplatters[1][0];
    t.eq([s.Quantity, s.LifeTimeQuantity, s.SpawnRate], [40, 40, 160], "red splatter (vanilla 20, 20, 80)");
});

// The preload binds `local mod = ::EventsFix <- {...}` (copied from events_delayed_fix): with
// both installed it replaces that mod's root table.
test("MB1: More Blood leaves ::EventsFix to Events Delayed Fix", function (t) {
    t.eq(::EventsFix.ID, "mod_events_delayed_fix", "::EventsFix.ID");
});
