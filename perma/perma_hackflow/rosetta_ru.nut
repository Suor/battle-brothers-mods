if (!("Rosetta" in getroottable())) return;

local def = ::PermaHackflow;
local rosetta = {
    mod = {id = def.ID, version = def.Version}
    author = "hackflow"
    lang = "ru"
}
local pairs = [
    // FILE: perma_hackflow/hooks/missing_finger_injury.nut
    {
        en = "May drop shield or weapon on shield hit"
        ru = "Может уронить щит при ударе по нему или оружие при ударе по щиту"
    }
    // FILE: scripts/!mods_preload/mod_perma_hackflow.nut
    {
        en = "Hackflows's Permanent Injuries"
        ru = "Увечья от Hackflow"
    }
    {
        // ::Const.UI.getColorizedEntityName(_attacker) + "'s weapon slips from his fingers");
        mode = "pattern"
        en = "<name:str_tag>'s weapon slips from his fingers"
        ru = "<name> роняет оружие, оно выскользнуло из его пальцев"
    }
    {
        // ::Const.UI.getColorizedEntityName(actor) + "'s shield slips from his fingers");
        mode = "pattern"
        en = "<name:str_tag>'s shield slips from his fingers"
        ru = "<name> роняет щит, он выскользнул из его пальцев"
    }
]
::Rosetta.add(rosetta, pairs);
