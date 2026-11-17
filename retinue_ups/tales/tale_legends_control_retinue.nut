// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_legends==19.4.23 stdlib@dev

// Control for tale_legends_bugs_retinue.nut: Legends without Retinue Promotions keeps a hired follower over a load.

local R = @() ::World.Retinue;
local function slots() { return R().m.Slots.map(@(f) f == null ? null : f.getID()); }

// Legends drops a follower whose requirements aren't met (its "retinue brother lost" event, answered by
// Autoplay after the load): the trader needs 25 trade goods sold and a Peddler-like bro.
local function enableTrader() {
    ::World.Statistics.getFlags().set("TradeGoodsSold", 25);
    local bro = ::World.getPlayerRoster().create("scripts/entity/tactical/player");
    bro.setStartValuesEx(["peddler_background"]);
}

test("control: a hired trader stays in his slot over save and load", function (t) {
    enableTrader();
    R().setFollower(0, R().getFollower("follower.trader"));
    t.save("ru_control");
    yield t.load("ru_control");
    t.eq(slots(), ["follower.trader", null, null, null, null], "slots after the load");
});
