// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_reforged==0.9.3 mod_AC@dev stdlib@dev
// include: lib/helpers.nut

// AC under Reforged 0.9.3. Companions are AC's own actor classes, so Reforged's per-enemy hooks
// (Reach, perks) don't run on them; compared with the Reforged enemy of the same kind.

local TL = ::Const.Companions.TypeList;
local Pairs = [
    ["Wardog", "scripts/entity/tactical/wardog"], ["Warhound", "scripts/entity/tactical/warhound"],
    ["Warwolf", "scripts/entity/tactical/warwolf"], ["Direwolf", "scripts/entity/tactical/enemies/direwolf"],
    ["DirewolfFrenzied", "scripts/entity/tactical/enemies/direwolf_high"],
    ["Hyena", "scripts/entity/tactical/enemies/hyena"], ["HyenaFrenzied", "scripts/entity/tactical/enemies/hyena_high"],
    ["Spider", "scripts/entity/tactical/enemies/spider"], ["Snake", "scripts/entity/tactical/enemies/serpent"],
    ["Nacho", "scripts/entity/tactical/enemies/ghoul"], ["Alp", "scripts/entity/tactical/enemies/alp"],
    ["Unhold", "scripts/entity/tactical/enemies/unhold"], ["Schrat", "scripts/entity/tactical/enemies/schrat"],
    ["Noodle", "scripts/entity/tactical/enemies/lindwurm"],
];

test("AC-KB1: unleashed companions have the Reach of their Reforged kin", function (t) {
    local restore = ::Tales.tolerateRfAI();
    ::Tales.toughen();
    local id = t.state.id <- t.roster()[0].getID();
    local got = t.state.got <- {}, kin = t.state.kin <- {};
    yield t.battle({spawn = "BanditRaiders", resources = 40, player = ::Tales.scripted([function (t) {
        local bro = ::Tactical.getEntityByID(t.state.id), used = {};
        local got = t.state.got, kin = t.state.kin;
        foreach (p in Pairs) {
            local c = ::ACT.unleash(bro, TL[p[0]], ::Tales.freeTile(used));
            got[p[0]] <- c.getCurrentProperties().Reach;
            local e = ::Tales.spawn(p[1], ::Tales.freeTile(used), ::Const.Faction.PlayerAnimals);
            kin[p[0]] <- e.getCurrentProperties().Reach;
        }
    }], @(t) ::Tactical.getEntityByID(t.state.id))});
    restore();
    t.probe("Reforged kin reach", kin);
    t.eq(got, kin, "companion Reach per type");
});

test("AC-KB2 reforged: a tamed Nachzehrer grows from a feast like a wild one (and AC-KB1 Reach)", function (t) {
    local restore = ::Tales.tolerateRfAI();
    ::Tales.toughen();
    local id = t.state.id <- t.roster()[0].getID();
    local out = t.state.out <- {};
    yield t.battle({spawn = "BanditRaiders", resources = 40, player = ::Tales.scripted([function (t) {
        local bro = ::Tactical.getEntityByID(t.state.id), used = {};
        local out = t.state.out;
        out.tame <- ::ACT.unleash(bro, ::Const.Companions.TypeList.Nacho, ::Tales.freeTile(used));
        out.wild <- ::Tales.spawn("scripts/entity/tactical/enemies/ghoul", ::Tales.freeTile(used), ::Const.Faction.PlayerAnimals);
        out.before <- [::ACT.ghoulState(out.tame), ::ACT.ghoulState(out.wild)];
        ::ACT.feast(out.tame);
        ::ACT.feast(out.wild);
    }, ::Tales.wait(90), function (t) {
        local out = t.state.out;
        out.after <- [::ACT.ghoulState(out.tame), ::ACT.ghoulState(out.wild)];
        delete out.tame; delete out.wild;
    }], @(t) ::Tactical.getEntityByID(t.state.id))});
    restore();
    t.probe("[size, HP max, Reach] before: [tame, wild]", out.before);
    local grown = @(s) [s[0][0] - s[1][0], s[0][1] - s[1][1], s[0][2] - s[1][2]];
    local tame = [out.after[0], out.before[0]], wild = [out.after[1], out.before[1]];
    local g = [grown(tame), grown(wild)];
    t.eq([g[0][0], g[0][1]], [g[1][0], g[1][1]], "AC-KB2 growth [size, HP max]: tame vs wild");
    t.eq(g[0][2], g[1][2], "AC-KB1 Reach growth: tame vs wild");
});
