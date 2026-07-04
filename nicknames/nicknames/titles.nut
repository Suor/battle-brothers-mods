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
//         legend_aggressive, legend_light, legend_double_tongued
//   Bad:  ailing, asthmatic, bleeder, clubfooted, clumsy, cocky, craven, dastard, disloyal,
//         dumb, fainthearted, fear_beasts, fear_greenskins, fear_undead, fragile, gluttonous,
//         greedy, hesitant, insecure, irrational, night_blind, pessimist, short_sighted,
//         superstitious, legend_fear_nobles, legend_frail, legend_appetite_donkey, legend_fear_dark,
//         legend_predictable, legend_slack
//   TODO: update legends traits, the list is outdated here
//   EXPLAINED: trait.brute — aggressive, uses crude force, goes for the head.
//              NOT dumb, NOT cocky, NOT pushy.
//
// trait.* (North Expansion)
//   champion, chosen, destined, duel_fighter, feral, moonkissed, shieldmaster,
//   skald, wolfmaster   (thrall is aliased into background.slave)
//
// trait.* (Black Pyramid / Elemental) — one phobia granted at generation (~15%)
//   elem_fear_fire, elem_fear_ice, elem_fear_thunder
//
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
//   Black Pyramid: "elem_fire_affinity", "elem_ice_affinity", "elem_thunder_affinity"
//                  (innate, granted at generation ~1% — no background_perks needed)
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
    "trait.halfbreed":                       "perk.necro.regeneration"
    // Fantasy Bros
    "background.xxherosp":                   "background.adventurous_noble"
    "background.xxheroroyal":                "background.adventurous_noble"
    // Cultist origin
    "background.cultist_commander":          "background.cultist"
    // Lone Chosen / Northern Expansion — both are "the Chosen"
    "background.chosen":                     "trait.chosen"
    // Northen Expansion
    "background.barbarian":                  "background.wildman"
    "trait.thrall":                          "background.slave"  // тралл — бывший раб
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
    {ru = "Малыш", en = "the Little", factors = [
        ["trait.tiny"],  // literal
        ["trait.huge"],  // ironic: для великана
    ]}
    {ru = "Длинный", en = "the Lanky", factors = [
        ["trait.huge"],  // высокий и долговязый
    ]}
    {ru = "Гора", en = "the Mountain", factors = [
        ["trait.huge"],  // literal: громадный
        ["trait.fat"],   // same with a twist
    ]}
    {names = [
        {ru = "Жердь", en = "the Beanpole"},
        {ru = "Оглобля", en = "the Shaft"},
        {ru = "Каланча", en = "the Lamppost"},
    ], factors = [
        ["trait.huge", "attr.Hitpoints.low"],  // долговязый и некрепкий
    ]}
    {ru = "Бочка", en = "the Barrel", factors = [
        ["trait.fat"],
        ["trait.drunkard"],
        ["trait.fat", "trait.drunkard"],
    ]}
    {ru = "Пузо", en = "the Belly", factors = [
        ["trait.fat"],
        ["trait.gluttonous"],  // заслужил привычкой
    ]}
    {ru = "Квашня", en = "the Dough-lump", factors = [
        ["trait.fat", "trait.fragile"],        // мягкий и тучный
        ["trait.fat", "trait.insecure"],
        ["trait.fat", "attr.MeleeSkill.low"],  // тучный и неумелый
    ]}
    {names = [
        {ru = "Нос", en = "the Nose"}
        {ru = "Носатый", en = "the Nosy"}
    ], factors = [
        ["injury.missing_nose"],  // нос сломан в драке, криво торчит
    ]}
    // Зубастый — нет обоснования; iron_jaw не про зубы, не использовать
    {ru = "Четыре пальца", en = "Four Fingers", factors = [
        ["injury.missing_finger"],
    ]}
    {ru = "Кривой", en = "the Crooked", factors = [
        ["trait.clubfooted"],        // ходит вкривь — clubfoot ближайшее
        ["injury.broken_knee"], // нога срослась криво
    ]}
    {ru = "Косой", en = "the Squinty", factors = [
        ["trait.short_sighted"],     // плохое зрение — щурится
        ["injury.missing_eye"], // повреждённый глаз
    ]}
    {names = [
        {ru = "Косолапый", en = "Clubfoot"}
        {ru = "Хромой", en = "Limpy"}
    ], factors = [
        ["trait.clubfooted"],
        ["injury.maimed_foot"],
    ]}
    {ru = "Косматый", en = "the Shaggy", factors = [
        ["background.wildman"],
        ["group.pauper"],
    ]}
    {ru = "Чумазый", en = "the Grimy", factors = [
        ["background.gravedigger"],
        ["background.miner"],
        ["background.ratcatcher"],
        ["background.farmhand"],
    ]}
    {ru = "Бледный", en = "the Pale", factors = [
        ["trait.asthmatic"],  // лёгочник выглядит бледно
        ["trait.fragile"],    // хилый, болезненного вида
        ["attr.Hitpoints.low"],
        ["attr.Bravery.low"],
    ]}
    {ru = "Одноглазый", en = "One-Eye", factors = [
        ["injury.missing_eye"],
    ]}
    {ru = "Меченый", en = "the Marked", factors = [
        ["background.cultist"],    // ритуальные метки
        ["background.flagellant"], // следы самобичевания
    ]}
    {ru = "Муравей", en = "the Ant", factors = [
        ["trait.tiny"],                          // мелкий, как муравей
        ["trait.tiny", "attr.Stamina.high"],     // мелкий, но выносливый
    ]}

    // ── Характер ─────────────────────────────────────────────────────────
    // Молчун — нет механического основания; молчаливость не отражена ни в одном факторе, не использовать
    {ru = "Болтун", en = "the Chatterbox", factors = [
        ["trait.cocky"],  // самодовольный = болтливый
        ["trait.cocky", "trait.dumb"],
    ]}
    {ru = "Горлопан", en = "the Loudmouth", factors = [
        ["trait.cocky"],
        ["perk.taunt"],
        ["perk.rally_the_troops"],
        ["attr.Bravery.high", "attr.Initiative.high"],
    ]}
    {ru = "Нытик", en = "the Whiner", factors = [
        ["trait.pessimist"],
        ["trait.craven"],  // страх выражается нытьём
    ]}
    {ru = "Брюзга", en = "the Grumbler", factors = [
        ["trait.pessimist"],
        ["trait.paranoid"],  // всё видит в чёрном
    ]}
    {ru = "Весельчак", en = "the Jolly", factors = [
        ["trait.optimist"],
    ]}
    {ru = "Ворчун", en = "the Grumpy", factors = [
        ["trait.pessimist"],
    ]}
    {ru = "Туча", en = "the Gloom", factors = [
        ["trait.pessimist", "trait.paranoid"],  // вдвойне мрачный — чёрная туча в отряде
    ]}
    {ru = "Задира", en = "the Bully", factors = [
        ["trait.brute", "trait.impatient"],
        ["perk.taunt"],  // literally taunts enemies into fighting
    ]}
    {ru = "Животное", en = "the Animal", factors = [
        ["trait.brute"],
        ["trait.bloodthirsty"],
        ["trait.dumb"],
        ["trait.drunkard"],
    ]}
    {ru = "Буян", en = "the Rowdy", factors = [
        ["trait.brute"],
        ["trait.drunkard"],  // пьяный дебош
    ]}
    {ru = "Пьянчик", en = "the Boozy", factors = [
        ["trait.drunkard"],
    ]}
    {ru = "Забияка", en = "the Troublemaker", factors = [
        ["background.brawler", "trait.impatient"],
    ]}
    {names = [
        {ru = "Упрямец", en = "the Stubborn"},
        {ru = "Кочерга", en = "the Fire Poker"},
    ], factors = [
        ["trait.determined"],
    ]}
    {ru = "Хитрец", en = "the Sly", factors = [
        ["background.thief"],
        ["background.assassin"],
        ["trait.bright"],  // умный = хитрый
    ]}
    {ru = "Зануда", en = "the Pedant", factors = [
        ["trait.bright"],  // умный, но утомляет
        ["perk.student"],  // вечно учится, вечно поучает
    ]}
    {ru = "Пройдоха", en = "the Schemer", factors = [
        ["background.thief"],
        ["background.hackflows_con_artist"],
        ["trait.bright", "trait.disloyal"],
    ]}
    {names = [
        {ru = "Жмот", en = "the Miser"},
        {ru = "Скупец", en = "the Penny Pincher"},
        {ru = "Скряга", en = "the Skinflint"},
    ], factors = [
        ["trait.greedy"],
    ]}
    {ru = "Обжора", en = "the Gobbler", factors = [
        ["trait.gluttonous"],
        ["trait.gluttonous", "trait.fat"],   // тучный обжора
        ["trait.legend_appetite_donkey"],    // ест как осёл — хуже не бывает
    ]}
    {ru = "Пирожок", en = "Little Pie", factors = [
        ["trait.gluttonous"],  // любит поесть
        ["trait.insecure"],    // мягкий, уютный, ненастоящий боец
        ["trait.fat", "trait.tiny"],
    ]}
    {ru = "Размазня", en = "the Milksop", factors = [
        ["trait.insecure"],                        // literal
        ["trait.fainthearted"],                    // тоже тряпка
        ["trait.insecure", "trait.fainthearted"],  // совсем размазня
    ]}
    {ru = "Тихоня", en = "the Quiet One", factors = [
        ["trait.bloodthirsty"],  // ironic: смирный с виду, страшный в бою
        ["trait.weasel"],        // тихо делает тёмные дела
    ]}
    {ru = "Хамелеон", en = "the Chameleon", factors = [
        ["perk.fast_adaption"],  // adapts to any situation
        ["perk.fast_adaption", "trait.weasel"],  // changes colours to survive
    ]}
    {ru = "Смельчак", en = "the Daredevil", factors = [
        ["trait.brave"],
        ["trait.fearless"],
        ["trait.fearless", "attr.Hitpoints.low"],  // ironic: лезет на рожон, а дунь — упадёт
    ]}
    {names = [
        {ru = "Трус", en = "the Coward"},
        {ru = "Трусишка", en = "the Scaredy Cat"},
    ], factors = [
        ["trait.craven"],
        ["trait.weasel"],
        ["trait.fainthearted"],
        ["trait.craven", "attr.Bravery.low"],  // маленький трусишка
    ]}
    // Трус, Балбес и Бывалый — фильмы Гайдая
    {ru = "Балбес", en = "the Dunce", factors = [
        ["trait.dumb"],
        ["trait.dumb", "trait.clumsy"],
    ]}
    {ru = "Дёрганый", en = "the Twitchy", factors = [
        ["trait.paranoid"],
        ["trait.paranoid", "attr.Initiative.high"],
        ["trait.hesitant"],
        ["trait.impatient"],
    ]}
    {names = [
        {ru = "Тугодум", en = "the Slow Thinker"},
        {ru = "Топтун", en = "the Shuffler"},
        {ru = "Завтра", en = "Tomorrow"},
    ], factors = [
        ["trait.hesitant"],
    ]}
    {ru = "Якорь", en = "the Anchor", factors = [
        ["trait.hesitant"],
        ["background.hackflows_pirate", "trait.hesitant"],
    ]}
    {ru = "Шальной", en = "the Unhinged", factors = [
        ["trait.bloodthirsty"],
        ["trait.deathwish"],
        ["trait.irrational"],
        ["attr.Initiative.high"],
    ]}
    {ru = "Крыса", en = "the Rat", factors = [
        ["trait.disloyal"],
        ["trait.greedy"],
    ]}
    {ru = "Баламут", en = "the Stirrer", factors = [
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
    {ru = "Мятежник", en = "the Rebel", factors = [
        ["trait.disloyal"],
        ["trait.disloyal", "trait.cocky"],    // наглый и нелояльный
        ["trait.disloyal", "trait.impatient"],
    ]}
    {ru = "Лиходей", en = "the Villain", factors = [
        ["background.killer_on_the_run"],
        ["trait.bloodthirsty"],
        ["perk.fearsome"],  // enemies fear him
    ]}
    {ru = "Брехло", en = "the Liar", factors = [
        ["trait.disloyal"],
        ["trait.legend_double_tongued"],
    ]}
    {ru = "Двулицый", en = "Two-Face", factors = [
        ["trait.legend_double_tongued"],
        ["background.hackflows_con_artist"],  // мошенник о двух лицах
    ]}
    {ru = "Лежебока", en = "Lazybones", factors = [
        ["attr.Initiative.low"],  // медленно двигается = ленив
        ["attr.Stamina.low"],
        ["trait.legend_slack"],
    ]}
    {ru = "Заяц", en = "the Hare", factors = [
        ["attr.Initiative.high", "attr.Stamina.low"],  // рванул вперёд и сдулся
    ]}
    {ru = "Верный", en = "the Faithful", factors = [
        ["trait.loyal"],
        ["trait.loyal", "trait.teamplayer"],  // на него можно положиться
    ]}
    {ru = "Товарищ", en = "the Comrade", factors = [
        ["trait.teamplayer"],
        ["trait.teamplayer", "trait.loyal"],
    ]}
    {ru = "Фанатик", en = "the Fanatic", factors = [
        ["background.flagellant"],
        ["background.cultist"],
        ["trait.deathwish", "background.flagellant"],  // идёт до конца
        ["perk.indomitable"],  // fervor makes him unbreakable
    ]}
    {ru = "Голодный", en = "the Hungry", factors = [
        ["trait.gluttonous"],
        ["trait.legend_appetite_donkey"],  // жрёт и не наедается
        ["background.beggar"],   // literal: голодает
        ["background.refugee"],  // нищий беженец всегда голоден
    ]}
    {ru = "Бесстрашный", en = "the Fearless", factors = [
        ["trait.fearless"],
        ["trait.brave", "attr.Bravery.high"],
        ["perk.fortified_mind"],  // iron will, cannot be frightened
    ]}
    {ru = "Хвастун", en = "the Showoff", factors = [
        ["trait.cocky"],
        ["trait.cocky", "attr.MeleeSkill.high"],  // повод для хвастовства есть
    ]}
    {ru = "Неспокойный", en = "the Restless", factors = [
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
    {ru = "Предатель", en = "the Turncoat", factors = [
        ["trait.disloyal"],
        ["background.deserter", "trait.disloyal"],
        ["trait.disloyal", "background.hackflows_dissenter"],
    ]}
    {ru = "Изгой", en = "the Outcast", factors = [
        ["background.hackflows_dissenter"],
        ["background.oathbreaker"],
        ["background.refugee", "trait.disloyal"],
        ["perk.lone_wolf"],  // fights alone, cast out
    ]}
    {names = [
        {ru = "Позор", en = "the Disgrace"},
        {ru = "Отступник", en = "the Apostate"},
        {ru = "Отречённый", en = "the Renounced"},
    ], factors = [
        ["background.oathbreaker"],
        ["background.paladin", "trait.drunkard"],  // спившийся паладин; жив без "Follow excludes"
        ["background.monk", "trait.drunkard"],     // брат-пьяница, позор обители
        ["background.deserter", "trait.craven"],   // бежал с поля — и не стыдится
        ["background.disowned_noble", "trait.drunkard"],  // отречённый роднёй, утешается вином
    ]}
    {ru = "Правдоруб", en = "the Truth-cutter", factors = [
        ["background.hackflows_dissenter"],
        ["background.hackflows_dissenter", "trait.bright"],
        ["trait.cocky", "trait.bright"],
    ]}
    {ru = "Гнилой", en = "the Rotten", factors = [
        ["trait.disloyal", "trait.greedy"],
        ["trait.disloyal", "background.deserter"],
    ]}
    {ru = "Нелюдь", en = "the Inhuman", factors = [
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
    {ru = "Соня", en = "the Sleepy", factors = [
        ["attr.Initiative.low", "attr.Stamina.low"],
        ["attr.Initiative.low", "trait.night_owl"],
    ]}
    {ru = "Заводила", en = "the Instigator", factors = [
        ["trait.impatient", "perk.rally_the_troops"],
        ["trait.cocky", "perk.taunt"],
    ]}
    {ru = "Дурной", en = "Bad-blood", factors = [
        ["trait.irrational"],
        ["trait.irrational", "trait.brave"],
    ]}
    {ru = "Щегол", en = "the Dandy", factors = [
        ["trait.cocky"],               // пёстрый, хвастливый
        ["trait.tiny", "trait.cocky"],
    ]}
    {ru = "Барабан", en = "the Drum", factors = [
        ["trait.cocky", "attr.Bravery.high"],              // громкий, звонкий голос
        ["perk.rally_the_troops"],                         // бьёт в барабан — ведёт за собой
        ["trait.skald", "attr.Bravery.high"],              // задаёт ритм боя
        ["attr.Hitpoints.high", "attr.MeleeDefense.low"],  // сам принимает удары
    ]}
    {ru = "Пиявка", en = "the Leech", factors = [
        ["trait.greedy"],                          // высасывает, прицепился
        ["trait.greedy", "trait.disloyal"],        // забирает и предаёт
        ["perk.hackflows.flesh_on_the_bones"],     // буквально: плоть на костях
    ]}
    {ru = "Угорь", en = "the Eel", factors = [
        ["trait.dexterous", "trait.weasel"],   // скользкий, изворотливый
        ["trait.dexterous", "trait.disloyal"],
    ]}
    {ru = "Крендель", en = "the Pretzel", factors = [
        ["trait.irrational"],                         // с выкрутасами
        ["trait.cocky", "trait.irrational"],
        ["background.juggler", "trait.irrational"],
    ]}
    {ru = "Павлин", en = "the Peacock", factors = [
        ["trait.cocky"],                          // красуется перед боем
        ["background.minstrel", "trait.cocky"],
    ]}
    {ru = "Потроха", en = "Guts", factors = [
        ["trait.bloodthirsty"],                    // всегда угрожает выпустить кишки
        ["trait.bloodthirsty", "trait.irrational"],
        ["background.butcher", "trait.irrational"],
    ]}
    {ru = "Свисток", en = "the Whistle", factors = [
        ["trait.craven", "trait.paranoid"],  // паникер, зовёт на помощь первым
        ["trait.quick", "trait.craven"],
    ]}
    {ru = "Бузотёр", en = "the Rabblerouser", factors = [
        ["trait.bloodthirsty", "trait.irrational"],  // только дай повод начать драку
        ["background.brawler", "trait.drunkard"],
    ]}
    {ru = "Дебошир", en = "the Hellraiser", factors = [
        ["trait.drunkard", "trait.irrational"],  // как напьётся, разносит пол-лагеря
    ]}
    {ru = "Петух", en = "the Cock", factors = [
        ["trait.cocky"],  // постоянно красуется и лезет драться
    ]}
    {ru = "Петушок", en = "the Cockerel", factors = [
        ["trait.cocky", "trait.tiny"],
    ]}
    {ru = "Философ", en = "the Philosopher", factors = [
        ["trait.dumb", "trait.pessimist"],  // вечно рассуждает о тлене перед боем
    ]}
    {ru = "Лицемер", en = "the Hypocrite", factors = [
        ["background.monk", "trait.disloyal"],  // на словах святой, на деле — первый в лут; жив без "Follow excludes"
        ["group.peaceful", "trait.bloodthirsty"],  // мирный с виду, кровожадный внутри
    ]}
    {ru = "Звездочёт", en = "the Stargazer", factors = [
        ["trait.short_sighted"],   // слепо пялится в небо
        ["trait.night_blind"],
        ["trait.bright"],          // ironic: умный — только смотрит не туда
    ]}
    {ru = "Сектант", en = "the Zealot", factors = [
        ["background.cultist", "trait.dumb"],  // тупой фанатик с промытыми мозгами
    ]}
    {ru = "Скоморох", en = "the Jester", factors = [
        ["background.juggler", "trait.irrational"],  // отмачивает тупые шутки, пока всех режут
    ]}
    {ru = "Самоубийца", en = "the Suicide", factors = [
        ["trait.deathwish", "trait.pessimist"],  // только и ищет повода красиво помереть
    ]}
    {ru = "Атаман", en = "the Chieftain", factors = [
        ["perk.rally_the_troops", "trait.cocky"],  // бывший рейдер, сохранивший замашки
    ]}
    {ru = "Кидала", en = "Bunco", factors = [
        ["background.hackflows_con_artist"],
        ["weapon.sling"],
    ]}

    // ── Боевые ───────────────────────────────────────────────────────────
    {ru = "Мясник", en = "the Butcher", factors = [
        ["background.butcher"],                      // literal: бывший мясник
        ["weapon.axe", "attr.MeleeSkill.high"],      // эффективно рубит
        ["weapon.cleaver", "attr.MeleeSkill.high"],  // эффективно рубит
        ["weapon.cleaver", "trait.bloodthirsty"],    // эффектно рубит
        ["perk.crippling_strikes"],           // maims like a butcher
        ["perk.coup_de_grace"],               // finishes off the helpless
    ]}
    {ru = "Кувалда", en = "the Sledgehammer", factors = [
        ["weapon.hammer"],
        ["weapon.mace", "trait.strong"],
        ["trait.brute"],  // бьёт в голову со всей дури, без затей
        ["perk.brawny"],  // strong enough to swing heavy weapons
    ]}
    {ru = "Рубака", en = "the Slasher", factors = [
        ["group.combat", "weapon.sword"],
        ["group.combat", "attr.MeleeSkill.high"],  // просто хорошо машет
        ["background.hackflows_cook", "attr.MeleeSkill.high"],  // ironic
    ]}
    {ru = "Крепыш", en = "the Strongarm", factors = [
        ["trait.strong"],
        ["trait.athletic"],                        // крепкий телом
        ["trait.strong", "attr.MeleeSkill.high"],  // сила помогает бить точно
        ["trait.athletic", "trait.strong"],        // сила и выносливость
        ["perk.brawny"],  // built for heavy armor
    ]}
    {names = [
        {ru = "Борец", en = "the Wrestler"},
        {ru = "Жеребец", en = "the Stallion"},
        {ru = "Удалец", en = "the Gallant"},
    ], factors = [
        ["trait.athletic"],
    ]}
    {ru = "Крепкий Орешек", en = "the Hard Nut", factors = [
        ["trait.athletic", "trait.survivor"],
    ]}
    {ru = "Громила", en = "the Bruiser", factors = [
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
    {ru = "Молот", en = "the Hammer", factors = [
        ["weapon.hammer"],
        ["weapon.mace"],
    ]}
    {ru = "Топор", en = "the Axe", factors = [
        ["weapon.axe"],
    ]}
    {ru = "Коса", en = "the Scythe", factors = [
        ["weapon.polearm"],  // косящий замах алебарды/глефы
        ["perk.reach_advantage"],    // keeps enemies in the scythe zone
        ["weapon.spear"],
    ]}
    {ru = "Цепь", en = "the Chain", factors = [
        ["weapon.flail"],
    ]}
    {ru = "Горлохват", en = "the Throat-cutter", factors = [
        ["weapon.dagger"],
        ["background.hackflows_hangman"],
        ["trait.bloodthirsty"],
        ["perk.backstabber"],  // attacks from behind
    ]}
    {ru = "Жало", en = "the Stinger", factors = [
        ["weapon.dagger"],
        ["weapon.dagger", "trait.bloodthirsty"],
        ["weapon.dagger", "attr.MeleeSkill.high"],  // бьёт точно и быстро
        ["weapon.dagger", "attr.Initiative.high"],  // бьёт точно и быстро
        ["perk.backstabber"],     // stabs from behind
    ]}
    {ru = "Живодёр", en = "the Flayer", factors = [
        ["background.butcher"],
        ["background.butcher", "trait.bloodthirsty"],
        ["background.hunter", "trait.bloodthirsty"],
    ]}
    {ru = "Мясорубка", en = "the Meatgrinder", factors = [
        ["background.butcher", "trait.bloodthirsty"],  // мясник с жаждой крови
    ]}
    {ru = "Душегуб", en = "the Killer", factors = [
        ["background.killer_on_the_run"],
        ["trait.bloodthirsty"],
        ["perk.fearsome"],       // сеет ужас
        ["perk.coup_de_grace"],  // добивает
    ]}
    {ru = "Головорез", en = "the Cutthroat", factors = [
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
    {ru = "Молния", en = "the Lightning", factors = [
        ["trait.swift", "attr.Initiative.high"],  // стремительный в бою
        ["trait.impatient", "attr.Initiative.high"],
        ["perk.adrenaline"],  // bursts forward in a flash
    ]}
    {names = [
        {ru = "Соколиный глаз", en = "Hawkeye"},
        {ru = "Острый взгляд", en = "the Sharp Eye"},
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
    {ru = "Мышка", en = "the Fieldmouse", factors = [
        ["trait.fear_beasts"],     // боится любой живности
    ]}
    {names = [
        {ru = "Набожный", en = "the Devout"},
        {ru = "Крест", en = "the Cross"},
        {ru = "Свечка", en = "the Candle"},
        {ru = "Чеснок", en = "the Garlic"},
    ], factors = [
        ["trait.fear_undead"],  // молится — авось поможет
    ]}
    // Black Pyramid — стихийные фобии (одна на бро, ~15% при генерации)
    {ru = "Палёный", en = "the Singed", factors = [
        ["trait.elem_fear_fire"],   // обжёгся раз — теперь шарахается огня
    ]}
    {ru = "Мерзляк", en = "Shivers", factors = [
        ["trait.elem_fear_ice"],
    ]}
    {ru = "Гроза", en = "the Storm", factors = [
        ["trait.elem_fear_thunder"],  // ironic: сам прячется от грозы
    ]}
    // Black Pyramid — врождённое сродство к стихии (редкое, ~1%); игрок вряд ли
    // догадается почему — и хорошо
    {ru = "Саламандра", en = "the Salamander", factors = [
        ["perk.elem_fire_affinity"],  // в огне не горит
    ]}
    {ru = "Мороз", en = "Frost", factors = [
        ["perk.elem_ice_affinity"],
    ]}
    {ru = "Искра", en = "the Spark", factors = [
        ["perk.elem_thunder_affinity"],
    ]}

    {ru = "Стрела", en = "the Arrow", factors = [
        ["weapon.bow", "attr.RangedSkill.high"],
        ["weapon.bow", "perk.bullseye"],      // never misses
    ]}
    {ru = "Болт", en = "the Bolt", factors = [
        ["weapon.crossbow", "attr.RangedSkill.high"],
        ["weapon.crossbow", "perk.bullseye"],
    ]}
    {ru = "Яблочко", en = "Bullseye", factors = [
        ["type.ranged", "attr.RangedSkill.high"],
        ["trait.gluttonous", "trait.tiny"],
        ["perk.bullseye"],          // literal translation
    ]}
    {ru = "Мастер клинка", en = "the Blade Master", factors = [
        ["type.melee", "attr.MeleeSkill.high", "cost.high"],  // слишком пафосно для дешёвых
        ["background.swordmaster"],
    ]}
    {ru = "Костелом", en = "the Bonebreaker", factors = [
        ["weapon.hammer", "trait.brute"],    // тупое оружие + грубая сила
        ["weapon.hammer", "attr.MeleeSkill.high"],
        ["weapon.mace", "trait.brute"],
        ["weapon.mace", "attr.MeleeSkill.high"],
    ]}
    {ru = "Жнец", en = "the Reaper", factors = [
        ["weapon.polearm", "attr.MeleeSkill.high"],
        ["weapon.polearm", "trait.bloodthirsty"],  // косит врагов как траву
        ["perk.hackflows.bloody_harvest"],  // keeps enemies in the scythe zone
    ]}
    {ru = "Первая кровь", en = "First Blood", factors = [
        ["trait.bloodthirsty", "attr.Initiative.high"],  // всегда бьёт первым
        ["trait.bloodthirsty", "trait.impatient"],
        ["perk.adrenaline"],  // charges in first
    ]}
    {ru = "Бойня", en = "the Slaughter", factors = [
        ["trait.bloodthirsty", "attr.MeleeSkill.high"],
        ["trait.bloodthirsty", "background.butcher"],
        ["perk.killing_frenzy"],  // goes on a rampage
    ]}
    {ru = "Смерч", en = "the Whirlwind", factors = [
        ["perk.overwhelm", "attr.Initiative.high"],
        ["perk.overwhelm", "attr.MeleeSkill.high"],
    ]}
    {ru = "Мал да удал", en = "Small but Sharp", factors = [
        ["trait.tiny", "type.melee", "attr.MeleeSkill.high"],
        ["trait.tiny", "type.ranged", "attr.RangedSkill.high"],  // мал, а метко бьёт
        ["perk.underdog"],  // shines when outnumbered
    ]}
    {ru = "Проворный", en = "the Nimble", factors = [
        ["trait.dexterous"],
        ["trait.dexterous", "attr.Initiative.high"],
        ["trait.dexterous", "trait.swift"],
        ["perk.nimble"],    // literal match
        ["perk.footwork"],  // moves with agility
    ]}
    {ru = "Сила есть", en = "the Dumb Muscle", factors = [
        ["trait.strong", "trait.dumb"],
        ["trait.huge", "trait.strong", "trait.dumb"],  // силища есть — ума не надо
        ["trait.huge", "trait.strong"],  // Бык — упрямый, сильный, бьёт рогами
    ]}
    {ru = "Кулак", en = "the Fist", factors = [
        ["background.brawler"],
        ["background.brawler", "trait.brute"],
    ]}
    {ru = "Людоед", en = "the Man Eater", factors = [
        ["trait.huge", "trait.bloodthirsty"],
        ["trait.huge", "trait.brute"],
    ]}
    {ru = "Перспективный", en = "the Promising", factors = [
        ["type.melee", "attr.MeleeSkill.high", "attr.MeleeDefense.high", "cost.low"],
        ["type.ranged", "attr.RangedSkill.high", "attr.RangedDefense.high", "cost.low"],
    ]}
    {ru = "Щитоносец", en = "the Shieldman", factors = [
        ["background.hackflows_bodyguard"],
        ["background.hackflows_bodyguard", "attr.MeleeDefense.high"],  // телохранитель — прикрывает
        ["attr.MeleeDefense.high", "attr.Hitpoints.high"],
        ["perk.shield_expert"],  // mastered the shield
        ["trait.shieldmaster"],  // мастер боя со щитом
    ]}

    {ru = "Быстрые ноги", en = "Quickfeet", factors = [
        ["trait.swift", "attr.Initiative.high"],
        ["attr.Initiative.high", "trait.sure_footing"],  // быстрый и уверенный
        ["perk.footwork"],  // literal match
    ]}
    {ru = "Юла", en = "the Spinning Top", factors = [
        ["perk.rotation"],  // never stands still, always repositioning
        ["perk.rotation", "attr.Initiative.high"],
    ]}
    {ru = "Толстая шкура", en = "the Thick Hide", factors = [
        ["attr.Hitpoints.high", "trait.lucky"],
        ["attr.Hitpoints.high", "trait.tough"],
        ["perk.colossus"],    // extra HP pool
        ["perk.steel_brow"],  // tough skull, shrugs off hits
    ]}
    {ru = "Кованый", en = "the Battle-Forged", factors = [
        ["perk.battle_forged"],                             // literal
        ["perk.battle_forged", "background.sellsword"],    // mercenary hardened by years of war
        ["perk.battle_forged", "background.hedge_knight"], // wandering knight who earned his scars
        ["perk.hackflows.full_force"],    // hits with the full weight of his armor
        ["perk.hackflows.stabilized"],    // injury-resistant, built to last
    ]}
    {ru = "Ловкий", en = "the Agile", factors = [
        ["trait.dexterous"],
        ["trait.swift", "trait.dexterous"],
        ["trait.dexterous", "attr.Initiative.high"],
    ]}
    {ru = "Дуэлянт", en = "the Duelist", factors = [
        ["perk.duelist"],
        ["trait.champion"],     // прославленный мастер поединков
        ["trait.duel_fighter"], // закалён в схватках один на один
        ["background.hackflows_myrmidon"],
        ["attr.MeleeSkill.high", "attr.MeleeDefense.high"],  // воюет один на один
        ["perk.anticipation"],         // reads enemy moves like a duelist
        ["perk.hackflows.balance"],    // stays balanced through the fight
    ]}
    {ru = "Гарпун", en = "the Harpoon", factors = [
        ["background.fisherman"],
        ["background.fisherman", "weapon.spear"],
        ["background.fisherman", "weapon.throwing"],
    ]}
    {ru = "Наковальня", en = "the Anvil", factors = [
        ["background.hackflows_blacksmith"],
        ["trait.iron_jaw"],
        ["trait.iron_jaw", "attr.Hitpoints.high"],
        ["perk.steel_brow"],
        ["perk.steel_brow", "trait.tough"],
    ]}
    {ru = "Заноза", en = "the Splinter", factors = [
        ["trait.tiny", "trait.impatient"],
        ["weapon.dagger", "attr.MeleeSkill.high"],
    ]}
    {ru = "Затычка", en = "the Plug", factors = [
        ["perk.shield_expert", "attr.MeleeDefense.high"],
        ["trait.shieldmaster", "attr.MeleeDefense.high"],
        ["attr.Hitpoints.high", "attr.MeleeDefense.high"],
    ]}
    {ru = "Кремень", en = "the Flint", factors = [
        ["trait.determined", "trait.tough"],
        ["trait.determined", "trait.fearless"],
        ["trait.iron_jaw"],
        ["trait.iron_jaw", "trait.tough"],
    ]}
    {ru = "Молотило", en = "the Thresher", factors = [
        ["weapon.flail"],
        ["weapon.flail", "trait.brute"],
        ["weapon.flail", "attr.MeleeSkill.high"],
    ]}
    {ru = "Карусель", en = "the Whirligig", factors = [
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
    {ru = "Щепка", en = "the Sliver", factors = [
        ["trait.tiny", "weapon.dagger"],
    ]}
    {ru = "Зубодробитель", en = "the Toothbreaker", factors = [
        ["weapon.hammer", "trait.brute"],
        ["weapon.hammer", "perk.head_hunter"],
        ["weapon.mace", "trait.brute"],
        ["weapon.mace", "perk.head_hunter"],
    ]}
    {ru = "Гром", en = "the Thunder", factors = [
        ["cost.high", "weapon.hammer"],
        ["cost.high", "weapon.hammer", "attr.MeleeSkill.high"],
    ]}
    {ru = "Крюк", en = "the Hook", factors = [
        ["perk.crippling_strikes"],
        ["background.fisherman"],
        ["background.hackflows_hangman"],
    ]}
    {ru = "Костолом", en = "the Bonecracker", factors = [
        ["weapon.hammer", "trait.brute"],    // молот/кость ломает грубой силой
    ]}
    {ru = "Шило", en = "the Awl", factors = [
        ["background.hackflows_cobbler", "trait.swift"],    // быстрый сапожник с ножом
        ["background.hackflows_cobbler", "weapon.dagger"],
        ["trait.swift", "weapon.dagger"],
    ]}
    {ru = "Клык", en = "the Fang", factors = [
        ["trait.bloodthirsty", "trait.hate_beasts"],  // агрессивный зверобой
        ["weapon.dagger", "trait.hate_beasts"],
    ]}
    {ru = "Коготь", en = "the Claw", factors = [
        ["trait.bloodthirsty", "background.killer_on_the_run"],  // кровожадный убийца
    ]}
    {ru = "Гвоздь", en = "the Nail", factors = [
        ["trait.determined", "trait.strong"],  // упрямый, вобьёт и не вытащишь
        ["background.hackflows_carpenter"],
    ]}
    {ru = "Черепаха", en = "the Tortoise", factors = [
        ["attr.Initiative.low", "trait.tough"],         // медленный, но в панцире
        ["attr.Initiative.low", "perk.shield_expert"],
    ]}
    {ru = "Мозгоправ", en = "the Headshrinker", factors = [
        ["weapon.mace", "trait.brute"],                    // вправляет мозги ударом булавы
        ["background.hackflows_surgeon", "trait.brute"],
    ]}
    {ru = "Трубочист", en = "the Chimney Sweep", factors = [
        ["weapon.firearm", "trait.dumb"],  // вечно с чёрной от пороха мордой
        ["background.miner", "trait.tiny"],  // мелкий и чумазый — хоть в дымоход
    ]}
    {ru = "Гроза Орков", en = "the Orc Terror", factors = [
        ["trait.fear_greenskins", "attr.Bravery.low"],   // ironic: бледнеет при слове «зеленокожий»
        ["trait.hate_greenskins", "attr.Bravery.high"],  // и у тех, кто их вправду ненавидит
    ]}
    {names = [
        {ru = "Оркоед", en = "the Orc-Eater"},
        {ru = "Зелёный", en = "Greenie"},
    ], factors = [
        ["trait.fear_greenskins"],  // ironic: самый трусливый зовётся Оркоедом / сам позеленел от страха
    ]}
    {ru = "Шнырь", en = "the Snooper", factors = [
        ["background.thief", "trait.quick"],  // везде прошмыгнёт без мыла
        ["trait.weasel", "trait.quick"],
    ]}
    {ru = "Решето", en = "the Sieve", factors = [
        ["attr.RangedDefense.low"],
        ["attr.RangedDefense.low", "attr.Hitpoints.high"],  // ironic: дырявый, но живёт
    ]}

    // Boris the Bullet Dodger — Snatch (2000)
    {ru = "Хрен попадёшь", en = "the Bullet Dodger", setting = false, factors = [
        ["attr.MeleeDefense.high", "attr.RangedDefense.high"],
        ["attr.MeleeDefense.high", "perk.dodge"],  // trained to dodge
    ]}

    // ── Судьба ───────────────────────────────────────────────────────────
    {ru = "Везунчик", en = "the Lucky", factors = [
        ["trait.lucky"],
    ]}
    {names = [
        {ru = "Счастливчик", en = "the Lucky Devil"},
        {ru = "Четырёхлистник", en = "Four-Leaf"},
    ], factors = [
        ["trait.lucky"],
        ["trait.lucky", "trait.survivor"],  // выжил — повезло
        ["trait.destined"],  // знает, что не здесь и не сейчас ему суждено пасть
    ]}
    {ru = "Горемыка", en = "the Wretch", factors = [
        ["attr.Hitpoints.low", "attr.Bravery.low"],  // слабый и пугливый — вечно мается
    ]}
    {ru = "Обречённый", en = "the Doomed", factors = [
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
        ["trait.destined"],                     // ему просто не суждено умереть
        ["perk.nine_lives"],                    // literally hard to kill
        ["perk.hold_out"],                      // refuses to go down
        ["perk.hackflows.flesh_on_the_bones"],  // extra flesh to soak damage
        ["perk.necro.regeneration"],            // regenerates wounds
    ]}
    {ru = "Неудачник", en = "the Loser", factors = [
        ["trait.survivor", "trait.pessimist"],
        ["trait.survivor", "trait.tough"],     // ironic: просто не умирает
    ]}
    {ru = "Дырявый", en = "Full of Holes", factors = [
        ["trait.bleeder"],
        ["trait.bleeder", "trait.survivor"],  // кровоточит, но живёт
    ]}
    {ru = "Красный Нос", en = "the Red Nose", factors = [
        ["trait.bleeder"],
        ["trait.drunkard"],
        ["trait.bleeder", "trait.drunkard"],  // и кровоточит, и пьёт — вечно красный
    ]}
    {ru = "Смертник", en = "the Dead Man", factors = [
        ["trait.brave", "trait.deathwish"],                        // храбрый + тяга к смерти
        ["trait.brave", "trait.deathwish", "attr.Hitpoints.low"],  // храбрый + тяга к смерти + реально хилый
    ]}
    {ru = "Без завтра", en = "No Tomorrow", factors = [
        ["trait.deathwish"],
        ["trait.deathwish", "attr.Bravery.high"],  // не боится смерти — и не скрывает
        ["trait.deathwish", "trait.lucky"],
    ]}
    {ru = "Пёс Везучий", en = "the Lucky Dog", factors = [
        ["trait.lucky"],
        ["trait.lucky", "attr.Hitpoints.low"],  // ironic: хилый, но живёт
        ["trait.lucky", "perk.underdog"],  // ironic: хилый, но живёт
    ]}
    {ru = "Беда", en = "the Trouble", factors = [
        ["trait.pessimist", "trait.irrational"],
        ["trait.pessimist", "trait.disloyal"],
        ["trait.bloodthirsty", "trait.irrational"],
    ]}
    {ru = "Золотой", en = "Goldie", factors = [
        ["cost.high", "trait.greedy"],
        ["cost.high", "attr.MeleeSkill.high"],
        ["cost.high", "attr.Bravery.high"],
    ]}
    {ru = "Кроличья лапка", en = "the Rabbit Foot", factors = [
        ["trait.lucky"],
        ["trait.lucky", "attr.Bravery.low"],  // трусоват, зато везёт
    ]}
    {ru = "Шкура", en = "the Hide", factors = [
        ["trait.survivor"],                      // живучий, выживает несмотря ни на что
        ["trait.tough", "attr.Hitpoints.high"],
        ["trait.greedy"],                        // ironic: своя шкура — дороже всего
    ]}
    {ru = "Мертвец", en = "the Corpse", factors = [
        ["trait.fragile", "trait.deathwish"],    // бледный, мёртвый вид
        ["trait.pessimist", "trait.deathwish"],
    ]}
    {ru = "Колобок", en = "the Dumpling", factors = [
        ["trait.fat", "trait.survivor"],   // круглый, ушёл от всех проблем
        ["trait.lucky", "trait.fat"],
        ["trait.lucky", "trait.survivor"],
    ]}
    {ru = "Герой", en = "the Hero", factors = [
        ["trait.dumb", "trait.lucky"],    // ironic: трус, которому пока просто везло
        ["trait.dumb", "trait.brave"],
        ["trait.lucky", "trait.brave"],
    ]}
    {ru = "Избранный", en = "the Chosen", factors = [
        ["trait.chosen"],                     // North Expansion / Lone Chosen — отмечен богами
        ["background.hackflows_folk_hero"],   // народный герой — тоже избранник
    ]}

    // ── Животные ─────────────────────────────────────────────────────────
    {ru = "Медведь", en = "the Bear", factors = [
        ["trait.huge", "trait.strong"],
        ["attr.Hitpoints.high", "trait.strong"],
    ]}
    {ru = "Волк", en = "the Wolf", factors = [
        ["trait.bloodthirsty", "attr.MeleeSkill.high"],
        ["trait.wolfmaster"],  // неразлучен со своим лютоволком
        ["background.hunter"],
    ]}
    {ru = "Кабан", en = "the Boar", factors = [
        ["trait.fat"],
        ["trait.fat", "trait.brute"],
        ["trait.huge", "trait.impatient"],  // прёт напролом
    ]}
    {ru = "Вепрь", en = "the Wild Boar", factors = [
        ["trait.fat", "trait.brute"],
        ["trait.feral", "attr.Hitpoints.low"],  // дичает тем сильнее, чем ближе к смерти
        ["trait.bloodthirsty", "background.wildman"],  // дичее обычного
    ]}
    {ru = "Лис", en = "the Fox", factors = [
        ["trait.weasel", "trait.bright"],
        ["background.thief"],
    ]}
    {ru = "Сова", en = "the Owl", factors = [
        ["trait.night_owl"],
        ["trait.moonkissed"],  // оживает ночью, под луной
        ["trait.bright"],  // мудрый/наблюдательный
    ]}
    {ru = "Самородок", en = "the Natural", factors = [
        ["perk.gifted"],  // born with exceptional talent
    ]}
    {ru = "Ворон", en = "the Raven", factors = [
        ["background.gravedigger"],
        ["trait.pessimist"],  // предвестник несчастья
    ]}
    {ru = "Барсук", en = "the Badger", factors = [
        ["trait.determined", "trait.tough"],
    ]}
    {ru = "Клещ", en = "the Tick", factors = [
        ["trait.determined"],  // не отпускает
        ["trait.determined", "trait.tiny"],
        ["trait.loyal"],       // прицепился и держится
    ]}
    {ru = "Ёрш", en = "the Ruffe", factors = [
        ["trait.brute", "trait.impatient"],  // колючий, лезет на рожон
    ]}
    {ru = "Коняга", en = "the Workhorse", factors = [
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
    {ru = "Таракан", en = "the Cockroach", factors = [
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
    {ru = "Орёл", en = "the Eagle", factors = [
        ["attr.Bravery.high", "trait.brave"],           // гордый, непреклонный
        ["attr.Bravery.high", "trait.eagle_eyes"],
        ["type.ranged", "trait.eagle_eyes", "attr.RangedSkill.high"],  // видит и попадает
    ]}
    {ru = "Зверь", en = "the Beast", factors = [
        ["trait.bloodthirsty", "trait.huge"],
        ["trait.bloodthirsty", "trait.strong"],
        ["trait.feral"],  // дерётся как дикий зверь
        ["background.wildman", "trait.bloodthirsty"],  // дикарь с кровожадностью
    ]}
    {ru = "Пёс", en = "the Hound", factors = [
        ["background.houndmaster"],
        ["background.houndmaster", "trait.loyal"],  // водил псов — сам стал псом отряда
        ["trait.loyal"],
        ["perk.underdog"],
    ]}
    {ru = "Альфа", en = "Alpha", factors = [
        ["background.houndmaster", "trait.brave"],   // привык быть вожаком стаи
        ["background.houndmaster", "trait.strong"],
        ["background.houndmaster", "attr.Bravery.high"],
        ["trait.wolfmaster"],  // при нём лютоволк — вожак своей стаи
    ]}
    {ru = "Чертёнок", en = "the Imp", factors = [
        ["trait.tiny", "trait.bright"],
        ["trait.tiny", "trait.bright", "trait.weasel"],  // мелкий, умный, пролезет куда угодно
        ["trait.tiny", "trait.bright", "trait.irrational"],
    ]}
    {ru = "Псина", en = "the Mutt", factors = [
        ["trait.brute", "trait.disloyal"],         // злой и ненадёжный — пёс без хозяина
        ["trait.brute", "background.houndmaster"],
    ]}
    {names = [
        {ru = "Курица", en = "the Chicken"},
        {ru = "Фонарь", en = "the Lantern"},
    ], factors = [
        ["trait.night_blind"],  // без фонаря ни шагу — ironic: зовут Фонарём
    ]}
    {ru = "Слепень", en = "the Horsefly", factors = [
        ["trait.night_blind"],
        ["trait.short_sighted"],  // летит прямо куда не надо
    ]}
    {names = [
        {ru = "Шмель", en = "the Hornet"},
        {ru = "Перец", en = "the Pepper"},
    ], factors = [
        ["trait.tiny", "trait.brute"],
        ["trait.tiny", "trait.impatient"],
    ]}
    {ru = "Рысь", en = "the Lynx", factors = [
        ["trait.swift", "attr.Initiative.high"],
        ["trait.eagle_eyes", "attr.Initiative.high"],
    ]}
    {ru = "Мул", en = "the Mule", factors = [
        ["trait.determined", "attr.Stamina.high"],
        ["attr.Stamina.high", "trait.tough"],
    ]}
    {ru = "Соколик", en = "the Falcon", factors = [
        ["background.hackflows_falconer"],
        ["type.ranged", "trait.eagle_eyes"],
        ["type.ranged", "trait.eagle_eyes", "attr.RangedSkill.high"],
    ]}
    {ru = "Хорёк", en = "the Ferret", factors = [
        ["trait.weasel"],
        ["trait.tiny", "trait.weasel"],
        ["trait.dexterous"],
    ]}
    {ru = "Козёл", en = "the Goat", factors = [
        ["trait.determined", "trait.impatient"],
        ["trait.determined", "trait.cocky"],
    ]}
    {ru = "Жаба", en = "the Toad", factors = [
        ["trait.fat", "attr.Initiative.low"],
        ["trait.paranoid", "attr.Initiative.low"],
    ]}
    {ru = "Сорока", en = "the Magpie", factors = [
        ["trait.greedy"],
        ["perk.bags_and_belts"],
        ["trait.greedy", "perk.bags_and_belts"],
        ["background.graverobber", "trait.bright"],
    ]}
    {ru = "Бобёр", en = "the Beaver", factors = [
        ["background.lumberjack", "trait.determined"],
        ["background.hackflows_carpenter", "trait.determined"],
    ]}
    {ru = "Волкодав", en = "the Wolfhound", factors = [
        ["trait.hate_beasts", "attr.MeleeSkill.high"],
        ["trait.hate_beasts", "attr.RangedSkill.high"],
        ["trait.hate_beasts", "background.houndmaster"],
    ]}
    {ru = "Сурок", en = "the Groundhog", factors = [
        ["attr.Initiative.low", "trait.night_owl"],  // медленный ночной наблюдатель
    ]}
    {ru = "Жук", en = "the Beetle", factors = [
        ["trait.tiny", "trait.tough"],  // маленький, но крепкий; жив без "Follow excludes"
        ["trait.tiny", "attr.Hitpoints.high"],  // мелкий, а не раздавишь
    ]}
    {ru = "Крот", en = "the Mole", factors = [
        ["background.miner", "trait.night_owl"],  // шахтёр в темноте
        ["trait.short_sighted"],                  // буквально как крот
    ]}
    {ru = "Сыч", en = "the Screech Owl", factors = [
        ["trait.night_owl"],  // маленькая мрачная сова
        ["trait.moonkissed", "trait.night_owl"],  // ночной боец, лучше всего во тьме
    ]}
    {ru = "Бес", en = "the Fiend", factors = [
        ["trait.tiny", "trait.bloodthirsty"],  // мелкий, злой, проказник
        ["trait.tiny", "trait.irrational"],
    ]}
    {names = [
        {ru = "Ворона", en = "the Crow"},
        {ru = "Растяпа", en = "the Klutz"},
    ], factors = [
        ["trait.clumsy"],  // всё проворонит
    ]}
    {ru = "Боров", en = "the Porker", factors = [
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
    {ru = "Шакал", en = "the Jackal", factors = [
        ["trait.greedy", "trait.disloyal"],
        ["trait.greedy", "background.graverobber"],  // стервятник, жадный до чужого
        ["trait.greedy", "background.ratcatcher"],   // подбирает всё, что плохо лежит
    ]}
    {ru = "Змея", en = "the Snake", factors = [
        ["trait.disloyal", "background.assassin"],    // предатель по натуре
        ["trait.disloyal", "background.thief"],       // скользкий тип
    ]}

    // ── Грубые прозвища ──────────────────────────────────────────────────
    {ru = "Вонючка", en = "Stinky", factors = [
        ["background.gravedigger"],
        ["background.ratcatcher"],
        ["background.miner"],
    ]}
    {ru = "Замухрышка", en = "the Runt", factors = [
        ["trait.tiny", "trait.fragile"],
        ["attr.Hitpoints.low"],
    ]}
    {names = [
        {ru = "Пень", en = "the Stump"},
        {ru = "Чурбан", en = "the Blockhead"},
    ], factors = [
        ["trait.dumb"],
    ]}
    {ru = "Руки-крюки", en = "Butterfingers", factors = [
        ["trait.clumsy"],
        ["type.melee", "attr.MeleeSkill.low"],
        ["type.ranged", "attr.RangedSkill.low"],
    ]}
    {ru = "Рукосуй", en = "the Fumbler", factors = [
        ["type.melee", "trait.clumsy", "trait.dumb"],
        ["type.melee", "trait.clumsy", "attr.Initiative.high"],
        ["type.melee", "trait.clumsy", "trait.impatient"],
        ["type.melee", "attr.MeleeSkill.low", "attr.Initiative.high"],
    ]}
    {ru = "Лапоть", en = "the Bumpkin", factors = [
        ["background.farmhand", "trait.dumb"],
        ["background.daytaler", "trait.dumb"],
    ]}
    {ru = "Дохлый", en = "the Half-dead", factors = [
        ["trait.fragile", "attr.Hitpoints.low"],
        ["attr.Stamina.low", "attr.Hitpoints.low"],
        ["trait.asthmatic"],  // дышит как умирающий
    ]}
    {ru = "Огрызок", en = "the Remnant", factors = [
        ["trait.tiny", "attr.Hitpoints.low"],  // маленький и потрёпанный
    ]}
    {ru = "Висельник", en = "the Gallows-bird", factors = [
        ["background.killer_on_the_run"],
        ["background.deserter"],
        ["trait.disloyal"],  // должны были повесить
    ]}
    {ru = "Рухлядь", en = "the Old Wreck", factors = [
        ["trait.fragile", "cost.low"],
        ["attr.Hitpoints.low", "attr.MeleeSkill.low"],  // плохой по всему
    ]}
    {ru = "Плюгавый", en = "the Puny", factors = [
        ["trait.tiny", "trait.fragile"],
    ]}
    {ru = "Непутёвый", en = "Good-for-nothing", factors = [
        ["trait.irrational"],
        ["trait.clumsy", "trait.impatient"],  // всё делает не так
    ]}
    {ru = "Мутный", en = "the Shady", factors = [
        ["trait.weasel"],
        ["background.hackflows_con_artist"],
        ["trait.paranoid"],  // держится в тени
    ]}
    {ru = "Полено", en = "the Log", factors = [
        ["trait.dumb", "attr.Initiative.low"],  // тупой и неповоротливый
    ]}
    {ru = "Чумной", en = "the Cracked", factors = [
        ["trait.irrational", "trait.deathwish"],
        ["background.flagellant"],
    ]}
    {ru = "Балда", en = "the Numbskull", factors = [
        ["trait.dumb"],
        ["trait.dumb", "trait.brute"],
    ]}
    {ru = "Простак", en = "the Simpleton", factors = [
        ["trait.dumb"],
        ["background.farmhand"],
        ["background.daytaler"],
    ]}
    {names = [
        {ru = "Скользкий", en = "the Slippy"},
        {ru = "Склизкий", en = "the Slippery"},
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
    {ru = "Мягкий", en = "the Squishy", factors = [
        ["trait.fragile"],
        ["attr.Hitpoints.low", "trait.fragile"],
        ["trait.legend_frail"],  // легенда о хрупкости
    ]}
    {ru = "Невежда", en = "the Clueless", factors = [
        ["group.pauper", "trait.dumb"],
    ]}
    {ru = "Вялый", en = "the Dullard", factors = [
        ["attr.Stamina.low"],
        ["attr.Initiative.low"],
        ["trait.ailing"],
    ]}
    {names = [
        {ru = "Пыхтун", en = "the Puffer"},
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
    {ru = "Жалкий", en = "the Pitiful", factors = [
        ["trait.craven", "attr.MeleeSkill.low"],
        ["trait.fragile", "trait.craven"],
    ]}
    {ru = "Развалина", en = "the Crumbler", factors = [
        ["trait.ailing"],
        ["trait.ailing", "trait.fragile"],
        ["trait.ailing", "attr.Hitpoints.low"],
    ]}
    {ru = "Болван", en = "the Oaf", factors = [
        ["trait.dumb", "trait.huge"],    // тупой, большой
        ["trait.dumb", "trait.strong"],
    ]}
    {ru = "Бревно", en = "the Timber", factors = [
        ["attr.Initiative.low", "trait.huge"],  // медленный, неуклюжий, но тяжёлый
        ["attr.Initiative.low", "trait.dumb"],
    ]}
    {ru = "Дрын", en = "the Cudgel", factors = [
        ["trait.huge", "trait.brute"],  // огромный, тупой детина, бьёт с размаху
        ["trait.huge", "trait.dumb"],
        ["trait.huge", "weapon.mace"],
    ]}
    {ru = "Мясо", en = "the Cannon Fodder", factors = [
        ["trait.dumb", "trait.deathwish"],     // расходный материал, идёт вперёд жрать урон
        ["background.brawler", "trait.fat"],
        ["trait.survivor", "trait.deathwish"],
    ]}
    {ru = "Кляча", en = "the Old Nag", factors = [
        ["trait.clubfooted", "trait.asthmatic"],  // больной и еле волочит ноги
        ["trait.clubfooted", "trait.ailing"],
    ]}
    {ru = "Бубен", en = "the Tambourine", factors = [
        ["trait.iron_jaw", "trait.dumb"],          // лицо как бубен, только получает по нему
        ["background.brawler", "trait.cocky"],
        ["trait.brute"],
    ]}
    {ru = "Сморчок", en = "the Wisp", factors = [
        ["trait.tiny", "trait.ailing"],  // маленький, больной и сморщенный
        ["trait.tiny"],
    ]}
    {ru = "Мордоворот", en = "the Ugly Mug", factors = [
        ["background.brawler", "trait.huge"],              // страшный и квадратный
        ["background.hackflows_bodyguard", "trait.huge"],
    ]}
    {ru = "Жбан", en = "the Tankard", factors = [
        ["trait.iron_jaw", "background.brawler"],  // башка крепкая как кувшин
        ["trait.drunkard", "trait.iron_jaw"],
    ]}
    {ru = "Балалайка", en = "the Balalaika", factors = [
        ["background.minstrel", "trait.dumb"],  // трендит без умолку и пустая внутри
        ["trait.cocky", "trait.dumb"],
    ]}
    {ru = "Валенок", en = "the Felt Boot", factors = [
        ["trait.dumb", "trait.optimist"],      // тёплый, но тупой
    ]}
    {ru = "Отбивная", en = "the Cutlet", factors = [
        ["trait.survivor", "trait.ailing"],     // бьют все, а он живёт; жив без "Follow excludes"
        ["background.brawler", "trait.ailing"],
        ["background.brawler", "trait.survivor"],  // вечно отбивают, а он встаёт
    ]}
    {ru = "Обуза", en = "the Deadweight", factors = [
        ["trait.clumsy", "trait.fainthearted"],      // тащить тяжело, а бросить жалко
        ["trait.clubfooted", "trait.fainthearted"],
    ]}
    {names = [
        {ru = "Чучело", en = "the Scarecrow"},
        {ru = "Пугало", en = "the Bogey"},
    ], factors = [
        ["trait.fainthearted", "trait.huge"],       // выглядит страшно, но пустой
        ["background.farmhand", "perk.fearsome"],
        ["perk.fearsome"],
    ]}
    {ru = "Грабли", en = "the Rake", factors = [
        ["trait.clumsy", "trait.pessimist"],  // неуклюжий, но опасный
        ["background.farmhand"],
    ]}
    {ru = "Олух", en = "the Clod", factors = [
        ["trait.dumb", "trait.clumsy"],  // просто классический олух
    ]}
    {ru = "Рохля", en = "the Dawdler", factors = [
        ["attr.Initiative.low", "trait.clumsy"],  // пока замахнётся мечом, бой уже заканчивается
    ]}
    {ru = "Увалень", en = "the Waddler", factors = [
        ["trait.fat", "trait.clumsy"],  // толстый, неповоротливый
    ]}
    {ru = "Тюфяк", en = "the Stuffed Sack", factors = [
        ["trait.fainthearted", "trait.fat"],  // мягкий, толстый и бесполезный
    ]}
    {ru = "Телёнок", en = "the Calf", factors = [
        ["trait.fainthearted"],                    // большой, тупой и безвредный для врагов
        ["trait.dumb", "trait.fainthearted"],
    ]}
    {ru = "Тряпка", en = "the Doormat", factors = [
        ["trait.fainthearted", "trait.craven"],   // об него вытирают ноги, а он и рад
        ["trait.fainthearted", "group.pauper"],
    ]}
    {ru = "Мокрые Штаны", en = "the Wet Britches", factors = [
        ["attr.Bravery.low"],                     // не держит ни строй, ни мочевой пузырь
        ["trait.craven", "attr.Bravery.low"],
    ]}
    {ru = "Хромой Пёс", en = "the Limping Hound", factors = [
        ["trait.clubfooted", "trait.survivor"],  // тащится позади всего отряда
    ]}
    {names = [
        {ru = "Мыслитель", en = "the Thinker"},
        {ru = "Дырявая Башка", en = "the Cracked Skull"},
        {ru = "Юродивый", en = "the Holy Fool"},
    ], factors = [
        ["injury.brain_damage"],
    ]}
    {ru = "Башка", en = "Crackskull", factors = [
        ["injury.brain_damage"],
        ["trait.brute"],
        ["perk.head_hunter"],
    ]}
    {ru = "Плясун", en = "the Dancer", factors = [
        ["injury.broken_knee", "trait.drunkard"],  // еле стоит на ногах
    ]}
    {ru = "Клешня", en = "the Pincer", factors = [
        ["injury.broken_elbow_joint"],
        ["injury.broken_elbow_joint", "background.beggar"],
    ]}
    {ru = "Ухо", en = "the Ear", factors = [
        ["injury.missing_ear"],  // ironic: нет уха — зовут Ухом
    ]}
    {ru = "Полушка", en = "the Half-ear", factors = [
        ["injury.missing_ear"],  // было два уха, осталось полтора
        ["trait.tiny", "trait.greedy"],  // мелкий и жадный — цена ему полушка
    ]}
    {ru = "Культяпка", en = "the Stub", factors = [
        ["injury.missing_hand"],
    ]}
    {ru = "Пуганый", en = "the Spooked", factors = [
        ["injury.traumatized"],
    ]}
    {ru = "Блаженный", en = "the Blessed", factors = [
        ["injury.traumatized"],
        ["injury.traumatized", "trait.optimist"],  // после всего, что видел — сидит с улыбкой
    ]}
    {ru = "Синяк", en = "the Bruise", factors = [
        ["injury.weakened_heart"],
        ["injury.weakened_heart", "attr.Stamina.low"],
        ["trait.ailing"],  // ironic: синеет при нагрузке
    ]}

    // ── Прочие ───────────────────────────────────────────────────────────
    {ru = "Бродяга", en = "the Wanderer", factors = [
        ["background.vagabond"],
        ["background.beggar"],
        ["background.refugee"],
        ["background.hackflows_drifter"],
    ]}
    {ru = "Беглец", en = "the Fugitive", factors = [
        ["background.deserter"],
        ["background.killer_on_the_run"],
        ["background.refugee"],
        ["attr.Initiative.high", "trait.swift"],  // ironic: просто быстрый на ногу
    ]}
    {ru = "Пришлый", en = "the Outsider", factors = [
        ["background.refugee"],
        ["background.hackflows_outlander"],
        ["background.wildman"],
    ]}
    {ru = "Дикий", en = "the Wild One", factors = [
        ["background.wildman"],
        ["trait.bloodthirsty", "trait.irrational"],
    ]}
    {names = [
        {ru = "Дышло", en = "the Bellows"},
        {ru = "Хрипун", en = "the Raspy"},
    ], factors = [
        ["trait.asthmatic"],
        ["injury.collapsed_lung_part"],
        ["trait.iron_lungs", "attr.Stamina.low"],  // ironic
    ]}
    {ru = "Мехи", en = "the Wind Pumps", factors = [
        ["trait.iron_lungs"],  // кузнечные меха: качает воздух без устали
    ]}
    {ru = "Труба", en = "the Foghorn", factors = [
        ["trait.iron_lungs"],
        ["background.minstrel", "trait.iron_lungs"],  // дышит как труба, слышно на весь лагерь
    ]}
    {ru = "Бурдюк", en = "the Wineskin", factors = [
        ["trait.iron_lungs"],
        ["trait.iron_lungs", "trait.drunkard"],  // ironic: бурдюк с воздухом — или с вином
    ]}
    {ru = "Задохлик", en = "Сhoke", factors = [
        ["trait.asthmatic"],
        ["attr.Stamina.low", "trait.asthmatic"],
        ["attr.Stamina.low", "attr.Hitpoints.low"],
    ]}
    {ru = "Пёрышко", en = "the Feather", factors = [
        ["trait.legend_light"],        ["trait.tiny", "attr.Initiative.high"],  // лёгкий и порхает
    ]}
    {ru = "Фантом", en = "the Phantom", factors = [
        ["trait.night_owl", "background.thief"],
        ["trait.night_owl", "trait.weasel"],
    ]}
    {ru = "Отмычка", en = "the Picklock", factors = [
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
    {ru = "Дуболом", en = "the Oaf Feller", factors = [
        ["background.lumberjack"],
        ["background.lumberjack", "weapon.axe"],
        ["trait.strong", "weapon.axe"],  // рубит как заправский лесоруб
        ["trait.strong", "trait.dumb"],
    ]}
    {ru = "Мясной щит", en = "Meatshield", setting = false, factors = [
        ["attr.Hitpoints.high", "attr.MeleeDefense.high"],  // стоит впереди и держит удар
        ["attr.Hitpoints.high", "trait.survivor"],  // мясной и можно пожертвовать
    ]}
    {ru = "Звонарь", en = "the Bell Ringer", factors = [
        ["background.hackflows_town_watchman"],
    ]}
    {ru = "Стражник", en = "the Town Guard", factors = [
        ["background.hackflows_town_watchman"],
        ["background.militia"],
    ]}
    {names = [
        {ru = "Рекрут", en = "the Recruit"},
        {ru = "Частокол", en = "the Palisade"},
        {ru = "Деревня", en = "the Village Boy"},
        {ru = "Земляк", en = "Homeboy"},
    ], factors = [
        ["background.militia"],
    ]}
    {ru = "Проводник", en = "the Pathfinder", factors = [
        ["background.hackflows_cartographer"],
        ["trait.sure_footing"],                              // знает, куда ступить
        ["background.hackflows_cartographer", "trait.sure_footing"],
        ["perk.pathfinder"],  // literal match
    ]}
    {names = [
        {ru = "Козлик", en = "the Billy Goat"},
        {ru = "Верный Шаг", en = "Surestep"},
    ], factors = [
        ["trait.sure_footing"],
    ]}
    {names = [
        {ru = "Полукровка", en = "Half-Blood"},
        {ru = "Байстрюк", en = "the By-blow"},
        {ru = "Нагуляный", en = "the Love Child"},
        {ru = "Отпрыск", en = "the Offspring"},
        {ru = "Левый Сын", en = "the Left-Hand Son"},
        {ru = "Случайный", en = "the Accident"},
    ], factors = [
        ["background.bastard"],
    ]}
    {ru = "Каблук", en = "the Cobbler", factors = [
        ["background.hackflows_cobbler"],
        ["attr.Initiative.low"],
    ]}
    {ru = "Петля", en = "the Noose", factors = [
        ["background.hackflows_hangman"],
    ]}
    {ru = "Заплатка", en = "Patches", factors = [
        ["background.tailor"],
    ]}
    {ru = "Знаменосец", en = "the Bannerman", factors = [
        ["perk.rally_the_troops"],  // rallies the company
        ["perk.rally_the_troops", "background.militia"],          // the sergeant of the militia
        ["perk.rally_the_troops", "background.retired_soldier"],  // old soldier leading by example
        ["trait.skald"],  // скальд — его доблесть воодушевляет соседей
    ]}
    {ru = "Дудочник", en = "the Pied Piper", factors = [
        ["background.minstrel"],
        ["background.minstrel", "trait.optimist"],  // весёлый — и дудит
        ["trait.skald"],  // северный бард, поёт под бой
    ]}
    {ru = "Вилы", en = "the Pitchfork", factors = [
        ["background.farmhand"],
        ["background.farmhand", "weapon.spear"],  // вилы — они и есть вилы
    ]}
    {ru = "Ходок по доскам", en = "the Plank Walker", factors = [
        ["background.hackflows_pirate"],
    ]}
    {ru = "Перо", en = "the Quill", factors = [
        ["background.hackflows_fletcher"],
        ["background.hackflows_fletcher", "type.ranged"],  // сам делает стрелы — сам стреляет
    ]}
    {ru = "Лопата", en = "the Shovel", factors = [
        ["background.gravedigger"],
        ["background.miner"],
    ]}
    {ru = "Кастрюля", en = "the Stewpot", factors = [
        ["background.hackflows_cook"],
    ]}
    {ru = "Могила", en = "the Tomb", factors = [
        ["background.gravedigger"],
        ["background.graverobber"],
    ]}
    {ru = "Расхититель", en = "the Tomb Raider", factors = [
        ["background.graverobber"],
        ["background.graverobber", "trait.greedy"],
    ]}
    {ru = "Подёнщик", en = "Odd Jobs", factors = [
        ["background.daytaler"],
    ]}
    {ru = "Большой улов", en = "the Big Catch", factors = [
        ["background.fisherman", "trait.lucky"],
    ]}
    {ru = "Клещи", en = "Iron Tongs", factors = [
        ["background.hackflows_torturer"],
        ["background.hackflows_blacksmith"],
    ]}
    {ru = "Кровища", en = "the Bloodbath", factors = [
        ["trait.bloodthirsty", "trait.irrational"],
        ["background.hackflows_surgeon"],                       // ironic: руки в крови по локоть
        ["background.hackflows_surgeon", "trait.bloodthirsty"],
        ["background.butcher", "trait.bloodthirsty"],
    ]}
    {ru = "Без башни", en = "the Wildcard", setting = false, factors = [
        ["trait.irrational"],
        ["trait.irrational", "trait.impatient"],
        ["trait.bloodthirsty", "trait.irrational"],  // никогда не знаешь чего ждать
    ]}
    {ru = "Ветерок", en = "the Breeze", factors = [
        ["trait.weasel", "trait.night_owl"],
        ["background.thief", "attr.Initiative.high", "trait.dexterous"],
    ]}
    {ru = "Болячка", en = "the Sore", factors = [
        ["trait.ailing"],
        ["trait.ailing", "trait.pessimist"],
    ]}
    {ru = "Дозорный", en = "the Watchman", factors = [
        ["background.hackflows_town_watchman", "trait.eagle_eyes"],
        ["background.hackflows_town_watchman", "attr.Initiative.high"],
    ]}
    {ru = "Колдун", en = "the Sorcerer", factors = [
        ["background.hackflows_druid"],
        ["background.cultist"],
        ["background.hackflows_herbalist"],
    ]}
    {ru = "Дед", en = "Gramps", factors = [
        ["background.retired_soldier", "attr.Stamina.low"],
        ["background.retired_soldier", "cost.low"],
    ]}
    {ru = "Самосуд", en = "the Vigilante", factors = [
        ["background.witchhunter", "trait.bloodthirsty"],
        ["background.killer_on_the_run"],
    ]}
    {names = [
        {ru = "Кошель", en = "the Moneybag"},
        {ru = "Барыга", en = "the Fence"},
    ], factors = [
        ["trait.greedy", "background.peddler"],  // жадный торговец
    ]}
    {ru = "Пахарь", en = "the Ploughman", factors = [
        ["background.farmhand", "attr.Stamina.high"],  // работяга-земледелец
    ]}
    {ru = "Шарманка", en = "the Hurdy-gurdy", factors = [
        ["background.minstrel", "trait.pessimist"],      // тянет одну унылую песню
        ["background.minstrel", "trait.superstitious"],
        ["trait.pessimist", "trait.superstitious"],
    ]}
    {ru = "Коновал", en = "the Quack", factors = [
        ["background.butcher", "trait.dumb"],               // вообще-то лекарь, но пациенты помирают
        ["background.hackflows_surgeon", "trait.clumsy"],
        ["background.hackflows_surgeon", "trait.dumb"],
    ]}
    {ru = "Отшельник", en = "the Hermit", factors = [
        ["background.wildman", "trait.paranoid"],           // дикий и шарахается от людей
        ["background.hackflows_druid", "trait.paranoid"],
    ]}
    {ru = "Деревенщина", en = "the Yokel", factors = [
        ["background.farmhand", "trait.clumsy"], // неуклюжий колхозник
        ["group.lowborn", "trait.superstitious"],
    ]}
    {ru = "Папаша", en = "Pop", factors = [
        ["trait.teamplayer", "background.brawler"], // защищает молодых бойцов кулаками
        ["trait.teamplayer", "trait.bright"],
    ]}
    {names = [
        {ru = "Землекоп", en = "the Digger"},
        {ru = "Гробовщик", en = "the Undertaker"},
    ], factors = [
        ["background.gravedigger"],  // закапывает трупы профессионально
    ]}
    {ru = "Шулер", en = "the Cardsharp", factors = [
        ["background.juggler", "trait.greedy"],  // обчистит своих же в кости
        ["background.hackflows_con_artist"],
    ]}
    {ru = "Тамада", en = "the Toastmaster", factors = [
        ["background.minstrel", "trait.dumb"],  // тупой бард, мешающий шуточками; жив без "Follow excludes"
        ["background.minstrel", "trait.drunkard"],  // и спеть, и выпить, и тост поднять
    ]}
    {ru = "Леший", en = "the Woodsprite", factors = [
        ["background.wildman"],                   // лесной дикарь-параноик
        ["background.wildman", "trait.paranoid"],
    ]}
    {ru = "Знахарь", en = "the Witch Doctor", factors = [
        ["background.shaman"],
        ["background.hackflows_druid"],
        ["background.hackflows_surgeon", "trait.irrational"],  // мутные грибы и странная трава
    ]}
    {ru = "Мародёр", en = "the Marauder", factors = [
        ["background.deserter", "trait.greedy"],  // дезертир, который вернулся ради лута
    ]}
    {ru = "Шарлатан", en = "the Charlatan", factors = [
        ["background.hackflows_con_artist"],  // мастер вешать лапшу на уши
    ]}
    {names = [
        {ru = "Обоз", en = "the Baggage"},
        {ru = "Погонщик", en = "the Drover"},
        {ru = "Колея", en = "the Rut"},
        {ru = "Тюк", en = "the Bundle"},
        {ru = "Пыль Столбом", en = "Dustcloud"},  // FIX: use this one for nomad too
    ], factors = [
        ["background.caravan_hand"],
    ]}
    {names = [
        {ru = "Клетка", en = "the Cage"},
        {ru = "Сетка", en = "the Net Fighter"},
    ], factors = [
        ["background.gladiator"],
    ]}
    {ru = "Любимчик", en = "the Favourite", factors = [
        ["background.gladiator"],  // любимец арены
        ["trait.chosen"],          // избранник — баловень богов
    ]}
    {ru = "Последний бой", en = "Last Fight", factors = [
        ["background.gladiator"],
        ["trait.deathwish"],
    ]}
    {ru = "Пилигрим", en = "the Pilgrim", factors = [
        ["weapon.staff", "group.peaceful"],
        ["group.peaceful"],
        ["background.monk", "group.peaceful"],
    ]}

    // ── Происхождение ────────────────────────────────────────────────────
    {names = [
        {ru = "Белоручка", en = "Soft Hands"},
        {ru = "Голубая Кровь", en = "Blue Blood"},
        {ru = "Породистый", en = "the Toff"},
    ], factors = [
        ["group.noble"],
    ]}
    {names = [
        {ru = "Клинок", en = "the Blade"},
        {ru = "Задаток", en = "Down Payment"},
        {ru = "Серебро", en = "Silver"},
        {ru = "Ничего Личного", en = "Nothing Personal"},
        {ru = "Свободный", en = "the Free Blade"},
    ], factors = [
        ["background.sellsword"],          // буквально продавал меч
    ]}
    {ru = "Холоп", en = "the Serf", factors = [
        ["background.servant"],
        ["trait.legend_fear_nobles"],      // страх перед господами — у него в крови
    ]}
    {names = [
        {ru = "Лакей", en = "the Lackey"},
        {ru = "Метла", en = "the Broom"},
        {ru = "Поклон", en = "the Bow"},
    ], factors = [
        ["background.servant"],
    ]}
    {ru = "Кирпич", en = "the Brick", factors = [
        ["background.mason"],
        ["background.mason", "trait.iron_jaw"],  // крепкий и квадратный
    ]}
    {names = [
        {ru = "Каменщик", en = "the Mason"},
        {ru = "Плита", en = "the Slab"},
        {ru = "Зубило", en = "the Chisel"},
    ], factors = [
        ["background.mason"],
    ]}
    {ru = "Паж", en = "the Page", factors = [
        ["background.squire"],
    ]}
    {ru = "Коробейник", en = "the Pedlar", factors = [
        ["background.peddler"],
        ["perk.bags_and_belts"],  // carries everything with him
    ]}
    {names = [
        {ru = "Торгаш", en = "the Huckster"},
        {ru = "Лоток", en = "the Tray Man"},
    ], factors = [
        ["background.peddler"],
    ]}
    {ru = "Сюда Иди", en = "Come Hither", factors = [
        ["background.peddler"],
        ["background.peddler", "trait.cocky"],
    ]}
    {names = [
        {ru = "Силки", en = "Snares"},
        {ru = "Кот", en = "the Tom Cat"},
        {ru = "Ночник", en = "the Prowler"},
        {ru = "Нычка", en = "Stash"},
    ], factors = [
        ["background.poacher"],            // жил тихо — расставлял ловушки
    ]}
    {ru = "Капкан", en = "the Trap", factors = [
        ["background.poacher"],
        ["background.poacher", "trait.irrational"],  // ironic: сам попался в наёмники
    ]}
    {ru = "Инквизитор", en = "the Inquisitor", factors = [
        ["trait.hate_undead"],
        ["background.monk", "trait.hate_undead"],
        ["background.witchhunter"],
    ]}
    {ru = "Шаман", en = "the Shaman", factors = [
        ["background.shaman"],
    ]}
    {ru = "Маменькин сынок", en = "Mama's Boy", factors = [
        ["group.noble", "trait.fainthearted"],  // благородных кровей, при виде крови — в обморок
    ]}
    {ru = "Святоша", en = "the Holy Roller", factors = [
        ["trait.bloodthirsty", "background.monk"],    // на нём столько крови — давно должен гореть в аду
        ["trait.bloodthirsty", "trait.superstitious"],
    ]}
    {names = [
        {ru = "Кровосос", en = "the Bloodsucker"},
        {ru = "Упырь", en = "the Ghoul"},
    ], factors = [
        ["perk.necro.blood_sucking"],
    ]}
    {ru = "Кукловод", en = "the Puppeteer", factors = [
        ["perk.necro.mind_meld"],  // bends undead minds to his will
    ]}
    {ru = "Поводырь", en = "the Guide", factors = [
        ["perk.necro.soul_link"],  // водит нежить за собой
    ]}
    {names = [
        {ru = "Голосок", en = "the High Voice"},
        {ru = "Дворцовый", en = "the Palace Man"},
    ], factors = [
        ["background.eunuch"],
    ]}

    // ── Легендарные черты ─────────────────────────────────────────────────
    {ru = "Берсерк", en = "the Berserker", factors = [
        ["trait.legend_aggressive"],
        ["perk.berserk"],                  // literally the berserk perk
        ["perk.killing_frenzy"],           // frenzied after kills
        ["perk.hackflows.battle_flow"],    // keeps the momentum going
    ]}
    {ru = "Светлячок", en = "the Firefly", factors = [
        ["trait.bright"],
        ["trait.night_blind"],
        ["trait.legend_fear_dark"],    // без огня — никуда
    ]}
    {ru = "Книга", en = "the Open Book", factors = [
        ["trait.bright"],
        ["perk.student"],
        ["trait.legend_predictable"],  // читается насквозь
    ]}

    // ── Прочие черты ──────────────────────────────────────────────────────
    {ru = "Подлец", en = "the Rascal", factors = [
        ["trait.dastard"],
        ["trait.disloyal"],
    ]}
    {ru = "Сглаз", en = "the Jinx", factors = [
        ["trait.superstitious"],  // всё вокруг — дурной знак
    ]}
    {names = [
        {ru = "Мука", en = "the Flour"},
        {ru = "Водяной", en = "the Water Spirit"},
        {ru = "Закрома", en = "the Granary"},
    ], factors = [
        ["background.miller"],  // мельник — мука буквально
    ]}
    {ru = "Глухарь", en = "the Deaf Grouse", factors = [
        ["injury.missing_ear"],
        ["injury.missing_ear", "trait.dumb"],
    ]}
    {ru = "Безрукий", en = "the Handless", factors = [
        ["injury.missing_hand"],
        ["type.melee", "attr.MeleeSkill.low", "trait.clumsy"],
    ]}
    {ru = "Беспалый", en = "the Fingerless", factors = [
        ["injury.missing_finger"],
        ["injury.missing_finger", "background.hackflows_master_archer"],
    ]}
    {ru = "Подранок", en = "the Wounded Bird", factors = [
        ["trait.bleeder"],
        ["injury.maimed_foot", "trait.survivor"],
    ]}
    {ru = "Битый", en = "the Beaten", factors = [
        ["injury.traumatized", "trait.tough"],
        ["trait.survivor", "trait.ailing"],
    ]}
    {ru = "Штык", en = "the Bayonet", factors = [
        ["weapon.spear", "attr.MeleeSkill.high"],
        ["weapon.polearm", "perk.reach_advantage"],
        ["weapon.spear", "trait.impatient"],
    ]}
    {ru = "Пращник", en = "the Slinger", factors = [
        ["weapon.sling"],
    ]}
    {ru = "Камушек", en = "the Pebble", factors = [
        ["weapon.sling", "trait.tiny"],
        ["weapon.sling"],
    ]}
    {ru = "Самострел", en = "Self-Shot", factors = [
        ["weapon.crossbow", "trait.clumsy"],
        ["weapon.crossbow", "trait.dumb"],
    ]}
    {ru = "Залп", en = "the Volley", factors = [
        ["weapon.firearm"],
        ["weapon.firearm", "trait.brute"],
        ["type.ranged", "trait.impatient"],  // не целится — лупит всё сразу
    ]}
    {ru = "Рогатина", en = "the Boar Spear", factors = [
        ["weapon.spear", "trait.hate_beasts"],
        ["weapon.spear", "background.hunter"],
    ]}
    {ru = "Клевец", en = "the War Pick", factors = [
        ["weapon.hammer", "attr.MeleeSkill.high"],
        ["weapon.hammer", "perk.head_hunter"],
    ]}
    {ru = "Кол", en = "the Stake", factors = [
        ["weapon.spear", "trait.hate_undead"],
        ["background.witchhunter", "weapon.spear"],
    ]}
    {ru = "Ледоруб", en = "the Ice-Cutter", factors = [
        ["weapon.axe", "perk.head_hunter"],
        ["weapon.axe", "trait.strong"],
    ]}
    {ru = "Меткий", en = "the Sharpshooter", factors = [
        ["attr.RangedSkill.high", "perk.bullseye"],
        ["type.ranged", "attr.RangedSkill.high", "trait.eagle_eyes"],
    ]}
    {ru = "Оса", en = "the Wasp", factors = [
        ["weapon.dagger", "trait.bloodthirsty"],
        ["weapon.dagger", "trait.cocky"],
        ["weapon.dagger", "attr.MeleeSkill.high"],
    ]}
    {ru = "Скала", en = "the Cliff", factors = [
        ["trait.iron_jaw", "attr.Hitpoints.high"],
        ["trait.determined", "trait.tough"],
    ]}
    {ru = "Призрак", en = "the Ghost", factors = [
        ["perk.dodge", "trait.dexterous"],
        ["attr.MeleeDefense.high", "attr.RangedDefense.high", "trait.swift"],
    ]}
    {ru = "Подушка", en = "the Pillow", factors = [
        ["attr.Hitpoints.high", "attr.MeleeDefense.low", "trait.survivor"],
        ["attr.Hitpoints.high", "trait.tough"],
        ["attr.Hitpoints.high", "trait.fat"],
    ]}
    {ru = "Дуб", en = "the Oak", factors = [
        ["attr.Bravery.high", "trait.tough"],
        ["attr.Bravery.high", "trait.determined"],
        ["trait.dumb", "trait.tough"],
        ["trait.sure_footing", "attr.Hitpoints.high"],
    ]}
    {ru = "Булат", en = "Damascus", factors = [
        ["perk.battle_forged", "attr.Bravery.high"],
        ["perk.battle_forged"],
    ]}
    {ru = "Бивень", en = "the Tusk", factors = [
        ["trait.iron_jaw", "trait.huge"],
        ["trait.iron_jaw", "perk.fearsome"],
    ]}
    {ru = "Чугун", en = "the Pig-Iron", factors = [
        ["trait.iron_jaw", "trait.dumb"],
        ["perk.steel_brow", "trait.dumb"],
    ]}
    {ru = "Чуткий", en = "the Hunch", factors = [
        ["perk.anticipation"],
        ["perk.anticipation", "trait.paranoid"],
    ]}
    {ru = "Старожил", en = "the Old-Timer", factors = [
        ["perk.nine_lives", "trait.survivor"],
        ["background.retired_soldier", "trait.tough"],
    ]}
    {ru = "Волчара", en = "the Grey Wolf", factors = [
        ["perk.lone_wolf", "trait.bloodthirsty"],
        ["perk.lone_wolf", "attr.MeleeSkill.high"],
    ]}
    {ru = "Ураган", en = "the Hurricane", factors = [
        ["cost.high", "perk.berserk", "attr.MeleeSkill.high"],
        ["cost.high", "perk.killing_frenzy", "perk.overwhelm"],
    ]}
    {ru = "Лисёнок", en = "the Fox Cub", factors = [
        ["background.apprentice", "trait.weasel"],
        ["trait.bright", "trait.weasel", "trait.tiny"],
    ]}
    {ru = "Волчонок", en = "the Wolf Cub", factors = [
        ["background.apprentice", "attr.MeleeSkill.high"],
        ["background.apprentice", "trait.bloodthirsty"],
        ["background.squire", "trait.bloodthirsty"],
        ["background.aspirant", "attr.MeleeSkill.high"],
    ]}
    {ru = "Зубоскал", en = "the Snickerer", factors = [
        ["trait.cocky", "trait.impatient"],
        ["trait.cocky", "trait.bloodthirsty"],
    ]}
    {ru = "Гусь", en = "the Goose", factors = [
        ["trait.cocky", "attr.Stamina.high"],
        ["trait.cocky", "attr.Initiative.high"],
    ]}
    {ru = "Муха", en = "the Fly", factors = [
        ["trait.cocky", "trait.impatient"],
        ["trait.tiny", "trait.impatient"],
        ["trait.tiny", "attr.Initiative.high"],
    ]}
    {ru = "Плут", en = "the Crook", factors = [
        ["background.thief", "trait.weasel"],
        ["background.hackflows_con_artist", "trait.bright"],
    ]}
    {ru = "Змеёныш", en = "the Snakeling", factors = [
        ["trait.weasel", "trait.tiny"],
        ["trait.disloyal", "trait.tiny"],
    ]}
    {ru = "Бедокур", en = "the Hellion", factors = [
        ["trait.irrational", "trait.drunkard"],
        ["background.brawler", "trait.drunkard"],
    ]}
    {ru = "Орколом", en = "Orc-Breaker", factors = [
        ["trait.hate_greenskins", "attr.MeleeSkill.high"],
        ["trait.hate_greenskins", "weapon.hammer"],
    ]}
    {ru = "Травник", en = "the Herbman", factors = [
        ["background.hackflows_herbalist"],
        ["background.hackflows_herbalist", "trait.bright"],
    ]}
    {ru = "Голубятник", en = "the Pigeoner", factors = [
        ["background.hackflows_roofer"],
    ]}
    {ru = "Кисточка", en = "the Brush", factors = [
        ["background.hackflows_painter", "trait.tiny"],
    ]}
    {ru = "Маляр", en = "the Dauber", factors = [
        ["background.hackflows_painter", "trait.dumb"],  // жив без "Follow excludes"
        ["background.hackflows_painter", "trait.clumsy"],  // художник с руками не оттуда
    ]}
    {ru = "Тяпка", en = "the Hoe", factors = [
        ["background.hackflows_gardener", "trait.dumb"],
        ["background.farmhand", "trait.dumb"],
    ]}
    {ru = "Игла", en = "the Needle", factors = [
        ["background.tailor", "weapon.dagger"],
        ["background.tailor", "trait.swift"],
        ["weapon.dagger", "trait.swift"],
    ]}
    {ru = "Ряса", en = "the Cassock", factors = [
        ["background.monk"],
        ["background.monk", "attr.Stamina.low"],
    ]}
    {ru = "Служивый", en = "the Servicer", factors = [
        ["background.retired_soldier"],
        ["background.retired_soldier", "trait.loyal"],
    ]}
    {ru = "Служака", en = "the Barracks Man", factors = [
        ["group.combat", "trait.loyal"],
        ["background.retired_soldier", "trait.loyal"],
    ]}
    {ru = "Сирота", en = "the Orphan", factors = [
        ["background.refugee", "trait.fainthearted"],
        ["background.vagabond", "attr.Hitpoints.low"],
    ]}
    {ru = "Горн", en = "the Forge", factors = [
        ["background.hackflows_blacksmith"],
        ["background.hackflows_blacksmith", "attr.Hitpoints.high"],
    ]}
    {ru = "Приблудный", en = "the Stray", factors = [
        ["background.refugee", "trait.disloyal"],
        ["background.deserter", "trait.disloyal"],
    ]}
    {ru = "Перекати-поле", en = "the Tumbleweed", factors = [
        ["background.vagabond", "trait.impatient"],
        ["background.hackflows_drifter", "trait.impatient"],
    ]}
    {ru = "Креститель", en = "the Baptist", factors = [
        ["background.witchhunter", "trait.hate_undead"],
        ["background.witchhunter", "perk.fearsome"],
    ]}
    {ru = "Босяк", en = "Bareheel", factors = [
        ["group.pauper", "background.beggar"],
        ["background.vagabond", "attr.Stamina.low"],
    ]}
    {ru = "Дорогой", en = "the Pricey", factors = [
        ["cost.high", "trait.greedy"],
        ["cost.high", "attr.MeleeSkill.high"],
    ]}
    {ru = "Кубышка", en = "the Piggybank", factors = [
        ["trait.greedy", "attr.Hitpoints.high"],
        ["trait.greedy", "trait.fat"],
    ]}
    {ru = "Лось", en = "the Elk", factors = [
        ["trait.huge", "attr.Stamina.high"],
        ["trait.huge", "trait.determined"],
    ]}
    {ru = "Мешок", en = "the Sack", factors = [
        ["trait.fat", "attr.Initiative.low"],
        ["trait.fat", "trait.clumsy"],
    ]}
    {ru = "Пузырь", en = "the Bubble", factors = [
        ["trait.fragile", "attr.Hitpoints.low"],
        ["trait.fainthearted", "trait.fragile"],
    ]}
    {ru = "Лепёха", en = "the Flatbread", factors = [
        ["trait.fat", "trait.fragile"],
        ["trait.fat", "attr.Stamina.low"],
    ]}
    {ru = "Мямля", en = "the Drip", factors = [
        ["trait.pessimist", "trait.fainthearted"],
        ["trait.fainthearted", "trait.fragile"],
    ]}
    {ru = "Безносый", en = "the Noseless", factors = [
        ["injury.missing_nose"],
        ["injury.missing_nose", "trait.insecure"],
    ]}
    {ru = "Хрящ", en = "the Gristle", factors = [
        ["trait.iron_jaw", "trait.tiny"],  // оба — живы без "Follow excludes"
        ["trait.tough", "trait.tiny"],
        ["trait.iron_lungs", "trait.tiny"],  // мелкий и жилистый, не угрызёшь
    ]}
    {ru = "Бирюк", en = "the Loner", factors = [
        ["trait.paranoid", "perk.lone_wolf"],
        ["trait.paranoid", "background.hackflows_drifter"],
    ]}
    {ru = "Баклан", en = "the Cormorant", factors = [
        ["background.fisherman", "trait.cocky"],
        ["background.fisherman", "trait.dumb"],
    ]}
    {ru = "Плакса", en = "the Crybaby", factors = [
        ["trait.fainthearted", "trait.craven"],
        ["trait.fainthearted", "attr.Bravery.low"],
    ]}
    {ru = "Зевака", en = "the Gawker", factors = [
        ["trait.hesitant", "attr.MeleeSkill.low"],
        ["trait.hesitant", "attr.Initiative.low"],
    ]}
    {ru = "Ловец", en = "the Catcher", factors = [
        ["background.ratcatcher"],
        ["background.manhunter"],
        ["background.witchhunter"],
        ["background.beast_slayer"],
    ]}
    {ru = "Битый жбан", en = "the Cracked Jug", factors = [
        ["injury.brain_damage"],
        ["injury.brain_damage", "trait.irrational"],
        ["injury.brain_damage", "trait.survivor"],
        ["perk.nine_lives", "trait.dumb"],
        ["trait.survivor", "trait.dumb"],
    ]}
    {ru = "Черепок", en = "the Cracked Pot", factors = [
        ["injury.brain_damage"],
        ["trait.fragile"],
    ]}
    {ru = "Глаз Да Глаз", en = "All-Eyes", factors = [
        ["injury.missing_eye"],
        ["injury.missing_eye", "perk.anticipation"],
        ["injury.missing_eye", "trait.paranoid"],
        ["perk.anticipation", "trait.paranoid"],
        ["trait.disloyal", "trait.greedy"],
    ]}
    {ru = "Лихоманка", en = "the Fever", factors = [
        ["trait.ailing", "attr.Hitpoints.low"],
        ["trait.ailing", "trait.pessimist"],
    ]}
    {ru = "Драная Шкура", en = "the Torn Hide", factors = [
        ["trait.bleeder", "perk.nine_lives"],
        ["trait.bleeder", "trait.tough"],
    ]}
    {ru = "Живучий Кот", en = "the Tough Cat", factors = [
        ["perk.nine_lives", "trait.lucky"],
        ["perk.nine_lives", "perk.fast_adaption"],
    ]}
    {ru = "Хромой Чёрт", en = "the Limping Devil", factors = [
        ["trait.clubfooted", "trait.bloodthirsty"],
        ["trait.clubfooted", "trait.determined"],
    ]}
    {ru = "Верный Клинок", en = "the True Blade", factors = [
        ["weapon.sword", "attr.MeleeSkill.high"],
        ["weapon.sword", "perk.duelist"],
    ]}
    {ru = "Лёгкая Рука", en = "the Light Hand", factors = [
        ["trait.dexterous", "weapon.dagger"],
        ["type.melee", "attr.MeleeSkill.high", "trait.swift"],
        ["type.melee", "attr.MeleeSkill.high", "attr.Initiative.high"],
    ]}
    {ru = "Дубовая Стрела", en = "the Oaken Arrow", factors = [
        ["weapon.bow", "trait.dumb"],
        ["weapon.bow", "attr.RangedSkill.low"],
    ]}
    {ru = "Три Руки", en = "Three Hands", factors = [
        ["perk.quick_hands", "trait.swift"],
        ["perk.quick_hands", "trait.dexterous"],
        ["perk.quick_hands", "attr.MeleeSkill.high"],
    ]}
    {ru = "Медная Шкура", en = "the Copper Hide", factors = [
        ["perk.battle_forged", "attr.Stamina.high"],
        ["perk.battle_forged", "perk.colossus"],
    ]}
    {ru = "Бычья Шея", en = "the Ox Neck", factors = [
        ["trait.strong", "perk.steel_brow"],
        ["trait.huge", "perk.steel_brow"],
    ]}
    {ru = "Лёгкий Шаг", en = "Lightfoot", factors = [
        ["perk.footwork", "trait.swift"],
        ["perk.pathfinder", "trait.swift"],
    ]}
    {ru = "Вторая Кожа", en = "the Second Skin", factors = [
        ["perk.nimble", "trait.dexterous"],
        ["perk.nimble", "trait.swift"],
        ["perk.nimble", "attr.Initiative.high"],
    ]}
    {ru = "Кошачья Лапа", en = "the Cat Paw", factors = [
        ["perk.footwork", "trait.dexterous"],
        ["trait.dexterous", "attr.MeleeSkill.high"],
    ]}
    {ru = "Медная Глотка", en = "the Brass Throat", factors = [
        ["perk.rally_the_troops"],
        ["perk.rally_the_troops", "attr.Stamina.high"],
        ["perk.rally_the_troops", "attr.Bravery.high"],
    ]}
    {ru = "Старый Волк", en = "the Old Wolf", factors = [
        ["perk.lone_wolf", "background.retired_soldier"],
        ["perk.lone_wolf", "trait.survivor"],
    ]}
    {ru = "Мокрая Курица", en = "the Wet Hen", factors = [
        ["trait.craven", "trait.fainthearted"],
        ["trait.craven", "attr.Stamina.low"],
    ]}
    {ru = "Коленки", en = "Shaky Knees", factors = [
        ["trait.craven", "attr.Bravery.low"],
        ["trait.fainthearted", "attr.Initiative.low"],
    ]}
    {ru = "Кислый Хрен", en = "the Bitter Root", factors = [
        ["trait.pessimist", "trait.hesitant"],
        ["trait.pessimist", "attr.Bravery.low"],
    ]}
    {ru = "Тихий Омут", en = "the Quiet Pool", factors = [
        ["trait.pessimist", "attr.MeleeSkill.high"],
        ["perk.fortified_mind", "attr.MeleeSkill.high"],
    ]}
    {ru = "Дурной Глаз", en = "the Evil Eye", factors = [
        ["trait.superstitious", "trait.paranoid"],
        ["trait.superstitious", "trait.irrational"],
    ]}
    {ru = "Бешеный Пёс", en = "the Mad Dog", factors = [
        ["trait.bloodthirsty", "trait.irrational"],
        ["trait.bloodthirsty", "perk.berserk"],
    ]}
    {ru = "Гнилой Зуб", en = "the Rotten Tooth", factors = [
        ["trait.ailing", "trait.pessimist"],
        ["trait.ailing", "trait.drunkard"],
    ]}
    {ru = "Сорняк", en = "the Weed", factors = [
        ["trait.survivor", "trait.disloyal"],
        ["trait.survivor", "trait.pessimist"],
    ]}
    {ru = "Старый Монах", en = "the Old Monk", factors = [
        ["background.monk", "trait.survivor"],
        ["background.monk", "attr.Bravery.high"],
    ]}
    {ru = "Лесной Волк", en = "the Forest Wolf", factors = [
        ["background.wildman", "perk.lone_wolf"],
        ["background.wildman", "trait.bloodthirsty"],
    ]}
    {ru = "Дикий Пёс", en = "the Wild Dog", factors = [
        ["background.wildman", "trait.fearless"],
        ["background.wildman", "trait.brute"],
    ]}
    {ru = "Шкурник", en = "the Pelter", factors = [
        ["background.poacher", "trait.greedy"],
        ["background.poacher", "weapon.bow"],
    ]}
    {ru = "Конокрад", en = "the Horse Thief", factors = [
        ["background.thief", "attr.Initiative.high"],
        ["background.thief", "trait.swift"],
    ]}
    {ru = "Серая Мышь", en = "the Grey Mouse", factors = [
        ["background.servant", "trait.tiny"],
        ["background.hackflows_cobbler", "trait.tiny"],
    ]}
    {ru = "Лавочник", en = "the Shopkeep", factors = [
        ["background.peddler", "trait.greedy"],
        ["background.peddler", "trait.fat"],
    ]}
    {ru = "Голый Зад", en = "the Bare Arse", factors = [
        ["group.pauper", "attr.Stamina.low"],
        ["background.beggar"],
    ]}
    {ru = "Жирный Боров", en = "the Fat Hog", factors = [
        ["trait.gluttonous", "trait.fat"],
        ["trait.fat", "trait.strong"],
    ]}
    {ru = "Сон-трава", en = "the Sleep-Herb", factors = [
        ["background.hackflows_herbalist", "trait.pessimist"],
        ["trait.pessimist", "attr.Initiative.low"],
    ]}
    {ru = "Сухой Сучок", en = "the Dry Twig", factors = [
        ["trait.fragile", "attr.Stamina.low"],
        ["trait.fragile", "trait.ailing"],
    ]}
    {ru = "Толстый Каравай", en = "the Fat Loaf", factors = [
        ["trait.fat", "trait.gluttonous"],
        ["trait.fat", "attr.Hitpoints.high"],
    ]}
    {ru = "Тупой Кол", en = "the Dull Stake", factors = [
        ["trait.dumb", "trait.determined"],
        ["trait.dumb", "trait.loyal"],
    ]}
    {ru = "Пень С Глазами", en = "Stump-with-Eyes", factors = [
        ["attr.Initiative.low", "trait.dumb"],
        ["trait.huge", "trait.dumb"],
        ["trait.dumb", "trait.eagle_eyes"],
    ]}
    {ru = "Золотые Руки", en = "the Golden Hands", factors = [
        ["background.tailor", "attr.MeleeSkill.high"],
        ["background.hackflows_blacksmith", "attr.MeleeSkill.high"],
    ]}
    {ru = "Лошадиная Сила", en = "the Horse Power", factors = [
        ["attr.Stamina.high", "attr.Hitpoints.high"],
        ["trait.iron_lungs", "attr.Stamina.high"],
    ]}
    {ru = "Подкова", en = "the Horseshoe", factors = [
        ["trait.lucky"],
        ["background.hackflows_blacksmith"],
        ["trait.sure_footing", "trait.lucky"],
    ]}
    {ru = "Колун", en = "the Chopper", factors = [
        ["weapon.axe", "trait.strong"],
        ["background.lumberjack", "weapon.axe"],
        ["weapon.axe", "perk.brawny"],
        ["weapon.axe", "trait.huge"],
    ]}
    {ru = "Кочан", en = "the Cabbage", factors = [
        ["trait.iron_jaw", "trait.dumb"],
        ["perk.steel_brow", "trait.dumb"],
        ["injury.brain_damage", "perk.steel_brow"],
    ]}
    {ru = "Квас", en = "the Kvass", factors = [
        ["trait.drunkard", "trait.optimist"],
        ["background.hackflows_barkeep"],
        ["trait.drunkard", "attr.Bravery.high"],
    ]}
    {ru = "Пробка", en = "the Cork", factors = [
        ["trait.survivor"],
        ["trait.lucky", "trait.survivor"],
        ["perk.nine_lives"],
        ["trait.dumb"],
        ["trait.drunkard"],
    ]}
    {ru = "Гнилушка", en = "the Rotten Stub", factors = [
        ["trait.ailing", "trait.survivor"],
        ["background.hackflows_leper"],
        ["injury.weakened_heart", "trait.survivor"],
    ]}
    {ru = "Сучок", en = "the Snag", factors = [
        ["trait.tiny", "trait.determined"],
        ["trait.clubfooted", "trait.tough"],
    ]}
    {ru = "Пила", en = "the Saw", factors = [
        ["weapon.cleaver", "perk.crippling_strikes"],
        ["weapon.axe", "perk.crippling_strikes"],
        ["background.hackflows_carpenter"],
    ]}
    {ru = "Кочерыжка", en = "the Cabbagehead", factors = [
        ["trait.tiny", "trait.tough"],
        ["trait.tiny", "perk.steel_brow"],
        ["attr.Hitpoints.high", "trait.tiny"],
    ]}
    {ru = "Окорок", en = "the Ham", factors = [
        ["trait.fat", "attr.Hitpoints.high"],
        ["trait.gluttonous", "trait.fat"],
        ["background.butcher", "trait.fat"],
    ]}
    {ru = "Кисель", en = "the Jelly", factors = [
        ["trait.craven"],
        ["trait.insecure", "attr.Bravery.low"],
        ["trait.fainthearted", "attr.Initiative.high"],
    ]}
    {ru = "Калач", en = "the Roll", factors = [
        ["background.hackflows_cook"],
        ["trait.survivor", "trait.optimist"],
        ["background.brawler", "trait.tough"],
    ]}
    {ru = "Репа", en = "the Turnip", factors = [
        ["trait.dumb", "trait.tough"],
        ["background.farmhand"],
        ["attr.Hitpoints.high", "attr.Initiative.low"],
        ["trait.iron_jaw", "trait.dumb"],
        ["perk.steel_brow", "trait.dumb"],
    ]}
    {ru = "Хрен", en = "the Horseradish", factors = [
        ["trait.brute", "trait.tiny"],
        ["weapon.dagger", "trait.brute"],
        ["trait.irrational", "trait.brave"],
    ]}
    {ru = "Половник", en = "the Ladle", factors = [
        ["background.hackflows_cook", "weapon.polearm"],
        ["background.servant", "weapon.polearm"],
        ["weapon.polearm", "trait.dumb"],
    ]}
    {ru = "Котелок", en = "the Pothead", factors = [
        ["trait.iron_jaw"],
        ["perk.steel_brow"],
        ["injury.brain_damage", "trait.tough"],
    ]}
    {ru = "Багор", en = "the Gaff", factors = [
        ["background.fisherman", "weapon.polearm"],
        ["weapon.polearm", "perk.crippling_strikes"],
        ["perk.reach_advantage", "trait.determined"],
    ]}
    {ru = "Верёвка", en = "the Rope", factors = [
        ["background.hackflows_hangman"],
        ["background.hackflows_pirate"],
        ["perk.rotation", "trait.teamplayer"],
    ]}
    {ru = "Петух в мешке", en = "Cock-in-Bag", factors = [
        ["trait.cocky", "attr.Bravery.low"],
        ["trait.cocky", "trait.craven"],
        ["perk.taunt", "trait.craven"],
    ]}
    {ru = "Подмётка", en = "the Sole", factors = [
        ["background.hackflows_cobbler", "trait.survivor"],
        ["perk.pathfinder", "trait.survivor"],
        ["injury.maimed_foot", "trait.determined"],
    ]}
    {ru = "Сверчок", en = "the Cricket", factors = [
        ["trait.tiny", "trait.night_owl"],
        ["background.minstrel", "trait.tiny"],
        ["trait.optimist", "trait.night_owl"],
    ]}
    {ru = "Фитиль", en = "the Fuse", factors = [
        ["trait.tiny", "trait.impatient"],
        ["trait.impatient", "trait.irrational"],
        ["weapon.firearm", "trait.impatient"],
    ]}
    {ru = "Булыжник", en = "the Cobble", factors = [
        ["background.mason"],
        ["weapon.throwing", "trait.strong"],
        ["perk.steel_brow", "trait.tough"],
    ]}
    {ru = "Репей", en = "the Burr", factors = [
        ["trait.determined", "trait.survivor"],
        ["perk.hold_out"],
        ["perk.underdog", "trait.determined"],
    ]}
    {ru = "Мухомор", en = "the Toadstool", factors = [
        ["trait.cocky", "trait.dumb"],
        ["background.hackflows_herbalist", "trait.irrational"],
        ["trait.irrational", "trait.weasel"],
        ["background.hackflows_cook", "trait.dumb"],
    ]}
    {ru = "Пиявочник", en = "the Leecher", factors = [
        ["background.hackflows_herbalist", "trait.greedy"],
        ["background.hackflows_surgeon", "trait.greedy"],
        ["perk.necro.blood_sucking"],
    ]}
    {ru = "Костыль", en = "the Crutch", factors = [
        ["background.cripple"],
        ["injury.maimed_foot"],
        ["trait.clubfooted"],
    ]}
    {ru = "Шрам", en = "the Scar", factors = [
        ["injury.missing_ear"],
        ["injury.missing_eye"],
        ["trait.survivor"],
    ]}
    {ru = "Пустое ухо", en = "the Empty Ear", factors = [
        ["injury.missing_ear"],
        ["injury.missing_ear", "trait.dumb"],
        ["injury.missing_ear", "trait.brave"],
    ]}
    {ru = "Мёртвяк", en = "Deadman", factors = [
        ["trait.ailing", "trait.fearless"],
        ["trait.survivor", "trait.fear_undead"],
    ]}
    {ru = "Святая вода", en = "the Holy Water", factors = [
        ["trait.fear_undead"],
        ["background.monk", "trait.fear_undead"],
        ["background.witchhunter", "trait.hate_undead"],
    ]}
    {ru = "Хлыст", en = "the Whip", factors = [
        ["background.flagellant"],
        ["trait.deathwish", "background.flagellant"],
        ["perk.overwhelm", "weapon.flail"],
    ]}
    {ru = "Напёрсток", en = "the Thimble", factors = [
        ["background.tailor", "trait.tiny"],
        ["trait.tiny", "perk.shield_expert"],
        ["trait.dexterous", "trait.tiny"],
        ["background.hackflows_con_artist", "trait.tiny"],
        ["background.hackflows_con_artist", "trait.dexterous"],
    ]}
    {ru = "Монета", en = "the Coin", factors = [
        ["trait.greedy"],
        ["background.gambler"],
        ["trait.disloyal", "trait.greedy"],
    ]}
    {ru = "Ночной горшок", en = "the Chamberpot", factors = [
        ["background.servant"],
        ["background.servant", "trait.pessimist"],
        ["background.servant", "trait.fragile"],
    ]}
    {ru = "Крысиный хвост", en = "the Rat-tail", factors = [
        ["background.ratcatcher"],
        ["trait.weasel", "trait.tiny"],
        ["background.beggar", "trait.weasel"],
    ]}
    {ru = "Пыльная пятка", en = "the Dust Heel", factors = [
        ["background.messenger", "trait.swift"],
        ["perk.pathfinder", "trait.swift"],
        ["background.hackflows_drifter", "perk.pathfinder"],
    ]}
    {ru = "Будка", en = "the Watchbox", factors = [
        ["background.hackflows_town_watchman", "trait.pessimist"],
        ["trait.hesitant", "attr.MeleeDefense.high"],
        ["perk.shield_expert"],
        ["background.houndmaster"],
        ["background.houndmaster", "trait.loyal"],
    ]}
    {ru = "Кайло", en = "the Pickaxe", factors = [
        ["background.miner"],
    ]}
    {ru = "Кость", en = "the Bone", factors = [
        ["injury.broken_elbow_joint"],
        ["perk.hold_out", "trait.dumb"],
        ["trait.iron_jaw", "trait.dumb"],
    ]}
    {ru = "Копыто", en = "the Hoof", factors = [
        ["trait.sure_footing", "trait.strong"],
        ["background.shepherd", "trait.sure_footing"],
    ]}
    {ru = "Кабанчик", en = "the Shoat", factors = [
        ["trait.tiny", "trait.fat"],
        ["trait.brute", "trait.fat"],
        ["trait.gluttonous", "trait.impatient"],
    ]}
    {ru = "Капюшон", en = "the Hood", factors = [
        ["background.thief"],
        ["background.assassin"],
        ["perk.backstabber"],
    ]}
    {ru = "Сало", en = "the Lard", factors = [
        ["trait.fat"],
        ["trait.gluttonous"],
        ["background.butcher", "trait.gluttonous"],
    ]}
    {ru = "Колесо", en = "the Wheel", factors = [
        ["background.caravan_hand"],
        ["perk.rotation"],
        ["trait.swift", "perk.footwork"],
    ]}
    {ru = "Секач", en = "the Hewer", factors = [
        ["weapon.axe", "trait.impatient"],
        ["weapon.cleaver", "trait.impatient"],
        ["perk.berserk"],
    ]}
    {ru = "Хомяк", en = "the Hoarder", factors = [
        ["trait.greedy", "trait.gluttonous"],
        ["perk.bags_and_belts", "trait.greedy"],
        ["trait.fat", "trait.greedy"],
    ]}
    {ru = "Паскуда", en = "the Scab", factors = [
        ["trait.weasel", "trait.disloyal"],
        ["background.hackflows_con_artist", "trait.disloyal"],
        ["trait.greedy", "trait.weasel"],
    ]}
    {ru = "Гнилой зуб", en = "the Rot Tooth", factors = [
        ["trait.weasel", "trait.disloyal"],
        ["trait.bloodthirsty", "trait.weasel"],
        ["background.killer_on_the_run"],
    ]}
    {ru = "Свиное ушко", en = "the Pig Ear", factors = [
        ["trait.gluttonous", "trait.greedy"],
        ["injury.missing_ear", "trait.gluttonous"],
        ["trait.fat", "trait.greedy"],
    ]}
    {ru = "Грязный ноготь", en = "Dirtynails", factors = [
        ["background.gravedigger"],
        ["background.miner"],
        ["trait.disloyal", "trait.weasel"],
    ]}
    {names = [
        {ru = "Две левых", en = "Two Left"},
        {ru = "Не та нога", en = "the Wrong Leg"},
    ], factors = [
        ["trait.clubfooted"],
        ["trait.clubfooted", "trait.clumsy"],
        ["trait.clubfooted", "trait.pessimist"],
    ]}
    {ru = "Пёсья кость", en = "the Dog Bone", factors = [
        ["background.houndmaster"],
        ["trait.loyal", "trait.brute"],
        ["trait.hate_beasts", "trait.brute"],
    ]}
    {ru = "Карман", en = "the Pocket", factors = [
        ["background.thief"],
        ["background.hackflows_con_artist"],
        ["perk.bags_and_belts"],
        ["trait.greedy", "perk.quick_hands"],
    ]}
    {ru = "Деревянный меч", en = "the Wood Sword", factors = [
        ["weapon.sword", "attr.MeleeSkill.low"],
        ["background.apprentice", "weapon.sword"],
        ["cost.low", "weapon.sword"],
    ]}
    {ru = "Мясной крюк", en = "the Meat Hook", factors = [
        ["background.butcher", "weapon.polearm"],
        ["weapon.polearm", "perk.crippling_strikes"],
        ["trait.bloodthirsty", "perk.crippling_strikes"],
    ]}
    {ru = "Пароход", en = "Ironclad", factors = [
        ["perk.battle_forged", "attr.MeleeDefense.high"],
        ["perk.battle_forged", "trait.tough"],
        ["perk.battle_forged", "background.hedge_knight"],
        ["perk.battle_forged", "trait.huge"],
        ["background.hedge_knight", "trait.huge"],
    ]}
    {ru = "Доброе Железо", en = "Goodblade", factors = [
        ["weapon.sword", "attr.MeleeSkill.high"],
        ["weapon.sword", "perk.duelist"],
        ["weapon.axe", "attr.MeleeSkill.high"],
        ["weapon.axe", "attr.MeleeSkill.high", "trait.determined"],
    ]}
    {ru = "Кузнечик", en = "Quickstep", factors = [
        ["background.hackflows_skirmisher", "trait.swift"],
        ["trait.tiny", "perk.footwork"],
        ["trait.swift", "trait.dexterous"],
    ]}
    {ru = "Скороход", en = "Longstride", factors = [
        ["trait.huge", "background.hunter"],
        ["trait.huge", "background.messenger"],
        ["trait.huge", "trait.athletic"],
    ]}
    {ru = "Лоб", en = "Hardhead", factors = [
        ["trait.iron_jaw", "trait.determined"],
        ["perk.steel_brow", "trait.determined"],
        ["type.melee", "trait.brute", "attr.MeleeSkill.high"],
    ]}
    {ru = "Барин", en = "Proudfoot", factors = [
        ["trait.cocky", "group.noble"],
    ]}
    {ru = "Волчий Глаз", en = "Wolfeye", factors = [
        ["trait.night_owl", "trait.bloodthirsty"],
        ["trait.night_owl", "background.killer_on_the_run"],
        ["trait.night_owl", "background.hackflows_town_watchman"],
    ]}
    {ru = "Бугай", en = "Bullneck", factors = [
        ["trait.strong", "trait.huge"],
        ["trait.strong", "perk.steel_brow"],
        ["background.hackflows_bodyguard", "trait.strong"],
    ]}
    {ru = "Хряк", en = "Boarhead", factors = [
        ["trait.brute", "trait.huge"],
        ["trait.brute", "perk.berserk"],
        ["background.wildman", "trait.brute"],
    ]}
    {ru = "Благодетель", en = "Godsend", factors = [
        ["trait.bloodthirsty", "background.sellsword"],
        ["trait.greedy", "background.sellsword"],
        ["trait.bloodthirsty", "cost.high"],
    ]}
    {ru = "Миротворец", en = "Makepeace", factors = [
        ["trait.bloodthirsty", "weapon.hammer"],
        ["trait.bloodthirsty", "trait.brute"],
        ["trait.brute", "attr.MeleeSkill.high"],
    ]}
    {ru = "Дружок", en = "Goodfriend", factors = [
        ["trait.teamplayer"],
        ["trait.disloyal"],
        ["trait.greedy"],
        ["trait.disloyal", "trait.greedy"],
        ["background.hackflows_con_artist"],
        ["background.hackflows_con_artist", "trait.disloyal"],
    ]}
    {ru = "Саранча", en = "the Locust", factors = [
        ["background.nomad", "trait.gluttonous"],
        ["background.nomad", "trait.greedy"],
        ["trait.gluttonous", "trait.greedy"],
    ]}
    {ru = "Факел", en = "the Torch", factors = [
        ["background.raider", "trait.bloodthirsty"],
        ["background.raider"],
        ["trait.bloodthirsty", "trait.irrational"],
    ]}
    {ru = "Клеймо", en = "the Brand", factors = [
        ["background.slave"],
        ["background.killer_on_the_run"],
        ["background.thief"],
    ]}
    {ru = "Ошейник", en = "the Collar", factors = [
        ["background.slave", "trait.brute"],
        ["background.houndmaster"],
        ["background.manhunter"],
    ]}
    {ru = "Аминь", en = "Amen", factors = [
        ["background.paladin"],
        ["background.monk", "perk.coup_de_grace"],
        ["background.flagellant"],
        ["background.witchhunter"],
    ]}
    {ru = "Потрошитель", en = "the Ripper", factors = [
        ["background.anatomist"],
        ["background.butcher", "trait.bloodthirsty"],
        ["weapon.cleaver", "trait.bloodthirsty"],
        ["background.hackflows_surgeon", "trait.bloodthirsty"],
        ["background.graverobber"],
    ]}
    {ru = "Книжный Червь", en = "Bookworm", factors = [
        ["background.historian"],
        ["background.monk", "trait.bright"],
        ["trait.bright", "attr.MeleeSkill.low", "type.melee"],
    ]}
    {ru = "Аркан", en = "the Lasso", factors = [
        ["background.manhunter"],
        ["background.nomad"],
        ["background.hackflows_bounty_hunter"],
    ]}
    {ru = "Подкидыш", en = "the Foundling", factors = [
        ["background.bastard"],
        ["background.refugee"],
    ]}
    {ru = "Каплун", en = "the Capon", factors = [
        ["background.eunuch"],
        ["trait.fat", "attr.Bravery.low"],
    ]}
    {ru = "Стремя", en = "the Stirrup", factors = [
        ["background.squire"],
        ["background.servant", "trait.loyal"],
    ]}
    {ru = "Отвес", en = "the Plumb Line", factors = [
        ["background.mason"],
        ["background.mason", "attr.MeleeDefense.high"],
        ["background.hackflows_carpenter"],
    ]}
    {ru = "Полцены", en = "Half-Price", factors = [
        ["cost.low", "group.combat"],
        ["cost.low", "attr.MeleeSkill.low", "type.melee"],
    ]}
    {ru = "Клятва", en = "the Oath", factors = [
        ["background.oathbreaker"],
        ["background.deserter"],
        ["trait.disloyal", "trait.superstitious"],
    ]}
    {ru = "Костяшки", en = "the Knucklebones", factors = [
        ["background.shaman"],
        ["background.gambler"],
        ["background.brawler"],
    ]}
    {ru = "Учитель", en = "the Teacher", factors = [
        ["background.swordmaster"],
        ["background.historian"],
        ["background.retired_soldier"],
    ]}
    {ru = "Тетива", en = "the Bowstring", factors = [
        ["background.bowyer"],
        ["background.hackflows_fletcher"],
        ["weapon.bow", "attr.RangedSkill.high"],
    ]}
    {ru = "Шампур", en = "the Skewer", factors = [
        ["background.hackflows_lancer"],
        ["weapon.spear", "attr.MeleeSkill.high"],
        ["background.hackflows_cook", "weapon.spear"],
    ]}
    {ru = "Кипяток", en = "Hothead", factors = [
        ["background.hackflows_berserker"],
        ["trait.impatient", "trait.brute"],
        ["background.hackflows_cook", "trait.impatient"],
    ]}
    {ru = "Ищейка", en = "the Bloodhound", factors = [
        ["background.hackflows_bounty_hunter"],
        ["trait.determined", "perk.pathfinder"],
        ["background.houndmaster", "perk.pathfinder"],
    ]}
    {ru = "Кубок", en = "the Cup", factors = [
        ["background.hackflows_champion"],
        ["background.gladiator"],
        ["trait.drunkard", "trait.cocky"],
    ]}
    {ru = "Заступник", en = "the Protector", factors = [
        ["background.hackflows_folk_hero"],
        ["perk.taunt", "trait.brave"],
        ["background.hackflows_bodyguard"],
    ]}
    {ru = "Сто Шагов", en = "Hundred Paces", factors = [
        ["background.hackflows_master_archer"],
        ["attr.RangedSkill.high", "trait.eagle_eyes", "type.ranged"],
    ]}
    {ru = "Ворот", en = "the Windlass", factors = [
        ["background.hackflows_arbalester"],
        ["background.hackflows_atilliator"],
        ["weapon.crossbow"],
    ]}
    {ru = "Конёк", en = "the Ridge", factors = [
        ["background.hackflows_roofer"],
        ["trait.sure_footing"],
    ]}
    {ru = "Подворотня", en = "the Back Alley", factors = [
        ["background.hackflows_myrmidon"],
        ["background.thief"],
        ["perk.backstabber"],
        ["background.brawler", "perk.backstabber"],
    ]}
    {ru = "Крапива", en = "the Nettle", factors = [
        ["background.hackflows_gardener"],
        ["background.hackflows_herbalist"],
        ["background.hackflows_dissenter"],
    ]}
    {ru = "Тиски", en = "the Vise", factors = [
        ["background.hackflows_torturer"],
        ["perk.crippling_strikes", "trait.bloodthirsty"],
        ["background.hackflows_blacksmith", "trait.strong"],
    ]}
    {ru = "Мозоль", en = "the Callus", factors = [
        ["background.daytaler"],
        ["background.farmhand"],
        ["background.lumberjack"],
        ["perk.taunt", "group.lowborn"],
    ]}
    {ru = "Верблюд", en = "the Camel", factors = [
        ["background.caravan_hand"],
        ["trait.strong", "attr.Stamina.high"],
    ]}
    {ru = "Рожок", en = "the Horn", factors = [
        ["weapon.musical"],
        ["background.shepherd"],
        ["background.necro", "weapon.musical"],
    ]}
    {ru = "Гостинец", en = "the Parting Gift", factors = [
        ["weapon.throwing"],
        ["weapon.sling"],
        ["background.peddler", "weapon.throwing"],
    ]}
    {ru = "Дубина", en = "the Club", factors = [
        ["weapon.mace", "trait.strong"],
        ["trait.dumb", "trait.strong"],
        ["weapon.staff", "trait.strong"],
    ]}
    {ru = "Пугач", en = "the Noisemaker", factors = [
        ["weapon.firearm", "attr.RangedSkill.low"],
        ["trait.cocky", "attr.Bravery.low"],
    ]}
    {ru = "Обух", en = "the Blunt End", factors = [
        ["weapon.axe", "trait.dumb"],
        ["weapon.hammer", "trait.dumb"],
    ]}
    {ru = "Лом", en = "the Crowbar", factors = [
        ["weapon.mace", "trait.strong"],
        ["perk.hackflows.full_force"],
        ["background.miner", "trait.strong"],
    ]}
    {ru = "Кадило", en = "the Censer", factors = [
        ["background.monk", "weapon.flail"],
        ["background.flagellant", "weapon.flail"],
        ["background.cultist", "weapon.flail"],
    ]}
    {ru = "Просека", en = "the Clearing", factors = [
        ["weapon.axe", "perk.killing_frenzy"],
    ]}
    {ru = "Столб", en = "the Post", factors = [
        ["perk.indomitable"],
        ["attr.MeleeDefense.high", "attr.Hitpoints.high", "type.melee"],
        ["trait.dumb", "attr.Initiative.low"],
    ]}
    {ru = "Жернов", en = "the Millstone", factors = [
        ["perk.relentless"],
        ["background.miller", "trait.determined"],
    ]}
    {ru = "Истукан", en = "the Stone Idol", factors = [
        ["perk.fortified_mind"],
        ["attr.Bravery.high", "trait.determined"],
        ["trait.dumb", "trait.fearless"],
    ]}
    {ru = "Веретено", en = "the Spindle", factors = [
        ["perk.dodge"],
        ["trait.swift", "attr.Initiative.high"],
        ["background.tailor", "trait.swift"],
    ]}
    {ru = "Сам на Сам", en = "One-on-One", factors = [
        ["perk.duelist"],
        ["perk.lone_wolf", "attr.MeleeSkill.high", "type.melee"],
        ["background.gladiator", "attr.MeleeSkill.high"],
    ]}
    {ru = "Красная Тряпка", en = "the Red Rag", factors = [
        ["perk.taunt"],
        ["perk.fearsome", "trait.cocky"],
    ]}
    {ru = "Тень", en = "the Shade", factors = [
        ["background.assassin"],
        ["trait.loyal", "perk.footwork"],
    ]}
    {ru = "Манок", en = "the Bird Call", factors = [
        ["perk.taunt"],
        ["background.hunter"],
        ["background.hackflows_falconer"],
    ]}
    {ru = "Скорлупа", en = "the Eggshell", factors = [
        ["perk.battle_forged", "attr.Hitpoints.low"],
        ["perk.battle_forged", "trait.craven"],
    ]}
    {ru = "Таран", en = "the Battering Ram", factors = [
        ["perk.berserk", "trait.huge"],
        ["weapon.hammer", "trait.brute"],
    ]}
    {ru = "Зарубка", en = "the Tally", factors = [
        ["perk.head_hunter", "trait.bloodthirsty"],
        ["background.hunter", "trait.bloodthirsty"],
        ["background.lumberjack", "trait.bloodthirsty"],
    ]}
    {ru = "Заговорённый", en = "the Charmed", factors = [
        ["trait.lucky", "attr.RangedDefense.high"],
        ["trait.superstitious", "trait.lucky"],
    ]}
    {ru = "Молоко", en = "the Barn Door", factors = [
        ["type.ranged", "attr.RangedSkill.low"],
    ]}
    {ru = "Сундук", en = "the Coffer", factors = [
        ["trait.fat", "cost.high"],
    ]}
    {ru = "Осёл", en = "the Donkey", factors = [
        ["trait.determined", "trait.dumb"],
        ["perk.brawny", "perk.bags_and_belts"],
    ]}
    {ru = "Баран", en = "the Ram", factors = [
        ["trait.dumb", "trait.brute"],
        ["perk.steel_brow", "trait.dumb"],
        ["background.shepherd", "trait.dumb"],
    ]}
    {ru = "Паук", en = "the Spider", factors = [
        ["background.tailor"],
        ["perk.anticipation", "weapon.crossbow"],
    ]}
    {ru = "Блоха", en = "the Flea", factors = [
        ["trait.tiny", "perk.dodge"],
        ["trait.tiny", "perk.footwork"],
    ]}
    {ru = "Белка", en = "the Squirrel", factors = [
        ["perk.quick_hands", "trait.swift"],
        ["perk.bags_and_belts", "trait.greedy"],
    ]}
    {ru = "Улитка", en = "the Snail", factors = [
        ["attr.Initiative.low", "perk.battle_forged"],
        ["attr.Initiative.low", "attr.MeleeDefense.high", "type.melee"],
        ["trait.hesitant", "perk.battle_forged"],
    ]}
    {ru = "Оборотень", en = "the Turnskin", factors = [
        ["trait.legend_double_tongued"],
        ["trait.night_owl", "trait.irrational"],
        ["background.hackflows_con_artist", "trait.night_owl"],
    ]}
    {ru = "Горбушка", en = "the Crust", factors = [
        ["trait.tough", "group.pauper"],
        ["background.beggar", "trait.fat"],
    ]}
    {ru = "Ложка", en = "the Spoon", factors = [
        ["trait.gluttonous"],
        ["trait.gluttonous", "attr.Initiative.high"],
        ["trait.fat", "attr.Initiative.high"],
    ]}
    {ru = "Пряник", en = "the Gingerbread", factors = [
        ["perk.rally_the_troops", "trait.optimist"],
        ["background.hackflows_cook"],
        ["trait.fat", "trait.optimist"],
    ]}
    {ru = "Грызло", en = "the Bit", factors = [
        ["trait.impatient", "attr.Initiative.high"],
        ["trait.impatient", "perk.adrenaline"],
    ]}
    {ru = "Должник", en = "the Debtor", factors = [
        ["trait.deathwish"],
        ["background.gambler"],
    ]}
    {ru = "Заика", en = "the Stutterer", factors = [
        ["injury.traumatized"],
        ["trait.insecure", "attr.Bravery.low"],
    ]}
    {ru = "Шептун", en = "the Whisperer", factors = [
        ["trait.superstitious"],
        ["background.hackflows_herbalist", "trait.superstitious"],
        ["trait.paranoid", "trait.superstitious"],
    ]}
    {ru = "Кликуша", en = "the Wailer", factors = [
        ["trait.superstitious", "trait.pessimist"],
        ["background.cultist", "trait.irrational"],
    ]}
    // the One — Neo, «Матрица» (1999)
    {ru = "Единственный", en = "the One", setting = false, factors = [
        ["trait.chosen"],
        ["trait.chosen", "perk.gifted"],
    ]}
    {ru = "Крестник", en = "Godson", factors = [
        ["trait.chosen"],
        ["trait.lucky"],
        ["background.bastard"],
    ]}
    {ru = "Молодец", en = "Goodlad", factors = [
        ["background.hackflows_folk_hero"],
        ["trait.chosen"],
        ["type.melee", "attr.Bravery.high", "attr.MeleeSkill.high"],
    ]}
    {ru = "Звезда", en = "the Star", factors = [
        ["trait.chosen"],
        ["trait.chosen", "trait.lucky"],
        ["trait.cocky", "trait.lucky"],
    ]}
];
