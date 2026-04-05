if (!("Rosetta" in getroottable())) return;

local rosetta = {
    mod = {id = "mod_nicknames", version = "0.1"}
    author = "suor"
    lang = "ru"
}
local pairs = [
    // Trait nicknames
    {
        en = "Bonebreaker"
        ru = "Костелом"
    }
    {
        en = "Strongarm"
        ru = "Крепыш"
    }
    {
        en = "Irongrip"
        ru = "Железная хватка"
    }
    {
        en = "Lionheart"
        ru = "Лев"
    }
    {
        en = "the Valiant"
        ru = "Храбрец"
    }
    {
        en = "Stoutheart"
        ru = "Смелый"
    }
    {
        en = "Cold Feet"
        ru = "Мёрзнущие ноги"
    }
    {
        en = "Shaky Knees"
        ru = "Дрожащие ноги"
    }
    {
        en = "the Reluctant"
        ru = "Нежелающий"
    }
    {
        en = "Barrel"
        ru = "Бочка"
    }
    {
        en = "Lardball"
        ru = "Жирдяй"
    }
    {
        en = "the Wide"
        ru = "Толстяк"
    }
    {
        en = "Bigfoot"
        ru = "Большеног"
    }
    {
        en = "the Colossus"
        ru = "Колосс"
    }
    {
        en = "Thunderstep"
        ru = "Грохот ног"
    }
    {
        en = "Halfpint"
        ru = "Малютка"
    }
    {
        en = "the Runt"
        ru = "Коротышка"
    }
    {
        en = "Thumbling"
        ru = "Кулак"
    }
    {
        en = "Numbskull"
        ru = "Балда"
    }
    {
        en = "Simpleton"
        ru = "Простак"
    }
    {
        en = "the Clueless"
        ru = "Невежда"
    }
    {
        en = "Sharpwit"
        ru = "Ретивый"
    }
    {
        en = "Brainiac"
        ru = "Мозговед"
    }
    {
        en = "the Thinker"
        ru = "Мыслитель"
    }
    {
        en = "Bloodlust"
        ru = "Жажда крови"
    }
    {
        en = "the Savage"
        ru = "Дикарь"
    }
    {
        en = "Gore"
        ru = "Кровавый"
    }
    {
        en = "Four-Leaf"
        ru = "Четырёхлистник"
    }
    {
        en = "Lucky Dog"
        ru = "Везучий"
    }
    {
        en = "Lady's Favor"
        ru = "Любимец судьбы"
    }
    {
        en = "Boozy"
        ru = "Пьянчик"
    }
    {
        en = "Barrel Bottom"
        ru = "Бочка с дном"
    }
    {
        en = "the Sloshed"
        ru = "Подвыпивший"
    }
    {
        en = "Granite Face"
        ru = "Гранитное лицо"
    }
    {
        en = "Hard Chin"
        ru = "Твёрдый подбородок"
    }
    {
        en = "Unbreakable"
        ru = "Неломаемый"
    }
    {
        en = "Hawkeye"
        ru = "Соколиный глаз"
    }
    {
        en = "the Spotter"
        ru = "Видящий"
    }
    {
        en = "Farsight"
        ru = "Дальневидец"
    }
    {
        en = "Lightning"
        ru = "Молния"
    }
    {
        en = "the Wind"
        ru = "Ветер"
    }
    {
        en = "Quickstep"
        ru = "Быстроног"
    }
    {
        en = "Cockroach"
        ru = "Таракан"
    }
    {
        en = "the Unkillable"
        ru = "Неуничтожимый"
    }
    {
        en = "Last Man"
        ru = "Последний мужик"
    }
    {
        en = "the Mole"
        ru = "Крот"
    }
    {
        en = "Dusk Fumbler"
        ru = "Суммеречный простак"
    }
    {
        en = "Squinter"
        ru = "Щурящийся"
    }
    {
        en = "Mole Eyes"
        ru = "Кротовы глаза"
    }
    {
        en = "Stumbles"
        ru = "Спотыкающийся"
    }
    {
        en = "the Hobbler"
        ru = "Хромающий"
    }
    {
        en = "Wheezy"
        ru = "Хрипящий"
    }
    {
        en = "the Puffer"
        ru = "Одышечный"
    }
    {
        en = "Bottomless Pit"
        ru = "Чёрная дыра"
    }
    {
        en = "Gobbler"
        ru = "Обжора"
    }
    {
        en = "the Hungry"
        ru = "Голодный"
    }
    {
        en = "Goldfingers"
        ru = "Жадный"
    }
    {
        en = "Penny Pincher"
        ru = "Скупец"
    }
    {
        en = "the Miser"
        ru = "Скупой"
    }
    {
        en = "Tinfoil"
        ru = "Фольга"
    }
    {
        en = "Eyes Everywhere"
        ru = "Всевидящий"
    }
    {
        en = "Gloom"
        ru = "Мрачный"
    }
    {
        en = "Raincloud"
        ru = "Туча"
    }
    {
        en = "the Downer"
        ru = "Пессимист"
    }
    {
        en = "Sunshine"
        ru = "Солнышко"
    }
    {
        en = "Smiley"
        ru = "Улыбакин"
    }
    {
        en = "the Cheerful"
        ru = "Весёлый"
    }
    {
        en = "Hotshot"
        ru = "Горячка"
    }
    {
        en = "Big Mouth"
        ru = "Большой рот"
    }
    {
        en = "the Showoff"
        ru = "Хвастун"
    }
    {
        en = "Turncoat"
        ru = "Предатель"
    }
    {
        en = "Shifty"
        ru = "Хитрец"
    }
    {
        en = "the Reckless"
        ru = "Безрассудный"
    }
    {
        en = "No Tomorrow"
        ru = "Без завтра"
    }
    {
        en = "Death's Friend"
        ru = "Смерти друг"
    }
    {
        en = "Nerves of Steel"
        ru = "Стальные нервы"
    }
    {
        en = "Stone Cold"
        ru = "Холод"
    }
    {
        en = "Iron Will"
        ru = "Железная воля"
    }
    {
        en = "the Relentless"
        ru = "Неумолимый"
    }
    {
        en = "the Stubborn"
        ru = "Упрямец"
    }
    {
        en = "Thick Skin"
        ru = "Толстая кожа"
    }
    {
        en = "Ironhide"
        ru = "Железная шкура"
    }
    {
        en = "Knuckles"
        ru = "Кулак"
    }
    {
        en = "Meatfist"
        ru = "Мясной кулак"
    }
    {
        en = "Twitchy"
        ru = "Дёргающийся"
    }
    {
        en = "Antsy"
        ru = "Беспокойный"
    }
    {
        en = "the Restless"
        ru = "Неспокойный"
    }
    {
        en = "Glass Bones"
        ru = "Стеклянные кости"
    }
    {
        en = "Paper Skin"
        ru = "Бумажная кожа"
    }
    {
        en = "Rabbit Foot"
        ru = "Кроличья лапка"
    }
    {
        en = "Hex Dodger"
        ru = "Избегающий проклятий"
    }
    {
        en = "Red Fountain"
        ru = "Красный фонтан"
    }
    {
        en = "Leaky"
        ru = "Текущий"
    }
    {
        en = "Gravebane"
        ru = "Надгробный бич"
    }
    {
        en = "the Exorcist"
        ru = "Экзорцист"
    }
    {
        en = "Tusk Breaker"
        ru = "Бивеломан"
    }
    {
        en = "Greenskin Bane"
        ru = "Зелёный враг"
    }
    {
        en = "Monster Bane"
        ru = "Чудище враг"
    }
    {
        en = "Beast Slayer"
        ru = "Убийца зверей"
    }
    {
        en = "the Tireless"
        ru = "Неустанный"
    }
    {
        en = "Never Winded"
        ru = "Не запыхавшийся"
    }
    {
        en = "Bone Shaker"
        ru = "Трясущий кости"
    }
    {
        en = "Ghost Pale"
        ru = "Бледный как призрак"
    }
    {
        en = "Fur Allergy"
        ru = "Аллергик на шерсть"
    }
    {
        en = "Beast Shy"
        ru = "Зверей боится"
    }
    {
        en = "Orc Shy"
        ru = "Орков боится"
    }
    {
        en = "Green Pale"
        ru = "Зелёный страх"
    }
    {
        en = "True Heart"
        ru = "Истинное сердце"
    }
    {
        en = "the Faithful"
        ru = "Верный"
    }
    {
        en = "Sly"
        ru = "Хитрец"
    }
    {
        en = "the Sneaky"
        ru = "Скрытый"
    }
    {
        en = "Yellow Belly"
        ru = "Трус"
    }
    {
        en = "the Cringe"
        ru = "Жалкий"
    }
    {
        en = "Slowstart"
        ru = "Медленный старт"
    }
    {
        en = "the Hesitant"
        ru = "Нерешительный"
    }
    {
        en = "Shaky"
        ru = "Трясущийся"
    }
    {
        en = "the Doubtful"
        ru = "Сомневающийся"
    }
    {
        en = "Wildcard"
        ru = "Дикий козырь"
    }
    {
        en = "Loose Cannon"
        ru = "Сумасшедший"
    }
    {
        en = "Pale Face"
        ru = "Бледное лицо"
    }
    {
        en = "the Meek"
        ru = "Кроткий"
    }
    {
        en = "Butterfingers"
        ru = "Руки-сливки"
    }
    {
        en = "Fumbles"
        ru = "Промахивается"
    }
    {
        en = "Quickdraw"
        ru = "Быстрая ничья"
    }
    {
        en = "the Agile"
        ru = "Ловкий"
    }
    {
        en = "Deft Hands"
        ru = "Искусные руки"
    }
    {
        en = "the Nimble"
        ru = "Проворный"
    }
    {
        en = "Steady"
        ru = "Устойчивый"
    }
    {
        en = "Surefoot"
        ru = "Твёрдый шаг"
    }
    {
        en = "the Night Owl"
        ru = "Ночной филин"
    }
    {
        en = "Moonwatcher"
        ru = "Луноприятель"
    }
    {
        en = "the Team Player"
        ru = "Командник"
    }
    {
        en = "Brother-in-Arms"
        ru = "Боевой товарищ"
    }
    {
        en = "the Athlete"
        ru = "Спортсмен"
    }
    {
        en = "Sprinter"
        ru = "Спринтер"
    }
    {
        en = "the Aggressor"
        ru = "Агрессор"
    }
    {
        en = "Hotblood"
        ru = "Горячая кровь"
    }
    {
        en = "Shadowfear"
        ru = "Тени страх"
    }
    {
        en = "the Nyctophobe"
        ru = "Боящийся темноты"
    }
    {
        en = "Featherweight"
        ru = "Пёрышко"
    }
    {
        en = "Light Step"
        ru = "Лёгкий шаг"
    }
    {
        en = "Two-Face"
        ru = "Двулицый"
    }
    {
        en = "Forked Tongue"
        ru = "Раздвоенный язык"
    }

    // Talent nicknames
    {
        en = "Tank"
        ru = "Танк"
    }
    {
        en = "Thick Hide"
        ru = "Толстая шкура"
    }
    {
        en = "Meatbox"
        ru = "Мясная коробка"
    }
    {
        en = "the Machine"
        ru = "Машина"
    }
    {
        en = "Never Tired"
        ru = "Никогда не устанет"
    }
    {
        en = "Stamina Freak"
        ru = "Выносливый сумасшедший"
    }
    {
        en = "Swordguy"
        ru = "Мечник"
    }
    {
        en = "Blade Master"
        ru = "Мастер клинка"
    }
    {
        en = "Choppy"
        ru = "Рубит"
    }
    {
        en = "Quick Feet"
        ru = "Быстрые ноги"
    }
    {
        en = "Twitchy"
        ru = "Дёргающийся"
    }
    {
        en = "Fastdraw"
        ru = "Быстрая ничья"
    }
    {
        en = "Arrow Wizard"
        ru = "Волшебник стрел"
    }
    {
        en = "Shots On Point"
        ru = "Попадает в точку"
    }
    {
        en = "Bullseye"
        ru = "Яблочко"
    }
    {
        en = "Fearless"
        ru = "Бесстрашный"
    }
    {
        en = "No Doubts"
        ru = "Без сомнений"
    }
    {
        en = "Guts"
        ru = "Смелость"
    }
    {
        en = "Slippy"
        ru = "Скользкий"
    }
    {
        en = "Evasive"
        ru = "Уклончивый"
    }
    {
        en = "Never Touched"
        ru = "Никогда не трогают"
    }
    {
        en = "Dodgy"
        ru = "Уклончивый"
    }
    {
        en = "Untouchable Ranged"
        ru = "Неуязвим издалека"
    }
    {
        en = "Bulletproof"
        ru = "Пулестойкий"
    }

    // Combo nicknames - Trait + trait
    {
        en = "Bulldozer"
        ru = "Бульдозер"
    }
    {
        en = "the Hammer"
        ru = "Молот"
    }
    {
        en = "Unrelenting"
        ru = "Неумолимый"
    }
    {
        en = "the Titan"
        ru = "Титан"
    }
    {
        en = "Goliath"
        ru = "Голиаф"
    }
    {
        en = "the Oaf"
        ru = "Простак"
    }
    {
        en = "Dumb Muscle"
        ru = "Дура мышца"
    }
    {
        en = "Gentle Giant"
        ru = "Добрый гигант"
    }
    {
        en = "Glory Chaser"
        ru = "Охотник за славой"
    }
    {
        en = "Daredevil"
        ru = "Смельчак"
    }
    {
        en = "the Gnat"
        ru = "Комар"
    }
    {
        en = "Little Lightning"
        ru = "Маленькая молния"
    }
    {
        en = "Ankle Biter"
        ru = "Кусающий в ноги"
    }
    {
        en = "the Boulder"
        ru = "Валун"
    }
    {
        en = "Unmovable"
        ru = "Неподвижный"
    }
    {
        en = "Meatshield"
        ru = "Мясной щит"
    }
    {
        en = "Born Survivor"
        ru = "Прирождённый выживший"
    }
    {
        en = "Slippery"
        ru = "Скользкий"
    }
    {
        en = "the Dodger"
        ru = "Уклоняющийся"
    }
    {
        en = "the Tactician"
        ru = "Тактик"
    }
    {
        en = "All-Seeing"
        ru = "Всевидящий"
    }
    {
        en = "Mastermind"
        ru = "Мастермайнд"
    }
    {
        en = "Dutch Courage"
        ru = "Голландская смелость"
    }
    {
        en = "Liquid Bravery"
        ru = "Жидкая смелость"
    }
    {
        en = "Booze Berserker"
        ru = "Пьяный берсеркер"
    }
    {
        en = "the Maniac"
        ru = "Маньяк"
    }
    {
        en = "Gore Fiend"
        ru = "Кровожадный"
    }
    {
        en = "Maddog"
        ru = "Бешеный пёс"
    }
    {
        en = "the Mercenary"
        ru = "Наёмник"
    }
    {
        en = "Sold Soul"
        ru = "Проданная душа"
    }
    {
        en = "Coin Chaser"
        ru = "Охотник за монетами"
    }
    {
        en = "Doomed"
        ru = "Обречённый"
    }
    {
        en = "Walking Misery"
        ru = "Ходячее несчастье"
    }
    {
        en = "the Grim"
        ru = "Мрачный"
    }
    {
        en = "the Ogre"
        ru = "Людоед"
    }
    {
        en = "Man Eater"
        ru = "Людоед"
    }
    {
        en = "the Horror"
        ru = "Ужас"
    }
    {
        en = "the Imp"
        ru = "Чертёнок"
    }
    {
        en = "Little Professor"
        ru = "Маленький профессор"
    }
    {
        en = "Small but Sharp"
        ru = "Мал да удал"
    }
    {
        en = "the Keg"
        ru = "Бочка"
    }
    {
        en = "Tavern King"
        ru = "Король трактира"
    }
    {
        en = "Beer Belly"
        ru = "Пивной живот"
    }
    {
        en = "Cheerful"
        ru = "Весёлый"
    }
    {
        en = "Always Grins"
        ru = "Всегда улыбается"
    }
    {
        en = "Smileface"
        ru = "Улыбакин"
    }
    {
        en = "the Sentinel"
        ru = "Стражник"
    }
    {
        en = "Ever Watchful"
        ru = "Всегда бдительный"
    }
    {
        en = "the Fortress"
        ru = "Крепость"
    }
    {
        en = "Unbreakable Wall"
        ru = "Неломаемая стена"
    }
    {
        en = "Steelborn"
        ru = "Рождённый сталью"
    }
    {
        en = "the Charger"
        ru = "Атакующий"
    }
    {
        en = "First In"
        ru = "Первый в бой"
    }
    {
        en = "Vanguard"
        ru = "Авангард"
    }
    {
        en = "the Troll"
        ru = "Тролль"
    }
    {
        en = "Simple Giant"
        ru = "Простой гигант"
    }
    {
        en = "Big Dumb"
        ru = "Большой дурак"
    }

    // Combo nicknames - Background + trait
    {
        en = "the True Knight"
        ru = "Истинный рыцарь"
    }
    {
        en = "Gallant"
        ru = "Доблестный"
    }
    {
        en = "the Chivalrous"
        ru = "Рыцарственный"
    }
    {
        en = "the Phantom"
        ru = "Фантом"
    }
    {
        en = "Ghost Fingers"
        ru = "Призрачные пальцы"
    }
    {
        en = "the Crusader"
        ru = "Крестоносец"
    }
    {
        en = "Holy Fury"
        ru = "Святой гнев"
    }
    {
        en = "Righteous Fist"
        ru = "Праведный кулак"
    }
    {
        en = "the Slaughterhouse"
        ru = "Бойня"
    }
    {
        en = "Blood and Guts"
        ru = "Кровь и кишки"
    }
    {
        en = "Meatgrinder"
        ru = "Мясорубка"
    }
    {
        en = "the Sheepdog"
        ru = "Овчарка"
    }
    {
        en = "Wolf Among Sheep"
        ru = "Волк среди овец"
    }
    {
        en = "Rags to Riches"
        ru = "От тряпья к богатству"
    }
    {
        en = "Fortune's Fool"
        ru = "Шут судьбы"
    }
    {
        en = "the Yeti"
        ru = "Йети"
    }
    {
        en = "Forest Giant"
        ru = "Лесной гигант"
    }
    {
        en = "Sasquatch"
        ru = "Снежный человек"
    }
    {
        en = "the Martyr"
        ru = "Мученик"
    }
    {
        en = "the Fanatic"
        ru = "Фанатик"
    }
    {
        en = "Self-Sacrifice"
        ru = "Самопожертвование"
    }
    {
        en = "Silver Tongue"
        ru = "Серебряный язык"
    }
    {
        en = "the Poet"
        ru = "Поэт"
    }
    {
        en = "Wordsmith"
        ru = "Словес мастер"
    }
    {
        en = "Dirt Eater"
        ru = "Едок земли"
    }
    {
        en = "the Undertaker"
        ru = "Могильщик"
    }
    {
        en = "the Jackpot"
        ru = "Джекпот"
    }
    {
        en = "Always Wins"
        ru = "Всегда побеждает"
    }
    {
        en = "House Buster"
        ru = "Разоритель домов"
    }
    {
        en = "the Woodcutter"
        ru = "Лесоруб"
    }
    {
        en = "Treesplitter"
        ru = "Раскалыватель деревьев"
    }
    {
        en = "Oak Feller"
        ru = "Валящий дубы"
    }
    {
        en = "Rockjaw"
        ru = "Каменная челюсть"
    }
    {
        en = "the Tunneler"
        ru = "Копатель"
    }
    {
        en = "Iron Ore"
        ru = "Железная руда"
    }
    {
        en = "the Big Catch"
        ru = "Большой улов"
    }
    {
        en = "Golden Net"
        ru = "Золотая сеть"
    }
    {
        en = "the Rat"
        ru = "Крыса"
    }
    {
        en = "Sewer Prince"
        ru = "Князь канализации"
    }
    {
        en = "Gold Before Glory"
        ru = "Золото прежде славы"
    }
    {
        en = "the Price Tag"
        ru = "Ценовой ярлык"
    }
    {
        en = "the Hunted"
        ru = "Преследуемый"
    }
    {
        en = "Looking Over Shoulder"
        ru = "Оглядывается через плечо"
    }
    {
        en = "the Escaped"
        ru = "Беглец"
    }
    {
        en = "Fleet Foot"
        ru = "Быстрая ступня"
    }

    // Combo nicknames - Weapon + attribute
    {
        en = "the Sharpshooter"
        ru = "Снайпер"
    }
    {
        en = "Eagle's Arrow"
        ru = "Орлиная стрела"
    }
    {
        en = "the Sniper"
        ru = "Снайпер"
    }
    {
        en = "Bolt of Death"
        ru = "Болт смерти"
    }
    {
        en = "One Shot"
        ru = "Один выстрел"
    }
    {
        en = "Surecut"
        ru = "Верный удар"
    }
    {
        en = "Deathstroke"
        ru = "Смертельный удар"
    }
    {
        en = "the Duelist"
        ru = "Дуэлист"
    }
    {
        en = "Skull Splitter"
        ru = "Раскалыватель черепов"
    }
    {
        en = "Axe Storm"
        ru = "Буря топоров"
    }
    {
        en = "First Blood"
        ru = "Первая кровь"
    }
    {
        en = "the Viper"
        ru = "Гадюка"
    }
    {
        en = "Quick Jab"
        ru = "Быстрый укол"
    }
    {
        en = "Earthshaker"
        ru = "Тряс земли"
    }
    {
        en = "the Crusher"
        ru = "Дробитель"
    }
    {
        en = "Plate Buster"
        ru = "Разбиватель пластин"
    }
    {
        en = "Little Sting"
        ru = "Маленький укол"
    }
    {
        en = "Flea Bite"
        ru = "Укус блохи"
    }
    {
        en = "Pin Prick"
        ru = "Укол булавкой"
    }
    {
        en = "the Reaper"
        ru = "Жнец"
    }
    {
        en = "Long Arm of Death"
        ru = "Длинная рука смерти"
    }
    {
        en = "Whirlwind of Pain"
        ru = "Вихрь боли"
    }
    {
        en = "Chain Fury"
        ru = "Цепной гнев"
    }
    {
        en = "Skull Denter"
        ru = "Продавливатель черепа"
    }
    {
        en = "the Concussor"
        ru = "Сотрясатель"
    }

    // Combo nicknames - Talent + background
    {
        en = "Born Mercenary"
        ru = "Прирождённый наёмник"
    }
    {
        en = "Natural Killer"
        ru = "Прирождённый убийца"
    }
    {
        en = "the Deadeye"
        ru = "Гибкий глаз"
    }
    {
        en = "Hawk"
        ru = "Ястреб"
    }
    {
        en = "Nature's Archer"
        ru = "Лучник природы"
    }
    {
        en = "Doom Blade"
        ru = "Лезвие судьбы"
    }
    {
        en = "the Annihilator"
        ru = "Уничтожитель"
    }
    {
        en = "Wrecking Ball"
        ru = "Разрушительный шар"
    }
    {
        en = "Telescopic"
        ru = "Телескопический"
    }
    {
        en = "the Sharpshooter"
        ru = "Снайпер"
    }
    {
        en = "Future Knight"
        ru = "Будущий рыцарь"
    }
    {
        en = "the Promising"
        ru = "Многообещающий"
    }
    {
        en = "the Abbot"
        ru = "Аббат"
    }
    {
        en = "Voice of God"
        ru = "Голос Божий"
    }

    // Attribute nicknames
    {
        en = "Squishy"
        ru = "Мягкий"
    }
    {
        en = "Paperman"
        ru = "Бумажный"
    }
    {
        en = "Choppy"
        ru = "Рубит"
    }
    {
        en = "Miss-a-lot"
        ru = "Частый мах"
    }
    {
        en = "Blind Archer"
        ru = "Слепой лучник"
    }
    {
        en = "Off-Target"
        ru = "Не в цель"
    }
    {
        en = "Dodgy"
        ru = "Уклончивый"
    }
    {
        en = "Untouchable"
        ru = "Неуязвим"
    }
    {
        en = "Ranged Dodger"
        ru = "Уклоняющийся от стрел"
    }
    {
        en = "Stray Proof"
        ru = "Устойчив к ошибкам"
    }
    {
        en = "Scaredy Cat"
        ru = "Трусишка"
    }
    {
        en = "Huffpuff"
        ru = "Пыхтящий"
    }
    {
        en = "Zippy"
        ru = "Молниеносный"
    }
    {
        en = "Speedster"
        ru = "Скоростной"
    }
    {
        en = "Slowpoke"
        ru = "Копуша"
    }
    {
        en = "Sluggish"
        ru = "Медлительный"
    }

    // Background nicknames
    {
        en = "Pitchfork"
        ru = "Вилы"
    }
    {
        en = "Mudfoot"
        ru = "Грязные ноги"
    }
    {
        en = "Hay Bale"
        ru = "Сенник"
    }
    {
        en = "Odd Jobs"
        ru = "Разные работы"
    }
    {
        en = "Dusty Hands"
        ru = "Пыльные руки"
    }
    {
        en = "the Drifter"
        ru = "Скиталец"
    }
    {
        en = "Blade for Hire"
        ru = "Меч в аренду"
    }
    {
        en = "Coin Soldier"
        ru = "Монетный солдат"
    }
    {
        en = "Gate Watch"
        ru = "Страж ворот"
    }
    {
        en = "Town Guard"
        ru = "Городская стража"
    }
    {
        en = "Yes Sir"
        ru = "Слушаюсь, сэр"
    }
    {
        en = "Boot Polisher"
        ru = "Полировщик сапог"
    }
    {
        en = "Stonefist"
        ru = "Каменный кулак"
    }
    {
        en = "Brickhand"
        ru = "Кирпичный кулак"
    }
    {
        en = "Flour Dust"
        ru = "Мучная пыль"
    }
    {
        en = "Grindstone"
        ru = "Жёрнов"
    }
    {
        en = "Night Arrow"
        ru = "Ночная стрела"
    }
    {
        en = "Snare Setter"
        ru = "Ловушколов"
    }
    {
        en = "Rat King"
        ru = "Король крыс"
    }
    {
        en = "Pied Piper"
        ru = "Крысолов"
    }
    {
        en = "Tinker"
        ru = "Лудильщик"
    }
    {
        en = "Cheap Wares"
        ru = "Дешёвый товар"
    }
    {
        en = "Bare Knuckles"
        ru = "Голые кулаки"
    }
    {
        en = "Bruiser"
        ru = "Бойцы"
    }
    {
        en = "Stringfinger"
        ru = "Стройный палец"
    }
    {
        en = "Shaft"
        ru = "Стержень"
    }
    {
        en = "Dispatch"
        ru = "Диспетчер"
    }
    {
        en = "Swift Foot"
        ru = "Быстрая ступня"
    }
    {
        en = "Needlefingers"
        ru = "Иголочные пальцы"
    }
    {
        en = "Patches"
        ru = "Заплатки"
    }
    {
        en = "Shield Bearer"
        ru = "Щитоносец"
    }
    {
        en = "the Hopeful"
        ru = "Надеющийся"
    }
    {
        en = "Dog Whisperer"
        ru = "Шептун собак"
    }
    {
        en = "Alpha"
        ru = "Альфа"
    }
    {
        en = "Roadworn"
        ru = "Дорожный"
    }
    {
        en = "Dustwalker"
        ru = "Ходок по пыли"
    }
    {
        en = "Shovel"
        ru = "Лопата"
    }
    {
        en = "Bone Picker"
        ru = "Костеносец"
    }
    {
        en = "No Name"
        ru = "Безымянный"
    }
    {
        en = "Half-Blood"
        ru = "Полукровка"
    }
    {
        en = "Tomb Raider"
        ru = "Грабитель гробниц"
    }
    {
        en = "the Ghoul"
        ru = "Гуль"
    }
    {
        en = "Blue Blood"
        ru = "Голубая кровь"
    }
    {
        en = "the Adventurer"
        ru = "Искатель приключений"
    }
    {
        en = "Fallen Grace"
        ru = "Падшая благодать"
    }
    {
        en = "Lost Crown"
        ru = "Потеряная корона"
    }
    {
        en = "Old Guard"
        ru = "Старая гвардия"
    }
    {
        en = "Rusty Blade"
        ru = "Ржавый клинок"
    }
    {
        en = "Dusty Boots"
        ru = "Пыльные сапоги"
    }
    {
        en = "Road Dog"
        ru = "Дорожный пёс"
    }
    {
        en = "Whip Mark"
        ru = "След кнута"
    }
    {
        en = "Scar Back"
        ru = "Рубец на спине"
    }
    {
        en = "Beastblood"
        ru = "Кровь зверя"
    }
    {
        en = "the Feral"
        ru = "Дикий"
    }
    {
        en = "Witch Finder"
        ru = "Охотник на ведьм"
    }
    {
        en = "Stake and Fire"
        ru = "Кол и огонь"
    }
    {
        en = "the Jouster"
        ru = "Турнирный боец"
    }
    {
        en = "Wandering Blade"
        ru = "Странствующий клинок"
    }
    {
        en = "Old Blade"
        ru = "Старый клинок"
    }
    {
        en = "Still Learning"
        ru = "Ещё учится"
    }
    {
        en = "Half-Trained"
        ru = "Полуобученный"
    }
    {
        en = "No Home"
        ru = "Бездомный"
    }
    {
        en = "the Displaced"
        ru = "Изгнанный"
    }

    // XBE backgrounds
    {
        en = "Hawkmaster"
        ru = "Мастер ястребов"
    }
    {
        en = "Bird Caller"
        ru = "Зовущий птиц"
    }
    {
        en = "Sky Eye"
        ru = "Небесный глаз"
    }
    {
        en = "Noose"
        ru = "Петля"
    }
    {
        en = "Gallows Hand"
        ru = "Палач"
    }
    {
        en = "Neck Stretcher"
        ru = "Растягиватель шеи"
    }
    {
        en = "Sea Dog"
        ru = "Морской пёс"
    }
    {
        en = "Plank Walker"
        ru = "Ходок по доскам"
    }
    {
        en = "Barnacle"
        ru = "Морской жёлудь"
    }
    {
        en = "Rager"
        ru = "Бешенец"
    }
    {
        en = "Foaming Mouth"
        ru = "Вспенивающийся рот"
    }
    {
        en = "Sawdust"
        ru = "Опилки"
    }
    {
        en = "Nailbiter"
        ru = "Кусающий гвозди"
    }
    {
        en = "Splinter"
        ru = "Занозы"
    }
    {
        en = "Tap Master"
        ru = "Мастер крана"
    }
    {
        en = "Ale Lord"
        ru = "Пивной лорд"
    }
    {
        en = "Last Call"
        ru = "Последний возглас"
    }
    {
        en = "Green Thumb"
        ru = "Зелёный палец"
    }
    {
        en = "Leaf Picker"
        ru = "Сборщик листьев"
    }
    {
        en = "Root Digger"
        ru = "Раскопыватель корней"
    }
    {
        en = "Smooth Talker"
        ru = "Сладкоречивый"
    }
    {
        en = "the Grifter"
        ru = "Мошенник"
    }
    {
        en = "Fast Talk"
        ru = "Быстрый разговор"
    }
    {
        en = "the Shield"
        ru = "Щит"
    }
    {
        en = "Iron Shadow"
        ru = "Железная тень"
    }
    {
        en = "Watchdog"
        ru = "Сторожевой пёс"
    }
    {
        en = "Headhunter"
        ru = "Охотник за головами"
    }
    {
        en = "the Tracker"
        ru = "Ловец"
    }
    {
        en = "Bounty"
        ru = "Награда"
    }
    {
        en = "Anvil Striker"
        ru = "Бьющий по наковальне"
    }
    {
        en = "Hammer"
        ru = "Молот"
    }
    {
        en = "Sparks"
        ru = "Искры"
    }
    {
        en = "Stewpot"
        ru = "Кастрюля"
    }
    {
        en = "Spice"
        ru = "Специи"
    }
    {
        en = "Hot Pot"
        ru = "Горячий горшок"
    }
    {
        en = "Stitcher"
        ru = "Шивец"
    }
    {
        en = "Bloodstained"
        ru = "Окровавленный"
    }
    {
        en = "the Wrack"
        ru = "Пытка"
    }
    {
        en = "Stretcher"
        ru = "Растягиватель"
    }
    {
        en = "Night Watch"
        ru = "Ночная стража"
    }
    {
        en = "Gate Guard"
        ru = "Страж ворот"
    }
    {
        en = "Bell Ringer"
        ru = "Звонарь"
    }
    {
        en = "Shingles"
        ru = "Гонт"
    }
    {
        en = "High Step"
        ru = "Высокий шаг"
    }
    {
        en = "Roofwalker"
        ru = "Ходок по крышам"
    }
    {
        en = "Sole Fixer"
        ru = "Чинитель подошв"
    }
    {
        en = "Bootmaker"
        ru = "Сапожник"
    }
    {
        en = "Heel"
        ru = "Каблук"
    }
    {
        en = "Tumbledown"
        ru = "Развалина"
    }
    {
        en = "Dustwalker"
        ru = "Ходок по пыли"
    }
    {
        en = "Nowhere Man"
        ru = "Человек ниоткуда"
    }
    {
        en = "Pointy Boy"
        ru = "Острый мальчик"
    }
    {
        en = "the Lancer"
        ru = "Копейщик"
    }
    {
        en = "Tilt"
        ru = "Поворот"
    }
    {
        en = "Sharp Eye"
        ru = "Острый взгляд"
    }
    {
        en = "Arrow"
        ru = "Стрела"
    }
    {
        en = "Deadshot"
        ru = "Мёртвый выстрел"
    }
    {
        en = "the Stranger"
        ru = "Незнакомец"
    }
    {
        en = "Outsider"
        ru = "Чужак"
    }
    {
        en = "Far Walker"
        ru = "Странник"
    }
    {
        en = "Ballista Boy"
        ru = "Баллистовец"
    }
    {
        en = "Heavy Bolt"
        ru = "Тяжёлый болт"
    }
    {
        en = "Crank"
        ru = "Рукоять"
    }
    {
        en = "Tree Hugger"
        ru = "Обнимающий деревья"
    }
    {
        en = "Moss Beard"
        ru = "Мшистая борода"
    }
    {
        en = "Bark Skin"
        ru = "Коровая кожа"
    }
    {
        en = "Arrow Maker"
        ru = "Делатель стрел"
    }
    {
        en = "Featherman"
        ru = "Пёрышник"
    }
    {
        en = "Quill"
        ru = "Перо"
    }
    {
        en = "Plant Man"
        ru = "Человек растений"
    }
    {
        en = "Weeder"
        ru = "Сорняки"
    }
    {
        en = "Picklock"
        ru = "Отмычка"
    }
    {
        en = "Lock Buster"
        ru = "Взломщик замков"
    }
    {
        en = "Key Master"
        ru = "Мастер ключей"
    }
    {
        en = "Arena Rat"
        ru = "Крыса арены"
    }
    {
        en = "Ant Soldier"
        ru = "Муравьиный боец"
    }
    {
        en = "Pit Fighter"
        ru = "Боец ямы"
    }
    {
        en = "Brush Dude"
        ru = "Кисточник"
    }
    {
        en = "Color Hands"
        ru = "Цветные руки"
    }
    {
        en = "Hit Run"
        ru = "Удар и бег"
    }
    {
        en = "Quick Jab"
        ru = "Быстрый укол"
    }
    {
        en = "Stinger"
        ru = "Жалящий"
    }
    {
        en = "Map Man"
        ru = "Человек карт"
    }
    {
        en = "Compass"
        ru = "Компас"
    }
    {
        en = "Pathfinder"
        ru = "Ищущий пути"
    }
    {
        en = "Rebel"
        ru = "Мятежник"
    }
    {
        en = "Free Mind"
        ru = "Свободный ум"
    }
    {
        en = "Rule Breaker"
        ru = "Нарушитель правил"
    }
    {
        en = "Rags"
        ru = "Тряпки"
    }
    {
        en = "Wrapped One"
        ru = "Завёрнутый"
    }
    {
        en = "Spotted"
        ru = "Пятнистый"
    }
    {
        en = "Gear Head"
        ru = "Голова механизма"
    }
    {
        en = "Tinkerer"
        ru = "Мастер на всё руки"
    }
    {
        en = "Gadget Boy"
        ru = "Мальчик-гаджет"
    }
];
::Rosetta.add(rosetta, pairs);
