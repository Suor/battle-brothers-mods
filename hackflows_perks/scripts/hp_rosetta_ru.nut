if (!("Rosetta" in getroottable())) return;

local rosetta = {
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
        en = "Light Wounds"
        ru = "Лёгкие раны"
    }
    {
        en = "Light Wounds (1 day)"
        ru = "Лёгкие раны (1 день)"
    }
    {
        plural = "days"
        en = "Light Wounds (<days:int> days)"
        n1 = "Лёгкие ранения (<days> день)"
        n2 = "Лёгкие ранения (<days> дня)"
        n5 = "Лёгкие ранения (<days> дней)"
    }
    {
        en = "Iron Will effect"
        ru = "Эффект железной воли"
    }
        // en = "default"
    // FILE: scripts/config/z_hackflows_perks.nut
    {
        en = "Balance"
        ru = "Равновесие"
    }
    {
        mode = "pattern"
        en = "Getting hit or missed costs <open:tag>half<close:tag> of the usual fatigue."
        ru = "Теряет только <open>половину<close> положенной выносливости, когда по персонажу бьют или промахиваются."
    }
    {
        en = "Bloody Harvest"
        ru = "Кровавая жатва"
    }
    {
        mode = "pattern"
        en = "Gain <bonus:str_tag> chance to hit for all area of effect attacks."
        ru = "Получите <bonus> к шансу попадания для всех атак по области."
    }
    {
        en = "Full Force"
        ru = "Всем весом"
    }
    {
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
        mode = "pattern"
        en = "If the bones are there the flesh will grow. Restores hitpoints at <open:tag>double rate<close:tag> and doesn't feel any new injuries until combat ends.\n\nBoth will only work as long as no bones are broken. Permanent injuries are fine."
        ru = "Кости есть - мясо нарастёт. Восстанавливает здоровье с <open>двойной скоростью<close> и не чувствует новых травм до конца боя.\n\nРаботает только если не сломаны кости. Постоянные травмы не в счёт."
    }
    {
        en = "Stabilized"
        ru = "Стабилизация"
    }
    {
        mode = "pattern"
        en = "Specialize in medium armor! Hitpoint and armor damage is reduced by <bonus:str_tag> when the total penalty to Maximum Fatigue from head and body armor is between <fat_low:int_tag> and <fat_high:int_tag>. Outside this range the bonus drops rapidly.\n\nCombines multiplicatively with Nimble and Battle Forged."
        ru = "Специализация на средней броне! Урон по здоровью и броне снижен на <bonus>, когда общий штраф к максимальной выносливости от шлема и брони между <fat_low> и <fat_high>. Вне этого диапазона бонус быстро снижается.\n\nСкладывается мультипликативно с навыками 'Ловкач' и 'Закалённый в боях'."
    }
    // FILE: scripts/skills/perks/perk_hackflows_balance.nut
    // FILE: scripts/skills/perks/perk_hackflows_battle_flow.nut
    // FILE: scripts/skills/perks/perk_hackflows_bloody_harvest.nut
    // FILE: scripts/skills/perks/perk_hackflows_flesh_on_the_bones.nut
    // FILE: scripts/skills/perks/perk_hackflows_full_force.nut
    // FILE: scripts/skills/perks/perk_hackflows_stabilized.nut
    {
        en = "Perfectly balanced! This character makes use of their armor's blend of protection and mobility, granting them a reduction in damage taken to both Hitpoints and Armor."
        ru = "Идеальный баланс! Этот персонаж эффективно использует сочетание защиты и подвижности своей брони, получая меньше урона как по Здоровью, так и по Броне."
    }
    {
        mode = "pattern"
        en = "Only receive <bonus:str_tag> of any attack damage"
        ru = "Получает только <bonus> от любого урона"
    }
    // {
    //     en = "Nimble and Battle Forged"
    //     ru = "Ловкость и Закалка боем"
    // }
    // {
    //     en = "Nimble"
    //     ru = "Ловкость"
    // }
    // {
    //     en = "Battle Forged"
    //     ru = "Закалка боем"
    // }
    {
        mode = "pattern"
        en = "Combined with <others:str> you only receive <hp:str_tag> damage to Hitpoints and <armor:str_tag> damage to Armor"
        ru = "Вместе с <others> вы получаете лишь <hp> урона по здоровью и <armor> урона по броне"
    }
    // {
    //     mode = "pattern"
    //     en = "<Text.positive(is perfect)>, i.e. "
    //     ru = "<Text.positive(идеально)>, т.е. "
    // }
    // {
    //     mode = "pattern"
    //     en = "<Text.negative(is not perfect)>, i.e. "
    //     ru = "<Text.negative(не идеально)>, т.е. "
    // }
    // {
    //     mode = "pattern"
    //     en = "<Text.negative(disables Stabilized)>, get back to "
    //     ru = "<Text.negative(отключает Стабилизацию)>, вернитесь к "
    // }
    {
        mode = "pattern"
        en = "Total fatigue of armor weared is <fat:str_tag>, which <open:tag>is perfect<close:tag>, i.e. 25 to 37"
        ru = "Суммарный штраф от брони <fat>, это <open>идеально<close>, т.е. от 25 до 37"
    }
    {
        mode = "pattern"
        en = "Total fatigue of armor weared is <fat:str_tag>, which <open:tag>is not perfect<close:tag>, i.e. 25 to 37"
        ru = "Суммарный штраф от брони <fat>, что <open>выходит<close> из идеальных от 25 до 37"
    }
    {
        mode = "pattern"
        en = "Total fatigue of armor weared is <fat:str_tag>, which <open:tag>disables Stabilized<close:tag>, get back to 25 to 37"
        ru = "Суммарный штраф от брони <fat>, что делает Стабилизацию <open>бесполезной<close>, вернитесь в диапазон от 25 до 37"
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
