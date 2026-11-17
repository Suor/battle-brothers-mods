// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_renamer@dev mod_msu stdlib@dev

local hire = function (_bg) {
    local bro = ::World.getPlayerRoster().create("scripts/entity/tactical/player");
    bro.setStartValuesEx([_bg]);
    bro.m.__titleBefore <- bro.getTitle();
    bro.onHired();
    return bro;
};

test("hired bros get numbered titles by background, the fallen counted", function (t) {
    local a = hire("farmhand_background"), b = hire("farmhand_background");
    local k = hire("hedge_knight_background");
    t.eq([a.getTitle(), b.getTitle(), k.getTitle()], ["Farmer I", "Farmer II", "Knight I"], "titles");
    t.eq(a.getFlags().get("renamer_initialTitle"), a.m.__titleBefore, "the old title is kept in a flag");

    // as vanilla events record a death (cultist_finale_event)
    ::World.Statistics.addFallen({Name = b.getName(), Time = 1, TimeWithCompany = 1, Kills = 0, Battles = 0,
        KilledBy = "Testing", Expendable = false});
    ::World.getPlayerRoster().remove(b);
    t.eq(hire("farmhand_background").getTitle(), "Farmer III", "after II fell");

    local i = 0;
    while (i++ < 7) hire("farmhand_background");
    t.eq(hire("farmhand_background").getTitle(), "Farmer XI", "roman past ten");
});
