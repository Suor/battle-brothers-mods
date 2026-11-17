// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_heal_repair_fix@dev mod_msu stdlib@dev
// include: lib/measure.nut

// With the mod: camping heals the intended 1.5 per hour, not 2.
// Vanilla 1.5.2 changed the followers since the README's tables: the cook adds +1 hp/hour,
// the blacksmith x1.2 repair speed (was x1.33 for both).

test("core: camping, no cook: hp per hour", function (t) {
    local s = ::HRF.start(t, true, null);
    yield ::HRF.hours(t, 24);
    local r = ::HRF.rates(t, s);
    // stochastic rounding, its own unseeded generator: a day of +1/+2 hours varies by ~0.1
    t.near(r.hp, 1.5, 0.3, "hp/hour");
});

test("core: camping, cook: hp per hour", function (t) {
    local s = ::HRF.start(t, true, "follower.cook");
    yield ::HRF.hours(t, 24);
    local r = ::HRF.rates(t, s);
    t.near(r.hp, 3, 0.15, "hp/hour");
});

test("core: blacksmith: armor per hour", function (t) {
    local s = ::HRF.start(t, false, "follower.blacksmith");
    yield ::HRF.hours(t, 24);
    local r = ::HRF.rates(t, s);
    t.near(r.armor, 3.6, 0.05, "armor/hour");
});

test("core: camping, blacksmith: armor per hour", function (t) {
    local s = ::HRF.start(t, true, "follower.blacksmith");
    yield ::HRF.hours(t, 24);
    local r = ::HRF.rates(t, s);
    t.near(r.armor, 5.4, 0.05, "armor/hour");
});
