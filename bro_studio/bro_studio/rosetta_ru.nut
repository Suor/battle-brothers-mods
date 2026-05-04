if (!("Rosetta" in getroottable())) return;
if (::Hooks.SQClass.ModVersion(::Rosetta.Version) < ::Hooks.SQClass.ModVersion("0.3.0")) return;

local rosetta = {
    mod = {id = "mod_bro_studio", version = "1.2.0"}
    author = "hackflow"
    lang = "ru"
}
local pairs = [
    // FILE: bro_studio/attrs.nut
    {
        en = "Talents & Attrs"
        ru = "Таланты и хар-ки"
    }
    {
        en = "Minimum Talents"
        ru = "Минимум талантов"
    }
    {
        en = "A low bound on a number of talents each bro gets"
        ru = "Нижняя граница числа талантов у каждого бойца"
    }
    {
        en = "Maximum Talents"
        ru = "Максимум талантов"
    }
    {
        en = "A high bound on a number of talents each bro gets"
        ru = "Верхняя граница числа талантов у каждого бойца"
    }
    {
        en = "Talent Chance"
        ru = "Шанс таланта"
    }
    {
        en = "A bro will need to roll this chance to get each talent after minimum"
        ru = "После минимума боец получает каждый следующий талант с этим шансом"
    }
    {
        en = "relaxed"
        ru = "мягко"
    }
    {
        en = "strict"
        ru = "строго"
    }
    {
        en = "ignored"
        ru = "игнор"
    }
    {
        en = "Excluded Talents"
        ru = "Запретные таланты"
    }
    {
        // "How to treat background exclusions:\n\n" +
        // Text.negative("strict") + " - never get excluded talents,\n" +
        // Text.negative("relaxed") + " - get any other first, then may get excluded,\n" +
        // Text.negative("ignored") + " - completely ignore the excluded list."));
        mode = "pattern"
        en = "How to treat background exclusions:\n\n<o1:tag>strict<c1:tag> - never get excluded talents,\n<o2:tag>relaxed<c2:tag> - get any other first, then may get excluded,\n<o3:tag>ignored<c3:tag> - completely ignore the excluded list."
        ru = "Как учитывать запреты происхождения:\n\n<o1>строго<c1> - никогда не давать запретные таланты,\n<o2>мягко<c2> - сначала дать любые другие, потом можно запретные,\n<o3>игнор<c3> - полностью игнорировать список запретов."
    }
    {
        en = "Weighted Talents"
        ru = "Взвешенные таланты"
    }
    {
        // "Better chances to get talent in attributes favored by background. " +
        // "Plus higher chance to get 2 or 3 stars in those attributes too.\n\n" +
        // "The attributes not favored by background get talents rarer and " +
        en = "Better chances to get talent in attributes favored by background. Plus higher chance to get 2 or 3 stars in those attributes too.\n\nThe attributes not favored by background get talents rarer and have lower chance for 2 or 3 stars."
        ru = "Больше шансов получить талант в характеристиках, подходящих происхождению. И выше шанс получить там 2 или 3 звезды.\n\nВ неподходящих характеристиках таланты встречаются реже, а шанс на 2 или 3 звезды ниже."
    }
    {
        en = "Randomize Starting Talents"
        ru = "Случайные стартовые таланты"
    }
    {
        // "Some company origins have preset bros. " +
        en = "Some company origins have preset bros. If this is checked those will be rolled by Studio instead."
        ru = "У некоторых истоков отряда бойцы заданы заранее. Если включено, Studio перебросит их сама."
    }
    {
        en = "Attributes"
        ru = "Характеристики"
    }
    {
        en = "Attribute Ups"
        ru = "Подъёмы характеристик"
    }
    {
        en = "Amount of attribute bros allowed to raise each level-up"
        ru = "Сколько характеристик боец может поднять при повышении уровня"
    }
        // en = "35rem"
    {
        en = "Veteran Level for Attributes"
        ru = "Ветеранский уровень для хар-к"
    }
    {
        en = "off"
        ru = "выкл"
    }
    {
        en = "slight"
        ru = "слабый"
    }
    {
        en = "classic"
        ru = "классика"
    }
    {
        en = "high"
        ru = "высокий"
    }
    {
        en = "Veteran Boost"
        ru = "Ветеранский бонус"
    }
    {
        en = "Allow veterans to get more than 1 sometimes in talented attributes"
        ru = "Позволяет ветеранам иногда получать больше 1 в талантливых характеристиках"
    }
    // FILE: bro_studio/injuries.nut
    {
        en = "Injuries"
        ru = "Увечья"
    }
    {
        en = "1%"
        ru = "1%"
    }
    {
        en = "Permanent injury chance"
        ru = "Шанс увечья"
    }
    {
        en = "Newly recruited bros may come with a permanent injury and will be cheaper to hire"
        ru = "Новобранцы могут прийти с увечьем, зато нанять их будет дешевле"
    }
    // FILE: bro_studio/perks.nut
    {
        en = "Perks"
        ru = "Навыки"
    }
    {
        en = "Perks given each level"
        ru = "Навыков за уровень"
    }
    {
        en = "On levels from to 2 to Veteran Level, i.e. 10 times by default."
        ru = "На уровнях со 2-го до ветеранского, т.е. по умолчанию 10 раз."
    }
    {
        en = "Add a perk each N-th level"
        ru = "Доп. навык каждый N-й уровень"
    }
    {
        en = "Starting from but not including level 1 and not after the Veteran Level.\n\nE.g. veteran level 11, N=5: extra perk on levels 6 and 11."
        ru = "Начиная после 1-го уровня и не позже ветеранского.\n\nНапример, ветеранский уровень 11, N=5: доп. навыки на 6-м и 11-м."
    }
    {
        en = "Veterans"
        ru = "Ветераны"
    }
    {
        en = "Veteran Level for Perks"
        ru = "Ветеранский уровень для навыков"
    }
    {
        en = "Add a perk each N-th veteran level"
        ru = "Доп. навык каждый N-й вет. уровень"
    }
    {
        en = "Starting from but not including the Veteran Level.\n\nE.g. veteran level 11, N=3: extra perk on levels 14, 17, 20 and so on."
        ru = "Начиная после ветеранского уровня.\n\nНапример, ветеранский уровень 11, N=3: доп. навыки на 14-м, 17-м, 20-м и т.д."
    }
    {
        en = "Give a perk on these levels"
        ru = "Давать навык на этих уровнях"
    }
    {
        en = "Level numbers separated by space or comma"
        ru = "Номера уровней через пробел или запятую"
    }
    // FILE: bro_studio/slider_setting.nut
        // en = "<base.tostring()> | Values: <::std.Dumper.pp(this.Values)> | Labels: <::std.Dumper.pp(this.Labels)>"
    // FILE: bro_studio/traits.nut
    {
        en = "Traits"
        ru = "Черты"
    }
    {
        en = "Number"
        ru = "Число"
    }
    {
        en = "Will add this number of random traits to each bro"
        ru = "Добавит столько случайных черт каждому бойцу"
    }
    {
        en = "Add good traits"
        ru = "Добавлять хорошие черты"
    }
    {
        en = "Allow adding good traits"
        ru = "Разрешить добавлять хорошие черты"
    }
    {
        en = "Add bad traits"
        ru = "Добавлять плохие черты"
    }
    {
        en = "Allow adding bad traits"
        ru = "Разрешить добавлять плохие черты"
    }
    {
        en = "Add so-so traits"
        ru = "Добавлять спорные черты"
    }
    {
        en = "Allow adding traits having both significant upsides and downsides"
        ru = "Разрешить черты с заметными плюсами и минусами"
    }
    {
        en = "Stupid Mode"
        ru = "Дурацкий режим"
    }
    {
        en = "Compensate each bad or so-so trait added with a good one"
        ru = "Компенсировать каждую плохую или спорную черту хорошей"
    }
    {
        en = "Repeat each N-th level"
        ru = "Повторять каждый N-й уровень"
    }
    {
        en = "Starting from but not including the level 1"
        ru = "Начиная после 1-го уровня"
    }
    {
        en = "Will add this number of random traits each Nth level"
        ru = "Добавит столько случайных черт каждый N-й уровень"
    }
    // FILE: scripts/!mods_preload/mod_bro_studio.nut
    {
        en = "Bro Studio"
        ru = "Бро Студио"
    }
    {
        en = "Bro Studio adds"
        ru = "Бро Студио добавляет"
    }
    // FILE: scripts/i_bro_studio_levelup_changes.nut
        // en = " and "
        // en = ", "
]
::Rosetta.add(rosetta, pairs);
