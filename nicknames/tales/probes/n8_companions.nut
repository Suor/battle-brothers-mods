// mode: campaign seed=bbtest-nick fresh=1
// mods: mod_nicknames@dev stdlib@dev
// include: ../lib/helpers.nut

// N8 measurement, not part of the suite: how often a companion has no title candidates and stays untitled.
// Run: cd ~/projects/bbm/bbtales && ./bbtales.py --env code,engine -vv ../mods/nicknames/tales/probes/n8_companions.nut
// (add `-r mod_msu` for the MSU case)

test("N8 probe: companions without candidates", function (t) {
    ::NickT.resetState();
    t.probe("msu", ::Hooks.hasMod("mod_msu"));
    foreach (b in t.roster()) t.probe("start " + b.getName(), [b.getBackground().getID(), b.getTitle(),
        ::NickT.keys(::Nicknames.buildFactorSet(b)), ::Nicknames.buildCandidates(b).len()]);
    foreach (bg in ["companion_1h_background", "companion_2h_background", "companion_ranged_background"]) {
        local none = 0, untitled = 0, sample = null;
        for (local i = 0; i < 300; i++) {
            local bro = ::NickT.recruit([bg]);
            if (::Nicknames.buildCandidates(bro).len() == 0) {
                none++;
                if (sample == null) sample = ::NickT.keys(::Nicknames.buildFactorSet(bro));
            }
            if (bro.getTitle() == "") untitled++;
            ::World.getTemporaryRoster().clear();
        }
        t.probe(bg, {none = none, untitled = untitled, sample = sample});
    }
});
