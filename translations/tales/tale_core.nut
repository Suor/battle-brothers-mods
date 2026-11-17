// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_settlement_prices_tooltip==6 mod_hackflows_translations@dev mod_hooks stdlib@dev

// Russian for a third-party mod, through Rosetta switched on by hand (the game is English here).
local ru = function (_texts) {
    ::Rosetta.activate("ru");
    local ret = ::Rosetta.translateTooltip(_texts.map(@(s) {id = 1, type = "text", text = s})).map(@(e) e.text);
    ::Rosetta.activate(null);
    return ret;
};

test("Settlement Prices Tooltip lines in Russian", function (t) {
    t.eq(::Hooks.hasMod("mod_settlement_prices_tooltip"), true, "the target mod is loaded");
    local c = @(s) "[color=" + ::Const.UI.Color.NegativeValue + "]" + s + "[/color]";
    local range = " vs" + c(" [") + c("100") + "-" + c("130") + c("]");
    t.eq(ru(["Best buy in " + c("Hamburg"), "Buy price: " + c("120") + "%" + range]),
         ["Выгоднее купить в " + c("Hamburg"), "Цена покупки: " + c("120") + "%" + range], "translated");
});

// The "Buy/Sell price: <p:val_tag>%<tail:line>" patterns need the range part: with nothing after
// "%" Rosetta's `line` ([^\n]*(?:\n|$)) has to match empty at the string's end, which Squirrel's
// regexp never does (the same in the standalone interpreter), so the line stays English.
test("TR1: a price line without a range is translated too", function (t) {
    local c = @(s) "[color=" + ::Const.UI.Color.NegativeValue + "]" + s + "[/color]";
    t.eq(ru(["Buy price: " + c("120") + "%", "Sell price: " + c("80") + "%"]),
         ["Цена покупки: " + c("120") + "%", "Цена продажи: " + c("80") + "%"], "translated");
});
