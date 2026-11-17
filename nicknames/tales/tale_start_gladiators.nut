// mode: campaign seed=bbtest-nick origin=scenario.gladiators
// mods: mod_nicknames@dev mod_msu stdlib@dev
// include: lib/helpers.nut

// The origin's own titles stay; the mod only fills empty ones at campaign start.
test("gladiators keep their origin titles", function (t) {
    local titles = t.roster().map(@(b) b.getTitle());
    titles.sort();
    t.eq(titles, ["the Bear", "the Lion", "the Viper"]);
    t.eq(::Nicknames.loadState().generated, {}, "nothing generated");
});
