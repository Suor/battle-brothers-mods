// Titles — a pool of nicknames.
//
// SETTING & STYLE GUIDE
// ─────────────────────
// This is a mercenary company in a dark medieval low-fantasy world. These are rough,
// ordinary men — peasants, drifters, outlaws, failed soldiers. The nicknames they give
// each other are simple, direct, and often crude. No psychology, no poetry. If a guy
// is fat, he's "Бочка". If he limps, he's "Хромой". That's all the wit needed.
//
// We might take into account our audience though - these are modern day games, often born 198x-199x.
// So might add some cultural references and gaming slang, but mark those so they could be exlcuded
// with a [future] setting.
//
// What makes a good title here:
//   1. Short — one or two words at most. Nobody's saying "Gentle Giant" around a campfire.
//   2. Has an origin — background, traits, attributes/talents, preffered weapon or combination.
//      There is no generic no reason nicknames. And since looks are not in the set of possible
//      reasons there should not be things like "Лысый" and such. There are traits like fat though.
//   3. Occasionally ironic — the huge oaf is called "Малыш", the nervous wreck is
//      called "Скала". The player figures it out and smiles. That's enough.
//   4. No anachronisms — "Bulletproof", "Спортсмен", "Энерджайзер" have no place here.
//      Crude guns exist but not common, gyms nor sports exist, batteries certainly don't.
//   5. Ambiguity is a feature — "Мясник" works for the ex-butcher AND the guy who
//      hacks limbs off in battle. Same with "Бродяга", "Лис", "Трус". The player
//      can't always tell why he got the name. That's a good thing. Let them wonder.
//   6. Evocative, not descriptive — "Таракан" says survivor without saying it. "Зелёный враг"
//      just describes a fact. If the nickname could be a tooltip, it's too literal.
//
// AVAILABLE FACTORS
// ─────────────────
// trait.*
//   Good: strong, brave, tough, fearless, determined, iron_jaw, iron_lungs, bright,
//         eagle_eyes, swift, quick, dexterous, sure_footing, lucky, survivor, bloodthirsty,
//         loyal, teamplayer, athletic, night_owl, optimist, weasel, deathwish,
//         hate_undead, hate_greenskins, hate_beasts
//   Soso: drunkard, fat, impatient, huge, tiny, paranoid, brute
//         legend_aggressive, legend_diurnal, legend_light, legend_double_tongued
//   Bad:  ailing, asthmatic, bleeder, clubfooted, clumsy, cocky, craven, dastard, disloyal,
//         dumb, fainthearted, fear_beasts, fear_greenskins, fear_undead, fragile, gluttonous,
//         greedy, hesitant, insecure, irrational, night_blind, pessimist, short_sighted,
//         superstitious, legend_fear_nobles, legend_frail, legend_appetite_donkey, legend_fear_dark,
//         legend_predictable, legend_slack
//   NOTE: trait.brute — aggressive, uses crude force, goes for the head. NOT dumb, NOT cocky.
//
// background.*  (vanilla)
//   farmhand, daytaler, sellsword, militia, servant, mason, miller, poacher, ratcatcher,
//   peddler, brawler, bowyer, messenger, tailor, squire, houndmaster, vagabond,
//   gravedigger, bastard, graverobber, adventurous_noble, disowned_noble, retired_soldier,
//   caravan_hand, flagellant, wildman, witchhunter, hedge_knight, swordmaster, apprentice,
//   refugee, thief, monk, butcher, shepherd, beggar, cultist, minstrel, gambler,
//   lumberjack, miner, fisherman, killer_on_the_run, deserter, hunter
//
// [NOT IMPLEMENTED] aliases
//   assassin_southern = assassin
//   gladiator_origin  = gladiator
//   -- HeroicScenarioPack
//   belly_dancer_origin  = belly_dancer
//   adventurous_noble_southern = adventurous_noble
//   -- Fantasy Brothers (Adventurer there is masked behind other backgrounds)
//   xxherosp = adventurous_noble
//   xxheroroyal = adventurous_noble
//   -- Cultist Origin
//   cultist_commander = cultist
//
// background.*  (hackflows/XBE)
//   hackflows_falconer, hackflows_hangman, hackflows_pirate, hackflows_berserker,
//   hackflows_carpenter, hackflows_barkeep, hackflows_herbalist, hackflows_con_artist,
//   hackflows_bodyguard, hackflows_bounty_hunter, hackflows_blacksmith, hackflows_cook,
//   hackflows_surgeon, hackflows_torturer, hackflows_town_watchman, hackflows_roofer,
//   hackflows_cobbler, hackflows_drifter, hackflows_lancer, hackflows_master_archer,
//   hackflows_outlander, hackflows_arbalester, hackflows_druid, hackflows_fletcher,
//   hackflows_gardener, hackflows_locksmith, hackflows_myrmidon, hackflows_painter,
//   hackflows_skirmisher, hackflows_cartographer, hackflows_dissenter, hackflows_leper,
//   hackflows_atilliator
//
// background.* (other mods)
// Lone Chosen: chosen (like strong wildman), aspirant (also barbaric), shaman
// Proper Necromancer: necro
// Of Flesh and Faith Plus: oathbreaker
//
// talent.*  (3-star only — rare enough to be meaningful on its own)
//   Hitpoints, Stamina, MeleeSkill, RangedSkill, MeleeDefense, RangedDefense,
//   Bravery, Initiative
// [NOT IMPLEMENTED] no_talent.*  — no talent in attr; too common alone, useful in combos
//                                e.g. no_talent.MeleeSkill + background.swordmaster → humorous
//
// attr.*  (compared against background-adjusted base range)
//   Hitpoints.high/low, MeleeSkill.high/low, RangedSkill.high/low, Bravery.high/low,
//   Stamina.high/low, Initiative.high/low, MeleeDefense.high, RangedDefense.high
//
// type.*  (weapon category)
//   melee   — bro uses a melee weapon
//   ranged  — bro uses a ranged weapon (Bow, Crossbow, etc.)
//
// weapon.*  (main-hand weapon type)
//   Sword, Axe, Hammer, Spear, Dagger, Mace, Polearm, Bow, Crossbow, Flail
// [NOT IMPLEMENTED] weapon.firearm  — based on m.Categories string not type e.g. Firearm, Throwing
//  (might be broken by translation, but may look into MSU having this handled
//      - ::Const.Items.WeaponType,::Const.Items.ItemType)
//
// [NOT IMPLEMENTED] offhand.Shield, offhand.Net  — bro uses a shield or throwing net
// [NOT IMPLEMENTED] armor.heavy, armor.light  — bro's body armor tier
//
// [NOT IMPLEMENTED] perm.*  — permanent injuries; new bros don't have them in vanilla,
//                               but possible for future use (e.g. injury.lost_eye → "Одноглазый")
//    brain_damage_injury, broken_elbow_joint_injury, broken_knee_injury, collapsed_lung_part_injury,
//    maimed_foot_injury, missing_ear_injury, missing_eye_injury, missing_finger_injury,
//    missing_hand_injury, missing_nose_injury, permanent_injury, traumatized_injury,
//    weakened_heart_injury
//
// [NOT IMPLEMENTED] perk.*    — specific perks taken; new bros don't have them in vanilla
//   "adrenaline", "anticipation", "backstabber", "bags_and_belts", "battle_forged", "berserk",
//   "brawny", "bullseye", "colossus", "coup_de_grace", "crippling_strikes", "dodge", "duelist",
//   "fast_adaption", "fearsome", "footwork", "fortified_mind", "gifted", "hacflows.bloody_harvest",
//   "hackflows.balance", "hackflows.battle_flow", "hackflows.bloody_harvest",
//   "hackflows.flesh_on_the_bones", "hackflows.full_force", "hackflows.stabilized", "head_hunter",
//   "hold_out", "indomitable", "killing_frenzy", "lone_wolf", "mastery.axe", "mastery.bow",
//   "mastery.cleaver", "mastery.crossbow", "mastery.dagger", "mastery.flail", "mastery.hammer",
//   "mastery.mace", "mastery.polearm", "mastery.spear", "mastery.sword", "mastery.throwing",
//   "necro.blood_sucking", "necro.mind_meld", "necro.regeneration", "necro.soul_link",
//   "nimble", "nine_lives", "overwhelm", "pathfinder", "quick_hands", "rally_the_troops",
//   "reach_advantage", "recover", "relentless", "rotation", "shield_expert", "steel_brow",
//   "student", "taunt", "underdog"
// NOTE: other perks may be mapped into these via background_perks/background_perks/fallbacks.nut
//
// cost.high  (daily >= 20),  cost.low  (daily <= 10)

