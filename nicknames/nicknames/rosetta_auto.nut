if (!("Rosetta" in getroottable())) return;

local rosetta = {
    mod = {id = "mod_nicknames", version = "0.1"}
    author = "hackflow"
    lang = "ru"
}
local pairs = [];
foreach (entry in ::Nicknames.Titles) {
    local names = "names" in entry ? entry.names : [{en = entry.en, ru = entry.ru}];
    foreach (name in names)
        pairs.push({en = name.en, ru = name.ru});
}

::Rosetta.add(rosetta, pairs);
