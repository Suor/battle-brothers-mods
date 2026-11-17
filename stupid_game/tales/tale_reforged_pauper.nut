// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_reforged==0.9.3 mod_stupid_game@dev mod_hooks stdlib@dev

test("cheap backgrounds get Reforged's pauper perk group", function (t) {
    local got = {};
    foreach (bg in ["beggar_background", "farmhand_background", "hedge_knight_background"]) {
        local bro = ::World.getPlayerRoster().create("scripts/entity/tactical/player");
        bro.setStartValuesEx([bg]);
        got[bg] <- [bro.getBackground().m.DailyCost <= 10, bro.getPerkTree().hasPerkGroup("pg.rf_pauper")];
        ::World.getPlayerRoster().remove(bro);
    }
    t.eq(got, {beggar_background = [true, true], farmhand_background = [false, false],
        hedge_knight_background = [false, false]}, "[cheap, has pauper]");
    t.eq(::Const.Perks.findById("perk.rf_discovered_talent").verifyPrerequisites(t.roster()[0], []), true,
         "Discovered Talent has no prerequisites");
});
