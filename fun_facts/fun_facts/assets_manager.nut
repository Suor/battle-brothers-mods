local Debug = ::std.Debug, Util = std.Util;

::mods_hookNewObject("states/world/asset_manager", function (obj) {
    local function freshFood(_assets) {
        local now = ::Time.getVirtualTimeF(), amount = 0.0;
        foreach (item in _assets.m.Stash.getItems()) {
            if (item != null && item.isItemType(::Const.Items.ItemType.Food) && now < item.getBestBeforeTime())
                amount += item.getAmount();
        }
        return amount;
    }

    local consumeFood = obj.consumeFood;
    obj.consumeFood = function () {
        // Vanilla eats nothing when not using provisions and no more than the stash holds
        local before = freshFood(this);
        consumeFood();
        local eaten = before - freshFood(this);

        local roster = this.World.getPlayerRoster().getAll();
        local daily = 0.0;
        foreach (bro in roster) daily += bro.getDailyFood();
        if (eaten <= 0 || daily <= 0) return;
        foreach (bro in roster) {
             bro.m.FunFacts.onConsumeFood(bro.getDailyFood() * eaten / daily);
        }
    }
})
