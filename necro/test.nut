dofile(getenv("STDLIB_DIR") + "load.nut", true);
dofile("mocks.nut", true);
dofile("necro/rosetta.nut", true);

local Util = ::std.Util, Debug = ::std.Debug;

function assertEq(a, b) {
    if (Util.deepEq(a, b)) return;
    throw "assertEq failed:\na = " + Debug.pp(a) + "b = " + Debug.pp(b);
}
function assertTr(_en, _ru) {assertEq(::Rosetta.translate(_en), _ru)}

local def = ::Rosetta;
local rosetta = {
    mod = "mod_necro"
    lang = "ru"
    version = "0.3.0"
}
function setup(_pair) {
    def.maps = {};
    def.add(rosetta, [_pair]);
}

// Pattern tests
assertEq(def.parsePattern("Has a range of <range:int>"),
        {labels = ["range"], re = @"^Has a range of ([+\-]?\d+)$"});
assertEq(def.parsePattern("Has a range of <range:int> tiles"),
        {labels = ["range"], re = @"^Has a range of ([+\-]?\d+) tiles$"});
assertEq(def.parsePattern("range <open:tag><range:int><close:tag>"),
        {labels = ["open", "range", "close"], re = @"^range (\[[^\]]+\])([+\-]?\d+)(\[[^\]]+\])$"});
assertEq(def.parsePattern("Has a range of <range:int_tag> tiles"),
        {labels = ["range"], re = @"^Has a range of (\[[^\]]+\][+\-]?\d+\[/[^\]]+\]) tiles$"});
assertEq(def.parsePattern("<range:int> tiles"),
        {labels = ["range"], re = @"^([+\-]?\d+) tiles$"});
assertEq(def.parsePattern("1 ... <range:int>"),
        {labels = ["range"], re = @"^1 \.\.\. ([+\-]?\d+)$"});

// Translate via pattern
setup({
    mode = "pattern"
    en = "Has a range of <range:int> tiles"
    ru = "Дальность <range> клеток"
})
assertTr("Has a range of 5 tiles", "Дальность 5 клеток");

setup({
    mode = "pattern"
    en = "Has a range of <open:tag><range:int><close:tag> tiles"
    ru = "Дальность <open><range><close> клеток"
})
assertTr("Has a range of [b]5[/b] tiles", "Дальность [b]5[/b] клеток");

setup({
    mode = "pattern"
    en = "Has a range of <range:int_tag> tiles"
    ru = "Дальность <range> клеток"
})
assertTr("Has a range of [b]5[/b] tiles", "Дальность [b]5[/b] клеток");
assertTr("it Has a range of [b]5[/b] tiles", "it Has a range of [b]5[/b] tiles"); // prefix
assertTr("Has a range of [b]5[/b] tiles.", "Has a range of [b]5[/b] tiles."); // suffix

// plurals
setup({
    plural = "range"
    en = "Has a range of <range:int> tiles"
    n1 = "Дальность - <range> клетка"
    n2 = "Дальность - <range> клетки"
    n5 = "Дальность - <range> клеток"
})
assertTr("Has a range of 1 tiles", "Дальность - 1 клетка");
assertTr("Has a range of 31 tiles", "Дальность - 31 клетка");
assertTr("Has a range of 23 tiles", "Дальность - 23 клетки");
assertTr("Has a range of 5 tiles", "Дальность - 5 клеток");
assertTr("Has a range of 14 tiles", "Дальность - 14 клеток");

setup({
    plural = "range"
    en = "Has a range of <range:int_tag> tiles"
    n1 = "Дальность - <range> клетка"
    n2 = "Дальность - <range> клетки"
    n5 = "Дальность - <range> клеток"
})
assertTr("Has a range of [b]4[/b] tiles", "Дальность - [b]4[/b] клетки");

// Reverse labels and no proper contenKey
setup({
    mode = "pattern"
    en = "<x:int> and <y:int>"
    ru = "<y> и <x>"
})
assertTr("11 and 22", "22 и 11");

// This won't work - a key oin original text will be Some2, so no partial word labeling!
// setup({
//     mode = "pattern"
//     en = "Some<x:int>"
//     ru = "Типа<x>"
// })
// assertTr("Some2", "Типа2");

// Label match as a potential contentKey
setup({
    mode = "pattern"
    en = "<name:word> says hello"
    ru = "<name> передаёт привет"
})
assertTr("Yarg says hello", "Yarg передаёт привет");
assertTr("Йарг says hello", "Йарг передаёт привет"); // Check matching non-english words


// setup(
//     {  // FIX
//         mode = "pattern"
//           // "Master raising undead. Use [color=#135213]4 AP[/color] and [color=#135213]25%[/color] less fatigue to raise."
//         en = "Master raising undead. Use <open:tag><ap:int> AP<close:tag> and <fat:str_tag> less fatigue to raise."
//         ru = "Мастер поднятия нежити. Тратит только <open><ap> ОД<close> и на <fat> меньше выносливости для поднятия мертвецов."
//     }
// )
// assertTr("Master raising undead. Use [color=#135213]4 AP[/color] and [color=#135213]25%[/color] less fatigue to raise.", "")


// TODO: test missing labels, dup labels, no type

// // Repeating labels and no contentKey in pattern, string contentKey == 10 !!!!
// setup({
//     mode = "pattern"
//     en = "<n:int> and <n:int>"
//     ru = "...<n>..."
// })
// assertTr("10 and 20", "");

print("Tests OK\n");
