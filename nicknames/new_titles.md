# Новые прозвища — черновик для ревью

Стиль, факторы и уже добавленные прозвища — в `nicknames/titles.nut`.
Прозвища, уже существующие в игре — в `built-in.nut`.
Разъяснения смысла факторов — комментарии EXPLAINED в `titles.nut`.
Сюда добавляем только новые, не повторяя ни то, ни другое.

## Что работает

- **Короткое конкретное существительное** — 1–2 слова, знакомые всем.
  Хорошо: Малыш, Крыса, Крюк. Плохо: Дружинник, Ланцет, Завсегдатай.
- **Двойной смысл** — буквальное происхождение (фон/фактор) + боевая метафора.
  Хорошо: Гарпун (рыбак с копьём — одно и то же), Наковальня (берёт удары).
- **Ирония и метафоры** — хорошо, должны быть факторы как для буквального так и ироничного или метафорического варианта

## Что не работает

- **Прилагательные вместо существительных** — Желчный, Упёртый, Угрюмый — лучше заменить на существительные, если можно.
- **Поэтические/литературные образы** — Зарница, Буревестник, Ртуть, Соломинка — не язык лагерного костра.
- **Книжные слова** — Ворог, Скрытень — не в ходу у наёмников.
- **Слишком умные/специфические** — Ланцет, Богомол — для простых мужиков не так работает.

## Артикль `the` в английских вариантах

- **Одиночное существительное / прилагательное** → с `the`: `the Anvil`, `the Bear`, `the Lanky`, `the Crooked`, `the Falconer`.
- **Слитное составное слово (portmanteau)** → без `the`: `Hawkeye`, `Goodhand`, `Crackskull`, `Lightfoot`, `Lionheart`, `Quickfeet`.
- **Многословная фраза-кличка** → без `the`: `Eagle Eye`, `Four Fingers`, `Mama's Boy`, `Hard to Kill`, `Iron Tongs`.

## Ошибки с факторами

- `trait.brute` — агрессивный, бьёт в голову с плеча, грубая сила без тактики. **НЕ** значит "физически сильный" или "мощный удар". Не использовать там, где нужна просто сила.
- `background.hackflows_skirmisher` — лёгкий боец, не разведчик/дозорный. Для дозора — `background.hackflows_town_watchman`.

## Отвергнуты как неинтересные

Богомол, Выдра, Куница, Аист, Острие, Пест, Засада, Кистень, Желчный, Упёртый, Головня, Дутый,
Угрюмый, Дрёма, Соломинка, Буревестник, Зарница, Ртуть, Сквозняк, Порох, Скрытень, Мякина, Свалка,
Ворог, Сиделец, Ланцет, Ополченец, Завсегдатай, Дружинник, Жила, Псалом

```bash
./tools.nut new       # Проверить статус предложений (добавлено / в built-in / ещё нет)
./tools.nut load-new  # Загрузить новые прозвища
```

## Формат

**Прозвище / Nickname** — кому давать свободным текстом — `факторы`

Примеры:

**Волкодав / Wolfhound** — натаскан на тварей, знает как с ними — `trait.hate_beasts + attr.MeleeSkill.high`; `background.houndmaster + trait.hate_beasts`
**Крюк / Hook** — цепляется и не отпускает — `perk.crippling_strikes`; `background.hackflows_hangman`; `background.fisherman`

---

# Kimi 2.7
**Рогатка / the Slingshot** — меткий из подручного — `weapon.sling + trait.tiny`; `weapon.sling + trait.dumb`
**Натоптыш / the Corn** — ходит весь день — `background.daytaler + attr.Stamina.high`; `background.farmhand + attr.Stamina.high`
**Скелет / the Skeleton** — костлявый хиляк — `attr.Hitpoints.low + attr.Stamina.low`; `attr.Hitpoints.low + trait.fragile`
**Козлёнок / the Goatling** — упрямый малыш — `trait.tiny + trait.determined`; `trait.tiny + trait.impatient`

**Слюнтяй / the Sniveller** — чуть что — распустил сопли — `trait.craven + trait.fainthearted`; `trait.insecure + trait.pessimist`
# Кочерыжка — уже есть в titles.nut (the Cabbagehead), пропускаем

# Opus 4.8
**Заточка / the Shiv** — беглый душегуб с ножом — `weapon.dagger + background.killer_on_the_run`; `weapon.dagger + trait.weasel`
**Ишак / the Ass** — упрямый и туповатый работяга — `trait.determined + trait.dumb`; `background.slave + attr.Stamina.high`
**Подпасок / the Shepherd Boy** — робкий, идёт за старшими — `background.shepherd + trait.fainthearted`; `trait.craven + trait.teamplayer`
**Дылда / the Beanstalk** — долговязый и нескладный — `trait.huge + attr.Hitpoints.low`; `trait.huge + trait.insecure`
**Куль / the Bale** — тяжёлый, неповоротливый мешок — `trait.fat + attr.Initiative.low`; `background.caravan_hand`

ADD HERE

# Opus 4.8 — весёлый/ироничный батч
# ([future]-пометки при загрузке: Конан, Дон Кихот, Тормоз, Ведьмак — вне сеттинга)

