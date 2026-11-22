// mode: campaign seed=bbtest-battle
// mods: mod_AC@dev mod_msu !stdlib
// include: lib/helpers.nut

// KNOWN_BUGS #3 (fixed in 2.1): without stdlib, Tame failed with `the index 'std' does not exist`.

test("AC-KB3: Tame's hit chance without stdlib", function (t) {
    t.eq("std" in getroottable(), false, "no stdlib");
    ::Tales.toughen();
    local id = t.state.id <- t.roster()[0].getID(), out = t.state.out <- {};
    yield t.battle({spawn = "BanditRaiders", resources = 40, player = ::Tales.scripted([function (t) {
        local bro = ::Tactical.getEntityByID(t.state.id);
        local out = t.state.out;
        local tile = ::Tales.freeNear(bro);
        local wolf = ::Tales.spawn("scripts/entity/tactical/enemies/direwolf", tile,
            ::World.FactionManager.getFactionOfType(::Const.FactionType.Beasts).getID());
        local tame = bro.getSkills().getSkillByID("actives.companions_tame");
        out.chance <- typeof tame.getHitchance(wolf);
        out.verify <- tame.onVerifyTarget(bro.getTile(), tile);
    }], @(t) ::Tactical.getEntityByID(t.state.id))});
    t.eq([out.chance, out.verify], ["float", true], "[chance type, verify]");
});
