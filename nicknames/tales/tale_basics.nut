// mode: campaign seed=bbtest-nick fresh=1
// mods: mod_nicknames@dev mod_msu stdlib@dev
// include: lib/helpers.nut

// Cases of ../test.nut (mocks), on real brothers made by vanilla scripts instead of makeBro().

// A recruit of `_bg` whose only traits are `_traits`.
local function broWith(_bg, _traits = [], _injuries = []) {
    local bro = ::NickT.recruit([_bg]);
    foreach (s in bro.getSkills().getAllSkillsOfType(::Const.SkillType.Trait))
        if (s.getID().find("trait.") == 0) bro.getSkills().remove(s);
    foreach (t in _traits) bro.getSkills().add(::new("scripts/skills/traits/" + t + "_trait"));
    foreach (i in _injuries) bro.getSkills().add(::new("scripts/skills/injury_permanent/" + i + "_injury"));
    return bro;
}

test("vanilla trait m.Titles are candidates", function (t) {
    ::NickT.resetState();
    local titles = ::NickT.titles(broWith("farmhand_background", ["tiny"]));
    local missing = ::new("scripts/skills/traits/tiny_trait").m.Titles.filter(@(_, x) !::NickT.has(titles, x));
    t.eq(missing, [], "tiny's titles missing from the candidates");
    ::World.getTemporaryRoster().clear();
});

test("single and multi-factor titles, weights", function (t) {
    ::NickT.resetState();
    local W = ::Nicknames.Weights;
    local cands = ::Nicknames.buildCandidates(broWith("farmhand_background", ["tiny", "bright"]));
    t.eq(cands.filter(@(_, c) c.title == "Shorty"), [{title = "Shorty", weight = W.trait}]);
    t.eq(cands.filter(@(_, c) c.title == "the Imp"), [{title = "the Imp", weight = W.trait * W.trait}]);
    t.eq(::NickT.has(::NickT.titles(broWith("farmhand_background", ["brave"])), "Shorty"), false, "no false match");
    ::World.getTemporaryRoster().clear();
});

test("injury factor and weight", function (t) {
    ::NickT.resetState();
    local bro = broWith("farmhand_background", [], ["missing_eye"]);
    t.eq(::NickT.factorsWithPrefix(::Nicknames.buildFactorSet(bro), "injury."), ["injury.missing_eye"]);
    local cands = ::Nicknames.buildCandidates(bro);
    t.eq(cands.filter(@(_, c) c.title == "One-Eye"), [{title = "One-Eye", weight = ::Nicknames.Weights.injury}]);
    t.eq(::NickT.has(::NickT.titles(broWith("farmhand_background", ["drunkard"], ["broken_knee"])), "the Dancer"),
        true, "injury + trait combo");
    ::World.getTemporaryRoster().clear();
});

test("aliases: the southern assassin matches assassin titles", function (t) {
    ::NickT.resetState();
    local fs = ::Nicknames.buildFactorSet(::NickT.recruit(["assassin_southern_background"]));
    t.eq(::NickT.factorsWithPrefix(fs, "background."), ["background.assassin", "background.assassin_southern"]);
    ::World.getTemporaryRoster().clear();
});

test("the roster blocks its titles, the cascade falls back when all are blocked", function (t) {
    ::NickT.resetState();
    local bro = broWith("farmhand_background", ["tiny"]);
    local all = ::NickT.titles(bro);
    t.roster()[0].setTitle("Shorty");
    local picked = [];
    for (local i = 0; i < 10; i++) {
        ::Nicknames.loadState().generated.clear();
        ::Nicknames.fillTitle(bro);
        picked.push(bro.getTitle());
    }
    t.eq(picked.filter(@(_, x) x == "Shorty"), [], "Shorty is worn");
    foreach (title in all) ::Nicknames.loadState().generated[title] <- {days = [::World.getTime().Days]};
    ::Nicknames.fillTitle(bro);
    t.eq(::NickT.has(all, bro.getTitle()), true, "a candidate when all are recent");
    ::World.getTemporaryRoster().clear();
});

test("onHired records the title, twice for a re-hire", function (t) {
    ::NickT.resetState();
    local bro = ::NickT.recruit(["farmhand_background"]);
    bro.setTitle("Bjorn");
    ::NickT.hire(bro);
    t.eq(::Nicknames.loadState().hired.Bjorn, 1);
    bro.onHired();
    t.eq(::Nicknames.loadState().hired.Bjorn, 2);
});
