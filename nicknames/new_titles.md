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
Угрюмый, Дрёма, Соломинка, Семь бед, Чёрный день, Буревестник, Зарница, Ртуть, Сквозняк, Порох,
Скрытень, Мякина, Разгильдяй, Свалка, Ворог, Сиделец, Ланцет, Ополченец, Завсегдатай, Дружинник

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

FILL HERE

**Саранча / the Locust** — пришёл из пустыни, всё подъедает — `background.nomad + trait.gluttonous`; `background.nomad + trait.greedy`; `trait.gluttonous + trait.greedy`  // ~1 in 268
**Факел / the Torch** — жёг деревни, любит когда горит — `background.raider + trait.bloodthirsty`; `background.raider`; `trait.bloodthirsty + trait.irrational`  // ~1 in 101
**Клеймо / the Brand** — клеймёный, прошлое выжжено на шкуре — `background.slave`; `background.killer_on_the_run`; `background.thief`  // ~1 in 46
**Ошейник / the Collar** — снял ошейник, а повадки остались — `background.slave + trait.brute`; `background.slave + trait.loyal`; `background.houndmaster`; `background.manhunter`  // ~1 in 52
**Аминь / Amen** — помолился — и ставит точку — `background.paladin`; `background.monk + perk.coup_de_grace`; `background.flagellant`; `background.witchhunter`  // ~1 in 38
**Потрошитель / the Ripper** — вскрывает, что на столе, что в бою — `background.anatomist`; `background.butcher + trait.bloodthirsty`; `weapon.cleaver + trait.bloodthirsty`; `background.hackflows_surgeon + trait.bloodthirsty`; `background.graverobber`  // ~1 in 62
**Книжный Червь / Bookworm** — носом в книгах, а укусить может — `background.historian`; `background.monk + trait.bright`; `trait.bright + attr.MeleeSkill.low + type.melee`  // ~1 in 131 ME: apprentice? perk.student?
**Аркан / the Lasso** — накидывает петлю на беглых — `background.manhunter`; `background.nomad`; `background.hackflows_bounty_hunter`  // ~1 in 18
**Подкидыш / the Foundling** — нашли на пороге, прибился к отряду — `background.bastard`; `background.refugee`  // ~1 in 31
**Каплун / the Capon** — петух холощёный, зато жирный — `background.eunuch`; `trait.fat + attr.Bravery.low`  // ~1 in 161
**Стремя / the Stirrup** — держал стремя рыцарю, теперь сам в седле — `background.squire`; `background.servant + trait.loyal`  // ~1 in 198
**Отвес / the Plumb Line** — ровный, надёжный, по нему строй равняют — `background.mason`; `background.mason + attr.MeleeDefense.high`; `background.hackflows_carpenter`  // ~1 in 82
**Полцены / Half-Price** — иронично: наёмник по сходной цене — `cost.low + group.combat`; `cost.low + attr.MeleeSkill.low + type.melee`  // ~1 in 22 ME: add some trader
**Клятва / the Oath** — иронично: клялся уже, все помнят чем кончилось — `background.oathbreaker`; `background.deserter`; `trait.disloyal + trait.superstitious`  // ~1 in 59
**Костяшки / the Knucklebones** — гадает на костях, играет на костях — `background.shaman`; `background.gambler`; `background.brawler`  // ~1 in 52
**Учитель / the Teacher** — каждый удар — урок — `background.swordmaster`; `background.historian`; `background.retired_soldier + perk.rally_the_troops`  // ~1 in 124
**Тетива / the Bowstring** — натянут и звенит — `background.bowyer`; `background.hackflows_fletcher`; `weapon.bow + attr.RangedSkill.high`  // ~1 in 45
**Шампур / the Skewer** — насаживает, как на вертел — `background.hackflows_lancer`; `weapon.spear + attr.MeleeSkill.high`; `background.hackflows_cook + weapon.spear`  // ~1 in 41
**Кипяток / Hothead** — вскипает с пол-удара — `background.hackflows_berserker`; `trait.impatient + trait.brute`; `background.hackflows_cook + trait.impatient`  // ~1 in 60
**Ищейка / the Bloodhound** — взял след — не отстанет — `background.hackflows_bounty_hunter`; `trait.determined + perk.pathfinder`; `background.houndmaster + perk.pathfinder`  // ~1 in 29
**Кубок / the Cup** — брал призы на турнирах и аренах, а теперь не выпускает из рук — `background.hackflows_champion`; `background.gladiator`; `trait.drunkard + trait.cocky`  // ~1 in 38
**Заступник / the Protector** — встаёт между своими и бедой — `background.hackflows_folk_hero`; `perk.taunt + trait.brave`; `background.hackflows_bodyguard`  // ~1 in 34
**Сто Шагов / Hundred Paces** — со ста шагов в глаз — `background.hackflows_master_archer`; `attr.RangedSkill.high + trait.eagle_eyes + type.ranged`  // ~1 in 70
**Ворот / the Windlass** — крутит ворот арбалета, жилы как канаты — `background.hackflows_arbalester`; `background.hackflows_atilliator`; `weapon.crossbow`  // ~1 in 20
**Конёк / the Ridge** — лазал по крышам, не оступается — `background.hackflows_roofer`; `trait.sure_footing`  // ~1 in 15
**Подворотня / the Back Alley** — выполз из подворотни, там же и дерётся — `background.hackflows_myrmidon`; `background.thief`; `background.brawler + trait.weasel`  // ~1 in 29
**Крапива / the Nettle** — сорняк сорняком, а жжётся — `background.hackflows_gardener`; `background.hackflows_herbalist`; `background.hackflows_dissenter`  // ~1 in 37
// **Верста / the Milestone** — мерил дороги ногами; коломенская верста — `background.hackflows_cartographer`; `background.messenger`; `trait.huge`  // ~1 in 15
**Тиски / the Vise** — зажмёт — не вырвешься — `background.hackflows_torturer`; `perk.crippling_strikes + trait.bloodthirsty`; `background.hackflows_blacksmith + trait.strong`  // ~1 in 122
**Мозоль / the Callus** — руки в мозолях, а врагу глаза мозолит — `background.daytaler`; `background.farmhand`; `background.lumberjack`; `perk.taunt + group.lowborn`  // ~1 in 16
**Верблюд / the Camel** — тащит за троих, плюётся — `background.caravan_hand`; `trait.strong + attr.Stamina.high`  // ~1 in 57
// **Второй Ряд / Second Rank** — иронично: воюет копьём из-за чужих спин — `background.militia + weapon.spear`; `background.militia + trait.craven`; `weapon.polearm + trait.craven`  // ~1 in 207