// **Голиаф / Goliath** — грозное имя тому, кто мельче всех — `trait.tiny + trait.cocky`; `trait.huge + attr.Hitpoints.high`
// **Титан / the Titan** — дунь — и свалится твой титан — `attr.Hitpoints.low + trait.fragile`; `trait.tiny + trait.cocky`
// **Геракл / Hercules** — силач-неудачник, ни одного подвига — `attr.MeleeSkill.low + trait.cocky`; `trait.strong + trait.dumb`
// **Самсон / Samson** — вся сила, видать, в волосах была — `attr.Hitpoints.low + trait.insecure`; `trait.strong + trait.superstitious`
// **Атлант / Atlas** — тащит весь отряд на горбу — `attr.Hitpoints.high + trait.teamplayer`; `attr.Stamina.low + trait.pessimist`
// **Мамонт / the Mammoth** — громадный и вот-вот вымрет — `trait.huge + attr.Hitpoints.high`; `trait.huge + attr.Initiative.low`
// **Бегемот / the Behemoth** — жирная туша прёт из болота — `trait.fat + trait.huge`; `trait.fat + attr.Hitpoints.high`
// **Голем / the Golem** — глиняная громадина, тупая и медленная — `perk.colossus + trait.dumb`; `trait.huge + attr.Initiative.low`
// **Циклоп / the Cyclops** — одноглазый верзила — `injury.missing_eye + trait.huge`; `injury.missing_eye + trait.brute`
// **Минотавр / the Minotaur** — бык-людоед, прёт башкой — `trait.brute + trait.huge`; `trait.brute + trait.hate_beasts`
**Дракон / the Dragon** — пыхтит, будто огнём дышит — `trait.asthmatic`; `trait.elem_fear_fire + attr.Bravery.low`; `perk.elem_fire_affinity + trait.bloodthirsty`
// **Гидра / the Hydra** — руби не руби, всё живой — `trait.survivor + perk.nine_lives`; `perk.necro.regeneration`
// **Феникс / the Phoenix** — горит да заново встаёт — `perk.nine_lives`; `perk.elem_fire_affinity + trait.survivor`
**Кракен / the Kraken** — морская туша, пират-громила — `background.hackflows_pirate + trait.huge`; `background.fisherman + trait.brute`
// **Василиск / the Basilisk** — убил бы взглядом, да подслеповат — `trait.eagle_eyes + attr.RangedSkill.high`; `trait.short_sighted + trait.cocky`
// **Кощей / Koschei** — тощий скряга, а не помирает — `attr.Hitpoints.low + trait.greedy`; `attr.Hitpoints.low + trait.survivor`
// **Химера / the Chimera** — не пойми что, и всё не в себе — `trait.irrational + background.hedge_knight`; `trait.irrational + trait.brave`
// **Огр / the Ogre** — здоровенный и вечно голодный — `trait.huge + trait.gluttonous`; `trait.huge + trait.dumb`
**Гоблин / the Goblin** — мелкий, злой, зеленеет в бою — `trait.tiny + trait.fear_greenskins`; `trait.tiny + trait.bloodthirsty`
// **Император / the Emperor** — оборванец с царскими замашками — `group.pauper + trait.cocky`; `background.beggar + trait.cocky`
// **Цезарь / Caesar** — возомнил о себе невесть что — `trait.cocky`; `group.pauper + trait.cocky`
// **Султан / the Sultan** — разъелся и обленился — `trait.fat + trait.gluttonous`; `trait.fat + attr.Initiative.low`
// **Граф / the Count** — нищета, а нос дерёт — `group.pauper + trait.cocky`; `trait.cocky + trait.greedy`
// **Визирь / the Vizier** — умён и вечно что-то мутит — `trait.bright + trait.disloyal`; `background.hackflows_con_artist + trait.bright`
// **Фараон / the Pharaoh** — с мертвецами запросто — `background.anatomist`; `background.gravedigger + trait.cocky`
// **Идол / the Idol** — стоит истуканом, молись не молись — `trait.superstitious + attr.Initiative.low`; `attr.Initiative.low + trait.dumb`
// **Оракул / the Oracle** — вещает чушь с важным видом — `trait.superstitious + trait.cocky`; `trait.dumb + trait.superstitious`
// **Пророк / the Prophet** — сулит всем скорую погибель — `trait.pessimist + trait.superstitious`; `background.flagellant + trait.pessimist`
// **Мессия / the Messiah** — уверен, что всех спасёт — `background.hackflows_folk_hero + trait.cocky`; `trait.chosen + trait.cocky`
// **Робин Гуд / Robin Hood** — из лесу, с луком, бьёт метко — `weapon.bow + background.poacher`; `background.poacher + attr.RangedSkill.high`
// **Каин / Cain** — поднял руку на своих — `background.killer_on_the_run`; `trait.disloyal + trait.bloodthirsty`
// **Лазарь / Lazarus** — уже хоронили, а он встал — `trait.survivor + attr.Hitpoints.low`; `perk.nine_lives`
// **Иов / Job** — все беды разом на него — `trait.survivor + trait.pessimist`; `trait.ailing + trait.survivor`
// **Ирод / Herod** — лютый, никого не пожалеет — `trait.bloodthirsty + trait.irrational`; `background.killer_on_the_run`
// **Фома / Thomas** — пока не потрогает — не поверит — `trait.hesitant + trait.paranoid`; `trait.hesitant + trait.pessimist`
// **Конан / Conan** — дикарь с гор, машет мечом — `background.wildman + trait.strong`; `background.barbarian + attr.MeleeSkill.high`
// **Дон Кихот / Don Quixote** — рыцарь не в себе, воюет с мельницами — `background.hedge_knight + trait.irrational`; `trait.irrational + trait.brave`
// **Ромашка / the Daisy** — с виду кроткий, а режет глотки — `trait.bloodthirsty`; `background.killer_on_the_run + trait.optimist`
// **Лютик / the Buttercup** — имя нежное, а сам лютый — `trait.bloodthirsty + trait.optimist`; `background.killer_on_the_run + trait.optimist`
// **Ангел / the Angel** — ангел, только смерти — `trait.bloodthirsty + perk.coup_de_grace`; `perk.fearsome`
// **Херувим / the Cherub** — морда ангельская, кулак чугунный — `trait.brute + attr.MeleeSkill.high`; `trait.brute + trait.optimist`
// **Голубок / the Dove** — «мирный», а первый в драку — `group.peaceful + trait.bloodthirsty`; `trait.cocky + trait.bloodthirsty`
// **Пушинка / the Featherweight** — «лёгкий», в три обхвата — `trait.fat + trait.huge`; `trait.fat + attr.Hitpoints.high`
// **Мизинец / the Pinky** — от горшка два вершка — `trait.tiny`; `trait.tiny + trait.insecure`
// **Пострел / the Scamp** — везде поспел, шустрый чертёнок — `trait.tiny + attr.Initiative.high`; `trait.tiny + trait.quick`
// **Мальчик-с-пальчик / Tom Thumb** — мал, да смышлён — `trait.tiny + trait.bright`; `trait.tiny + trait.quick`
// **Козявка / the Booger** — мелочь, соплёй перешибёшь — `trait.tiny + trait.insecure`; `trait.tiny + attr.Hitpoints.low`
// **Тихушник / the Sneak** — тихой сапой делает своё — `trait.weasel + trait.quick`; `background.thief + trait.paranoid`
// **Профессор / the Professor** — умный вид, пустая башка — `trait.dumb + trait.cocky`; `perk.student + trait.cocky`
// **Всезнайка / the Know-it-all** — на всё ответ, всегда не тот — `trait.bright + trait.cocky`; `perk.student + trait.cocky`
// **Алхимик / the Alchemist** — мутит зелья, сам не знает какие — `background.hackflows_herbalist + trait.irrational`; `background.hackflows_herbalist + trait.superstitious`
// **Счетовод / the Reckoner** — считает чужие монеты — `trait.greedy + trait.bright`; `background.peddler + trait.greedy`
// **Икона / the Icon** — на него молятся, толку чуть — `trait.superstitious + trait.insecure`; `background.monk + trait.superstitious`
// **Лопух / the Burdock** — простак, обведут вокруг пальца — `trait.dumb + trait.insecure`; `trait.dumb + trait.loyal`
// **Осина / the Aspen** — дрожит, как осиновый лист — `trait.craven`; `trait.fear_undead + attr.Bravery.low`
// **Поганка / the Deathcap** — с виду гриб, а отрава — `trait.ailing + trait.weasel`; `background.hackflows_herbalist + trait.disloyal`
// **Чертополох / the Thistle** — колючий, за так не возьмёшь — `trait.tough + trait.paranoid`; `trait.survivor + trait.tough`
// **Вьюнок / the Bindweed** — обовьёт и придушит — `perk.crippling_strikes`; `trait.weasel + trait.determined`
// **Дурман / the Nightshade** — рядом с ним дуреют — `background.hackflows_herbalist + trait.irrational`; `trait.superstitious + trait.irrational`
**Голодранец / the Ragamuffin** — гол как сокол, а гонору полно — `group.pauper + trait.cocky`; `background.beggar + trait.cocky`
**Прохвост / the Scoundrel** — пройдоха, каких поискать — `trait.bright + trait.disloyal`; `background.hackflows_con_artist`
**Шельма / the Knave** — плутоватый и скользкий — `trait.weasel + trait.bright`; `background.thief + trait.weasel`
**Хапуга / the Grabber** — гребёт всё под себя — `trait.greedy`; `trait.greedy + background.peddler`
// **Живоглот / the Gorger** — сожрёт и не поперхнётся — `trait.gluttonous + trait.greedy`; `trait.gluttonous + trait.bloodthirsty`
**Дармоед / the Freeloader** — ест за троих, толку ноль — `trait.gluttonous + attr.Stamina.low`; `background.beggar + trait.gluttonous`; `cost.high + type.melee + attr.MeleeSkill.low`; `cost.high + type.ranged + attr.RangedSkill.low`
// **Обормот / the Galoot** — балбес с кулаками — `trait.dumb + trait.brute`; `trait.dumb + trait.impatient`
**Жучила / the Fixer** — обжулит на ровном месте — `background.hackflows_con_artist + trait.weasel`; `trait.weasel + trait.greedy`
// **Мазурик / the Pilferer** — что плохо лежит — уже его — `background.thief`; `background.thief + trait.tiny`
**Хмырь / the Creep** — мутный, себе на уме — `trait.weasel + trait.pessimist`; `trait.disloyal + trait.pessimist`; `trait.weasel + trait.disloyal`
// **Пшик / the Fizzle** — грозы много, толку ноль — `trait.cocky + attr.MeleeSkill.low`; `attr.Hitpoints.low + trait.cocky`
// **Пустышка / the Dud** — пустой и снаружи, и внутри — `trait.cocky + attr.MeleeSkill.low`; `trait.insecure + trait.cocky`
// **Хлопушка / the Firecracker** — бахнет громко, вреда чуть — `perk.rally_the_troops + trait.cocky`; `trait.cocky + attr.Hitpoints.low`
// **Каюк / the Goner** — на нём давно крест поставили — `trait.pessimist + trait.deathwish`; `attr.Hitpoints.low + trait.pessimist`
// **Балласт / the Ballast** — мёртвый груз в отряде — `attr.Stamina.low + trait.pessimist`; `trait.fat + attr.Initiative.low`
// **Труха / the Rot** — сыплется на глазах — `trait.ailing + attr.Hitpoints.low`; `trait.fragile + trait.ailing`
**Доходяга / the Wreck** — еле ноги волочит — `attr.Hitpoints.low + trait.ailing`; `trait.ailing + attr.Stamina.low`
**Дрищ / the Twig** — соплёй перешибить можно —  `attr.Hitpoints.low + trait.fragile`; `attr.Hitpoints.low + attr.Stamina.low`
// **Штоф / the Flask** — сам себе бочонок — `trait.drunkard`; `trait.drunkard + trait.fat`
// **Холодец / the Aspic** — трясётся, как студень — `trait.craven + trait.fat`; `attr.Bravery.low + trait.fat`
// **Тюря / the Gruel** — размазня на воде — `background.beggar`; `background.beggar + trait.insecure`
// **Баланда / the Slop** — арестантская похлёбка — `background.killer_on_the_run`; `trait.pessimist + background.killer_on_the_run`
// **Кислятина / the Sourpuss** — вечно кривит рожу — `trait.pessimist`; `trait.pessimist + trait.paranoid`
// **Шкварка / the Crackling** — мелкий и жирный — `trait.fat + trait.tiny`; `trait.fat + background.hackflows_cook`
// **Домовой / the Hobgoblin** — сидит в лагере духом-хранителем — `trait.superstitious + attr.Hitpoints.high`; `background.hackflows_bodyguard + trait.superstitious`
// **Ведьмак / the Witcher** — травит нечисть, сам с придурью — `background.witchhunter + trait.hate_undead`; `trait.hate_undead + trait.superstitious`
// **Морок / the Phantasm** — наводит жуть одним видом — `trait.night_owl + trait.paranoid`; `background.cultist + trait.superstitious`
// **Ворожей / the Warlock** — шепчет, ворожит, пугает — `background.cultist + trait.superstitious`; `background.hackflows_druid + trait.superstitious`
// **Погост / the Graveyard** — от него могилой веет — `background.gravedigger + trait.pessimist`; `background.graverobber + trait.fear_undead`
**Дурак / the Fool** — дуракам, известно, везёт — `trait.dumb + trait.lucky`; `trait.dumb + trait.survivor`; `trait.dumb + trait.optimist`
// **Шут / the Buffoon** — паясничает, пока всех режут — `background.juggler + trait.cocky`; `background.minstrel + trait.irrational`
// **Решка / Tails** — как монета ляжет — `trait.lucky + attr.Bravery.low`; `background.gambler + trait.craven`
// **Метеор / the Meteor** — вспыхнул и сдулся — `attr.Initiative.high + attr.Stamina.low`; `trait.impatient + attr.Stamina.low`
**Тормоз / the Brake** — вечно тянет и тормозит — `attr.Initiative.low + trait.hesitant`; `attr.Initiative.low + trait.dumb`
// **Носорог / the Rhino** — прёт напролом, толстокожий — `trait.brute + attr.Hitpoints.high`; `trait.huge + trait.brute`
// **Зубр / the Bison** — матёрый, тёртый здоровяк — `trait.huge + trait.strong`; `attr.Hitpoints.high + trait.determined`
// **Дикобраз / the Porcupine** — ощетинился, не подступишься — `trait.tough + trait.paranoid`; `perk.battle_forged + trait.paranoid`
// **Кукушка / the Loon** — подкинет своё другим, ку-ку — `trait.disloyal + trait.weasel`; `trait.night_owl + trait.irrational`
// **Винтик / the Screw** — винтика в башке не хватает — `trait.irrational`; `trait.irrational + trait.dumb`
// **Пружина / the Spring** — сжался и как выстрелит — `attr.Initiative.high + trait.impatient`; `perk.adrenaline`
// **Шкаф / the Cupboard** — здоровенный, что твой шкаф — `trait.huge + attr.Hitpoints.high`; `trait.huge + trait.tough`

