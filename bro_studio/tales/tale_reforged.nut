// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_reforged==0.9.3 mod_bro_studio@dev mod_hooks stdlib@dev
// allow-errors: stdlib \(stdlib\) version 2\.6 is outdated for mod_bro_studio
// allow-errors: Errors occured when validating mod compatibility, the game was therefore not loaded correctly
// include: lib/helpers.nut

// BS-KB2: under Reforged (Hardened: tale_hardened_bugs_bro_studio.nut), recruits
// generated with a permanent injury, hired and taken into a battle.

test("BS-KB2: 200 injured recruits under Reforged, one fights", function (t) {
    local bros = ::BST.with({permChance = 100, traitsNum = 2}, function () {
        local out = [];
        for (local i = 0; i < 200; i++) out.push(::Tales.recruit(::Const.CharacterBackgrounds[i % ::Const.CharacterBackgrounds.len()]));
        return out;
    });
    t.eq(bros.filter(@(_, b) b.getSkills().query(::Const.SkillType.PermanentInjury).len() == 1).len(), 200, "each has one permanent injury");

    local hired = ::World.getPlayerRoster().create("scripts/entity/tactical/player");
    ::BST.with({permChance = 100}, @() hired.setStartValuesEx(["sellsword_background"]));
    hired.onHired();
    ::Tales.toughen();
    local restore = ::Tales.tolerateRfAI();
    yield t.battle({spawn = "BanditRaiders", resources = 60});
    restore();
    t.eq(t.result.survivors.enemies, 0, "won");
});
