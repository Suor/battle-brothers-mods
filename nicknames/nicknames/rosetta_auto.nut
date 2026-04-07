if (!("Rosetta" in getroottable())) return;

local rosetta = {
    mod = {id = "mod_nicknames", version = "0.1"}
    author = "hackflow"
    lang = "ru"
}
local pairs = [];
foreach (entry in ::Nicknames.Titles)
    pairs.push({en = entry.en, ru = entry.ru});

::Rosetta.add(rosetta, pairs);