# Opus 4.8 — фразы и присказки (многословные клички)
# ([future] при загрузке: Кот в сапогах — сказочная отсылка вне сеттинга)

// **Илья Муромец / Ilya Muromets** — сиднем сидел, а как встал — богатырь — `attr.Initiative.low + trait.strong`; `trait.huge + attr.Hitpoints.high`
// **Соловей-разбойник / Whistling Robber** — свистнет — и полягут — `background.raider + trait.cocky`; `perk.fearsome + trait.cocky`
// **Троянский конь / Trojan Horse** — с виду свой, а нож в спину — `trait.disloyal + trait.weasel`; `background.deserter + trait.disloyal`
// **Волк в овечьей шкуре / Wolf in Sheep's Clothing** — кроткий с виду, зверь внутри — `group.peaceful + trait.bloodthirsty`; `trait.weasel + trait.bloodthirsty`
// **Заблудшая овца / Lost Sheep** — прибился, сам не знает зачем — `background.cultist + trait.hesitant`; `background.refugee + trait.insecure`
// **Козёл отпущения / Scapegoat** — на него всех собак вешают — `trait.insecure + trait.pessimist`; `background.refugee + trait.disloyal`
// **Белая ворона / Rare Bird** — чужак, всё делает не как все — `background.hackflows_outlander + trait.irrational`; `trait.irrational + group.lowborn`
// **Змея подколодная / Snake in the Grass** — пригрели на груди — `trait.weasel + trait.disloyal`; `trait.greedy + trait.disloyal`
// **Ланселот / Lancelot** — странствующий рыцарь при мече — `background.hedge_knight + attr.MeleeSkill.high`; `background.paladin + weapon.sword`
// **Чёрный рыцарь / Black Knight** — руку отруби — «царапина» — `trait.bleeder + trait.determined`; `trait.determined + trait.deathwish`
// **Гроза курятников / Terror of Henhouses** — храбр лишь с теми, кто слабей — `trait.craven + trait.cocky`; `attr.MeleeSkill.low + trait.cocky`
**Гроза кабаков / Terror of Taverns** — герой, пока не протрезвеет — `background.brawler + trait.drunkard`; `trait.drunkard + trait.cocky`
// **Гроза семи морей / Terror of Seven Seas** — гроза для рыб да чаек — `background.hackflows_pirate + trait.cocky`; `background.hackflows_pirate + attr.MeleeSkill.high`
// **Гроза мышей / Terror of Mice** — крысолов, возомнивший себя воином — `background.ratcatcher + trait.cocky`; `background.ratcatcher + trait.bloodthirsty`
// **Ни рыба ни мясо / Neither Fish nor Fowl** — ни то ни сё, серединка — `attr.MeleeSkill.low + trait.insecure`; `trait.hesitant + trait.insecure`
// **Пятое колесо / Fifth Wheel** — в телеге лишний — `attr.Stamina.low + trait.pessimist`; `trait.fat + attr.Initiative.low`
// **Ноль без палочки / Plain Zero** — сам по себе — пустое место — `attr.MeleeSkill.low + trait.insecure`; `cost.low + trait.insecure`
// **Дырка от бублика / Bagel Hole** — обещаний много, толку — дырка — `trait.cocky + attr.MeleeSkill.low`; `trait.cocky + attr.Hitpoints.low`
// **Звёзд с неба не хватает / No Great Shakes** — звёзд с неба не хватает — `trait.dumb + trait.loyal`; `attr.MeleeSkill.low + trait.loyal`
// **Мокрых дел мастер / Wet-Work Man** — по мокрому делу спец — `background.killer_on_the_run + trait.bloodthirsty`; `background.assassin`
// **Мастер заплечных дел / Master of the Rack** — заплечных дел умелец — `background.hackflows_torturer`; `background.hackflows_hangman + trait.bloodthirsty`
// **Мастер на все руки / Jack of All Trades** — за всё берётся, всё умеет — `perk.fast_adaption`; `background.hackflows_carpenter + trait.bright`
// **Пороху не нюхал / Never Smelled Powder** — в бою ещё не бывал — `background.militia + trait.insecure`; `cost.low + attr.MeleeSkill.low`
// **Молоко на губах / Milk on His Lips** — молоко на губах не обсохло — `cost.low + trait.insecure`; `background.militia + attr.MeleeSkill.low`
// **Пушечное мясо / Cannon Fodder** — в первый ряд, и не жалко — `cost.low + type.melee`; `cost.low + attr.Hitpoints.low`
// **Косая сажень / Broad Shoulders** — в плечах косая сажень — `trait.huge + trait.strong`; `trait.strong + attr.Hitpoints.high`
// **Метр с кепкой / Knee-High** — от земли не видать — `trait.tiny`; `trait.tiny + trait.cocky`
// **Верста коломенская / Long Streak** — вымахал под небо — `trait.huge + attr.Hitpoints.low`; `trait.huge + trait.clumsy`
// **Слон в посудной лавке / Bull in a China Shop** — громит всё вокруг — `trait.huge + trait.clumsy`; `trait.huge + trait.impatient`
// **Три подбородка / Three Chins** — есть на что посмотреть — `trait.fat + trait.gluttonous`; `trait.fat + attr.Initiative.low`
// **Пивное пузо / Beer Belly** — наел на пиве — `trait.fat + trait.drunkard`; `trait.drunkard + trait.gluttonous`
// **Луженая глотка / Iron Gullet** — глотка лужёная, пьёт и орёт — `trait.drunkard + attr.Stamina.high`; `perk.rally_the_troops + trait.drunkard`
**Медный лоб / Brass Forehead** — лбом стену прошибёт — `trait.determined + trait.dumb`; `perk.steel_brow + trait.dumb` # trait.iron_jaw?
// **Дырявые руки / Butter Fingers** — всё из рук валится — `trait.clumsy`; `trait.clumsy + attr.MeleeSkill.low`
// **Каменное лицо / Stone Face** — ни страха, ни улыбки — `trait.fearless`; `perk.fortified_mind`
// **Семь пятниц / Seven Fridays** — семь пятниц на неделе — `trait.hesitant + trait.irrational`; `trait.disloyal + trait.hesitant`
// **Без царя в голове / No King Upstairs** — без царя в голове — `trait.dumb + trait.irrational`; `trait.irrational + trait.impatient`
// **Не подарок / No Picnic** — с ним не сладко — `trait.disloyal + trait.impatient`; `trait.brute + trait.disloyal`
// **Гусь лапчатый / Sly Goose** — тот ещё гусь — `trait.weasel + trait.cocky`; `trait.weasel + trait.greedy`
// **Собака на сене / Dog in the Manger** — сам не гам и другим не дам — `trait.greedy + trait.disloyal`; `trait.greedy`
// **Стреляный воробей / Old Sparrow** — стреляного воробья не проведёшь — `background.retired_soldier + trait.survivor`; `trait.survivor + trait.paranoid`
// **Тёртый калач / Tough Cookie** — тёртый, всё повидал — `background.sellsword + trait.survivor`; `trait.survivor + trait.tough`
// **Морской волк / Sea Wolf** — просоленный, всё видел — `background.hackflows_pirate + trait.survivor`; `background.fisherman + trait.tough`
**Тёмная лошадка / the Dark Horse** — тихий, а бьётся на диво — `cost.low + attr.MeleeSkill.high`; `background.hackflows_outlander + attr.MeleeSkill.high`
// **Рабочая лошадка / Workhorse** — тянет и тянет, без жалоб — `background.daytaler + attr.Stamina.high`; `trait.loyal + attr.Stamina.high`
// **На честном слове / By a Thread** — держится на честном слове — `trait.bleeder + trait.survivor`; `attr.Hitpoints.low + trait.survivor`
// **Одной ногой в могиле / One Foot in the Grave** — краше в гроб кладут — `trait.ailing + attr.Hitpoints.low`; `background.gravedigger + trait.pessimist`
// **Не жилец / Not Long for This World** — не жилец, а всё коптит — `attr.Hitpoints.low + trait.pessimist`; `trait.fragile + trait.deathwish`
// **Тридцать три несчастья / Thirty-Three Woes** — что ни шаг, то беда — `trait.clumsy + attr.Initiative.low`; `trait.clumsy + trait.pessimist`
// **Кровь из носу / Bloody-Minded** — кровь из носу, а сделает — `trait.determined + trait.bleeder`; `trait.determined + trait.deathwish`
// **Один в поле / One-Man Army** — один в поле, и то воин — `perk.lone_wolf`; `perk.underdog + trait.brave`
// **Последний герой / Last Man Standing** — последним уходит с поля — `perk.lone_wolf + trait.survivor`; `trait.survivor + trait.determined`
// **Пуп земли / Center of the Universe** — считает себя пупом земли — `trait.cocky`; `group.noble + trait.cocky`
// **Семи пядей / Wise Guy** — семи пядей во лбу, как же — `trait.dumb + trait.cocky`; `trait.bright + perk.student`
// **Стрелок от бога / God's Own Shot** — то в яблочко, то в белый свет — `type.ranged + attr.RangedSkill.high`; `type.ranged + attr.RangedSkill.low + trait.cocky`
// **Рука не дрогнет / Steady Hand** — рука не дрогнет добить — `perk.coup_de_grace`; `background.hackflows_hangman + trait.determined`
// **Мухи не обидит / Wouldn't Hurt a Fly** — мухи не обидит, а глотки режет — `trait.bloodthirsty`; `background.killer_on_the_run + trait.optimist`
// **Тише воды / Meek as a Lamb** — тише воды, ниже травы — `trait.bloodthirsty + trait.insecure`; `trait.weasel`
// **Кровь с молоком / Hale and Hearty** — кровь с молоком, здоровяк — `trait.athletic + attr.Hitpoints.high`; `attr.Hitpoints.high + trait.optimist`
// **Медведь на ухо / Tin Ear** — медведь на ухо наступил — `background.minstrel + trait.dumb`; `background.juggler + trait.clumsy`
// **Профессор кислых щей / Half-Baked Scholar** — умник на пустом месте — `trait.dumb + trait.cocky`; `perk.student + trait.dumb`
// **Кот в сапогах / Puss in Boots** — плут в сапогах, обведёт любого — `background.hackflows_cobbler + trait.weasel`; `background.hackflows_con_artist + trait.bright`
// **Гроза в стакане / Storm in a Teacup** — бури много, воды по колено — `trait.cocky + attr.Hitpoints.low`; `trait.cocky + attr.MeleeSkill.low`
// **Без штанов / No Breeches** — гол и бос, а лезет в драку — `background.beggar + trait.brave`; `group.pauper + trait.cocky`
// **Одна нога здесь / Here and Gone** — одна нога здесь, другая там — `background.messenger + attr.Initiative.high`; `trait.swift + trait.impatient`
// **Держи карман / Tight Pockets** — снега зимой не выпросишь — `trait.greedy`; `trait.greedy + trait.disloyal`
// **Заячья душа / Rabbit Heart** — душа в пятки от всего — `trait.craven + attr.Bravery.low`; `trait.fainthearted + trait.craven`
// **Медвежья услуга / Bear's Favor** — хотел помочь, вышло хуже — `trait.dumb + trait.loyal`; `trait.clumsy + trait.teamplayer`
// **Мартышкин труд / Fool's Errand** — старается зря — `attr.MeleeSkill.low + trait.determined`; `trait.determined + trait.dumb`
// **Слепая курица / Blind Hen** — слепой курице всё пшеница — `trait.short_sighted + type.ranged`; `trait.night_blind + trait.cocky`
// **Сонная тетеря / Sleepyhead** — вечно клюёт носом — `attr.Initiative.low + trait.night_owl`; `attr.Initiative.low + attr.Stamina.low`
// **Дрожащая тварь / Trembling Wretch** — дрожит и трясётся — `trait.craven + trait.pessimist`; `trait.fainthearted + trait.insecure`
**Кровавая баня / Bloodbath** — устроит баню по колено в крови — `trait.bloodthirsty + attr.MeleeSkill.high`; `perk.killing_frenzy` # need other russian nick
// **Последний довод / Last Argument** — там, где слова кончились — `weapon.firearm + attr.RangedSkill.high`; `weapon.mace + trait.brute`
// **Живая мишень / Sitting Duck** — в него как в мишень — `attr.RangedDefense.low`; `attr.RangedDefense.low + trait.huge`
// **Ходячий лазарет / Walking Wounded** — весь в болячках да бинтах — `trait.ailing + trait.bleeder`; `injury.broken_knee + trait.ailing`
// **Двужильный / the Tireless** — двужильный, не свалишь — `attr.Stamina.high + trait.tough`; `attr.Stamina.high + trait.determined`
// **Ищи ветра / Chase the Wind** — ищи ветра в поле — `background.deserter + trait.swift`; `trait.swift + trait.craven`
// **Без промаха / Never Misses** — что ни выстрел, то в цель — `type.ranged + perk.bullseye`; `weapon.crossbow + attr.RangedSkill.high`
// **Сорви-голова / Madcap** — башку сложит и не заметит — `trait.deathwish + trait.brave`; `trait.impatient + trait.brave`
// **Отпетый / the Incorrigible** — отпетый негодяй — `background.killer_on_the_run + trait.disloyal`; `trait.bloodthirsty + trait.disloyal`
// **Семь вёрст / Tall Tales** — семь вёрст до небес и всё лесом — `trait.cocky + trait.legend_double_tongued`; `background.minstrel + trait.cocky`
// **Раб божий / God's Servant** — на всё воля божья — `trait.superstitious + trait.fainthearted`; `background.monk + trait.superstitious`
// **Свят-свят / Cross Yourself** — чуть что — крестится — `trait.superstitious + trait.fear_undead`; `trait.superstitious + trait.paranoid`
// **Конец света / Doomsayer** — конец света на подходе — `trait.pessimist + trait.superstitious`; `background.flagellant + trait.pessimist`
// **Ловкость рук / Sleight of Hand** — ловкость рук и никакого — `background.thief + perk.quick_hands`; `background.juggler + trait.dexterous`
**Липкие пальцы / Sticky Fingers** — что плохо лежит — прилипнет — `background.thief + trait.greedy`; `trait.weasel + trait.greedy`
// **Мелкий бес / Petty Devil** — мелкий, да пакостный — `trait.tiny + trait.weasel`; `trait.tiny + trait.disloyal`
// **Дуб дубом / Thick as a Plank** — дуб дубом, а кулаки что надо — `trait.dumb + trait.strong`; `trait.dumb + trait.brute`
**Лоб в лоб / Head-On** — прёт в лоб, без затей — `trait.brute + attr.MeleeSkill.high`; `trait.brute + trait.impatient`
// **Себе дороже / Not Worth the Trouble** — связываться себе дороже — `cost.high + trait.disloyal`; `cost.high + attr.MeleeSkill.low`
// **Влетит в копеечку / Pretty Penny** — дорого обходится — `cost.high + trait.greedy`; `cost.high + trait.gluttonous`
// **Задаром / Dirt Cheap** — за миску похлёбки служит — `cost.low + trait.loyal`; `cost.low + background.beggar`
// **Вдоводел / Widowmaker** — после него — вдовы да сироты — `trait.bloodthirsty + attr.MeleeSkill.high`; `perk.fearsome`
// **Чёрная метка / Black Spot** — кому вручат — тому конец — `perk.fearsome`; `background.hackflows_pirate + trait.bloodthirsty`
// **Сам себе враг / His Own Worst Enemy** — сам себе яму роет — `trait.irrational + trait.deathwish`; `trait.irrational + attr.Bravery.high`
// **Голова садовая / Scatterbrain** — голова садовая, вечно впросак — `trait.dumb + trait.clumsy`; `trait.dumb + attr.Initiative.low`
// **Гнилое нутро / Rotten to the Core** — снаружи гладко, внутри гниль — `trait.disloyal + trait.weasel`; `trait.disloyal + trait.greedy`
// **Кровь не водица / Blood is Thicker** — своих в обиду не даст — `trait.loyal + trait.teamplayer`; `trait.loyal + attr.Bravery.high`
// **Последняя спица / Last in Line** — последняя спица в колеснице — `cost.low + trait.insecure`; `background.servant + trait.insecure`

