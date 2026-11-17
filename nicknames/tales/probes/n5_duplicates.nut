// mode: campaign seed=bbtest-nick fresh=1
// mods: mod_nicknames mod_msu stdlib@dev
// include: ../lib/helpers.nut

// N5 measurement, not part of the suite (~20 s): how often a volunteers-event recruit comes with a
// vanilla-rolled title, and how often that title is worn by a living brother.
// Run: cd ~/projects/bbm/bbtales && ./bbtales.py --env code ../mods/nicknames/tales/probes/n5_duplicates.nut

local Bgs = ["farmhand_background", "daytaler_background", "militia_background", "hunter_background",
    "sellsword_background", "brawler_background", "thief_background", "poacher_background",
    "miller_background", "wildman_background", "messenger_background", "butcher_background"];

foreach (rosterSize in [6, 12, 20]) {
    local size = rosterSize;
    test("N5 probe roster " + size, function (t) {
        ::NickT.resetState();
        local dudes = 0, withTitle = 0, dup = 0;
        for (local run = 0; run < 15; run++) {
            // a roster of town recruits, titled by the mod
            foreach (b in t.roster().slice(3)) ::World.getPlayerRoster().remove(b);
            while (t.roster().len() < size) ::NickT.hire(::NickT.recruit([Bgs[::Math.rand(0, Bgs.len() - 1)]]));
            local worn = {};
            foreach (b in t.roster()) worn[b.getTitle()] <- true;
            for (local i = 0; i < 20; i++) {
                ::Tales.Autoplay = false;
                local ev = ::World.Events.getEvent("event.volunteers");
                if (!::World.Events.fire("event.volunteers", false)) throw "no fire";
                foreach (d in [ev.m.Dude1, ev.m.Dude2, ev.m.Dude3]) {
                    dudes++;
                    if (d.getTitle() != "") withTitle++;
                    if (d.getTitle() in worn) dup++;
                }
                ::World.Events.processInput(1);
                ::Tales.Autoplay = true;
            }
        }
        t.probe("event recruits / with a vanilla title / wearing a living brother's", [dudes, withTitle, dup]);
    });
}