**Рожок / the Horn** — дудит так, что мёртвые встают — `weapon.musical`; `background.shepherd`; `background.necro + weapon.musical`  // ~1 in 194
**Гостинец / the Parting Gift** — шлёт «гостинцы» издалека — `weapon.throwing`; `weapon.sling`; `background.peddler + weapon.throwing`  // ~1 in 92
**Дубина / the Club** — и оружие, и характеристика — `weapon.mace + trait.strong`; `trait.dumb + trait.strong`; `weapon.staff + trait.strong`  // ~1 in 127
// **Копоть / the Soot** — весь в копоти и пороховой гари — `weapon.firearm`; `background.hackflows_blacksmith`; `background.miner`  // ~1 in 28
**Пугач / the Noisemaker** — грохоту много, толку меньше — `weapon.firearm + attr.RangedSkill.low`; `trait.cocky + attr.Bravery.low`  // НИКОГДА: никто не генерируется с огнестрелом, прозвище выдаётся до перевооружения
// **Колчан / the Quiver** — стрел на всех хватит — `weapon.bow`; `perk.bags_and_belts + weapon.bow`  // ~1 in 20
**Обух / the Blunt End** — тупой, но как приложит — `weapon.axe + trait.dumb`; `weapon.hammer + trait.dumb`  // ~1 in 183
**Лом / the Crowbar** — против него нет приёма — `weapon.mace + trait.strong`; `perk.hackflows.full_force`; `background.miner + trait.strong`  // ~1 in 131
// **Ухват / the Oven Fork** — что горшок из печи, что врага из строя — `background.hackflows_cook + weapon.polearm`; `background.servant + weapon.polearm`  // НИКОГДА: повар и слуга не генерируются с древковым, прозвище выдаётся до перевооружения
// **Весло / the Oar** — плечи гребца, бьёт с размаху — `background.fisherman + trait.strong`; `background.hackflows_pirate + trait.strong`  // ~1 in 457
**Кадило / the Censer** — машет цепом, как поп кадилом — `background.monk + weapon.flail`; `background.flagellant + weapon.flail`; `background.cultist + weapon.flail`  // ~1 in 185
**Просека / the Clearing** — где прошёл с топором — там просека — `weapon.axe + perk.killing_frenzy`;
// **Щука / the Pike** — хвать из камышей — и нет тебя — `background.fisherman + weapon.polearm`; `weapon.polearm + trait.bloodthirsty`  // ~1 in 1311

