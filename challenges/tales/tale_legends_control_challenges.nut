// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_legends==19.4.23 stdlib@dev
// include: legends/level_up_body.nut

// Control for tale_legends_bugs_challenges.nut: Legends without Challenges.
test("control: a bro with level-ups gets level-up data for the UI", function (t) {
    local d = ::CHL_levelUpData();
    t.probe("ui data", d);
    t.eq([d.levelUps > 0, d.hasLevelUpValues], [true, true], "[has level-ups, levelUp values in the UI data]");
});
