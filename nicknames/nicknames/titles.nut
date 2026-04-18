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
//   EXPLAINED: trait.brute — aggressive, uses crude force, goes for the head.
//              NOT dumb, NOT cocky, NOT pushy.
//
// background.*  (vanilla)
//   assassin, farmhand, daytaler, sellsword, militia, servant, mason, miller, poacher, ratcatcher,
//   peddler, brawler, bowyer, messenger, tailor, squire, houndmaster, vagabond,
//   gravedigger, bastard, graverobber, adventurous_noble, disowned_noble, retired_soldier,
//   caravan_hand, flagellant, wildman, witchhunter, hedge_knight, swordmaster, apprentice,
//   refugee, thief, monk, butcher, shepherd, beggar, cultist, minstrel, juggler, gambler,
//   lumberjack, miner, fisherman, killer_on_the_run, deserter, hunter, nomad, raider, slave,
//   gladiator, beast_slayer, anatomist, bladedancer, converted_cultist, cripple, eunuch,
//   historian, manhunter, paladin
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
//   hackflows_atilliator, hackflows_champion, hackflows_folk_hero, hackflows_paladin_commander
//
// background.* (other mods)
// Lone Chosen: aspirant (also barbaric), shaman
// Proper Necromancer: necro
// Of Flesh and Faith Plus: oathbreaker
//
// attr.*  (compared against background-adjusted base range)
//   Hitpoints.high/low, MeleeSkill.high/low, RangedSkill.high/low, Bravery.high/low,
//   Stamina.high/low, Initiative.high/low, MeleeDefense.high, RangedDefense.high
//
// type.*  (weapon category)
//   melee   — bro has a melee background
//   ranged  — bro has a ranged background
//
// group.* - groups of backgrounds: peaceful, combat, noble, lowborn, pauper
//
// weapon.*  (main-hand weapon type)
//   sword, axe, hammer, spear, dagger, mace, polearm, bow, crossbow, flail, cleaver, firearm, throwing
//
// [NOT IMPLEMENTED] offhand.Shield, offhand.Net  — bro uses a shield or throwing net
// [NOT IMPLEMENTED] armor.heavy, armor.light  — bro's body armor tier
//
// injury.*  — permanent injuries (skill IDs used directly as factors)
//    brain_damage, broken_elbow_joint, broken_knee, collapsed_lung_part,
//    maimed_foot, missing_ear, missing_eye, missing_finger,
//    missing_hand, missing_nose, traumatized, weakened_heart
//
// perk.*    — specific perks taken; requires mod_background_perks
//   vanilla:   "adrenaline", "anticipation", "backstabber", "bags_and_belts", "battle_forged",
//              "berserk", "brawny", "bullseye", "colossus", "coup_de_grace", "crippling_strikes",
//              "dodge", "duelist", "fast_adaption", "fearsome", "footwork", "fortified_mind",
//              "gifted", "head_hunter", "hold_out", "indomitable", "killing_frenzy", "lone_wolf",
//              "nine_lives", "nimble", "overwhelm", "pathfinder", "quick_hands", "rally_the_troops",
//              "reach_advantage", "recover", "relentless", "rotation", "shield_expert", "steel_brow",
//              "student", "taunt", "underdog"
//   NOTE: mastery perks (mastery.axe, mastery.bow, etc.) are converted to weapon.* factors
//   hackflows: "hackflows.balance", "hackflows.battle_flow", "hackflows.bloody_harvest",
//              "hackflows.flesh_on_the_bones", "hackflows.full_force", "hackflows.stabilized"
//   necro:     "necro.blood_sucking", "necro.mind_meld", "necro.regeneration", "necro.soul_link"
// NOTE: other perks may be mapped into these via background_perks/background_perks/fallbacks.nut
//
// cost.high  (daily >= 20),  cost.low  (daily <= 10)
//
// NOTE: Legends do have way more extra backgrounds and traits
//       Reforged have 2 backgrounds, which could be aliased

local def = ::Nicknames;

// Per-factor-type weights; entry weight = product of each factor's weight
def.Weights <- {
    background = 1.5
    trait      = 1.5
    attr       = 2.0
    injury     = 2.5
    cost       = 1.0
    type       = 1.0
    weapon     = 1.5
    perk       = 2.5
    group      = 1.2
};

// Factor aliases: if a bro has the key factor, the value factor is also added to their factor set
def.Aliases <- {
    "background.assassin_southern":          "background.assassin"
    "background.gladiator_origin":           "background.gladiator"
    // Reforged
    "background.rf_old_swordmaster":         "background.swordmaster"
    "background.rf_renowned_swordmaster":    "background.swordmaster"
    // HeroicScenarioPack
    "background.adventurous_noble_southern": "background.adventurous_noble"
    "background.belly_dancer_origin":        "background.belly_dancer"
    "trait.halfbreed":                       "necro.regeneration"
    // Fantasy Bros
    "background.xxherosp":                   "background.adventurous_noble"
    "background.xxheroroyal":                "background.adventurous_noble"
    // Cultist origin
    "background.cultist_commander":          "background.cultist"
    // Lone Chosen
    "background.chosen":                     "background.wildman"
}
// Alias Starting Perks by Background falllbacks
if ("BgPerks" in getroottable() && "fallbacks" in ::BgPerks) {
    foreach (canonical, fallbacks in ::BgPerks.fallbacks)
        foreach (fallback in fallbacks)
            def.Aliases["perk." + fallback] <- "perk." + canonical;
}


