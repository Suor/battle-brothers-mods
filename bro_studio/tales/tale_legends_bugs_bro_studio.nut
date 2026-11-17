// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_legends==19.4.23 mod_bro_studio@dev stdlib@dev
// allow-errors: stdlib \(stdlib\) version 2\.6 is outdated for mod_bro_studio
// allow-errors: Errors occured when validating mod compatibility, the game was therefore not loaded correctly
// include: lib/helpers.nut

// Bro Studio on the real Legends 19.4.23. KNOWN_BUGS.md #4 (fixed in 1.3.1): Modern Hooks
// rejected wrapping Legends' setStartValuesEx (4 params) — a boot error; here the Legends branch of the hooks runs
// for recruits with traits, talents and injuries, which are then hired and fight.

test("BS-KB4 legends: recruits get Bro Studio's traits, talents and injuries", function (t) {
    local bros = ::BST.with({permChance = 100, traitsNum = 2, talentsMin = 4, talentsMax = 4, talentsChance = 100}, function () {
        local out = [];
        foreach (bg in ["farmhand_background", "sellsword_background", "militia_background", "legend_noble_background"])
            for (local i = 0; i < 25; i++) out.push(::Tales.recruit(bg));
        return out;
    });
    t.eq(bros.filter(@(_, b) b.getSkills().query(::Const.SkillType.PermanentInjury).len() != 1).len(), 0, "each has one permanent injury");
    t.probe("talent counts", ::Tales.uniq(bros.map(@(b) ::Tales.talentCount(b))));
    t.probe("trait counts", ::Tales.uniq(bros.map(@(b) b.getSkills().query(::Const.SkillType.Trait).len())));
});

test("BS-KB4 legends: an injured hired recruit fights and survives a load", function (t) {
    local hired = ::World.getPlayerRoster().create("scripts/entity/tactical/player");
    ::BST.with({permChance = 100}, @() hired.setStartValuesEx(["sellsword_background"]));
    hired.onHired();
    ::Tales.toughen();
    yield t.battle({spawn = "BanditRaiders", resources = 60});
    t.eq(t.result.survivors.enemies, 0, "won");
    t.save("bs_lg");
    yield t.load("bs_lg");
    t.eq(t.roster().len(), 4, "roster after load");
});
