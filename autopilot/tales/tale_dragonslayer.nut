// mode: campaign seed=bbtest-battle fresh=1 launch=dslayer
// mods: mod_legends==19.4.23 mod_guts_dragonslayer==1.0.4 mod_autopilot_new@dev mod_ap_probe stdlib@dev
// include: lib/helpers.nut

// Guts' Dragonslayer: its sword's own copies of vanilla strikes, used by a bro on AI.

// Bertel alone, the others in reserve, so the thugs are his to fight. The strikes cost 45-65 fatigue and the sword
// takes 40 off the max: it's for a bro of great stamina, so he's given that.
test("a bro with the Dragon Slayer strikes with its skills", function (t) {
    ::Tales.toughen(null, true);
    ::APT.probeReset();
    local place = 18;
    foreach (bro in t.roster()) if (bro.getName() != "Bertel") bro.setPlaceInFormation(place++);
    local bertel = ::Tales.byName("Bertel");
    bertel.getBaseProperties().Stamina += 100;
    ::Tales.equip(bertel, "scripts/items/weapons/dragon_slayer");
    local p = ::APT.pilot();
    yield t.battle({entities = ::Tales.thugs(2), player = p.fn, maxFrames = 30000});
    local uses = ::Tales.uniq(::APT.autoUses("Bertel").map(@(u) u.what), true);
    t.probe("Bertel's uses", uses);
    t.eq(uses.filter(@(_, u) u.find("actives.DS_") == 0).len() > 0, true, "a Dragonslayer strike");
    t.eq(p.st.stuck, [], "no stuck turn");
});
