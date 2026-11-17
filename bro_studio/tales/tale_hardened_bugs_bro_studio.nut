// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_hardened==1.26.3 mod_bro_studio@dev mod_hooks stdlib@dev
// allow-errors: stdlib \(stdlib\) version 2\.6 is outdated for mod_bro_studio
// allow-errors: Errors occured when validating mod compatibility, the game was therefore not loaded correctly
// include: lib/helpers.nut

// KNOWN_BUGS.md #2: critical exception under Hardened with a recruit that got a Bro Studio
// permanent injury. Real Hardened 1.26.3 on Reforged 0.9.3; every permanent injury in ::Const.Injury.Permanent is
// carried into a battle and through a save/load.

test("BS-KB2 hardened: 200 injured recruits generate", function (t) {
    local bros = ::BST.with({permChance = 100, traitsNum = 2}, function () {
        local out = [];
        for (local i = 0; i < 200; i++) out.push(::Tales.recruit(::Const.CharacterBackgrounds[i % ::Const.CharacterBackgrounds.len()]));
        return out;
    });
    t.eq(bros.filter(@(_, b) b.getSkills().query(::Const.SkillType.PermanentInjury).len() == 1).len(), 200, "each has one permanent injury");
});

test("BS-KB2 hardened: every permanent injury on a hired bro survives a battle and a load", function (t) {
    local injuries = ::Const.Injury.Permanent.map(@(i) i.Script);
    t.probe("permanent injuries", injuries.len());
    local roster = ::World.getPlayerRoster();
    // the company carries them in turns of up to 9 extra bros (roster max 12 in battle)
    for (local start = 0; start < injuries.len(); start += 9) {
        local added = [];
        foreach (inj in injuries.slice(start, ::Math.min(start + 9, injuries.len()))) {
            local bro = roster.create("scripts/entity/tactical/player");
            ::BST.with({permChance = 0}, @() bro.setStartValuesEx(["sellsword_background"]));
            bro.getSkills().add(::new("scripts/skills/" + inj));
            bro.onHired();
            added.push(bro);
        }
        ::Tales.toughen();
        local restore = ::Tales.tolerateRfAI();
        yield t.battle({spawn = "BanditRaiders", resources = 80});
        restore();
        t.eq(t.result.survivors.enemies, 0, "won, injuries " + start);
        t.save("bs_kb2_hd");
        yield t.load("bs_kb2_hd");
        foreach (bro in ::World.getPlayerRoster().getAll().slice(3)) roster.remove(bro);
    }
});
