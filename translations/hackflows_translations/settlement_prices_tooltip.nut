if (!("Rosetta" in getroottable())) return;
if (::Hooks.SQClass.ModVersion(::Rosetta.Version) < ::Hooks.SQClass.ModVersion("0.4.0")) return;

local rosetta = {
    mod = {id = "mod_settlement_prices_tooltip", version = 6}
    author = "hackflow"
    lang = "ru"
}
local pairs = [
    // FILE: scripts/!mods_preload/mod_settlement_prices_tooltip.nut
    // en = "Settlement prices tooltip"  // mod registration name, not user-facing
    // en = " vs<blue( [) + colorizeLeft(getMin(numbers))>-<colorizeRight(getMax(numbers)) + blue(])>"  // sub-expression, intercepted as part of buy/sell price strings
    {
        // text = "Buy price: " + colorizeBuy(buy) + "%" + getRangeString(buyPrices, true)
        mode = "pattern"
        en = "Buy price: <p:val_tag>%<tail:line>"
        ru = "Цена покупки: <p>%<tail>"
    }
    {
        // text = "Best buy in " + blue(bestBuySettlement)
        mode = "pattern"
        en = "Best buy in <name:str_tag>"
        ru = "Выгоднее купить в <name>"
    }
    {
        // text = "Sell price: " + colorizeSell(sell) + "%" + getRangeString(sellPrices)
        mode = "pattern"
        en = "Sell price: <p:val_tag>%<tail:line>"
        ru = "Цена продажи: <p>%<tail>"
    }
    {
        // text = "Best sell in " + blue(bestSellSettlement)
        mode = "pattern"
        en = "Best sell in <name:str_tag>"
        ru = "Выгоднее продать в <name>"
    }
]
::Rosetta.add(rosetta, pairs);
