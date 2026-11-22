// mode: campaign seed=bbtest-nick fresh=1 snapshot=0
// mods: mod_nicknames@dev mod_onhired_stub mod_msu stdlib@dev
// include: lib/helpers.nut

// N1 with a mod calling onHired() for the starting brothers (mod_onhired_stub/), before and after the loop that
// records starting titles: titles stay, each is in `hired`, and the loop doesn't add to a count.
// snapshot=0: the stub records the calls at the campaign start, which a launch from a snapshot skips.

test("N1: a mod calling onHired() for starting brothers keeps titles and hired right", function (t) {
    local titles = t.roster().map(@(b) b.m.Title), once = {}, twice = {};
    foreach (title in titles) { once[title] <- 1; twice[title] <- 2; }
    t.probe("titles", titles);
    t.eq(titles.filter(@(_, x) x == "").len(), 0, "every brother titled");
    t.eq(once.len(), titles.len(), "titles distinct");

    local seen = ::OnHiredStub.seen;
    t.eq(seen.map(@(s) s.point), ["before", "after"], "onHired() calls around our loop");
    t.eq(seen[0].hired, {}, "nothing recorded before our loop");
    t.eq(seen[1].hired, once, "before the second onHired(): each title once, the loop didn't count again");
    t.eq(seen[1].titles, titles, "the second onHired() keeps titles");
    ::NickT.resetState();
    t.eq(::Nicknames.loadState().hired, twice, "hired after both onHired() calls");
});
