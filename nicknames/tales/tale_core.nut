// mode: campaign seed=bbtest-nick fresh=1
// mods: mod_nicknames@dev mod_msu stdlib@dev
// include: lib/helpers.nut

// Core: titles for the starting roster, recruits, settlements; repeat avoidance; hiring state.

local Backgrounds = ["farmhand_background", "daytaler_background", "sellsword_background",
    "militia_background", "thief_background", "monk_background", "hunter_background",
    "brawler_background", "beggar_background", "hedge_knight_background", "witchhunter_background",
    "miner_background", "messenger_background", "squire_background", "wildman_background"];

test("starting roster: every brother titled, titles distinct", function (t) {
    ::NickT.resetState();
    local titles = [], seen = {};
    foreach (bro in t.roster()) {
        local title = bro.getTitle();
        titles.push(title);
        t.ok(title != "", bro.getName() + " has a title");
        t.ok(!(title in seen), "title " + title + " repeats");
        seen[title] <- true;
    }
    t.probe("titles", titles);
    // Titles the mod gave are recorded and fit the brother; the rest come from the origin.
    local generated = ::Nicknames.loadState().generated;
    foreach (bro in t.roster())
        if (bro.getTitle() in generated)
            t.ok(::NickT.has(::NickT.titles(bro), bro.getTitle()), bro.getTitle() + " fits " + bro.getName());
    t.ok(generated.len() > 0, "the mod titled some starting brother");
});

test("recruits get a title that fits them", function (t) {
    ::NickT.resetState();
    local misfits = [], untitled = 0;
    for (local i = 0; i < 45; i++) {
        local bro = ::NickT.recruit([Backgrounds[i % Backgrounds.len()]]);
        local title = bro.getTitle();
        if (title == "") { untitled++; continue; }
        if (!::NickT.has(::NickT.titles(bro), title))
            misfits.push(bro.getBackground().getID() + ": " + title);
    }
    t.eq(untitled, 0, "recruits without a title");
    t.eq(misfits, [], "titles not among the recruit's candidates");
    ::World.getTemporaryRoster().clear();
});

test("recruit's title is recorded as generated today", function (t) {
    ::NickT.resetState();
    local bro = ::NickT.recruit(["farmhand_background"]);
    local today = ::World.getTime().Days;
    t.eq(::Nicknames.loadState().generated[bro.getTitle()].days.top(), today);
    // Persisted in the world flags, not only in the cache
    ::NickT.resetState();
    t.eq(::Nicknames.loadState().generated[bro.getTitle()].days.top(), today, "after a cache reset");
    ::World.getTemporaryRoster().clear();
});

test("recruits avoid recent and taken titles while others are left", function (t) {
    ::NickT.resetState();
    local repeats = [];
    for (local i = 0; i < 40; i++) {
        local blocked = ::NickT.blocked();
        local bro = ::World.getTemporaryRoster().create("scripts/entity/tactical/player");
        bro.setStartValuesEx(["farmhand_background"]);
        local free = ::NickT.titles(bro).filter(@(_, c) !(c in blocked));
        if (free.len() > 0 && bro.getTitle() in blocked)
            repeats.push(bro.getTitle() + " (free: " + free.len() + ")");
    }
    t.eq(repeats, [], "picked a blocked title while free ones existed");
    ::World.getTemporaryRoster().clear();
});

test("settlement recruits all get distinct fitting titles", function (t) {
    ::NickT.resetState();
    local player = ::World.State.getPlayer().getTile();
    local towns = clone ::World.EntityManager.getSettlements();
    towns.sort(@(a, b) a.getTile().getDistanceTo(player) <=> b.getTile().getDistanceTo(player));
    local all = [], problems = [];
    foreach (town in towns.slice(0, 4)) {
        town.updateRoster(true);
        foreach (bro in ::World.getRoster(town.getID()).getAll()) {
            all.push(bro.getTitle());
            if (bro.getTitle() == "" || !::NickT.has(::NickT.titles(bro), bro.getTitle()))
                problems.push(town.getName() + ": " + bro.getName() + " '" + bro.getTitle() + "'");
        }
    }
    t.probe("recruits", all.len());
    t.ok(all.len() >= 8, "enough recruits to judge");
    t.eq(problems, [], "untitled or misfitting recruits");
    local seen = {}, dups = [];
    foreach (title in all) {
        if (title in seen) dups.push(title);
        seen[title] <- true;
    }
    t.eq(dups, [], "repeated titles among fresh recruits of nearby towns");
});

test("hiring keeps the title and records it", function (t) {
    ::NickT.resetState();
    local bro = ::NickT.recruit(["sellsword_background"]);
    local title = bro.getTitle();
    ::NickT.hire(bro);
    t.eq(bro.getTitle(), title, "title after hire");
    ::NickT.resetState();
    t.eq(::Nicknames.loadState().hired[title], 1, "hired count, read back from the flags");
});

