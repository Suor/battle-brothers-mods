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
Ворог, Сиделец, Ланцет, Ополченец, Завсегдатай, Дружинник, Жила, Псалом, Барчук, Шпора, Гость

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

## Благородные, рыцари, оруженосцы

`background.adventurous_noble` не покрыт ни одним нашим прозвищем — начинаем с него.

// **Барчук / the Young Lord** — молодой господин поехал на войну как на охоту — `background.adventurous_noble`; `group.noble + trait.cocky`
// **Гость / the Guest** — в лагере он как в гостях: чужая посуда, чужие мозоли — `background.adventurous_noble`; `background.hackflows_outlander`
// **Шпора / the Spur** — звенит железом и вечно подгоняет остальных — `background.hedge_knight`; `background.squire`; `background.adventurous_noble`
// **Забрало / the Visor** — лица не видно, разговаривать бесполезно — `background.hedge_knight`; `perk.battle_forged + attr.MeleeDefense.high`
**Безземельный / the Landless** — герб есть, земли нет (как у Иоанна Безземельного) — `background.disowned_noble`; `group.noble + trait.pessimist`
// **Пасынок / the Stepson** — свой среди чужих, чужой среди своих — `background.bastard + trait.insecure`; `background.bastard + trait.pessimist`

## Мирные ремёсла

// **Отруби / the Bran** — мельничная пыль в бороде; и звучит как приказ — `background.miller`; `background.miller + trait.brute`
// **Мастерок / the Trowel** — кладёт ровно, что кирпич, что зубы — `background.mason`; `background.hackflows_carpenter`
// **Набат / the Alarm Bell** — по нему сбегается всё село — `background.militia`; `background.hackflows_town_watchman + trait.paranoid`
**Отрава / the Poison** — травил крыс, привычка осталась — `background.ratcatcher`; `background.hackflows_herbalist + trait.weasel` // why weasel  + cook clumsy
// **Саван / the Shroud** — знает, во что заворачивать — `background.graverobber`; `background.gravedigger + trait.superstitious`
// **Верста / the Milepost** — считает вёрсты, а не привалы — `background.messenger`; `background.messenger + attr.Stamina.high`
// **Тис / the Yew** — из тиса гнут луки, из него — стрелков — `background.bowyer`; `background.hackflows_fletcher`; `weapon.bow + trait.determined`
// **Замок / the Lock** — открывает что угодно, кроме своего рта — `background.hackflows_locksmith`; `background.hackflows_locksmith + trait.bright`
// **Колокольчик / the Handbell** — прокажённому положено звенеть заранее — `background.hackflows_leper`; `background.hackflows_leper + trait.ailing`
**Пчела / the Bee** — жужжит с рассвета, к вечеру жалит — `background.hackflows_gardener`; `background.hackflows_herbalist + attr.Stamina.high` // +dagger something
**Уголёк / the Ember** — мелкий, чёрный и обжигает — `background.hackflows_blacksmith + trait.tiny`; `background.hackflows_blacksmith + trait.impatient`
**Работяга / the Toiler** — руки помнят работу, а не меч — `group.peaceful + attr.Stamina.high` // more factors
**Медяк / the Copper** — дешевле никого нет — `group.pauper`
**Чёрная кость / Black Bone** — не голубая кровь, а чёрная кость — `group.lowborn + trait.strong` // more factors, but not very widespread
**Лыко / the Bast** — лыком шит, а держит — `group.lowborn + trait.dumb`; `group.pauper + trait.clumsy`
// **Копна / the Haystack** — здоровый, лохматый, из деревни — `background.farmhand + trait.huge`; `trait.huge + group.lowborn`
// **Серп / the Sickle** — жал хлеб, жнёт остальное — `background.farmhand + weapon.cleaver`; `weapon.cleaver + group.lowborn`
// **Ухват / the Pot Hook** — двумя руками и в печь — `background.hackflows_cook + trait.strong`; `weapon.polearm + trait.strong`
**Чан / the Vat** — сколько влезет, столько и влезет — `background.hackflows_barkeep + trait.fat`; `background.hackflows_barkeep + trait.gluttonous` // +cook + something?
// **Невод / the Seine** — тянет вместе со всеми и вытянет — `background.fisherman + trait.teamplayer`; `background.fisherman + attr.Stamina.high`
// **Тюря / the Gruel** — хлеб, вода и никаких затей — `group.pauper + trait.gluttonous`; `background.beggar + attr.Stamina.low`
// **Смола / the Tar** — прилип — не отдерёшь — `trait.determined + trait.loyal`; `background.hackflows_roofer + trait.determined`

