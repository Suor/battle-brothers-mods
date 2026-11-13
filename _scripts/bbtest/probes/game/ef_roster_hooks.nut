// mode: campaign
// mods: mod_elite_few mod_hooks stdlib@dev
// Which roster paths run Elite Few's mods_hookNewObject("entity/tactical/player") (its master's 4th talent):
// a roster from World.createRoster, the same roster through World.getRoster, the player roster.
beforeCampaign(function () {
    ::getModSetting("mod_elite_few", "selectMode").set("all");
});
test("paths", function (t) {
    local talents = function (b) { local n = 0; foreach (x in b.m.Talents) if (x > 0) n++; return n; };
    local id = 9990, made = ::World.createRoster(id);
    local a = made.create("scripts/entity/tactical/player");
    a.setStartValuesEx(["farmhand_background"]);
    local b = ::World.getRoster(id).create("scripts/entity/tactical/player");
    b.setStartValuesEx(["farmhand_background"]);
    local c = ::World.getPlayerRoster().create("scripts/entity/tactical/player");
    c.setStartValuesEx(["farmhand_background"]);
    t.probe("[master, talents]: createRoster, getRoster, getPlayerRoster",
        [[a.getSkills().hasSkill("trait.master"), talents(a)], [b.getSkills().hasSkill("trait.master"), talents(b)],
         [c.getSkills().hasSkill("trait.master"), talents(c)]]);
    t.probe("createRoster's == getRoster's", made == ::World.getRoster(id));
    local r = null;
    try { r = ::World.getRoster(9991); t.probe("getRoster(missing)", r); } catch (e) { t.probe("getRoster(missing) raised", e); }
    local d = ::BBT.recruit();
    t.probe("BBT.recruit [master, talents]", [d.getSkills().hasSkill("trait.master"), talents(d)]);
});
