// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_reforged==0.9.3 mod_hackflows_perks@dev mod_hooks stdlib@dev

// Hackflow's Perks under Reforged 0.9.3: perks in Reforged's perk groups, Promised Potential
// replaced by the graded one.

test("HP1: perks are added to Reforged's perk groups", function (t) {
    local groups = ["pg.rf_soldier", "pg.rf_militia", "pg.rf_pauper", "pg.rf_vigorous", "pg.rf_agile", "pg.rf_power",
                    "pg.rf_medium_armor", "pg.rf_heavy_armor", "pg.rf_large"];
    t.eq(groups.filter(@(_, g) ::DynamicPerks.PerkGroups.findById(g) == null), [], "groups the mod targets that Reforged lacks");
    local find = function (_group, _perk) {
        local g = ::DynamicPerks.PerkGroups.findById(_group);
        return g != null && g.hasPerk(_perk);
    };
    t.eq([find("pg.rf_soldier", "perk.hackflows.flesh_on_the_bones"), find("pg.rf_agile", "perk.hackflows.balance"),
          find("pg.rf_power", "perk.hackflows.full_force"), find("pg.rf_large", "perk.hackflows.full_force")],
        [true, true, true, true], "[soldier FotB, agile balance, power FF, large FF]");
});

test("Promised Potential grows at level 5 and survives a save", function (t) {
    local bro = ::World.getPlayerRoster().create("scripts/entity/tactical/player");
    bro.setStartValuesEx(["beggar_background"]);
    bro.m.PerkPoints = 1;
    bro.unlockPerk("perk.rf_promised_potential");
    yield t.frames(20);  // the perk syncs its level 200 ms after it's added
    local ids = function () {
        local out = [];
        foreach (sk in bro.getSkills().getAllSkillsOfType(::Const.SkillType.Perk))
            if (sk.getID().find("potential") != null) out.push(sk.getID());
        foreach (sk in bro.getSkills().m.Skills)
            if (sk.isHidden() && sk.getID().find("potential") != null) out.push(sk.getID());
        return out;
    };
    t.eq(ids(), ["perk.hackflows.potential_0"], "replaced on unlock");
    local pot = bro.getSkills().getSkillByID("perk.hackflows.potential_0");
    local will = pot.m.WillSucceed;
    bro.m.XP = ::Const.LevelXP[4];
    bro.updateLevel();
    local expected = will ? "perk.hackflows.potential_1" : "perk.hackflows.potential_0_fail";
    t.probe("will succeed", will);
    t.eq([bro.getLevel(), ids()], [5, [expected]], "[level, perk] after level 5");
    t.eq(bro.getPerkTree().hasPerk(expected), true, "the tree shows the new stage");
    local id = bro.getID();
    t.save("potential");
    yield t.load("potential");
    local loaded = null;
    foreach (b in t.roster()) if (b.getName() == bro.getName()) loaded = b;
    t.eq(loaded.getSkills().getSkillByID(expected) != null, true, "stage kept after load");
});
