// mode: campaign
// mods: mod_vap stdlib@dev
// Is VAP's mods_hookNewObject patch on a player made by roster.create (BBT.recruit) and by ::new?
test("patched", function (t) {
    local a = ::BBT.recruit();
    t.probe("roster.create: addExtraPerks", "addExtraPerks" in a);
    local b = ::new("scripts/entity/tactical/player");
    t.probe("::new: addExtraPerks", "addExtraPerks" in b);
    a.m.XP = ::Const.LevelXP[15];
    a.updateLevel();
    t.probe("level, perk points at 16", [a.m.Level, a.m.PerkPoints]);
});
