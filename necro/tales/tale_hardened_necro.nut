// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_hardened==1.26.3 mod_necro@dev mod_hooks stdlib@dev

// Skipped report "Hardened breaks perks" (no log), checked on Reforged 0.9.3 + Hardened 1.26.3:
// a necromancer bro can learn every necro perk.

test("NE-HD: a necromancer under Hardened unlocks every necro perk", function (t) {
    local bro = ::World.getPlayerRoster().create("scripts/entity/tactical/player");
    bro.setStartValuesEx(["necro_background"]);
    local got = [];
    foreach (perk in ::Const.Perks.Necro) {
        bro.m.PerkPoints = 1;
        got.push([perk.ID, bro.unlockPerk(perk.ID) && bro.getSkills().hasSkill(perk.ID)]);
    }
    t.eq(got, ::Const.Perks.Necro.map(@(p) [p.ID, true]), "[perk, unlocked]");
    t.eq(bro.getSkills().hasSkill("actives.raise_undead"), true, "can raise");
    ::World.getPlayerRoster().remove(bro);
});
