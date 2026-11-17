// mode: campaign seed=bbtest-battle fresh=1
// mods: sato_balance_mod==2.3.1 mod_hooks mod_msu stdlib@dev

// Control for tale_sato.nut: Sato's Balance Mod alone sets its Lone Wolf and Nimble texts.

test("Sato alone: Lone Wolf shows Sato's text", function (t) {
    local L = ::Const.Perks.LookupMap, S = ::Const.Strings.PerkDescription;
    t.eq([L["perk.lone_wolf"].Tooltip == S.LoneWolf, L["perk.nimble"].Tooltip == S.Nimble], [true, true], "[Lone Wolf, Nimble]");
});
