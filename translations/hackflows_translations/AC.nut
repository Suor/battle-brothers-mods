if (!("Rosetta" in getroottable())) return;

local rosetta = {
    mod = {id = "mod_AC", version = "1.26"}
    author = "hackflow"
    lang = "ru"
}
local pairs = [
    // FILE: scripts/!mods_preload/mod_AC.nut
    {
        en = "Accessory Companions (fixed by hackflow)"
        ru = "Спутники-аксессуары (починил hackflow)"
    }
    {
        en = "Beastmaster"
        ru = "Укротитель"
    }
    {
        en = "Beastmasters are used to handle various beasts."
        ru = "Укротители привыкли управляться с самыми разными зверями."
    }
    {
        en = "Beasts were not simply 'beasts' to %name%, despite his title as 'beastmaster.' To him, they were the most loyal friends of his life. After leaving the company, he discovered an ingenious way to breed the animals specifically tailored to the desires of the nobility. Wanted a brutish beast for a guard? He could do it. Wanted something small and cuddly for the children? He could do that, too. The former mercenary now earns an incredible earning doing what he loves - working with beasts."
        ru = "Для %name% звери были не просто 'зверями', несмотря на его звание укротителя. Для него они — самые верные друзья в жизни. Покинув отряд, он нашёл остроумный способ разводить животных под нужды знати. Нужен свирепый зверь для охраны? Без проблем. Нужно что-то маленькое и ласковое для детей? Тоже сделаем. Бывший наёмник теперь зарабатывает немалые деньги, занимаясь любимым делом — работой со зверями."
    }
    {
        en = "What's merely a beast to one man is a loyal companion to %name%. After leaving the company, the beastmaster went out to work for the nobility. Unfortunately, he refused to let hundreds of his beasts be used as a battle vanguard to be thrown away for some short-lived tactical advantage. He was hanged for his 'traitorous ideals'."
        ru = "То, что для одних лишь зверь, для %name% — верный товарищ. Покинув отряд, укротитель пошёл служить знати. Увы, он отказался бросить сотни своих питомцев в авангард ради минутного тактического преимущества. За эти 'предательские идеалы' его повесили."
    }
    {
        en = "the Beastmaster"
        ru = "Укротитель"
    }
    {
        en = "the Tamer"
        ru = "Дрессировщик"
    }
    {
        en = "Beasts unleashed by this character will start at confident morale."
        ru = "Выпущенные этим персонажем звери начинают бой в уверенном настроении."
    }
    {
        en = "Beasts handled by this character gain more experience."
        ru = "Звери этого персонажа получают больше опыта."
    }
    {
        en = "Higher chance of success when taming beasts."
        ru = "Повышенный шанс успеха при приручении зверей."
    }
    {
        en = "{%name%'s affection for beasts started after his father won a serpent in a shooting contest. | When a direwolf saved him from a bear, %name% dedicated his life to beasts of all sorts. | Seeing a webknecht stave off a would-be robber, %name%'s fondness for beasts only grew. | A young, bird-hunting %name% quickly saw the honor, loyalty, and workmanship of a trained beast. | Once bitten by a wild hyena, %name% confronted his fear of beasts by learning to train them.} {The beastmaster spent many years working for a local lord. He gave up the post after the liege struck one of his post-ferals down just for sport. | Quick with training the wildlife, the beastmaster put his post-ferals into a lucrative traveling tradeshow. | The man made a great deal of money on the beast-fighting circuits, his post-ferals renowned for their easily commanded - and unleashed - ferocity. | Employed by lawmen, the beastmaster used his strong-nosed post-ferals to hunt down many a criminal element. | Used by a local lord, many of the beastmaster's post-ferals found their way onto the battlefield. | For many years, the beastmaster used his post-ferals to help lift the spirits of orphaned children and the crippled.} {Now, though, %name% seeks a change of vocation. | When he heard word of a mercenary's pay, %name% decided to try his hand at being a sellsword. | Approached by a sellsword to buy one of his creatures, %name% became more interested in the prospect of he, himself, becoming a mercenary. | Tired of training creatures for this purpose or that, %name% seeks to train himself for... well, this purpose or that. | An interesting prospect, you can only hope %name% is as loyal as the creatures he once commanded.}"
        ru = "{Любовь %name% к зверям зародилась, когда его отец выиграл змея в состязании по стрельбе. | Когда лютоволк спас его от медведя, %name% посвятил жизнь всевозможным зверям. | Увидев, как вебкнехт отогнал грабителя, %name% стал ценить зверей ещё больше. | Юный %name%, охотясь на птиц, быстро разглядел честь, преданность и мастерство обученного зверя. | Укушенный диким гиеной, %name% победил свой страх перед зверями, научившись их укрощать.} {Укротитель долгие годы служил местному лорду. Он покинул эту должность после того, как господин убил одного из его питомцев ради забавы. | Обладая талантом к обучению диких животных, укротитель превратил своих питомцев в прибыльный бродячий цирк. | Мужчина хорошо заработал на звериных боях — его питомцы прославились неистовой яростью, которую легко зажечь и выпустить. | Нанятый стражниками, укротитель использовал своих чутконосых питомцев для поимки преступников. | По велению местного лорда многие из питомцев укротителя оказались на поле боя. | Долгие годы укротитель поднимал дух детей-сирот и калек с помощью своих питомцев.} {Но теперь %name% ищет смену занятий. | Услышав о жаловании наёмников, %name% решил попробовать себя в роли меченосца. | Когда к нему подошёл наёмник с желанием купить одного из его зверей, %name% сам заинтересовался перспективой стать наёмником. | Устав дрессировать зверей на потребу дня, %name% решил натренировать самого себя... ну, тоже на потребу дня. | Заманчивая перспектива — остаётся лишь надеяться, что %name% окажется столь же верным, как звери, которыми он когда-то командовал.}"
    }
    // en = "<cloneRawDescription>\nmod_AC=Beastmaster"  // internal serialization
    // en = "\nmod_AC=Beastmaster"                        // internal serialization
    {
        en = "This massive citadel guards a warport and the surrounding trade routes. It is a seat of power for nobility and home to a large garrison."
        ru = "Этот огромный замок охраняет военный порт и окружающие торговые пути. Оплот знати и дом большого гарнизона."
    }
    {
        en = "A massive citadel towering over the open plains surrounding it. A seat of power to nobles, and housing large armed forces for a firm grip on the region."
        ru = "Огромный замок, возвышающийся над открытыми равнинами. Оплот знати с крупными вооружёнными силами, держащими регион под контролем."
    }
    {
        en = "This citadel towers high over the surrounding forests and dominates the region."
        ru = "Этот замок высится над окружающими лесами и господствует в регионе."
    }
    {
        en = "This massive stone citadel is built into the steep mountains. A large number of men are stationed here to hold a firm grip on the land."
        ru = "Этот огромный каменный замок врублен в крутые горы. Здесь размещён большой гарнизон, крепко держащий землю в своих руках."
    }
    {
        en = "This large citadel looks wide over the endless snow and is a stronghold against anything that may come down from the far north. As people flocked to its protection over the years, the many houses and workshops in its vicinity now also grant shelter and supply to travelers, mercenaries and adventurers in the area."
        ru = "Этот огромный замок смотрит на бескрайние снега и служит твердыней против всего, что может прийти с далёкого севера. Со временем под его защиту стекался народ, и теперь многочисленные дома и мастерские вокруг дают кров и припасы путникам, наёмникам и искателям приключений."
    }
    {
        en = "This mighty citadel towers high above the surrounding steppe and is the seat of power in the region. It houses a large garrison and offers all kinds of services valuable to travellers and mercenaries."
        ru = "Этот могучий замок высится над окружающей степью и является оплотом власти в регионе. Здесь размещён большой гарнизон, путникам и наёмникам доступны всевозможные услуги."
    }
    {
        en = "A large citadel towering high over the surrounding tundra and securing the large and open region. Many come here to resupply, make repairs and rest until venturing on."
        ru = "Огромный замок, высящийся над окружающей тундрой и контролирующий широкий открытый регион. Многие приходят сюда пополнить запасы, починить снаряжение и отдохнуть перед дальней дорогой."
    }
    {
        en = "A large city surrounded by lush green meadows, orchards and fields. Food stocks are usually filled to the brim."
        ru = "Большой город в окружении пышных зелёных лугов, садов и полей. Запасы еды здесь обычно полны до краёв."
    }
    {
        en = "A big harbor city relying on trade and fishing, and an important hub for travellers arriving or leaving by ship."
        ru = "Крупный портовый город, живущий торговлей и рыболовством. Важный перевалочный пункт для путников, прибывающих и отбывающих морем."
    }
    {
        en = "A prospering city located close to the forest with its main produce being valuable timber and venison."
        ru = "Процветающий город у леса, главный товар которого — ценная древесина и дичь."
    }
    {
        en = "A large city far up north. Traders, travelers and adventurers come here for shelter from snow and storms."
        ru = "Большой город на далёком севере. Торговцы, путники и искатели приключений приходят сюда спастись от снега и бурь."
    }
    {
        en = "A large city thriving in the southern steppe by trading and producing valuable goods and fine arts."
        ru = "Большой город, процветающий в южных степях благодаря торговле, производству ценных товаров и изящным искусствам."
    }
    {
        en = "A collection of many smaller settlements spread out over dry spots in the swampy area to form one modestly sized city."
        ru = "Множество небольших поселений на сухих островках болотистой местности, вместе образующих один скромный город."
    }
    {
        en = "Surrounded by barren tundra, this large city has lasted as an important trading hub and home to thinkers and fine arts."
        ru = "Окружённый бесплодной тундрой, этот большой город сохранился как важный торговый узел и родина мыслителей и изящных искусств."
    }
    {
        en = "This mighty stone keep surrounded by forest acts as a base of operations in the area."
        ru = "Этот могучий каменный форт в окружении леса служит опорной базой в регионе."
    }
    {
        en = "A stone keep that is towering high over the surrounding mountains. Lookouts on the towers can see approaching troops from miles away."
        ru = "Каменный форт, высящийся над окружающими горами. Дозорные на башнях замечают приближающихся врагов за многие мили."
    }
    {
        en = "A stone keep controlling routes through and access to the surrounding swamps and marshes."
        ru = "Каменный форт, контролирующий пути через окружающие болота и топи."
    }
    {
        en = "An established village close to the forest living mainly from lumber cutting and game."
        ru = "Обжитая деревня у леса, живущая главным образом рубкой леса и охотой."
    }
    {
        en = "A stretched out settlement nestled into the surrounding mountains. The hammering of pickaxes against stone can be heard from a distance."
        ru = "Вытянутое поселение, укрывшееся среди окружающих гор. Стук кирок о камень слышен издалека."
    }
    {
        en = "A somewhat larger settlement spread out across various dry and firm spots in the swamp."
        ru = "Относительно крупное поселение, раскинувшееся по сухим твёрдым островкам болота."
    }
    {
        en = "A village living off of lumber and everything the forest offers."
        ru = "Деревня, живущая лесом и всем, что он даёт."
    }
    {
        en = "A small settlement in a swampy area. The people living here sure know hardship."
        ru = "Небольшое поселение в болотистой местности. Здешний народ точно знает, что такое лишения."
    }
    {
        // return this.m.Name + "\'s Collar";
        mode = "pattern"
        en = "<name:str>'s Collar"
        ru = "Ошейник <name>"
    }
    {
        en = "MAX LEVEL"
        ru = "МАКС. УРОВЕНЬ"
    }
    // en = "<this.getName()> ([color=<this.Const.UI.Color.PositiveValue>]<woundsCalc>%[/color])"  // no text to translate
    {
        // local levelText = "Level " + this.m.Level + ", Health " + woundsCalc + "%"
        mode = "pattern"
        en = "Level <lvl:int>, Health <hp:val>"
        ru = "Уровень <lvl>, Здоровье <hp>"
    }
    {
        // levelText = "Level " + this.m.Level;
        mode = "pattern"
        en = "Level <lvl:int>"
        ru = "Уровень <lvl>"
    }
    {
        en = "Worn in Accessory Slot"
        ru = "Надет в слот аксессуара"
    }
    {
        en = "Usable in Combat"
        ru = "Используется в бою"
    }
    // en = "progressbar"  // internal sprite id
    {
        en = "The power of this incantation:"
        ru = "Мощь этого заклинания:"
    }
    {
        en = "This individual's base attributes:"
        ru = "Базовые характеристики:"
    }
    {
        en = "And its additional effects:"
        ru = "Дополнительные эффекты:"
    }
    {
        en = "And the quirks they possess:"
        ru = "Особенности:"
    }
    // en = "image"   // internal sprite id
    {
        en = "MAX"
        ru = "МАКС"
    }
    // en = "\nmod_AC=<this.m.Type>,<this.m.Level>,<this.m.XP>,<this.m.Wounds>,A=<this.m.Attributes.Hitpoints>,<this.m.Attributes.Stamina>,<this.m.Attributes.Bravery>,<this.m.Attributes.Initiative>,<this.m.Attributes.MeleeSkill>,<this.m.Attributes.RangedSkill>,<this.m.Attributes.MeleeDefense>,<this.m.Attributes.RangedDefense>,Q="  // internal serialization
    // en = "\nmod_AC="  // internal serialization (short form)
    // en = "<_cn.find(0x00000000)==null>"  // internal condition
    // en = "A="  // internal serialization key
    // en = "Q="  // internal serialization key

    // FILE: scripts/companions/companions_library.nut
    {
        en = "Wardog Collar"
        ru = "Ошейник боевого пса"
    }
    {
        en = "A strong and loyal dog bred for war. Can be unleashed in battle for scouting, tracking or running down routing enemies."
        ru = "Крепкий верный пёс, выращенный для войны. Может быть выпущен в бою для разведки, слежки или преследования бегущих врагов."
    }
    {
        en = "The collar of a wardog that has been unleashed onto the battlefield."
        ru = "Ошейник боевого пса, выпущенного на поле боя."
    }
    {
        en = "A strong and loyal dog bred for war. Can be unleashed in battle for scouting, tracking or running down routing enemies. This one wears a leather coat for protection against cutting wounds."
        ru = "Крепкий верный пёс, выращенный для войны. Может быть выпущен в бою для разведки, слежки или преследования бегущих врагов. Этот носит кожаный жилет, защищающий от порезов."
    }
    {
        en = "A strong and loyal dog bred for war. Can be unleashed in battle for scouting, tracking or running down routing enemies. This one wears a heavy hide coat for protection."
        ru = "Крепкий верный пёс, выращенный для войны. Может быть выпущен в бою для разведки, слежки или преследования бегущих врагов. Этот носит толстую шкуру для защиты."
    }
    {
        en = "Warhound Collar"
        ru = "Ошейник боевой гончей"
    }
    {
        en = "The collar of a warhound that has been unleashed onto the battlefield."
        ru = "Ошейник боевой гончей, выпущенной на поле боя."
    }
    {
        en = "A strong and loyal northern hound bred for war. Can be unleashed in battle for scouting, tracking or running down routing enemies. This one wears a leather coat for protection against cutting wounds."
        ru = "Крепкая верная северная гончая, выращенная для войны. Может быть выпущена в бою для разведки, слежки или преследования бегущих врагов. Эта носит кожаный жилет, защищающий от порезов."
    }
    {
        en = "A strong and loyal northern hound bred for war. Can be unleashed in battle for scouting, tracking or running down routing enemies. This one wears a heavy hide coat for protection."
        ru = "Крепкая верная северная гончая, выращенная для войны. Может быть выпущена в бою для разведки, слежки или преследования бегущих врагов. Эта носит толстую шкуру для защиты."
    }
    {
        en = "Wolf Collar"
        ru = "Ошейник волка"
    }
    {
        en = "A strong and wild wolf, tamed to be a loyal companion in battle. Can be unleashed in battle for scouting, tracking or running down routing enemies."
        ru = "Сильный дикий волк, приученный к верной службе в бою. Может быть выпущен в бою для разведки, слежки или преследования бегущих врагов."
    }
    {
        en = "The collar of a wolf that has been unleashed onto the battlefield."
        ru = "Ошейник волка, выпущенного на поле боя."
    }
    {
        en = "Direwolf Collar"
        ru = "Ошейник лютоволка"
    }
    {
        en = "A direwolf, tamed to be a loyal companion in battle. Can be unleashed in battle for scouting, tracking or running down routing enemies."
        ru = "Лютоволк, приученный к верной службе в бою. Может быть выпущен в бою для разведки, слежки или преследования бегущих врагов."
    }
    {
        en = "The collar of a direwolf that has been unleashed onto the battlefield."
        ru = "Ошейник лютоволка, выпущенного на поле боя."
    }
    {
        en = "A frenzied direwolf, tamed to be a loyal companion in battle. Can be unleashed in battle for scouting, tracking or running down routing enemies."
        ru = "Неистовый лютоволк, приученный к верной службе в бою. Может быть выпущен в бою для разведки, слежки или преследования бегущих врагов."
    }
    {
        en = "Hyena Collar"
        ru = "Ошейник гиены"
    }
    {
        en = "A hyena, tamed to be a loyal companion in battle. Can be unleashed in battle for scouting, tracking or running down routing enemies."
        ru = "Гиена, приученная к верной службе в бою. Может быть выпущена в бою для разведки, слежки или преследования бегущих врагов."
    }
    {
        en = "The collar of a hyena that has been unleashed onto the battlefield."
        ru = "Ошейник гиены, выпущенной на поле боя."
    }
    {
        en = "A frenzied hyena, tamed to be a loyal companion in battle. Can be unleashed in battle for scouting, tracking or running down routing enemies."
        ru = "Неистовая гиена, приученная к верной службе в бою. Может быть выпущена в бою для разведки, слежки или преследования бегущих врагов."
    }
    {
        en = "Webknecht Collar"
        ru = "Ошейник вебкнехта"
    }
    {
        en = "A webknecht, tamed to be a loyal companion in battle. Can be unleashed in battle for scouting, tracking or running down routing enemies."
        ru = "Вебкнехт, приученный к верной службе в бою. Может быть выпущен в бою для разведки, слежки или преследования бегущих врагов."
    }
    {
        en = "The collar of a webknecht that has been unleashed onto the battlefield."
        ru = "Ошейник вебкнехта, выпущенного на поле боя."
    }
    {
        en = "Serpent Collar"
        ru = "Ошейник змея"
    }
    {
        en = "A serpent, tamed to be a loyal companion in battle. Can be unleashed in battle for scouting, tracking or running down routing enemies."
        ru = "Змей, приученный к верной службе в бою. Может быть выпущен в бою для разведки, слежки или преследования бегущих врагов."
    }
    {
        en = "The collar of a serpent that has been unleashed onto the battlefield."
        ru = "Ошейник змея, выпущенного на поле боя."
    }
    {
        en = "Nachzehrer Collar"
        ru = "Ошейник нахцерера"
    }
    {
        en = "A nachzehrer, tamed to be a loyal companion in battle. Can be unleashed in battle for scouting, tracking or running down routing enemies."
        ru = "Нахцерер, приученный к верной службе в бою. Может быть выпущен в бою для разведки, слежки или преследования бегущих врагов."
    }
    {
        en = "The collar of a nachzehrer that has been unleashed onto the battlefield."
        ru = "Ошейник нахцерера, выпущенного на поле боя."
    }
    {
        en = "Alp Collar"
        ru = "Ошейник альпа"
    }
    {
        en = "An alp, tamed to be a loyal companion in battle. Can be unleashed in battle for scouting, tracking or running down routing enemies."
        ru = "Альп, приученный к верной службе в бою. Может быть выпущен в бою для разведки, слежки или преследования бегущих врагов."
    }
    {
        en = "The collar of an alp that has been unleashed onto the battlefield."
        ru = "Ошейник альпа, выпущенного на поле боя."
    }
    {
        en = "Unhold Collar"
        ru = "Ошейник тролля"
    }
    {
        en = "A unhold, tamed to be a loyal companion in battle. Can be unleashed in battle for scouting, tracking or running down routing enemies."
        ru = "Тролль, приученный к верной службе в бою. Может быть выпущен в бою для разведки, слежки или преследования бегущих врагов."
    }
    {
        en = "The collar of a unhold that has been unleashed onto the battlefield."
        ru = "Ошейник тролля, выпущенного на поле боя."
    }
    {
        en = "The collar of an unhold that has been unleashed onto the battlefield."
        ru = "Ошейник тролля, выпущенного на поле боя."
    }
    {
        en = "Schrat Collar"
        ru = "Ошейник шрата"
    }
    {
        en = "A schrat, tamed to be a loyal companion in battle. Can be unleashed in battle for scouting, tracking or running down routing enemies."
        ru = "Шрат, приученный к верной службе в бою. Может быть выпущен в бою для разведки, слежки или преследования бегущих врагов."
    }
    {
        en = "The collar of a schrat that has been unleashed onto the battlefield."
        ru = "Ошейник шрата, выпущенного на поле боя."
    }
    {
        en = "Lindwurm Collar"
        ru = "Ошейник линдворма"
    }
    {
        en = "A lindwurm, tamed to be a loyal companion in battle. Can be unleashed in battle for scouting, tracking or running down routing enemies."
        ru = "Линдвурм, приученный к верной службе в бою. Может быть выпущен в бою для разведки, слежки или преследования бегущих врагов."
    }
    {
        en = "The collar of a lindwurm that has been unleashed onto the battlefield."
        ru = "Ошейник линдворма, выпущенного на поле боя."
    }
    {
        en = "Tome of Reanimation"
        ru = "Фолиант воскрешения"
    }
    {
        en = "A mysterious tome that details the finer points of reanimating the dead."
        ru = "Таинственный фолиант, раскрывающий тонкости воскрешения мёртвых."
    }

    // FILE: scripts/companions/companions_names.nut
    // CanineNames
    {en = "Bruno" ru = "Бруно"}
    {en = "Hunter" ru = "Охотник"}
    {en = "Smoke" ru = "Дымок"}
    {en = "Outlaw" ru = "Изгой"}
    {en = "Kane" ru = "Каин"}
    {en = "Digger" ru = "Землерой"}
    {en = "Lightning" ru = "Молния"}
    {en = "Oracle" ru = "Оракул"}
    {en = "Phantom" ru = "Фантом"}
    {en = "Mudroch" ru = "Мудрох"}
    {en = "Hawkeye" ru = "Соколик"}
    {en = "Bullet" ru = "Пуля"}
    {en = "Loki" ru = "Локи"}
    {en = "Riggs" ru = "Риггс"}
    {en = "Comet" ru = "Комета"}
    {en = "Bear" ru = "Мишка"}
    {en = "Lupus" ru = "Волчара"}
    {en = "Echo" ru = "Эхо"}
    {en = "Snow" ru = "Снежок"}
    {en = "Ball" ru = "Шарик"}
    {en = "Rider" ru = "Всадник"}
    {en = "Dane" ru = "Датчанин"}
    {en = "Brutus" ru = "Брут"}
    {en = "Thunder" ru = "Гром"}
    {en = "Jax" ru = "Джакс"}
    {en = "Bones" ru = "Костяк"}
    {en = "Riptide" ru = "Прибой"}
    {en = "Hercules" ru = "Геракл"}
    {en = "Phoenix" ru = "Феникс"}
    {en = "Twilight" ru = "Сумерки"}
    {en = "Myth" ru = "Миф"}
    {en = "Tank" ru = "Танк"}
    {en = "Farkas" ru = "Фаркас"}
    {en = "Magnus" ru = "Магнус"}
    {en = "Brock" ru = "Барсук"}
    {en = "Silver" ru = "Серебряный"}
    {en = "Brown" ru = "Бурый"}
    {en = "Trouble" ru = "Проказник"}
    {en = "Drake" ru = "Дрейк"}
    {en = "Ice" ru = "Лёд"}
    {en = "Grunt" ru = "Рявка"}
    {en = "Maverick" ru = "Мэверик"}
    {en = "Hannibal" ru = "Ганнибал"}
    {en = "Bane" ru = "Бэйн"}
    {en = "Boulder" ru = "Валун"}
    {en = "Blaze" ru = "Вспышка"}
    {en = "Dash" ru = "Вихрь"}
    {en = "Atilla" ru = "Аттила"}
    {en = "Scar" ru = "Шрам"}
    {en = "Hulk" ru = "Халк"}
    {en = "Alpha" ru = "Альфа"}
    {en = "Archer" ru = "Лучник"}
    {en = "Boon" ru = "Дар"}
    {en = "Nero" ru = "Нерон"}
    {en = "Storm" ru = "Буря"}
    {en = "Ralph" ru = "Ральф"}
    {en = "Jinx" ru = "Сглаз"}
    {en = "Fern" ru = "Папоротник"}
    {en = "Brick" ru = "Кирпич"}
    {en = "Titan" ru = "Титан"}
    {en = "Shade" ru = "Полутень"}
    {en = "Menace" ru = "Гроза"}
    {en = "Blitz" ru = "Блиц"}
    {en = "Justice" ru = "Правосудие"}
    {en = "Raven" ru = "Ворон"}
    {en = "Hector" ru = "Гектор"}
    {en = "Rebel" ru = "Бунтарь"}
    {en = "Dust" ru = "Пыль"}
    {en = "Maximus" ru = "Максимус"}
    {en = "Caesar" ru = "Цезарь"}
    {en = "Logan" ru = "Логан"}
    {en = "Shadow" ru = "Тень"}
    {en = "Camelot" ru = "Камелот"}
    {en = "King" ru = "Царь"}
    {en = "Bolt" ru = "Вольт"}
    {en = "Judge" ru = "Судья"}
    {en = "Odin" ru = "Один"}
    {en = "Shredder" ru = "Шреддер"}
    {en = "Mayhem" ru = "Смута"}
    {en = "Sly" ru = "Хитрюга"}
    {en = "Omen" ru = "Знамение"}
    {en = "Razor" ru = "Бритва"}
    {en = "Lupin" ru = "Люпен"}
    {en = "Ghost" ru = "Призрак"}
    {en = "Frost" ru = "Мороз"}
    {en = "Goliath" ru = "Голиаф"}
    {en = "Baron" ru = "Барон"}
    {en = "Fury" ru = "Ярость"}
    {en = "Nightmare" ru = "Кошмар"}
    {en = "Diablo" ru = "Дьябло"}
    {en = "Lotus" ru = "Лотос"}
    {en = "Rags" ru = "Лохматик"}
    {en = "Whisper" ru = "Шёпот"}
    {en = "Dot" ru = "Точка"}
    {en = "Rogue" ru = "Плут"}
    {en = "Bo" ru = "Бо"}
    {en = "Chronos" ru = "Хронос"}
    {en = "Winter" ru = "Зима"}
    {en = "Lore" ru = "Предание"}
    {en = "Banshee" ru = "Баньши"}

    // SlitherachnoNames
    {en = "Szeq'ri" ru = "Щек'ри"}
    {en = "Ichik'zol" ru = "Ичик'зол"}
    {en = "Ok'tur" ru = "Ок'тур"}
    {en = "Raq'rud" ru = "Рак'руд"}
    {en = "Cor'os" ru = "Кор'ос"}
    {en = "Zit'iced" ru = "Зит'ицед"}
    {en = "Qaq'rivir" ru = "Как'ривир"}
    {en = "Nair'eh" ru = "Наир'эх"}
    {en = "At'or" ru = "Ат'ор"}
    {en = "Zachik'sas" ru = "Зачик'сас"}
    {en = "Khocuk'zed" ru = "Хоцук'зед"}
    {en = "Chian'qe" ru = "Чиан'ке"}
    {en = "Char'al" ru = "Чар'ал"}
    {en = "Qezeet'ih" ru = "Кезит'их"}
    {en = "Nash'ti" ru = "Наш'ти"}
    {en = "Rhas'tol" ru = "Рас'тол"}
    {en = "Yak'seesil" ru = "Як'сисил"}
    {en = "Sak'sieh" ru = "Сак'сиэх"}
    {en = "Esit'iar" ru = "Эсит'иар"}
    {en = "As'tu" ru = "Ас'ту"}
    {en = "Nok'sul" ru = "Нок'сул"}
    {en = "Ziq'rid" ru = "Зик'рид"}
    {en = "Cek'zo" ru = "Цек'зо"}
    {en = "Yeezis'tis" ru = "Изис'тис"}
    {en = "Zhocit'is" ru = "Жоцит'ис"}
    {en = "Sen'qeh" ru = "Сен'кех"}
    {en = "Ros'tah" ru = "Рос'тах"}
    {en = "Yit'er" ru = "Ит'ер"}
    {en = "Khis'ti" ru = "Хис'ти"}
    {en = "Rhis'tuq" ru = "Рис'тук"}
    {en = "Zhik'zuq" ru = "Жик'зук"}
    {en = "Niq'rih" ru = "Ник'рих"}
    {en = "Seet'u" ru = "Сит'у"}
    {en = "Yeq'rud" ru = "Ек'руд"}
    {en = "Zhir'ar" ru = "Жир'ар"}
    {en = "Khen'qir" ru = "Хен'кир"}
    {en = "Szek'seer" ru = "Щек'сир"}
    {en = "Qait'oq" ru = "Кайт'ок"}
    {en = "Lan'qiq" ru = "Лан'кик"}
    {en = "At'eeh" ru = "Ат'их"}
    {en = "Zheq'ririaq" ru = "Жек'ририак"}
    {en = "Ik'suza" ru = "Ик'суза"}
    {en = "Qhes'tuq" ru = "Кхес'тук"}
    {en = "Qot'el" ru = "Кот'эл"}
    {en = "Qhaik'zil" ru = "Кхайк'зил"}
    {en = "Qhas'til" ru = "Кхас'тил"}
    {en = "Cik'ziq" ru = "Цик'зик"}
    {en = "Cit'ol" ru = "Цит'ол"}
    {en = "Zees'toq" ru = "Зис'ток"}
    {en = "Lar'a" ru = "Лар'а"}
    {en = "Savoq'ri" ru = "Савок'ри"}
    {en = "Aq'ro" ru = "Ак'ро"}
    {en = "Qaq'roh" ru = "Как'рох"}
    {en = "Eq'rar" ru = "Эк'рар"}
    {en = "An'qad" ru = "Ан'кад"}
    {en = "Yik'ziq" ru = "Ик'зик"}
    {en = "Nis'tod" ru = "Нис'тод"}
    {en = "Zharik'se" ru = "Жарик'се"}
    {en = "Rat'oq" ru = "Рат'ок"}
    {en = "Nik'sah" ru = "Ник'сах"}
    {en = "Reeq'rie" ru = "Рик'рие"}
    {en = "Khas'tar" ru = "Хас'тар"}
    {en = "En'qiqar" ru = "Эн'кикар"}
    {en = "Sin'qeh" ru = "Син'кэх"}
    {en = "It'e" ru = "Ит'э"}
    {en = "Chair'os" ru = "Чаир'ос"}
    {en = "Cicer'oh" ru = "Цицер'ох"}
    {en = "Er'ee" ru = "Эр'и"}
    {en = "Seek'sod" ru = "Сик'сод"}
    {en = "Szet'i" ru = "Щет'и"}
    {en = "Yaik'zaq" ru = "Яйк'зак"}
    {en = "Nak'rix" ru = "Нак'рикс"}
    {en = "Caqel'zas" ru = "Цакел'зас"}
    {en = "Ok'zax" ru = "Ок'закс"}
    {en = "Kal'zichab" ru = "Кал'зичаб"}
    {en = "Lat'as" ru = "Лат'ас"}
    {en = "Kriqurk'aat" ru = "Крикурк'ат"}
    {en = "Srin'qax" ru = "Срин'какс"}
    {en = "Sricik'rox" ru = "Срицик'рокс"}
    {en = "Nek'za" ru = "Нек'за"}
    {en = "Chak'zokir" ru = "Чак'зокир"}
    {en = "Neq'zachar" ru = "Нек'захар"}
    {en = "Es'tizar" ru = "Эс'тизар"}
    {en = "Ork'urrax" ru = "Орк'уррракс"}
    {en = "Zel'zeex" ru = "Зел'зикс"}
    {en = "Szaaq'tir" ru = "Щак'тир"}
    {en = "Krak'sax" ru = "Крак'сакс"}
    {en = "Sichaq'zar" ru = "Сичак'зар"}
    {en = "Nos'tieqix" ru = "Нос'тиэкикс"}
    {en = "Kik'rutes" ru = "Кик'рутэс"}
    {en = "Oug'zee" ru = "Уг'зи"}
    {en = "Qhok'saciad" ru = "Кхок'сациад"}
    {en = "Sacog'zar" ru = "Саког'зар"}
    {en = "Kiq'zaq" ru = "Кик'зак"}
    {en = "Sairul'zis" ru = "Сайрул'зис"}
    {en = "Zork'ab" ru = "Зорк'аб"}
    {en = "Kek'zeb" ru = "Кек'зэб"}
    {en = "Naq'tiet" ru = "Нак'тиэт"}
    {en = "Srak'sux" ru = "Срак'сукс"}
    {en = "Oun'qit" ru = "Ун'кит"}
    {en = "Zrel'zut" ru = "Зрел'зут"}
    {en = "Srazark'et" ru = "Сразарк'эт"}
    {en = "Otin'qaix" ru = "Отин'кайкс"}
    {en = "Kreeq'zid" ru = "Крик'зид"}
    {en = "Krikos'te" ru = "Крикос'тэ"}
    {en = "Krak'sis" ru = "Крак'сис"}
    {en = "Rik'saq" ru = "Рик'сак"}
    {en = "Ark'iit" ru = "Арк'ит"}
    {en = "Kiqork'er" ru = "Кикорк'эр"}
    {en = "Rhacuq'zax" ru = "Рацук'закс"}
    {en = "Yial'zit" ru = "Йиал'зит"}
    {en = "San'qo" ru = "Сан'ко"}
    {en = "Krork'iq" ru = "Крорк'ик"}
    {en = "Sriakog'zi" ru = "Сриаког'зи"}
    {en = "Zren'qiex" ru = "Зрен'киэкс"}
    {en = "Zrex'ut" ru = "Зрекс'ут"}
    {en = "Chok'riq" ru = "Чок'рик"}
    {en = "Zrezis'tiq" ru = "Зрезис'тик"}
    {en = "Qirk'ees" ru = "Кирк'ис"}
    {en = "Izik'ze" ru = "Изик'зэ"}
    {en = "Szal'zob" ru = "Щал'зоб"}
    {en = "Srarrix'aaq" ru = "Сраррикс'ак"}
    {en = "Leex'ieria" ru = "Ликс'иэриа"}
    {en = "Zeen'qiq" ru = "Зин'кик"}
    {en = "Rhouk'rix" ru = "Рук'рикс"}
    {en = "Yak'rox" ru = "Як'рокс"}
    {en = "Rel'zuq" ru = "Рел'зук"}
    {en = "Zril'zax" ru = "Зрил'закс"}
    {en = "Sreek'terri" ru = "Срик'терри"}
    {en = "Kais'za" ru = "Кайс'за"}
    {en = "Yex'uq" ru = "Екс'ук"}
    {en = "Eek'zucheb" ru = "Ик'зучэб"}
    {en = "Khakiq'zot" ru = "Хакик'зот"}
    {en = "Al'zix" ru = "Ал'зикс"}

    // GutturalNames
    {en = "Koq" ru = "Кок"}
    {en = "Guaq" ru = "Гуак"}
    {en = "Zajoq" ru = "Зажок"}
    {en = "Chatzug" ru = "Чацуг"}
    {en = "Butgaq" ru = "Бутгак"}
    {en = "Voz" ru = "Воз"}
    {en = "Jik" ru = "Джик"}
    {en = "Ubac" ru = "Убац"}
    {en = "Rubbag" ru = "Руббаг"}
    {en = "Rixzok" ru = "Риксзок"}
    {en = "Boz" ru = "Боз"}
    {en = "Vok" ru = "Вок"}
    {en = "Bax" ru = "Бакс"}
    {en = "Khograk" ru = "Хограк"}
    {en = "Kunaq" ru = "Кунак"}
    {en = "Khaz" ru = "Хаз"}
    {en = "Zujid" ru = "Зужид"}
    {en = "Khok" ru = "Хок"}
    {en = "Gux" ru = "Гукс"}
    {en = "Kog" ru = "Ког"}
    {en = "Joqric" ru = "Джокрик"}
    {en = "Auskux" ru = "Аускукс"}
    {en = "Agzac" ru = "Агзац"}
    {en = "Orgod" ru = "Оргод"}
    {en = "Bod" ru = "Бод"}
    {en = "Khud" ru = "Худ"}
    {en = "Uquk" ru = "Укук"}
    {en = "Onkoz" ru = "Онкоз"}
    {en = "Boq" ru = "Бок"}
    {en = "Vuq" ru = "Вук"}
    {en = "Vodrut" ru = "Водрут"}
    {en = "Guzzax" ru = "Гуззакс"}
    {en = "Ralgruq" ru = "Ралгрук"}
    {en = "Gubbot" ru = "Губбот"}
    {en = "Galgac" ru = "Галгац"}
    {en = "Chot" ru = "Чот"}
    {en = "Gattaz" ru = "Гаттаз"}
    {en = "Jutgouz" ru = "Джутгауз"}
    {en = "Vaut" ru = "Ваут"}
    {en = "Gaubnac" ru = "Гаубнац"}
    {en = "Kottaug" ru = "Коттауг"}
    {en = "Khixnog" ru = "Хиксног"}
    {en = "Kodrod" ru = "Кодрод"}
    {en = "Urduq" ru = "Урдук"}
    {en = "Jugrik" ru = "Джугрик"}
    {en = "Gaz" ru = "Газ"}
    {en = "Gurgud" ru = "Гургуд"}
    {en = "Khitgoq" ru = "Хитгок"}
    {en = "Zogrok" ru = "Зогрок"}
    {en = "Zoug" ru = "Зауг"}
    {en = "Kalkrak" ru = "Калкрак"}
    {en = "Koktoc" ru = "Коктоц"}
    {en = "Chuk" ru = "Чук"}
    {en = "Zuxxat" ru = "Зуксат"}
    {en = "Umkag" ru = "Умкаг"}
    {en = "Khoz" ru = "Хоз"}
    {en = "Zusgaz" ru = "Зусгаз"}
    {en = "Vuk" ru = "Вук"}
    {en = "Aggox" ru = "Аггокс"}
    {en = "Ruknat" ru = "Рукнат"}
    {en = "Bokux" ru = "Бокукс"}
    {en = "Varak" ru = "Варак"}
    {en = "Orok" ru = "Орок"}
    {en = "Khik" ru = "Хик"}
    {en = "Vugduq" ru = "Вугдук"}
    {en = "Rablok" ru = "Раблок"}
    {en = "Banzod" ru = "Банзод"}
    {en = "Jalkog" ru = "Джалког"}
    {en = "Zuk" ru = "Зук"}
    {en = "Jogzud" ru = "Джогзуд"}
    {en = "Oxuz" ru = "Оксуз"}
    {en = "Khax" ru = "Хакс"}
    {en = "Khingrok" ru = "Хингрок"}
    {en = "Askrauq" ru = "Аскраук"}
    {en = "Babloz" ru = "Баблоз"}
    {en = "Khutaq" ru = "Хутак"}
    {en = "Ozbac" ru = "Озбац"}
    {en = "Ukvod" ru = "Уквод"}
    {en = "Kamux" ru = "Камукс"}
    {en = "Atrac" ru = "Атрац"}
    {en = "Gukuz" ru = "Гукуз"}
    {en = "Guthib" ru = "Гутхиб"}
    {en = "Ardrok" ru = "Ардрок"}
    {en = "Chankrax" ru = "Чанкракс"}
    {en = "Khuksud" ru = "Хуксуд"}
    {en = "Burvod" ru = "Бурвод"}
    {en = "Zumgud" ru = "Зумгуд"}
    {en = "Juk" ru = "Джук"}
    {en = "Gaxzoz" ru = "Гаксзоз"}
    {en = "Chokdux" ru = "Чокдукс"}
    {en = "Khosqot" ru = "Хоскот"}
    {en = "Kirbug" ru = "Кирбуг"}
    {en = "Chonkrok" ru = "Чонкрок"}
    {en = "Zolkot" ru = "Золкот"}
    {en = "Chalgog" ru = "Чалгог"}
    {en = "Ongrod" ru = "Онгрод"}
    {en = "Olduq" ru = "Олдук"}
    {en = "Zosqid" ru = "Зоскид"}
    {en = "Aqok" ru = "Акок"}
    {en = "Zituq" ru = "Зитук"}
    {en = "Uldoz" ru = "Улдоз"}
    {en = "Balgrag" ru = "Балграг"}
    {en = "Onkag" ru = "Онкаг"}
    {en = "Rankuc" ru = "Ранкуц"}
    {en = "Aqruq" ru = "Акрук"}
    {en = "Gog" ru = "Гог"}
    {en = "Gunkat" ru = "Гункат"}
    {en = "Khak" ru = "Хак"}
    {en = "Kitgut" ru = "Китгут"}
    {en = "Khugot" ru = "Хугот"}
    {en = "Khuzut" ru = "Хузут"}
    {en = "Boxud" ru = "Боксуд"}
    {en = "Bidroq" ru = "Бидрок"}
    {en = "Kazluz" ru = "Казлуз"}
    {en = "Vamkag" ru = "Вамкаг"}
    {en = "Zudrid" ru = "Зудрид"}
    {en = "Gonkrid" ru = "Гонкрид"}
    {en = "Vuzbuk" ru = "Вузбук"}
    {en = "Gakzak" ru = "Гакзак"}
    {en = "Bingrok" ru = "Бингрок"}
    {en = "Akgix" ru = "Акгикс"}
    {en = "Chokgog" ru = "Чокгог"}
    {en = "Ilgruk" ru = "Илгрук"}
    {en = "Vabluz" ru = "Ваблуз"}

    // TreefolkNames
    {en = "Pervalur" ru = "Первалур"}
    {en = "Tralen" ru = "Тралэн"}
    {en = "Carnel" ru = "Карнэл"}
    {en = "Fenmaris" ru = "Фэнмарис"}
    {en = "Elakas" ru = "Элакас"}
    {en = "Glynmenor" ru = "Глинмэнор"}
    {en = "Waesven" ru = "Вэсвэн"}
    {en = "Genren" ru = "Гэнрэн"}
    {en = "Lutoris" ru = "Луторис"}
    {en = "Qinnorin" ru = "Киннорин"}
    {en = "Thelamin" ru = "Тэламин"}
    {en = "Heimenor" ru = "Хэймэнор"}
    {en = "Dornan" ru = "Дорнан"}
    {en = "Tracan" ru = "Тракан"}
    {en = "Advalur" ru = "Адвалур"}
    {en = "Elsalor" ru = "Элсалор"}
    {en = "Kelxalim" ru = "Кэлксалим"}
    {en = "Naehorn" ru = "Нэйхорн"}
    {en = "Aexidor" ru = "Эксидор"}
    {en = "Raloris" ru = "Ралорис"}
    {en = "Fenwarin" ru = "Фэнварин"}
    {en = "Leolar" ru = "Лэолар"}
    {en = "Keanan" ru = "Кэанан"}
    {en = "Qidark" ru = "Кидарк"}
    {en = "Umero" ru = "Умэро"}
    {en = "Patoris" ru = "Паторис"}
    {en = "Urijor" ru = "Урижор"}
    {en = "Olonan" ru = "Олонан"}
    {en = "Fenwraek" ru = "Фэнврэйк"}
    {en = "Zumvalur" ru = "Зумвалур"}
    {en = "Mirasalor" ru = "Мирасалор"}
    {en = "Kelqen" ru = "Кэлкэн"}
    {en = "Paren" ru = "Парэн"}
    {en = "Permaer" ru = "Пэрмэйр"}
    {en = "Lujor" ru = "Лужор"}
    {en = "Leoran" ru = "Лэоран"}
    {en = "Eljor" ru = "Элжор"}
    {en = "Sarren" ru = "Саррэн"}
    {en = "Sarfir" ru = "Сарфир"}
    {en = "Zumfaren" ru = "Зумфарэн"}
    {en = "Naeceran" ru = "Нэйсэран"}
    {en = "Adnorin" ru = "Аднорин"}
    {en = "Wranneiros" ru = "Враннэйрос"}
    {en = "Perxalim" ru = "Пэрксалим"}
    {en = "Naetoris" ru = "Нэйторис"}
    {en = "Gensalor" ru = "Гэнсалор"}
    {en = "Farquinal" ru = "Фаркуинал"}
    {en = "Ilizeiros" ru = "Илизэйрос"}
    {en = "Norkian" ru = "Норкиан"}
    {en = "Aelen" ru = "Эйлэн"}
    {en = "Waesran" ru = "Вэсран"}
    {en = "Beifir" ru = "Бэйфир"}
    {en = "Mirawraek" ru = "Мираврэйк"}
    {en = "Heryarus" ru = "Хэрьярус"}
    {en = "Lumaris" ru = "Лумарис"}
    {en = "Farlen" ru = "Фарлэн"}
    {en = "Elpetor" ru = "Элпэтор"}
    {en = "Mormaris" ru = "Мормарис"}
    {en = "Iliris" ru = "Илирис"}
    {en = "Zinsandoral" ru = "Зинсандорал"}
    {en = "Morkian" ru = "Моркиан"}
    {en = "Vacan" ru = "Вакан"}
    {en = "Elaven" ru = "Элавэн"}
    {en = "Zumtoris" ru = "Зумторис"}
    {en = "Trawarin" ru = "Траварин"}
    {en = "Glynhice" ru = "Глинхис"}
    {en = "Tramenor" ru = "Трамэнор"}
    {en = "Crafaren" ru = "Крафарэн"}
    {en = "Virpetor" ru = "Вирпэтор"}
    {en = "Zumneiros" ru = "Зумнэйрос"}
    {en = "Hervalur" ru = "Хэрвалур"}
    {en = "Wranlar" ru = "Вранлар"}
    {en = "Sylnorin" ru = "Силнорин"}
    {en = "Beisendoral" ru = "Бэйсэндорал"}
    {en = "Daepetor" ru = "Дэйпэтор"}
    {en = "Dorlar" ru = "Дорлар"}
    {en = "Norgeiros" ru = "Норгэйрос"}
    {en = "Naelamin" ru = "Нэйламин"}
    {en = "Fargolor" ru = "Фарголор"}
    {en = "Dorlamin" ru = "Дорламин"}
    {en = "Vavalur" ru = "Вавалур"}
    {en = "Theven" ru = "Тэвэн"}
    {en = "Ologolor" ru = "Ологолор"}
    {en = "Zumzumin" ru = "Зумзумин"}
    {en = "Waeshice" ru = "Вэсхис"}
    {en = "Carxalim" ru = "Карксалим"}

    // SpookNames
    {en = "Criozhar" ru = "Криожар"}
    {en = "Shelak" ru = "Шэлак"}
    {en = "Strigrim" ru = "Стригрим"}
    {en = "Krorius" ru = "Крориус"}
    {en = "Dagrim" ru = "Дагрим"}
    {en = "Ocraedulus" ru = "Окрэдулус"}
    {en = "Rivok" ru = "Ривок"}
    {en = "Folekai" ru = "Фолэкай"}
    {en = "Waxor" ru = "Ваксор"}
    {en = "Krivok" ru = "Кривок"}
    {en = "Saugan" ru = "Сауган"}
    {en = "Gerow" ru = "Гэров"}
    {en = "Griozhul" ru = "Гриожул"}
    {en = "Prokar" ru = "Прокар"}
    {en = "Straqir" ru = "Стракир"}
    {en = "Izexius" ru = "Изэксиус"}
    {en = "Gemien" ru = "Гэмиэн"}
    {en = "Kedulus" ru = "Кэдулус"}
    {en = "Staulak" ru = "Стаулак"}
    {en = "Beigrim" ru = "Бэйгрим"}
    {en = "Istoughor" ru = "Истаугор"}
    {en = "Namien" ru = "Намиэн"}
    {en = "Wozhul" ru = "Вожул"}
    {en = "Huthik" ru = "Хутик"}
    {en = "Vuxir" ru = "Вуксир"}
    {en = "Cedum" ru = "Цэдум"}
    {en = "Upimien" ru = "Упимиэн"}
    {en = "Chothum" ru = "Чотум"}
    {en = "Wavras" ru = "Ваврас"}
    {en = "Houlak" ru = "Хаулак"}
    {en = "Braghor" ru = "Брагор"}
    {en = "Crozius" ru = "Крозиус"}
    {en = "Ludulus" ru = "Лудулус"}
    {en = "Stequr" ru = "Стэкур"}
    {en = "Drolazar" ru = "Дролазар"}
    {en = "Caudum" ru = "Каудум"}
    {en = "Nogrim" ru = "Ногрим"}
    {en = "Bibrum" ru = "Бибрум"}
    {en = "Waekhar" ru = "Вэйхар"}
    {en = "Ridhur" ru = "Ридур"}
    {en = "Bouthum" ru = "Баутум"}
    {en = "Xeqir" ru = "Ксэкир"}
    {en = "Acrazad" ru = "Акразад"}
    {en = "Verius" ru = "Вэриус"}
    {en = "Atiozhul" ru = "Атиожул"}
    {en = "Lebrum" ru = "Лэбрум"}
    {en = "Faevras" ru = "Фэйврас"}
    {en = "Kroxor" ru = "Кроксор"}
    {en = "Bakras" ru = "Бакрас"}
    {en = "Ceithik" ru = "Цэйтик"}
    {en = "Vremon" ru = "Врэмон"}
    {en = "Withik" ru = "Витик"}
    {en = "Adiokras" ru = "Адиокрас"}
    {en = "Edrapent" ru = "Эдрапэнт"}
    {en = "Mauthum" ru = "Маутум"}
    {en = "Lodan" ru = "Лодан"}
    {en = "Gerius" ru = "Гэриус"}
    {en = "Taezor" ru = "Тэйзор"}
    {en = "Caxius" ru = "Каксиус"}
    {en = "Nupent" ru = "Нупэнт"}
    {en = "Yorius" ru = "Йориус"}
    {en = "Brelazar" ru = "Брэлазар"}
    {en = "Shizhar" ru = "Шижар"}
    {en = "Otazad" ru = "Отазад"}
    {en = "Mozhul" ru = "Можул"}
    {en = "Apekar" ru = "Апэкар"}
    {en = "Vrizad" ru = "Вризад"}
    {en = "Dikhar" ru = "Дикар"}
    {en = "Edabrum" ru = "Эдабрум"}
    {en = "Mazius" ru = "Мазиус"}
    {en = "Dithik" ru = "Дитик"}
    {en = "Tarael" ru = "Тарэл"}
    {en = "Vaelekai" ru = "Вэйлэкай"}
    {en = "Sazius" ru = "Сазиус"}
    {en = "Hicular" ru = "Хикулар"}
    {en = "Belak" ru = "Бэлак"}
    {en = "Gozhar" ru = "Гожар"}
    {en = "Afatic" ru = "Афатик"}
    {en = "Tazhul" ru = "Тажул"}
    {en = "Prethum" ru = "Прэтум"}
    {en = "Procular" ru = "Прокулар"}
    {en = "Hezar" ru = "Хэзар"}
    {en = "Shozar" ru = "Шозар"}
    {en = "Vraughor" ru = "Враугор"}
    {en = "Paekar" ru = "Пэйкар"}
    {en = "Vizhul" ru = "Вижул"}
    {en = "Veghor" ru = "Вэгор"}
    {en = "Rouxius" ru = "Рауксиус"}
    {en = "Exakai" ru = "Эксакай"}
    {en = "Xaxor" ru = "Ксаксор"}
    {en = "Achelazar" ru = "Акэлазар"}
    {en = "Ecedulus" ru = "Эцэдулус"}
    {en = "Igrexius" ru = "Игрэксиус"}
    {en = "Wrurius" ru = "Вруриус"}
    {en = "Gazhul" ru = "Гажул"}
    {en = "Greilazar" ru = "Грэйлазар"}
    {en = "Mevok" ru = "Мэвок"}
    {en = "Mezor" ru = "Мэзор"}
    {en = "Caelekai" ru = "Кэйлэкай"}
    {en = "Wramien" ru = "Врамиэн"}
    {en = "Zemien" ru = "Зэмиэн"}
    {en = "Tacular" ru = "Такулар"}
    {en = "Drulazar" ru = "Друлазар"}
    {en = "Kiodum" ru = "Киодум"}

    // FILE: scripts/companions/onequip/companions_leash.nut
    {
        // this.m.Name = "Leash " + this.m.Item.m.Name;
        mode = "pattern"
        en = "Leash <name:str>"
        ru = "Поводок: <name>"
    }
    {
        // this.m.Description = "Leash " + this.m.Item.m.Name + " and remove them from the battlefield...";
        mode = "pattern"
        en = "Leash <name:str> and remove them from the battlefield. They must not be charmed, stunned, rooted nor fleeing."
        ru = "Взять <name> на поводок и убрать с поля боя. Цель не должна быть очарована, оглушена, обездвижена или отступать."
    }
    // FILE: scripts/companions/onequip/companions_raise.nut
    {
        en = "Reanimate Dead"
        ru = "Поднять мертвеца"
    }
    {
        en = "Reanimate the dead and have them engage the enemy. Requires a resurrectable corpse on an empty tile. Can be used twice per battle."
        ru = "Поднять мертвеца и направить против врага. Требуется воскрешаемый труп на пустой клетке. Можно использовать дважды за бой."
    }
    {
        // text = "Has a max range of [color=...]" + this.m.MaxRange + "[/color] tiles"
        mode = "pattern"
        en = "Has a max range of <range:int_tag> tiles"
        ru = "Максимальная дальность — <range> клеток"
    }
    {
        // this.Tactical.EventLog.log(getColorizedEntityName(_user) + " reanimates the dead");
        mode = "pattern"
        en = "<user:str_tag> reanimates the dead"
        ru = "<user> поднимает мертвеца"
    }
    // FILE: scripts/companions/onequip/companions_unleash.nut
    {
        // this.m.Name = "Unleash " + this.m.Item.m.Name;
        mode = "pattern"
        en = "Unleash <name:str>"
        ru = "Выпустить: <name>"
    }
    {
        // this.m.Description = "Unleash " + this.m.Item.m.Name + " and have them engage the enemy...";
        mode = "pattern"
        en = "Unleash <name:str> and have them engage the enemy. Needs a free adjacent tile. Can be used once per battle."
        ru = "Выпустить <name> и направить против врага. Нужна свободная соседняя клетка. Можно использовать раз в бою."
    }
    {
        mode = "pattern"
        en = "Unleash <name:str> and have them engage the enemy. Needs a free adjacent tile (and a free adjacent tile next to that one, for the tail). Can be used once per battle."
        ru = "Выпустить <name> и направить против врага. Нужна свободная соседняя клетка (и ещё одна рядом — для хвоста). Можно использовать раз в бою."
    }
    // FILE: scripts/companions/player/companions_tame.nut
    {
        en = "Tame Beast"
        ru = "Приручить зверя"
    }
    {
        en = "Attempt to tame an adjacent beast. Failing the attempt makes further attempts on the same beast impossible. Succeeding the attempt equips the beast in the brother's accessory slot, but it cannot be unleashed in the same battle in which it was tamed."
        ru = "Попытаться приручить соседнего зверя. При неудаче дальнейшие попытки на том же звере невозможны. При успехе зверь надевается в слот аксессуара наёмника, но не может быть выпущен в том же бою, в котором был пойман."
    }
    {
        // getColorizedEntityName(actor) + " successfully tamed " + getColorizedEntityName(target) + ". Chance was merely " + (chance / 10.0) + "%"
        mode = "pattern"
        en = "<actor:str_tag> successfully tamed <target:str_tag>. Chance was merely <chance:val>%"
        ru = "<actor> успешно приручил <target>. Шанс был всего <chance>%"
    }
    // en = "<this.isKindOf(target, , , lindwurm)&&target.m.Tail!=null&&!target.m.Tail.isNull()&&target.m.Tail.isAlive()>"  // internal condition
    {
        // getColorizedEntityName(actor) + " failed to tame " + getColorizedEntityName(target) + ". Chance was merely " + (chance / 10.0) + "%"
        mode = "pattern"
        en = "<actor:str_tag> failed to tame <target:str_tag>. Chance was merely <chance:val>%"
        ru = "<actor> не смог приручить <target>. Шанс был всего <chance>%"
    }
    // FILE: scripts/companions/player/companions_taming_protection.nut
    {
        en = "Taming Protection"
        ru = "Защита от приручения"
    }
    {
        en = "Cannot be tamed."
        ru = "Не поддаётся приручению."
    }
    // FILE: scripts/companions/quirks/companions_berserker_rage.nut
    {
        en = "Rage"
        ru = "Ярость"
    }
    {
        en = "Rage."
        ru = "Ярость."
    }
    {
        // getColorizedEntityName(actor) + " gains rage!"
        mode = "pattern"
        en = "<actor:str_tag> gains rage!"
        ru = "<actor> впадает в ярость!"
    }
    // FILE: scripts/companions/quirks/companions_good_boy.nut
    {
        en = "Good Boy/Girl"
        ru = "Хороший мальчик/девочка"
    }
    {
        en = "Who's a good boy?!"
        ru = "Кто хороший мальчик?!"
    }
    // FILE: scripts/companions/quirks/companions_healthy.nut
    {
        en = "Healthy"
        ru = "Здоровяк"
    }
    {
        en = "This entity is a picture of health."
        ru = "Само воплощение здоровья."
    }
    // FILE: scripts/companions/quirks/companions_poisonous.nut
    {
        en = "Poisonous"
        ru = "Ядовитый"
    }
    {
        en = "Poisonous."
        ru = "Ядовитый."
    }
    {
        // getColorizedEntityName(_targetEntity) + " is poisoned"
        mode = "pattern"
        en = "<target:str_tag> is poisoned"
        ru = "<target> отравлен"
    }
    // FILE: scripts/companions/quirks/companions_regenerative.nut
    {
        en = "Regenerative"
        ru = "Регенерирующий"
    }
    {
        en = "Regenerates health"
        ru = "Восстанавливает здоровье"
    }
    {
        // getColorizedEntityName(actor) + " heals for " + healthAdded + " points"
        mode = "pattern"
        en = "<actor:str_tag> heals for <hp:int> points"
        ru = "<actor> восстанавливает <hp> ОЗ"
    }
    // FILE: scripts/companions/quirks/companions_soften_blows.nut
    {
        en = "Soften Blows"
        ru = "Смягчение ударов"
    }
    {
        en = "Brace yourself for incoming attacks!"
        ru = "Приготовься к входящим ударам!"
    }
    // FILE: scripts/companions/skills/companions_nightmare_skill.nut
    {
        en = "Died of nightmares"
        ru = "Умер от кошмаров"
    }
    // FILE: scripts/companions/skills/companions_swallow_whole.nut
    {
        en = "Swallow Whole"
        ru = "Проглотить целиком"
    }
    {
        // getColorizedEntityName(_user) + " devours " + getColorizedEntityName(target)
        mode = "pattern"
        en = "<user:str_tag> devours <target:str_tag>"
        ru = "<user> пожирает <target>"
    }
    // en = "<this.m.SwallowedEntity.getFlags().set(Devoured, true)>"  // internal flag setter
    // FILE: scripts/companions/types/companions_alp.nut
    {
        en = "Alp"
        ru = "Альп"
    }
    {
        // corpse.CorpseName = "An " + this.getName();
        mode = "pattern"
        en = "An <name:str>"
        ru = "<name:t>"
    }
    // en = "Corpse"  // internal property key
    // FILE: scripts/companions/types/companions_direwolf.nut
    {
        en = "Direwolf"
        ru = "Лютоволк"
    }
    {
        en = "A Direwolf"
        ru = "Лютоволк"
    }
    // FILE: scripts/companions/types/companions_hyena.nut
    {
        en = "Hyena"
        ru = "Гиена"
    }
    {
        en = "A Hyena"
        ru = "Гиена"
    }
    // FILE: scripts/companions/types/companions_nacho.nut
    {
        en = "Nachzehrer"
        ru = "Нахцерер"
    }
    // en = "<this.getFlags().add(ghoul)>"   // internal flag operation
    // en = "<this.getFlags().add(undead)>"  // internal flag operation
    // en = "body"    // internal sprite id
    // en = "head"    // internal sprite id
    {
        // corpse.CorpseName = "A " + this.getName();
        mode = "pattern"
        en = "A <name:str>"
        ru = "<name:t>"
    }
    // en = "<e.getFlags().set(Devoured, false)>"  // internal flag setter
    // FILE: scripts/companions/types/companions_noodle.nut
    {
        en = "Lindwurm"
        ru = "Линдвурм"
    }
    // en = "<this.getFlags().add(lindwurm)>"  // internal flag operation
    {
        en = "A Lindwurm"
        ru = "Линдвурм"
    }
    {
        // this.m.Tail.m.Name = this.m.Name + "\'s tail";
        mode = "pattern"
        en = "<name:str>'s tail"
        ru = "Хвост <name>"
    }
    // FILE: scripts/companions/types/companions_noodle_tail.nut
    {
        en = "Lindwurm tail"
        ru = "Хвост линдворма"
    }
    {
        // getColorizedEntityName(this) + "\'s natural armor is hit for [b]" + dmg + "[/b] damage"
        mode = "pattern"
        en = "<entity:str_tag>'s natural armor is hit for [b]<dmg:int_tag>[/b] damage"
        ru = "Природная броня <entity> получила <dmg> урона"
    }
    {
        en = "Suffered an injury"
        ru = "Получил увечье"
    }
    {
        // getColorizedEntityName(this) + "\'s " + BodyPartName[part] + " is hit for [b]" + dmg + "[/b] damage and suffers " + injury + "!"
        mode = "pattern"
        en = "<entity:str_tag>'s <part:str> is hit for [b]<dmg:int_tag>[/b] damage and suffers <inj:str>!"
        ru = "<entity> — <part> получает <dmg> урона и получает увечье: <inj>!"
    }
    {
        // getColorizedEntityName(this) + "\'s " + BodyPartName[part] + " is hit for [b]" + dmg + "[/b] damage"
        mode = "pattern"
        en = "<entity:str_tag>'s <part:str> is hit for [b]<dmg:int_tag>[/b] damage"
        ru = "<entity> — <part> получает <dmg> урона"
    }
    // FILE: scripts/companions/types/companions_schrat.nut
    {
        en = "Schrat"
        ru = "Шрат"
    }
    {
        en = "A Schrat"
        ru = "Шрат"
    }
    // FILE: scripts/companions/types/companions_snake.nut
    {
        en = "Serpent"
        ru = "Змей"
    }
    {
        en = "A Serpent"
        ru = "Змей"
    }
    // FILE: scripts/companions/types/companions_spider.nut
    {
        en = "Webknecht"
        ru = "Вебкнехт"
    }
    // en = "injury"  // internal sprite id
    {
        en = "A Webknecht"
        ru = "Вебкнехт"
    }
    // FILE: scripts/companions/types/companions_unhold.nut
    {
        en = "Unhold"
        ru = "Тролль"
    }
    {
        en = "An Unhold"
        ru = "Тролль"
    }
    // FILE: scripts/companions/types/companions_wardog.nut
    {
        en = "Wardog"
        ru = "Боевой пёс"
    }
    // FILE: scripts/companions/types/companions_warhound.nut
    {
        en = "Warhound"
        ru = "Боевая гончая"
    }
    // FILE: scripts/companions/types/companions_warwolf.nut
    {
        en = "Wolf"
        ru = "Волк"
    }
]
::Rosetta.add(rosetta, pairs);
