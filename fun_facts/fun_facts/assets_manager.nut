local Debug = ::std.Debug, Util = std.Util;

::mods_hookNewObject("states/world/asset_manager", function (obj) {
    local consumeFood = obj.consumeFood;
    obj.consumeFood = function () {
        local d = this.Math.maxf(0.0, this.Time.getVirtualTimeF() - this.m.LastFoodConsumed);
        local factor = d * ::Const.World.TerrainFoodConsumption[::World.State.getPlayer().getTile().Type] 
            * this.m.FoodConsumptionMult * ::Const.World.Assets.FoodConsumptionMult;

        consumeFood();

        local roster = this.World.getPlayerRoster().getAll();
        foreach (bro in roster) {
             bro.m.FunFacts.onConsumeFood(bro.getDailyFood() * factor);
        }
    }
})
