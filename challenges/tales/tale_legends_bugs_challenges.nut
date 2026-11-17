// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_legends==19.4.23 mod_challenges@dev stdlib@dev
// include: lib/helpers.nut legends/level_up_body.nut

// Challenges on real Legends 19.4.23 (the mod doesn't claim Legends support).

// KNOWN_BUGS "Others": "can't level up bros, no button" with Legends. The button is the character screen's JS;
// headless only the UI data it is built from can be checked (same values in tale_legends_control_challenges.nut).
test("CH-KB1 legends: a bro with level-ups gets level-up data for the UI", function (t) {
    local d = ::CHL_levelUpData();
    t.probe("ui data", d);
    t.eq([d.levelUps > 0, d.hasLevelUpValues], [true, true], "[has level-ups, levelUp values in the UI data]");
});

// New (CH-L1): Legends replaces retinue_manager.getFollowersForUI per instance (mods_hookNewObject),
// shadowing the mod's class hook, so banned followers are still offered.
test("CH-L1: banned followers are left out of the hire list under Legends", function (t) {
    local ids = @() ::World.Retinue.getFollowersForUI().map(@(f) f.ID);
    local all = ids();
    local banned = ::CHT.with({"ban_follower.cook": true, "ban_follower.scout": true}, ids);
    t.probe("getFollowersForUI source", ::World.Retinue.getFollowersForUI.getinfos().src);
    t.eq([all.find("follower.cook") != null, all.find("follower.scout") != null], [true, true], "offered by default");
    t.eq(banned, all.filter(@(_, id) id != "follower.cook" && id != "follower.scout"), "cook and scout gone");
});
