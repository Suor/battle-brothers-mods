if (!("Rosetta" in getroottable())) return;

local rosetta = {
    mod = {id = "mod_standout_enemies", version = 1.2}
    author = "hackflow"
    lang = "ru"
}
local pairs = [
    // FILE: scripts/!mods_preload/mod_standout_enemies.nut
    // {
    //     en = "Standout Enemies"
    //     ru = "Выдающиеся враги"
    // }
    // {
    //     en = "Goblin Skirmisher"
    //     ru = "Гоблин-застрельщик"
    // }
    // {
    //     en = "Goblin"
    //     ru = "Гоблин"
    // }
    // {
    //     en = "Goblin Wolfrider"
    //     ru = "Гоблин-волкогон"
    // }
    // {
    //     en = "Wolfrider"
    //     ru = "Волкогон"
    // }
    // {
    //     en = "Orc Berserker"
    //     ru = "Орк-берсерк"
    // }
    // {
    //     en = "Berserker"
    //     ru = "Берсерк"
    // }
    // {
    //     en = "Brigand Raider"
    //     ru = "Разбойник-налётчик"
    // }
    // {
    //     en = "Raider"
    //     ru = "Налётчик"
    // }
    // {
    //     en = "Nomad Outlaw"
    //     ru = "Кочевник-изгой"
    // }
    // {
    //     en = "Outlaw"
    //     ru = "Изгой"
    // }
    // {
    //     en = "Fallen Hero"
    //     ru = "Падший герой"
    // }
    // {
    //     en = "Hero"
    //     ru = "Герой"
    // }
    // {
    //     en = "Barbarian Chosen"
    //     ru = "Избранный варвар"
    // }
    // {
    //     en = "Chosen"
    //     ru = "Избранный"
    // }
    // {
    //     en = "Barbarian Reaver"
    //     ru = "Варвар-грабитель"
    // }
    // {
    //     en = "Reaver"
    //     ru = "Грабитель"
    // }
    // {
    //     en = "Barbarian Thrall"
    //     ru = "Варвар-раб"
    // }
    // {
    //     en = "Thrall"
    //     ru = "Раб"
    // }
    // {
    //     en = "Ancient "
    //     ru = "Древний "
    // }
    {
        mode = "pattern"
        en = "Agile <s:str>"
        ru = "Проворный <s>"
    }
    {
        mode = "pattern"
        en = "Huge <s:str>"
        ru = "Огромный <s>"
    }
    {
        mode = "pattern"
        en = "Fearless <s:str>"
        ru = "Бесстрашный <s>"
    }
    {
        mode = "pattern"
        en = "Furious <s:str>"
        ru = "Яростный <s>"
    }
    {
        mode = "pattern"
        en = "Dreadful <s:str>"
        ru = "Ужасный <s>"
    }
    {
        mode = "pattern"
        en = "<s:str>Headshot"
        ru = "<s>Меткач"
    }
    {
        mode = "pattern"
        en = "<s:str>Quickshot"
        ru = "<s>Быстрострел"
    }
    {
        mode = "pattern"
        en = "Sly <s:str>"
        ru = "Хитрый <s>"
    }
    {
        mode = "pattern"
        en = "Stubborn <s:str>"
        ru = "Упрямый <s>"
    }
    {
        mode = "pattern"
        en = "Masterwork <s:str>"
        ru = "<s> Шедевр"
    }
    {
        mode = "pattern"
        en = "Skilled <s:str>"
        ru = "Умелый <s>"
    }
    {
        mode = "pattern"
        en = "Cursed <s:str>"
        ru = "Проклятый <s>"
    }
    // {
    //     mode = "pattern"
    //     en = "<item.getName()> value=<item.m.Value>"
    //     ru = "<item.getName()> value=<item.m.Value>"
    // }
    // FILE: scripts/skills/cursed_effect.nut
    // {
    //     mode = "pattern"
    //     en = " (x<this.m.Count>)"
    //     ru = " (x<this.m.Count>)"
    // }
    {
        plural = "turns"
        en = "This character is cursed. His ability to attack and defend decreased. The effect will slowly wear off over <turns:int_tag> more turn(s)."
        n1 = "Этот персонаж проклят. Его способность атаковать и защищаться снижена. Эффект выветриться в течение <turns> хода."
        n2 = "Этот персонаж проклят. Его способность атаковать и защищаться снижена. Эффект выветриться в течение <turns> ходов."
        n5 = "Этот персонаж проклят. Его способность атаковать и защищаться снижена. Эффект выветриться в течение <turns> ходов."
    }
    // TODO: move this to common pack
    {
        mode = "pattern"
        en = "<bonus:str_tag> Melee Skill"
        ru = "<bonus> к навыку ближнего боя"
    }
    {
        mode = "pattern"
        en = "<bonus:str_tag> Ranged Skill"
        ru = "<bonus> к навыку дальнего боя"
    }
    {
        mode = "pattern"
        en = "<bonus:str_tag> Melee Defense"
        ru = "<bonus> к защите в ближнем бою"
    }
    {
        mode = "pattern"
        en = "<bonus:str_tag> Ranged Defense"
        ru = "<bonus> к защите в дальнем бою"
    }
    {
        mode = "pattern"
        en = "<actor:str_tag> is unaffected by the curse thanks to his unnatural physiology"
        ru = "<actor> не подвержен проклятию благодаря своей противоестественной природе"
    }
    {
        mode = "pattern"
        en = "<actor:str_tag> is cursed"
        ru = "<actor> проклят"
    }
    // FILE: scripts/skills/cursed_skill.nut
    {
        en = "Spreads curses, weakening everybody around"
        ru = "Распространяет проклятия, ослабляя всех вокруг"
    }
]
::Rosetta.add(rosetta, pairs);

::std.Table.extend(::StandoutEnemies.Config.ShortNames, {
    "Гоблин-налётчик": "Гоблин"
    "Восставший из мёртвых": "Восставший"
    "Орк-берсерк": "Берсерк"
    "Варвар-избранный": "Избранный"
    "Павший герой": "Герой"
    // "Goblin Wolfrider": "Wolfrider",
    // "Nomad Outlaw": "Outlaw",
    // "Barbarian Reaver": "Reaver",
    // "Barbarian Thrall": "Thrall",
})