## Кровавые ремёсла

**Удавка / the Garrote** — тихо, коротко и без свидетелей — `background.assassin`; `perk.backstabber + trait.weasel`
// **Колодка / the Shackle** — носил сам, теперь надевает другим — `background.slave`; `background.manhunter`; `background.hackflows_torturer`
**Костоправ / the Bonesetter** — правит кости, ломает по привычке — `background.hackflows_surgeon`; `background.anatomist`
**Требуха / the Offal** — знает, что внутри у человека — `background.anatomist`; `background.anatomist + trait.bloodthirsty` // +cook combos
// **Милость / the Mercy** — добивает раненых, называет это милостью — `perk.coup_de_grace`; `perk.coup_de_grace + trait.bloodthirsty`
// **Дым / the Smoke** — после него от деревни остаётся дым — `background.raider`; `background.hackflows_pirate`
// **Хвост / the Tail** — сел на след и не отвалится — `background.hackflows_bounty_hunter + trait.determined`; `background.manhunter + trait.determined`
// **Трофей / the Trophy** — клыки на поясе, счёт на память — `background.beast_slayer`; `trait.hate_beasts + trait.cocky`
// **Погост / the Boneyard** — за ним всегда идёт кто-то ещё — `background.necro`; `background.gravedigger + trait.night_owl`; `perk.necro.soul_link`

## Вера, арена, чужие земли

**Отец / Father** — командует и отпускает грехи, всё в одном — `background.paladin + perk.rally_the_troops`;`background.monk + perk.rally_the_troops`
// **Купель / the Font** — отмыли от прежней веры, следы остались — `background.converted_cultist`; `background.witchhunter + trait.superstitious`
// **Омела / the Mistletoe** — таскает пучки травы и бормочет — `background.hackflows_druid`; `background.shaman`
**Оберег / the Charm** — без своей тряпочки в бой не пойдёт — `trait.superstitious`; `trait.superstitious + attr.Bravery.low`
**Песок / the Sand** — вырос на арене, песок в крови — `background.gladiator`; `background.gladiator + trait.survivor` //+ nomad
// **Венок / the Laurel** — победителю венок, остальным яма — `background.hackflows_champion`; `background.gladiator + trait.cocky`
**Веер / the Fan** — крутится с клинками, не подойти — `background.bladedancer`; `weapon.sword + perk.rotation`; `perk.footwork + weapon.sword`
// **Выпад / the Lunge** — учит одному движению, зато насмерть — `background.swordmaster`; `weapon.sword + perk.duelist`
// **Полынь / the Wormwood** — степная горечь, ничем не перебить — `background.nomad`; `background.nomad + trait.survivor`
// **Говор / the Accent** — двух слов не скажет, чтоб не выдать себя — `background.hackflows_outlander`; `background.nomad`
// **Пена / the Froth** — пена у рта раньше первой крови — `background.hackflows_berserker`; `perk.berserk + trait.irrational`

## Оружие

