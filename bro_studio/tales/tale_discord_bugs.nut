// mode: campaign seed=bbtest-battle fresh=1 launch=discord
// mods: mod_bro_studio@dev mod_hooks stdlib@dev
// allow-errors: stdlib \(stdlib\) version 2\.6 is outdated for mod_bro_studio
// allow-errors: Errors occured when validating mod compatibility, the game was therefore not loaded correctly
// include: lib/helpers.nut

// KNOWN_BUGS.md #1 extended (Discord deep search): max-only rows (Gifted) on a veteran.


local function gift(_bro) {
    _bro.getSkills().add(::new("scripts/skills/perks/perk_gifted"));
}

test("BS-KB1: Gifted on a level-12 bro keeps its max row", function (t) {
    local Max = ::Const.AttributesLevelUp.map(@(a) a.Max);
    local bro = ::Tales.recruit();
    ::BST.levelTo(bro, 12);
    gift(bro);
    local rows = ::BST.levelTo(bro, 14);
    t.probe("rows after Gifted at 12, levels 13-14", rows);
    t.eq(rows.len(), 3, "Gifted + 2 level-ups");
    t.eq(rows[0], [Max[0], Max[1], Max[2], Max[3], Max[4], Max[5], Max[6], Max[7]], "Gifted's row is max");
});

test("BS-KB1: Gifted after the level-up screen was opened on a pending veteran level", function (t) {
    local Max = ::Const.AttributesLevelUp.map(@(a) a.Max);
    local bro = ::Tales.recruit();
    ::BST.levelTo(bro, 12);
    bro.m.XP = ::Const.LevelXP[12];
    bro.updateLevel();
    bro.getAttributeLevelUpValues();   // the screen built the veteran row
    gift(bro);
    local out = [];
    while (bro.m.LevelUps > 0) {
        local v = bro.getAttributeLevelUpValues();
        out.push([v.hitpointsIncrease, v.braveryIncrease, v.fatigueIncrease, v.initiativeIncrease,
                  v.meleeSkillIncrease, v.rangeSkillIncrease, v.meleeDefenseIncrease, v.rangeDefenseIncrease]);
        v.maxFatigueIncrease <- v.fatigueIncrease;
        bro.setAttributeLevelUpValues(v);
    }
    t.probe("rows", out);
    t.eq(out.len(), 2, "a level-up + Gifted");
    t.eq(out.filter(@(_, r) r[0] == Max[0] && r[4] == Max[4]).len(), 1, "one max row (Gifted's)");
});