// **Хватка / the Knack** — всё схватывает: и науку, и за горло — `perk.gifted`; `perk.fast_adaption`; `trait.dexterous + trait.bright`; `background.thief + perk.quick_hands`  // ~1 in 12
**Столб / the Post** — вкопан, не сдвинешь; или просто стоит столбом — `perk.indomitable`; `attr.MeleeDefense.high + attr.Hitpoints.high + type.melee`; `trait.dumb + attr.Initiative.low`  // ~1 in 70
// **Второе Дыхание / Second Wind** — другие падают, а он только разошёлся — `perk.recover`; `trait.iron_lungs + attr.Stamina.high`; `perk.adrenaline + trait.athletic`  // ~1 in 53
**Жернов / the Millstone** — мелет медленно, но верно — `perk.relentless`; `background.miller + trait.determined`  // ~1 in 79
**Истукан / the Stone Idol** — стоит как истукан, ничем не проймёшь — `perk.fortified_mind`; `attr.Bravery.high + trait.determined`; `trait.dumb + trait.fearless`  // ~1 in 43
**Веретено / the Spindle** — вертится — не зацепишь — `perk.dodge`; `trait.swift + attr.Initiative.high`; `background.tailor + trait.swift`  // ~1 in 39
// **Точка / Full Stop** — ставит точку в любом споре — `perk.coup_de_grace`; `background.hackflows_hangman`  // ~1 in 140
**Сам на Сам / One-on-One** — зовёт на честный бой, нечестно хорош в нём — `perk.duelist`; `perk.lone_wolf + attr.MeleeSkill.high + type.melee`; `background.gladiator + attr.MeleeSkill.high`  // ~1 in 107
**Красная Тряпка / the Red Rag** — дразнит, как тряпка быка — `perk.taunt`; `perk.fearsome + trait.cocky`  // ~1 in 96
// **Плотина / the Dam** — принимает напор на себя — `perk.taunt + attr.MeleeDefense.high + type.melee`; `perk.hold_out + attr.Hitpoints.high`; `perk.shield_expert + attr.Hitpoints.high`  // ~1 in 264
**Тень / the Shade** — за спиной, когда не ждёшь; или ходит тенью за своими — `perk.backstabber`; `background.assassin`; `trait.loyal + perk.footwork`  // ~1 in 73
// **Брод / the Ford** — знает все тропы и броды — `perk.pathfinder`; `background.poacher`; `background.vagabond + perk.pathfinder`  // ~1 in 17
**Манок / the Bird Call** — приманивает дичь под выстрел — `background.hunter + perk.taunt`; `background.hackflows_falconer + perk.taunt`  // НИКОГДА: в background_perks нет шанса taunt у hunter/falconer
**Скорлупа / the Eggshell** — иронично: броня толстая, нутро жидкое — `perk.battle_forged + attr.Hitpoints.low`; `perk.battle_forged + trait.craven`  // ~1 in 8591
**Таран / the Battering Ram** — выносит ворота лбом — `perk.berserk + trait.huge`; `weapon.hammer + trait.brute`  // ~1 in 376
**Зарубка / the Tally** — за каждого убитого — зарубка — `perk.head_hunter + trait.bloodthirsty`; `background.hunter + trait.bloodthirsty`; `background.lumberjack + trait.bloodthirsty`  // ~1 in 1037
// **Отпетый / Last Rites** — отпели уже, а он живой — `perk.nine_lives`; `trait.deathwish + trait.survivor`; `background.gravedigger + trait.survivor`  // ~1 in 58

