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
//   Sword, Axe, Hammer, Spear, Dagger, Mace, Polearm, Bow, Crossbow, Flail, Cleaver, Firearm, Throwing
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
    {ru = "Жердь", en = "Beanpole", factors = [
        ["trait.huge", "attr.Hitpoints.low"],  // долговязый и некрепкий
    ]}
    {ru = "Оглобля", en = "Shaft", factors = [
        ["trait.huge", "attr.Hitpoints.low"],  // высокий и тощий
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
    {ru = "Носатый", en = "Nosy", factors = [
        ["perm.missing_nose_injury"],  // [NOT IMPLEMENTED] нос сломан в драке, криво торчит
    ]}
    // Зубастый — нет обоснования; iron_jaw не про зубы, не использовать
    {ru = "Четыре пальца", en = "Four Fingers", factors = [
        ["perm.missing_finger_injury"],  // [NOT IMPLEMENTED]
    ]}
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
    // Шрам — нет подходящего perm.*; TODO: найти обоснование или убрать
    {ru = "Одноглазый", en = "One-Eye", factors = [
        ["perm.missing_eye_injury"]  // [NOT IMPLEMENTED],
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
    {ru = "Упрямец", en = "Stubborn", factors = [
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
    {ru = "Жмот", en = "Miser", factors = [
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
    {ru = "Трус", en = "Coward", factors = [
        ["trait.craven"],
        ["trait.weasel"],
    ]}
    {ru = "Трусишка", en = "Scaredy Cat", factors = [
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
    {ru = "Брехун", en = "Liar", factors = [
        ["trait.weasel"],
        ["trait.legend_double_tongued"],
    ]}
    {ru = "Двулицый", en = "Two-Face", factors = [
        ["trait.legend_double_tongued"],
    ]}
    {ru = "Лежебока", en = "Lazybones", factors = [
        ["attr.Initiative.low"],  // медленно двигается = ленив
        ["trait.legend_slack"],   // легенда о безделье
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
    {ru = "Скупец", en = "Penny Pincher", factors = [
        ["trait.greedy"],
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
    {ru = "Правдоруб", en = "Truth-cutter", factors = [
        ["background.hackflows_dissenter"],
        ["background.hackflows_dissenter", "trait.bright"],
        ["trait.cocky", "trait.bright"],
    ]}
    {ru = "Гнилой", en = "Rotten", factors = [
        ["trait.disloyal", "trait.greedy"],
        ["trait.disloyal", "background.deserter"],
    ]}
    {ru = "Нелюдь", en = "Non-human", factors = [
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

    // ── Боевые ───────────────────────────────────────────────────────────
    {ru = "Мясник", en = "Butcher", factors = [
        ["background.butcher"],                      // literal: бывший мясник
        ["weapon.Axe", "attr.MeleeSkill.high"],      // эффективно рубит
        ["weapon.Cleaver", "attr.MeleeSkill.high"],  // эффективно рубит
        ["weapon.Cleaver", "trait.bloodthirsty"],    // эффектно рубит
        ["perk.crippling_strikes"],           // maims like a butcher
        ["perk.coup_de_grace"],               // finishes off the helpless
    ]}
    {ru = "Кувалда", en = "Sledgehammer", factors = [
        ["weapon.Hammer"],
        ["weapon.Mace", "trait.strong"],
        ["trait.brute"],  // бьёт в голову со всей дури, без затей
        ["perk.brawny"],  // strong enough to swing heavy weapons
    ]}
    {ru = "Рубака", en = "Slasher", factors = [
        ["weapon.Sword"],  // weapon.* как единственный фактор — слишком широко, но здесь норм
        ["weapon.Axe"],
        ["attr.MeleeSkill.high"],  // просто хорошо машет
    ]}
    {ru = "Крепыш", en = "Strongarm", factors = [
        ["trait.strong"],
        ["trait.athletic"],                        // крепкий телом
        ["trait.strong", "attr.MeleeSkill.high"],  // сила помогает бить точно
        ["trait.athletic", "trait.strong"],        // сила и выносливость
        ["perk.brawny"],  // built for heavy armor
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
        ["weapon.Hammer"],
        ["weapon.Mace"],
    ]}
    {ru = "Топор", en = "Axe", factors = [
        ["weapon.Axe"],
    ]}
    {ru = "Коса", en = "Scythe", factors = [
        ["weapon.Polearm"],  // косящий замах алебарды/глефы
        ["perk.reach_advantage"],    // keeps enemies in the scythe zone
        ["weapon.Spear"],
    ]}
    {ru = "Цепь", en = "the Chain", factors = [
        ["weapon.Flail"],
    ]}
    {ru = "Горлохват", en = "Throat-grabber", factors = [
        ["weapon.Dagger"],
        ["background.hackflows_hangman"],
        ["trait.bloodthirsty"],
        ["perk.backstabber"],  // attacks from behind
    ]}
    {ru = "Жало", en = "Stinger", factors = [
        ["weapon.Dagger"],
        ["weapon.Dagger", "trait.bloodthirsty"],
        ["weapon.Dagger", "attr.MeleeSkill.high"],  // бьёт точно и быстро
        ["weapon.Dagger", "attr.Initiative.high"],  // бьёт точно и быстро
        ["perk.backstabber"],     // stabs from behind
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
        ["perk.fearsome"],       // сеет ужас
        ["perk.coup_de_grace"],  // добивает
    ]}
    {ru = "Головорез", en = "Cutthroat", factors = [
        ["weapon.Axe", "trait.bloodthirsty"],
        ["background.killer_on_the_run"],
        ["background.hackflows_hangman"],
        ["perk.head_hunter"],  // literally goes for the head
        ["perk.backstabber"],  // attacks from behind
    ]}
    {ru = "Маньяк", en = "the Maniac", factors = [
        ["trait.bloodthirsty", "trait.irrational"],
        ["weapon.Cleaver", "trait.irrational"],  // вовсе потерял связь с реальностью
        ["perk.berserk"],          // literally berserk
        ["perk.killing_frenzy"],   // frenzied after kills
    ]}
    {ru = "Молния", en = "Lightning", factors = [
        ["trait.swift", "attr.Initiative.high"],  // стремительный в бою
        ["trait.impatient", "attr.Initiative.high"],
        ["perk.adrenaline"],  // bursts forward in a flash
    ]}
    {ru = "Соколиный глаз", en = "Hawkeye", factors = [
        ["trait.eagle_eyes"],
        ["trait.eagle_eyes", "type.ranged"],  // видит цель — и попадает
        ["perk.bullseye"],  // deadly aim
        ["type.ranged", "attr.RangedSkill.high"],
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
    {ru = "Набожный", en = "the Devout", factors = [
        ["trait.fear_undead"],  // молится — авось поможет
    ]}

    {ru = "Стрела", en = "Arrow", factors = [
        ["background.hackflows_master_archer"],
        ["weapon.Bow", "attr.RangedSkill.high"],
        ["perk.bullseye"],      // never misses
        ["weapon.Bow"],
    ]}
    {ru = "Болт", en = "Bolt", factors = [
        ["weapon.Crossbow"],
    ]}
    {ru = "Яблочко", en = "Bullseye", factors = [
        ["type.ranged", "attr.RangedSkill.high"],
        ["trait.gluttonous", "trait.tiny"],
        ["perk.bullseye"],          // literal translation
        ["weapon.Throwing"],
    ]}
    {ru = "Мастер клинка", en = "Blade Master", factors = [
        ["type.melee", "attr.MeleeSkill.high", "cost.high"],  // дорогой — значит, умеет
        ["background.swordmaster"],
    ]}
    {ru = "Костелом", en = "Bonebreaker", factors = [
        ["weapon.Hammer", "trait.brute"],    // тупое оружие + грубая сила
        ["weapon.Hammer", "attr.MeleeSkill.high"],
        ["weapon.Mace", "trait.brute"],
    ]}
    {ru = "Жнец", en = "Reaper", factors = [
        ["weapon.Polearm", "attr.MeleeSkill.high"],
        ["weapon.Polearm", "trait.bloodthirsty"],  // косит врагов как траву
        ["perk.hackflows.bloody_harvest"],  // keeps enemies in the scythe zone
    ]}
    {ru = "Первая кровь", en = "First Blood", factors = [
        ["trait.bloodthirsty", "attr.Initiative.high"],  // всегда бьёт первым
        ["trait.impatient", "trait.bloodthirsty"],
        ["perk.adrenaline"],  // charges in first
    ]}
    {ru = "Бойня", en = "Slaughterhouse", factors = [
        ["trait.bloodthirsty", "attr.MeleeSkill.high"],
        ["background.butcher", "trait.bloodthirsty", "attr.MeleeSkill.high"],
        ["perk.killing_frenzy"],  // goes on a rampage
    ]}
    {ru = "Смерч", en = "Whirlwind", factors = [
        ["perk.overwhelm"],                              // sweeps through enemies
        ["perk.overwhelm", "attr.MeleeSkill.high"],
        ["perk.overwhelm", "trait.brute"],               // brute-force overwhelm
    ]}
    {ru = "Мал да удал", en = "Small but Sharp", factors = [
        ["trait.tiny", "attr.MeleeSkill.high"],
        ["trait.tiny", "attr.RangedSkill.high"],  // мал, а метко бьёт
        ["perk.underdog"],  // shines when outnumbered
    ]}
    {ru = "Проворный", en = "Nimble", factors = [
        ["trait.dexterous"],
        ["trait.dexterous", "attr.Initiative.high"],
        ["trait.swift", "trait.dexterous"],
        ["perk.nimble"],    // literal match
        ["perk.footwork"],  // moves with agility
    ]}
    {ru = "Сила есть", en = "Dumb Muscle", factors = [
        ["trait.strong", "trait.dumb"],
        ["trait.huge", "trait.strong", "trait.dumb"],  // силища есть — ума не надо
    ]}
    {ru = "Кулак", en = "Fist", factors = [
        ["background.brawler"],
        ["background.brawler", "trait.brute"],
    ]}
    {ru = "Людоед", en = "Man Eater", factors = [
        ["trait.huge", "trait.bloodthirsty"],
        ["trait.bloodthirsty", "trait.brute"],
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
        ["trait.tough"],
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
    {ru = "Острый взгляд", en = "Sharp Eye", factors = [
        ["trait.eagle_eyes"],
        ["trait.eagle_eyes", "type.ranged"],
        ["trait.eagle_eyes", "attr.RangedSkill.high"],
        ["perk.bullseye"],  // pinpoint accuracy
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
        ["background.fisherman", "weapon.Spear"],
        ["background.fisherman", "weapon.Throwing"],
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
        ["weapon.Dagger", "attr.MeleeSkill.high"],
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
        ["weapon.Flail"],
        ["weapon.Flail", "trait.brute"],
        ["weapon.Flail", "attr.MeleeSkill.high"],
    ]}
    {ru = "Карусель", en = "Whirligig", factors = [
        ["weapon.Flail", "perk.berserk"],
        ["weapon.Flail", "perk.hackflows.bloody_harvest"],
        ["weapon.Axe", "perk.berserk"],
        ["weapon.Axe", "perk.hackflows.bloody_harvest"],
        ["background.juggler"],
    ]}
    {ru = "Дробина", en = "Buckshot", factors = [
        ["trait.tiny", "attr.MeleeSkill.high"],
        ["trait.tiny", "attr.RangedSkill.high"],
        ["trait.tiny", "trait.strong"],
    ]}
    {ru = "Щепка", en = "Sliver", factors = [
        ["trait.tiny", "weapon.Dagger"],
    ]}
    {ru = "Зубодробитель", en = "Toothbreaker", factors = [
        ["weapon.Hammer", "trait.brute"],
        ["weapon.Hammer", "perk.head_hunter"],
        ["weapon.Mace", "trait.brute"],
        ["weapon.Mace", "perk.head_hunter"],
    ]}
    {ru = "Гром", en = "Thunder", factors = [
        ["cost.high", "weapon.Hammer"],
        ["cost.high", "weapon.Hammer", "attr.MeleeSkill.high"],
    ]}
    {ru = "Крюк", en = "Hook", factors = [
        ["perk.crippling_strikes"],
        ["background.fisherman"],
        ["background.hackflows_hangman"],
    ]}

    // Boris the Bullet Dodger — Snatch (2000)
    {ru = "Хрен попадёшь", en = "Bullet Dodger", setting = false, factors = [
        ["attr.MeleeDefense.high", "attr.RangedDefense.high"],
        ["perk.dodge"],  // trained to dodge
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
    {ru = "Смертник", en = "Dead Man", factors = [
        ["trait.brave", "trait.deathwish"],                        // храбрый + тяга к смерти
        ["trait.brave", "trait.deathwish", "attr.Hitpoints.low"],  // храбрый + тяга к смерти + реально хилый
    ]}
    {ru = "Без завтра", en = "No Tomorrow", factors = [
        ["trait.deathwish"],
        ["trait.deathwish", "attr.Bravery.high"],  // не боится смерти — и не скрывает
        ["trait.deathwish", "trait.lucky"],
    ]}
    {ru = "Четырёхлистник", en = "Four-Leaf", factors = [
        ["trait.lucky"],
        ["trait.lucky", "trait.survivor"],  // везло уже не раз
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
        ["trait.eagle_eyes"],
        ["trait.eagle_eyes", "attr.RangedSkill.high"],  // видит и попадает
        ["attr.Bravery.high", "trait.brave"],            // гордый, непреклонный
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
    ]}
    {ru = "Псина", en = "Mutt", factors = [
        ["trait.brute", "trait.disloyal"],         // злой и ненадёжный — пёс без хозяина
        ["trait.brute", "background.houndmaster"],
    ]}
    {ru = "Курица", en = "Chicken", factors = [
        ["trait.night_blind"],  // куриная слепота — буквально
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
        ["type.melee", "attr.MeleeSkill.low"],
        ["type.ranged", "attr.RangedSkill.low"],
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
    {ru = "Балда", en = "Numbskull", factors = [
        ["trait.dumb"],
        ["trait.dumb", "trait.brute"],
    ]}
    {ru = "Простак", en = "Simpleton", factors = [
        ["trait.dumb"],
        ["background.farmhand"],
        ["background.daytaler"],
    ]}
    {ru = "Скользкий", en = "Slippy", factors = [
        ["trait.weasel"],
        ["trait.weasel", "trait.dexterous"],
        ["background.thief"],
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
        ["trait.dumb"],
        ["background.farmhand", "trait.dumb"],
        ["background.daytaler", "trait.dumb"],
    ]}
    {ru = "Одышка", en = "Puffer", factors = [
        ["attr.Stamina.low"],
        ["attr.Stamina.low", "trait.fat"],
    ]}
    {ru = "Большой дурак", en = "Big Dumb", factors = [
        ["trait.huge", "trait.dumb"],
        ["trait.huge", "trait.dumb", "trait.brute"],  // громадный, тупой и агрессивный
    ]}
    {ru = "Мазила", en = "Miss", factors = [
        ["type.ranged", "attr.RangedSkill.low"],  // стреляет — и мимо
        ["type.melee", "attr.MeleeSkill.low"],
        ["background.hackflows_master_archer", "attr.RangedSkill.low"],  // ironic: мастер, а мажет
    ]}
    {ru = "Пыхпых", en = "Huffpuff", factors = [
        ["attr.Stamina.low"],
        ["attr.Stamina.low", "trait.fat"],       // пыхтит под собственным весом
        ["trait.asthmatic", "attr.Stamina.low"],
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
    {ru = "Дышло", en = "Bellows", factors = [
        ["trait.asthmatic"],
        ["attr.Stamina.low"],
        ["trait.iron_lungs"],  // ironic
    ]}
    {ru = "Хрипун", en = "Raspy", factors = [
        ["trait.asthmatic"],
        ["trait.iron_lungs"],  // ironic: дышит как сломанные мехи, но не устаёт
    ]}
    {ru = "Задохлик", en = "Сhoke", factors = [
        ["attr.Stamina.low"],
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
        ["background.lumberjack", "weapon.Axe"],
        ["background.wildman", "weapon.Axe"],  // дикарь с топором — та же работа
    ]}
    {ru = "Мясной щит", en = "Meatshield", setting = false, factors = [
        ["attr.Hitpoints.high"],
        ["attr.Hitpoints.high", "attr.MeleeDefense.high"],  // стоит впереди и держит удар
        ["attr.Hitpoints.high", "trait.survivor"],  // мясной и можно пожертвовать
    ]}
    {ru = "Валящий дубы", en = "Oak Feller", factors = [
        ["background.lumberjack"],
        ["background.lumberjack", "weapon.Axe"],
        ["trait.strong", "weapon.Axe"],  // рубит как заправский лесоруб
    ]}
    {ru = "Звонарь", en = "Bell Ringer", factors = [
        ["background.hackflows_town_watchman"],
    ]}
    {ru = "Стражник", en = "Town Guard", factors = [
        ["background.hackflows_town_watchman"],
        ["background.militia"],
    ]}
    {ru = "Проводник", en = "Pathfinder", factors = [
        ["background.hackflows_cartographer"],
        ["trait.sure_footing"],                              // знает, куда ступить
        ["background.hackflows_cartographer", "trait.sure_footing"],
        ["perk.pathfinder"],  // literal match
    ]}
    {ru = "Полукровка", en = "Half-Blood", factors = [
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
        ["background.farmhand", "weapon.Spear"],  // вилы — они и есть вилы
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
        ["background.caravan_hand"],
    ]}
    {ru = "Большой улов", en = "Big Catch", factors = [
        ["background.fisherman", "trait.lucky"],
    ]}
    {ru = "Клещи", en = "Iron Tongs", factors = [
        ["background.hackflows_torturer"],
        ["background.hackflows_blacksmith"],
    ]}
    {ru = "Кровища", en = "Bloodbath", factors = [
        ["background.hackflows_surgeon"],                       // ironic: руки в крови по локоть
        ["background.hackflows_surgeon", "trait.bloodthirsty"],
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

    // ── Происхождение ────────────────────────────────────────────────────
    {ru = "Белоручка", en = "Soft Hands", factors = [
        ["background.adventurous_noble"],  // барин в полевых условиях
    ]}
    {ru = "Клинок", en = "the Blade", factors = [
        ["background.sellsword"],          // буквально продавал меч
    ]}
    {ru = "Холоп", en = "Serf", factors = [
        ["background.servant"],
        ["trait.legend_fear_nobles"],      // страх перед господами — у него в крови
    ]}
    {ru = "Кирпич", en = "Brick", factors = [
        ["background.mason"],              // клал стены — сам как стена
    ]}
    {ru = "Коробейник", en = "Pedlar", factors = [
        ["background.peddler"],
        ["perk.bags_and_belts"],  // carries everything with him
    ]}
    {ru = "Силки", en = "Snares", factors = [
        ["background.poacher"],            // жил тихо — расставлял ловушки
    ]}
    {ru = "Инквизитор", en = "Inquisitor", factors = [
        ["trait.hate_undead"],
        ["background.monk", "trait.hate_undead"],
        ["background.witchhunter"],
    ]}
    {ru = "Паж", en = "Page", factors = [
        ["background.squire"],             // таскал чужой меч
    ]}
    {ru = "Шаман", en = "Shaman", factors = [
        ["background.shaman"],
    ]}
    {ru = "Претендент", en = "Claimant", factors = [
        ["background.aspirant"],
    ]}
    {ru = "Кровосос", en = "Bloodsucker", factors = [
        ["perk.necro.blood_sucking"],
    ]}
    {ru = "Упырь", en = "Ghoul", factors = [
        ["perk.necro.blood_sucking"],  // drains life from enemies
    ]}
    {ru = "Кукловод", en = "Puppeteer", factors = [
        ["perk.necro.mind_meld"],  // bends undead minds to his will
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
    {ru = "Шакал", en = "Jackal", factors = [
        ["trait.greedy", "trait.disloyal"],
        ["trait.greedy", "background.graverobber"],  // стервятник, жадный до чужого
        ["trait.greedy", "background.ratcatcher"],   // подбирает всё, что плохо лежит
    ]}
    {ru = "Змея", en = "Snake", factors = [
        ["trait.disloyal", "background.assassin"],    // предатель по натуре
        ["trait.disloyal", "background.thief"],       // скользкий тип
    ]}
];
