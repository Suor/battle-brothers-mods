// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_reforged==0.9.3 mod_necro@dev mod_hooks stdlib@dev
// allow-errors: ImagePath coui://gfx/necro/perk_mastery.png already set by mod

// Necro under Reforged: its perks go through Dynamic Perks as the pg.necro group.

test("NE1: no necro perk shares its icon with the pg.necro perk group", function (t) {
    local group = ::DynamicPerks.PerkGroups.findById("pg.necro");
    local clash = [];
    foreach (perk in ::Const.Perks.Necro) if (perk.Icon == group.getIcon()) clash.push(perk.ID);
    t.eq(group.getIcon(), "necro/perk_mastery.png", "group icon");
    // MSU's nested tooltips key image keywords by path: the second one is dropped with an error
    t.eq(clash, [], "perks with the group's icon");
});

test("NE2: Possess perk keeps its enabled icon", function (t) {
    local perk = ::new("scripts/skills/perks/perk_necro_possess");
    t.eq([perk.m.Icon, perk.m.IconDisabled],
        [::Const.Perks.LookupMap["perk.necro.possess"].Icon, ::Const.Perks.LookupMap["perk.necro.possess"].IconDisabled],
        "[Icon, IconDisabled]");
});

test("necro background gets the pg.necro tree", function (t) {
    local bro = ::World.getPlayerRoster().create("scripts/entity/tactical/player");
    bro.setStartValuesEx(["necro_background"]);
    local tree = bro.getPerkTree();
    local ids = [];
    foreach (perk in ::Const.Perks.Necro) ids.push(tree.hasPerk(perk.ID));
    t.eq(ids, ::Const.Perks.Necro.map(@(_) true), "every necro perk is in the tree");
    t.eq(bro.getSkills().hasSkill("actives.raise_undead"), true, "can raise");
    ::World.getPlayerRoster().remove(bro);
});
