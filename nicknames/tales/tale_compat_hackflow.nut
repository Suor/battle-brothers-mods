// mode: campaign seed=bbtest-nick fresh=1
// mods: mod_backgrounds_and_events==0.8 mod_hackflows_perks==1.6.3 mod_background_perks==2.6.2 mod_nicknames@dev mod_msu stdlib@dev
// include: lib/helpers.nut

// With the author's companion mods: XBE backgrounds, Hackflow's Perks, Starting Perks by Background.

local function loadIds(_dir) {
    local out = {};
    foreach (f in ::IO.enumerateFiles(_dir)) {
        if (f.find("perk_hackflows_potential") != null) continue;  // needs setup() args, logs an error
        try { out[::new(f).getID()] <- true; } catch (e) {}
    }
    return out;
}

test("XBE backgrounds and Hackflow's perks used as factors exist", function (t) {
    ::NickT.resetState();
    local known = loadIds("scripts/skills/backgrounds");
    foreach (k, _ in loadIds("scripts/skills/perks")) known[k] <- true;
    local missing = {};
    foreach (e in ::Nicknames.Titles) foreach (fs in e.factors) foreach (f in fs)
        if ((f.find("background.hackflows_") == 0 || f.find("perk.hackflows.") == 0) && !(f in known))
            missing[f] <- true;
    t.eq(::NickT.keys(missing), []);
});

// BUG N6: Aliases is one value per key, so a fallback perk standing in for several canonical
// perks (rf_survival_instinct for nine_lives, underdog and dodge) keeps only the last one.
test("N6: every Starting Perks fallback aliases to each perk it stands in for", function (t) {
    ::NickT.resetState();
    t.ok("BgPerks" in ::getroottable(), "BgPerks loaded");
    local lost = [];
    foreach (canonical, fallbacks in ::BgPerks.fallbacks)
        foreach (fb in fallbacks)
            if (::Nicknames.Aliases["perk." + fb].find("perk." + canonical) == null)
                lost.push(fb + " -> " + canonical);
    lost.sort();
    t.eq(lost, []);
});

test("recruits with starting perks get perk factors and titles", function (t) {
    ::NickT.resetState();
    local withPerk = 0;
    for (local i = 0; i < 30; i++) {
        local bro = ::NickT.recruit(["monk_background", "hunter_background", "historian_background",
            "brawler_background", "thief_background"]);
        if (::NickT.factorsWithPrefix(::Nicknames.buildFactorSet(bro), "perk.").len() > 0) withPerk++;
        t.ok(bro.getTitle() != "" && ::NickT.has(::NickT.titles(bro), bro.getTitle()), "titled, fitting");
    }
    t.probe("with a perk factor", withPerk);
    t.ok(withPerk > 0, "some recruit has a starting perk factor");
    ::World.getTemporaryRoster().clear();
});