local def = ::Nicknames;

def.Titles <- [
    // ── Внешность ────────────────────────────────────────────────────────
    {ru = "Коротышка", en = "Shorty", factors = [
        ["trait.tiny"],  // literal
        ["trait.huge"],  // ironic: самый здоровый в отряде
    ]}
    {ru = "Длинный", en = "Lanky", factors = [
        ["trait.huge"],  // высокий и долговязый
    ]}
    {ru = "Малыш", en = "Little", factors = [
        ["trait.tiny"],  // literal
        ["trait.huge"],  // ironic: для великана
    ]}
    {ru = "Гора", en = "Mountain", factors = [
        ["trait.huge"],  // literal: громадный
        ["trait.fat"],   // same with a twist
    ]}
    {ru = "Жердь", en = "Beanpole", factors = [
        ["trait.huge"],                        // высокий и костлявый
        ["trait.huge", "attr.Hitpoints.low"],  // долговязый и некрепкий
    ]}
    {ru = "Оглобля", en = "Shaft", factors = [
        ["trait.huge"],  // высокий и тощий
    ]}
    {ru = "Бочка", en = "Barrel", factors = [
        ["trait.fat"],
    ]}
    {ru = "Пузо", en = "Gut", factors = [
        ["trait.fat"],
        ["trait.gluttonous"],  // заслужил привычкой
    ]}
    {ru = "Квашня", en = "Dough-lump", factors = [
        ["trait.fat"],
        ["trait.fat", "trait.fragile"],        // мягкий и тучный
        ["trait.fat", "attr.MeleeSkill.low"],  // тучный и неумелый
        ["trait.fat", "no_talent.MeleeSkill"],
    ]}
    {ru = "Носатый", en = "Nosy", factors = [
        ["perm.missing_nose_injury"],  // [NOT IMPLEMENTED] нос сломан в драке, криво торчит
    ]}
    // Зубастый — нет обоснования; iron_jaw не про зубы, не использовать
    {ru = "Кривой", en = "Crooked", factors = [
        ["trait.clubfooted"],        // ходит вкривь — clubfoot ближайшее
        ["perm.broken_knee_injury"], // [NOT IMPLEMENTED] нога срослась криво
    ]}
    {ru = "Косой", en = "Squinty", factors = [
        ["trait.short_sighted"],     // плохое зрение — щурится
        ["perm.missing_eye_injury"], // [NOT IMPLEMENTED] повреждённый глаз
    ]}
    {ru = "Хромой", en = "Limpy", factors = [
        ["trait.clubfooted"],       // прямое попадание
        ["perm.maimed_foot_injury"], // [NOT IMPLEMENTED] или последствие старой раны
    ]}
    {ru = "Косматый", en = "Shaggy", factors = [
        ["background.wildman"],
        ["background.vagabond"],
        ["background.beggar"],
    ]}
    {ru = "Чумазый", en = "Grimy", factors = [
        ["background.gravedigger"],
        ["background.miner"],
        ["background.ratcatcher"],
        ["background.farmhand"],
    ]}
    {ru = "Бледный", en = "Pale", factors = [
        ["trait.asthmatic"],  // лёгочник выглядит бледно
        ["trait.fragile"],    // хилый, болезненного вида
    ]}
    // Шрам — нет подходящего perm.*; TODO: найти обоснование или убрать
    {ru = "Одноглазый", en = "One-Eye", factors = [
        ["perm.missing_eye_injury"]  // [NOT IMPLEMENTED],
    ]}
    {ru = "Меченый", en = "Marked", factors = [
        ["background.cultist"],    // ритуальные метки
        ["background.flagellant"], // следы самобичевания
    ]}

    // ── Характер ─────────────────────────────────────────────────────────
    // Молчун — нет механического основания; молчаливость не отражена ни в одном факторе, не использовать
    {ru = "Болтун", en = "Chatterbox", factors = [
        ["trait.cocky"],  // самодовольный = болтливый
    ]}
    {ru = "Горлопан", en = "Loudmouth", factors = [
        ["trait.cocky"],
    ]}
    {ru = "Нытик", en = "Whiner", factors = [
        ["trait.pessimist"],
        ["trait.craven"],  // страх выражается нытьём
    ]}
    {ru = "Брюзга", en = "Grumbler", factors = [
        ["trait.pessimist"],
        ["trait.paranoid"],  // всё видит в чёрном
    ]}
    {ru = "Весельчак", en = "Jolly", factors = [
        ["trait.optimist"],
    ]}
    {ru = "Злюка", en = "Grumpy", factors = [
        ["trait.pessimist"],
    ]}
    {ru = "Туча", en = "Gloom", factors = [
        ["trait.pessimist", "trait.paranoid"],  // вдвойне мрачный — чёрная туча в отряде
    ]}
    {ru = "Задира", en = "Bully", factors = [
        ["trait.brute", "trait.impatient"],
    ]}
    {ru = "Буян", en = "Rowdy", factors = [
        ["trait.brute"],
        ["trait.drunkard"],  // пьяный дебош
    ]}
    {ru = "Пьянчик", en = "Boozy", factors = [
        ["trait.drunkard"],
    ]}
    {ru = "Забияка", en = "Troublemaker", factors = [
        ["background.brawler", "trait.impatient"],
    ]}
    {ru = "Упрямец", en = "Stubborn", factors = [
        ["trait.determined"],
    ]}
    {ru = "Хитрец", en = "Sly", factors = [
        ["trait.weasel"],
        ["background.thief"],
        ["trait.bright"],  // умный = хитрый
    ]}
    {ru = "Пройдоха", en = "Schemer", factors = [
        ["background.thief"],
        ["background.hackflows_con_artist"],
        ["trait.weasel"],
    ]}
    {ru = "Жмот", en = "Miser", factors = [
        ["trait.greedy"],
    ]}
    {ru = "Обжора", en = "Gobbler", factors = [
        ["trait.gluttonous"],
        ["trait.gluttonous", "trait.fat"],  // тучный обжора
    ]}
    {ru = "Тихоня", en = "Quiet One", factors = [
        ["trait.bloodthirsty"],  // ironic: смирный с виду, страшный в бою
        ["trait.weasel"],        // тихо делает тёмные дела
    ]}
    {ru = "Смельчак", en = "Daredevil", factors = [
        ["trait.brave"],
        ["trait.fearless"],
        ["trait.craven"],                          // ironic
        ["trait.fearless", "attr.Hitpoints.low"],  // ironic: лезет на рожон, а дунь — упадёт
    ]}
    {ru = "Трус", en = "Coward", factors = [
        ["trait.craven"],      // literal
        ["trait.fearless"],    // ironic: самый безбашенный
        ["trait.deathwish"],   // ironic: вообще не боится умереть
    ]}
    // Трус, Балбес и Бывалый — фильмы Гайдая
    {ru = "Балбес", en = "Dunce", factors = [
        ["trait.dumb"],
        ["trait.dumb", "trait.clumsy"],
    ]}
    {ru = "Дёрганый", en = "Twitchy", factors = [
        ["trait.paranoid"],
        ["trait.hesitant"],
        ["trait.impatient"],
    ]}
    {ru = "Шальной", en = "Unhinged", factors = [
        ["trait.bloodthirsty"],
        ["trait.deathwish"],
        ["trait.irrational"],
    ]}
    {ru = "Крыса", en = "Rat", factors = [
        ["trait.disloyal"],
    ]}
    {ru = "Баламут", en = "Agitator", factors = [
        ["trait.disloyal"],  // мутит воду в отряде
    ]}
    {ru = "Иуда", en = "Judas", factors = [
        ["trait.greedy", "trait.disloyal"],  // жадный предатель
    ]}
    {ru = "Гадюка", en = "the Viper", factors = [
        ["trait.weasel"],
        ["background.thief"],
        ["trait.disloyal"],
        ["trait.weasel", "trait.disloyal"],  // хитрый и ненадёжный — змея в траве
    ]}
    {ru = "Мятежник", en = "Rebel", factors = [
        ["trait.disloyal"],
        ["trait.disloyal", "trait.cocky"],    // наглый и нелояльный
        ["trait.disloyal", "trait.impatient"],
    ]}
    {ru = "Лиходей", en = "Villain", factors = [
        ["background.killer_on_the_run"],
        ["trait.bloodthirsty"],
    ]}
    {ru = "Брехун", en = "Liar", factors = [
        ["trait.weasel"],
        ["trait.legend_double_tongued"],
    ]}
    {ru = "Двулицый", en = "Two-Face", factors = [
        ["trait.legend_double_tongued"],
    ]}
    {ru = "Лежебока", en = "Lazybones", factors = [
        ["attr.Initiative.low"],  // медленно двигается = ленив
    ]}
    {ru = "Заяц", en = "Hare", factors = [
        ["attr.Initiative.high", "attr.Stamina.low"],  // рванул вперёд и сдулся
    ]}

    // ── Боевые ───────────────────────────────────────────────────────────
    {ru = "Мясник", en = "Butcher", factors = [
        ["background.butcher"],                      // literal: бывший мясник
        ["weapon.Axe", "attr.MeleeSkill.high"],      // эффективно рубит
        ["weapon.Cleaver", "attr.MeleeSkill.high"],  // эффективно рубит
        ["weapon.Cleaver", "trait.bloodthirsty"],    // эффектно рубит
    ]}
    {ru = "Кувалда", en = "Sledgehammer", factors = [
        ["weapon.Hammer"],
        ["weapon.Mace", "trait.strong"],
        ["trait.brute"],  // бьёт в голову со всей дури, без затей
    ]}
    {ru = "Рубака", en = "Slasher", factors = [
        ["weapon.Sword"],  // weapon.* как единственный фактор — слишком широко, но здесь норм
        ["weapon.Axe"],
        ["attr.MeleeSkill.high"],  // просто хорошо машет
    ]}
    {ru = "Крепыш", en = "Strongarm", factors = [
        ["trait.strong"],
        ["trait.strong", "attr.MeleeSkill.high"],  // сила помогает бить точно
    ]}
    {ru = "Громила", en = "Bruiser", factors = [
        ["trait.huge", "trait.strong"],
        ["trait.brute"],
    ]}
    {ru = "Валун", en = "the Boulder", factors = [
        ["trait.huge", "trait.tough"],
        ["trait.huge", "attr.Hitpoints.high"],
        ["trait.tough", "attr.Hitpoints.high"],
        ["trait.huge", "trait.strong", "trait.tough"],
    ]}
    {ru = "Молот", en = "Hammer", factors = [
        ["weapon.Hammer"],
        ["weapon.Mace"],
    ]}
    {ru = "Топор", en = "Axe", factors = [
        ["weapon.Axe"],
    ]}
    {ru = "Коса", en = "Scythe", factors = [
        ["weapon.Polearm"],  // косящий замах алебарды/глефы
    ]}
    {ru = "Горлохват", en = "Throat-grabber", factors = [
        ["weapon.Dagger"],
        ["background.hackflows_hangman"],
        ["trait.bloodthirsty"],
    ]}
    {ru = "Жало", en = "Stinger", factors = [
        ["weapon.Dagger"],
        ["weapon.Dagger", "trait.bloodthirsty"],
        ["weapon.Dagger", "attr.MeleeSkill.high"],  // бьёт точно и быстро
        ["weapon.Dagger", "attr.Initiative.high"],  // бьёт точно и быстро
    ]}
    {ru = "Живодёр", en = "Flayer", factors = [
        ["background.butcher"],
        ["background.hunter", "trait.bloodthirsty"],
    ]}
    {ru = "Мясорубка", en = "Meatgrinder", factors = [
        ["background.butcher", "trait.bloodthirsty"],  // мясник с жаждой крови
    ]}
    {ru = "Душегуб", en = "Killer", factors = [
        ["background.killer_on_the_run"],
        ["trait.bloodthirsty"],
    ]}
    {ru = "Головорез", en = "Cutthroat", factors = [
        ["weapon.Axe", "trait.bloodthirsty"],
        ["background.killer_on_the_run"],
        ["background.hackflows_hangman"],
    ]}
    {ru = "Маньяк", en = "the Maniac", factors = [
        ["trait.bloodthirsty", "trait.irrational"],
        ["weapon.Cleaver", "trait.irrational"],  // вовсе потерял связь с реальностью
    ]}
    {ru = "Молния", en = "Lightning", factors = [
        ["trait.swift", "attr.Initiative.high"],  // стремительный в бою
        ["trait.swift", "talent.Initiative"],
        ["trait.impatient", "attr.Initiative.high"],
        ["talent.Initiative", "attr.Initiative.high"],
    ]}
    {ru = "Соколиный глаз", en = "Hawkeye", factors = [
        ["trait.eagle_eyes"],
        ["trait.eagle_eyes", "type.ranged"],  // видит цель — и попадает
    ]}
    // Ненависть к конкретному врагу
    {ru = "Экзорцист", en = "the Exorcist", factors = [
        ["trait.hate_undead"],
    ]}

    // Boris the Bullet Dodger — Snatch (2000)
    {ru = "Хрен попадёшь", en = "Bullet Dodger", setting = false, factors = [
        ["attr.MeleeDefense.high", "attr.RangedDefense.high"],
        ["talent.MeleeDefense", "talent.RangedDefense"],
    ]}

    // ── Судьба ───────────────────────────────────────────────────────────
    {ru = "Везунчик", en = "Lucky", factors = [
        ["trait.lucky"],
    ]}
    {ru = "Счастливчик", en = "Lucky Devil", factors = [
        ["trait.lucky"],
        ["trait.lucky", "trait.survivor"],  // выжил — повезло
    ]}
    {ru = "Горемыка", en = "Wretch", factors = [
        ["attr.Hitpoints.low", "attr.Bravery.low"],  // слабый и пугливый — вечно мается
    ]}
    {ru = "Обречённый", en = "Doomed", factors = [
        ["trait.fragile", "trait.craven"],
        ["trait.ailing", "attr.Hitpoints.low"],
        ["attr.Hitpoints.low", "attr.Bravery.low", "attr.MeleeSkill.low"],  // плохой по всему
        ["trait.fragile", "attr.Hitpoints.low", "attr.Bravery.low"],
        ["trait.pessimist", "attr.Hitpoints.low"],
        ["trait.pessimist", "attr.Bravery.low"],
    ]}
    {ru = "Живучий", en = "Hard to Kill", factors = [
        ["trait.tough"],
        ["trait.survivor"],
        ["trait.survivor", "attr.Hitpoints.high"],
        ["attr.Hitpoints.high", "talent.Hitpoints"],
    ]}
    {ru = "Неудачник", en = "Loser", factors = [
        ["trait.survivor", "trait.tough"],  // ironic: просто не умирает
    ]}
    {ru = "Дырявый", en = "Full of Holes", factors = [
        ["trait.bleeder"],
        ["trait.bleeder", "trait.survivor"],  // кровоточит, но живёт
        // ["attr.Hitpoints.high"]              // столько дыр — и стоит -- makes no sense
    ]}
    {ru = "Смертник", en = "Dead Man", factors = [
        ["trait.brave", "trait.deathwish"],                        // храбрый + тяга к смерти
        ["trait.brave", "trait.deathwish", "attr.Hitpoints.low"],  // храбрый + тяга к смерти + реально хилый
    ]}

    // ── Животные ─────────────────────────────────────────────────────────
    {ru = "Медведь", en = "Bear", factors = [
        ["trait.huge", "trait.strong"],
        ["attr.Hitpoints.high", "trait.strong"],
    ]}
    {ru = "Волк", en = "Wolf", factors = [
        ["trait.bloodthirsty", "attr.MeleeSkill.high"],
        ["background.hunter"],
    ]}
    {ru = "Кабан", en = "Boar", factors = [
        ["trait.fat"],
        ["trait.fat", "trait.brute"],
        ["trait.huge", "trait.impatient"],  // прёт напролом
    ]}
    {ru = "Вепрь", en = "Wild Boar", factors = [
        ["trait.fat", "trait.brute"],
        ["trait.bloodthirsty", "background.wildman"],  // дичее обычного
    ]}
    {ru = "Лис", en = "Fox", factors = [
        ["trait.weasel", "trait.bright"],
        ["background.thief"],
    ]}
    {ru = "Сова", en = "Owl", factors = [
        ["trait.night_owl"],
        ["trait.bright"],  // мудрый/наблюдательный
    ]}
    {ru = "Ворон", en = "Raven", factors = [
        ["background.gravedigger"],
        ["background.graverobber"],
        ["trait.pessimist"],  // предвестник несчастья
    ]}
    {ru = "Барсук", en = "Badger", factors = [
        ["trait.determined", "trait.tough"],
    ]}
    {ru = "Клещ", en = "Tick", factors = [
        ["trait.determined"],  // не отпускает
        ["trait.loyal"],       // прицепился и держится
    ]}
    {ru = "Ёрш", en = "Ruffe", factors = [
        ["trait.brute", "trait.impatient"],  // колючий, лезет на рожон
    ]}
    {ru = "Жила", en = "Sinew", factors = [
        ["trait.tough", "attr.Stamina.high"],
        ["talent.Stamina"],
    ]}
    {ru = "Лев", en = "Lionheart", factors = [
        ["trait.fearless"],
        ["trait.brave", "attr.Bravery.high"],
    ]}
    {ru = "Таракан", en = "Cockroach", factors = [
        ["trait.survivor"],               // ironic: живёт вопреки всему
        ["trait.survivor", "trait.tough"],
    ]}
    {ru = "Бешеный пёс", en = "Maddog", factors = [
        ["trait.bloodthirsty", "trait.irrational"],
    ]}
    {ru = "Тролль", en = "the Troll", factors = [
        ["trait.huge", "trait.dumb"],  // ironic: большой и тупой
    ]}
    {ru = "Йети", en = "the Yeti", factors = [
        ["background.wildman", "trait.huge"],
        ["trait.huge", "trait.brute"],
        ["background.wildman", "trait.strong"],
        ["background.wildman", "trait.huge", "trait.strong"],  // лесной здоровяк во всей красе
    ]}
    {ru = "Овчарка", en = "the Sheepdog", factors = [
        ["background.shepherd"],                      // пас овец — теперь пасёт отряд
        ["background.shepherd", "trait.teamplayer"],  // и правда прикрывает всех
    ]}

    // ── Грубые прозвища ──────────────────────────────────────────────────
    {ru = "Вонючка", en = "Stinky", factors = [
        ["background.gravedigger"],
        ["background.ratcatcher"],
        ["background.miner"],
    ]}
    {ru = "Замухрышка", en = "Runt", factors = [
        ["trait.tiny", "trait.fragile"],
        ["attr.Hitpoints.low"],
    ]}
    {ru = "Пень", en = "Stump", factors = [
        ["trait.dumb"],
    ]}
    {ru = "Растяпа", en = "Klutz", factors = [
        ["trait.clumsy"],
    ]}
    {ru = "Руки-крюки", en = "Butterfingers", factors = [
        ["trait.clumsy"],
        ["trait.clumsy", "attr.MeleeSkill.low"],
    ]}
    {ru = "Лапоть", en = "Bumpkin", factors = [
        ["background.farmhand", "trait.dumb"],
        ["background.daytaler", "trait.dumb"],
    ]}
    {ru = "Чурбан", en = "Blockhead", factors = [
        ["trait.dumb"],
    ]}
    {ru = "Дохлый", en = "Half-dead", factors = [
        ["trait.fragile", "attr.Hitpoints.low"],
        ["trait.asthmatic"],  // дышит как умирающий
    ]}
    {ru = "Огрызок", en = "Remnant", factors = [
        ["trait.tiny", "attr.Hitpoints.low"],  // маленький и потрёпанный
    ]}
    {ru = "Висельник", en = "Gallows-bird", factors = [
        ["background.killer_on_the_run"],
        ["background.deserter"],
        ["trait.disloyal"],  // должны были повесить
    ]}
    {ru = "Рухлядь", en = "Old Wreck", factors = [
        ["trait.fragile", "cost.low"],
        ["attr.Hitpoints.low", "attr.MeleeSkill.low"],  // плохой по всему
    ]}
    {ru = "Плюгавый", en = "Puny", factors = [
        ["trait.tiny", "trait.fragile"],
    ]}
    {ru = "Непутёвый", en = "Good-for-nothing", factors = [
        ["trait.irrational"],
        ["trait.clumsy", "trait.impatient"],  // всё делает не так
    ]}
    {ru = "Мутный", en = "Shady", factors = [
        ["trait.weasel"],
        ["background.hackflows_con_artist"],
        ["trait.paranoid"],  // держится в тени
    ]}
    {ru = "Полено", en = "Log", factors = [
        ["trait.dumb", "attr.Initiative.low"],  // тупой и неповоротливый
    ]}
    {ru = "Кочерга", en = "Fire Poker", factors = [
        ["trait.huge"],       // жердеобразный, жёсткий
        ["trait.determined"], // гнётся с трудом
    ]}
    {ru = "Чумной", en = "Cracked", factors = [
        ["trait.irrational", "trait.deathwish"],
        ["background.flagellant"],
    ]}

    // ── Прочие ───────────────────────────────────────────────────────────
    {ru = "Бродяга", en = "Wanderer", factors = [
        ["background.vagabond"],
        ["background.beggar"],
        ["background.refugee"],
        ["background.hackflows_drifter"],
    ]}
    {ru = "Беглец", en = "Fugitive", factors = [
        ["background.deserter"],
        ["background.killer_on_the_run"],
        ["background.refugee"],
        ["attr.Initiative.high", "trait.swift"],  // ironic: просто быстрый на ногу
    ]}
    {ru = "Пришлый", en = "Outsider", factors = [
        ["background.refugee"],
        ["background.hackflows_outlander"],
        ["background.wildman"],
    ]}
    {ru = "Дикий", en = "Wild One", factors = [
        ["background.wildman"],
        ["trait.bloodthirsty", "trait.irrational"],
    ]}
    {ru = "Склизкий", en = "Slippery", factors = [
        ["trait.weasel"],
        ["background.thief"],
        ["background.hackflows_con_artist"],
    ]}
    {ru = "Хрипун", en = "Raspy", factors = [
        ["trait.asthmatic"],
        ["trait.iron_lungs"],  // ironic: дышит как сломанные мехи, но не устаёт
    ]}
    {ru = "Пёрышко", en = "Featherweight", factors = [
        ["trait.legend_light"],
    ]}
    {ru = "Фантом", en = "the Phantom", factors = [
        ["trait.night_owl", "background.thief"],
        ["trait.night_owl", "trait.weasel"],
    ]}
    {ru = "Отмычка", en = "Picklock", factors = [
        ["background.thief"],
        ["background.hackflows_locksmith"],
        ["background.thief", "trait.dexterous"],  // ловкие руки — дело мастера
        ["background.thief", "perk.quick_hands"],
    ]}
    {ru = "Безымянный", en = "No Name", factors = [
        ["background.vagabond"],
        ["background.refugee"],
        ["background.hackflows_drifter"],
    ]}
    {ru = "Лесоруб", en = "the Woodcutter", factors = [
        ["background.lumberjack"],
        ["background.lumberjack", "weapon.Axe"],
        ["background.wildman", "weapon.Axe"],  // дикарь с топором — та же работа
    ]}
    {ru = "Мясной щит", en = "Meatshield", setting = false, factors = [
        ["attr.Hitpoints.high", "attr.MeleeDefense.high"],  // стоит впереди и держит удар
        ["attr.Hitpoints.high", "trait.tough"],
        ["talent.Hitpoints", "attr.MeleeDefense.high"],
    ]}
    {ru = "Без башни", en = "Wildcard", setting = false, factors = [
        ["trait.irrational"],
        ["trait.irrational", "trait.impatient"],
        ["trait.bloodthirsty", "trait.irrational"],  // никогда не знаешь чего ждать
    ]}
];