// **Мишень / the Target** — все в него попадают, а он ещё и напрашивается — `attr.MeleeDefense.low + type.melee`; `attr.RangedDefense.low`; `perk.taunt + attr.MeleeDefense.low + type.melee`  // ~1 in 6
**Заговорённый / the Charmed** — стрелы летят мимо, будто заговорён; сам в это верит — `attr.RangedDefense.high`; `trait.lucky + attr.RangedDefense.high`; `trait.superstitious + trait.lucky`  // ~1 in 6
**Молоко / the Barn Door** — стреляет в молоко — `type.ranged + attr.RangedSkill.low`  // ~1 in 109
**Сундук / the Coffer** — жалованье как у трёх, и сам как сундук — `trait.fat + cost.high`  // add more factors
// **Грош / the Penny** — служит за грош — `cost.low`; `cost.low + group.pauper`  // ~1 in 2
// **Сокровище / the Treasure** — иронично: дорогой, а толку нет — `cost.high + attr.MeleeSkill.low + type.melee`; `cost.high + attr.RangedSkill.low + type.ranged`; `cost.high + trait.fragile`  // ~1 in 55
// **Сермяга / Homespun** — простой, как сермяжная правда — `group.lowborn`; `group.pauper`  // ~1 in 2

// **Ёж / the Hedgehog** — колючий, голыми руками не возьмёшь — `weapon.spear + attr.MeleeDefense.high`; `trait.pessimist + trait.tough`  // ~1 in 96
**Осёл / the Donkey** — упрямый, навьюченный — `trait.determined + trait.dumb`; `perk.brawny + perk.bags_and_belts`  // ~1 in 319
**Баран / the Ram** — прёт лбом в ворота; пас баранов — сам баран — `trait.dumb + trait.brute`; `perk.steel_brow + trait.dumb`; `background.shepherd + trait.dumb`  // ~1 in 279
// **Сом / the Catfish** — усатый, ленивый, лежит на дне — `background.fisherman + trait.fat`; `trait.fat + attr.Initiative.low`  // ~1 in 356
// **Рак / the Crayfish** — в панцире и пятится — `background.fisherman + trait.craven`; `trait.fainthearted + trait.tough`  // ~1 in 333
**Паук / the Spider** — сидит в углу, ждёт — `background.tailor`; `perk.anticipation + weapon.crossbow`  // ~1 in 93
// **Комар / the Mosquito** — мелкий, звенит, кусает — `trait.tiny + weapon.dagger`; `trait.tiny + perk.overwhelm`  // ~1 in 187
**Блоха / the Flea** — поди поймай — `trait.tiny + perk.dodge`; `trait.tiny + perk.footwork`  // ~1 in 705
// **Коршун / the Kite** — кружит над падалью — `background.graverobber`; `background.raider + trait.greedy`; `background.nomad + trait.greedy`  // ~1 in 149
**Белка / the Squirrel** — вертлявый и запасливый — `perk.quick_hands + trait.swift`; `perk.bags_and_belts + trait.greedy`  // ~1 in 232
**Улитка / the Snail** — иронично: в панцире и не торопится — `attr.Initiative.low + perk.battle_forged`; `attr.Initiative.low + attr.MeleeDefense.high + type.melee`; `trait.hesitant + perk.battle_forged`  // ~1 in 125
// **Цапля / the Heron** — длинноногий, стоит и ждёт, бьёт одним тычком — `trait.huge + weapon.spear`; `background.fisherman + trait.huge`; `trait.huge + perk.anticipation`  // ~1 in 229
**Оборотень / the Turnskin** — днём один, ночью другой — `trait.legend_double_tongued`; `trait.night_owl + trait.irrational`; `background.hackflows_con_artist + trait.night_owl`  // ~1 in 332
// **Кощей / the Deathless** — кожа да кости, а не помирает — `attr.Hitpoints.low + trait.survivor`; `trait.greedy + trait.survivor`  // ~1 in 174
// **Домовой / the House Spirit** — ворчит и стережёт добро — `background.servant + trait.paranoid`; `perk.bags_and_belts + trait.paranoid`; `trait.tiny + trait.paranoid`  // ~1 in 284