# ds4pro

**Самовар / the Samovar** — пузатый, пыхтит и кипит от нетерпения — `trait.impatient`; `trait.impatient + attr.Initiative.high`; `trait.fat + trait.asthmatic`
**Корыто / the Trough** — жрёт из корыта, как свинья — `trait.gluttonous + trait.fat`; `trait.gluttonous + background.hackflows_cook`; `trait.fat + attr.Initiative.low`  # объединено: mimo + _qwen (обжора)
**Рубило / the Hatchet** — грубо, но кости рубит — `weapon.axe + trait.dumb`; `weapon.axe + background.lumberjack`
**Погорелец / the Burnout** — всё потерял в огне, лёгкие прокоптил — `background.refugee + trait.pessimist`; `background.refugee + trait.asthmatic`
# Щепа — дубль существующей Щепка (the Sliver); стоит дополнить её факторы: `trait.tiny + attr.Initiative.high`, `background.hackflows_carpenter + trait.tiny`
# Колотушка — объединена с дублями из mimo (см. секцию mimo)

# GPT-5.5

**Битый зуб / Broken Tooth** — бит по голове не раз: челюсть держит, а думать разучился — `trait.iron_jaw + trait.dumb`; `background.brawler + trait.iron_jaw`; `perk.steel_brow + trait.dumb`
**Дырявый мешок / Leaky Sack** — всё роняет и сам сыплется — `trait.clumsy + trait.fragile`; `trait.bleeder + trait.clumsy`  # корни Дырявый и Мешок уже заняты — на грани дубля
**Волчий хвост / Wolf Tail** — держится в хвосте стаи — `trait.craven + trait.teamplayer`; `perk.backstabber`
**Левый сапог / Left Boot** — всё делает не с той ноги — `background.hackflows_cobbler + trait.clumsy`; `trait.clubfooted`
**Пёс без цепи / Dog Unchained** — хозяина нет, зубы есть — `background.houndmaster + trait.disloyal`; `background.houndmaster + trait.bloodthirsty`; `trait.disloyal + trait.bloodthirsty`
**Шрамодел / Scarmaker** — после него все с памятью — `perk.crippling_strikes`; `perk.crippling_strikes + trait.bloodthirsty`; `perk.crippling_strikes + weapon.cleaver`

