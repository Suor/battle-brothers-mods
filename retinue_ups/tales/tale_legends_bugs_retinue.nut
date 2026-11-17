// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_legends==19.4.23 mod_retinue_ups@dev stdlib@dev

// Retinue Promotions on real Legends 19.4.23 (unsupported by the mod). Legends replaces retinue_manager's
// setFollower and onDeserialize per instance (mods_hookNewObject), which shadows the mod's class-level hooks.

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
local function slots() { return R().m.Slots.map(@(f) f == null ? null : f.getID()); }

// Legends drops a follower whose requirements aren't met (its "retinue brother lost" event, answered by
// Autoplay after the load): the trader needs 25 trade goods sold and a Peddler-like bro.
local function enableTrader() {
    ::World.Statistics.getFlags().set("TradeGoodsSold", 25);
    local bro = ::World.getPlayerRoster().create("scripts/entity/tactical/player");
    bro.setStartValuesEx(["peddler_background"]);
}

// KNOWN_BUGS retinue_ups #2 (Legends): promotions revert after loading a save.
test("RU-KB2 legends: a promotion survives save and load", function (t) {
    enableTrader();
    local f = hire(0, "follower.trader");
    R().ru_promote(f);
    t.eq(state(f), {cost = 10500, effects = 2, hasBase = true, promoted = true}, "promoted before the save");
    t.probe("slots before", slots());
    t.eq(f.isEnabled(), true, "trader enabled by Legends' requirements");
    t.save("ru_kb2_legends");
    yield t.load("ru_kb2_legends");
    local g = R().getFollower("follower.trader");
    t.probe("slots after", slots());
    t.probe("same follower object", f == g);
    t.probe("onDeserialize source", R().onDeserialize.getinfos().src);
    t.eq(state(g), {cost = 10500, effects = 2, hasBase = true, promoted = true}, "trader after the load");
});

test("RU-L1: replacing a promoted follower under Legends demotes it", function (t) {
    local f = hire(1, "follower.cook");
    R().ru_promote(f);
    hire(1, "follower.scout");
    t.probe("setFollower source", R().setFollower.getinfos().src);
    t.eq([state(f).promoted, state(f).hasBase], [false, false], "the replaced cook: [promoted, ru_base]");
});
