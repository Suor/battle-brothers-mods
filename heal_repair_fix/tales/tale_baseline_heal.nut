// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_hooks mod_msu stdlib@dev
// include: lib/measure.nut

// Baseline without the mod, vanilla 1.5.2: Math.round in setHitpoints turns camping's 1.5 into 2; improveCondition keeps fractions, so repairs need no fix.
// Vanilla 1.5.2 changed the followers since the README's tables: the cook adds +1 hp/hour,
// the blacksmith x1.2 repair speed (was x1.33 for both).

test("baseline: camping, no cook: hp per hour", function (t) {
    local s = ::HRF.start(t, true, null);
    yield ::HRF.hours(t, 24);
    local r = ::HRF.rates(t, s);
    t.near(r.hp, 2, 0.15, "hp/hour");
});

test("baseline: camping, cook: hp per hour", function (t) {
    local s = ::HRF.start(t, true, "follower.cook");
    yield ::HRF.hours(t, 24);
    local r = ::HRF.rates(t, s);
    t.near(r.hp, 3, 0.15, "hp/hour");
});

test("baseline: blacksmith: armor per hour", function (t) {
    local s = ::HRF.start(t, false, "follower.blacksmith");
    yield ::HRF.hours(t, 24);
    local r = ::HRF.rates(t, s);
    t.near(r.armor, 3.6, 0.05, "armor/hour");
});

test("baseline: camping, blacksmith: armor per hour", function (t) {
    local s = ::HRF.start(t, true, "follower.blacksmith");
    yield ::HRF.hours(t, 24);
    local r = ::HRF.rates(t, s);
    t.near(r.armor, 5.4, 0.05, "armor/hour");
});
