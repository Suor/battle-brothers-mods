if (!("Rosetta" in getroottable())) return;

local rosetta = {
    mod = {id = "mod_fixes", version = "0.5.0"}
    author = "hackflow"
    lang = "ru"
}
local pairs = [
    // FILE: scripts/!mods_preload/mod_fixes.nut
    {
        en = "Hackflow's Fixes"
        ru = "Фиксы от Hackflow"
    }
        // en = "<!isKindOf(item, , , ammo)&&!isKindOf(item, , , weapon)>"
    {
        // ret.top().text += format("\n\nShort of %s ammo to refill.",
        //                          ::std.Text.negative(ammoReq));
        mode = "pattern"
        en = "<prefix:str>\n\nShort of <n:int_tag> ammo to refill."
        ru = "<prefix>\n\nНе хватает <n> боеприпасов для полного пополнения."
    }
    {
        mode = "pattern"
        en = "Total fatigue of armor weared is <fat:int_tag>"
        ru = "Суммарный штраф от брони <fat>"
    }
]
::Rosetta.add(rosetta, pairs);
