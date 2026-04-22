if (!("Rosetta" in getroottable())) return;

local rosetta = {
    mod = {id = "mod_camps_and_artifacts", version = "3.5.2"}
    author = "hackflow"
    lang = "ru"
}
local pairs = [
    // FILE: camps_and_artifacts/config/item_names.nut
    // --- Axe names ---
    {
        en = "Skullrender"
        ru = "Раздроб Черепов"
    }
    {
        en = "Guttler"
        ru = "Гуттлер"
    }
    {
        en = "Ogre Bane"
        ru = "Погибель Огров"
    }
    {
        en = "Juggernaut"
        ru = "Джаггернаут"
    }
    {
        en = "Ragnar's Call"
        ru = "Зов Рагнара"
    }
    {
        en = "Gorefiend"
        ru = "Кровавый Демон"
    }
    {
        en = "Star Hewer"
        ru = "Небесный Рубила"
    }
    {
        en = "Reaper"
        ru = "Жнец"
    }
    {
        en = "Headsman"
        ru = "Палач"
    }
    {
        en = "Bravura"
        ru = "Бравура"
    }
    // --- Whip names ---
    {
        en = "The Golden Lasso"
        ru = "Золотое Лассо"
    }
    {
        en = "Discipline"
        ru = "Дисциплина"
    }
    {
        en = "Lion Tamer"
        ru = "Укротитель Львов"
    }
    {
        en = "Qilinbian"
        ru = "Цилиньбянь"
    }
    {
        en = "Scourge"
        ru = "Бич"
    }
    // --- Polearm names ---
    {
        en = "The Whirlwind"
        ru = "Вихрь"
    }
    {
        en = "Bec de Corbin"
        ru = "Клюв Ворона"
    }
    {
        en = "Bohemian Earspoon"
        ru = "Богемский Шпиль"
    }
    {
        en = "Thalassocrat"
        ru = "Владыка Морей"
    }
    {
        en = "Gae Bolg"
        ru = "Гэ Болг"
    }
    {
        en = "Gae Derg"
        ru = "Гэ Дерг"
    }
    {
        en = "Amenonuhoko"
        ru = "Аменонухоко"
    }
    {
        en = "Gungnir"
        ru = "Гунгнир"
    }
    {
        en = "Rhongomyniad"
        ru = "Ронгомийниад"
    }
    {
        en = "Vel"
        ru = "Вель"
    }
    // --- Sword names ---
    {
        en = "Excalibur"
        ru = "Экскалибур"
    }
    {
        en = "Joyeuse"
        ru = "Жуайёз"
    }
    {
        en = "Greyswandir"
        ru = "Грейсвандир"
    }
    {
        en = "Orcrist"
        ru = "Оркрист"
    }
    {
        en = "Durandal"
        ru = "Дюрандаль"
    }
    {
        en = "Arondright"
        ru = "Арондрайт"
    }
    {
        en = "Amanomurakumo"
        ru = "Аманомуракумо"
    }
    {
        en = "Dragnipur"
        ru = "Драгнипур"
    }
    {
        en = "Callandor"
        ru = "Калландор"
    }
    {
        en = "Ice"
        ru = "Лёд"
    }
    {
        en = "Glamdrang"
        ru = "Гламдранг"
    }
    {
        en = "Narsil"
        ru = "Нарсил"
    }
    {
        en = "Balmung"
        ru = "Балмунг"
    }
    {
        en = "Hrondil"
        ru = "Хрондил"
    }
    {
        en = "Caliburn"
        ru = "Калибурн"
    }
    {
        en = "Ridill"
        ru = "Ридиль"
    }
    {
        en = "Zenmetsu"
        ru = "Дзэнмэцу"
    }
    {
        en = "Almace"
        ru = "Альмас"
    }
    {
        en = "Burtgang"
        ru = "Бюртганг"
    }
    {
        en = "Ragnarok"
        ru = "Рагнарёк"
    }
    {
        en = "Lionheart"
        ru = "Львиное Сердце"
    }
    {
        en = "Humility"
        ru = "Смирение"
    }
    {
        en = "Gram"
        ru = "Грам"
    }
    {
        en = "Buster Sword"
        ru = "Разрубатель"
    }
    {
        en = "Tizona"
        ru = "Тисона"
    }
    {
        en = "Calada"
        ru = "Калада"
    }
    {
        en = "Chrysaor"
        ru = "Хрисаор"
    }
    {
        en = "Fragarach"
        ru = "Фрагарах"
    }
    {
        en = "Clarent"
        ru = "Кларент"
    }
    {
        en = "Coreiseuse"
        ru = "Корейёз"
    }
    {
        en = "Secace"
        ru = "Секас"
    }
    {
        en = "Courtain"
        ru = "Куртен"
    }
    {
        en = "Tyrfing"
        ru = "Тюрфинг"
    }
    {
        en = "Hauteclaire"
        ru = "Отклэр"
    }
    {
        en = "Harpe"
        ru = "Харпэ"
    }
    // --- Crossbow names ---
    {
        en = "Hellrack"
        ru = "Адская Стойка"
    }
    {
        en = "Buriza-Do Kyanon"
        ru = "Буриза-До Кьянон"
    }
    {
        en = "Demon Machine"
        ru = "Машина Демонов"
    }
    {
        en = "Gastraphetes"
        ru = "Гастрафет"
    }
    {
        en = "Reason"
        ru = "Разум"
    }
    {
        en = "Imati"
        ru = "Имати"
    }
    {
        en = "Illap"
        ru = "Иллап"
    }
    // --- Dagger names ---
    {
        en = "Athame"
        ru = "Атамэ"
    }
    {
        en = "Carnwennan"
        ru = "Карнвеннан"
    }
    {
        en = "Parazonium"
        ru = "Паразоний"
    }
    {
        en = "Misericorde"
        ru = "Мизерикорд"
    }
    {
        en = "Mandau"
        ru = "Мандау"
    }
    {
        en = "Golad"
        ru = "Голад"
    }
    {
        en = "Tiriosh"
        ru = "Тириош"
    }
    {
        en = "Kingslayer"
        ru = "Убийца Королей"
    }
    // --- Flail names ---
    {
        en = "Holy Water Sprinkler"
        ru = "Кропило"
    }
    {
        en = "Stormlash"
        ru = "Удар Бури"
    }
    {
        en = "Golden Flence"
        ru = "Золотое Бичевание"
    }
    {
        en = "Cranium Basher"
        ru = "Дробитель Черепов"
    }
    // --- Throwing names ---
    {
        en = "Thunderbolt"
        ru = "Удар Грома"
    }
    {
        en = "Tathlum"
        ru = "Татлум"
    }
    {
        en = "Sagitta"
        ru = "Сагитта"
    }
    {
        en = "Kenkonken"
        ru = "Кэнконкэн"
    }
    {
        en = "Vajra"
        ru = "Ваджра"
    }
    // --- Mace names ---
    {
        en = "Echoing Fury"
        ru = "Эхо Ярости"
    }
    {
        en = "Asclepius"
        ru = "Асклепий"
    }
    {
        en = "Gada"
        ru = "Гада"
    }
    {
        en = "Caduceus"
        ru = "Кадуцей"
    }
    {
        en = "Was"
        ru = "Уас"
    }
    {
        en = "The Silver Hand"
        ru = "Серебряная Рука"
    }
    {
        en = "Shillelagh"
        ru = "Шилела"
    }
    // --- Orc weapon names ---
    {
        en = "Mancarver"
        ru = "Человекокрой"
    }
    {
        en = "Slash"
        ru = "Рубака"
    }
    {
        en = "Skitch"
        ru = "Скитч"
    }
    {
        en = "Gash"
        ru = "Зияло"
    }
    {
        en = "Gitsnick"
        ru = "Гитсник"
    }
    {
        en = "Karg"
        ru = "Карг"
    }
    {
        en = "Crack"
        ru = "Ломан"
    }
    {
        en = "Crunch"
        ru = "Хрустан"
    }
    {
        en = "Smish"
        ru = "Смиш"
    }
    // --- Spear names ---
    {
        en = "Aram"
        ru = "Арам"
    }
    {
        en = "Longinus"
        ru = "Лонгин"
    }
    {
        en = "Rhongomiant"
        ru = "Ронгомиант"
    }
    {
        en = "Areadbhar"
        ru = "Ареадхар"
    }
    {
        en = "Crann Buidhe"
        ru = "Кранн Буй"
    }
    {
        en = "Gae Assail"
        ru = "Гэ Ассайл"
    }
    {
        en = "Nihongo"
        ru = "Нихонго"
    }
    // --- Hammer names ---
    {
        en = "Mjollnir"
        ru = "Мьёльнир"
    }
    {
        en = "Ukonvasara"
        ru = "Уконвасара"
    }
    {
        en = "Steeldriver"
        ru = "Стальной Молот"
    }
    {
        en = "The Furnace"
        ru = "Горнило"
    }
    {
        en = "Sunder"
        ru = "Раздробитель"
    }
    {
        en = "Doom Hammer"
        ru = "Молот Рока"
    }
    {
        en = "Ironfoe"
        ru = "Железный Враг"
    }
    {
        en = "Stormherald"
        ru = "Вестник Бури"
    }
    {
        en = "Storm's End"
        ru = "Конец Бури"
    }
    // --- Bow names ---
    {
        en = "Eurytos"
        ru = "Эврит"
    }
    {
        en = "Artemis"
        ru = "Артемида"
    }
    {
        en = "Houyi"
        ru = "Хоу И"
    }
    {
        en = "Eros"
        ru = "Эрос"
    }
    {
        en = "Rhok'delar"
        ru = "Рок'делар"
    }
    {
        en = "Heartstriker"
        ru = "Сердцебойца"
    }
    {
        en = "Yoichinoyumi"
        ru = "Ёитиноюми"
    }
    {
        en = "Loxley"
        ru = "Локсли"
    }
    // --- Shield names ---
    {
        en = "Aegis"
        ru = "Эгида"
    }
    {
        en = "Hoplon"
        ru = "Гоплон"
    }
    {
        en = "Ancile"
        ru = "Анцилий"
    }
    {
        en = "Pridwen"
        ru = "Придвен"
    }
    {
        en = "Evalach"
        ru = "Эвалах"
    }
    {
        en = "Svalinn"
        ru = "Свалинн"
    }
    {
        en = "Bulwark"
        ru = "Оплот"
    }
    {
        en = "Ward"
        ru = "Страж"
    }
    // --- Orc shield names ---
    {
        en = "Clang"
        ru = "Брякало"
    }
    {
        en = "Pillar"
        ru = "Столп"
    }
    {
        en = "No"
        ru = "Нет"
    }
    {
        en = "Grunt"
        ru = "Хрюк"
    }
    {
        en = "Gork"
        ru = "Горк"
    }

    // FILE: camps_and_artifacts/entity/world/locations/orc_fortress_location.nut
    {
        // this.m.Name = "Fortress " + this.World.EntityManager.getUniqueLocationName(this.Const.World.LocationNames.OrcCamp);
        mode = "pattern"
        en = "Fortress <name:str>"
        ru = "Крепость <name>"
    }
    // FILE: scripts/!mods_preload/mod_camps_and_artifacts.nut
    // en = "Camps and Artifacts (Reworked)"
    // en = "camps:artifact_name:"
    {
        en = "Artifact"
        ru = "Артефакт"
    }
    // FILE: scripts/entity/world/locations/bandit_usurper_location.nut
    {
        en = "The bastard son of some noble has taken up residence in this abandoned stronghold.  He is raising an army to invade the civilized lands."
        ru = "Незаконнорождённый сын какого-то дворянина обосновался в этой заброшенной крепости. Он собирает армию, чтобы вторгнуться в обжитые земли."
    }
    {
        // this.m.Name = "New " + this.World.EntityManager.getUniqueLocationName([
        //  "Hohenfeste",
        //  "Wolfenfeste",
        //  "Wolfenstein",
        //  "Felsfeste",
        //  "Eisenfeste",
        //  "Grollfeste",
        //  "Grubenfeste",
        //  "Donnerfeste",
        //  "Erzfeste",
        //  "Gronenfeste",
        //  "Sattelfeste",
        //  "Kammfeste",
        //  "Turmfeste",
        //  "Windfeste",
        //  "Adlerfeste",
        //  "Brunwald",
        //  "Heldenfeste",
        //  "Wurmfeste",
        //  "Schwertfeste",
        //  "Lanzenfeste",
        //  "Falkenstein",
        //  "Flechtenstein",
        //  "Himmelsfeste",
        //  "Steinturm",
        //  "Gipfelfeste",
        //  "Zugfeste",
        //  "Granitfeste",
        //  "Zinnenfeste",
        //  "Wackersfeste",
        //  "Fernsichtfeste",
        //  "Wildbergfeste"
        // ]);
        mode = "pattern"
        en = "New <name:str>"
        ru = "Новый <name:t>"
    }
    { en = "Hohenfeste"     ru = "Хоэнфесте" }
    { en = "Wolfenfeste"    ru = "Вольфенфесте" }
    { en = "Wolfenstein"    ru = "Вольфенштайн" }
    { en = "Felsfeste"      ru = "Фельсфесте" }
    { en = "Eisenfeste"     ru = "Айзенфесте" }
    { en = "Grollfeste"     ru = "Гроллфесте" }
    { en = "Grubenfeste"    ru = "Грубенфесте" }
    { en = "Donnerfeste"    ru = "Доннерфесте" }
    { en = "Erzfeste"       ru = "Эрцфесте" }
    { en = "Gronenfeste"    ru = "Гроненфесте" }
    { en = "Sattelfeste"    ru = "Заттельфесте" }
    { en = "Kammfeste"      ru = "Каммфесте" }
    { en = "Turmfeste"      ru = "Турмфесте" }
    { en = "Windfeste"      ru = "Виндфесте" }
    { en = "Adlerfeste"     ru = "Адлерфесте" }
    { en = "Brunwald"       ru = "Брунвальд" }
    { en = "Heldenfeste"    ru = "Хельденфесте" }
    { en = "Wurmfeste"      ru = "Вурмфесте" }
    { en = "Schwertfeste"   ru = "Швертфесте" }
    { en = "Lanzenfeste"    ru = "Ланценфесте" }
    { en = "Falkenstein"    ru = "Фалькенштайн" }
    { en = "Flechtenstein"  ru = "Флехтенштайн" }
    { en = "Himmelsfeste"   ru = "Химмельсфесте" }
    { en = "Steinturm"      ru = "Штайнтурм" }
    { en = "Gipfelfeste"    ru = "Гипфельфесте" }
    { en = "Zugfeste"       ru = "Цугфесте" }
    { en = "Granitfeste"    ru = "Гранитфесте" }
    { en = "Zinnenfeste"    ru = "Цинненфесте" }
    { en = "Wackersfeste"   ru = "Ваккерсфесте" }
    { en = "Fernsichtfeste" ru = "Фернзихтфесте" }
    { en = "Wildbergfeste"  ru = "Вильдбергфесте" }
    // FILE: scripts/entity/world/locations/barbarian_sacred_grove_location.nut
    {
        en = "One of the sacred pillars of the barbarian tribes.  The greatest warriors of the north will defend this site if it is threatened."
        ru = "Одна из священных святынь варварских племён. Величайшие воины севера встанут на её защиту."
    }
    {
        // this.m.Name = "Sacred " + this.World.EntityManager.getUniqueLocationName(this.Const.World.LocationNames.BarbarianSanctuary);
        mode = "pattern"
        en = "Sacred <name:str>"
        ru = "Священный <name>"
    }
    // FILE: scripts/entity/world/locations/citystate_barracks_location.nut
    {
        en = "A barracks of the noble houses, with a regiment of troops training in the yard."
        ru = "Казармы благородных домов, где во дворе тренируется полк солдат."
    }
    {
        // this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.SouthernOfficerTitles) + this.World.EntityManager.getUniqueLocationName([
        //  "'s Camp",
        //  "'s Rest",
        //  "'s Barracks",
        //  "'s Muster"
        //  ]);
        mode = "pattern"
        en = "<name:str>'s Camp"
        ru = "Лагерь <name>"
    }
    {
        // this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.SouthernOfficerTitles) + this.World.EntityManager.getUniqueLocationName([
        //  "'s Camp",
        //  "'s Rest",
        //  "'s Barracks",
        //  "'s Muster"
        //  ]);
        mode = "pattern"
        en = "<name:str>'s Rest"
        ru = "Стоянка <name>"
    }
    {
        // this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.SouthernOfficerTitles) + this.World.EntityManager.getUniqueLocationName([
        //  "'s Camp",
        //  "'s Rest",
        //  "'s Barracks",
        //  "'s Muster"
        //  ]);
        mode = "pattern"
        en = "<name:str>'s Barracks"
        ru = "Казармы <name>"
    }
    {
        // this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.SouthernOfficerTitles) + this.World.EntityManager.getUniqueLocationName([
        //  "'s Camp",
        //  "'s Rest",
        //  "'s Barracks",
        //  "'s Muster"
        //  ]);
        mode = "pattern"
        en = "<name:str>'s Muster"
        ru = "Сбор <name>"
    }
    // FILE: scripts/entity/world/locations/citystate_stronghold_location.nut
    {
        en = "A stronghold of the noble houses.  An army waits behind its gates and untold riches in its keep"
        ru = "Твердыня благородных домов. За воротами ждёт армия, а в башне хранятся несметные богатства."
    }
    {
        // this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.SouthernOfficerTitles) + this.World.EntityManager.getUniqueLocationName([
        //  "'s Bulwark",
        //  "'s Fortress",
        //  "'s Holdfast",
        //  "'s Castle"
        //  ]);
        mode = "pattern"
        en = "<name:str>'s Bulwark"
        ru = "Бастион <name>"
    }
    {
        // this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.SouthernOfficerTitles) + this.World.EntityManager.getUniqueLocationName([
        //  "'s Bulwark",
        //  "'s Fortress",
        //  "'s Holdfast",
        //  "'s Castle"
        //  ]);
        mode = "pattern"
        en = "<name:str>'s Fortress"
        ru = "Крепость <name>"
    }
    {
        // this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.SouthernOfficerTitles) + this.World.EntityManager.getUniqueLocationName([
        //  "'s Bulwark",
        //  "'s Fortress",
        //  "'s Holdfast",
        //  "'s Castle"
        //  ]);
        mode = "pattern"
        en = "<name:str>'s Holdfast"
        ru = "Редут <name>"
    }
    {
        // this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.SouthernOfficerTitles) + this.World.EntityManager.getUniqueLocationName([
        //  "'s Bulwark",
        //  "'s Fortress",
        //  "'s Holdfast",
        //  "'s Castle"
        //  ]);
        mode = "pattern"
        en = "<name:str>'s Castle"
        ru = "Замок <name>"
    }
    // FILE: scripts/entity/world/locations/citystate_tower_location.nut
    {
        en = "A watchtower of the noble houses, the eyes by which the nobles keep watch over their lands"
        ru = "Сторожевая башня благородных домов — глаза, которыми дворяне следят за своими землями."
    }
    {
        // this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.SouthernOfficerTitles) + this.World.EntityManager.getUniqueLocationName([
        //  "'s Tower",
        //  "'s Post",
        //  "'s Watch",
        //  "'s Refuge"
        //  ]);
        mode = "pattern"
        en = "<name:str>'s Tower"
        ru = "Башня <name>"
    }
    {
        // this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.SouthernOfficerTitles) + this.World.EntityManager.getUniqueLocationName([
        //  "'s Tower",
        //  "'s Post",
        //  "'s Watch",
        //  "'s Refuge"
        //  ]);
        mode = "pattern"
        en = "<name:str>'s Post"
        ru = "Пост <name>"
    }
    {
        // this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.SouthernOfficerTitles) + this.World.EntityManager.getUniqueLocationName([
        //  "'s Tower",
        //  "'s Post",
        //  "'s Watch",
        //  "'s Refuge"
        //  ]);
        mode = "pattern"
        en = "<name:str>'s Watch"
        ru = "Вышка <name>"
    }
    {
        // this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.SouthernOfficerTitles) + this.World.EntityManager.getUniqueLocationName([
        //  "'s Tower",
        //  "'s Post",
        //  "'s Watch",
        //  "'s Refuge"
        //  ]);
        mode = "pattern"
        en = "<name:str>'s Refuge"
        ru = "Убежище <name>"
    }
    // FILE: scripts/entity/world/locations/goblin_warrens_location.nut
    {
        en = "A goblin warrens breaks ground here. An underground civilization spanning miles of tunnels stands ready to defend it."
        ru = "Здесь раскинулись гоблинские норы. Подземная цивилизация, протянувшаяся на мили туннелей, готова её защищать."
    }
    {
        // this.m.Name = "Great " + this.World.EntityManager.getUniqueLocationName(this.Const.World.LocationNames.GoblinBase);
        mode = "pattern"
        en = "Great <name:str>"
        ru = "Великий <name>"
    }
    // FILE: scripts/entity/world/locations/noble_barracks_location.nut
    {
        // this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.CharacterNames) + this.World.EntityManager.getUniqueLocationName([
        //  "'s Camp",
        //  "'s Rest",
        //  "'s Barracks",
        //  "'s Muster"
        //  ]);
        mode = "pattern"
        en = "<name:str>'s Camp"
        ru = "Лагерь <name>"
    }
    {
        // this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.CharacterNames) + this.World.EntityManager.getUniqueLocationName([
        //  "'s Camp",
        //  "'s Rest",
        //  "'s Barracks",
        //  "'s Muster"
        //  ]);
        mode = "pattern"
        en = "<name:str>'s Rest"
        ru = "Стоянка <name>"
    }
    {
        // this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.CharacterNames) + this.World.EntityManager.getUniqueLocationName([
        //  "'s Camp",
        //  "'s Rest",
        //  "'s Barracks",
        //  "'s Muster"
        //  ]);
        mode = "pattern"
        en = "<name:str>'s Barracks"
        ru = "Казармы <name>"
    }
    {
        // this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.CharacterNames) + this.World.EntityManager.getUniqueLocationName([
        //  "'s Camp",
        //  "'s Rest",
        //  "'s Barracks",
        //  "'s Muster"
        //  ]);
        mode = "pattern"
        en = "<name:str>'s Muster"
        ru = "Сбор <name>"
    }
    // FILE: scripts/entity/world/locations/noble_stronghold_location.nut
    {
        // this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.CharacterNames) + this.World.EntityManager.getUniqueLocationName([
        //  "'s Bulwark",
        //  "'s Fortress",
        //  "'s Holdfast",
        //  "'s Castle"
        //  ]);
        mode = "pattern"
        en = "<name:str>'s Bulwark"
        ru = "Бастион <name>"
    }
    {
        // this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.CharacterNames) + this.World.EntityManager.getUniqueLocationName([
        //  "'s Bulwark",
        //  "'s Fortress",
        //  "'s Holdfast",
        //  "'s Castle"
        //  ]);
        mode = "pattern"
        en = "<name:str>'s Fortress"
        ru = "Крепость <name>"
    }
    {
        // this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.CharacterNames) + this.World.EntityManager.getUniqueLocationName([
        //  "'s Bulwark",
        //  "'s Fortress",
        //  "'s Holdfast",
        //  "'s Castle"
        //  ]);
        mode = "pattern"
        en = "<name:str>'s Holdfast"
        ru = "Редут <name>"
    }
    {
        // this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.CharacterNames) + this.World.EntityManager.getUniqueLocationName([
        //  "'s Bulwark",
        //  "'s Fortress",
        //  "'s Holdfast",
        //  "'s Castle"
        //  ]);
        mode = "pattern"
        en = "<name:str>'s Castle"
        ru = "Замок <name>"
    }
    // FILE: scripts/entity/world/locations/noble_tower_location.nut
    {
        // this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.CharacterNames) + this.World.EntityManager.getUniqueLocationName([
        //  "'s Tower",
        //  "'s Post",
        //  "'s Watch",
        //  "'s Refuge"
        //  ]);
        mode = "pattern"
        en = "<name:str>'s Tower"
        ru = "Башня <name>"
    }
    {
        // this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.CharacterNames) + this.World.EntityManager.getUniqueLocationName([
        //  "'s Tower",
        //  "'s Post",
        //  "'s Watch",
        //  "'s Refuge"
        //  ]);
        mode = "pattern"
        en = "<name:str>'s Post"
        ru = "Пост <name>"
    }
    {
        // this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.CharacterNames) + this.World.EntityManager.getUniqueLocationName([
        //  "'s Tower",
        //  "'s Post",
        //  "'s Watch",
        //  "'s Refuge"
        //  ]);
        mode = "pattern"
        en = "<name:str>'s Watch"
        ru = "Вышка <name>"
    }
    {
        // this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.Strings.CharacterNames) + this.World.EntityManager.getUniqueLocationName([
        //  "'s Tower",
        //  "'s Post",
        //  "'s Watch",
        //  "'s Refuge"
        //  ]);
        mode = "pattern"
        en = "<name:str>'s Refuge"
        ru = "Убежище <name>"
    }
    // FILE: scripts/entity/world/locations/nomad_heretic_location.nut
    {
        en = "A heretic sect from the south; having established their own kingdom, it is only a matter of time before they move on the city-states."
        ru = "Еретическая секта с юга. Основав собственное царство, они рано или поздно двинутся на города-государства."
    }
    {
        // this.m.Name = "Heretic " + this.World.EntityManager.getUniqueLocationName(this.Const.World.LocationNames.NomadTentCity);
        mode = "pattern"
        en = "Heretic <name:str>"
        ru = "Еретический <name>"
    }
    // FILE: scripts/entity/world/locations/undead_damned_city_location.nut
    {
        en = "Once a thriving human settlement, this place has been defiled and fallen into ruin, turned into a necropolis of the undead. Waves of walking corpses pour forth to spread terror and fear in the surrounding lands."
        ru = "Некогда процветающее людское поселение осквернено и лежит в руинах, превращённое в некрополь нежити. Волны ходячих мертвецов расходятся отсюда, сея ужас в окрестных землях."
    }
    {
        // this.m.Name = this.World.EntityManager.getUniqueLocationName(this.Const.World.LocationNames.BuriedCastle) + " Exhumed";
        mode = "pattern"
        en = "<name:str> Exhumed"
        ru = "<name>, поднятый из мёртвых"
    }
    // FILE: scripts/items/ammo/artifact_ammo.nut
    // TODO: these concats don't really work
    {
        en = "Flaming "
        ru = "Пылающие "
    }
    {
        en = ", imbued with fire"
        ru = ", наполненные огнём"
    }
    {
        en = "Sets target tile on fire"
        ru = "Поджигает клетку цели"
    }
    {
        en = "Freezing "
        ru = "Ледяные "
    }
    {
        en = ", imbued with ice."
        ru = ", наполненные льдом."
    }
    {
        en = "Freezes target on hit"
        ru = "Замораживает цель при попадании"
    }
    {
        en = "Poisoned "
        ru = "Отравленные "
    }
    {
        en = ", coated in goblin poison."
        ru = ", покрытые гоблинским ядом."
    }
    {
        en = "Applies goblin poison on target hit"
        ru = "Отравляет цель гоблинским ядом"
    }
    {
        en = "Shocking "
        ru = "Оглушающие "
    }
    {
        en = ", dazing target on hit."
        ru = ", оглушающие цель при попадании."
    }
    {
        en = "Applies daze on target hit"
        ru = "Оглушает цель при попадании"
    }
    {
        en = "Jagged "
        ru = "Зазубренные "
    }
    {
        en = ", jagged to make them bleed."
        ru = ", зазубренные для кровотечения."
    }
    {
        en = "Applies bleeding on target hit"
        ru = "Вызывает кровотечение при попадании"
    }
    // en = "image"
    {
        // text = "Contains [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.Ammo + "[/color] arrows"
        mode = "pattern"
        en = "Contains <n:int_tag> arrows"
        ru = "Содержит <n> стрел"
    }
    // FILE: scripts/items/ammo/artifact_imbued_arrows.nut
    {
        en = "Arrows"
        ru = "Стрелы"
    }
    {
        en = "A quiver of arrows"
        ru = "Колчан стрел"
    }
    // en = "arrows"
    // en = "fire"
    // en = "ice"
    // en = "poison"
    // FILE: scripts/items/ammo/artifact_imbued_bolts.nut
    {
        en = "Bolts"
        ru = "Болты"
    }
    {
        en = "An quiver of bolts"
        ru = "Колчан болтов"
    }
    // en = "bolts"
    // FILE: scripts/items/ammo/artifact_powder_bag.nut
    {
        en = "Endless Powder Bag"
        ru = "Бездонный Мешок Пороха"
    }
    {
        en = "An endless bag of black powder, used for arming exotic firearms. Is automatically refilled after each battle if you have enough ammunition."
        ru = "Бездонный мешок чёрного пороха для зарядки редкого огнестрельного оружия. Автоматически пополняется после каждого боя, если у вас достаточно боеприпасов."
    }
    {
        // text = "Contains powder for [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.Ammo + "[/color] uses"
        mode = "pattern"
        en = "Contains powder for <n:int_tag> uses"
        ru = "Содержит порох для <n> выстрелов"
    }
    // FILE: scripts/items/ammo/artifact_quiver_of_arrows.nut
    {
        en = "Endless Quiver of Arrows"
        ru = "Бездонный Колчан Стрел"
    }
    {
        en = "An endless quiver of arrows, required to use bows of all kinds. Is automatically refilled after each battle if you have enough ammunition."
        ru = "Бездонный колчан стрел для луков всех видов. Автоматически пополняется после каждого боя, если у вас достаточно боеприпасов."
    }
    // FILE: scripts/items/ammo/artifact_quiver_of_bolts.nut
    {
        en = "Endless Quiver of Bolts"
        ru = "Бездонный Колчан Болтов"
    }
    {
        en = "An endless quiver of bolts, required to use crossbows. Is automatically refilled after each battle if you have enough ammunition."
        ru = "Бездонный колчан болтов для арбалетов. Автоматически пополняется после каждого боя, если у вас достаточно боеприпасов."
    }
    {
        // text = "Contains [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.Ammo + "[/color] bolts"
        mode = "pattern"
        en = "Contains <n:int_tag> bolts"
        ru = "Содержит <n> болтов"
    }
    // FILE: scripts/items/armor/artifact/artifact_armor.nut
    {
        en = "Glorious Quickness"
        ru = "Дивная Быстрота"
    }
    {
        en = "+1 Action Point"
        ru = "+1 Очко Действия"
    }
    {
        en = "+1 Vision"
        ru = "+1 Обзор"
    }
    {
        en = "Night Vision"
        ru = "Ночное Зрение"
    }
    {
        en = "Preternatural Dodge"
        ru = "Сверхъестественное Уклонение"
    }
    {
        en = "Regenerating"
        ru = "Регенерация"
    }
    {
        en = "+2 Fatigue Recovery"
        ru = "+2 Восстановление Выносливости"
    }
    {
        en = "Immune against fear and mind control abilities"
        ru = "Невосприимчив к страху и ментальному контролю"
    }
    {
        en = "Immunity to being rooted by nets or grasping vines"
        ru = "Невосприимчив к путам сетей и лиан"
    }
    {
        en = "Enables the Linebreaker skill"
        ru = "Открывает навык «Прорыв строя»"
    }
    // FILE: scripts/items/armor/artifact/artifact_black_leather_armor.nut
    {
        en = "Leather armor from a tough but supple beast hide that you cannot recognize, supported by a padded gambeson and chainmail. Light to wear but incredibly sturdy."
        ru = "Кожаный доспех из прочной, но мягкой шкуры неизвестного зверя, усиленный подбитым гамбезоном и кольчугой. Лёгкий в носке, но невероятно прочный."
    }
    {
        en = "Second Skin"
        ru = "Вторая Кожа"
    }
    {
        en = "Coldstream Guard"
        ru = "Страж Холодного Ручья"
    }
    {
        en = "Black Coat"
        ru = "Чёрный Кафтан"
    }
    {
        en = "Nightcloak"
        ru = "Плащ Ночи"
    }
    {
        en = "Vantablack"
        ru = "Вантаблэк"
    }
    {
        en = "Dark Omen"
        ru = "Мрачное Предзнаменование"
    }
    // en = "light"
    // FILE: scripts/items/armor/artifact/artifact_blue_studded_mail_armor.nut
    {
        en = "This silvery mail shirt is combined with a gambeson and covered with a tough, riveted leather jacket for a light yet exceedingly resilient armor."
        ru = "Серебристая кольчужная рубашка в сочетании с гамбезоном и прочной клёпаной кожаной курткой — лёгкий, но исключительно стойкий доспех."
    }
    {
        en = "Padded Mythril"
        ru = "Мифриловый Поддоспешник"
    }
    {
        en = "Impskin"
        ru = "Чертова Кожа"
    }
    {
        en = "Feyskin"
        ru = "Эльфийская Кожа"
    }
    // FILE: scripts/items/armor/artifact/artifact_brown_coat_of_plates_armor.nut
    {
        en = "A thick mail hauberk combined with plates of meteoric iron. This armor will protect its wearer even in the pandemonium of battle."
        ru = "Плотная кольчужная хауберта с пластинами из метеоритного железа. Этот доспех защитит своего владельца даже в вихре битвы."
    }
    {
        en = "Hard Harness"
        ru = "Несокрушимый Доспех"
    }
    {
        en = "Paragon's Defense"
        ru = "Защита Образца"
    }
    {
        en = "Barrier of the Ages"
        ru = "Барьер Эпох"
    }
    {
        en = "Meteoric Plate Armor"
        ru = "Метеоритные Латы"
    }
    {
        en = "Meteoric Plated Vest"
        ru = "Метеоритный Нагрудник"
    }
    {
        en = "Lifesaver"
        ru = "Спаситель"
    }
    // en = "heavy"
    // FILE: scripts/items/armor/artifact/artifact_golden_scale_armor.nut
    {
        en = "A scale armor made of small, interlocking scales. You swear that this armor is truly made of the scales of a golden dragon."
        ru = "Чешуйчатый доспех из мелких переплетённых чешуек. Вы готовы поклясться, что он и правда сделан из чешуи золотого дракона."
    }
    {
        en = "Brilliant Scale Shirt"
        ru = "Блестящая Чешуйчатая Рубаха"
    }
    {
        en = "Lusterous Scale Armor"
        ru = "Переливчатая Чешуйчатая Броня"
    }
    {
        en = "Paladine's Dragonskin"
        ru = "Драконья Кожа Паладина"
    }
    {
        en = "Dragon Scales"
        ru = "Чешуя Дракона"
    }
    {
        en = "Golden Wyrmskin"
        ru = "Золотая Кожа Червя"
    }
    {
        en = "Goldskin"
        ru = "Золотая Кожа"
    }
    {
        en = "Prismatic Scale Tunic"
        ru = "Призматическая Чешуйчатая Туника"
    }
    {
        en = "Auric Armor"
        ru = "Золочёный Доспех"
    }
    {
        en = "Auric Dawn"
        ru = "Золотой Рассвет"
    }
    // FILE: scripts/items/armor/artifact/artifact_green_coat_of_plates_armor.nut
    {
        en = "A coat of plates crafted from strange metal.  Dark lines swirl and flow through the metal."
        ru = "Бригантина из странного металла. Тёмные прожилки вьются и текут сквозь него."
    }
    {
        en = "Coat of Damascus"
        ru = "Дамасская Бригантина"
    }
    {
        en = "Invulnerable Carapace"
        ru = "Неуязвимый Панцирь"
    }
    {
        en = "Adamant Shell"
        ru = "Адамантовый Панцирь"
    }
    {
        en = "Damascus Plate Cuirass"
        ru = "Дамасская Кираса"
    }
    {
        en = "Green Plate Coat"
        ru = "Зелёная Пластинчатая Бригантина"
    }
    {
        en = "Argent Harness"
        ru = "Серебряный Доспех"
    }
    // FILE: scripts/items/armor/artifact/artifact_leopard_armor.nut
    {
        en = "A heavy lamellar plate harness combined with exquisite mail and luxurious padding. An exceptional piece that is almost too precious to be torn in battle."
        ru = "Тяжёлый ламеллярный доспех в сочетании с изысканной кольчугой и роскошным подбоем. Исключительная вещь — почти слишком драгоценная, чтобы рвать её в бою."
    }
    {
        en = "Sultan's Embrace"
        ru = "Объятия Султана"
    }
    {
        en = "Sultan's Guard"
        ru = "Охрана Султана"
    }
    {
        en = "Resplendant Lamellar"
        ru = "Великолепный Ламелляр"
    }
    {
        en = "Sultan's Harness"
        ru = "Доспех Султана"
    }
    {
        en = "Carapace of the Blazing Sands"
        ru = "Панцирь Пылающих Песков"
    }
    {
        en = "Nimrod's Armor"
        ru = "Доспех Нимрода"
    }
    // FILE: scripts/items/armor/artifact/artifact_lindwurm_armor.nut
    {
        en = "The sturdy scales of a true dragon sewn together ontop a heavy chainmail. Though you doubt the existence of such a beast, this relic makes you reconsider. The shimmering scales remain untouched by any corroding Lindwurm blood."
        ru = "Прочная чешуя истинного дракона, нашитая на тяжёлую кольчугу. Вы сомневались в существовании такого зверя, но эта реликвия заставляет пересмотреть взгляды. Переливающаяся чешуя не поддаётся разъедающей крови Линдвурма."
    }
    {
        en = "True Dragon Scales"
        ru = "Чешуя Истинного Дракона"
    }
    {
        en = "True Dragon's Hide"
        ru = "Шкура Истинного Дракона"
    }
    {
        en = "Dragon's Harness"
        ru = "Доспех Дракона"
    }
    {
        en = "Dragon's Coat"
        ru = "Плащ Дракона"
    }
    {
        en = "Dragoncales"
        ru = "Драконьи Чешуи"
    }
    {
        en = "Coat of the Dragon"
        ru = "Кафтан Дракона"
    }
    {
        en = "Unaffected by acidic Lindwurm blood"
        ru = "Невосприимчив к кислотной крови Линдвурма"
    }
    // FILE: scripts/items/armor/artifact/artifact_noble_mail_armor.nut
    {
        en = "This piece of light mail armor seems to be made of lowing silver. It is incredibly light, yet nearly indestructible."
        ru = "Этот лёгкий кольчужный доспех, похоже, выкован из живого серебра. Он невероятно лёгок, но почти неразрушим."
    }
    {
        en = "Mythril Shirt"
        ru = "Мифриловая Рубашка"
    }
    {
        en = "Auric Mail"
        ru = "Золочёная Кольчуга"
    }
    {
        en = "Kingsguard"
        ru = "Королевская Гвардия"
    }
    {
        en = "Fencing Paragon"
        ru = "Образцовый Фехтовальщик"
    }
    // FILE: scripts/items/armor/artifact/artifact_sellswords_armor.nut
    {
        en = "This piece of layered armor bears the hallmarks of a hero of legend. Its incredible resilience and flexibility make it a irreplacible piece of craftsmanship."
        ru = "Этот многослойный доспех несёт на себе черты легендарного героя. Его невероятная прочность и гибкость делают его незаменимым шедевром ремесла."
    }
    {
        en = "Legend's Coat"
        ru = "Кафтан Легенды"
    }
    {
        en = "Paragon's Hide"
        ru = "Шкура Образца"
    }
    {
        en = "Hero's Layered Armor"
        ru = "Многослойный Доспех Героя"
    }
    {
        en = "King's Plated Coat"
        ru = "Королевский Пластинчатый Кафтан"
    }
    // FILE: scripts/items/helmets/artifact/artifact_golden_feathers_helmet.nut
    {
        en = "A helmet of strange alloy, combined with a full mail coif for incomperable protection."
        ru = "Шлем из странного сплава в сочетании с полным кольчужным подшлемником — несравненная защита."
    }
    {
        en = "Golden Headpiece"
        ru = "Золотой Наголовник"
    }
    {
        en = "Golden Skullcap"
        ru = "Золотая Тюбетейка"
    }
    {
        en = "Peacock Helm"
        ru = "Шлем Павлина"
    }
    {
        en = "Prismatic Helmet"
        ru = "Призматический Шлем"
    }
    // FILE: scripts/items/helmets/artifact/artifact_heraldic_mail_helmet.nut
    {
        en = "A meteoric iron bascinet with a moveable visor, worn over a mail coif. A relic befitting a king."
        ru = "Метеоритный бацинет с подвижным забралом, надеваемый поверх кольчужного подшлемника. Реликвия, достойная короля."
    }
    {
        en = "Kingly Bascinet"
        ru = "Королевский Бацинет"
    }
    {
        en = "Argent Bascinet"
        ru = "Серебряный Бацинет"
    }
    {
        en = "Argent Helmet"
        ru = "Серебряный Шлем"
    }
    {
        en = "Kingly Helm"
        ru = "Королевский Шлем"
    }
    // FILE: scripts/items/helmets/artifact/artifact_lindwurm_helmet.nut
    {
        en = "This helmet must have once belonged to a daring and skilled hunter for it is covered in the scales of a true Dragon. Not only do the scales deflect blows and hits, but they also remain unscathed by the acidic Lindwurm blood."
        ru = "Этот шлем, должно быть, принадлежал смелому и искусному охотнику — он покрыт чешуёй истинного Дракона. Чешуя не только отклоняет удары, но и остаётся невредимой от кислотной крови Линдвурма."
    }
    {
        en = "True Dragon's Head"
        ru = "Голова Истинного Дракона"
    }
    {
        en = "Dragon's' Headpiece"
        ru = "Наголовник Дракона"
    }
    {
        en = "Dragon's Dome"
        ru = "Купол Дракона"
    }
    {
        en = "Dragon Ward"
        ru = "Стражник Дракона"
    }
    {
        en = "Dragonscale Helmet"
        ru = "Шлем Из Чешуи Дракона"
    }
    {
        en = "Dragonscale Mask"
        ru = "Маска Из Чешуи Дракона"
    }
    // FILE: scripts/items/helmets/artifact/artifact_metal_bull_helmet.nut
    {
        en = "A reinforced helmet made from an meteoric iron. It is richly decorated and heavy but offers extraordinary protection."
        ru = "Усиленный шлем из метеоритного железа. Богато украшен, тяжёл, но обеспечивает исключительную защиту."
    }
    {
        en = "Spiked Helmet"
        ru = "Шипованный Шлем"
    }
    {
        en = "Meteoric Headpiece"
        ru = "Метеоритный Наголовник"
    }
    {
        en = "Meteoric Sallet"
        ru = "Метеоритный Салет"
    }
    {
        en = "Protector"
        ru = "Защитник"
    }
    {
        en = "Spiked Crest"
        ru = "Шипованный Гребень"
    }
    // FILE: scripts/items/helmets/artifact/artifact_metal_nose_horn_helmet.nut
    {
        en = "This helmet must have belonged to a legendary warrior of the barbarians. Its size and design appear alien to all southern folks."
        ru = "Этот шлем, должно быть, принадлежал легендарному воину варваров. Его размер и облик чужды всем южанам."
    }
    {
        en = "Hermetic Helmet"
        ru = "Герметичный Шлем"
    }
    {
        en = "Spiked Headpiece"
        ru = "Шипованный Наголовник"
    }
    {
        en = "Bladed Headguard"
        ru = "Клинковый Нащечник"
    }
    {
        en = "Meteoric Faceguard"
        ru = "Метеоритное Забрало"
    }
    // FILE: scripts/items/helmets/artifact/artifact_metal_skull_helmet.nut
    {
        en = "A skull-like mask made of meteoric iron. This piece is as massive as it is impressive."
        ru = "Маска в форме черепа из метеоритного железа. Столь же массивная, сколь и внушительная."
    }
    {
        en = "Face of the North"
        ru = "Лицо Севера"
    }
    {
        en = "Fallen Skull"
        ru = "Павший Череп"
    }
    {
        en = "Meteoric Facemask"
        ru = "Метеоритная Маска"
    }
    {
        en = "Aspect of the Clans"
        ru = "Облик Кланов"
    }
    {
        en = "Adamant Mask"
        ru = "Адамантовая Маска"
    }
    {
        en = "Steel Veil"
        ru = "Стальная Вуаль"
    }
    {
        en = "Ancient's Visage"
        ru = "Лик Древних"
    }
    {
        en = "Pillager Gaze"
        ru = "Взгляд Мародёра"
    }
    // FILE: scripts/items/helmets/artifact/artifact_norse_helmet.nut
    {
        en = "An exquisite nordic helmet that must have belonged to a high king or exalted champion, thought lost to time."
        ru = "Изысканный нордический шлем, принадлежавший, должно быть, верховному королю или прославленному чемпиону — считавшийся утраченным."
    }
    {
        en = "Highlord's Helmet"
        ru = "Шлем Великого Лорда"
    }
    {
        en = "Lord's Nasal Helmet"
        ru = "Назальный Шлем Лорда"
    }
    {
        en = "Mythril Faceguard"
        ru = "Мифриловое Забрало"
    }
    {
        en = "Meteoric Norse Helmet"
        ru = "Метеоритный Нордический Шлем"
    }
    {
        en = "Odin's Helmet"
        ru = "Шлем Одина"
    }
    // FILE: scripts/items/helmets/artifact/artifact_sallet_green_helmet.nut
    {
        en = "A inscrutable sallet supported by a mail coif, crested with gossamer ribbons."
        ru = "Загадочный салет на кольчужном подшлемнике, увенчанный тончайшими лентами."
    }
    {
        en = "Decorated Sallet"
        ru = "Украшенный Салет"
    }
    {
        en = "Eerie Sallet"
        ru = "Жуткий Салет"
    }
    {
        en = "Auric Sallet"
        ru = "Золочёный Салет"
    }
    {
        en = "Ribboned Sallet"
        ru = "Ленточный Салет"
    }
    // FILE: scripts/items/helmets/artifact/artifact_wolf_helmet.nut
    {
        en = "A silvery metal helmet with attached mail, covered with an impressive wolf head."
        ru = "Серебристый металлический шлем с прикреплённой кольчугой, украшенный впечатляющей волчьей головой."
    }
    {
        en = "Primal Cap"
        ru = "Первобытный Капюшон"
    }
    {
        en = "Helmet of the Beast"
        ru = "Шлем Зверя"
    }
    {
        en = "Berserker Coif"
        ru = "Кой Берсерка"
    }
    {
        en = "Beast King Coif"
        ru = "Кой Короля Зверей"
    }
    {
        en = "Dire Wolf Crown"
        ru = "Корона Лютого Волка"
    }
    {
        en = "Apex Predator Crown"
        ru = "Корона Высшего Хищника"
    }
    // FILE: scripts/items/shields/artifact/artifact_golden_round_shield.nut
    {
        en = "A round shield of unmatched quality.  The very metal of this shield swirls with dark veins."
        ru = "Круглый щит несравненного качества. Сам металл этого щита пронизан тёмными прожилками."
    }
    // FILE: scripts/items/shields/artifact/artifact_orc_heavy_shield.nut
    {
        en = "A colossal hunk of meteoric iron with a leather band attached.  While unwieldy, this shield will withstand incredible amounts of punishment"
        ru = "Колоссальный кусок метеоритного железа с прикреплённой кожаной полосой. Неуклюжий, но этот щит выдержит невероятное количество ударов."
    }
    // FILE: scripts/items/shields/artifact/artifact_schract_shield.nut
    {
        en = "This long wooden shield seems to have been grown rather than crafted.  The continual growth of the wood has kept it whole for an age."
        ru = "Этот длинный деревянный щит, похоже, вырос, а не был изготовлен. Непрестанный рост дерева хранил его целым на протяжении эпохи."
    }
    {
        // text = "Regenerates itself by [color=" + this.Const.UI.Color.PositiveValue + "]4[/color] points of durability each turn."
        mode = "pattern"
        en = "Regenerates itself by <n:int_tag> points of durability each turn."
        ru = "Восстанавливает <n> единиц прочности каждый ход."
    }
    // FILE: scripts/items/shields/artifact/artifact_sipar_shield.nut
    {
        en = "A full metal round shield of southern design with exquisite ornaments. Heavy, but nearly impenetrable"
        ru = "Цельнометаллический круглый щит южного образца с изысканными украшениями. Тяжёлый, но почти непроницаемый."
    }
    // FILE: scripts/items/weapons/artifact/artifact_axe.nut
    {
        en = "An axe of legend whose making has been lost to time.  It is perfectly honed for dismantling armored opponents."
        ru = "Легендарный топор, секрет изготовления которого утрачен. Идеально заточен для разрушения доспехов противников."
    }
    {
        en = "Axe, One-Handed"
        ru = "Топор, одноручный"
    }
    // FILE: scripts/items/weapons/artifact/artifact_bardiche.nut
    {
        en = "This exquisite bardiche has been made from a fallen star.  A faint hum emenates from the strange metal."
        ru = "Этот изысканный бердыш выкован из упавшей звезды. От странного металла исходит едва слышное гудение."
    }
    {
        en = "Axe, Two-Handed"
        ru = "Топор, двуручный"
    }
    // FILE: scripts/items/weapons/artifact/artifact_battle_whip.nut
    {
        en = "This whip is unlike any you have seen.  Clearly crafted by a country of men that have mastered its use, you wonder what strange land could have fashioned such a weapon."
        ru = "Этот хлыст не похож ни на один виденный вами. Явно изготовлен в стране, где люди в совершенстве овладели им. Вы гадаете, в каких странных краях могли создать такое оружие."
    }
    {
        en = "Cleaver, One-Handed"
        ru = "Тесак, одноручный"
    }
    // FILE: scripts/items/weapons/artifact/artifact_billhook.nut
    {
        en = "A wicked-looking polearm, edged on one side and hooked on the other.  The design of this piece is alien to you, the masterpiece of a civilization long past"
        ru = "Зловещего вида алебарда, заточенная с одной стороны и крючковатая с другой. Образец вам не знаком — шедевр давно ушедшей цивилизации."
    }
    {
        en = "Polearm, Two-Handed"
        ru = "Древковое, двуручное"
    }
    // FILE: scripts/items/weapons/artifact/artifact_bladed_pike.nut
    {
        en = "A masterwork of the old empire. Strange magic has kept this pike preserved and deadly through countless millenia."
        ru = "Шедевр старой империи. Странная магия хранила эту пику целой и смертоносной через бесчисленные тысячелетия."
    }
    // FILE: scripts/items/weapons/artifact/artifact_cleaver.nut
    {
        en = "A sword of legend.  This blade bears the mark of an ancient tyrant, built for dismembering opponents and seeming to call out for blood."
        ru = "Легендарный меч. Это клинок несёт знак древнего тирана, созданный для расчленения врагов — и словно жаждущий крови."
    }
    // FILE: scripts/items/weapons/artifact/artifact_crossbow.nut
    {
        en = "A crossbow of inscrutable make.  This weapon feels immediately familiar, yet you could not describe how it works.  The bolts from this weapon snap through the air to horrifying effect."
        ru = "Арбалет непостижимой работы. Он кажется привычным в руке, но вы не смогли бы объяснить, как он устроен. Болты из него разрезают воздух с ужасающим эффектом."
    }
    {
        en = "Crossbow, Two-Handed"
        ru = "Арбалет, двуручный"
    }
    // FILE: scripts/items/weapons/artifact/artifact_crypt_cleaver.nut
    {
        en = "A fabled weapon of the ancient empire.  This massive cleaver has filled tomes as it carved its way through the old world"
        ru = "Легендарное оружие древней империи. Этот массивный тесак вписан в летописи — пока прокладывал путь сквозь старый мир."
    }
    {
        en = "Cleaver, Two-Handed"
        ru = "Тесак, двуручный"
    }
    // FILE: scripts/items/weapons/artifact/artifact_dagger.nut
    {
        en = "An impossibly sharp short blade.  This eerie dagger never seems to lose its edge."
        ru = "Невозможно острый короткий клинок. Этот жуткий кинжал, кажется, никогда не тупится."
    }
    {
        en = "Dagger, One-Handed"
        ru = "Кинжал, одноручный"
    }
    // FILE: scripts/items/weapons/artifact/artifact_fencing_sword.nut
    {
        en = "This strange sword feels almost weightless in your hand.  Its thin blade passes effortlessly through armor and flesh, though you cannot fathom how it maintains its strength."
        ru = "Этот странный меч ощущается почти невесомым в руке. Его тонкий клинок легко проходит сквозь доспехи и плоть, и вы не можете понять, как он сохраняет прочность."
    }
    {
        en = "Sword, One-Handed"
        ru = "Меч, одноручный"
    }
    // FILE: scripts/items/weapons/artifact/artifact_flail.nut
    {
        en = "The form of this weapon matches common flails: A spiked head, a handle, and a chain connecting them.  The construction and materials of this piece, however, resemble no weapon that you have seen.  Though old beyond reckoning, you can see no signs of wear on this weapon."
        ru = "Форма этого оружия соответствует обычному цепу: шипастый шар, рукоять и цепь между ними. Однако конструкция и материалы не похожи ни на одно виданное вами оружие. Хотя оно невероятно древнее, следов износа нет."
    }
    {
        en = "Flail, One-Handed"
        ru = "Цеп, одноручный"
    }
    // FILE: scripts/items/weapons/artifact/artifact_greataxe.nut
    {
        en = "A massive weapon forged from meteoric iron.  This two-handed axe hums as it cleaves through armor, flesh, and bone."
        ru = "Массивное оружие, выкованное из метеоритного железа. Этот двуручный топор гудит, разрубая доспехи, плоть и кости."
    }
    // FILE: scripts/items/weapons/artifact/artifact_greatsword.nut
    {
        en = "A relic of masters long past, this greatsword has no peer in the known kingdoms.  Though tall as a man, this greatsword is weilded easily."
        ru = "Реликвия давно ушедших мастеров — этот двуручный меч не имеет равных в известных королевствах. Ростом с человека, он держится легко."
    }
    {
        en = "Sword, Two-Handed"
        ru = "Меч, двуручный"
    }
    // FILE: scripts/items/weapons/artifact/artifact_handgonne.nut
    {
        en = "Cacafuego"
        ru = "Какафуэго"
    }
    {
        en = "Deathspitter"
        ru = "Плевок Смерти"
    }
    {
        en = "Coronach"
        ru = "Коронах"
    }
    {
        en = "Death Penalty"
        ru = "Смертная Казнь"
    }
    {
        en = "Though a new invention, this handgonne, cast from meteoric iron, is without peer. Can not be used while engaged in melee."
        ru = "Хотя это новое изобретение, этот ручной пистоль из метеоритного железа не имеет равных. Нельзя использовать в ближнем бою."
    }
    {
        en = "Firearm, Two-Handed"
        ru = "Огнестрел, двуручный"
    }
    // FILE: scripts/items/weapons/artifact/artifact_javelin.nut
    {
        en = "A bundle of light spears crafted to be thrown.  These weapons are pointed with some material that you cannot discern.  They fly deadly and true."
        ru = "Связка лёгких копий для метания. Они заострены каким-то неизвестным вам материалом. Летят смертоносно и точно."
    }
    {
        en = "Throwing Weapon, One-Handed"
        ru = "Метательное, одноручное"
    }
    // FILE: scripts/items/weapons/artifact/artifact_longaxe.nut
    {
        en = "This axe holds a strange blade at the end of a long shaft.  Its reach goes well beyond that of a normal weapon allowing its weilder to rain blows from behind the frontline.  No craftsman today can match the quality of this weapon."
        ru = "Этот топор несёт странное лезвие на конце длинного древка. Его досягаемость намного превосходит обычное оружие, позволяя владельцу наносить удары из-за линии фронта. Ни один современный мастер не сравнится с его качеством."
    }
    // FILE: scripts/items/weapons/artifact/artifact_mace.nut
    {
        en = "While the form of this weapon is clearly a mace, the construction is unlike anything you have seen.  Ripples and veins of darkness swirl around the metal, and cruel spikes look to have grown from the head."
        ru = "Форма этого оружия явно палица, но конструкция не похожа ни на что виденное. Тёмные прожилки вьются вокруг металла, а жестокие шипы словно выросли из навершия."
    }
    {
        en = "Mace, One-Handed"
        ru = "Палица, одноручная"
    }
    // FILE: scripts/items/weapons/artifact/artifact_orc_axe.nut
    {
        en = "An unworldly piece of metal that has been attached to a haft.  Cumbersome and inelegant, but deadly."
        ru = "Неземной кусок металла, насаженный на рукоять. Неуклюжий и безыскусный, но смертоносный."
    }
    // FILE: scripts/items/weapons/artifact/artifact_orc_cleaver.nut
    {
        en = "A piece of meteoric iron, shaped into an ugly but terrifying cleaver."
        ru = "Кусок метеоритного железа, сформированный в уродливый, но устрашающий тесак."
    }
    // FILE: scripts/items/weapons/artifact/artifact_pike.nut
    {
        en = "This pike, forged of a strange metal, seems strangely light.  It moves with the ease of a much smaller weapon; its tip passes easily through metal and flesh."
        ru = "Эта пика из странного металла ощущается на удивление лёгкой. Она движется с лёгкостью гораздо меньшего оружия, а её жало легко проходит сквозь металл и плоть."
    }
    // FILE: scripts/items/weapons/artifact/artifact_polehammer.nut
    {
        en = "A relic from an unknown land, this polehammer has been forged of a strange metal, flowing with veins and eddies."
        ru = "Реликвия из неизвестных краёв, этот молот на древке выкован из странного металла, пронизанного прожилками и завихрениями."
    }
    {
        en = "Hammer, Two-Handed"
        ru = "Молот, двуручный"
    }
    // FILE: scripts/items/weapons/artifact/artifact_qatal_dagger.nut
    {
        en = "A kingslayer, this dagger has already shaped the fate of empires."
        ru = "Убийца королей — этот кинжал уже определил судьбу империй."
    }
    // FILE: scripts/items/weapons/artifact/artifact_rusty_warblade.nut
    {
        en = "The massive blade hold a history that goes back hundreds of years.  Though none can speak of its origin, countless warlords have rallied their hordes to this weapon."
        ru = "Это массивное лезвие хранит историю, уходящую на сотни лет назад. Никто не знает его происхождения, но бесчисленные военачальники собирали свои орды под его знаменем."
    }
    // FILE: scripts/items/weapons/artifact/artifact_shamshir.nut
    {
        en = "Though forged in the southern style, this shamshir has no peer.  Even the genius of the eastern sages seem to have lost this weapons secrets to time."
        ru = "Хотя и выкованный в южном стиле, этот шамшир не имеет равных. Даже гений восточных мудрецов, кажется, утратил секреты этого оружия со временем."
    }
    // FILE: scripts/items/weapons/artifact/artifact_spear.nut
    {
        en = "The material of this spear seems almost crystalline, as if some great force of the earth had forced it into the proper shape.  It seems to sing as you move it through the air."
        ru = "Материал этого копья кажется почти кристаллическим, словно какая-то великая сила земли придала ему нужную форму. Оно как будто поёт, когда вы рассекаете им воздух."
    }
    {
        en = "Spear, One-Handed"
        ru = "Копьё, одноручное"
    }
    // FILE: scripts/items/weapons/artifact/artifact_sword.nut
    {
        en = "A relic from the great kings of legend.  This sword is immaculately crafted, holding still the edge that earned it its name."
        ru = "Реликвия великих легендарных королей. Этот меч безупречно выкован и до сих пор хранит остроту, что принесла ему его имя."
    }
    // FILE: scripts/items/weapons/artifact/artifact_swordlance.nut
    {
        en = "A long pole attached to a deadly curved blade, this weapon has cut down men like so much wheat"
        ru = "Длинное древко с смертоносным изогнутым клинком — это оружие косило людей как пшеницу."
    }
    // FILE: scripts/items/weapons/artifact/artifact_three_headed_flail.nut
    {
        en = "A truly uncanny weapon, both in form and construction.  This flail looks like no other weapon of these lands."
        ru = "Поистине жуткое оружие — и по форме, и по конструкции. Этот цеп не похож ни на какое другое оружие этих земель."
    }
    // FILE: scripts/items/weapons/artifact/artifact_throwing_axe.nut
    {
        en = "These small axes have been forged as a batch from meteoric iron.  Though irreproducible, they fly true and deadly."
        ru = "Эти маленькие топорики выкованы из метеоритного железа одной партией. Неповторимые — летят точно и смертоносно."
    }
    // FILE: scripts/items/weapons/artifact/artifact_two_handed_flail.nut
    {
        en = "A wicked tool, made for crushing bodies and heads.  This massive flail was the tool of a cruel tyrant, now in the hands of your company."
        ru = "Жестокий инструмент для дробления тел и голов. Этот массивный цеп был орудием жестокого тирана — теперь в руках вашей дружины."
    }
    {
        en = "Flail, Two-Handed"
        ru = "Цеп, двуручный"
    }
    // FILE: scripts/items/weapons/artifact/artifact_two_handed_hammer.nut
    {
        en = "A gargantuan hammer, made from a massive chunk of meteoric iron.  It seems that attempts to forge the metal had failed and instead the stone was simply attached to a hilt."
        ru = "Исполинский молот из огромного куска метеоритного железа. Судя по всему, попытки ковки металла провалились, и камень просто прикрепили к рукояти."
    }
    // FILE: scripts/items/weapons/artifact/artifact_two_handed_mace.nut
    {
        en = "A massive two-handed mace whose construction has been lost to time.  This weapon is a true terror when weilded by a skilled hand."
        ru = "Массивная двуручная палица, чья конструкция утрачена временем. Это оружие — настоящий ужас в умелых руках."
    }
    {
        en = "Mace, Two-Handed"
        ru = "Палица, двуручная"
    }
    // FILE: scripts/items/weapons/artifact/artifact_two_handed_scimitar.nut
    {
        en = "A massive scimitar wielded with both hands. The metal of the curved blade swirls with some strange alloy, but it hews right through flesh and bone."
        ru = "Массивный ятаган, которым орудуют обеими руками. Металл изогнутого клинка пронизан каким-то странным сплавом, но он рубит плоть и кости без труда."
    }
    // FILE: scripts/items/weapons/artifact/artifact_warbow.nut
    {
        en = "This bow seems to have been grown rather than hewn.  Light and impossibly strong, you have never seen its equal."
        ru = "Этот лук, похоже, вырос, а не был вырублен. Лёгкий и невозможно прочный — вам не доводилось видеть ему равных."
    }
    {
        en = "Bow, Two-Handed"
        ru = "Лук, двуручный"
    }
    // FILE: scripts/items/weapons/artifact/artifact_warhammer.nut
    {
        en = "This hammer has been forged from some impossibly hard material.  Against even the strongest plate, it leaves gashes and holes."
        ru = "Этот молот выкован из какого-то невозможно твёрдого материала. Даже самые прочные латы он оставляет в дырах и пробоинах."
    }
    {
        en = "Hammer, One-Handed"
        ru = "Молот, одноручный"
    }
    // FILE: scripts/items/weapons/artifact/artifact_warscythe.nut
    {
        en = "This masterpiece of the ancient empire hold a sweeping blade at the end of a long pole.  Though ages have passed since its forging, it bears no marks of rust or wear."
        ru = "Шедевр древней империи — широкий клинок на конце длинного древка. Хотя с момента его ковки прошли эпохи, он не несёт следов ржавчины или износа."
    }
    // FILE: scripts/skills/special/campart_bleeding_ammo.nut
    {
        en = "Bleeding Ammo Effect"
        ru = "Эффект Кровоточащих Боеприпасов"
    }
    {
        en = "A successful hit will make the target bleed."
        ru = "Успешное попадание вызовет кровотечение у цели."
    }
    {
        en = "Applies bleeding on hit"
        ru = "Вызывает кровотечение при попадании"
    }
    {
        // ::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_targetEntity) + " is bleeding");
        mode = "pattern"
        en = "<name:str_tag> is bleeding"
        ru = "<name> истекает кровью"
    }
    // FILE: scripts/skills/special/campart_fire_ammo.nut
    {
        en = "Flaming Ammo Effect"
        ru = "Эффект Огненных Боеприпасов"
    }
    {
        en = "A successful hit will light the target tile on fire for 2 rounds."
        ru = "Успешное попадание поджигает клетку цели на 2 хода."
    }
    {
        en = "Will light the landing tile on fire for 2 rounds"
        ru = "Поджигает клетку попадания на 2 хода"
    }
    {
        en = "Fire rages here, melting armor and flesh alike"
        ru = "Здесь бушует пламя, плавящее доспехи и плоть"
    }
    // FILE: scripts/skills/special/campart_ice_ammo.nut
    {
        en = "Freezing Ammo Effect"
        ru = "Эффект Ледяных Боеприпасов"
    }
    {
        en = "A successful hit will freeze the target."
        ru = "Успешное попадание заморозит цель."
    }
    {
        en = "Will freeze a target on hit"
        ru = "Замораживает цель при попадании"
    }
    {
        // ::Const.UI.getColorizedEntityName(_targetEntity) + " is chilled");
        mode = "pattern"
        en = "<name:str_tag> is chilled"
        ru = "<name> обморожен"
    }
    // FILE: scripts/skills/special/campart_poison_ammo.nut
    {
        en = "Poisoned Ammo Effect"
        ru = "Эффект Отравленных Боеприпасов"
    }
    {
        en = "Poisons a target on hit."
        ru = "Отравляет цель при попадании."
    }
    {
        en = "Applies goblin poison on hit"
        ru = "Отравляет цель гоблинским ядом"
    }
    {
        // this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_targetEntity) + " is poisoned");
        mode = "pattern"
        en = "<name:str_tag> is poisoned"
        ru = "<name> отравлен"
    }
    // FILE: scripts/skills/special/campart_shock_ammo.nut
    {
        en = "Shocking Ammo Effect"
        ru = "Эффект Оглушающих Боеприпасов"
    }
    {
        en = "A successful hit will daze the target."
        ru = "Успешное попадание оглушит цель."
    }
    {
        en = "Will daze a target on hit"
        ru = "Оглушает цель при попадании"
    }
    {
        // ::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_targetEntity) + " is dazed");
        mode = "pattern"
        en = "<name:str_tag> is dazed"
        ru = "<name> оглушён"
    }
    // FILE: scripts/skills/traits/bonus_ap_trait.nut
    {
        en = "Bonus AP"
        ru = "Бонусное ОД"
    }
    {
        en = "Moving faster than most men"
        ru = "Двигается быстрее большинства людей"
    }
    {
        // text = "[color=" + this.Const.UI.Color.PositiveValue + "]+1[/color] Action Point"
        mode = "pattern"
        en = "<n:int_tag> Action Point"
        ru = "<n> очко действия"
    }
    // FILE: scripts/skills/traits/bonus_stam_regen_trait.nut
    {
        en = "Bonus Stamina Regen"
        ru = "Бонус к Регенерации Выносливости"
    }
    {
        en = "Renewed strength with every breath"
        ru = "Силы возобновляются с каждым вздохом"
    }
    // FILE: scripts/skills/traits/grab_immune_trait.nut
    {
        en = "Grab Immune"
        ru = "Иммунитет к Захватам"
    }
    {
        en = "Immune to grab effects"
        ru = "Невосприимчив к эффектам захвата"
    }
    // FILE: scripts/skills/traits/grant_linebreaker_trait.nut
    {
        en = "Grants Linebreaker"
        ru = "Дарует Прорыв Строя"
    }
    {
        en = "Enables the Linebreaker Skill"
        ru = "Открывает навык «Прорыв строя»"
    }
    // FILE: scripts/skills/traits/mind_immune_trait.nut
    {
        en = "Mind Immune"
        ru = "Иммунитет к Ментальному"
    }
    {
        en = "Immune to mental effects"
        ru = "Невосприимчив к ментальным эффектам"
    }
    // FILE: scripts/skills/traits/night_vision_trait.nut
    {
        en = "Sees in the dark, clear as day"
        ru = "Видит в темноте как днём"
    }
    {
        en = "Unaffected by Nighttime effect"
        ru = "На него не влияет эффект Ночи"
    }
    // FILE: scripts/skills/traits/preternatural_dodge_trait.nut
    {
        en = "This character reacts with unnatural speed"
        ru = "Этот персонаж реагирует с неестественной скоростью"
    }
    {
        en = "Dodges the first attack each round"
        ru = "Уклоняется от первой атаки каждого хода"
    }
    {
        en = "Dodge!"
        ru = "Уклон!"
    }
    // FILE: scripts/skills/traits/regenerate_trait.nut
    {
        en = "Healing Factor!"
        ru = "Исцеление!"
    }
    {
        // this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " heals for " + healthAdded + " points");
        mode = "pattern"
        en = "<name:str_tag> heals for <n:int> points"
        ru = "<name> исцеляется на <n> ОЗ"
    }
    // FILE: scripts/skills/traits/repair_armor_trait.nut
    {
        en = "Repair Armor"
        ru = "Починка Брони"
    }
    // FILE: scripts/skills/traits/repair_helmet_trait.nut
    {
        en = "Repair Helmet"
        ru = "Починка Шлема"
    }
]
::Rosetta.add(rosetta, pairs);
