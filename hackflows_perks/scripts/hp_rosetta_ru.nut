if (!("Rosetta" in getroottable())) return;
if (::Hooks.SQClass.ModVersion(::Rosetta.Version) < ::Hooks.SQClass.ModVersion("0.2.0")) return;

local rosetta = {
    version = "0.2.0"
    mod = {id = "mod_hackflow_perks", version = 1.4}
    author = "hackflow"
    lang = "ru"
}
local pairs = [
    // FILE: scripts/!mods_preload/mod_hackflows_perks.nut
    {
        en = "Hackflow's Perks"
        ru = "Навыки от Hackflow"
    }
    {
        // line.text = format("Light Wounds (%i day%s)", days, Text.plural(days));
        plural = "days"
        en = "Light Wounds (<days:int> day<s:str>)"
        n1 = "Лёгкие раны (<days> день)"
        n2 = "Лёгкие раны (<days> дня)"
        n5 = "Лёгкие раны (<days> дней)"
    }
    {
        en = "Will take effect only after combat ends due to the Flesh on the Bones effect"
        ru = "Вступает в силу только после окончания боя из-за навыка 'Мясо на костях'"
    }
    // FILE: scripts/config/z_hackflows_perks.nut
    {
        en = "Balance"
        ru = "Равновесие"
    }
    {
        // Tooltip = "Getting hit or missed costs " + green("half") + " of the usual fatigue."
        mode = "pattern"
        en = "Getting hit or missed costs <open:tag>half<close:tag> of the usual fatigue."
        ru = "Теряет только <open>половину<close> положенной выносливости, когда по персонажу бьют или промахиваются."
    }
    {
        en = "Bloody Harvest"
        ru = "Кровавая жатва"
    }
    {
        // Tooltip = "Gain " + green("+10%") + " chance to hit for all area of effect attacks."
        mode = "pattern"
        en = "Gain <bonus:str_tag> chance to hit for all area of effect attacks."
        ru = "Получите <bonus> к шансу попадания для всех атак по области."
    }
    {
        en = "Full Force"
        ru = "Всем весом"
    }
    {
        // Tooltip = "Put your full weight into every blow and gain " + green("+1%")
        //     + " minimal melee damage for each " + red(3)
        //     + " fatigue caused by things worn and held. Items in the bag do not contribute."
        mode = "pattern"
        en = "Put your full weight into every blow and gain <bonus:str_tag> minimal melee damage for each <fat:int_tag> fatigue caused by things worn and held. Items in the bag do not contribute."
        ru = "Вкладывайте весь вес в каждый удар и получайте <bonus> к минимальному урону в ближнем бою за каждые <fat> единицы выносливости от надетых и удерживаемых предметов. Предметы в сумке не учитываются."
    }
    {
        en = "Battle Flow"
        ru = "Боевой поток"
    }
    {
        en = "The first kill each turn does not accumulate fatigue."
        ru = "Первое убийство за ход не расходует выносливость."
    }
    {
        en = "Flesh on the Bones"
        ru = "Мясо на костях"
    }
    {
        // Tooltip = "If the bones are there the flesh will grow.\n\nRestores hitpoints at "
        //     + green("double rate") + " and doesn't feel any new injuries until combat ends."
        //     + " Both will only work as long as no bones are broken. Permanent injuries are fine."
        //     + "\n\nNon-bone injuries heal one day faster."
        mode = "pattern"
        en = "If the bones are there the flesh will grow.\n\nRestores hitpoints at <open:tag>double rate<close:tag> and doesn't feel any new injuries until combat ends. Both will only work as long as no bones are broken. Permanent injuries are fine.\n\nNon-bone injuries heal one day faster."
        ru = "Кости есть - мясо нарастёт. Восстанавливает здоровье с <open>двойной скоростью<close> и не чувствует новых травм до конца боя. Работает только если не сломаны кости. Увечья не в счёт.\n\nТравмы, не связанные с костями, заживают быстрее на день."
    }
    {
        en = "Stabilized"
        ru = "Стабилизация"
    }
    {
        // Tooltip = "Specialize in medium armor! Hitpoint and armor damage is reduced by "
        //     + green("25%") + " when the total penalty to Maximum Fatigue from head and body armor"
        //     + " is between " + red(25) + " and " + red(37)
        //     + ". Outside this range the bonus drops rapidly.\n\n"
        //     + "Combines multiplicatively with Nimble and Battle Forged."
        mode = "pattern"
        en = "Specialize in medium armor! Hitpoint and armor damage is reduced by <bonus:str_tag> when the total penalty to Maximum Fatigue from head and body armor is between <fat_low:int_tag> and <fat_high:int_tag>. Outside this range the bonus drops rapidly.\n\nCombines multiplicatively with Nimble and Battle Forged."
        ru = "Специализация на средней броне! Урон по здоровью и броне снижен на <bonus>, когда общий штраф к максимальной выносливости от шлема и брони между <fat_low> и <fat_high>. Вне этого диапазона бонус быстро снижается.\n\nСкладывается мультипликативно с навыками 'Ловкач' и 'Закалённый в боях'."
    }
    // FILE: scripts/hackflows_perks/potential.nut
    {
        en = "Promised Potential"
        ru = "Ожидаемый потенциал"
    }
    {
        en = "Promising Potential"
        ru = "Подающий надежды"
    }
    {
        en = "Rising Potential"
        ru = "Растущий потенциал"
    }
    {
        en = "Realized Potential"
        ru = "Раскрытый потенциал"
    }
    {
        mode = "pattern"
        en = "<title:str> (Failed)"
        ru = "<title:t> (Провал)"
    }
    {
        en = "This character looked promising, but either due to bad luck or simply lack of talent, they have not fulfilled the potential you thought they had."
        ru = "Этот боец подавал надежды, но из-за невезения или простой бездарности не оправдал возложенных на него ожиданий."
    }
    {
        en = "The Captain said he'd take a gamble on you, but you'd better not disappoint!"
        ru = "Капитан сказал, что рискнёт взять тебя, не подведи!"
    }
    {
        // "Upon reaching level 5, this perk has a " + Text.positive("75%") + " chance of being replaced with [b]Promising Potential[/b] which will increase all attributes by " + Text.positive("+3") + ", and can be upgraded further at levels 8 and 11.",
        mode = "pattern"
        en = "Upon reaching level 5, this perk has a <chance:val_tag> chance of being replaced with [b]Promising Potential[/b] which will increase all attributes by <attr:int_tag>, and can be upgraded further at levels 8 and 11."
        ru = "По достижении 5 уровня есть <chance> шанс, что этот навык заменится на [b]'Подающий надежды'[/b], который повысит все характеристики на <attr> и может быть улучшен на 8 и 11 уровнях"
    }
    {
        en = "If unsuccessful, this perk is replaced by [Failed Potential|Perk+perk_rf_failed_potential] which does nothing."
        ru = "В случае неудачи этот навык заменяется на [Нераскрытый потенциал|Perk+perk_rf_failed_potential], который ничего не даёт."
    }
    {
        // Footer = Text.negative("This perk cannot be picked after you have spent a perk point elsewhere. This perk cannot be refunded.")
        mode = "pattern"
        en = "<open:tag>This perk cannot be picked after you have spent a perk point elsewhere. This perk cannot be refunded.<close:tag>"
        ru = "<open>Этот навык недоступен после выбора иного навыка. Этот навык не может быть возмещён.<close>"
    }
    {
        en = "You turned out to be promising, but you'd better not disappoint!"
        ru = "Ты подаёшь надежды, не облажайся!"
    }
    {
        // "Increase all attributes by " + Text.positive("+3") + "."
        mode = "pattern"
        en = "Increase all attributes by <bonus:int_tag>."
        ru = "<bonus> ко всем характеристикам."
    }
    {
        // "Upon reaching level 8, this perk has a " + Text.positive("75%") + " chance of being replaced with [b]Rising Potential[/b] which will increase this character\'s salary by " + Text.negative("50%") + ", increase all attributes by " + Text.positive("+4") + ", unlock a new weapon perk group, and can be upgraded further at lvl 11",
        mode = "pattern"
        en = "Upon reaching level 8, this perk has a <chance:val_tag> chance of being replaced with [b]Rising Potential[/b] which will increase this character's salary by <salary:val_tag>, increase all attributes by <attr:int_tag>, unlock a new weapon perk group, and can be upgraded further at lvl 11"
        ru = "По достижении 8 уровня есть <chance> шанс, что этот навык заменится на [b]'Растущий потенциал'[/b], который увеличит жалование персонажа на <salary>, повысит все характеристики на <attr>, откроет новую группу навыков оружия и может быть улучшен на 11 уровне"
    }
    {
        en = "If unsuccessful, this perk stops progressing."
        ru = "При неудаче этот навык перестает развиваться."
    }
    {
        // Footer = Text.negative("This perk cannot be refunded.")
        mode = "pattern"
        en = "<open:tag>This perk cannot be refunded.<close:tag>"
        ru = "<open>Этот навык не может быть возмещён.<close>"
    }
    {
        en = "Your potential is rising, but you'd better not disappoint!"
        ru = "Твой потенциал растёт, но не расслабляйся!"
    }
    {
        // "Require " + Text.negative("50%") + " more daily wage.",
        mode = "pattern"
        en = "Require <wage:val_tag> more daily wage."
        ru = "Требует на <wage> больше ежедневной платы."
    }
    {
        // "Gain " + Text.positive("1") + " random Weapon Perk Group.",
        mode = "pattern"
        en = "Gain <num:int_tag> random Weapon Perk Group."
        ru = "Получить <num> случайную группу оружейных навыков."
    }
    {
        // "Upon reaching level 11, this perk has a " + Text.positive("75%") + " chance of being replaced with [b]Realized Potential[/b] which will increase this character\'s salary by " + Text.negative("50%") + ", increase all attributes by " + Text.positive("+5") + ", unlock new perk groups and refund all perk points, including the one spent on this perk.",
        mode = "pattern"
        en = "Upon reaching level 11, this perk has a <chance:val_tag> chance of being replaced with [b]Realized Potential[/b] which will increase this character's salary by <salary:val_tag>, increase all attributes by <attr:int_tag>, unlock new perk groups and refund all perk points, including the one spent on this perk."
        ru = "По достижении 11 уровня есть <chance> шанс, что этот навык заменится на [b]'Раскрытый потенциал'[/b], который увеличит жалование персонажа на <salary>, повысит все характеристики на <attr:int_tag>, откроет новые группы навыков и вернёт все потраченные очки навыков, включая потраченное на этот навык."
    }
    {
        en = "From bones to brawn! This character has truly come a long way. Who was once a dreg of society is now a full-fledged mercenary."
        ru = "От кожи да костей — к мускулам и силе! Этот боец прошел долгий путь. Бывший отброс общества стал настоящим наемником."
    }
    {
        en = "Refund all spent Perk Points."
        ru = "Возмещает все потраченные очки навыков."
    }
    {
        // "Gain " + Text.positive("+1") + " Perk Point.",
        mode = "pattern"
        en = "Gain <num:int_tag> Perk Point."
        ru = "Даёт <num> очко навыков."
    }
    {
        // "Gain " + Text.positive("1") + " random Shared Perk Group.",
        mode = "pattern"
        en = "Gain <num:int_tag> random Shared Perk Group."
        ru = "Даёт <num> случайную группу общих навыков."
    }
    {
        // "Gain " + Text.positive("2") + " random Weapon Perk Groups.",
        mode = "pattern"
        en = "Gain <num:int_tag> random Weapon Perk Groups."
        ru = "Даёт <num> случайные группы оружейных навыков."
    }
    // FILE: scripts/skills/perks/perk_hackflows_potential.nut
    {
        // text = ::std.Text.positive("+" + bonus) + " to all attributes"
        mode = "pattern"
        en = "<bonus:int_tag> to all attributes"
        ru = "<bonus> ко всем характеристикам"
    }
    {
        // text = ::std.Text.negative("+" + wagePercent + "%") + " more daily wage"
        mode = "pattern"
        en = "<wage:val_tag> more daily wage"
        ru = "<wage> дневной платы"
    }
    // FILE: scripts/skills/perks/perk_hackflows_stabilized.nut
    {
        en = "Perfectly balanced! This character makes use of their armor's blend of protection and mobility, granting them a reduction in damage taken to both Hitpoints and Armor."
        ru = "Идеальный баланс! Этот персонаж эффективно использует сочетание защиты и подвижности своей брони, получая меньше урона как по Здоровью, так и по Броне."
    }
    {
        // text = "Only receive " + Text.positive((100 - bonus) + "%") + " of any attack damage"
        mode = "pattern"
        en = "Only receive <bonus:str_tag> of any attack damage"
        ru = "Получает только <bonus> от любого урона"
    }
    {
        en = "Nimble and Battle Forged"
        ru = "'Ловкач' и 'Закалёный в боях'"
    }
    {
        en = "Nimble"
        ru = "'Ловкач'"
    }
    {
        en = "Battle Forged"
        ru = "'Закалёный в боях'"
    }
    {
        // text = format("Combined with %s you only receive %s damage to Hitpoints and %s damage to Armor", others, hp, armor)
        mode = "pattern"
        en = "Combined with <others:str> you only receive <hp:str_tag> damage to Hitpoints and <armor:str_tag> damage to Armor"
        ru = "Вместе с <others:t> вы получаете лишь <hp> урона по здоровью и <armor> урона по броне"
    }
    {
        // local fatDesc = bonus == this.m.BonusMax ? Text.positive("is perfect") + ", i.e. " :
        mode = "pattern"
        en = "<open:tag>is perfect<close:tag>, i.e. "
        ru = "<open>идеально<close>, т.е. "
    }
    {
        // bonus > 0 ? Text.negative("is not perfect") + ", i.e. " :
        mode = "pattern"
        en = "<open:tag>is not perfect<close:tag>, i.e. "
        ru = "<open>не идеально<close>, т.е. "
    }
    {
        // Text.negative("disables Stabilized") + ", get back to ";
        mode = "pattern"
        en = "<open:tag>disables Stabilized<close:tag>, get back to "
        ru = "делает Стабилизацию <open>бесполезной<close>, вернитесь к "
    }
    {
        // text = format("Total fatigue of armor weared is %s, which %s25 to 37",
        //               Text.negative(totalArmorFatPenalty), fatDesc)
        mode = "pattern"
        en = "Total fatigue of armor weared is <fat:str_tag>, which <expl:str>25 to 37"
        ru = "Суммарный штраф от брони <fat>, <expl:t>от 25 до 37"
    }
    {
        en = "This brother's armor is too flimsy to benefit from being stabilized! Try equipping some heavier armor."
        ru = "Броня этого брата слишком хлипкая для стабилизации! Попробуйте надеть что-нибудь потяжелее."
    }
    {
        en = "This brother's armor is too cumbersome to benefit from being stabilized! Try equipping some lighter armor."
        ru = "Броня этого брата слишком громоздкая для стабилизации! Попробуйте надеть что-нибудь полегче."
    }
]
::Rosetta.add(rosetta, pairs);
