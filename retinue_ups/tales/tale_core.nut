// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_retinue_ups@dev mod_hooks mod_msu stdlib@dev

// Promotions through the campfire screen's handler, their effects, and how they survive
// replacing a follower and loading saves. Bug tests are named RU-KB<n> after KNOWN_BUGS.md.

local R = @() ::World.Retinue;
local function hire(_slot, _id) {
    local f = ::World.Retinue.getFollower(_id);
    ::World.Retinue.setFollower(_slot, f);
    return f;
}
local function state(_f) {
    return {cost = _f.m.Cost, effects = _f.m.Effects.len(), hasBase = "ru_base" in _f.m,
            promoted = ::World.Retinue.ru_isPromoted(_f)};
}
local function campfire() { return ::World.State.m.CampfireScreen; }

test("promote through the campfire handler", function (t) {
    local f = hire(0, "follower.trader");
    t.eq(state(f), {cost = 3500, effects = 1, hasBase = false, promoted = false}, "hired");
    local hint = f.getTooltip().top();
    t.eq(hint.type, "hint", "promotion hint in the tooltip");

    ::World.Assets.addMoney(-::World.Assets.getMoney() + 6999);
    t.eq(campfire().ru_onSlotCtrlClicked(0), {Result = ::Const.UI.Error.NotEnoughMoney}, "too poor");
    t.eq(state(f).promoted, false, "not promoted when poor");

    ::World.Assets.addMoney(1);
    t.eq(campfire().ru_onSlotCtrlClicked(0), {Result = 0}, "promoted");
    t.eq(::World.Assets.getMoney(), 0, "paid 7000");
    t.eq(state(f), {cost = 10500, effects = 2, hasBase = true, promoted = true}, "promoted state");
    t.eq(f.getName(), "The Trader (Promoted)", "name");
    t.eq(campfire().ru_onSlotCtrlClicked(0), {Result = 999}, "second click does nothing");
});

test("bounty hunter promotion raises the champion chance", function (t) {
    local f = hire(0, "follower.bounty_hunter");
    R().update();
    t.eq(::World.Assets.m.ChampionChanceAdditional, 3, "plain");
    R().ru_promote(f);
    R().update();
    t.eq(::World.Assets.m.ChampionChanceAdditional, 7, "promoted");
    t.eq(f.m.Effects[0].find("Greatly") != null, true, "effect text");
});

test("drill sergeant promotion trains new hires", function (t) {
    local f = hire(0, "follower.drill_sergeant");
    R().ru_promote(f);
    local bro = ::World.getPlayerRoster().create("scripts/entity/tactical/player");
    bro.setStartValuesEx(["farmhand_background"]);
    bro.onHired();
    local e = bro.getSkills().getSkillByID("effects.trained");
    t.eq(e == null ? null : [e.m.Duration, e.m.XPGainMult], [3, 1.7], "trained effect");
});

test("cook promotion drops one more food", function (t) {
    local f = hire(0, "follower.cook");
    local count = function () {
        local items = [];
        ::Math.seedRandom(7);
        ::World.getPlayerEntity().dropFood(1, ["bread_item"], items);
        return items.len();
    };
    local plain = count();
    R().ru_promote(f);
    t.eq([plain, count()], [1, 2], "food dropped plain, promoted");
});

test("replacing a promoted follower demotes it", function (t) {
    local smith = hire(2, "follower.blacksmith");
    local plain = clone smith.m.Effects;
    R().ru_promote(smith);
    t.eq(state(smith), {cost = 3000 + 3000, effects = plain.len() + 1, hasBase = true, promoted = true}, "promoted");
    local cook = hire(2, "follower.cook");
    t.eq(R().m.Slots[2] == cook, true, "cook in the slot");
    t.eq([smith.m.Cost, smith.m.Effects, R().ru_isPromoted(smith)], [3000, plain, false], "blacksmith demoted");
});

// RU2: ru_onDemote leaves m.ru_base behind, and ru_onPromote takes it for "already promoted".
test("RU2: a demoted follower promoted again gets the promotion again", function (t) {
    local smith = hire(2, "follower.blacksmith");
    local plain = smith.m.Effects.len();
    R().ru_promote(smith);
    hire(2, "follower.cook");
    hire(2, "follower.blacksmith");
    R().ru_promote(smith);
    t.eq(state(smith), {cost = 6000, effects = plain + 1, hasBase = true, promoted = true}, "promoted again");
});

// RU1: the UI sends ctrl-clicks on empty slots too; the handler logs follower.getID() before
// its null check.
test("RU1: ctrl-click on an empty slot does nothing", function (t) {
    t.eq(R().m.Slots[1], null, "slot 1 empty");
    t.eq(campfire().ru_onSlotCtrlClicked(1), {Result = 999}, "empty slot does nothing");
});

// RU-KB3 (fixed in 1.2.2): replacing a follower that was never promoted.
test("RU-KB3: replace a non-promotable follower", function (t) {
    hire(2, "follower.cartographer");
    local f = hire(2, "follower.blacksmith");
    t.eq(R().m.Slots[2] == f, true, "new one in the slot");
});

// RU-KB2: a promotion survives a save/load (here within the session: the engine can't restart).
test("RU-KB2: promotion survives save and load", function (t) {
    local f = hire(0, "follower.trader");
    R().ru_promote(f);
    t.save("ru_kb2");
    yield t.load("ru_kb2");
    local g = R().getFollower("follower.trader");
    t.eq(R().m.Slots[0] == g, true, "trader in slot 0");
    t.eq(state(g), {cost = 10500, effects = 2, hasBase = true, promoted = true}, "still promoted");
});

// RU-KB1: loading a save made before the promotion leaves the follower objects promoted.
test("RU-KB1: loading an older save undoes the promotion", function (t) {
    local f = hire(0, "follower.trader");
    t.save("ru_kb1");
    R().ru_promote(f);
    yield t.load("ru_kb1");
    local g = R().getFollower("follower.trader");
    t.probe("same follower object", f == g);
    t.eq(state(g), {cost = 3500, effects = 1, hasBase = false, promoted = false}, "trader after the load");
});
