// mode: campaign seed=bbtest-nick origin=scenario.gladiators
// mods: mod_nicknames@dev mod_msu stdlib@dev
// include: lib/helpers.nut

// The origin's own titles stay; the mod only fills empty ones at campaign start.
test("gladiators keep their origin titles", function (t) {
    local titles = t.roster().map(@(b) b.m.Title);
    titles.sort();
    t.eq(titles, ::Tales.tr({en = ["the Bear", "the Lion", "the Viper"], ru = ["Змей", "Лев", "Медведь"]}));
    t.eq(::Nicknames.loadState().generated, {}, "nothing generated");
});
