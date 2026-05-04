if (!("Rosetta" in getroottable())) return;

local rosetta = {
    mod = {id = "mod_champion_beasts", version = "1.2.1"}
    author = "hackflow"
    lang = "ru"
}
local pairs = [
    // FILE: mod_champion_beasts/config/champions.nut
    {en = "the Trickster", ru = "Плут"}
    // FILE: mod_champion_beasts/config/names.nut
    {en = "Marie Shadowwalker", ru = "Мари Теневая"}
    {en = "Regina Vexx" ru = "Регина Вэкс"}
    {en = "Isis Cloven", ru = "Исида Расколотая"}
    {en = "Carlyn Wolf", ru = "Карлин Волк"}
    {en = "Valkyrie Tenebris", ru = "Валькирия Тенебрис"}
    {en = "Estrella Caligari", ru = "Эстрелла Калигари"}
    {en = "Maria Quinn", ru = "Мария Куинн"}
    {en = "Helen Le Torneau", ru = "Хелен Ле Торно"}
    {en = "Evanore Rathmore", ru = "Эванора Рэтмор"}
    {en = "Dorothy Panther", ru = "Дороти Пантера"}
    {en = "Sally Drabek", ru = "Салли Драбек"}
    {en = "Lilac Blankley", ru = "Сирень Бланкли"}
    {en = "Opal Shade", ru = "Опал Тень"}
    {en = "Minerva Tombend", ru = "Минерва Могильная"}
    {en = "Fern Shadowend", ru = "Фёрн Тенеход"}
    {en = "Leona Grimsbane", ru = "Леона Гримсгибель"}
    {en = "Christine Hart", ru = "Кристин Харт"}
    {en = "Dahlia Black", ru = "Далия Чёрная"}
    {en = "Agate Magnus", ru = "Агат Магнус"}
    {en = "Destiny Duke", ru = "Судьба Дюк"}
    {en = "Rosita Skinner", ru = "Розита Кожедёр"}
    {en = "Jemma Caligari", ru = "Джемма Калигари"}
    {en = "Anastasia Hallewell", ru = "Анастасия Холлуэлл"}
    {en = "Devi Riddle", ru = "Деви Загадка"}
    {en = "Ailey Crimson", ru = "Эйли Алая"}
    {en = "Glenda Lobo", ru = "Гленда Лобо"}
    {en = "Wihnhilda Murik", ru = "Вингильда Мурик"}
    {en = "Agate Tombend", ru = "Агат Могильная"}
    {en = "Angelica Blankley", ru = "Анжелика Бланкли"}
    {en = "Nissa Dukes", ru = "Нисса Дюкс"}
    {en = "Azura Scarletwound", ru = "Азура Алорана"}
    {en = "Odessa Stocker", ru = "Одесса Стокер"}
    {en = "Edna Latimer", ru = "Эдна Латимер"}
    {en = "Fay Void", ru = "Фэй Пустота"}
    {en = "Athena Dukes", ru = "Афина Дюкс"}
    {en = "Alecto Wood", ru = "Алекто Вуд"}
    {en = "Marilla Delarosa", ru = "Марилла Деларосса"}
    {en = "Albertine Graves", ru = "Альбертина Грейвс"}
    {en = "Hyacinth De Vil", ru = "Гиацинт Де Виль"}
    {en = "Kerrigan Malum", ru = "Керриган Малум"}
    {en = "Bernadette Raven", ru = "Бернадет Ворон"}
    {en = "Piper Woods", ru = "Пайпер Вудс"}
    {en = "Deville Blankley", ru = "Девиль Бланкли"}
    {en = "Farina Autumn", ru = "Фарина Осень"}
    {en = "Paige Crowe", ru = "Пейдж Кроу"}
    {en = "Bethy Rathmore", ru = "Бети Рэтмор"}
    {en = "Opalina Dread", ru = "Опалина Ужас"}
    {en = "Starla Moriarty", ru = "Старла Мориарти"}
    {en = "Meadow Cloven", ru = "Медоу Расколотая"}
    {en = "Deth", ru = "Дэт"}
    {en = "Aeren", ru = "Аэрен"}
    {en = "Blythe", ru = "Блайт"}
    {en = "Phan", ru = "Фан"}
    {en = "Aberra", ru = "Аберра"}
    {en = "Undine", ru = "Ундина"}
    {en = "Auris", ru = "Аурис"}
    {en = "Devo", ru = "Дево"}
    {en = "Angel", ru = "Ангел"}
    {en = "Ethae", ru = "Этэ"}
    {en = "Kindel", ru = "Киндэл"}
    {en = "Shayde", ru = "Шейд"}
    {en = "Myst", ru = "Мист"}
    {en = "Ethe", ru = "Эте"}
    {en = "Charis", ru = "Харис"}
    {en = "Stray", ru = "Стрэй"}
    {en = "Eaven", ru = "Эвен"}
    {en = "Spec", ru = "Спек"}
    {en = "Flo", ru = "Фло"}
    {en = "Devi", ru = "Деви"}
    {en = "Lloial", ru = "Ллойял"}
    {en = "Lite", ru = "Лайт"}
    {en = "Gallo", ru = "Галло"}
    {en = "Aide", ru = "Эйд"}
    {en = "Remane", ru = "Рэмэйн"}
    {en = "Aener", ru = "Аэнер"}
    {en = "Perris", ru = "Перрис"}
    {en = "Guya", ru = "Гуя"}
    {en = "Spryte", ru = "Спрайт"}
    {en = "Celeste", ru = "Селест"}
    {en = "Ellis", ru = "Эллис"}
    {en = "Ora", ru = "Ора"}
    {en = "Faith", ru = "Вера"}
    {en = "Elyse", ru = "Элиз"}
    {en = "the Welcome Eyes", ru = "Приветливый Взгляд"}
    {en = "the Ignored Widow", ru = "Забытая Вдова"}
    {en = "the Whining Maid", ru = "Ноющая Служанка"}
    {en = "the Dark Apparition", ru = "Тёмное Явление"}
    {en = "the Grim Templar", ru = "Мрачный Тамплиер"}
    {en = "the Sobbing Kid", ru = "Рыдающее Дитя"}
    {en = "the Forest Sentinel", ru = "Лесной Страж"}
    {en = "the Invited Necromancer", ru = "Приглашённый Некромант"}
    {en = "the Beach Woman", ru = "Женщина с Берега"}
    {en = "the Wandering Wraith", ru = "Блуждающий Призрак"}
    {en = "the Malevolent Squire", ru = "Злобный Оруженосец"}
    {en = "the Laughing Wraith", ru = "Смеющийся Призрак"}
    {en = "the Roaming Kid", ru = "Бродячее Дитя"}
    {en = "the Bloody Appearance", ru = "Кровавое Явление"}
    {en = "the White Phantom", ru = "Белый Фантом"}
    {en = "the Marching Templar", ru = "Марширующий Тамплиер"}
    {en = "the Hostile Teacher", ru = "Враждебный Учитель"}
    {en = "the Sleeping Reaper", ru = "Спящий Жнец"}
    {en = "the Midnight Ghost", ru = "Полночный Призрак"}
    {en = "the Violent Soul", ru = "Яростная Душа"}
    {en = "the Thin Cook", ru = "Тощий Повар"}
    {en = "the Wild Protector", ru = "Дикий Защитник"}
    {en = "the Stalking Guest", ru = "Крадущийся Гость"}
    {en = "the Grim Force", ru = "Мрачная Сила"}
    {en = "the Jolly Guardian", ru = "Весёлый Страж"}
    {en = "the Shy Ghost", ru = "Робкий Призрак"}
    {en = "the Headless Patrol", ru = "Безголовый Дозор"}
    {en = "the Forest Man", ru = "Лесной Человек"}
    {en = "the Wicked Prisoner", ru = "Злобный Узник"}
    {en = "the Forest Gentleman", ru = "Лесной Господин"}
    {en = "the Howling Shade", ru = "Воющая Тень"}
    {en = "the Beach Phantom", ru = "Береговой Фантом"}
    {en = "the Running Nightwatch", ru = "Бегущий Ночной Страж"}
    {en = "the Abandoned Kid", ru = "Брошенное Дитя"}
    {en = "the Sleeping Knight", ru = "Спящий Рыцарь"}
    {en = "the Wicked Servant", ru = "Злобный Слуга"}
    {en = "the Shrieking Witch", ru = "Вопящая Ведьма"}
    {en = "the Torment Soul", ru = "Мучимая Душа"}
    {en = "the Agony Dame", ru = "Дама в Агонии"}
    {en = "the Sinister Specter", ru = "Зловещий Призрак"}
    {en = "the Yelling Spirit", ru = "Кричащий Дух"}
    {en = "the Blaring Girl", ru = "Вопящая Девица"}
    {en = "the Vexed Damsel", ru = "Раздражённая Девушка"}
    {en = "the Faded Matriarch", ru = "Потускневшая Матриарх"}
    {en = "the Fading Apparition", ru = "Угасающее Явление"}
    {en = "the Grievous Maiden", ru = "Скорбная Дева"}
    {en = "the Screeching Youth", ru = "Визжащий Юнец"}
    {en = "the Mournful Apparition", ru = "Горестное Явление"}
    {en = "the Wandering Dame", ru = "Блуждающая Дама"}
    {en = "the Humming Banshee", ru = "Гудящая Банши"}
    {en = "the Grievous Mother", ru = "Скорбная Мать"}
    {en = "the Broken Aunt", ru = "Сломленная Тётушка"}
    {en = "Graarorn", ru = "Граарорн"}
    {en = "Erkun", ru = "Эркун"}
    {en = "Emnorn", ru = "Эмнорн"}
    {en = "Rhunzern", ru = "Рунзерн"}
    {en = "Trunmart", ru = "Трунмарт"}
    {en = "Threnmur", ru = "Тренмур"}
    {en = "Valkar", ru = "Валкар"}
    {en = "Struztort", ru = "Струзторт"}
    {en = "Uzron", ru = "Узрон"}
    {en = "Vokteror", ru = "Воктерор"}
    {en = "Velzurt", ru = "Велзурт"}
    {en = "Galzarn", ru = "Галзарн"}
    {en = "Stragrundurn", ru = "Страгрундурн"}
    {en = "Rezrarn", ru = "Резрарн"}
    {en = "Strazdas", ru = "Страздас"}
    {en = "Zoktos", ru = "Зоктос"}
    {en = "Zaaltur", ru = "Заалтур"}
    {en = "Momnur", ru = "Момнур"}
    {en = "Vurdas", ru = "Вурдас"}
    {en = "Makssur", ru = "Максур"}
    {en = "Sulles", ru = "Суллес"}
    {en = "Zrostem", ru = "Зростем"}
    {en = "Veksum", ru = "Векзум"}
    {en = "Trozuthart", ru = "Трозутхарт"}
    {en = "Voktes", ru = "Воктес"}
    {en = "Ozdaun", ru = "Оздаун"}
    {en = "Hennern", ru = "Хеннерн"}
    {en = "Emnert", ru = "Эмнерт"}
    {en = "Zordurt", ru = "Зордурт"}
    {en = "Olar", ru = "Олар"}
    {en = "Soztauj", ru = "Состауй"}
    {en = "Vuzdem", ru = "Вуздем"}
    {en = "Skolus", ru = "Сколус"}
    {en = "Skortert", ru = "Скортерт"}
    {en = "Egnum", ru = "Эгнум"}
    {en = "Ontam", ru = "Онтам"}
    {en = "Omner", ru = "Омнер"}
    {en = "Thamnort", ru = "Тамнорт"}
    {en = "Gurton", ru = "Гуртон"}
    {en = "Velmarn", ru = "Велмарн"}
    {en = "Zagron", ru = "Загрон"}
    {en = "Rhelzen", ru = "Релзен"}
    {en = "Karom", ru = "Каром"}
    {en = "Strenzunturn", ru = "Стренцунтурн"}
    {en = "Kanzort", ru = "Канзорт"}
    {en = "Monnum", ru = "Моннум"}
    {en = "Gagnorn", ru = "Гагнорн"}
    {en = "Truzun", ru = "Трузун"}
    {en = "Ugrarn", ru = "Уграрн"}
    {en = "Traltar", ru = "Тралтар"}
    {en = "Hulkaeuj", ru = "Хулкауй"}
    {en = "Vemnortun", ru = "Вемнортун"}
    {en = "Ertort", ru = "Эрторт"}
    {en = "Skoluj", ru = "Сколуй"}
    {en = "Stralkes", ru = "Стралкес"}
    {en = "Keles", ru = "Келес"}
    {en = "Astern", ru = "Астерн"}
    {en = "Trolzam", ru = "Тролзам"}
    {en = "Thauzdoj", ru = "Тауздой"}
    {en = "Raullus", ru = "Раулус"}
    {en = "Asbas", ru = "Асбас"}
    {en = "Ilduk", ru = "Илдук"}
    {en = "Nourzim", ru = "Нурзим"}
    {en = "Daoldrim", ru = "Даолдрим"}
    {en = "Toldil", ru = "Толдил"}
    {en = "Adram", ru = "Адрам"}
    {en = "Lendim", ru = "Лендим"}
    {en = "Dinzek", ru = "Динзек"}
    {en = "Umkil", ru = "Умкил"}
    {en = "Tounzox", ru = "Тоунзокс"}
    {en = "Aoznik", ru = "Аозник"}
    {en = "Zuzli", ru = "Зузли"}
    {en = "Ukris", ru = "Укрис"}
    {en = "Guznus", ru = "Гузнус"}
    {en = "Ognan", ru = "Огнан"}
    {en = "Ualdim", ru = "Уалдим"}
    {en = "Malguk", ru = "Малгук"}
    {en = "Huarbol", ru = "Хуарбол"}
    {en = "Lebrul", ru = "Лебрул"}
    {en = "Laugrik", ru = "Лаугрик"}
    {en = "Lunzak", ru = "Лунзак"}
    {en = "Uknim", ru = "Укним"}
    {en = "Delkok", ru = "Делкок"}
    {en = "Luarbak", ru = "Луарбак"}
    {en = "Erdak", ru = "Эрдак"}
    {en = "Vaundil", ru = "Ваундил"}
    {en = "Tervux", ru = "Тервукс"}
    {en = "Agnik", ru = "Агник"}
    {en = "Dimdrox", ru = "Димдрокс"}
    {en = "Haulgra", ru = "Хаулгра"}
    {en = "Lorzul", ru = "Лорзул"}
    {en = "Negrek", ru = "Негрек"}
    {en = "Galdex", ru = "Галдекс"}
    {en = "Aogran", ru = "Аогран"}
    {en = "Zalka", ru = "Залка"}
    {en = "Nuamkim", ru = "Нуамким"}
    {en = "Zomkan", ru = "Зомкан"}
    {en = "Lalgre", ru = "Лалгре"}
    {en = "Migdik", ru = "Мигдик"}
    {en = "Zuaklin", ru = "Зуаклин"}
    {en = "Liskal", ru = "Лискал"}
    {en = "Zuznum", ru = "Зузнум"}
    {en = "Nouslas", ru = "Нуслас"}
    {en = "Zignok", ru = "Зигнок"}
    {en = "Tikra", ru = "Тикра"}
    {en = "Lervux", ru = "Лервукс"}
    {en = "Zuaklum", ru = "Зуаклум"}
    {en = "Gumkas", ru = "Гумкас"}
    {en = "Laorzas", ru = "Лаорзас"}
    {en = "Duslim", ru = "Дуслим"}
    {en = "Norda", ru = "Норда"}
    {en = "Mazli", ru = "Мазли"}
    {en = "Laograx", ru = "Лаогракс"}
    {en = "Zigrak", ru = "Зиграк"}
    {en = "Voumri", ru = "Воумри"}
    {en = "Umkax", ru = "Умкакс"}
    {en = "Zoclo", ru = "Зокло"}
    {en = "Arvin", ru = "Арвин"}
    {en = "Luagra", ru = "Луагра"}
    {en = "Oumrul", ru = "Оумрул"}
    {en = "Diklol", ru = "Диклол"}
    {en = "Turdak", ru = "Турдак"}
    {en = "Tenzis", ru = "Тензис"}
    {en = "Arzel", ru = "Арзел"}
    {en = "Takdok", ru = "Такдок"}
    {en = "Eldil", ru = "Элдил"}
    {en = "Dalgul", ru = "Далгул"}
    {en = "Vulgrol", ru = "Вулгрол"}
    {en = "Omkek", ru = "Омкек"}
    {en = "Anguk", ru = "Ангук"}
    {en = "Ekdux", ru = "Экдукс"}
    {en = "Naugduk", ru = "Наугдук"}
    {en = "Labrak", ru = "Лабрак"}
    {en = "Abram", ru = "Абрам"}
    {en = "Maczu", ru = "Мацзу"}
    {en = "Vaolgrix", ru = "Ваолгрикс"}
    {en = "Tesbum", ru = "Тесбум"}
    {en = "Maskox", ru = "Маскокс"}
    {en = "Oudres", ru = "Аудрес"}
    {en = "Tekrun", ru = "Текрун"}
    {en = "Bic", ru = "Бик"}
    {en = "Khad", ru = "Кхад"}
    {en = "Rog", ru = "Рог"}
    {en = "Khotzoz", ru = "Хотзоз"}
    {en = "Amgac", ru = "Амгак"}
    {en = "Khozlaug", ru = "Хозлауг"}
    {en = "Cliffdribbler", ru = "Скалослюн"}
    {en = "Banemark", ru = "Гибельник"}
    {en = "Bonemuncher", ru = "Костогрыз"}
    {en = "Slimebrow", ru = "Слизебровь"}
    {en = "Khauc", ru = "Кхаук"}
    {en = "Rok", ru = "Рок"}
    {en = "Ruc", ru = "Рук"}
    {en = "Baldog", ru = "Балдог"}
    {en = "Gikiz", ru = "Гикиз"}
    {en = "Vaskrot", ru = "Васкрот"}
    {en = "Cursebane", ru = "Проклятогибель"}
    {en = "Iceguzzler", ru = "Льдоглот"}
    {en = "Grimlimb", ru = "Мрачноклешня"}
    {en = "Goomaw", ru = "Слизепасть"}
    {en = "Vog", ru = "Вог"}
    {en = "Zod", ru = "Зод"}
    {en = "Kox", ru = "Кокс"}
    {en = "Oknug", ru = "Окнуг"}
    {en = "Untit", ru = "Унтит"}
    {en = "Ummag", ru = "Уммаг"}
    {en = "Snowclaw", ru = "Снегоготь"}
    {en = "Emberrunner", ru = "Жаробег"}
    {en = "Earthrunner", ru = "Землебег"}
    {en = "Ironchewer", ru = "Железогрыз"}
    {en = "Khag", ru = "Кхаг"}
    {en = "Khox", ru = "Кхокс"}
    {en = "Chot", ru = "Чот"}
    {en = "Vaqux", ru = "Вакукс"}
    {en = "Rablod", ru = "Раблод"}
    {en = "Bikvag", ru = "Бикваг"}
    {en = "Darkwatcher", ru = "Тёмнодозор"}
    {en = "Puscrown", ru = "Гноекорона"}
    {en = "Stormchewer", ru = "Бурегрыз"}
    {en = "Chainbrewer", ru = "Цепекуй"}
    {en = "Roq", ru = "Рокк"}
    {en = "Zog", ru = "Зог"}
    {en = "Gat", ru = "Гат"}
    {en = "Chikvac", ru = "Чиквак"}
    {en = "Oskrux", ru = "Оскрукс"}
    {en = "Osgout", ru = "Осгут"}
    {en = "Filthbasher", ru = "Грязебой"}
    {en = "Dirtsnarl", ru = "Земнорык"}
    {en = "Gorestuffer", ru = "Кишконаб"}
    {en = "Gooface", ru = "Слиземорда"}
    {en = "Bux", ru = "Букс"}
    {en = "Rig", ru = "Риг"}
    {en = "Chok", ru = "Чок"}
    {en = "Kholgrot", ru = "Кхолгрот"}
    {en = "Vanok", ru = "Ванок"}
    {en = "Uktrat", ru = "Уктрат"}
    {en = "Forgesorrow", ru = "Кузнегорь"}
    {en = "Darksworn", ru = "Тёмноклятый"}
    {en = "Flameslobber", ru = "Огнеслюн"}
    {en = "Sludgeripper", ru = "Илорвач"}
    {en = "Kreciq", ru = "Крецик"}
    {en = "Qix'ab", ru = "Киксаб"}
    {en = "Rouqzis", ru = "Рукзис"}
    {en = "Kriqed", ru = "Крикед"}
    {en = "Assirriq", ru = "Ассиррик"}
    {en = "Rartaq", ru = "Рартак"}
    {en = "Qaviqo", ru = "Кавико"}
    {en = "Kraqad", ru = "Кракад"}
    {en = "Keqrit", ru = "Кекрит"}
    {en = "Qhalra", ru = "Кхалра"}
    {en = "Sriazikib", ru = "Сриазикиб"}
    {en = "Qartus", ru = "Картус"}
    {en = "Zhaqak'ror", ru = "Жакакрор"}
    {en = "Qhiantu", ru = "Кхианту"}
    {en = "Yirrad", ru = "Йиррад"}
    {en = "Rocur", ru = "Рокур"}
    {en = "Srark'as", ru = "Сраркас"}
    {en = "Zhek'sid", ru = "Жексид"}
    {en = "Qraarricheeb", ru = "Краарричиб"}
    {en = "Khaquntai", ru = "Хакунтай"}
    {en = "Irernaib", ru = "Ирернаиб"}
    {en = "Sriq'teke", ru = "Сриктеке"}
    {en = "Sassox", ru = "Сасокс"}
    {en = "Szisiq", ru = "Сзисик"}
    {en = "Zhosniq", ru = "Жосник"}
    {en = "Qrok'zud", ru = "Крокзуд"}
    {en = "Choqtu", ru = "Чокту"}
    {en = "Rocos", ru = "Рокос"}
    {en = "Zhaakuced", ru = "Жакусед"}
    {en = "Civus", ru = "Цивус"}
    {en = "Xousri", ru = "Хаусри"}
    {en = "Qen'qus", ru = "Кенкус"}
    {en = "Szakzor", ru = "Сзакзор"}
    {en = "Cek'ra", ru = "Цекра"}
    {en = "Lerox", ru = "Лерокс"}
    {en = "Krakzoq", ru = "Кракзок"}
    {en = "Qantet", ru = "Кантет"}
    {en = "Szoq'zivoq", ru = "Сзокзивок"}
    {en = "Zhek'zax", ru = "Жекзакс"}
    {en = "Aqizra", ru = "Акизра"}
    {en = "Caiva", ru = "Каива"}
    {en = "Charilli", ru = "Чарилли"}
    {en = "Khavur", ru = "Хавур"}
    {en = "Renteseh", ru = "Рентесех"}
    {en = "Rer'oh", ru = "Рерох"}
    {en = "Qhevah", ru = "Кхевах"}
    {en = "Szeecur", ru = "Сзекур"}
    {en = "Sikuh", ru = "Сикух"}
    {en = "Qher'aq", ru = "Кхерак"}
    {en = "Lat'o", ru = "Лато"}
    {en = "Loroqaid", ru = "Лорокаид"}
    {en = "Qir'eq", ru = "Кирек"}
    {en = "Qhasniq", ru = "Кхасник"}
    {en = "Khirti", ru = "Хирти"}
    {en = "Qisod", ru = "Кисод"}
    {en = "Yallur", ru = "Яллур"}
    {en = "Qhaizes", ru = "Кхайзес"}
    {en = "Yezsa", ru = "Йезса"}
    {en = "Chiriq", ru = "Чирик"}
    {en = "Zhivi", ru = "Живи"}
    {en = "Zasur", ru = "Засур"}
    {en = "At'i", ru = "Ати"}
    {en = "Zhirzasa", ru = "Жирзаса"}
    {en = "Zhisorzal", ru = "Жисорзал"}
    {en = "Chen'qis", ru = "Ченкис"}
    {en = "Lan'qiel", ru = "Ланкиел"}
    {en = "Sezier", ru = "Сезиер"}
    {en = "Zivoh", ru = "Зивох"}
    {en = "Relli", ru = "Релли"}
    {en = "Qhereezed", ru = "Кхерезед"}
    {en = "Cypresstrunk", ru = "Кипариствол"}
    {en = "Poplarblossom", ru = "Тополоцвет"}
    {en = "Sprucebark", ru = "Елькора"}
    {en = "Locustherb", ru = "Акациятрава"}
    {en = "Wiselarch", ru = "Мудролист"}
    {en = "Larchcovert", ru = "Лиственькрыт"}
    {en = "Pineshadow", ru = "Соснотень"}
    {en = "Yewbrow", ru = "Тисобровь"}
    {en = "Oakfury", ru = "Дубогнев"}
    {en = "Treeburn", ru = "Древожар"}
    {en = "Pygmyash", ru = "Карлоясень"}
    {en = "Silentbeard", ru = "Тихоборода"}
    {en = "Weepingoak", ru = "Плакальдуб"}
    {en = "Mildfir", ru = "Кроткопихта"}
    {en = "Weepinglocust", ru = "Плакакация"}
    {en = "Ashgrowl", ru = "Ясеньрык"}
    {en = "Acorneye", ru = "Желудоглаз"}
    {en = "Alderpaw", ru = "Ольхолапа"}
    {en = "Barecherry", ru = "Голочерня"}
    {en = "Elmroar", ru = "Вязорёв"}
    {en = "Mellowleg", ru = "Мягконога"}
    {en = "Spruceburn", ru = "Ельожог"}
    {en = "Willowwood", ru = "Ивалес"}
    {en = "Algalwillow", ru = "Водоросьива"}
    {en = "Denseelm", ru = "Густовяз"}
    {en = "Aldertrunk", ru = "Ольхоствол"}
    {en = "Tainttrunk", ru = "Скверноствол"}
    {en = "Burnedspruce", ru = "Горелаель"}
    {en = "Willowgrowl", ru = "Иворык"}
    {en = "Pinetooth", ru = "Соснозуб"}
    {en = "Elmburn", ru = "Вязожар"}
    {en = "Cunningtendril", ru = "Хитроусик"}
    {en = "Treebrow", ru = "Древобровь"}
    {en = "Pineshade", ru = "Сосноумрак"}
    {en = "Thistlehowl", ru = "Чертополохвой"}
    {en = "Beechburn", ru = "Букожар"}
    {en = "Sprucetwig", ru = "Ельветка"}
    {en = "Summerelm", ru = "Летовяз"}
    {en = "Poplarscar", ru = "Тополорубец"}
    {en = "Tenderlocust", ru = "Нежноакация"}
    {en = "Mildyew", ru = "Кроткотис"}
    {en = "Walnutlimb", ru = "Ореховетвь"}
    {en = "Beechhusk", ru = "Букошелух"}
    {en = "Poplarleaf", ru = "Топололист"}
    {en = "Scrubash", ru = "Кустоясень"}
    {en = "Gaho", ru = "Гахо"}
    {en = "Ghekhun", ru = "Гхекхун"}
    {en = "Verga", ru = "Верга"}
    {en = "Messo", ru = "Мессо"}
    {en = "Ergaris", ru = "Эргарис"}
    {en = "Koveka", ru = "Ковека"}
    {en = "Geriammoj", ru = "Гериаммой"}
    {en = "Memmona", ru = "Меммона"}
    {en = "Jhauguhshouz", ru = "Жаугухшоуз"}
    {en = "Eruszin", ru = "Эрушзин"}
    {en = "Zozzu", ru = "Зоззу"}
    {en = "Zrezi", ru = "Зрези"}
    {en = "Zrihshu", ru = "Зрихшу"}
    {en = "Zhukash", ru = "Жукаш"}
    {en = "Jorineh", ru = "Жоринех"}
    {en = "Nremzaves", ru = "Нремзавес"}
    {en = "Zugussi", ru = "Зугусси"}
    {en = "Zhikachu", ru = "Жикачу"}
    {en = "Iamuhjoush", ru = "Иамухжоуш"}
    {en = "Ngunara", ru = "Нгунара"}
    {en = "Akhush", ru = "Акхуш"}
    {en = "Chuve", ru = "Чуве"}
    {en = "Jhardih", ru = "Жардих"}
    {en = "Mraissuh", ru = "Мраиссух"}
    {en = "Ennizi", ru = "Эннизи"}
    {en = "Khasshekai", ru = "Хассхекай"}
    {en = "Uravi", ru = "Урави"}
    {en = "Zrezzouron", ru = "Зреззурон"}
    {en = "Mranengua", ru = "Мраненгуа"}
    {en = "Viraiga", ru = "Вираига"}
    {en = "Jhuvou", ru = "Жувоу"}
    {en = "Mgukkeh", ru = "Мгуккех"}
    {en = "Zekas", ru = "Зекас"}
    {en = "Nraeka", ru = "Нраека"}
    {en = "Mozukkaij", ru = "Мозуккаий"}
    {en = "Ugzozou", ru = "Угзозоу"}
    {en = "Zuagunan", ru = "Зуагунан"}
    {en = "Zhiaziveh", ru = "Жиазивех"}
    {en = "Maergumehs", ru = "Маэргумэхс"}
    {en = "Nirounkan", ru = "Нироункан"}
    {en = "Zimo", ru = "Зимо"}
    {en = "Ghainnaz", ru = "Гхайнназ"}
    {en = "Khizaz", ru = "Кхизаз"}
    {en = "Chozzihs", ru = "Чоззихс"}
    {en = "Aurgino", ru = "Аургино"}
    {en = "Kuzkenu", ru = "Кузкену"}
    {en = "Jhogini", ru = "Жогини"}
    {en = "Kaennumzij", ru = "Каенумзий"}
    {en = "Mikenohz", ru = "Микенохз"}
    {en = "Nrezorosh", ru = "Нрезорош"}
    {en = "Ngunua", ru = "Нгунуа"}
    {en = "Mrisshis", ru = "Мриссхис"}
    {en = "Ogehs", ru = "Огехс"}
    {en = "Ikhohs", ru = "Икхохс"}
    {en = "Jhauzogo", ru = "Жаузого"}
    {en = "Zaishgouri", ru = "Заишгури"}
    {en = "Chonuachohz", ru = "Чонуачохз"}
    {en = "Ghemmuzshai", ru = "Гхеммузшай"}
    {en = "Mrehazshai", ru = "Мрехазшай"}
    {en = "Zhogiki", ru = "Жогики"}
    {en = "Thyxishae", ru = "Тиксишаэ"}
    {en = "Castiphelia", ru = "Кастифелия"}
    {en = "Chalithea", ru = "Халитея"}
    {en = "Isesis", ru = "Изесис"}
    {en = "Thronea", ru = "Тронеа"}
    {en = "Thosolphi", ru = "Тосолфи"}
    {en = "Sylphiphaeia", ru = "Силфифайя"}
    {en = "Messethis", ru = "Мессетис"}
    {en = "Pixishia", ru = "Пиксишия"}
    {en = "Thespophai", ru = "Теспофай"}
    {en = "Phalaemios", ru = "Фалаэмиос"}
    {en = "Xenosyne", ru = "Ксеносинэ"}
    {en = "Parthobus", ru = "Партобус"}
    {en = "Typhothius", ru = "Тифотиус"}
    {en = "Kosalus", ru = "Косалус"}
    {en = "Anchastos", ru = "Анчастос"}
    {en = "Alcelaus", ru = "Алселаус"}
    {en = "Agathoneus", ru = "Агатонеус"}
    {en = "Dionysaestus", ru = "Дионисэстус"}
    {en = "Casoneus", ru = "Касонеус"}
    {en = "Eusix", ru = "Эузикс"}
    {en = "Xenas", ru = "Ксенас"}
    {en = "Heristhus", ru = "Херистус"}
    {en = "Iphicrastus", ru = "Ификрастус"}
    {en = "Caesixus", ru = "Кайзиксус"}
    {en = "Sotus", ru = "Сотус"}
    {en = "Isocritus", ru = "Изокритус"}
    {en = "Phrixous", ru = "Фриксоус"}
    {en = "Demophyx", ru = "Демофикс"}
    {en = "Achererus", ru = "Ахерерус"}
    {en = "Meniphymes", ru = "Менифимес"}
    {en = "Galixiche", ru = "Галиксиче"}
    {en = "Theleleia", ru = "Телeлeйя"}
    {en = "Acoseila", ru = "Акосейла"}
    {en = "Amathissis", ru = "Аматиссис"}
    {en = "Sagaxise", ru = "Сагаксизе"}
    {en = "Olithanthe", ru = "Олитанте"}
    {en = "Olitheshi", ru = "Олитеши"}
    {en = "Aphisia", ru = "Афизия"}
    {en = "Saphiphoia", ru = "Сафифойя"}
    {en = "Savareris", ru = "Саварерис"}
    {en = "Mathessei", ru = "Матессей"}
    {en = "Hyseithe", ru = "Хизейте"}
    {en = "Galixeasi", ru = "Галиксеази"}
    {en = "Amathiphise", ru = "Аматифизе"}
    {en = "Bathithea", ru = "Батитея"}
    {en = "Prosenis", ru = "Просенис"}
    {en = "Mystice", ru = "Мистике"}
    {en = "Pasose", ru = "Пасозе"}
    {en = "Lithusi", ru = "Литуси"}
    {en = "Sinesi", ru = "Синеси"}
    {en = "Lephaxise", ru = "Лефаксизе"}
    {en = "Selanise", ru = "Селанизе"}
    {en = "Axiphisei", ru = "Аксифизей"}
    {en = "Thalalise", ru = "Тхалализе"}
    {en = "Sagethia", ru = "Сагетия"}
    {en = "Phalalphia", ru = "Фалалфия"}
    {en = "Thanohsa", ru = "Тханохса"}
    {en = "Chalertes", ru = "Халертес"}
    {en = "Nethithea", ru = "Нетитея"}
    {en = "Shaggaruth", ru = "Шаггарут"}
    {en = "Thohochoth", ru = "Тхохохот"}
    {en = "Naccorath", ru = "Наккорат"}
    {en = "Xapocathlu", ru = "Ксапокатлу"}
    {en = "the Grand Devourer", ru = "Великий Пожиратель"}
    {en = "the All-Ender", ru = "Завершитель Всего"}
    {en = "the Unending", ru = "Бесконечный"}
    {en = "the Endless Maw", ru = "Бесконечная Пасть"}
    {en = "the Thousand-Armed Thresher", ru = "Тысячерукий Молотильщик"}
    {en = "the Gorger of All", ru = "Пожирающий Всё"}
    {en = "the Eater of Worlds", ru = "Пожиратель Миров"}
    {en = "the Eternal", ru = "Вечный"}
    {en = "the All-Reaching", ru = "Всеохватный"}
    // FILE: mod_champion_beasts/hooks/entity/tactical/enemies/ghost.nut
    // en = "player"
    // FILE: scripts/!mods_preload/!register_mod_nggh_champion_beasts.nut
    {en = "Champion Beasts", ru = "Звери-Чемпионы"}
    // FILE: scripts/items/accessory/named/nggh_mod_named_accessory.nut
    // en = "image"
    {
        // text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + (::Math.floor(this.m.DamageMult * 100) - 100) + "%[/color] Damage to Hitpoints"
        mode = "pattern"
        en = "<bonus:val_tag> Damage to Hitpoints"
        ru = "<bonus> Урон по здоровью"
    }
    {
        // text = "[color=" + ::Const.UI.Color.PositiveValue + "]+" + (::Math.floor(this.m.ArmorDamageMult * 100) - 100) + "%[/color] Damage to Armor"
        mode = "pattern"
        en = "<bonus:val_tag> Damage to Armor"
        ru = "<bonus> Урон по броне"
    }
    // en = "randomname"
    // en = "randomsouthernname"
    // en = "randomtown"
    {
        // return this.getRandomCharacterName(::Const.Strings.KnightNames) + "\'s " + ::MSU.Array.rand(this.m.NameList);
        mode = "pattern"
        en = "<name:str>'s <item:str>"
        ru = "<item:t> <name>"
    }
    // FILE: scripts/items/accessory/named/nggh_mod_named_alp_trophy_item.nut
    {
        en = "Alp Trophy Necklace"
        ru = "Ожерелье из Трофеев Альпа"
    }
    {
        en = "Trophy Necklace"
        ru = "Ожерелье из Трофеев"
    }
    {
        en = "This necklace fashioned from trophies taken of the most powerful Alp declares the one wearing it a veteran of battle against supernatural nocturnal predators, and not easily daunted."
        ru = "Это ожерелье из трофеев сильнейшего Альпа говорит о том, что носящий его — бывалый воин в схватках со сверхъестественными ночными хищниками, которого нелегко запугать."
    }
    // FILE: scripts/items/accessory/named/nggh_mod_named_ghoul_trophy_item.nut
    {
        en = "Nachzehrer Trophy Necklace"
        ru = "Ожерелье из Трофеев Нахцерера"
    }
    {
        en = "This necklace fashioned from trophies taken of the strongest Nachzehrer declares the one wearing it a veteran of battle against feral beasts, and not easily daunted."
        ru = "Это ожерелье из трофеев сильнейшего Нахцерера говорит о том, что носящий его — бывалый воин в схватках с дикими зверями, которого нелегко запугать."
    }
    // FILE: scripts/items/armor_upgrades/named/nggh_mod_named_bone_platings_upgrade.nut
    {
        en = "Bone Plating"
        ru = "Костяные Пластины"
    }
    {
        en = "Crafted from strong but surprisingly light bones, these ornate platings make for an ablative armor to be worn ontop of regular armor."
        ru = "Изготовленные из крепких, но на удивление лёгких костей, эти украшенные пластины служат дополнительным бронированием поверх обычных доспехов."
    }
    {
        en = "A layer of ornate bone plates is attached to this armor."
        ru = "К этим доспехам прикреплён слой украшенных костяных пластин."
    }
    {
        // text = "Can Completely absorb " + (this.m.SpecialValue > 1 ? "up to [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.SpecialValue + "[/color] hits" : "[color=" + ::Const.UI.Color.NegativeValue + "]1[/color] hit") + " of every combat encounter which doesn\'t ignore armor"
        mode = "pattern"
        en = "Can Completely absorb up to <n:int_tag> hits of every combat encounter which doesn't ignore armor"
        ru = "Полностью поглощает до <n> ударов в каждом бою, не игнорирующих броню"
    }
    {
        // text = "Can Completely absorb " + (this.m.SpecialValue > 1 ? "up to [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.SpecialValue + "[/color] hits" : "[color=" + ::Const.UI.Color.NegativeValue + "]1[/color] hit") + " of every combat encounter which doesn\'t ignore armor"
        mode = "pattern"
        en = "Can Completely absorb <n:int_tag> hit of every combat encounter which doesn't ignore armor"
        ru = "Полностью поглощает <n> удар в каждом бою, не игнорирующий броню"
    }

    {
        en = "Damage absorbed by Bone Plating"
        ru = "Урон, поглощённый Костяными Пластинами"
    }
    // FILE: scripts/items/armor_upgrades/named/nggh_mod_named_direwolf_pelt_upgrade.nut
    {
        en = "Pelt Mantle"
        ru = "Шкурная Накидка"
    }
    {
        en = "Pelts taken from ferocious direwolves, cured and sewn together to be worn as a beast hunter's trophy around the neck. Donning the skin of a beast like this can turn one into an imposing figure."
        ru = "Шкуры свирепых лютоволков, выделанные и сшитые — трофей охотника на зверей, носимый на шее. В шкуре такого зверя можно выглядеть весьма внушительно."
    }
    {
        en = "A mantle of direwolf pelts has been attached to this armor, which transforms the wearer into an imposing figure."
        ru = "К этим доспехам прикреплена накидка из шкур лютоволков, делающая владельца внушительной фигурой."
    }
    {
        // text = "Reduces the Resolve of any opponent engaged in melee by [color=" + ::Const.UI.Color.NegativeValue + "]-" + this.m.SpecialValue + "[/color]"
        mode = "pattern"
        en = "Reduces the Resolve of any opponent engaged in melee by <penalty:int_tag>"
        ru = "Снижает Решимость всех противников в ближнем бою на <penalty>"
    }
    // FILE: scripts/items/armor_upgrades/named/nggh_mod_named_horn_plate_upgrade.nut
    {
        en = "Horn Plate"
        ru = "Роговые Пластины"
    }
    {
        en = "These segments of horn plate are made from one of the hardest yet flexible materials nature has to offer. Worn over common armor, they can help to deflect incoming blows."
        ru = "Эти сегменты роговых пластин сделаны из одного из самых твёрдых и гибких материалов, что предлагает природа. Надетые поверх обычных доспехов, помогают отклонять удары."
    }
    {
        en = "Segments of horn plate provide additional protection."
        ru = "Сегменты роговых пластин обеспечивают дополнительную защиту."
    }
    {
        // text = "Reduces any melee damage to the body by [color=" + ::Const.UI.Color.NegativeValue + "]-" + this.m.SpecialValue + "%[/color]"
        mode = "pattern"
        en = "Reduces any melee damage to the body by <penalty:val_tag>"
        ru = "Снижает весь урон в ближнем бою по телу на <penalty>"
    }
    // FILE: scripts/items/armor_upgrades/named/nggh_mod_named_hyena_fur_upgrade.nut
    {
        en = "Fur Mantle"
        ru = "Меховая Накидка"
    }
    {
        en = "Furs taken from ferocious hyenas, cured and sewn together to be worn as a beast hunter's trophy around the neck. Donning the skin of a beast like this bolsters one's drive to action."
        ru = "Шкуры свирепых гиен, выделанные и сшитые — трофей охотника на зверей, носимый на шее. В шкуре такого зверя невольно хочется действовать напористее."
    }
    {
        en = "A mantle of hyena furs has been attached to this armor, which bolsters the wearer's drive to action."
        ru = "К этим доспехам прикреплена меховая накидка из шкур гиен, придающая владельцу напористости."
    }
    // FILE: scripts/items/armor_upgrades/named/nggh_mod_named_light_padding_replacement_upgrade.nut
    {
        en = "Silk Padding"
        ru = "Шёлковая Подкладка"
    }
    {
        en = "Crafted from exotic materials, this replacement padding can provide the same amount of protection as regular padding at less weight."
        ru = "Изготовленная из экзотических материалов, эта подкладка обеспечивает такую же защиту, как обычная, но весит меньше."
    }
    {
        en = "This armor has its padding replaced by a lighter but no less durable one."
        ru = "Подкладка этих доспехов заменена на более лёгкую, но не менее прочную."
    }
    {
        // text = "Reduces an armor\'s penalty to Maximum Fatigue by [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.SpecialValue + "%[/color]"
        mode = "pattern"
        en = "Reduces an armor's penalty to Maximum Fatigue by <penalty:val_tag>"
        ru = "Снижает штраф доспехов к Максимальной усталости на <penalty>"
    }
    // FILE: scripts/items/armor_upgrades/named/nggh_mod_named_lindwurm_scales_upgrade.nut
    {
        en = "Scale Cloak"
        ru = "Плащ из Чешуи"
    }
    {
        en = "A cloak made out of the scales of a Lindwurm. Not only is it a rare and impressive trophy, it also offers additional protection and is untouchable by corroding Lindwurm blood."
        ru = "Плащ из чешуи Линдвурма. Редкий и впечатляющий трофей, обеспечивающий дополнительную защиту и невосприимчивый к разъедающей крови Линдвурма."
    }
    {
        en = "A cloak made out of Lindwurm scales is worn over this armor for additional protection, including from the corrosive effects of Lindwurm blood."
        ru = "Поверх этих доспехов надет плащ из чешуи Линдвурма для дополнительной защиты, в том числе от разъедающего действия крови Линдвурма."
    }
    {
        en = "Unaffected by acidic Lindwurm blood"
        ru = "Невосприимчив к кислотной крови Линдвурма"
    }
    // FILE: scripts/items/armor_upgrades/named/nggh_mod_named_serpent_skin_upgrade.nut
    {
        en = "Skin Mantle"
        ru = "Накидка из Кожи"
    }
    {
        en = "A mantle crafted from the thin and shimmering scales of desert serpents, especially resistant to heat and flames."
        ru = "Накидка из тонкой переливчатой чешуи пустынных змей, особенно устойчивой к жару и огню."
    }
    {
        en = "A mantle of serpent skin has been attached to this armor, which makes it more resistant to heat and flames."
        ru = "К этим доспехам прикреплена накидка из кожи змея, делающая их более устойчивыми к жару и огню."
    }
    {
        // text = "Reduces damage from fire and firearms by [color=" + ::Const.UI.Color.NegativeValue + "]33%[/color]"
        mode = "pattern"
        en = "Reduces damage from fire and firearms by <val:val_tag>"
        ru = "Снижает урон от огня и огнестрельного оружия на <val>"
    }
    // FILE: scripts/items/armor_upgrades/named/nggh_mod_named_unhold_fur_upgrade.nut
    {
        en = "Fur Cloak"
        ru = "Меховой Плащ"
    }
    {
        en = "A thick cloak made out of a Frost Unhold's majestic white fur. Can be worn atop any armor to make the wearer more resilient against ranged weapons."
        ru = "Толстый плащ из великолепного белого меха Ледяного Унхольда. Надевается поверх любых доспехов и делает владельца более устойчивым к дальнобойному оружию."
    }
    {
        en = "A cloak of thick white fur has been attached to this armor to make it more resilient against ranged weapons."
        ru = "К этим доспехам прикреплён плащ из густого белого меха, повышающий устойчивость к дальнобойному оружию."
    }
    {
        // text = "Reduces any ranged damage to the body by [color=" + ::Const.UI.Color.NegativeValue + "]-" + this.m.SpecialValue + "%[/color]"
        mode = "pattern"
        en = "Reduces any ranged damage to the body by <penalty:val_tag>"
        ru = "Снижает весь урон от дальнобойного оружия по телу на <penalty>"
    }
    // FILE: scripts/items/shields/named/mod_nggh_named_schrat_shield.nut
    {en = "Shield", ru = "Щит"}
    {en = "Protector", ru = "Защитник"}
    {en = "Board", ru = "Доска"}
    {en = "Wall", ru = "Стена"}
    {en = "Cover", ru = "Прикрытие"}
    {en = "Bark", ru = "Кора"}
    {en = "Guardian", ru = "Хранитель"}
    {en = "Defender", ru = "Защитник"}
    {en = "Barricade", ru = "Баррикада"}
    {en = "Barrier", ru = "Барьер"}
    {en = "Bastion", ru = "Бастион"}
    {en = "Fortress", ru = "Крепость"}
    {en = "Guard", ru = "Страж"}
    {en = "Rampart", ru = "Вал"}
    {en = "Keeper", ru = "Хранитель"}
    {en = "Warden", ru = "Страж"}
    {en = "Carapace", ru = "Панцирь"}
    {
        en = "This shield was used by a living tree to defend against your attacks. A great trophy from a great battle, and is also quite light for its size. By holding it on your hand, you somehow feel safe and calm."
        ru = "Этот щит использовало живое дерево для защиты от ваших атак. Отличный трофей из великого сражения, к тому же довольно лёгкий для своих размеров. Держа его в руке, вы почему-то чувствуете себя в безопасности и спокойствии."
    }
    {
        // text = "Takes [color=" + ::Const.UI.Color.PositiveValue + "]33%[/color] less damage from piercing attacks."
        mode = "pattern"
        en = "Takes <val:val_tag> less damage from piercing attacks."
        ru = "Получает на <val> меньше урона от колющих атак."
    }
    // FILE: scripts/skills/actives/nggh_mod_spit_acid_skill.nut
    {
        en = "Spit Acidic Blood"
        ru = "Плюнуть Кислотной Кровью"
    }
    {
        en = "Use your own acidic blood as a ranged attack by spitting it at your target. Be careful it can easily splash to others nearby."
        ru = "Используйте собственную кислотную кровь как дальнобойную атаку, плюнув ею в цель. Осторожно — она легко может забрызгать находящихся рядом."
    }
    {
        // text = "Costs [color=" + ::Const.UI.Color.NegativeValue + "]" + this.m.HpCost + "[/color] hitpoints to use"
        mode = "pattern"
        en = "Costs <cost:int_tag> hitpoints to use"
        ru = "Расход <cost> ОЗ при использовании"
    }
    {
        // text = "Has a range of [color=" + ::Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
        mode = "pattern"
        en = "Has a range of <range:int_tag> tiles"
        ru = "Дальность <range> клеток"
    }
    {
        // text = "Reduces the target\'s armor by [color=" + ::Const.UI.Color.DamageValue + "]20%[/color] each turn for 3 turns."
        mode = "pattern"
        en = "Reduces the target's armor by <val:val_tag> each turn for 3 turns."
        ru = "Снижает броню цели на <val> за ход в течение 3 ходов."
    }
    {
        // text = "Has a [color=" + ::Const.UI.Color.DamageValue + "]50%[/color] chance to hit bystanders at the same or lower height level as well."
        mode = "pattern"
        en = "Has a <chance:val_tag> chance to hit bystanders at the same or lower height level as well."
        ru = "С вероятностью <chance> попадает и по стоящим рядом на том же уровне или ниже."
    }
    {
        // text = "[color=" + ::Const.UI.Color.DamageValue + "]Your health is low[/color]."
        mode = "pattern"
        en = "<open:tag>Your health is low<close:tag>."
        ru = "<open>Ваше здоровье на исходе<close>."
    }
    // FILE: scripts/skills/effects/nggh_mod_ghost_debuff_effect.nut
    {
        en = "Ooooh! You Have Been Spooked"
        ru = "Уууу! Тебя напугали"
    }
    // FILE: scripts/skills/perks/perk_nggh_true_nine_lives.nut
    {
        // return ret + " (" + this.m.NineLivesCount + " life left)"
        mode = "pattern"
        plural = "n"
        en = "<ret:str> (<n:int> life left)"
        n1 = "<ret> (<n> жизнь осталась)"
        n2 = "<ret> (<n> жизни осталось)"
        n5 = "<ret> (<n> жизней осталось)"
    }
    {
        // return ret + " (" + this.m.NineLivesCount + " lives left)"
        mode = "pattern"
        plural = "n"
        en = "<ret:str> (<n:int> lives left)"
        n1 = "<ret> (<n> жизнь осталась)"
        n2 = "<ret> (<n> жизни осталось)"
        n5 = "<ret> (<n> жизней осталось)"
    }
    {
        // this.m.Name = "True " + ::Const.Strings.PerkName.NineLives;
        mode = "pattern"
        en = "True <name:str>"
        ru = "Настоящие <name:t>"
    }
    {
        en = "This character has nine lives, thus, allowing them to survive through 8 fatal attacks."
        ru = "У этого персонажа девять жизней — он способен пережить 8 смертельных ударов."
    }
    {
        // text = "Extra life left: [color=" + ::Const.UI.Color.PositiveValue + "]" + this.m.NineLivesCount + "[/color]"
        mode = "pattern"
        en = "Extra life left: <n:int_tag>"
        ru = "Осталось жизней: <n>"
    }
    // FILE: scripts/skills/special/nggh_mod_champion_loot.nut
    {
        // item.m.Name = actor.getName() + "\'s Scale";
        mode = "pattern"
        en = "<name:str>'s Scale"
        ru = "Чешуя <name>"
    }
]
::Rosetta.add(rosetta, pairs);