**Клюка / the Cane** — палка вместо меча, а хватает — `weapon.staff`; `background.shepherd + weapon.staff`; `weapon.staff + attr.Initiative.low` // staff not really used, need other factors
// **Свирель / the Reed Pipe** — играет, пока другие копают могилы — `weapon.musical`; `background.shepherd + weapon.musical`
// **Топорик / Handaxe** — метнёт раньше, чем ты замахнёшься — `weapon.throwing`; `weapon.throwing + trait.strong`
**Козья ножка / the Goat Foot** — рычагом натягивает, руками не выходит — `weapon.crossbow + attr.Stamina.low`; `background.hackflows_atilliator`; `background.hackflows_arbalester`
// **Копоть / the Soot** — морда чёрная от пороха — `weapon.firearm`; `background.hackflows_blacksmith + weapon.firearm`
// **Свинец / the Lead** — свинец кладёт куда обещал — `weapon.firearm + attr.RangedSkill.high`; `weapon.sling + attr.RangedSkill.high`
// **Огниво / the Firesteel** — искру высечет из чего угодно — `weapon.firearm`; `perk.elem_fire_affinity`
// **Три локтя / Three Cubits** — три локтя древка между ним и тобой — `perk.reach_advantage`; `weapon.polearm + trait.huge`; `weapon.spear + perk.reach_advantage`
**Ёж / the Hedgehog** — со всех сторон колется, не подступишься — `weapon.spear + attr.MeleeDefense.high`; `perk.reach_advantage + attr.MeleeDefense.high`
// **Тумак / the Wallop** — бьёт кулаком лучше, чем железом — `background.brawler + trait.strong`; `trait.brute + trait.strong`

## Перки и боевые привычки

// **Дар / the Gift** — всё даётся само, и это бесит — `perk.gifted`; `perk.gifted + attr.MeleeSkill.high`
// **Канат / the Tightrope** — стоит на одной ноге весь бой — `perk.hackflows.balance`; `background.juggler`
// **Кураж / the Swagger** — попал в кураж — не остановишь — `perk.hackflows.battle_flow`; `perk.killing_frenzy`
// **Заклёпка / the Rivet** — сидит крепко, не разболтается — `perk.hackflows.stabilized`; `background.hackflows_blacksmith + trait.tough`
// **Ящерица / the Lizard** — оторвут — отрастит — `perk.necro.regeneration`; `perk.hackflows.flesh_on_the_bones`
// **Второе дыхание / Second Wind** — выдохся и снова пошёл — `perk.recover`; `trait.iron_lungs + attr.Stamina.high`
// **Стойка / the Stance** — держит стойку; за стойкой и стоял — `perk.indomitable`; `perk.indomitable + attr.MeleeDefense.high`; `background.hackflows_barkeep`
// **На ногах / Still Standing** — уже не должен стоять, а стоит — `perk.hold_out`; `perk.hold_out + trait.tough`
// **Ломовой / the Drayhorse** — тянет и тянет, пока не кончится враг — `perk.relentless`; `perk.relentless + attr.Stamina.high`; `background.caravan_hand + trait.strong`
// **Обвал / the Landslide** — навалился — и всё, накрыло — `perk.overwhelm`; `perk.overwhelm + trait.strong`
**Рубаха / the Shirt** — в бой в одной рубахе; рубаха-парень — `trait.lucky + perk.nimble`; `group.lowborn + trait.lucky + attr.MeleeDefense.high`
// **Ремень / the Belt** — на нём висит всё, что нужно отряду — `perk.bags_and_belts`; `perk.quick_hands + perk.bags_and_belts`
// **Хребет / the Backbone** — на нём держится вся линия — `attr.MeleeDefense.high + trait.loyal`; `perk.shield_expert + trait.loyal`
// **Заслон / the Screen** — встанет перед тобой раньше, чем попросишь — `attr.MeleeDefense.high + trait.teamplayer`; `perk.shield_expert + trait.teamplayer`
// **Плетень / the Wattle** — стенка стенкой, а насквозь видно — `attr.MeleeDefense.high + attr.Hitpoints.low`; `perk.shield_expert + trait.fragile`
// **Мишень / the Target** — все стрелы почему-то его — `attr.MeleeDefense.low`; `attr.RangedDefense.low`
// **Сухарь / the Hardtack** — чёрствый, зато не портится — `trait.survivor + group.combat`; `trait.tough + group.combat`

