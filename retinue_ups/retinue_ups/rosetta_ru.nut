if (!("Rosetta" in getroottable())) return;

local rosetta = {
    mod = {id = "mod_retinue_ups", version = "1.2.2"}
    author = "hackflow"
    lang = "ru"
}
local pairs = [
    // FILE: scripts/!mods_preload/mod_retinue_ups.nut
        // en = "mod_retinue_ups.<follower.ClassName>"
    {
        en = "Retinue Promotions"
        ru = "Повышения Спутиников"
    }
    {
        // return __original() + (::World.Retinue.ru_isPromoted(this) ? " (Promoted)" : "")
        mode = "pattern"
        en = "<name:str> (Promoted)"
        ru = "<name> (Повышен)"
    }
    {
        // text = "Promote " + this.m.ru_promotion.Tease + ", costs "
        //     + this.m.ru_promotion.Cost + "[img]gfx/ui/tooltips/money.png[/img]"
        mode = "pattern"
        en = "Promote <tease:str>, costs <cost:int><img:img>"
        ru = "Повысить <tease:t>, стоимость <cost><img>"
    }
    {
        en = "for even more champions"
        ru = "для ещё большего числа чемпионов"
    }
    {
        // positive("Greatly") + " increases the chance of encountering champions";
        mode = "pattern"
        en = "<o:tag>Greatly<c:tag> increases the chance of encountering champions"
        ru = "<o>Значительно<c> увеличивает шанс встретить чемпионов"
    }
    {
        en = "to recover items from slain enemies more often"
        ru = "чтобы чаще получать предметы с убитых врагов"
    }
    {
        en = "Gives better chance to get items from slain enemies, even broken ones"
        ru = "Повышает шанс получить предметы с убитых врагов, даже сломанные"
    }
    {
        en = "to double the ammo and tools recovered"
        ru = "для удвоения найденных боеприпасов и инструментов"
    }
    {
        en = "for more stuff in shops, including named items"
        ru = "для большего выбора в магазинах, включая именные предметы"
    }
    {
        en = "Finds more stuff in shops, including more named items"
        ru = "Находит больше товаров в магазинах, включая именные предметы"
    }
    {
        en = "to get extra food after combat"
        ru = "для получения дополнительной еды после боя"
    }
    {
        en = "Finds extra food after combat"
        ru = "Находит дополнительную еду после боя"
    }
    {
        en = "to provide training for new recruites and make the most from training halls"
        ru = "для обучения новобранцев и лучшего использования тренировочных залов"
    }
    {
        // "New hires get " + positive("+70%") + " experience in first 3 battles"
        mode = "pattern"
        en = "New hires get <bonus:val_tag> experience in first 3 battles"
        ru = "Новобранцы получают <bonus> опыта в первых 3 боях"
    }
    {
        en = "Training halls experience bonus is doubled"
        ru = "Бонус опыта от тренировочных залов удвоен"
    }
    {
        en = "to show more info about locations"
        ru = "для отображения дополнительной информации о локациях"
    }
    {
        // "Shows a faction of unscoutable locations "
        // + "and whether its treasury has " + named("named items")
        mode = "pattern"
        en = "Shows a faction of unscoutable locations and whether its treasury has <o:tag>named items<c:tag>"
        ru = "Показывает фракцию неразведанных локаций и наличие <o>именных предметов<c> в сокровищнице"
    }
    {
        // entry.text = "Unknown " + enemy(faction);
        mode = "pattern"
        en = "Unknown <faction:str_tag>"
        ru = "Неизвестные <faction>"
    }
    {
        // text = "Has " + named("named item") + " in there"
        mode = "pattern"
        en = "Has <o:tag>named item<c:tag> in there"
        ru = "Внутри есть <o>знаменитый предмет<c>"
    }
    {
        en = "to also move faster on normal terrain"
        ru = "чтобы быстрее двигаться по обычной местности"
    }
    {
        // "Makes the company travel " + positive("15%") + " faster on normal terrain"
        mode = "pattern"
        en = "Makes the company travel <bonus:val_tag> faster on normal terrain"
        ru = "Отряд перемещается на <bonus> быстрее по обычной местности"
    }
    {
        en = "to sometimes fix permanent injuries on level ups"
        ru = "чтобы иногда лечить увечья при повышении уровня"
    }
    {
        // "Give " + positive("15%") + " chance to fix permanent injury on level up"
        mode = "pattern"
        en = "Give <chance:val_tag> chance to fix permanent injury on level up"
        ru = "<chance> шанс исцелить увечье при повышении уровня"
    }
    {
        en = "Promoted Surgeon fixes"
        ru = "Повышенный врачеватель исцеляет"
    }
    // FILE: scripts/i_retinue_ups_levelup_changes.nut
        // en = " and "
        // en = ", "
]
::Rosetta.add(rosetta, pairs);
