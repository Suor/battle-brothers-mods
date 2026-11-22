// mode: campaign seed=bbtest-nick origin=scenario.militia
// mods: mod_nicknames@dev mod_msu stdlib@dev
// include: lib/helpers.nut

test("militia: twelve starting brothers, all titled, no repeats", function (t) {
    local titles = t.roster().map(@(b) b.m.Title);
    t.probe("titles", titles);
    t.eq(titles.len(), 12, "company size");
    local seen = {}, dups = [];
    foreach (title in titles) {
        t.ok(title != "", "titled");
        if (title in seen) dups.push(title);
        seen[title] <- true;
    }
    t.eq(dups, [], "repeated titles");
    local generated = ::Nicknames.loadState().generated;
    foreach (bro in t.roster())
        if (bro.m.Title in generated)
            t.ok(::NickT.has(::NickT.titles(bro), bro.m.Title), bro.m.Title + " fits " + bro.getName());
});
