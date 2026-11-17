// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_legends==19.4.23 mod_elite_few@dev stdlib@dev
// include: lib/helpers.nut

// KNOWN_BUGS.md #5, #9, #10 on the real Legends 19.4.23 (no hackflow shim: Legends brings
// mod_hooks). #4 needs SSU, which doesn't boot on Legends 19.4.

local ATTRS = ["Hitpoints", "Bravery", "Stamina", "MeleeSkill", "RangedSkill", "MeleeDefense", "RangedDefense", "Initiative"];

local function means(_bros) {
    local out = ATTRS.map(@(_) 0.0);
    foreach (b in _bros) foreach (i, a in ATTRS) out[i] += b.getBaseProperties()[a] / _bros.len().tofloat();
    return out.map(@(v) (v * 10).tointeger() / 10.0);
}

// #5: "Legends 19.0: elite bros get only 1 talent / odd stats".
test("EF-KB5 legends: masters get one talent more than plain bros and higher attributes", function (t) {
    local plain = [], masters = [];
    ::EFT.with({selectMode = "none"}, function () { for (local i = 0; i < 30; i++) plain.push(::Tales.recruit()); });
    ::EFT.with({selectMode = "all"}, function () { for (local i = 0; i < 30; i++) masters.push(::Tales.recruit()); });
    t.eq(masters.filter(@(_, b) !::EFT.isMaster(b)).len(), 0, "all are masters");
    local pt = plain.map(@(b) ::Tales.talentCount(b)), mt = masters.map(@(b) ::Tales.talentCount(b));
    t.probe("plain talent counts", pt);
    t.probe("master talent counts", mt);
    t.eq(mt.filter(@(i, n) n != pt[0] + 1).len(), 0, "EF-KB5: every master has plain's talents + 1");
    local pm = means(plain), mm = means(masters);
    t.probe("plain means " + ATTRS.reduce(@(a, b) a + " " + b), pm);
    t.probe("master means", mm);
    t.eq(ATTRS.filter(@(i, a) mm[i] <= pm[i]), [], "EF-KB5: attributes where masters aren't higher on average");
});

// #9: EF's fillTalentValues wrapper forwards the caller's args; Legends' takes (_num, _force = false).
test("EF-KB9 legends: fillTalentValues through Elite Few's wrapper with 1 and 2 args", function (t) {
    local bro = ::EFT.with({selectMode = "all"}, @() ::Tales.recruit());
    local errs = [];
    foreach (args in [[3], [3, false], [2, true]]) {
        bro.m.Talents = [0, 0, 0, 0, 0, 0, 0, 0];
        local call = [bro];
        call.extend(args);  // a statement: 3.0's extend() returns null
        try { bro.fillTalentValues.acall(call); } catch (e) { errs.push([args, e]); }
    }
    t.eq(errs, [], "EF-KB9: errors");
    t.probe("talents after (2, true)", bro.m.Talents);
});

// #10: Legends gives Deathwish -3 Melee Defense (mod_legends/hooks/skills/traits/deathwish_trait.nut); masters
// exclude bad traits (master_trait.nut), not this one.
test("EF-KB10 legends: no master rolls Deathwish", function (t) {
    local n = 0, with = 0;
    ::EFT.with({selectMode = "all"}, function () {
        foreach (bg in ["farmhand_background", "sellsword_background", "militia_background", "brawler_background"])
            for (local i = 0; i < 150; i++) {
                local b = ::Tales.recruit(bg);
                n++;
                if (b.getSkills().hasSkill("trait.deathwish")) with++;
            }
    });
    local plain = 0;
    ::EFT.with({selectMode = "none"}, function () {
        for (local i = 0; i < 600; i++) if (::Tales.recruit("sellsword_background").getSkills().hasSkill("trait.deathwish")) plain++;
    });
    t.probe("plain bros with Deathwish of 600", plain);
    t.eq(with, 0, "EF-KB10: masters with Deathwish of " + n);
});