# mimo

**Пустомеля / the Windbag** — мелет языком без умолку — `trait.cocky + trait.irrational`; `trait.cocky + trait.dumb`
**Колотушка / the Beater** — колотит всех подряд, да мимо — `background.brawler + trait.brute`; `weapon.mace + attr.MeleeSkill.low`; `weapon.mace + trait.dumb`; `weapon.hammer + trait.dumb`  # объединено: mimo (Beater/Pestle) + ds4pro (Mallet: почему не hammer — включил)
**Заморыш / the Runtling** — хилый недокормыш из деревни — `trait.tiny + attr.Hitpoints.low`; `trait.tiny + background.farmhand`
**Чёрный кот / the Black Cat** — накличет беду, а сам цел — `trait.lucky + trait.pessimist`; `trait.night_owl + trait.superstitious`

# Qwen Max

**Солома / the Straw** — хилый, бедный, да и солома в голове — `trait.fragile + group.pauper`; `attr.Hitpoints.low + group.pauper`; `trait.dumb + group.pauper`

# Qwen

**Пятак / the Snout** — туповат, прёт рылом вперёд — `trait.dumb + perk.steel_brow`; `trait.brute + trait.dumb`
**Тыква / the Pumpkin** — большой, да пустой внутри — `trait.fat + trait.dumb`; `trait.fat + attr.Initiative.low`
**Кирка / the Pick** — долбит и не устаёт — `background.miner + trait.strong`; `background.miner + trait.determined`
# Бочонок — дубль Бочки (the Barrel, fat/drunkard) — пропускаем
