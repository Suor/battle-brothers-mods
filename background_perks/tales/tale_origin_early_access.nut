// mode: campaign seed=bbtest-battle origin=scenario.early_access fresh=0
// mods: mod_background_perks@dev mod_hooks mod_msu stdlib@dev

// BP-KB1: the campaign starts with this origin and every starting bro gets his free perk roll.
// fresh=0: a launch of its own, as the rolls are recorded at the campaign start and other files' tests would add theirs.

beforeCampaign(function () {
    ::BPT_Rolled <- [];
    local give = ::BgPerks.giveFreePerks;
    ::BgPerks.giveFreePerks = function (_player) { ::BPT_Rolled.push(_player.getName()); return give(_player); };
});

test("BP-KB1: scenario.early_access starts, starting bros rolled", function (t) {
    local names = t.roster().map(@(b) b.getName());
    local rolled = clone ::BPT_Rolled;
    names.sort(); rolled.sort();
    t.eq(rolled, names, "bros rolled for perks");
    t.probe("perks", t.roster().map(@(b) b.getSkills().query(::Const.SkillType.Perk).len()));
});
