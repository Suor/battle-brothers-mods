// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_immortal_warriors@dev stdlib@dev

// Soul jars: the starting stash, imbuing a brother, his death returning the soul with his
// deeds, the next body taking them, and the info surviving a save.

local IW = {};
IW.jars <- function () {
    return ::World.Assets.getStash().getItems().filter(@(_, i) i != null && i.getID() == "misc.immortal_soul_jar");
};
IW.jarIndexes <- function () {
    local out = IW.jars().map(@(j) j.m.immortal_Index);
    out.sort();
    return out;
};
IW.useJar <- function (_bro) {
    local jar = IW.jars()[0];
    local ok = jar.onUse(_bro);
    ::World.Assets.getStash().remove(jar);
    return {ok = ok, index = jar.m.immortal_Index};
};
// A death outside battle, the way vanilla events do it (lawmen_after_criminal_event).
IW.dieInEvent <- function (_bro) {
    _bro.getItems().transferToStash(::World.Assets.getStash());
    _bro.getSkills().onDeath(::Const.FatalityType.None);
    ::World.getPlayerRoster().remove(_bro);
};
IW.setting <- @(_id) ::getModSetting("mod_immortal_warriors", _id);
IW.levelUp <- function (_bro) {
    local v = {hitpointsIncrease = 0, maxFatigueIncrease = 0, braveryIncrease = 0, meleeSkillIncrease = 0,
        rangeSkillIncrease = 0, meleeDefenseIncrease = 0, rangeDefenseIncrease = 0, initiativeIncrease = 0};
    _bro.setAttributeLevelUpValues(v);
};

test("the starting stash holds 3 soul jars", function (t) {
    t.eq(IW.jarIndexes(), [0, 1, 2], "jar indexes");
});

test("an immortal dies, his soul returns with his deeds, a new body takes them", function (t) {
    local bros = t.roster(), a = bros[0], b = bros[1];
    local used = IW.useJar(a);
    t.eq([used.ok, a.getSkills().hasSkill("trait.immortal_warrior")], [true, true], "imbued");
    a.setTitle("the Test");
    ::std.Player.giveLevels(a, 5);
    local stats = a.getLifetimeStats();
    stats.Kills = 5; stats.Battles = 2;
    local name = a.m.Name, level = a.getLevel();
    IW.dieInEvent(a);

    local info = ::ImmortalWarriors.getImmortalInfo(used.index);
    t.eq([info.Name, info.Title, info.Level, info.Kills, info.Battles, info.Deaths],
         [name, "the Test", level, 5, 2, 1], "the soul's info");
    t.eq(IW.jarIndexes(), [0, 1, 2], "the soul is back in a jar");

    local jar = IW.jars().filter(@(_, j) j.m.immortal_Index == used.index)[0];
    t.eq(jar.onUse(b), true, "reborn");
    ::World.Assets.getStash().remove(jar);
    t.eq([b.m.Name, b.getTitle(), b.getLevel()], [name, "the Test", 1 + level / 2],
         "name, title, half the levels (retainLevels = half)");
    t.eq([b.getLifetimeStats().Kills, b.getLifetimeStats().Battles], [5, 2], "the deeds carried over");

    t.save("iw");
    yield t.load("iw");
    t.eq(::ImmortalWarriors.getImmortalInfo(used.index).Name, name, "info after a load");
    t.eq(::World.getPlayerRoster().getAll().filter(@(_, x) x.m.Name == name)[0]
         .getSkills().hasSkill("trait.immortal_warrior"), true, "the trait after a load");
});

test("an immortal killed in battle returns his soul to the stash", function (t) {
    local a = t.roster()[0], name = a.m.Name;
    local used = IW.useJar(a);
    t.state.a <- a;
    yield t.battle({spawn = "BanditRaiders", resources = 30, player = function (t) {
        if (!::Tales.inBattle() || ::Tactical.State.isBattleEnded()) return;
        local a = t.state.a;
        // Not FatalityType.None: vanilla's isReallyKilled then rolls to survive with a permanent injury
        if (a.isAlive() && a.isPlacedOnMap()) { a.kill(null, null, ::Const.FatalityType.Decapitated); return; }
        local all = ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player);
        if (all.len() == 0) return;
        local killer = all[0], skill = null;
        foreach (sk in killer.getSkills().queryActives()) if (sk.isAttack()) { skill = sk.get(); break; }
        foreach (f, units in ::Tactical.Entities.getAllInstances())
            if (f != ::Const.Faction.Player)
                foreach (u in clone units) if (u != null && u.isAlive()) u.kill(killer, skill, ::Const.FatalityType.None);
    }});
    t.eq(t.roster().filter(@(_, x) x.m.Name == name).len(), 0, "he died");
    t.eq(IW.jarIndexes(), [0, 1, 2], "the soul is back in a jar");
    t.eq(::ImmortalWarriors.getImmortalInfo(used.index).Deaths, 1, "one death");
});

// The new body starts with the soul's Kills/Battles, and on his death onDeath adds his whole
// LifetimeStats to the info again, so every earlier life is counted once more per rebirth.
test("IW1: deeds are counted once across rebirths", function (t) {
    local bros = t.roster();
    local used = IW.useJar(bros[0]);
    bros[0].getLifetimeStats().Kills = 5;
    IW.dieInEvent(bros[0]);

    local jar = IW.jars().filter(@(_, j) j.m.immortal_Index == used.index)[0];
    jar.onUse(bros[1]);
    ::World.Assets.getStash().remove(jar);
    bros[1].getLifetimeStats().Kills += 3;   // 5 carried over + 3 in the second life
    IW.dieInEvent(bros[1]);
    t.eq(::ImmortalWarriors.getImmortalInfo(used.index).Kills, 8, "kills of both lives");
});

// immortal_extraALUV counts the gifted/potion rows at the front of m.Attributes, but every
// ordinary level-up decrements it too, so it goes negative and boostTalents' slice(0, n)
// keeps old rows as "extras" ahead of the rerolled ones.
test("IW2: talents boost rerolls the rows of a brother who already levelled", function (t) {
    local bro = t.roster()[0], talents = IW.setting("talents");
    bro.addXP(::Const.LevelXP[2] - bro.getXP(), false);  // level 3: two level-ups pending
    bro.updateLevel();
    IW.levelUp(bro); IW.levelUp(bro);
    t.eq([bro.getLevel(), bro.m.LevelUps, bro.m.Attributes[0].len()], [3, 0, 8], "levelled twice");
    talents.set(1);
    IW.useJar(bro);
    talents.set(0);
    t.eq(bro.m.immortal_extraALUV, 0, "no gifted rows");
    t.eq(bro.m.Attributes.map(@(a) a.len()), array(::Const.Attributes.COUNT, 8), "rows for the remaining levels");
});