## Травмы

// **Скрип / the Creak** — сустав слышно раньше, чем шаги — `injury.broken_knee`; `injury.broken_elbow_joint`
// **Локоть / the Elbow** — рука до конца не разгибается — `injury.broken_elbow_joint`; `injury.broken_elbow_joint + trait.brute`
// **Свистун / the Wheezer** — дышит со свистом, слышно через поле — `injury.collapsed_lung_part`; `trait.asthmatic + attr.Stamina.low`
**Сердечко / Little Heart** — сердечко пошаливает, а он всё лезет — `injury.weakened_heart`; `injury.weakened_heart + trait.craven` // +bulls eye?
// **Дрожь / the Shakes** — руки не унимаются с той самой ночи — `injury.traumatized`; `injury.traumatized + trait.craven`
**Мизинчик / the Pinky** — не хватает малости — `injury.missing_finger`; `injury.missing_finger + trait.tiny` // + tinty combos
// **Слепыш / the Blindworm** — днём щурится, ночью вообще стоит — `trait.night_blind + trait.short_sighted`; `trait.short_sighted + attr.RangedSkill.low`
// **Ржа / the Rust** — старое железо, старый солдат — `background.retired_soldier + trait.ailing`; `cost.low + perk.battle_forged`

## Живность

// **Клоп / the Bedbug** — мелкий, липкий, тащит чужое — `trait.tiny + trait.weasel + trait.greedy`
// **Вошь / the Louse** — вывести невозможно — `trait.tiny + trait.survivor`; `group.pauper + trait.survivor`
// **Опарыш / the Maggot** — водится там, где уже никого — `background.gravedigger + trait.weasel`; `trait.weasel + trait.ailing`
// **Слизень / the Slug** — медленный и мягкий, наступать жалко — `attr.Initiative.low + trait.fragile`; `attr.Initiative.low + trait.insecure`
// **Уж / the Grass Snake** — на вид гадюка, а кусать нечем — `trait.weasel + trait.craven`; `trait.weasel + attr.MeleeSkill.low`
// **Суслик / the Gopher** — высунулся, посмотрел, спрятался — `trait.craven + trait.night_owl`; `background.miner + trait.craven`
// **Ягнёнок / the Lamb** — пас овец, сам как овца — `background.shepherd + trait.craven`; `trait.fainthearted + trait.tiny`
// **Коршун / the Kite** — кружит, пока не увидит слабого — `background.hackflows_falconer + trait.bloodthirsty`; `trait.eagle_eyes + trait.bloodthirsty`
// **Индюк / the Turkey** — надулся, а повернуться не может — `trait.cocky + trait.clumsy`; `trait.cocky + attr.Initiative.low`
// **Трутень / the Drone** — жрёт мёд, работать не по чину — `trait.legend_slack + trait.gluttonous`; `cost.high + trait.legend_slack`
// **Зубр / the Wisent** — старый, тяжёлый, лучше не трогать — `background.retired_soldier + trait.strong`; `perk.colossus + trait.determined`
// **Вьюн / the Loach** — в руках не удержишь — `trait.quick`; `trait.quick + trait.dexterous`; `background.fisherman + trait.swift`

## Стать и повадки

// **Плечи / Broad Shoulders** — в плечах косая сажень — `trait.athletic`; `trait.athletic + attr.Stamina.high`
// **Сажень / the Fathom** — мерят им, а не портновским аршином — `trait.athletic + trait.huge`; `trait.huge + perk.brawny`
// **Вожжа / the Rein** — вожжа под хвост попала — и понесло — `trait.irrational + attr.Initiative.high`; `background.caravan_hand + trait.impatient`
**Шкет / the Nipper** — мелкий, дешёвый, за старшими бегает — `trait.tiny + background.apprentice`; `trait.tiny + cost.low`
**Обормот / the Scapegrace** — ни ума, ни терпения, зато рвётся первым — `trait.dumb + trait.impatient`; `background.brawler + trait.dumb`
