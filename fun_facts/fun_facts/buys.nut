// Tracks per-unit buy prices for supplies so TCO uses real numbers
// instead of hardcoded fallbacks.
::FunFacts.Buys <- {
    Stats = {
        Food  = {Amount = 0.0, Spent = 0}
        Ammo  = {Amount = 0,   Spent = 0}
        Parts = {Amount = 0,   Spent = 0}
        Herbs = {Amount = 0,   Spent = 0}
    }

    function getAvgPrice(_kind, _fallback) {
        if (!(_kind in this.Stats)) return _fallback;
        local b = this.Stats[_kind];
        return b.Amount > 0 ? b.Spent.tofloat() / b.Amount : _fallback;
    }

    function record(_kind, _amount, _price) {
        local b = this.Stats[_kind];
        b.Amount += _amount;
        b.Spent  += _price;
        ::FunFacts.Debug.log("buy " + _kind, format("+%g @ %d, avg %.2f over %g",
            _amount.tofloat(), _price, b.Spent.tofloat() / b.Amount, b.Amount.tofloat()));
    }

    function pack(_flags) {
        ::std.Flags.pack(_flags, "FunFactsBuys", this.Stats);
    }

    function unpack(_flags) {
        try {
            local stats = ::std.Flags.unpack(_flags, "FunFactsBuys");
            if (stats) ::std.Table.extend(this.Stats, stats);
        } catch (err) {
            ::logError("Failed to load FunFacts.Buys: " + err);
        }
    }
}

local function makeHook(_kind) {
    return function (o) {
        local setBought = ::mods_getMember(o, "setBought");
        o.setBought <- function (_f) {
            setBought(_f);
            if (_f && this.m.Amount > 0
                && ("State" in this.World) && this.World.State != null
                && this.World.State.getCurrentTown() != null)
            {
                ::FunFacts.Buys.record(_kind, this.m.Amount, this.getBuyPrice());
            }
        }
    }
}

// food_item is the base for all food (smoked_ham, dried_fish, ...). None of
// the children override setBought, so adding it here covers them all.
::mods_hookExactClass("items/supplies/food_item",        makeHook("Food"));
::mods_hookExactClass("items/supplies/ammo_item",        makeHook("Ammo"));
::mods_hookExactClass("items/supplies/armor_parts_item", makeHook("Parts"));
::mods_hookExactClass("items/supplies/medicine_item",    makeHook("Herbs"));
