// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_standout_enemies@dev mod_black_pyramid mod_msu stdlib@dev
// include: lib/helpers.nut

// Black Pyramid's black_pyramid_beasts replaces tactical_entity_manager.setupEntity wholesale: quirks need us on top.

test("with Black Pyramid bandits of a party still get quirks", function (t) {
    ::Tales.toughen();
    local cfg = ::StandoutEnemies.Config, days = cfg.ScaleDays;
    cfg.ScaleDays = 1;  // scale = Days / ScaleDays: past every strategy's MinScale
    local p = ::SET.partyEntities(200);
    local names = t.state.names <- [];
    yield t.battle({entities = p.entities, player = ::Tales.scripted([function (t) {
        foreach (e in ::Tales.hostiles()) t.state.names.push(e.getName());
        ::Tales.killAll();
    }])});
    cfg.ScaleDays = days;
    if (p.party.isAlive()) p.party.die();
    local quirks = ::Tales.tr({en = ["Agile ", "Huge "], ru = ["Проворный ", "Огромный "]});
    local quirked = names.filter(@(_, n) quirks.filter(@(_, q) n.find(q) == 0).len() > 0);
    t.probe("names", names);
    t.eq(quirked.len() > 0, true, "some bandit is Agile or Huge");
    t.eq(t.result.survivors.enemies, 0, "won");
});