test("a gone brother's title isn't given again", function (t) {
    ::NickT.resetState();
    local bro = ::NickT.recruit(["farmhand_background"]);
    local title = bro.getTitle();
    ::NickT.hire(bro);
    ::World.getPlayerRoster().remove(bro);
    t.ok(::NickT.titles(bro).len() > 1, "has alternatives");
    local reused = 0;
    for (local i = 0; i < 20; i++) {
        ::Nicknames.loadState().generated.clear();  // as if 14 days passed
        ::Nicknames.fillTitle(bro);
        if (bro.getTitle() == title) reused++;
    }
    t.eq(reused, 0, "times " + title + " was picked again");
});

// BUG N1: starting brothers never go through onHired(), so their titles aren't in state.hired
// and are free to be reused once they fall.
test("N1: starting brothers' titles count as hired", function (t) {
    ::NickT.resetState();
    local hired = ::Nicknames.loadState().hired;
    local missing = [];
    foreach (bro in t.roster())
        if (!(bro.getTitle() in hired)) missing.push(bro.getTitle());
    t.eq(missing, [], "starting titles missing from state.hired");

    // The fallout: a fallen starting brother's title is handed out again. He needs another candidate
    // nobody wears, or the cascade rightly falls back to his own.
    local worn = {}, bro = null;
    foreach (b in t.roster()) worn[b.getTitle()] <- true;
    foreach (b in t.roster())
        if (bro == null && ::NickT.titles(b).filter(@(_, c) !(c in worn)).len() > 0) bro = b;
    local title = bro.getTitle();
    ::World.getPlayerRoster().remove(bro);
    local reused = 0;
    for (local i = 0; i < 20; i++) {
        ::Nicknames.loadState().generated.clear();  // as if 14 days passed
        ::Nicknames.fillTitle(bro);
        if (bro.getTitle() == title) reused++;
    }
    t.eq(reused, 0, "times the fallen " + title + " was picked again");
});

test("titles and state survive save and load", function (t) {
    ::NickT.resetState();
    local bro = ::NickT.recruit(["monk_background"]);
    ::NickT.hire(bro);
    local before = [];
    foreach (b in t.roster()) before.push(b.getTitle());
    local state = ::Nicknames.loadState();
    local hired = clone state.hired, generated = ::NickT.keys(state.generated);
    t.save("nick_saveload");
    yield t.load("nick_saveload");
    local after = [];
    foreach (b in t.roster()) after.push(b.getTitle());
    t.eq(after, before, "roster titles");
    ::NickT.resetState();
    t.eq(::Nicknames.loadState().hired, hired, "state.hired");
    t.eq(::NickT.keys(::Nicknames.loadState().generated), generated, "state.generated titles");
});

test("debug mode logs factors and candidates into flags", function (t) {
    ::NickT.resetState();
    ::Nicknames.Debug = true;
    local bro = ::NickT.recruit(["farmhand_background"]);
    ::Nicknames.Debug = false;
    t.eq(::World.Flags.getAsInt("nicknames.factors"), 1, "factors log index");
    t.eq(::World.Flags.getAsInt("nicknames.candidates"), 1, "candidates log index");
    local logged = ::std.Flags.unpack(::World.Flags, "nicknames.factors.0");
    t.eq(logged.len(), 1, "factors batch size");
    // The label has the name as it was then: a vanilla trait title may follow it.
    local label = "factors for " + bro.getNameOnly();
    t.eq(logged[0].label.slice(0, label.len()), label);
    ::Nicknames.Logs = {factors = {idx = null, items = []}, candidates = {idx = null, items = []}};
    ::World.getTemporaryRoster().clear();
});

test("generated records older than 14 days are dropped on the next record", function (t) {
    ::NickT.resetState();
    local today = ::World.getTime().Days;
    local generated = ::Nicknames.loadState().generated, expected = {};
    foreach (title, rec in generated) expected[title] <- {days = clone rec.days};
    generated["old title"] <- {days = [today - 14]};
    generated["recent title"] <- {days = [today - 14, today - 13]};
    local title = ::NickT.recruit(["farmhand_background"]).getTitle();
    ::World.getTemporaryRoster().clear();
    expected["recent title"] <- {days = [today - 13]};
    if (!expected.rawin(title)) expected[title] <- {days = []};
    expected[title].days.push(today);
    t.eq(::Nicknames.loadState().generated, expected);
});

test("generated titles expire after 14 days", function (t) {
    ::NickT.resetState();
    local day0 = ::World.getTime().Days;
    local first = ::NickT.recruit(["farmhand_background"]).getTitle();
    ::World.getTemporaryRoster().clear();
    yield t.days(15, {speed = 16.0});
    local today = ::World.getTime().Days;
    local second = ::NickT.recruit(["farmhand_background"]).getTitle();
    ::World.getTemporaryRoster().clear();
    // Towns refresh their recruits meanwhile, so the first title may be recorded again later.
    local generated = ::Nicknames.loadState().generated;
    t.eq(generated.rawin(first) ? generated[first].days.find(day0) : null, null,
        "the day " + day0 + " record of " + first);
    t.eq(generated[second].days.top(), today, second + " recorded today");
    foreach (title, rec in generated)
        foreach (d in rec.days) t.ok(d > today - 14, title + " generated on day " + d + " kept on day " + today);
});
