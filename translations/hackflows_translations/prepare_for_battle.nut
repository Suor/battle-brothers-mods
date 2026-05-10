if (!("Rosetta" in getroottable())) return;
if (::Hooks.SQClass.ModVersion(::Rosetta.Version) < ::Hooks.SQClass.ModVersion("0.4.0")) return;

local rosetta = {
    mod = {id = "mod_prepare_for_battle", version = "1.0.1"}
    author = "hackflow"
    lang = "ru"
}
local pairs = [
    // FILE: scripts/!mods_preload/mod_prepare_for_battle.nut
    {
        en = "Prepare For Battle"
        ru = "Подготовка к бою"
    }
    {
        en = "Main"
        ru = "Основное"
    }
    {
        en = "Show Prepare For Battle When Ambushed"
        ru = "Показывать кнопку при засаде"
    }
    {
        en = "Shows the prepare for battle button even when ambushed."
        ru = "Кнопка подготовки к бою показывается даже при засаде."
    }
]
::Rosetta.add(rosetta, pairs);
