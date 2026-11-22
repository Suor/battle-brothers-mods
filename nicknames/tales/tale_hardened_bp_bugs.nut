// mode: campaign seed=bbtest-nick origin=scenario.militia fresh=1
// mods: mod_black_pyramid==1.4.4 mod_davkul_rising==0.4 mod_nicknames@dev mod_hooks stdlib@dev
// include: lib/helpers.nut

// KNOWN_BUGS #3 with the reporter's mod set as available now: Reforged 0.9.3, Hardened 1.26.3,
// Black Pyramid 1.4.4 (Undead Curse, Elemental Reforged, Reforged Rogues, beasts …) and Davkul
// Rising's Reforged/Hardened compat 0.4, peasant militia origin.

local Recruitable = ["farmhand_background", "daytaler_background", "militia_background",
    "cultist_background", "sellsword_background", "monk_background"];
local Forms = ["uc_form_skeleton_effect", "uc_form_mummy_effect", "uc_form_necrosavant_effect"];

test("KB3: the reporter's mods are loaded", function (t) {
    local ids = ["mod_reforged", "mod_hardened", "mod_undead_curse", "mod_elemental_reforged",
        "mod_davkul_rising", "mod_nicknames"];
    t.eq(ids.map(@(id) ::Hooks.hasMod(id)), ids.map(@(_) true), "registered");
    local titles = t.roster().map(@(b) b.m.Title);
    t.probe("starting titles", titles);
    foreach (title in titles) t.ok(typeof title == "string" && title != "", "starting title: " + title);
});

test("KB3: undead forms of Black Pyramid get candidates and keep titles", function (t) {
    ::NickT.resetState();
    local out = [];
    foreach (i, form in Forms) {
        local bro = ::NickT.recruit(["farmhand_background"]);
        ::NickT.hire(bro);
        local title = bro.m.Title;
        ::UndeadCurse.transform(bro, form);
        ::UndeadCurse.applyUndeadBackground(bro);
        local cands = ::NickT.titles(bro);
        out.push([form, bro.getBackground().getID(), title, cands.len()]);
        t.eq(bro.m.Title, title, form + ": title kept");
        t.ok(cands.len() > 0, form + ": candidates");
        // a recruit generated with the undead in the roster
        local r = ::NickT.recruit(["daytaler_background"]);
        t.ok(r.m.Title != "", "recruit titled next to " + form);
    }
    ::World.getTemporaryRoster().clear();
    t.probe("forms", out);
});

test("KB3: ten recruits, undead among them, two days, save and load", function (t) {
    ::NickT.resetState();
    local hired = [];
    for (local i = 0; i < 10; i++) {
        local bro = ::NickT.recruit([Recruitable[i % Recruitable.len()]]);
        ::NickT.hire(bro);
        hired.push(bro.m.Title);
        if (i < Forms.len()) {
            ::UndeadCurse.transform(bro, Forms[i]);
            ::UndeadCurse.applyUndeadBackground(bro);
        }
    }
    ::World.getTemporaryRoster().clear();
    yield t.days(2);
    local before = t.roster().map(@(b) [b.getName(), b.m.Title, b.getBackground().getID()]);
    t.save("kb3hd");
    yield t.load("kb3hd");
    local after = t.roster().map(@(b) [b.getName(), b.m.Title, b.getBackground().getID()]);
    t.eq(after, before, "roster after load");
    foreach (b in t.roster()) t.ok(typeof b.m.Title == "string" && b.m.Title != "", "title of " + b.getName());
    ::NickT.resetState();
    local state = ::Nicknames.loadState();
    foreach (title in hired) t.ok(title in state.hired, "hired title in the loaded state: " + title);
    t.probe("roster", after);
    yield t.days(1);
    // The day's events may change the roster; the save must keep it as it is.
    local again = t.roster().map(@(b) [b.getName(), b.m.Title, b.getBackground().getID()]);
    t.save("kb3hd2");
    yield t.load("kb3hd2");
    t.eq(t.roster().map(@(b) [b.getName(), b.m.Title, b.getBackground().getID()]), again, "second save/load");
});