def.Titles <- [
    // ── Внешность ────────────────────────────────────────────────────────
    {ru = "Коротышка", en = "Shorty", factors = [
        ["trait.tiny"],
    ]}
    {ru = "Малыш", en = "Little", factors = [
        ["trait.tiny"],  // literal
        ["trait.huge"],  // ironic: для великана
    ]}
    {ru = "Длинный", en = "Lanky", factors = [
        ["trait.huge"],  // высокий и долговязый
    ]}
    {ru = "Гора", en = "Mountain", factors = [
        ["trait.huge"],  // literal: громадный
        ["trait.fat"],   // same with a twist
    ]}
    {names = [
        {ru = "Жердь", en = "Beanpole"},
        {ru = "Оглобля", en = "Shaft"},
        {ru = "Каланча", en = "Lamppost"},
    ], factors = [
        ["trait.huge", "attr.Hitpoints.low"],  // долговязый и некрепкий
    ]}
    {ru = "Бочка", en = "Barrel", factors = [
        ["trait.fat"],
    ]}
    {ru = "Пузо", en = "Belly", factors = [
        ["trait.fat"],
        ["trait.gluttonous"],  // заслужил привычкой
    ]}
    {ru = "Квашня", en = "Dough-lump", factors = [
        ["trait.fat", "trait.fragile"],        // мягкий и тучный
        ["trait.fat", "trait.insecure"],
        ["trait.fat", "attr.MeleeSkill.low"],  // тучный и неумелый
    ]}
    {names = [
        {ru = "Нос", en = "Nose"}
        {ru = "Носатый", en = "Nosy"}
    ], factors = [
        ["injury.missing_nose"],  // нос сломан в драке, криво торчит
    ]}
    // Зубастый — нет обоснования; iron_jaw не про зубы, не использовать
    {ru = "Четыре пальца", en = "Four Fingers", factors = [
        ["injury.missing_finger"],
    ]}
    {ru = "Кривой", en = "Crooked", factors = [
        ["trait.clubfooted"],        // ходит вкривь — clubfoot ближайшее
        ["injury.broken_knee"], // нога срослась криво
    ]}
    {ru = "Косой", en = "Squinty", factors = [
        ["trait.short_sighted"],     // плохое зрение — щурится
        ["injury.missing_eye"], // повреждённый глаз
    ]}
    {ru = "Хромой", en = "Limpy", factors = [
        ["trait.clubfooted"],       // прямое попадание
        ["injury.maimed_foot"], // или последствие старой раны
    ]}
    {ru = "Косматый", en = "Shaggy", factors = [
        ["background.wildman"],
        ["group.pauper"],
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
        ["attr.Hitpoints.low"],
        ["attr.Bravery.low"],
    ]}
    {ru = "Одноглазый", en = "One-Eye", factors = [
        ["injury.missing_eye"],
    ]}
    {ru = "Меченый", en = "Marked", factors = [
        ["background.cultist"],    // ритуальные метки
        ["background.flagellant"], // следы самобичевания
    ]}
    {ru = "Муравей", en = "Ant", factors = [
        ["trait.tiny"],                          // мелкий, как муравей
        ["trait.tiny", "attr.Stamina.high"],     // мелкий, но выносливый
    ]}

    // ── Характер ─────────────────────────────────────────────────────────
    // Молчун — нет механического основания; молчаливость не отражена ни в одном факторе, не использовать
    {ru = "Болтун", en = "Chatterbox", factors = [
        ["trait.cocky"],  // самодовольный = болтливый
        ["trait.cocky", "trait.dumb"],
    ]}
    {ru = "Горлопан", en = "Loudmouth", factors = [
        ["trait.cocky"],
        ["perk.taunt"],
        ["perk.rally_the_troops"],
        ["attr.Bravery.high", "attr.Initiative.high"],
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
    {ru = "Ворчун", en = "Grumpy", factors = [
        ["trait.pessimist"],
    ]}
    {ru = "Туча", en = "Gloom", factors = [
        ["trait.pessimist", "trait.paranoid"],  // вдвойне мрачный — чёрная туча в отряде
    ]}
    {ru = "Задира", en = "Bully", factors = [
        ["trait.brute", "trait.impatient"],
        ["perk.taunt"],  // literally taunts enemies into fighting
    ]}
    {ru = "Животное", en = "Animal", factors = [
        ["trait.brute"],
        ["trait.bloodthirsty"],
        ["trait.dumb"],
        ["trait.drunkard"],
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
    {names = [
        {ru = "Упрямец", en = "Stubborn"},
        {ru = "Кочерга", en = "Fire Poker"},
    ], factors = [
        ["trait.determined"],
    ]}
    {ru = "Хитрец", en = "Sly", factors = [
        ["background.thief"],
        ["background.assassin"],
        ["trait.bright"],  // умный = хитрый
    ]}
    {ru = "Зануда", en = "Pedant", factors = [
        ["trait.bright"],  // умный, но утомляет
        ["perk.student"],  // вечно учится, вечно поучает
    ]}
    {ru = "Пройдоха", en = "Schemer", factors = [
        ["background.thief"],
        ["background.hackflows_con_artist"],
        ["trait.bright", "trait.disloyal"],
    ]}
    {names = [
        {ru = "Жмот", en = "Miser"},
        {ru = "Скупец", en = "Penny Pincher"},
        {ru = "Скряга", en = "Skinflint"},
    ], factors = [
        ["trait.greedy"],
    ]}
    {ru = "Обжора", en = "Gobbler", factors = [
        ["trait.gluttonous"],
        ["trait.gluttonous", "trait.fat"],   // тучный обжора
        ["trait.legend_appetite_donkey"],    // ест как осёл — хуже не бывает
    ]}
    {ru = "Пирожок", en = "Little Pie", factors = [
        ["trait.gluttonous"],  // любит поесть
        ["trait.insecure"],    // мягкий, уютный, ненастоящий боец
        ["trait.fat", "trait.tiny"],
    ]}
    {ru = "Размазня", en = "Milksop", factors = [
        ["trait.insecure"],                        // literal
        ["trait.fainthearted"],                    // тоже тряпка
        ["trait.insecure", "trait.fainthearted"],  // совсем размазня
    ]}
    {ru = "Тихоня", en = "Quiet One", factors = [
        ["trait.bloodthirsty"],  // ironic: смирный с виду, страшный в бою
        ["trait.weasel"],        // тихо делает тёмные дела
    ]}
    {ru = "Хамелеон", en = "Chameleon", factors = [
        ["perk.fast_adaption"],  // adapts to any situation
        ["perk.fast_adaption", "trait.weasel"],  // changes colours to survive
    ]}
    {ru = "Смельчак", en = "Daredevil", factors = [
        ["trait.brave"],
        ["trait.fearless"],
        ["trait.fearless", "attr.Hitpoints.low"],  // ironic: лезет на рожон, а дунь — упадёт
    ]}
    {names = [
        {ru = "Трус", en = "Coward"},
        {ru = "Трусишка", en = "Scaredy Cat"},
    ], factors = [
        ["trait.craven"],
        ["trait.weasel"],
        ["trait.fainthearted"],
        ["trait.craven", "attr.Bravery.low"],  // маленький трусишка
    ]}
    // Трус, Балбес и Бывалый — фильмы Гайдая
    {ru = "Балбес", en = "Dunce", factors = [
        ["trait.dumb"],
        ["trait.dumb", "trait.clumsy"],
    ]}
    {ru = "Дёрганый", en = "Twitchy", factors = [
        ["trait.paranoid"],
        ["trait.paranoid", "attr.Initiative.high"],
        ["trait.hesitant"],
        ["trait.impatient"],
    ]}
    {names = [
        {ru = "Тугодум", en = "Slow Thinker"},
        {ru = "Топтун", en = "Shuffler"},
        {ru = "Завтра", en = "Tomorrow"},
    ], factors = [
        ["trait.hesitant"],
    ]}
    {ru = "Якорь", en = "Anchor", factors = [
        ["trait.hesitant"],
        ["background.hackflows_pirate", "trait.hesitant"],
    ]}
    {ru = "Шальной", en = "Unhinged", factors = [
        ["trait.bloodthirsty"],
        ["trait.deathwish"],
        ["trait.irrational"],
        ["attr.Initiative.high"],
    ]}
    {ru = "Крыса", en = "Rat", factors = [
        ["trait.disloyal"],
        ["trait.greedy"],
    ]}
    {ru = "Баламут", en = "Stirrer", factors = [
        ["trait.disloyal"],  // мутит воду в отряде
        ["trait.disloyal", "perk.taunt"],
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
        ["perk.fearsome"],  // enemies fear him
    ]}
    {ru = "Брехло", en = "Liar", factors = [
        ["trait.disloyal"],
        ["trait.legend_double_tongued"],
    ]}
    {ru = "Двулицый", en = "Two-Face", factors = [
        ["trait.legend_double_tongued"],
    ]}
    {ru = "Лежебока", en = "Lazybones", factors = [
        ["attr.Initiative.low"],  // медленно двигается = ленив
        ["attr.Stamina.low"],
        ["trait.legend_slack"],
    ]}
    {ru = "Заяц", en = "Hare", factors = [
        ["attr.Initiative.high", "attr.Stamina.low"],  // рванул вперёд и сдулся
    ]}
    {ru = "Верный", en = "Faithful", factors = [
        ["trait.loyal"],
        ["trait.loyal", "trait.teamplayer"],  // на него можно положиться
    ]}
    {ru = "Товарищ", en = "Comrade", factors = [
        ["trait.teamplayer"],
        ["trait.teamplayer", "trait.loyal"],
    ]}
    {ru = "Фанатик", en = "Fanatic", factors = [
        ["background.flagellant"],
        ["background.cultist"],
        ["trait.deathwish", "background.flagellant"],  // идёт до конца
        ["perk.indomitable"],  // fervor makes him unbreakable
    ]}
    {ru = "Голодный", en = "Hungry", factors = [
        ["trait.gluttonous"],
        ["trait.legend_appetite_donkey"],  // жрёт и не наедается
        ["background.beggar"],   // literal: голодает
        ["background.refugee"],  // нищий беженец всегда голоден
    ]}
    {ru = "Бесстрашный", en = "Fearless", factors = [
        ["trait.fearless"],
        ["trait.brave", "attr.Bravery.high"],
        ["perk.fortified_mind"],  // iron will, cannot be frightened
    ]}
    {ru = "Хвастун", en = "Showoff", factors = [
        ["trait.cocky"],
        ["trait.cocky", "attr.MeleeSkill.high"],  // повод для хвастовства есть
    ]}
    {ru = "Неспокойный", en = "Restless", factors = [
        ["trait.impatient"],
        ["trait.impatient", "trait.brute"],  // не может сидеть на месте — лезет в драку
    ]}
    {ru = "Улыбакин", en = "Smiley", factors = [
        ["trait.optimist"],
        ["background.minstrel", "trait.optimist"],
    ]}
    {ru = "Солнышко", en = "Sunshine", factors = [
        ["trait.optimist"],
        ["trait.optimist", "trait.lucky"],
    ]}
    {ru = "Предатель", en = "Turncoat", factors = [
        ["trait.disloyal"],
        ["background.deserter", "trait.disloyal"],
        ["trait.disloyal", "background.hackflows_dissenter"],
    ]}
    {ru = "Изгой", en = "Outcast", factors = [
        ["background.hackflows_dissenter"],
        ["background.oathbreaker"],
        ["background.refugee", "trait.disloyal"],
        ["perk.lone_wolf"],  // fights alone, cast out
    ]}
    {names = [
        {ru = "Позор", en = "Disgrace"},
        {ru = "Отступник", en = "Apostate"},
        {ru = "Отречённый", en = "Renounced"},
    ], factors = [
        ["background.oathbreaker"],
    ]}
    {ru = "Правдоруб", en = "Truth-cutter", factors = [
        ["background.hackflows_dissenter"],
        ["background.hackflows_dissenter", "trait.bright"],
        ["trait.cocky", "trait.bright"],
    ]}
    {ru = "Гнилой", en = "Rotten", factors = [
        ["trait.disloyal", "trait.greedy"],
        ["trait.disloyal", "background.deserter"],
    ]}
    {ru = "Нелюдь", en = "Inhuman", factors = [
        ["trait.hate_greenskins"],
        ["trait.hate_undead"],
        ["trait.hate_greenskins", "trait.hate_undead"],
        ["trait.hate_greenskins", "trait.hate_beasts"],
        ["trait.hate_undead", "trait.hate_beasts"],
    ]}
    {ru = "Мудрила", en = "Wise-ass", factors = [
        ["trait.bright", "trait.cocky"],
        ["perk.student", "trait.cocky"],
    ]}
    {ru = "Соня", en = "Sleepy", factors = [
        ["attr.Initiative.low", "attr.Stamina.low"],
        ["attr.Initiative.low", "trait.night_owl"],
    ]}
    {ru = "Заводила", en = "Instigator", factors = [
        ["trait.impatient", "perk.rally_the_troops"],
        ["trait.cocky", "perk.taunt"],
    ]}
    {ru = "Дурной", en = "Bad-blood", factors = [
        ["trait.irrational"],
        ["trait.irrational", "trait.brave"],
    ]}
    {ru = "Щегол", en = "Dandy", factors = [
        ["trait.cocky"],               // пёстрый, хвастливый
        ["trait.tiny", "trait.cocky"],
    ]}
    {ru = "Барабан", en = "Drum", factors = [
        ["trait.cocky", "attr.Bravery.high"],              // громкий, звонкий голос
        ["perk.rally_the_troops"],                         // бьёт в барабан — ведёт за собой
        ["attr.Hitpoints.high", "attr.MeleeDefense.low"],  // сам принимает удары
    ]}
    {ru = "Пиявка", en = "Leech", factors = [
        ["trait.greedy"],                          // высасывает, прицепился
        ["trait.greedy", "trait.disloyal"],        // забирает и предаёт
        ["perk.hackflows.flesh_on_the_bones"],     // буквально: плоть на костях
    ]}
    {ru = "Угорь", en = "Eel", factors = [
        ["trait.dexterous", "trait.weasel"],   // скользкий, изворотливый
        ["trait.dexterous", "trait.disloyal"],
    ]}
    {ru = "Крендель", en = "Pretzel", factors = [
        ["trait.irrational"],                         // с выкрутасами
        ["trait.cocky", "trait.irrational"],
        ["background.juggler", "trait.irrational"],
    ]}
    {ru = "Павлин", en = "Peacock", factors = [
        ["trait.cocky"],                          // красуется перед боем
        ["background.minstrel", "trait.cocky"],
    ]}
    {ru = "Потроха", en = "Innards", factors = [
        ["trait.bloodthirsty"],                           // всегда угрожает выпустить кишки
        ["trait.bloodthirsty", "trait.irrational"],
        ["background.butcher", "trait.irrational"],
    ]}
    {ru = "Свисток", en = "Whistle", factors = [
        ["trait.craven", "trait.paranoid"],  // паникер, зовёт на помощь первым
        ["trait.quick", "trait.craven"],
    ]}
    {ru = "Бузотёр", en = "Rabblerouser", factors = [
        ["trait.bloodthirsty", "trait.irrational"],  // только дай повод начать драку
        ["background.brawler", "trait.drunkard"],
    ]}
    {ru = "Дебошир", en = "Hellraiser", factors = [
        ["trait.drunkard", "trait.irrational"],  // как напьётся, разносит пол-лагеря
    ]}
    {ru = "Петух", en = "Cockerel", factors = [
        ["trait.cocky"],  // постоянно красуется и лезет драться
    ]}
    {ru = "Философ", en = "Philosopher", factors = [
        ["trait.dumb", "trait.pessimist"],  // вечно рассуждает о тлене перед боем
    ]}
    {ru = "Лицемер", en = "Hypocrite", factors = [
        ["background.monk", "trait.disloyal"],  // на словах святой, на деле — первый в лут
    ]}
    {ru = "Звездочёт", en = "Stargazer", factors = [
        ["trait.short_sighted"],   // слепо пялится в небо
        ["trait.night_blind"],
        ["trait.bright"],          // ironic: умный — только смотрит не туда
    ]}
    {ru = "Сектант", en = "Zealot", factors = [
        ["background.cultist", "trait.dumb"],  // тупой фанатик с промытыми мозгами
    ]}
    {ru = "Скоморох", en = "Jester", factors = [
        ["background.juggler", "trait.irrational"],  // отмачивает тупые шутки, пока всех режут
    ]}
    {ru = "Самоубийца", en = "Suicide", factors = [
        ["trait.deathwish", "trait.pessimist"],  // только и ищет повода красиво помереть
    ]}
    {ru = "Атаман", en = "Chieftain", factors = [
        ["perk.rally_the_troops", "trait.cocky"],  // бывший рейдер, сохранивший замашки
    ]}
    {ru = "Кидала", en = "Bunco", factors = [
        ["background.hackflows_con_artist"],
        ["weapon.sling"],
    ]}

    // ── Боевые ───────────────────────────────────────────────────────────
    {ru = "Мясник", en = "Butcher", factors = [
        ["background.butcher"],                      // literal: бывший мясник
        ["weapon.axe", "attr.MeleeSkill.high"],      // эффективно рубит
        ["weapon.cleaver", "attr.MeleeSkill.high"],  // эффективно рубит
        ["weapon.cleaver", "trait.bloodthirsty"],    // эффектно рубит
        ["perk.crippling_strikes"],           // maims like a butcher
        ["perk.coup_de_grace"],               // finishes off the helpless
    ]}
    {ru = "Кувалда", en = "Sledgehammer", factors = [
        ["weapon.hammer"],
        ["weapon.mace", "trait.strong"],
        ["trait.brute"],  // бьёт в голову со всей дури, без затей
        ["perk.brawny"],  // strong enough to swing heavy weapons
    ]}
    {ru = "Рубака", en = "Slasher", factors = [
        ["group.combat", "weapon.sword"],
        ["group.combat", "attr.MeleeSkill.high"],  // просто хорошо машет
        ["background.hackflows_cook", "attr.MeleeSkill.high"],  // ironic
    ]}
    {ru = "Крепыш", en = "Strongarm", factors = [
        ["trait.strong"],
        ["trait.athletic"],                        // крепкий телом
        ["trait.strong", "attr.MeleeSkill.high"],  // сила помогает бить точно
        ["trait.athletic", "trait.strong"],        // сила и выносливость
        ["perk.brawny"],  // built for heavy armor
    ]}
    {names = [
        {ru = "Борец", en = "Wrestler"},
        {ru = "Жеребец", en = "Stallion"},
        {ru = "Удалец", en = "Gallant"},
    ], factors = [
        ["trait.athletic"],
    ]}
    {ru = "Крепкий Орешек", en = "Hard Nut", factors = [
        ["trait.athletic", "trait.survivor"],
    ]}
    {ru = "Громила", en = "Bruiser", factors = [
        ["trait.huge", "trait.strong"],
        ["trait.brute"],
        ["trait.huge", "trait.brute"],
        ["perk.brawny"],    // muscular
        ["perk.colossus"],  // massive HP
    ]}
    {ru = "Валун", en = "the Boulder", factors = [
        ["trait.huge", "trait.tough"],
        ["trait.huge", "attr.Hitpoints.high"],
        ["trait.tough", "attr.Hitpoints.high"],
        ["trait.huge", "trait.strong", "trait.tough"],
        ["perk.colossus"],  // massive HP pool
    ]}
    {ru = "Молот", en = "Hammer", factors = [
        ["weapon.hammer"],
        ["weapon.mace"],
    ]}
    {ru = "Топор", en = "Axe", factors = [
        ["weapon.axe"],
    ]}
    {ru = "Коса", en = "Scythe", factors = [
        ["weapon.polearm"],  // косящий замах алебарды/глефы
        ["perk.reach_advantage"],    // keeps enemies in the scythe zone
        ["weapon.spear"],
    ]}
    {ru = "Цепь", en = "the Chain", factors = [
        ["weapon.flail"],
    ]}
    {ru = "Горлохват", en = "Throat-grabber", factors = [
        ["weapon.dagger"],
        ["background.hackflows_hangman"],
        ["trait.bloodthirsty"],
        ["perk.backstabber"],  // attacks from behind
    ]}
    {ru = "Жало", en = "Stinger", factors = [
        ["weapon.dagger"],
        ["weapon.dagger", "trait.bloodthirsty"],
        ["weapon.dagger", "attr.MeleeSkill.high"],  // бьёт точно и быстро
        ["weapon.dagger", "attr.Initiative.high"],  // бьёт точно и быстро
        ["perk.backstabber"],     // stabs from behind
    ]}
    {ru = "Живодёр", en = "Flayer", factors = [
        ["background.butcher"],
        ["background.butcher", "trait.bloodthirsty"],
        ["background.hunter", "trait.bloodthirsty"],
    ]}
    {ru = "Мясорубка", en = "Meatgrinder", factors = [
        ["background.butcher", "trait.bloodthirsty"],  // мясник с жаждой крови
    ]}
    {ru = "Душегуб", en = "Killer", factors = [
        ["background.killer_on_the_run"],
        ["trait.bloodthirsty"],
        ["perk.fearsome"],       // сеет ужас
        ["perk.coup_de_grace"],  // добивает
    ]}
    {ru = "Головорез", en = "Cutthroat", factors = [
        ["weapon.axe", "trait.bloodthirsty"],
        ["background.killer_on_the_run"],
        ["background.hackflows_hangman"],
        ["perk.head_hunter"],  // literally goes for the head
        ["perk.backstabber"],  // attacks from behind
    ]}
    {ru = "Маньяк", en = "the Maniac", factors = [
        ["trait.bloodthirsty", "trait.irrational"],
        ["weapon.cleaver", "trait.irrational"],  // вовсе потерял связь с реальностью
        ["perk.berserk"],          // literally berserk
        ["perk.killing_frenzy"],   // frenzied after kills
    ]}
    {ru = "Молния", en = "Lightning", factors = [
        ["trait.swift", "attr.Initiative.high"],  // стремительный в бою
        ["trait.impatient", "attr.Initiative.high"],
        ["perk.adrenaline"],  // bursts forward in a flash
    ]}
    {names = [
        {ru = "Соколиный глаз", en = "Hawkeye"},
        {ru = "Острый взгляд", en = "Sharp Eye"},
    ], factors = [
        ["trait.eagle_eyes"],
        ["trait.eagle_eyes", "type.ranged"],  // видит цель — и попадает
        ["type.ranged", "attr.RangedSkill.high"],
        ["trait.eagle_eyes", "attr.RangedSkill.high"],
        ["perk.bullseye", "attr.RangedSkill.high"],
    ]}
    // Ненависть к конкретному врагу
    {ru = "Экзорцист", en = "the Exorcist", factors = [
        ["trait.hate_undead"],
        ["background.witchhunter"],
    ]}
    {ru = "Зверобой", en = "Beastbane", factors = [
        ["trait.hate_beasts"],
        ["trait.fear_beasts"],
    ]}
    // Страхи
    {ru = "Мышка", en = "Fieldmouse", factors = [
        ["trait.fear_beasts"],     // боится любой живности
    ]}
    {ru = "Зайка", en = "Bunny", factors = [
        ["trait.fear_beasts"],  // ironic: при любом звере — заяц
    ]}
    {ru = "Набожный", en = "the Devout", factors = [
        ["trait.fear_undead"],  // молится — авось поможет
    ]}
    {names = [
        {ru = "Крест", en = "the Cross"},
        {ru = "Свечка", en = "Candle"},
        {ru = "Чеснок", en = "Garlic"},
    ], factors = [
        ["trait.fear_undead"],
    ]}

    {ru = "Стрела", en = "Arrow", factors = [
        ["weapon.bow", "attr.RangedSkill.high"],
        ["weapon.bow", "perk.bullseye"],      // never misses
    ]}
    {ru = "Болт", en = "Bolt", factors = [
        ["weapon.crossbow", "attr.RangedSkill.high"],
        ["weapon.crossbow", "perk.bullseye"],
    ]}
    {ru = "Яблочко", en = "Bullseye", factors = [
        ["type.ranged", "attr.RangedSkill.high"],
        ["trait.gluttonous", "trait.tiny"],
        ["perk.bullseye"],          // literal translation
    ]}
    {ru = "Мастер клинка", en = "Blade Master", factors = [
        ["type.melee", "attr.MeleeSkill.high", "cost.high"],  // слишком пафосно для дешёвых
        ["background.swordmaster"],
    ]}
    {ru = "Костелом", en = "Bonebreaker", factors = [
        ["weapon.hammer", "trait.brute"],    // тупое оружие + грубая сила
        ["weapon.hammer", "attr.MeleeSkill.high"],
        ["weapon.mace", "trait.brute"],
        ["weapon.mace", "attr.MeleeSkill.high"],
    ]}
    {ru = "Жнец", en = "Reaper", factors = [
        ["weapon.polearm", "attr.MeleeSkill.high"],
        ["weapon.polearm", "trait.bloodthirsty"],  // косит врагов как траву
        ["perk.hackflows.bloody_harvest"],  // keeps enemies in the scythe zone
    ]}
    {ru = "Первая кровь", en = "First Blood", factors = [
        ["trait.bloodthirsty", "attr.Initiative.high"],  // всегда бьёт первым
        ["trait.bloodthirsty", "trait.impatient"],
        ["perk.adrenaline"],  // charges in first
    ]}
    {ru = "Бойня", en = "Slaughterhouse", factors = [
        ["trait.bloodthirsty", "attr.MeleeSkill.high"],
        ["trait.bloodthirsty", "background.butcher"],
        ["perk.killing_frenzy"],  // goes on a rampage
    ]}
    {ru = "Смерч", en = "Whirlwind", factors = [
        ["perk.overwhelm", "attr.Initiative.high"],
        ["perk.overwhelm", "attr.MeleeSkill.high"],
    ]}
    {ru = "Мал да удал", en = "Small but Sharp", factors = [
        ["trait.tiny", "type.melee", "attr.MeleeSkill.high"],
        ["trait.tiny", "type.ranged", "attr.RangedSkill.high"],  // мал, а метко бьёт
        ["perk.underdog"],  // shines when outnumbered
    ]}
    {ru = "Проворный", en = "Nimble", factors = [
        ["trait.dexterous"],
        ["trait.dexterous", "attr.Initiative.high"],
        ["trait.dexterous", "trait.swift"],
        ["perk.nimble"],    // literal match
        ["perk.footwork"],  // moves with agility
    ]}
    {ru = "Сила есть", en = "Dumb Muscle", factors = [
        ["trait.strong", "trait.dumb"],
        ["trait.huge", "trait.strong", "trait.dumb"],  // силища есть — ума не надо
        ["trait.huge", "trait.strong"],  // Бык — упрямый, сильный, бьёт рогами
    ]}
    {ru = "Кулак", en = "Fist", factors = [
        ["background.brawler"],
        ["background.brawler", "trait.brute"],
    ]}
    {ru = "Людоед", en = "Man Eater", factors = [
        ["trait.huge", "trait.bloodthirsty"],
        ["trait.huge", "trait.brute"],
    ]}
    {ru = "Перспективный", en = "Promising", factors = [
        ["type.melee", "attr.MeleeSkill.high", "attr.MeleeDefense.high", "cost.low"],
        ["type.ranged", "attr.RangedSkill.high", "attr.RangedDefense.high", "cost.low"],
    ]}
    {ru = "Щитоносец", en = "Shield Bearer", factors = [
        ["background.hackflows_bodyguard"],
        ["background.hackflows_bodyguard", "attr.MeleeDefense.high"],  // телохранитель — прикрывает
        ["attr.MeleeDefense.high", "attr.Hitpoints.high"],
        ["perk.shield_expert"],  // mastered the shield
    ]}

    {ru = "Быстрые ноги", en = "Quick Feet", factors = [
        ["trait.swift", "attr.Initiative.high"],
        ["attr.Initiative.high", "trait.sure_footing"],  // быстрый и уверенный
        ["perk.footwork"],  // literal match
    ]}
    {ru = "Юла", en = "Spinning Top", factors = [
        ["perk.rotation"],  // never stands still, always repositioning
        ["perk.rotation", "attr.Initiative.high"],
    ]}
    {ru = "Толстая шкура", en = "Thick Hide", factors = [
        ["attr.Hitpoints.high", "trait.lucky"],
        ["attr.Hitpoints.high", "trait.tough"],
        ["perk.colossus"],    // extra HP pool
        ["perk.steel_brow"],  // tough skull, shrugs off hits
    ]}
    {ru = "Кованый", en = "Battle-Forged", factors = [
        ["perk.battle_forged"],                             // literal
        ["perk.battle_forged", "background.sellsword"],    // mercenary hardened by years of war
        ["perk.battle_forged", "background.hedge_knight"], // wandering knight who earned his scars
        ["perk.hackflows.full_force"],    // hits with the full weight of his armor
        ["perk.hackflows.stabilized"],    // injury-resistant, built to last
    ]}
    {ru = "Ловкий", en = "Agile", factors = [
        ["trait.dexterous"],
        ["trait.swift", "trait.dexterous"],
        ["trait.dexterous", "attr.Initiative.high"],
    ]}
    {ru = "Дуэлянт", en = "Duelist", factors = [
        ["perk.duelist"],
        ["background.hackflows_myrmidon"],
        ["attr.MeleeSkill.high", "attr.MeleeDefense.high"],  // воюет один на один
        ["perk.anticipation"],         // reads enemy moves like a duelist
        ["perk.hackflows.balance"],    // stays balanced through the fight
    ]}
    {ru = "Гарпун", en = "Harpoon", factors = [
        ["background.fisherman"],
        ["background.fisherman", "weapon.spear"],
        ["background.fisherman", "weapon.throwing"],
    ]}
    {ru = "Наковальня", en = "Anvil", factors = [
        ["background.hackflows_blacksmith"],
        ["trait.iron_jaw"],
        ["trait.iron_jaw", "attr.Hitpoints.high"],
        ["perk.steel_brow"],
        ["perk.steel_brow", "trait.tough"],
    ]}
    {ru = "Заноза", en = "Splinter", factors = [
        ["trait.tiny", "trait.impatient"],
        ["weapon.dagger", "attr.MeleeSkill.high"],
    ]}
    {ru = "Затычка", en = "Plug", factors = [
        ["perk.shield_expert", "attr.MeleeDefense.high"],
        ["attr.Hitpoints.high", "attr.MeleeDefense.high"],
    ]}
    {ru = "Кремень", en = "Flint", factors = [
        ["trait.determined", "trait.tough"],
        ["trait.determined", "trait.fearless"],
        ["trait.iron_jaw"],
        ["trait.iron_jaw", "trait.tough"],
    ]}
    {ru = "Молотило", en = "Thresher", factors = [
        ["weapon.flail"],
        ["weapon.flail", "trait.brute"],
        ["weapon.flail", "attr.MeleeSkill.high"],
    ]}
    {ru = "Карусель", en = "Whirligig", factors = [
        ["weapon.flail", "perk.berserk"],
        ["weapon.flail", "perk.hackflows.bloody_harvest"],
        ["weapon.axe", "perk.berserk"],
        ["weapon.axe", "perk.hackflows.bloody_harvest"],
        ["background.juggler"],
    ]}
    {ru = "Дробина", en = "Buckshot", factors = [
        ["trait.tiny", "attr.MeleeSkill.high"],
        ["trait.tiny", "attr.RangedSkill.high"],
        ["trait.tiny", "trait.strong"],
    ]}
    {ru = "Щепка", en = "Sliver", factors = [
        ["trait.tiny", "weapon.dagger"],
    ]}
    {ru = "Зубодробитель", en = "Toothbreaker", factors = [
        ["weapon.hammer", "trait.brute"],
        ["weapon.hammer", "perk.head_hunter"],
        ["weapon.mace", "trait.brute"],
        ["weapon.mace", "perk.head_hunter"],
    ]}
    {ru = "Гром", en = "Thunder", factors = [
        ["cost.high", "weapon.hammer"],
        ["cost.high", "weapon.hammer", "attr.MeleeSkill.high"],
    ]}
    {ru = "Крюк", en = "Hook", factors = [
        ["perk.crippling_strikes"],
        ["background.fisherman"],
        ["background.hackflows_hangman"],
    ]}
    {ru = "Костолом", en = "Bonecracker", factors = [
        ["weapon.hammer", "trait.brute"],    // молот/кость ломает грубой силой
    ]}
    {ru = "Шило", en = "Awl", factors = [
        ["background.hackflows_cobbler", "trait.swift"],    // быстрый сапожник с ножом
        ["background.hackflows_cobbler", "weapon.dagger"],
        ["trait.swift", "weapon.dagger"],
    ]}
    {ru = "Клык", en = "Fang", factors = [
        ["trait.bloodthirsty", "trait.hate_beasts"],  // агрессивный зверобой
    ]}
    {ru = "Коготь", en = "Claw", factors = [
        ["trait.bloodthirsty", "background.killer_on_the_run"],  // кровожадный убийца
    ]}
    {ru = "Гвоздь", en = "Nail", factors = [
        ["trait.determined", "trait.strong"],  // упрямый, вобьёт и не вытащишь
        ["background.hackflows_carpenter"],
    ]}
    {ru = "Черепаха", en = "Tortoise", factors = [
        ["attr.Initiative.low", "trait.tough"],         // медленный, но в панцире
        ["attr.Initiative.low", "perk.shield_expert"],
    ]}
    {ru = "Мозгоправ", en = "Headshrinker", factors = [
        ["weapon.mace", "trait.brute"],                    // вправляет мозги ударом булавы
        ["background.hackflows_surgeon", "trait.brute"],
    ]}
    {ru = "Трубочист", en = "Chimney Sweep", factors = [
        ["weapon.firearm", "trait.dumb"],  // вечно с чёрной от пороха мордой
    ]}
    {ru = "Гроза Орков", en = "Orc Terror", factors = [
        ["trait.fear_greenskins", "attr.Bravery.low"],   // ironic: бледнеет при слове «зеленокожий»
        ["trait.hate_greenskins", "attr.Bravery.high"],  // и у тех, кто их вправду ненавидит
    ]}
    {names = [
        {ru = "Оркоед", en = "Orc-Eater"},
        {ru = "Зелёный", en = "Greenie"},
    ], factors = [
        ["trait.fear_greenskins"],  // ironic: самый трусливый зовётся Оркоедом / сам позеленел от страха
    ]}
    {ru = "Шнырь", en = "Snooper", factors = [
        ["background.thief", "trait.quick"],  // везде прошмыгнёт без мыла
        ["trait.weasel", "trait.quick"],
    ]}
    {ru = "Решето", en = "Sieve", factors = [
        ["attr.RangedDefense.low"],
        ["attr.RangedDefense.low", "attr.Hitpoints.high"],  // ironic: дырявый, но живёт
    ]}

    // Boris the Bullet Dodger — Snatch (2000)
    {ru = "Хрен попадёшь", en = "Bullet Dodger", setting = false, factors = [
        ["attr.MeleeDefense.high", "attr.RangedDefense.high"],
        ["attr.MeleeDefense.high", "perk.dodge"],  // trained to dodge
    ]}

    // ── Судьба ───────────────────────────────────────────────────────────
    {ru = "Везунчик", en = "Lucky", factors = [
        ["trait.lucky"],
    ]}
    {names = [
        {ru = "Счастливчик", en = "Lucky Devil"},
        {ru = "Четырёхлистник", en = "Four-Leaf"},
    ], factors = [
        ["trait.lucky"],
        ["trait.lucky", "trait.survivor"],  // выжил — повезло
    ]}
    {ru = "Горемыка", en = "Wretch", factors = [
        ["attr.Hitpoints.low", "attr.Bravery.low"],  // слабый и пугливый — вечно мается
    ]}
    {ru = "Обречённый", en = "Doomed", factors = [
        ["trait.fragile", "trait.craven"],
        ["attr.Hitpoints.low", "trait.ailing"],
        ["attr.Hitpoints.low", "trait.fragile"],
        ["attr.Hitpoints.low", "trait.pessimist"],
        ["trait.pessimist", "trait.superstitious"],
        ["trait.pessimist", "trait.fragile"],
    ]}
    {ru = "Живучий", en = "Hard to Kill", factors = [
        ["trait.survivor"],
        ["trait.survivor", "attr.Hitpoints.high"],
        ["perk.nine_lives"],                    // literally hard to kill
        ["perk.hold_out"],                      // refuses to go down
        ["perk.hackflows.flesh_on_the_bones"],  // extra flesh to soak damage
        ["perk.necro.regeneration"],            // regenerates wounds
    ]}
    {ru = "Неудачник", en = "Loser", factors = [
        ["trait.survivor", "trait.pessimist"],
        ["trait.survivor", "trait.tough"],     // ironic: просто не умирает
    ]}
    {ru = "Дырявый", en = "Full of Holes", factors = [
        ["trait.bleeder"],
        ["trait.bleeder", "trait.survivor"],  // кровоточит, но живёт
    ]}
    {ru = "Красный Норс", en = "Red Nose", factors = [
        ["trait.bleeder"],
        ["trait.bleeder", "trait.drunkard"],  // и кровоточит, и пьёт — вечно красный
    ]}
    {ru = "Смертник", en = "Dead Man", factors = [
        ["trait.brave", "trait.deathwish"],                        // храбрый + тяга к смерти
        ["trait.brave", "trait.deathwish", "attr.Hitpoints.low"],  // храбрый + тяга к смерти + реально хилый
    ]}
    {ru = "Без завтра", en = "No Tomorrow", factors = [
        ["trait.deathwish"],
        ["trait.deathwish", "attr.Bravery.high"],  // не боится смерти — и не скрывает
        ["trait.deathwish", "trait.lucky"],
    ]}
    {ru = "Пёс Везучий", en = "Lucky Dog", factors = [
        ["trait.lucky"],
        ["trait.lucky", "attr.Hitpoints.low"],  // ironic: хилый, но живёт
        ["trait.lucky", "perk.underdog"],  // ironic: хилый, но живёт
    ]}
    {ru = "Беда", en = "Trouble", factors = [
        ["trait.pessimist", "trait.irrational"],
        ["trait.pessimist", "trait.disloyal"],
        ["trait.bloodthirsty", "trait.irrational"],
    ]}
    {ru = "Золотой", en = "Goldie", factors = [
        ["cost.high", "trait.greedy"],
        ["cost.high", "attr.MeleeSkill.high"],
        ["cost.high", "attr.Bravery.high"],
    ]}
    {ru = "Кроличья лапка", en = "Rabbit Foot", factors = [
        ["trait.lucky"],
        ["trait.lucky", "attr.Bravery.low"],  // трусоват, зато везёт
    ]}
    {ru = "Шкура", en = "the Hide", factors = [
        ["trait.survivor"],                      // живучий, выживает несмотря ни на что
        ["trait.tough", "attr.Hitpoints.high"],
        ["trait.greedy"],                        // ironic: своя шкура — дороже всего
    ]}
    {ru = "Мертвец", en = "Corpse", factors = [
        ["trait.fragile", "trait.deathwish"],    // бледный, мёртвый вид
        ["trait.pessimist", "trait.deathwish"],
    ]}
    {ru = "Колобок", en = "Dumpling", factors = [
        ["trait.fat", "trait.survivor"],   // круглый, ушёл от всех проблем
        ["trait.lucky", "trait.fat"],
        ["trait.lucky", "trait.survivor"],
    ]}
    {ru = "Герой", en = "Hero", factors = [
        ["trait.dumb", "trait.lucky"],    // ironic: трус, которому пока просто везло
        ["trait.dumb", "trait.brave"],
        ["trait.lucky", "trait.brave"],
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
    {ru = "Самородок", en = "Natural", factors = [
        ["perk.gifted"],  // born with exceptional talent
    ]}
    {ru = "Ворон", en = "Raven", factors = [
        ["background.gravedigger"],
        ["trait.pessimist"],  // предвестник несчастья
    ]}
    {ru = "Барсук", en = "Badger", factors = [
        ["trait.determined", "trait.tough"],
    ]}
    {ru = "Клещ", en = "Tick", factors = [
        ["trait.determined"],  // не отпускает
        ["trait.determined", "trait.tiny"],
        ["trait.loyal"],       // прицепился и держится
    ]}
    {ru = "Ёрш", en = "Ruffe", factors = [
        ["trait.brute", "trait.impatient"],  // колючий, лезет на рожон
    ]}
    {ru = "Коняга", en = "Workhorse", factors = [
        ["attr.Stamina.high"],
        ["attr.Stamina.high", "trait.tough"],
        ["perk.relentless"],  // tireless in battle
        ["perk.recover"],     // bounces back fast
    ]}
    {ru = "Лев", en = "Lionheart", factors = [
        ["trait.fearless", "cost.high"],
        ["trait.brave", "cost.high"],
        ["attr.Bravery.high", "cost.high"],
    ]}
    {ru = "Таракан", en = "Cockroach", factors = [
        ["trait.survivor"],   // ironic: живёт вопреки всему
        ["trait.survivor", "trait.tough"],
        ["perk.nine_lives"],  // survives anything
    ]}
    {ru = "Бешеный пёс", en = "Maddog", factors = [
        ["trait.bloodthirsty", "trait.irrational"],
    ]}
    {ru = "Тролль", en = "the Troll", factors = [
        ["trait.huge", "trait.dumb"],  // большой и тупой
        ["trait.huge", "trait.brute"],
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
    {ru = "Орёл", en = "Eagle", factors = [
        ["attr.Bravery.high", "trait.brave"],           // гордый, непреклонный
        ["attr.Bravery.high", "trait.eagle_eyes"],
        ["type.ranged", "trait.eagle_eyes", "attr.RangedSkill.high"],  // видит и попадает
    ]}
    {ru = "Зверь", en = "Beast", factors = [
        ["trait.bloodthirsty", "trait.huge"],
        ["trait.bloodthirsty", "trait.strong"],
        ["background.wildman", "trait.bloodthirsty"],  // дикарь с кровожадностью
    ]}
    {ru = "Пёс", en = "Hound", factors = [
        ["background.houndmaster"],
        ["background.houndmaster", "trait.loyal"],  // водил псов — сам стал псом отряда
        ["trait.loyal"],
        ["perk.underdog"],
    ]}
    {ru = "Альфа", en = "Alpha", factors = [
        ["background.houndmaster", "trait.brave"],   // привык быть вожаком стаи
        ["background.houndmaster", "trait.strong"],
        ["background.houndmaster", "attr.Bravery.high"],
    ]}
    {ru = "Чертёнок", en = "Imp", factors = [
        ["trait.tiny", "trait.bright"],
        ["trait.tiny", "trait.bright", "trait.weasel"],  // мелкий, умный, пролезет куда угодно
        ["trait.tiny", "trait.bright", "trait.irrational"],
    ]}
    {ru = "Псина", en = "Mutt", factors = [
        ["trait.brute", "trait.disloyal"],         // злой и ненадёжный — пёс без хозяина
        ["trait.brute", "background.houndmaster"],
    ]}
    {ru = "Курица", en = "Chicken", factors = [
        ["trait.night_blind"],  // куриная слепота — буквально
    ]}
    {ru = "Фонарь", en = "Lantern", factors = [
        ["trait.night_blind"],  // без фонаря ни шагу — ironic: зовут Фонарём
    ]}
    {ru = "Слепень", en = "Horsefly", factors = [
        ["trait.night_blind"],
        ["trait.short_sighted"],  // летит прямо куда не надо
    ]}
    {ru = "Шмель", en = "Hornet", factors = [
        ["trait.tiny", "trait.brute"],
        ["trait.tiny", "trait.impatient"],
    ]}
    {ru = "Рысь", en = "Lynx", factors = [
        ["trait.swift", "attr.Initiative.high"],
        ["trait.eagle_eyes", "attr.Initiative.high"],
    ]}
    {ru = "Мул", en = "Mule", factors = [
        ["trait.determined", "attr.Stamina.high"],
        ["attr.Stamina.high", "trait.tough"],
    ]}
    {ru = "Соколик", en = "Falcon", factors = [
        ["background.hackflows_falconer"],
        ["type.ranged", "trait.eagle_eyes"],
        ["type.ranged", "trait.eagle_eyes", "attr.RangedSkill.high"],
    ]}
    {ru = "Хорёк", en = "Ferret", factors = [
        ["trait.weasel"],
        ["trait.tiny", "trait.weasel"],
        ["trait.dexterous"],
    ]}
    {ru = "Козёл", en = "Goat", factors = [
        ["trait.determined", "trait.impatient"],
        ["trait.determined", "trait.cocky"],
    ]}
    {ru = "Жаба", en = "Toad", factors = [
        ["trait.fat", "attr.Initiative.low"],
        ["trait.paranoid", "attr.Initiative.low"],
    ]}
    {ru = "Сорока", en = "Magpie", factors = [
        ["trait.greedy"],
        ["perk.bags_and_belts"],
        ["trait.greedy", "perk.bags_and_belts"],
        ["background.graverobber", "trait.bright"],
    ]}
    {ru = "Бобёр", en = "Beaver", factors = [
        ["background.lumberjack", "trait.determined"],
        ["background.hackflows_carpenter", "trait.determined"],
    ]}
    {ru = "Волкодав", en = "Wolfhound", factors = [
        ["trait.hate_beasts", "attr.MeleeSkill.high"],
        ["trait.hate_beasts", "attr.RangedSkill.high"],
        ["trait.hate_beasts", "background.houndmaster"],
    ]}
    {ru = "Сурок", en = "Groundhog", factors = [
        ["attr.Initiative.low", "trait.night_owl"],  // медленный ночной наблюдатель
    ]}
    {ru = "Жук", en = "Beetle", factors = [
        ["trait.tiny", "trait.tough"],  // маленький, но крепкий
    ]}
    {ru = "Крот", en = "Mole", factors = [
        ["background.miner", "trait.night_owl"],  // шахтёр в темноте
        ["trait.short_sighted"],                  // буквально как крот
    ]}
    {ru = "Сыч", en = "Screech Owl", factors = [
        ["trait.night_owl"],  // маленькая мрачная сова
    ]}
    {ru = "Бес", en = "Fiend", factors = [
        ["trait.tiny", "trait.bloodthirsty"],  // мелкий, злой, проказник
        ["trait.tiny", "trait.irrational"],
    ]}
    {names = [
        {ru = "Ворона", en = "the Crow"},
        {ru = "Растяпа", en = "Klutz"},
    ], factors = [
        ["trait.clumsy"],  // всё проворонит
    ]}
    {ru = "Боров", en = "Porker", factors = [
        ["trait.fat", "trait.bloodthirsty"],  // жирный и наглый, прёт буром
        ["trait.fat", "trait.cocky"],
        ["trait.gluttonous", "trait.cocky"],
    ]}
    {ru = "Бык", en = "the Bull", factors = [
        ["trait.huge", "trait.strong"],       // упрямый, сильный — прёт напролом
        ["trait.determined", "trait.strong"],
        ["trait.strong", "trait.dumb"],
    ]}
    {ru = "Тюлень", en = "the Seal", factors = [
        ["trait.fat", "attr.Initiative.low"],  // медленный и жирный
    ]}
    {ru = "Шакал", en = "Jackal", factors = [
        ["trait.greedy", "trait.disloyal"],
        ["trait.greedy", "background.graverobber"],  // стервятник, жадный до чужого
        ["trait.greedy", "background.ratcatcher"],   // подбирает всё, что плохо лежит
    ]}
    {ru = "Змея", en = "Snake", factors = [
        ["trait.disloyal", "background.assassin"],    // предатель по натуре
        ["trait.disloyal", "background.thief"],       // скользкий тип
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
    {names = [
        {ru = "Пень", en = "Stump"},
        {ru = "Чурбан", en = "Blockhead"},
    ], factors = [
        ["trait.dumb"],
    ]}
    {ru = "Руки-крюки", en = "Butterfingers", factors = [
        ["trait.clumsy"],
        ["type.melee", "attr.MeleeSkill.low"],
        ["type.ranged", "attr.RangedSkill.low"],
    ]}
    {ru = "Лапоть", en = "Bumpkin", factors = [
        ["background.farmhand", "trait.dumb"],
        ["background.daytaler", "trait.dumb"],
    ]}
    {ru = "Дохлый", en = "Half-dead", factors = [
        ["trait.fragile", "attr.Hitpoints.low"],
        ["attr.Stamina.low", "attr.Hitpoints.low"],
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
    {ru = "Чумной", en = "Cracked", factors = [
        ["trait.irrational", "trait.deathwish"],
        ["background.flagellant"],
    ]}
    {ru = "Балда", en = "Numbskull", factors = [
        ["trait.dumb"],
        ["trait.dumb", "trait.brute"],
    ]}
    {ru = "Простак", en = "Simpleton", factors = [
        ["trait.dumb"],
        ["background.farmhand"],
        ["background.daytaler"],
    ]}
    {names = [
        {ru = "Скользкий", en = "Slippy"},
        {ru = "Склизкий", en = "Slippery"},
    ], factors = [
        ["trait.weasel"],
        ["trait.weasel", "trait.dexterous"],
        ["background.thief"],
        ["background.hackflows_con_artist"],
    ]}
    {ru = "Копуша", en = "Slowpoke", factors = [
        ["attr.Initiative.low"],
        ["attr.Initiative.low", "trait.fat"],
        ["attr.Initiative.low", "attr.Stamina.low"],
    ]}
    {ru = "Мягкий", en = "Squishy", factors = [
        ["trait.fragile"],
        ["attr.Hitpoints.low", "trait.fragile"],
        ["trait.legend_frail"],  // легенда о хрупкости
    ]}
    {ru = "Невежда", en = "Clueless", factors = [
        ["group.pauper", "trait.dumb"],
    ]}
    {ru = "Вялый", en = "Dullard", factors = [
        ["attr.Stamina.low"],
        ["attr.Initiative.low"],
        ["trait.ailing"],
    ]}
    {names = [
        {ru = "Пыхтун", en = "Puffer"},
        {ru = "Одышка", en = "Pursy"},
        {ru = "Пыхпых", en = "Huffpuff"},
    ], factors = [
        ["attr.Stamina.low"],
        ["attr.Stamina.low", "trait.fat"],       // пыхтит под собственным весом
        ["attr.Stamina.low", "trait.asthmatic"],
    ]}
    {ru = "Большой дурак", en = "Big Dumb", factors = [
        ["trait.huge", "trait.dumb"],
    ]}
    {ru = "Мазила", en = "Miss", factors = [
        ["type.ranged", "attr.RangedSkill.low"],  // стреляет — и мимо
        ["type.melee", "attr.MeleeSkill.low"],
        ["background.hackflows_master_archer", "attr.RangedSkill.low"],  // ironic: мастер, а мажет
    ]}
    {ru = "Тряпки", en = "Rags", factors = [
        ["group.pauper"],
    ]}
    {ru = "Дно", en = "Rock Bottom", factors = [
        ["trait.drunkard"],
        ["trait.drunkard", "trait.pessimist"],  // пьяный нытик — ниже некуда
        ["trait.pessimist"],
    ]}
    {ru = "Жалкий", en = "Pitiful", factors = [
        ["trait.craven", "attr.MeleeSkill.low"],
        ["trait.fragile", "trait.craven"],
    ]}
    {ru = "Развалина", en = "Crumbler", factors = [
        ["trait.ailing"],
        ["trait.ailing", "trait.fragile"],
        ["trait.ailing", "attr.Hitpoints.low"],
    ]}
    {ru = "Болван", en = "Oaf", factors = [
        ["trait.dumb", "trait.huge"],    // тупой, большой
        ["trait.dumb", "trait.strong"],
    ]}
    {ru = "Бревно", en = "Timber", factors = [
        ["attr.Initiative.low", "trait.huge"],  // медленный, неуклюжий, но тяжёлый
        ["attr.Initiative.low", "trait.dumb"],
    ]}
    {ru = "Дрын", en = "Cudgel", factors = [
        ["trait.huge", "trait.brute"],  // огромный, тупой детина, бьёт с размаху
        ["trait.huge", "trait.dumb"],
        ["trait.huge", "weapon.mace"],
    ]}
    {ru = "Мясо", en = "Cannon Fodder", factors = [
        ["trait.dumb", "trait.deathwish"],     // расходный материал, идёт вперёд жрать урон
        ["background.brawler", "trait.fat"],
        ["trait.survivor", "trait.deathwish"],
    ]}
    {ru = "Кляча", en = "Old Nag", factors = [
        ["trait.clubfooted", "trait.asthmatic"],  // больной и еле волочит ноги
        ["trait.clubfooted", "trait.ailing"],
    ]}
    {ru = "Бубен", en = "Tambourine", factors = [
        ["trait.iron_jaw", "trait.dumb"],          // лицо как бубен, только получает по нему
        ["background.brawler", "trait.cocky"],
        ["trait.brute"],
    ]}
    {ru = "Сморчок", en = "Wisp", factors = [
        ["trait.tiny", "trait.ailing"],  // маленький, больной и сморщенный
        ["trait.tiny"],
    ]}
    {ru = "Мордоворот", en = "Ugly Mug", factors = [
        ["background.brawler", "trait.huge"],              // страшный и квадратный
        ["background.hackflows_bodyguard", "trait.huge"],
    ]}
    {ru = "Жбан", en = "Tankard", factors = [
        ["trait.iron_jaw", "background.brawler"],  // башка крепкая как кувшин
        ["trait.drunkard", "trait.iron_jaw"],
    ]}
    {ru = "Балалайка", en = "Balalaika", factors = [
        ["background.minstrel", "trait.dumb"],  // трендит без умолку и пустая внутри
        ["trait.cocky", "trait.dumb"],
    ]}
    {ru = "Валенок", en = "Felt Boot", factors = [
        ["trait.dumb", "trait.optimist"],      // тёплый, но тупой
    ]}
    {ru = "Отбивная", en = "Cutlet", factors = [
        ["trait.survivor", "trait.ailing"],     // бьют все, а он живёт
        ["background.brawler", "trait.ailing"],
    ]}
    {ru = "Обуза", en = "Deadweight", factors = [
        ["trait.clumsy", "trait.fainthearted"],      // тащить тяжело, а бросить жалко
        ["trait.clubfooted", "trait.fainthearted"],
    ]}
    {names = [
        {ru = "Чучело", en = "Scarecrow"},
        {ru = "Пугало", en = "Bogey"},
    ], factors = [
        ["trait.fainthearted", "trait.huge"],       // выглядит страшно, но пустой
        ["background.farmhand", "perk.fearsome"],
        ["perk.fearsome"],
    ]}
    {ru = "Грабли", en = "Rake", factors = [
        ["trait.clumsy", "trait.pessimist"],  // неуклюжий, но опасный
        ["background.farmhand"],
    ]}
    {ru = "Олух", en = "Clod", factors = [
        ["trait.dumb", "trait.clumsy"],  // просто классический олух
    ]}
    {ru = "Рохля", en = "the Dawdler", factors = [
        ["attr.Initiative.low", "trait.clumsy"],  // пока замахнётся мечом, бой уже заканчивается
    ]}
    {ru = "Увалень", en = "Waddler", factors = [
        ["trait.fat", "trait.clumsy"],  // толстый, неповоротливый
    ]}
    {ru = "Тюфяк", en = "Stuffed Sack", factors = [
        ["trait.fainthearted", "trait.fat"],  // мягкий, толстый и бесполезный
    ]}
    {ru = "Телёнок", en = "Calf", factors = [
        ["trait.fainthearted"],                    // большой, тупой и безвредный для врагов
        ["trait.dumb", "trait.fainthearted"],
    ]}
    {ru = "Тряпка", en = "Doormat", factors = [
        ["trait.fainthearted", "trait.craven"],   // об него вытирают ноги, а он и рад
        ["trait.fainthearted", "group.pauper"],
    ]}
    {ru = "Мокрые Штаны", en = "Wet Britches", factors = [
        ["attr.Bravery.low"],                     // не держит ни строй, ни мочевой пузырь
        ["trait.craven", "attr.Bravery.low"],
    ]}
    {ru = "Хромой Пёс", en = "Limping Hound", factors = [
        ["trait.clubfooted", "trait.survivor"],  // тащится позади всего отряда
    ]}
    {names = [
        {ru = "Мыслитель", en = "the Thinker"},
        {ru = "Дырявая Башка", en = "Cracked Skull"},
        {ru = "Юродивый", en = "Holy Fool"},
    ], factors = [
        ["injury.brain_damage"],
    ]}
    {ru = "Плясун", en = "the Dancer", factors = [
        ["injury.broken_knee", "trait.drunkard"],  // еле стоит на ногах
    ]}
    {ru = "Клешня", en = "Pincer", factors = [
        ["injury.broken_elbow_joint"],
        ["injury.broken_elbow_joint", "background.beggar"],
    ]}
    {ru = "Ухо", en = "Ear", factors = [
        ["injury.missing_ear"],  // ironic: нет уха — зовут Ухом
    ]}
    {ru = "Полушка", en = "Half-ear", factors = [
        ["injury.missing_ear"],  // было два уха, осталось полтора
        ["trait.tiny", "trait.greedy"],  // мелкий и жадный — цена ему полушка
    ]}
    {ru = "Культяпка", en = "Stub", factors = [
        ["injury.missing_hand"],
    ]}
    {ru = "Пуганый", en = "Spooked", factors = [
        ["injury.traumatized"],
    ]}
    {ru = "Блаженный", en = "Blessed", factors = [
        ["injury.traumatized"],
        ["injury.traumatized", "trait.optimist"],  // после всего, что видел — сидит с улыбкой
    ]}
    {ru = "Синяк", en = "Bruise", factors = [
        ["injury.weakened_heart"],
        ["injury.weakened_heart", "attr.Stamina.low"],
        ["trait.ailing"],  // ironic: синеет при нагрузке
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
    {names = [
        {ru = "Дышло", en = "Bellows"},
        {ru = "Хрипун", en = "Raspy"},
    ], factors = [
        ["trait.asthmatic"],
        ["injury.collapsed_lung_part"],
        ["trait.iron_lungs", "attr.Stamina.low"],  // ironic
    ]}
    {ru = "Мехи", en = "Wind Pumps", factors = [
        ["trait.iron_lungs"],  // кузнечные меха: качает воздух без устали
    ]}
    {ru = "Труба", en = "Foghorn", factors = [
        ["trait.iron_lungs"],
        ["background.minstrel", "trait.iron_lungs"],  // дышит как труба, слышно на весь лагерь
    ]}
    {ru = "Бурдюк", en = "Wineskin", factors = [
        ["trait.iron_lungs"],
        ["trait.iron_lungs", "trait.drunkard"],  // ironic: бурдюк с воздухом — или с вином
    ]}
    {ru = "Задохлик", en = "Сhoke", factors = [
        ["trait.asthmatic"],
        ["attr.Stamina.low", "trait.asthmatic"],
        ["attr.Stamina.low", "attr.Hitpoints.low"],
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
        ["background.lumberjack", "weapon.axe"],
        ["background.wildman", "weapon.axe"],  // дикарь с топором — та же работа
    ]}
    {ru = "Дуболом", en = "Oaf Feller", factors = [
        ["background.lumberjack"],
        ["background.lumberjack", "weapon.axe"],
        ["trait.strong", "weapon.axe"],  // рубит как заправский лесоруб
        ["trait.strong", "trait.dumb"],
    ]}
    {ru = "Мясной щит", en = "Meatshield", setting = false, factors = [
        ["attr.Hitpoints.high", "attr.MeleeDefense.high"],  // стоит впереди и держит удар
        ["attr.Hitpoints.high", "trait.survivor"],  // мясной и можно пожертвовать
    ]}
    {ru = "Звонарь", en = "Bell Ringer", factors = [
        ["background.hackflows_town_watchman"],
    ]}
    {ru = "Стражник", en = "Town Guard", factors = [
        ["background.hackflows_town_watchman"],
        ["background.militia"],
    ]}
    {names = [
        {ru = "Рекрут", en = "Recruit"},
        {ru = "Частокол", en = "Palisade"},
        {ru = "Деревня", en = "Village Boy"},
        {ru = "Земляк", en = "Homeboy"},
    ], factors = [
        ["background.militia"],
    ]}
    {ru = "Проводник", en = "Pathfinder", factors = [
        ["background.hackflows_cartographer"],
        ["trait.sure_footing"],                              // знает, куда ступить
        ["background.hackflows_cartographer", "trait.sure_footing"],
        ["perk.pathfinder"],  // literal match
    ]}
    {names = [
        {ru = "Козлик", en = "Billy Goat"},
        {ru = "Верный Шаг", en = "Sure Step"},
    ], factors = [
        ["trait.sure_footing"],
    ]}
    {ru = "Полукровка", en = "Half-Blood", factors = [
        ["background.bastard"],
    ]}
    {names = [
        {ru = "Байстрюк", en = "By-blow"},
        {ru = "Нагуляный", en = "Love Child"},
        {ru = "Отпрыск", en = "Offspring"},
        {ru = "Левый Сын", en = "Left-Hand Son"},
        {ru = "Случайный", en = "Accident"},
    ], factors = [
        ["background.bastard"],
    ]}
    {ru = "Каблук", en = "Cobbler", factors = [
        ["background.hackflows_cobbler"],
        ["attr.Initiative.low"],
    ]}
    {ru = "Петля", en = "Noose", factors = [
        ["background.hackflows_hangman"],
    ]}
    {ru = "Заплатка", en = "Patches", factors = [
        ["background.tailor"],
    ]}
    {ru = "Знаменосец", en = "Standard Bearer", factors = [
        ["perk.rally_the_troops"],  // rallies the company
        ["perk.rally_the_troops", "background.militia"],          // the sergeant of the militia
        ["perk.rally_the_troops", "background.retired_soldier"],  // old soldier leading by example
    ]}
    {ru = "Дудочник", en = "Pied Piper", factors = [
        ["background.minstrel"],
        ["background.minstrel", "trait.optimist"],  // весёлый — и дудит
    ]}
    {ru = "Вилы", en = "Pitchfork", factors = [
        ["background.farmhand"],
        ["background.farmhand", "weapon.spear"],  // вилы — они и есть вилы
    ]}
    {ru = "Ходок по доскам", en = "Plank Walker", factors = [
        ["background.hackflows_pirate"],
    ]}
    {ru = "Перо", en = "Quill", factors = [
        ["background.hackflows_fletcher"],
        ["background.hackflows_fletcher", "type.ranged"],  // сам делает стрелы — сам стреляет
    ]}
    {ru = "Лопата", en = "Shovel", factors = [
        ["background.gravedigger"],
        ["background.miner"],
    ]}
    {ru = "Кастрюля", en = "Stewpot", factors = [
        ["background.hackflows_cook"],
    ]}
    {ru = "Могила", en = "Tomb", factors = [
        ["background.gravedigger"],
        ["background.graverobber"],
    ]}
    {ru = "Расхититель", en = "Tomb Raider", factors = [
        ["background.graverobber"],
        ["background.graverobber", "trait.greedy"],
    ]}
    {ru = "Подёнщик", en = "Odd Jobs", factors = [
        ["background.daytaler"],
    ]}
    {ru = "Большой улов", en = "Big Catch", factors = [
        ["background.fisherman", "trait.lucky"],
    ]}
    {ru = "Клещи", en = "Iron Tongs", factors = [
        ["background.hackflows_torturer"],
        ["background.hackflows_blacksmith"],
    ]}
    {ru = "Кровища", en = "Bloodbath", factors = [
        ["trait.bloodthirsty", "trait.irrational"],
        ["background.hackflows_surgeon"],                       // ironic: руки в крови по локоть
        ["background.hackflows_surgeon", "trait.bloodthirsty"],
        ["background.butcher", "trait.bloodthirsty"],
    ]}
    {ru = "Без башни", en = "Wildcard", setting = false, factors = [
        ["trait.irrational"],
        ["trait.irrational", "trait.impatient"],
        ["trait.bloodthirsty", "trait.irrational"],  // никогда не знаешь чего ждать
    ]}
    {ru = "Ветерок", en = "Breeze", factors = [
        ["trait.weasel", "trait.night_owl"],
        ["background.thief", "attr.Initiative.high", "trait.dexterous"],
    ]}
    {ru = "Болячка", en = "Sore", factors = [
        ["trait.ailing"],
        ["trait.ailing", "trait.pessimist"],
    ]}
    {ru = "Дозорный", en = "Watchman", factors = [
        ["background.hackflows_town_watchman", "trait.eagle_eyes"],
        ["background.hackflows_town_watchman", "attr.Initiative.high"],
    ]}
    {ru = "Колдун", en = "Sorcerer", factors = [
        ["background.hackflows_druid"],
        ["background.cultist"],
        ["background.hackflows_herbalist"],
    ]}
    {ru = "Дед", en = "Gramps", factors = [
        ["background.retired_soldier", "attr.Stamina.low"],
        ["background.retired_soldier", "cost.low"],
    ]}
    {ru = "Самосуд", en = "Vigilante", factors = [
        ["background.witchhunter", "trait.bloodthirsty"],
        ["background.killer_on_the_run"],
    ]}
    {names = [
        {ru = "Кошель", en = "Moneybag"},
        {ru = "Барыга", en = "Fence"},
    ], factors = [
        ["trait.greedy", "background.peddler"],  // жадный торговец
    ]}
    {ru = "Пахарь", en = "Ploughman", factors = [
        ["background.farmhand", "attr.Stamina.high"],  // работяга-земледелец
    ]}
    {ru = "Шарманка", en = "Hurdy-gurdy", factors = [
        ["background.minstrel", "trait.pessimist"],      // тянет одну унылую песню
        ["background.minstrel", "trait.superstitious"],
        ["trait.pessimist", "trait.superstitious"],
    ]}
    {ru = "Коновал", en = "Quack", factors = [
        ["background.butcher", "trait.dumb"],               // вообще-то лекарь, но пациенты помирают
        ["background.hackflows_surgeon", "trait.clumsy"],
        ["background.hackflows_surgeon", "trait.dumb"],
    ]}
    {ru = "Отшельник", en = "Hermit", factors = [
        ["background.wildman", "trait.paranoid"],           // дикий и шарахается от людей
        ["background.hackflows_druid", "trait.paranoid"],
    ]}
    {ru = "Деревенщина", en = "Yokel", factors = [
        ["background.farmhand", "trait.clumsy"], // неуклюжий колхозник
        ["group.lowborn", "trait.superstitious"],
    ]}
    {ru = "Папаша", en = "Pop", factors = [
        ["trait.teamplayer", "background.brawler"], // защищает молодых бойцов кулаками
        ["trait.teamplayer", "trait.bright"],
    ]}
    {ru = "Землекоп", en = "Digger", factors = [
        ["background.gravedigger"],  // закапывает трупы профессионально
    ]}
    {ru = "Шулер", en = "Cardsharp", factors = [
        ["background.juggler", "trait.greedy"],  // обчистит своих же в кости
        ["background.hackflows_con_artist"],
    ]}
    {ru = "Тамада", en = "Toastmaster", factors = [
        ["background.minstrel", "trait.dumb"],  // тупой бард, мешающий шуточками
    ]}
    {ru = "Леший", en = "the Woodsprite", factors = [
        ["background.wildman"],                   // лесной дикарь-параноик
        ["background.wildman", "trait.paranoid"],
    ]}
    {ru = "Знахарь", en = "Witch Doctor", factors = [
        ["background.shaman"],
        ["background.hackflows_druid"],
        ["background.hackflows_surgeon", "trait.irrational"],  // мутные грибы и странная трава
    ]}
    {ru = "Мародёр", en = "Marauder", factors = [
        ["background.deserter", "trait.greedy"],  // дезертир, который вернулся ради лута
    ]}
    {ru = "Шарлатан", en = "Charlatan", factors = [
        ["background.hackflows_con_artist"],  // мастер вешать лапшу на уши
    ]}
    {names = [
        {ru = "Обоз", en = "Baggage Train"},
        {ru = "Погонщик", en = "Drover"},
        {ru = "Колея", en = "the Rut"},
        {ru = "Тюк", en = "the Bundle"},
        {ru = "Пыль Столбом", en = "Dustcloud"},
    ], factors = [
        ["background.caravan_hand"],
    ]}
    {names = [
        {ru = "Клетка", en = "the Cage"},
        {ru = "Любимчик", en = "Crowd Favourite"},
        {ru = "Последний бой", en = "Last Fight"},
        {ru = "Сетка", en = "Net Fighter"},
    ], factors = [
        ["background.gladiator"],
    ]}
    {ru = "Пилигрим", en = "Pilgrim", factors = [
        ["weapon.staff", "group.peaceful"],
        ["group.peaceful"],
        ["background.monk", "group.peaceful"],
    ]}

    // ── Происхождение ────────────────────────────────────────────────────
    {ru = "Белоручка", en = "Soft Hands", factors = [
        ["group.noble"],  // барин в полевых условиях
    ]}
    {ru = "Клинок", en = "the Blade", factors = [
        ["background.sellsword"],          // буквально продавал меч
    ]}
    {names = [
        {ru = "Задаток", en = "Down Payment"},
        {ru = "Серебро", en = "Silver"},
        {ru = "Ничего Личного", en = "Nothing Personal"},
        {ru = "Свободный", en = "Free Blade"},
    ], factors = [
        ["background.sellsword"],
    ]}
    {ru = "Холоп", en = "Serf", factors = [
        ["background.servant"],
        ["trait.legend_fear_nobles"],      // страх перед господами — у него в крови
    ]}
    {names = [
        {ru = "Лакей", en = "Lackey"},
        {ru = "Метла", en = "Broom"},
        {ru = "Поклон", en = "the Bow"},
    ], factors = [
        ["background.servant"],
    ]}
    {ru = "Кирпич", en = "Brick", factors = [
        ["background.mason"],
        ["background.mason", "trait.iron_jaw"],  // крепкий и квадратный
    ]}
    {names = [
        {ru = "Плита", en = "Slab"},
        {ru = "Зубило", en = "Chisel"},
    ], factors = [
        ["background.mason"],
    ]}
    {ru = "Паж", en = "Page", factors = [
        ["background.squire"],
    ]}
    {ru = "Коробейник", en = "Pedlar", factors = [
        ["background.peddler"],
        ["perk.bags_and_belts"],  // carries everything with him
    ]}
    {names = [
        {ru = "Торгаш", en = "Huckster"},
        {ru = "Лоток", en = "Tray Man"},
    ], factors = [
        ["background.peddler"],
    ]}
    {ru = "Сюда Иди", en = "Come Hither", factors = [
        ["background.peddler"],
        ["background.peddler", "trait.cocky"],
    ]}
    {ru = "Силки", en = "Snares", factors = [
        ["background.poacher"],            // жил тихо — расставлял ловушки
    ]}
    {names = [
        {ru = "Кот", en = "Tom Cat"},
        {ru = "Ночник", en = "Night Prowler"},
        {ru = "Нычка", en = "Stash"},
    ], factors = [
        ["background.poacher"],
    ]}
    {ru = "Капкан", en = "Trap", factors = [
        ["background.poacher"],
        ["background.poacher", "trait.irrational"],  // ironic: сам попался в наёмники
    ]}
    {ru = "Инквизитор", en = "Inquisitor", factors = [
        ["trait.hate_undead"],
        ["background.monk", "trait.hate_undead"],
        ["background.witchhunter"],
    ]}
    {ru = "Шаман", en = "Shaman", factors = [
        ["background.shaman"],
    ]}
    {ru = "Маменькин сынок", en = "Mama's Boy", factors = [
        ["group.noble", "trait.fainthearted"],  // благородных кровей, при виде крови — в обморок
    ]}
    {ru = "Святоша", en = "Holy Roller", factors = [
        ["trait.bloodthirsty", "background.monk"],    // на нём столько крови — давно должен гореть в аду
        ["trait.bloodthirsty", "trait.superstitious"],
    ]}
    {names = [
        {ru = "Кровосос", en = "Bloodsucker"},
        {ru = "Упырь", en = "Ghoul"},
    ], factors = [
        ["perk.necro.blood_sucking"],
    ]}
    {ru = "Кукловод", en = "Puppeteer", factors = [
        ["perk.necro.mind_meld"],  // bends undead minds to his will
    ]}
    {ru = "Поводырь", en = "the Guide", factors = [
        ["perk.necro.soul_link"],  // водит нежить за собой
    ]}
    {names = [
        {ru = "Голосок", en = "High Voice"},
        {ru = "Дворцовый", en = "Palace Man"},
    ], factors = [
        ["background.eunuch"],
    ]}

    // ── Легендарные черты ─────────────────────────────────────────────────
    {ru = "Берсерк", en = "Berserker", factors = [
        ["trait.legend_aggressive"],
        ["perk.berserk"],                  // literally the berserk perk
        ["perk.killing_frenzy"],           // frenzied after kills
        ["perk.hackflows.battle_flow"],    // keeps the momentum going
    ]}
    {ru = "Жаворонок", en = "Lark", factors = [
        ["trait.legend_diurnal"],      // встаёт с петухами
    ]}
    {ru = "Светлячок", en = "Firefly", factors = [
        ["trait.bright"],
        ["trait.night_blind"],
        ["trait.legend_fear_dark"],    // без огня — никуда
    ]}
    {ru = "Книга", en = "Open Book", factors = [
        ["trait.bright"],
        ["perk.student"],
        ["trait.legend_predictable"],  // читается насквозь
    ]}

    // ── Прочие черты ──────────────────────────────────────────────────────
    {ru = "Подлец", en = "Rascal", factors = [
        ["trait.dastard"],
        ["trait.disloyal"],
    ]}
    {ru = "Сглаз", en = "Jinx", factors = [
        ["trait.superstitious"],  // всё вокруг — дурной знак
    ]}
    {ru = "Мука", en = "Flour", factors = [
        ["background.miller"],  // мельник — мука буквально
    ]}
    {names = [
        {ru = "Водяной", en = "Water Spirit"},
        {ru = "Закрома", en = "the Granary"},
    ], factors = [
        ["background.miller"],
    ]}
    {ru = "Глухарь", en = "Deaf Grouse", factors = [
        ["injury.missing_ear"],
        ["injury.missing_ear", "trait.dumb"],
    ]}
    {ru = "Безрукий", en = "Handless", factors = [
        ["injury.missing_hand"],
        ["type.melee", "attr.MeleeSkill.low", "trait.clumsy"],
    ]}
    {ru = "Беспалый", en = "Fingerless", factors = [
        ["injury.missing_finger"],
        ["injury.missing_finger", "background.hackflows_master_archer"],
    ]}
    {ru = "Подранок", en = "Wounded Bird", factors = [
        ["trait.bleeder"],
        ["injury.maimed_foot", "trait.survivor"],
    ]}
    {ru = "Битый", en = "the Beaten", factors = [
        ["injury.traumatized", "trait.tough"],
        ["trait.survivor", "trait.ailing"],
    ]}
    {ru = "Штык", en = "Bayonet", factors = [
        ["weapon.spear", "attr.MeleeSkill.high"],
        ["weapon.polearm", "perk.reach_advantage"],
        ["weapon.spear", "trait.impatient"],
    ]}
    {ru = "Пращник", en = "Slinger", factors = [
        ["weapon.sling"],
    ]}
    {ru = "Камушек", en = "Pebble", factors = [
        ["weapon.sling", "trait.tiny"],
        ["weapon.sling"],
    ]}
    {ru = "Самострел", en = "Self-Shot", factors = [
        ["weapon.crossbow", "trait.clumsy"],
        ["weapon.crossbow", "trait.dumb"],
    ]}
    {ru = "Залп", en = "Volley", factors = [
        ["weapon.firearm"],
        ["weapon.firearm", "trait.brute"],
    ]}
    {ru = "Рогатина", en = "Boar Spear", factors = [
        ["weapon.spear", "trait.hate_beasts"],
        ["weapon.spear", "background.hunter"],
    ]}
    {ru = "Клевец", en = "War Pick", factors = [
        ["weapon.hammer", "attr.MeleeSkill.high"],
        ["weapon.hammer", "perk.head_hunter"],
    ]}
    {ru = "Кол", en = "Stake", factors = [
        ["weapon.spear", "trait.hate_undead"],
        ["background.witchhunter", "weapon.spear"],
    ]}
    {ru = "Ледоруб", en = "Ice-Cutter", factors = [
        ["weapon.axe", "perk.head_hunter"],
        ["weapon.axe", "trait.strong"],
    ]}
    {ru = "Меткий", en = "Sharpshooter", factors = [
        ["attr.RangedSkill.high", "perk.bullseye"],
        ["type.ranged", "attr.RangedSkill.high", "trait.eagle_eyes"],
    ]}
    {ru = "Оса", en = "Wasp", factors = [
        ["weapon.dagger", "trait.bloodthirsty"],
        ["weapon.dagger", "trait.cocky"],
        ["weapon.dagger", "attr.MeleeSkill.high"],
    ]}
    {ru = "Скала", en = "the Cliff", factors = [
        ["trait.iron_jaw", "attr.Hitpoints.high"],
        ["trait.determined", "trait.tough"],
    ]}
    {ru = "Призрак", en = "Ghost", factors = [
        ["perk.dodge", "trait.dexterous"],
        ["attr.MeleeDefense.high", "attr.RangedDefense.high", "trait.swift"],
    ]}
    {ru = "Подушка", en = "Pillow", factors = [
        ["attr.Hitpoints.high", "attr.MeleeDefense.low", "trait.survivor"],
        ["attr.Hitpoints.high", "trait.tough"],
        ["attr.Hitpoints.high", "trait.fat"],
    ]}
    {ru = "Дуб", en = "Oak", factors = [
        ["attr.Bravery.high", "trait.tough"],
        ["attr.Bravery.high", "trait.determined"],
        ["trait.dumb", "trait.tough"],
        ["trait.sure_footing", "attr.Hitpoints.high"],
    ]}
    {ru = "Булат", en = "Damascus", factors = [
        ["perk.battle_forged", "attr.Bravery.high"],
        ["perk.battle_forged"],
    ]}
    {ru = "Бивень", en = "Tusk", factors = [
        ["trait.iron_jaw", "trait.huge"],
        ["trait.iron_jaw", "perk.fearsome"],
    ]}
    {ru = "Чугун", en = "Pig-Iron", factors = [
        ["trait.iron_jaw", "trait.dumb"],
        ["perk.steel_brow", "trait.dumb"],
    ]}
    {ru = "Чуткий", en = "Hunch", factors = [
        ["perk.anticipation"],
        ["perk.anticipation", "trait.paranoid"],
    ]}
    {ru = "Старожил", en = "Old-Timer", factors = [
        ["perk.nine_lives", "trait.survivor"],
        ["background.retired_soldier", "trait.tough"],
    ]}
    {ru = "Волчара", en = "Grey Wolf", factors = [
        ["perk.lone_wolf", "trait.bloodthirsty"],
        ["perk.lone_wolf", "attr.MeleeSkill.high"],
    ]}
    {ru = "Ураган", en = "Hurricane", factors = [
        ["cost.high", "perk.berserk", "attr.MeleeSkill.high"],
        ["cost.high", "perk.killing_frenzy", "perk.overwhelm"],
    ]}
    {ru = "Лисёнок", en = "Fox Cub", factors = [
        ["background.apprentice", "trait.weasel"],
        ["trait.bright", "trait.weasel", "trait.tiny"],
    ]}
    {ru = "Волчонок", en = "Wolf Cub", factors = [
        ["background.apprentice", "attr.MeleeSkill.high"],
        ["background.apprentice", "trait.bloodthirsty"],
        ["background.squire", "trait.bloodthirsty"],
        ["background.aspirant", "attr.MeleeSkill.high"],
    ]}
    {ru = "Зубоскал", en = "Snickerer", factors = [
        ["trait.cocky", "trait.impatient"],
        ["trait.cocky", "trait.bloodthirsty"],
    ]}
    {ru = "Гусь", en = "Goose", factors = [
        ["trait.cocky", "attr.Stamina.high"],
        ["trait.cocky", "attr.Initiative.high"],
    ]}
    {ru = "Муха", en = "Fly", factors = [
        ["trait.cocky", "trait.impatient"],
        ["trait.tiny", "trait.impatient"],
        ["trait.tiny", "attr.Initiative.high"],
    ]}
    {ru = "Плут", en = "Crook", factors = [
        ["background.thief", "trait.weasel"],
        ["background.hackflows_con_artist", "trait.bright"],
    ]}
    {ru = "Змеёныш", en = "Snakeling", factors = [
        ["trait.weasel", "trait.tiny"],
        ["trait.disloyal", "trait.tiny"],
    ]}
    {ru = "Бедокур", en = "Mischief-Maker", factors = [
        ["trait.irrational", "trait.drunkard"],
        ["background.brawler", "trait.drunkard"],
    ]}
    {ru = "Орколом", en = "Orc-Breaker", factors = [
        ["trait.hate_greenskins", "attr.MeleeSkill.high"],
        ["trait.hate_greenskins", "weapon.hammer"],
    ]}
    {ru = "Травник", en = "Herbman", factors = [
        ["background.hackflows_herbalist"],
        ["background.hackflows_herbalist", "trait.bright"],
    ]}
    {ru = "Голубятник", en = "Pigeon-Keeper", factors = [
        ["background.hackflows_roofer"],
    ]}
    {ru = "Кисточка", en = "Brush", factors = [
        ["background.hackflows_painter", "trait.tiny"],
    ]}
    {ru = "Маляр", en = "Dauber", factors = [
        ["background.hackflows_painter", "trait.dumb"],
    ]}
    {ru = "Тяпка", en = "Hoe", factors = [
        ["background.hackflows_gardener", "trait.dumb"],
        ["background.farmhand", "trait.dumb"],
    ]}
    {ru = "Игла", en = "Needle", factors = [
        ["background.tailor", "weapon.dagger"],
        ["background.tailor", "trait.swift"],
        ["weapon.dagger", "trait.swift"],
    ]}
    {ru = "Ряса", en = "Cassock", factors = [
        ["background.monk"],
        ["background.monk", "attr.Stamina.low"],
    ]}
    {ru = "Служивый", en = "Servicer", factors = [
        ["background.retired_soldier"],
        ["background.retired_soldier", "trait.loyal"],
    ]}
    {ru = "Служака", en = "Barracks Man", factors = [
        ["group.combat", "trait.loyal"],
        ["background.retired_soldier", "trait.loyal"],
    ]}
    {ru = "Сирота", en = "Orphan", factors = [
        ["background.refugee", "trait.fainthearted"],
        ["background.vagabond", "attr.Hitpoints.low"],
    ]}
    {ru = "Горн", en = "Forge", factors = [
        ["background.hackflows_blacksmith"],
        ["background.hackflows_blacksmith", "attr.Hitpoints.high"],
    ]}
    {ru = "Приблудный", en = "Stray", factors = [
        ["background.refugee", "trait.disloyal"],
        ["background.deserter", "trait.disloyal"],
    ]}
    {ru = "Перекати-поле", en = "Tumbleweed", factors = [
        ["background.vagabond", "trait.impatient"],
        ["background.hackflows_drifter", "trait.impatient"],
    ]}
    {ru = "Креститель", en = "Baptist", factors = [
        ["background.witchhunter", "trait.hate_undead"],
        ["background.witchhunter", "perk.fearsome"],
    ]}
    {ru = "Синяя Кровь", en = "Blue Blood", factors = [
        ["group.noble"],
    ]}
    {ru = "Босяк", en = "Bareheel", factors = [
        ["group.pauper", "background.beggar"],
        ["background.vagabond", "attr.Stamina.low"],
    ]}
    {ru = "Дорогой", en = "Pricey", factors = [
        ["cost.high", "trait.greedy"],
        ["cost.high", "attr.MeleeSkill.high"],
    ]}
    {ru = "Кубышка", en = "Piggybank", factors = [
        ["trait.greedy", "attr.Hitpoints.high"],
        ["trait.greedy", "trait.fat"],
    ]}
    {ru = "Лось", en = "Elk", factors = [
        ["trait.huge", "attr.Stamina.high"],
        ["trait.huge", "trait.determined"],
    ]}
    {ru = "Мешок", en = "Sack", factors = [
        ["trait.fat", "attr.Initiative.low"],
        ["trait.fat", "trait.clumsy"],
    ]}
    {ru = "Пузырь", en = "Bubble", factors = [
        ["trait.fragile", "attr.Hitpoints.low"],
        ["trait.fainthearted", "trait.fragile"],
    ]}
    {ru = "Лепёха", en = "Flatbread", factors = [
        ["trait.fat", "trait.fragile"],
        ["trait.fat", "attr.Stamina.low"],
    ]}
    {ru = "Мямля", en = "Drip", factors = [
        ["trait.pessimist", "trait.fainthearted"],
        ["trait.fainthearted", "trait.fragile"],
    ]}
    {ru = "Безносый", en = "Noseless", factors = [
        ["injury.missing_nose"],
        ["injury.missing_nose", "trait.insecure"],
    ]}
    {ru = "Хрящ", en = "Gristle", factors = [
        ["trait.iron_jaw", "trait.tiny"],
        ["trait.tough", "trait.tiny"],
    ]}
    {ru = "Бирюк", en = "Loner", factors = [
        ["trait.paranoid", "perk.lone_wolf"],
        ["trait.paranoid", "background.hackflows_drifter"],
    ]}
    {ru = "Баклан", en = "Cormorant", factors = [
        ["background.fisherman", "trait.cocky"],
        ["background.fisherman", "trait.dumb"],
    ]}
    {ru = "Плакса", en = "Crybaby", factors = [
        ["trait.fainthearted", "trait.craven"],
        ["trait.fainthearted", "attr.Bravery.low"],
    ]}
    {ru = "Зевака", en = "Gawker", factors = [
        ["trait.hesitant", "attr.MeleeSkill.low"],
        ["trait.hesitant", "attr.Initiative.low"],
    ]}
    {ru = "Ловец", en = "Catcher", factors = [
        ["background.ratcatcher"],
        ["background.manhunter"],
        ["background.witchhunter"],
        ["background.beast_slayer"],
    ]}
    {ru = "Каменщик", en = "Mason", factors = [
        ["background.mason"],
    ]}
    {ru = "Битый Жбан", en = "Cracked Pot", factors = [
        ["injury.brain_damage"],
        ["injury.brain_damage", "trait.irrational"],
    ]}
    {ru = "Глаз Да Глаз", en = "One-Eyed Watch", factors = [
        ["injury.missing_eye", "perk.anticipation"],
        ["injury.missing_eye", "trait.paranoid"],
        ["perk.anticipation", "trait.paranoid"],
        ["trait.disloyal", "trait.greedy"],
    ]}
    {ru = "Лихоманка", en = "Fever", factors = [
        ["trait.ailing", "attr.Hitpoints.low"],
        ["trait.ailing", "trait.pessimist"],
    ]}
    {ru = "Драная Шкура", en = "Torn Hide", factors = [
        ["trait.bleeder", "perk.nine_lives"],
        ["trait.bleeder", "trait.tough"],
    ]}
    {ru = "Живучий Кот", en = "Tough Cat", factors = [
        ["perk.nine_lives", "trait.lucky"],
        ["perk.nine_lives", "perk.fast_adaption"],
    ]}
    {ru = "Хромой Чёрт", en = "Limping Devil", factors = [
        ["trait.clubfooted", "trait.bloodthirsty"],
        ["trait.clubfooted", "trait.determined"],
    ]}
    {ru = "Верный Клинок", en = "True Blade", factors = [
        ["weapon.sword", "attr.MeleeSkill.high"],
        ["weapon.sword", "perk.duelist"],
    ]}
    {ru = "Лёгкая Рука", en = "Light Hand", factors = [
        ["trait.dexterous", "weapon.dagger"],
        ["type.melee", "attr.MeleeSkill.high", "trait.swift"],
        ["type.melee", "attr.MeleeSkill.high", "attr.Initiative.high"],
    ]}
    {ru = "Дубовая Стрела", en = "Oaken Arrow", factors = [
        ["weapon.bow", "trait.dumb"],
        ["weapon.bow", "attr.RangedSkill.low"],
    ]}
    {ru = "Три Руки", en = "Three Hands", factors = [
        ["perk.quick_hands", "trait.swift"],
        ["perk.quick_hands", "trait.dexterous"],
        ["perk.quick_hands", "attr.MeleeSkill.high"],
    ]}
    {ru = "Медная Шкура", en = "Copper Hide", factors = [
        ["perk.battle_forged", "attr.Stamina.high"],
        ["perk.battle_forged", "perk.colossus"],
    ]}
    {ru = "Бычья Шея", en = "Ox Neck", factors = [
        ["trait.strong", "perk.steel_brow"],
        ["trait.huge", "perk.steel_brow"],
    ]}
    {ru = "Лёгкие Ноги", en = "Light Foot", factors = [
        ["perk.footwork", "trait.swift"],
        ["perk.pathfinder", "trait.swift"],
    ]}
    {ru = "Вторая Кожа", en = "Second Skin", factors = [
        ["perk.nimble", "trait.dexterous"],
        ["perk.nimble", "trait.swift"],
        ["perk.nimble", "attr.Initiative.high"],
    ]}
    {ru = "Кошачья Лапа", en = "Cat Paw", factors = [
        ["perk.footwork", "trait.dexterous"],
        ["trait.dexterous", "attr.MeleeSkill.high"],
    ]}
    {ru = "Медная Глотка", en = "Brass Throat", factors = [
        ["perk.rally_the_troops", "attr.Stamina.high"],
        ["perk.rally_the_troops", "attr.Bravery.high"],
    ]}
    {ru = "Старый Волк", en = "Old Wolf", factors = [
        ["perk.lone_wolf", "background.retired_soldier"],
        ["perk.lone_wolf", "trait.survivor"],
    ]}
    {ru = "Мокрая Курица", en = "Wet Hen", factors = [
        ["trait.craven", "trait.fainthearted"],
        ["trait.craven", "attr.Stamina.low"],
    ]}
    {ru = "Коленки", en = "Shaky Knees", factors = [
        ["trait.craven", "attr.Bravery.low"],
        ["trait.fainthearted", "attr.Initiative.low"],
    ]}
    {ru = "Кислый Хрен", en = "Sour Horseradish", factors = [
        ["trait.pessimist", "trait.hesitant"],
        ["trait.pessimist", "attr.Bravery.low"],
    ]}
    {ru = "Тихий Омут", en = "Quiet Pool", factors = [
        ["trait.pessimist", "attr.MeleeSkill.high"],
        ["perk.fortified_mind", "attr.MeleeSkill.high"],
    ]}
    {ru = "Дурной Глаз", en = "Evil Eye", factors = [
        ["trait.superstitious", "trait.paranoid"],
        ["trait.superstitious", "trait.irrational"],
    ]}
    {ru = "Бешеный Пёс", en = "Mad Dog", factors = [
        ["trait.bloodthirsty", "trait.irrational"],
        ["trait.bloodthirsty", "perk.berserk"],
    ]}
    {ru = "Гнилой Зуб", en = "Rotten Tooth", factors = [
        ["trait.ailing", "trait.pessimist"],
        ["trait.ailing", "trait.drunkard"],
    ]}
    {ru = "Сорняк", en = "Weed", factors = [
        ["trait.survivor", "trait.disloyal"],
        ["trait.survivor", "trait.pessimist"],
    ]}
    {ru = "Гробовщик", en = "Undertaker", factors = [
        ["background.gravedigger"],
    ]}
    {ru = "Старый Монах", en = "Old Monk", factors = [
        ["background.monk", "trait.survivor"],
        ["background.monk", "attr.Bravery.high"],
    ]}
    {ru = "Лесной Волк", en = "Forest Wolf", factors = [
        ["background.wildman", "perk.lone_wolf"],
        ["background.wildman", "trait.bloodthirsty"],
    ]}
    {ru = "Дикий Пёс", en = "Wild Dog", factors = [
        ["background.wildman", "trait.fearless"],
        ["background.wildman", "trait.brute"],
    ]}
    {ru = "Шкурник", en = "Pelter", factors = [
        ["background.poacher", "trait.greedy"],
        ["background.poacher", "weapon.bow"],
    ]}
    {ru = "Конокрад", en = "Horse Thief", factors = [
        ["background.thief", "attr.Initiative.high"],
        ["background.thief", "trait.swift"],
    ]}
    {ru = "Серая Мышь", en = "Grey Mouse", factors = [
        ["background.servant", "trait.tiny"],
        ["background.hackflows_cobbler", "trait.tiny"],
    ]}
    {ru = "Лавочник", en = "Shopkeep", factors = [
        ["background.peddler", "trait.greedy"],
        ["background.peddler", "trait.fat"],
    ]}
    {ru = "Голый Зад", en = "Bare Arse", factors = [
        ["group.pauper", "attr.Stamina.low"],
        ["background.beggar"],
    ]}
    {ru = "Жирный Боров", en = "Fat Hog", factors = [
        ["trait.gluttonous", "trait.fat"],
        ["trait.fat", "trait.strong"],
    ]}
    {ru = "Сон-трава", en = "Sleep-Herb", factors = [
        ["background.hackflows_herbalist", "trait.pessimist"],
        ["trait.pessimist", "attr.Initiative.low"],
    ]}
    {ru = "Сухой Сучок", en = "Dry Twig", factors = [
        ["trait.fragile", "attr.Stamina.low"],
        ["trait.fragile", "trait.ailing"],
    ]}
    {ru = "Толстый Каравай", en = "Fat Loaf", factors = [
        ["trait.fat", "trait.gluttonous"],
        ["trait.fat", "attr.Hitpoints.high"],
    ]}
    {ru = "Тупой Кол", en = "Dull Stake", factors = [
        ["trait.dumb", "trait.determined"],
        ["trait.dumb", "trait.loyal"],
    ]}
    {ru = "Пень С Глазами", en = "Stump-with-Eyes", factors = [
        ["attr.Initiative.low", "trait.dumb"],
        ["trait.huge", "trait.dumb"],
        ["trait.dumb", "trait.eagle_eyes"],
    ]}
    {ru = "Золотые Руки", en = "Golden Hands", factors = [
        ["background.tailor", "attr.MeleeSkill.high"],
        ["background.hackflows_blacksmith", "attr.MeleeSkill.high"],
    ]}
    {ru = "Лошадиная Сила", en = "Horse Power", factors = [
        ["attr.Stamina.high", "attr.Hitpoints.high"],
        ["trait.iron_lungs", "attr.Stamina.high"],
    ]}
];