**Горбушка / the Crust** — жёсткий, как чёрствая корка — `trait.tough + group.pauper`; `background.beggar + trait.tough`  // ~1 in 279
**Перец / the Pepper** — мелкий, а злой — `trait.tiny + trait.brute`; `trait.tiny + trait.impatient`  // ~1 in 363
**Ложка / the Spoon** — первый к котлу — `trait.gluttonous`; `trait.gluttonous + attr.Initiative.high`; `trait.fat + attr.Initiative.high`  // ~1 in 17
**Пряник / the Gingerbread** — добрым словом, где другие кнутом — `perk.rally_the_troops + trait.optimist`; `background.hackflows_cook`; `trait.fat + trait.optimist`  // ~1 in 78
// **Перегар / the Reek** — несёт за версту, враги сами падают — `trait.drunkard + perk.fearsome`; `trait.drunkard + trait.gluttonous`; `background.hackflows_barkeep + trait.drunkard`  // ~1 in 316
**Грызло / the Bit** — грызёт удила, рвётся в бой — `trait.impatient + attr.Initiative.high`; `trait.impatient + perk.adrenaline`  // ~1 in 199
**Должник / the Debtor** — задолжал смерти, тянет с расплатой — `trait.deathwish`; `background.gambler`  // ~1 in 17
// **Полночь / Midnight** — не спит, когда все спят — `trait.night_owl`; `background.hackflows_town_watchman + trait.night_owl`; `background.thief + trait.night_owl`  // ~1 in 16
**Заика / the Stutterer** — с тех пор заикается — `injury.traumatized`; `trait.insecure + attr.Bravery.low`  // ~1 in 144
**Шептун / the Whisperer** — шепчет заговоры над ранами; или шепчется по углам — `trait.superstitious`; `background.hackflows_herbalist + trait.superstitious`; `trait.paranoid + trait.superstitious`  // ~1 in 17
// **Пономарь / the Sexton** — бубнит молитвы над каждой могилой — `background.monk + trait.superstitious`; `background.gravedigger + trait.superstitious`  // ~1 in 1535
**Кликуша / the Wailer** — голосит и пророчит беду — `trait.superstitious + trait.pessimist`; `background.cultist + trait.irrational`  // ~1 in 357

// **Ромашка / the Daisy** — иронично: нежное имя для такой туши — `trait.brute + background.hackflows_gardener`; `trait.huge + background.hackflows_herbalist`; `trait.optimist + trait.huge`  // ~1 in 326
// **Нянька / the Nanny** — иронично: возится с ранеными, как с дитями — `background.hackflows_surgeon`; `perk.rally_the_troops + trait.teamplayer`; `background.hackflows_herbalist + trait.teamplayer`  // ~1 in 385
// **Ангел / the Angel** — иронично: приходит последним, кого видят — `background.hackflows_hangman`; `weapon.crossbow + trait.bloodthirsty`; `trait.optimist + trait.bloodthirsty`  // ~1 in 185
// **Десятина / the Tithe** — иронично: своего не упустит, как поп десятину — `background.monk + trait.greedy`; `trait.greedy + group.noble`; `cost.high + trait.greedy`  // ~1 in 69
