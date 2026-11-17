// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_hardened==1.26.3 mod_AC@dev stdlib@dev
// include: lib/helpers.nut

// KNOWN_BUGS.md #2: tamed Nachzehrer doesn't gain max HP from Gruesome Feast, reported with Hardened.
// The real Hardened 1.26.3 on Reforged 0.9.3; the body is tale_reforged.nut's AC-KB2 test.

test("AC-KB2 hardened: a tamed Nachzehrer grows from a feast like a wild one (and AC-KB1 Reach)", function (t) {
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
