// mode: campaign seed=bbtest-battle origin=scenario.legends_beggar
// mods: mod_legends==19.4.23 mod_background_perks@dev stdlib@dev
// allow-errors: Mod mod_background_perks .* is wrapping function setStartValuesEx in bb class scripts/entity/tactical/player with fewer total parameters

// KNOWN_BUGS background_perks #3: endless map generation for this Legends origin (a hang = launch timeout).

test("BP-KB3: scenario.legends_beggar starts", function (t) {
    t.eq(::World.Assets.getOrigin().getID(), "scenario.legends_beggar", "origin");
    t.probe("roster", t.roster().map(@(b) [b.getBackground().getID(), b.getSkills().query(::Const.SkillType.Perk).len()]));
});
