local def = ::Challenges, mod = def.mh;

// Settings
def.add(::MSU.Class.SettingsDivider("costsDiv"));
def.add(::MSU.Class.SettingsTitle("costsTitle", "Costs"));
def.add(::Challenges.SliderSetting("foodPriceMult", 1,
    [1, 2, 3, 5, 10, 20],
    ["1x" "2x" "3x" "5x" "10x" "20x"],
    "Food Price Multiplier",
    "Multiply the price of all food items by this amount."));
def.add(::Challenges.SliderSetting("wageMult", 1,
    [1, 2, 3, 5, 10],
    ["1x" "2x" "3x" "5x" "10x"],
    "Wages Multiplier",
    "Multiply daily wages of all brothers by this amount."));

// Hooks

// Food: hook food_item price.
mod.hook("scripts/items/food/food_item", function (q) {
    q.getValue = @(__original) function () {
        return ::Math.floor(__original() * def.conf("foodPriceMult"));
    }
})

// Wages: multiply every bro's daily cost.
mod.hook("scripts/entity/tactical/player", function (q) {
    q.getDailyCost = @(__original) function () {
        return ::Math.floor(__original() * def.conf("wageMult"));
    }
})
