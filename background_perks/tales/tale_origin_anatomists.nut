// mode: campaign seed=bbtest-battle origin=scenario.anatomists
// mods: mod_background_perks@dev mod_hooks mod_msu stdlib@dev

// BP-KB1: the campaign starts with this origin and every starting bro gets his free perk roll.

beforeCampaign(function () {
    ::BPT_Rolled <- [];
    local give = ::BgPerks.giveFreePerks;
    ::BgPerks.giveFreePerks = function (_player) { ::BPT_Rolled.push(_player.getName()); return give(_player); };
});

test("BP-KB1: scenario.anatomists starts, starting bros rolled", function (t) {
    local names = t.roster().map(@(b) b.getName());
    local rolled = clone ::BPT_Rolled;
    names.sort(); rolled.sort();
    t.eq(rolled, names, "bros rolled for perks");
    t.probe("perks", t.roster().map(@(b) b.getSkills().query(::Const.SkillType.Perk).len()));
});
