if (!("Rosetta" in getroottable())) return;

local rosetta = {
    mod = {id = ::Nicknames.ID, version = ::Nicknames.Version}
    author = "hackflow"
    lang = "ru"
}
local pairs = [];
foreach (entry in ::Nicknames.Titles) {
    local names = "names" in entry ? entry.names : [{en = entry.en, ru = entry.ru}];
    foreach (name in names)
        pairs.push({en = name.en, ru = name.ru});
}

local OldTitles = [
    {ru = "Малыш", en = "Little"}
    {ru = "Длинный", en = "Lanky"}
    {ru = "Гора", en = "Mountain"}
    {ru = "Жердь", en = "Beanpole"}
    {ru = "Оглобля", en = "Shaft"}
    {ru = "Каланча", en = "Lamppost"}
    {ru = "Бочка", en = "Barrel"}
    {ru = "Пузо", en = "Belly"}
    {ru = "Квашня", en = "Dough-lump"}
    {ru = "Нос", en = "Nose"}
    {ru = "Носатый", en = "Nosy"}
    {ru = "Кривой", en = "Crooked"}
    {ru = "Косой", en = "Squinty"}
    {ru = "Косматый", en = "Shaggy"}
    {ru = "Чумазый", en = "Grimy"}
    {ru = "Бледный", en = "Pale"}
    {ru = "Меченый", en = "Marked"}
    {ru = "Муравей", en = "Ant"}
    {ru = "Болтун", en = "Chatterbox"}
    {ru = "Горлопан", en = "Loudmouth"}
    {ru = "Нытик", en = "Whiner"}
    {ru = "Брюзга", en = "Grumbler"}
    {ru = "Весельчак", en = "Jolly"}
    {ru = "Ворчун", en = "Grumpy"}
    {ru = "Туча", en = "Gloom"}
    {ru = "Задира", en = "Bully"}
    {ru = "Животное", en = "Animal"}
    {ru = "Буян", en = "Rowdy"}
    {ru = "Пьянчик", en = "Boozy"}
    {ru = "Забияка", en = "Troublemaker"}
    {ru = "Упрямец", en = "Stubborn"}
    {ru = "Кочерга", en = "Fire Poker"}
    {ru = "Хитрец", en = "Sly"}
    {ru = "Зануда", en = "Pedant"}
    {ru = "Пройдоха", en = "Schemer"}
    {ru = "Жмот", en = "Miser"}
    {ru = "Скупец", en = "Penny Pincher"}
    {ru = "Скряга", en = "Skinflint"}
    {ru = "Обжора", en = "Gobbler"}
    {ru = "Размазня", en = "Milksop"}
    {ru = "Тихоня", en = "Quiet One"}
    {ru = "Хамелеон", en = "Chameleon"}
    {ru = "Смельчак", en = "Daredevil"}
    {ru = "Трус", en = "Coward"}
    {ru = "Трусишка", en = "Scaredy Cat"}
    {ru = "Балбес", en = "Dunce"}
    {ru = "Дёрганый", en = "Twitchy"}
    {ru = "Тугодум", en = "Slow Thinker"}
    {ru = "Топтун", en = "Shuffler"}
    {ru = "Якорь", en = "Anchor"}
    {ru = "Шальной", en = "Unhinged"}
    {ru = "Крыса", en = "Rat"}
    {ru = "Баламут", en = "Stirrer"}
    {ru = "Мятежник", en = "Rebel"}
    {ru = "Лиходей", en = "Villain"}
    {ru = "Брехло", en = "Liar"}
    {ru = "Заяц", en = "Hare"}
    {ru = "Верный", en = "Faithful"}
    {ru = "Товарищ", en = "Comrade"}
    {ru = "Фанатик", en = "Fanatic"}
    {ru = "Голодный", en = "Hungry"}
    {ru = "Бесстрашный", en = "Fearless"}
    {ru = "Хвастун", en = "Showoff"}
    {ru = "Неспокойный", en = "Restless"}
    {ru = "Предатель", en = "Turncoat"}
    {ru = "Изгой", en = "Outcast"}
    {ru = "Позор", en = "Disgrace"}
    {ru = "Отступник", en = "Apostate"}
    {ru = "Отречённый", en = "Renounced"}
    {ru = "Правдоруб", en = "Truth-cutter"}
    {ru = "Гнилой", en = "Rotten"}
    {ru = "Нелюдь", en = "Inhuman"}
    {ru = "Соня", en = "Sleepy"}
    {ru = "Заводила", en = "Instigator"}
    {ru = "Щегол", en = "Dandy"}
    {ru = "Барабан", en = "Drum"}
    {ru = "Пиявка", en = "Leech"}
    {ru = "Угорь", en = "Eel"}
    {ru = "Крендель", en = "Pretzel"}
    {ru = "Павлин", en = "Peacock"}
    {ru = "Свисток", en = "Whistle"}
    {ru = "Бузотёр", en = "Rabblerouser"}
    {ru = "Дебошир", en = "Hellraiser"}
    {ru = "Петух", en = "Cock"}
    {ru = "Петушок", en = "Cockerel"}
    {ru = "Философ", en = "Philosopher"}
    {ru = "Лицемер", en = "Hypocrite"}
    {ru = "Звездочёт", en = "Stargazer"}
    {ru = "Сектант", en = "Zealot"}
    {ru = "Скоморох", en = "Jester"}
    {ru = "Самоубийца", en = "Suicide"}
    {ru = "Атаман", en = "Chieftain"}
    {ru = "Мясник", en = "Butcher"}
    {ru = "Кувалда", en = "Sledgehammer"}
    {ru = "Рубака", en = "Slasher"}
    {ru = "Крепыш", en = "Strongarm"}
    {ru = "Борец", en = "Wrestler"}
    {ru = "Жеребец", en = "Stallion"}
    {ru = "Удалец", en = "Gallant"}
    {ru = "Крепкий Орешек", en = "Hard Nut"}
    {ru = "Громила", en = "Bruiser"}
    {ru = "Молот", en = "Hammer"}
    {ru = "Топор", en = "Axe"}
    {ru = "Коса", en = "Scythe"}
    {ru = "Горлохват", en = "Throat-grabber"}
    {ru = "Жало", en = "Stinger"}
    {ru = "Живодёр", en = "Flayer"}
    {ru = "Мясорубка", en = "Meatgrinder"}
    {ru = "Душегуб", en = "Killer"}
    {ru = "Головорез", en = "Cutthroat"}
    {ru = "Молния", en = "Lightning"}
    {ru = "Острый взгляд", en = "Sharp Eye"}
    {ru = "Мышка", en = "Fieldmouse"}
    {ru = "Свечка", en = "Candle"}
    {ru = "Чеснок", en = "Garlic"}
    {ru = "Стрела", en = "Arrow"}
    {ru = "Болт", en = "Bolt"}
    {ru = "Мастер клинка", en = "Blade Master"}
    {ru = "Костелом", en = "Bonebreaker"}
    {ru = "Жнец", en = "Reaper"}
    {ru = "Бойня", en = "Slaughterhouse"}
    {ru = "Смерч", en = "Whirlwind"}
    {ru = "Проворный", en = "Nimble"}
    {ru = "Сила есть", en = "Dumb Muscle"}
    {ru = "Кулак", en = "Fist"}
    {ru = "Людоед", en = "Man Eater"}
    {ru = "Перспективный", en = "Promising"}
    {ru = "Щитоносец", en = "Shield Bearer"}
    {ru = "Быстрые ноги", en = "Quick Feet"}
    {ru = "Юла", en = "Spinning Top"}
    {ru = "Толстая шкура", en = "Thick Hide"}
    {ru = "Кованый", en = "Battle-Forged"}
    {ru = "Ловкий", en = "Agile"}
    {ru = "Дуэлянт", en = "Duelist"}
    {ru = "Гарпун", en = "Harpoon"}
    {ru = "Наковальня", en = "Anvil"}
    {ru = "Заноза", en = "Splinter"}
    {ru = "Затычка", en = "Plug"}
    {ru = "Кремень", en = "Flint"}
    {ru = "Молотило", en = "Thresher"}
    {ru = "Карусель", en = "Whirligig"}
    {ru = "Щепка", en = "Sliver"}
    {ru = "Зубодробитель", en = "Toothbreaker"}
    {ru = "Гром", en = "Thunder"}
    {ru = "Крюк", en = "Hook"}
    {ru = "Костолом", en = "Bonecracker"}
    {ru = "Шило", en = "Awl"}
    {ru = "Клык", en = "Fang"}
    {ru = "Коготь", en = "Claw"}
    {ru = "Гвоздь", en = "Nail"}
    {ru = "Черепаха", en = "Tortoise"}
    {ru = "Мозгоправ", en = "Headshrinker"}
    {ru = "Трубочист", en = "Chimney Sweep"}
    {ru = "Гроза Орков", en = "Orc Terror"}
    {ru = "Оркоед", en = "Orc-Eater"}
    {ru = "Шнырь", en = "Snooper"}
    {ru = "Решето", en = "Sieve"}
    {ru = "Хрен попадёшь", en = "Bullet Dodger"}
    {ru = "Везунчик", en = "Lucky"}
    {ru = "Счастливчик", en = "Lucky Devil"}
    {ru = "Горемыка", en = "Wretch"}
    {ru = "Обречённый", en = "Doomed"}
    {ru = "Неудачник", en = "Loser"}
    {ru = "Красный Нос", en = "Red Nose"}
    {ru = "Смертник", en = "Dead Man"}
    {ru = "Пёс Везучий", en = "Lucky Dog"}
    {ru = "Беда", en = "Trouble"}
    {ru = "Кроличья лапка", en = "Rabbit Foot"}
    {ru = "Мертвец", en = "Corpse"}
    {ru = "Колобок", en = "Dumpling"}
    {ru = "Герой", en = "Hero"}
    {ru = "Медведь", en = "Bear"}
    {ru = "Волк", en = "Wolf"}
    {ru = "Кабан", en = "Boar"}
    {ru = "Вепрь", en = "Wild Boar"}
    {ru = "Лис", en = "Fox"}
    {ru = "Сова", en = "Owl"}
    {ru = "Самородок", en = "Natural"}
    {ru = "Ворон", en = "Raven"}
    {ru = "Барсук", en = "Badger"}
    {ru = "Клещ", en = "Tick"}
    {ru = "Ёрш", en = "Ruffe"}
    {ru = "Коняга", en = "Workhorse"}
    {ru = "Таракан", en = "Cockroach"}
    {ru = "Орёл", en = "Eagle"}
    {ru = "Зверь", en = "Beast"}
    {ru = "Пёс", en = "Hound"}
    {ru = "Чертёнок", en = "Imp"}
    {ru = "Псина", en = "Mutt"}
    {ru = "Курица", en = "Chicken"}
    {ru = "Фонарь", en = "Lantern"}
    {ru = "Слепень", en = "Horsefly"}
    {ru = "Шмель", en = "Hornet"}
    {ru = "Рысь", en = "Lynx"}
    {ru = "Мул", en = "Mule"}
    {ru = "Соколик", en = "Falcon"}
    {ru = "Хорёк", en = "Ferret"}
    {ru = "Козёл", en = "Goat"}
    {ru = "Жаба", en = "Toad"}
    {ru = "Сорока", en = "Magpie"}
    {ru = "Бобёр", en = "Beaver"}
    {ru = "Волкодав", en = "Wolfhound"}
    {ru = "Сурок", en = "Groundhog"}
    {ru = "Жук", en = "Beetle"}
    {ru = "Крот", en = "Mole"}
    {ru = "Сыч", en = "Screech Owl"}
    {ru = "Бес", en = "Fiend"}
    {ru = "Растяпа", en = "Klutz"}
    {ru = "Боров", en = "Porker"}
    {ru = "Шакал", en = "Jackal"}
    {ru = "Змея", en = "Snake"}
    {ru = "Замухрышка", en = "Runt"}
    {ru = "Пень", en = "Stump"}
    {ru = "Чурбан", en = "Blockhead"}
    {ru = "Лапоть", en = "Bumpkin"}
    {ru = "Дохлый", en = "Half-dead"}
    {ru = "Огрызок", en = "Remnant"}
    {ru = "Висельник", en = "Gallows-bird"}
    {ru = "Рухлядь", en = "Old Wreck"}
    {ru = "Плюгавый", en = "Puny"}
    {ru = "Мутный", en = "Shady"}
    {ru = "Полено", en = "Log"}
    {ru = "Чумной", en = "Cracked"}
    {ru = "Балда", en = "Numbskull"}
    {ru = "Простак", en = "Simpleton"}
    {ru = "Скользкий", en = "Slippy"}
    {ru = "Склизкий", en = "Slippery"}
    {ru = "Мягкий", en = "Squishy"}
    {ru = "Невежда", en = "Clueless"}
    {ru = "Вялый", en = "Dullard"}
    {ru = "Пыхтун", en = "Puffer"}
    {ru = "Жалкий", en = "Pitiful"}
    {ru = "Развалина", en = "Crumbler"}
    {ru = "Болван", en = "Oaf"}
    {ru = "Бревно", en = "Timber"}
    {ru = "Дрын", en = "Cudgel"}
    {ru = "Мясо", en = "Cannon Fodder"}
    {ru = "Кляча", en = "Old Nag"}
    {ru = "Бубен", en = "Tambourine"}
    {ru = "Сморчок", en = "Wisp"}
    {ru = "Мордоворот", en = "Ugly Mug"}
    {ru = "Жбан", en = "Tankard"}
    {ru = "Балалайка", en = "Balalaika"}
    {ru = "Валенок", en = "Felt Boot"}
    {ru = "Отбивная", en = "Cutlet"}
    {ru = "Обуза", en = "Deadweight"}
    {ru = "Чучело", en = "Scarecrow"}
    {ru = "Пугало", en = "Bogey"}
    {ru = "Грабли", en = "Rake"}
    {ru = "Олух", en = "Clod"}
    {ru = "Увалень", en = "Waddler"}
    {ru = "Тюфяк", en = "Stuffed Sack"}
    {ru = "Телёнок", en = "Calf"}
    {ru = "Тряпка", en = "Doormat"}
    {ru = "Мокрые Штаны", en = "Wet Britches"}
    {ru = "Хромой Пёс", en = "Limping Hound"}
    {ru = "Дырявая Башка", en = "Cracked Skull"}
    {ru = "Юродивый", en = "Holy Fool"}
    {ru = "Клешня", en = "Pincer"}
    {ru = "Ухо", en = "Ear"}
    {ru = "Полушка", en = "Half-ear"}
    {ru = "Культяпка", en = "Stub"}
    {ru = "Пуганый", en = "Spooked"}
    {ru = "Блаженный", en = "Blessed"}
    {ru = "Синяк", en = "Bruise"}
    {ru = "Бродяга", en = "Wanderer"}
    {ru = "Беглец", en = "Fugitive"}
    {ru = "Пришлый", en = "Outsider"}
    {ru = "Дикий", en = "Wild One"}
    {ru = "Дышло", en = "Bellows"}
    {ru = "Хрипун", en = "Raspy"}
    {ru = "Мехи", en = "Wind Pumps"}
    {ru = "Труба", en = "Foghorn"}
    {ru = "Бурдюк", en = "Wineskin"}
    {ru = "Пёрышко", en = "Featherweight"}
    {ru = "Отмычка", en = "Picklock"}
    {ru = "Дуболом", en = "Oaf Feller"}
    {ru = "Звонарь", en = "Bell Ringer"}
    {ru = "Стражник", en = "Town Guard"}
    {ru = "Рекрут", en = "Recruit"}
    {ru = "Частокол", en = "Palisade"}
    {ru = "Деревня", en = "Village Boy"}
    {ru = "Проводник", en = "Pathfinder"}
    {ru = "Козлик", en = "Billy Goat"}
    {ru = "Верный Шаг", en = "Sure Step"}
    {ru = "Байстрюк", en = "By-blow"}
    {ru = "Нагуляный", en = "Love Child"}
    {ru = "Отпрыск", en = "Offspring"}
    {ru = "Левый Сын", en = "Left-Hand Son"}
    {ru = "Случайный", en = "Accident"}
    {ru = "Каблук", en = "Cobbler"}
    {ru = "Петля", en = "Noose"}
    {ru = "Знаменосец", en = "Standard Bearer"}
    {ru = "Дудочник", en = "Pied Piper"}
    {ru = "Вилы", en = "Pitchfork"}
    {ru = "Ходок по доскам", en = "Plank Walker"}
    {ru = "Перо", en = "Quill"}
    {ru = "Лопата", en = "Shovel"}
    {ru = "Кастрюля", en = "Stewpot"}
    {ru = "Могила", en = "Tomb"}
    {ru = "Расхититель", en = "Tomb Raider"}
    {ru = "Большой улов", en = "Big Catch"}
    {ru = "Кровища", en = "Bloodbath"}
    {ru = "Без башни", en = "Wildcard"}
    {ru = "Ветерок", en = "Breeze"}
    {ru = "Болячка", en = "Sore"}
    {ru = "Дозорный", en = "Watchman"}
    {ru = "Колдун", en = "Sorcerer"}
    {ru = "Самосуд", en = "Vigilante"}
    {ru = "Кошель", en = "Moneybag"}
    {ru = "Барыга", en = "Fence"}
    {ru = "Пахарь", en = "Ploughman"}
    {ru = "Шарманка", en = "Hurdy-gurdy"}
    {ru = "Коновал", en = "Quack"}
    {ru = "Отшельник", en = "Hermit"}
    {ru = "Деревенщина", en = "Yokel"}
    {ru = "Землекоп", en = "Digger"}
    {ru = "Гробовщик", en = "Undertaker"}
    {ru = "Шулер", en = "Cardsharp"}
    {ru = "Тамада", en = "Toastmaster"}
    {ru = "Знахарь", en = "Witch Doctor"}
    {ru = "Мародёр", en = "Marauder"}
    {ru = "Шарлатан", en = "Charlatan"}
    {ru = "Обоз", en = "Baggage Train"}
    {ru = "Погонщик", en = "Drover"}
    {ru = "Любимчик", en = "Crowd Favourite"}
    {ru = "Сетка", en = "Net Fighter"}
    {ru = "Пилигрим", en = "Pilgrim"}
    {ru = "Породистый", en = "Toff"}
    {ru = "Свободный", en = "Free Blade"}
    {ru = "Холоп", en = "Serf"}
    {ru = "Лакей", en = "Lackey"}
    {ru = "Метла", en = "Broom"}
    {ru = "Кирпич", en = "Brick"}
    {ru = "Каменщик", en = "Mason"}
    {ru = "Плита", en = "Slab"}
    {ru = "Зубило", en = "Chisel"}
    {ru = "Паж", en = "Page"}
    {ru = "Коробейник", en = "Pedlar"}
    {ru = "Торгаш", en = "Huckster"}
    {ru = "Лоток", en = "Tray Man"}
    {ru = "Кот", en = "Tom Cat"}
    {ru = "Ночник", en = "Night Prowler"}
    {ru = "Капкан", en = "Trap"}
    {ru = "Инквизитор", en = "Inquisitor"}
    {ru = "Шаман", en = "Shaman"}
    {ru = "Святоша", en = "Holy Roller"}
    {ru = "Кровосос", en = "Bloodsucker"}
    {ru = "Упырь", en = "Ghoul"}
    {ru = "Кукловод", en = "Puppeteer"}
    {ru = "Голосок", en = "High Voice"}
    {ru = "Дворцовый", en = "Palace Man"}
    {ru = "Берсерк", en = "Berserker"}
    {ru = "Светлячок", en = "Firefly"}
    {ru = "Книга", en = "Open Book"}
    {ru = "Подлец", en = "Rascal"}
    {ru = "Сглаз", en = "Jinx"}
    {ru = "Мука", en = "Flour"}
    {ru = "Водяной", en = "Water Spirit"}
    {ru = "Глухарь", en = "Deaf Grouse"}
    {ru = "Безрукий", en = "Handless"}
    {ru = "Беспалый", en = "Fingerless"}
    {ru = "Подранок", en = "Wounded Bird"}
    {ru = "Штык", en = "Bayonet"}
    {ru = "Пращник", en = "Slinger"}
    {ru = "Камушек", en = "Pebble"}
    {ru = "Залп", en = "Volley"}
    {ru = "Рогатина", en = "Boar Spear"}
    {ru = "Клевец", en = "War Pick"}
    {ru = "Кол", en = "Stake"}
    {ru = "Ледоруб", en = "Ice-Cutter"}
    {ru = "Меткий", en = "Sharpshooter"}
    {ru = "Оса", en = "Wasp"}
    {ru = "Призрак", en = "Ghost"}
    {ru = "Подушка", en = "Pillow"}
    {ru = "Дуб", en = "Oak"}
    {ru = "Бивень", en = "Tusk"}
    {ru = "Чугун", en = "Pig-Iron"}
    {ru = "Чуткий", en = "Hunch"}
    {ru = "Старожил", en = "Old-Timer"}
    {ru = "Волчара", en = "Grey Wolf"}
    {ru = "Ураган", en = "Hurricane"}
    {ru = "Лисёнок", en = "Fox Cub"}
    {ru = "Волчонок", en = "Wolf Cub"}
    {ru = "Зубоскал", en = "Snickerer"}
    {ru = "Гусь", en = "Goose"}
    {ru = "Муха", en = "Fly"}
    {ru = "Плут", en = "Crook"}
    {ru = "Змеёныш", en = "Snakeling"}
    {ru = "Бедокур", en = "Mischief-Maker"}
    {ru = "Травник", en = "Herbman"}
    {ru = "Голубятник", en = "Pigeon-Keeper"}
    {ru = "Кисточка", en = "Brush"}
    {ru = "Маляр", en = "Dauber"}
    {ru = "Тяпка", en = "Hoe"}
    {ru = "Игла", en = "Needle"}
    {ru = "Ряса", en = "Cassock"}
    {ru = "Служивый", en = "Servicer"}
    {ru = "Служака", en = "Barracks Man"}
    {ru = "Сирота", en = "Orphan"}
    {ru = "Горн", en = "Forge"}
    {ru = "Приблудный", en = "Stray"}
    {ru = "Перекати-поле", en = "Tumbleweed"}
    {ru = "Креститель", en = "Baptist"}
    {ru = "Дорогой", en = "Pricey"}
    {ru = "Кубышка", en = "Piggybank"}
    {ru = "Лось", en = "Elk"}
    {ru = "Мешок", en = "Sack"}
    {ru = "Пузырь", en = "Bubble"}
    {ru = "Лепёха", en = "Flatbread"}
    {ru = "Мямля", en = "Drip"}
    {ru = "Безносый", en = "Noseless"}
    {ru = "Хрящ", en = "Gristle"}
    {ru = "Бирюк", en = "Loner"}
    {ru = "Баклан", en = "Cormorant"}
    {ru = "Плакса", en = "Crybaby"}
    {ru = "Зевака", en = "Gawker"}
    {ru = "Ловец", en = "Catcher"}
    {ru = "Глаз Да Глаз", en = "One-Eyed Watch"}
    {ru = "Лихоманка", en = "Fever"}
    {ru = "Драная Шкура", en = "Torn Hide"}
    {ru = "Живучий Кот", en = "Tough Cat"}
    {ru = "Хромой Чёрт", en = "Limping Devil"}
    {ru = "Верный Клинок", en = "True Blade"}
    {ru = "Лёгкая Рука", en = "Light Hand"}
    {ru = "Дубовая Стрела", en = "Oaken Arrow"}
    {ru = "Медная Шкура", en = "Copper Hide"}
    {ru = "Бычья Шея", en = "Ox Neck"}
    {ru = "Вторая Кожа", en = "Second Skin"}
    {ru = "Кошачья Лапа", en = "Cat Paw"}
    {ru = "Медная Глотка", en = "Brass Throat"}
    {ru = "Старый Волк", en = "Old Wolf"}
    {ru = "Мокрая Курица", en = "Wet Hen"}
    {ru = "Кислый Хрен", en = "Sour Horseradish"}
    {ru = "Тихий Омут", en = "Quiet Pool"}
    {ru = "Дурной Глаз", en = "Evil Eye"}
    {ru = "Бешеный Пёс", en = "Mad Dog"}
    {ru = "Гнилой Зуб", en = "Rotten Tooth"}
    {ru = "Сорняк", en = "Weed"}
    {ru = "Старый Монах", en = "Old Monk"}
    {ru = "Лесной Волк", en = "Forest Wolf"}
    {ru = "Дикий Пёс", en = "Wild Dog"}
    {ru = "Шкурник", en = "Pelter"}
    {ru = "Конокрад", en = "Horse Thief"}
    {ru = "Серая Мышь", en = "Grey Mouse"}
    {ru = "Лавочник", en = "Shopkeep"}
    {ru = "Голый Зад", en = "Bare Arse"}
    {ru = "Жирный Боров", en = "Fat Hog"}
    {ru = "Сон-трава", en = "Sleep-Herb"}
    {ru = "Сухой Сучок", en = "Dry Twig"}
    {ru = "Толстый Каравай", en = "Fat Loaf"}
    {ru = "Тупой Кол", en = "Dull Stake"}
    {ru = "Золотые Руки", en = "Golden Hands"}
    {ru = "Лошадиная Сила", en = "Horse Power"}
    {ru = "Подкова", en = "Horseshoe"}
    {ru = "Колун", en = "Chopper"}
    {ru = "Кочан", en = "Cabbage"}
    {ru = "Квас", en = "Kvass"}
    {ru = "Пробка", en = "Cork"}
    {ru = "Гнилушка", en = "Rotten Stub"}
    {ru = "Сучок", en = "Snag"}
    {ru = "Пила", en = "Saw"}
    {ru = "Кочерыжка", en = "Cabbage Stump"}
    {ru = "Окорок", en = "Ham"}
    {ru = "Кисель", en = "Jelly"}
    {ru = "Калач", en = "Roll"}
    {ru = "Репа", en = "Turnip"}
    {ru = "Хрен", en = "Horseradish"}
    {ru = "Половник", en = "Ladle"}
    {ru = "Котелок", en = "Pothead"}
    {ru = "Багор", en = "Gaff"}
    {ru = "Верёвка", en = "Rope"}
    {ru = "Петух в мешке", en = "Bagged Rooster"}
    {ru = "Подмётка", en = "Sole"}
    {ru = "Черепок", en = "Potsherd"}
    {ru = "Сверчок", en = "Cricket"}
    {ru = "Фитиль", en = "Fuse"}
    {ru = "Булыжник", en = "Cobble"}
    {ru = "Репей", en = "Burr"}
    {ru = "Мухомор", en = "Toadstool"}
    {ru = "Пиявочник", en = "Leecher"}
    {ru = "Костыль", en = "Crutch"}
    {ru = "Шрам", en = "Scar"}
    {ru = "Пустое ухо", en = "Empty Ear"}
    {ru = "Святая вода", en = "Holy Water"}
    {ru = "Хлыст", en = "Whip"}
    {ru = "Напёрсток", en = "Thimble"}
    {ru = "Монета", en = "Coin"}
    {ru = "Ночной горшок", en = "Chamberpot"}
    {ru = "Крысиный хвост", en = "Rat-tail"}
    {ru = "Пыльная пятка", en = "Dust Heel"}
    {ru = "Будка", en = "Watchbox"}
    {ru = "Кайло", en = "Pickaxe"}
    {ru = "Кость", en = "Bone"}
    {ru = "Копыто", en = "Hoof"}
    {ru = "Кабанчик", en = "Shoat"}
    {ru = "Капюшон", en = "Hood"}
    {ru = "Сало", en = "Lard"}
    {ru = "Колесо", en = "Wheel"}
    {ru = "Секач", en = "Hewer"}
    {ru = "Хомяк", en = "Hoarder"}
    {ru = "Паскуда", en = "Scab"}
    {ru = "Гнилой зуб", en = "Rot Tooth"}
    {ru = "Битый жбан", en = "Cracked Jug"}
    {ru = "Свиное ушко", en = "Pig Ear"}
    {ru = "Грязный ноготь", en = "Dirty Nail"}
    {ru = "Не та нога", en = "Wrong Leg"}
    {ru = "Пёсья кость", en = "Dog Bone"}
    {ru = "Карман", en = "Pocket"}
    {ru = "Деревянный меч", en = "Wood Sword"}
    {ru = "Мясной крюк", en = "Meat Hook"}
]
pairs.extend(OldTitles);

::Rosetta.add(rosetta, pairs);
