// mode: campaign seed=bbtest-battle fresh=1
// mods: sato_balance_mod==2.3.1 mod_hackflows_perks@dev mod_hooks mod_msu stdlib@dev

// KNOWN_BUGS #2: with Sato's Balance Mod 2.3.1 (compiled .cnut). Sato
// patches perk tooltips by fixed tree positions (`::Const.Perks.Perks[4][2]` must be Lone Wolf, `[5][2]` Nimble).

test("Sato's mod is loaded", function (t) {
    t.eq([::Hooks.hasMod("sato_balance_mod"), ::Hooks.hasMod("mod_hackflows_perks")], [true, true], "mods");
    t.probe("row 4", ::Const.Perks.Perks[4].map(@(p) p.ID));
});

test("HP-KB2: Sato's Lone Wolf and mastery texts survive the added perks", function (t) {
    local L = ::Const.Perks.LookupMap, S = ::Const.Strings.PerkDescription;
    t.eq([L["perk.lone_wolf"].Tooltip == S.LoneWolf, L["perk.nimble"].Tooltip == S.Nimble,
          L["perk.mastery.sword"].Tooltip == S.SpecSword, L["perk.mastery.dagger"].Tooltip == S.SpecDagger],
        [true, true, true, true], "[Lone Wolf, Nimble, Sword Mastery, Dagger Mastery] show Sato's texts");
    t.eq(S.LoneWolf.find("2 tiles") != null, true, "Sato's Lone Wolf text is in place");
});
