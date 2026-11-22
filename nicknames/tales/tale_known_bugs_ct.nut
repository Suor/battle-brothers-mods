// mode: campaign seed=bbtest-nick
// mods: mod_nicknames@dev mod_msu stdlib@dev
// include: lib/helpers.nut

// KNOWN_BUGS #1's other trigger: a new campaign in the same session; a launch of its own (it leaves the second campaign).

test("KB1: title state doesn't leak into a new campaign", function (t) {
    ::NickT.resetState();
    local hired = clone ::Nicknames.loadState().hired;
    local bro = ::NickT.recruit(["sellsword_background"]);
    local title = bro.m.Title;
    ::NickT.hire(bro);
    hired[title] <- 1;
    t.eq(::Nicknames.loadState().hired, hired, "hired in the first campaign");
    yield t.newCampaign({seed = "second"});
    local starting = {};
    foreach (b in t.roster()) starting[b.m.Title] <- 1;
    t.eq(::Nicknames.loadState().hired, starting, "hired in a new campaign: its starting brothers");
    local saved = ::std.Flags.unpack(::World.Flags, ::Nicknames.FlagState);
    t.eq(saved == null ? null : saved.hired, starting, "hired in the new campaign's flags");
});
