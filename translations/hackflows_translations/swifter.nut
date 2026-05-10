if (!("Rosetta" in getroottable())) return;
if (::Hooks.SQClass.ModVersion(::Rosetta.Version) < ::Hooks.SQClass.ModVersion("0.4.0")) return;

local rosetta = {
    mod = {id = "mod_swifter", version = "1.1.3"}
    author = "hackflow"
    lang = "ru"
}
local pairs = [
    // FILE: scripts/!mods_preload/mod_swifter.nut
    // en = "Swifter"
    {
        en = "World Keybinds"
        ru = "Клавиши мира"
    }
    {
        en = "4x World Speed"
        ru = "4x скорость мира"
    }
    {
        en = "Combat Keybinds"
        ru = "Клавиши боя"
    }
    {
        en = "1x Combat Speed"
        ru = "1x скорость боя"
    }
    {
        en = "General"
        ru = "Основное"
    }
    {
        en = "Combat Speed"
        ru = "Скорость боя"
    }
    {
        en = "Increases the animation speed of all engagements."
        ru = "Увеличивает скорость анимации в бою."
    }
    {
        en = "Event Frequency"
        ru = "Частота событий"
    }
    {
        en = "Multiplies the frequency of Events by this value"
        ru = "Умножает частоту событий на заданное значение"
    }
    {
        en = "Magda Mode"
        ru = "Режим Магды"
    }
    {
        en = "Don't throw up!"
        ru = "Только держись!"
    }
    // FILE: swifter/tooltip_events.nut
    {
        // text = "Very Fast Speed (" + ::getModSetting(::Swifter.ID, "veryfastTime").getValue() + ")"
        mode = "pattern"
        en = "Very Fast Speed (<v:val>)"
        ru = "Очень быстро (<v>)"
    }
    {
        en = "Set time to pass much faster than normal. (4x Speed)"
        ru = "Время идёт намного быстрее обычного. (4x скорость)"
    }
    {
        // text = "Super Fast Speed (" + ::getModSetting(::Swifter.ID, "superfastTime").getValue() + ")"
        mode = "pattern"
        en = "Super Fast Speed (<v:val>)"
        ru = "Сверхбыстро (<v>)"
    }
    {
        en = "Set time to pass super quickly. (8x Speed)"
        ru = "Время идёт сверхбыстро. (8x скорость)"
    }
]
::Rosetta.add(rosetta, pairs);
