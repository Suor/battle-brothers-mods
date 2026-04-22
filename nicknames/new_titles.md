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

## Ошибки с факторами

- `trait.brute` — агрессивный, бьёт в голову с плеча, грубая сила без тактики. **НЕ** значит "физически сильный" или "мощный удар". Не использовать там, где нужна просто сила.
- `background.hackflows_skirmisher` — лёгкий боец, не разведчик/дозорный. Для дозора — `background.hackflows_town_watchman`.

## Отвергнуты как неинтересные

Богомол, Выдра, Куница, Аист, Острие, Пест, Засада, Кистень, Желчный, Упёртый, Головня, Дутый,
Угрюмый, Дрёма, Соломинка, Семь бед, Чёрный день, Буревестник, Зарница, Ртуть, Сквозняк, Порох,
Скрытень, Мякина, Разгильдяй, Свалка, Ворог, Сиделец, Ланцет, Ополченец, Завсегдатай, Дружинник

Проверить статус предложений (добавлено / в built-in / ещё нет):
```
squirrel tools.nut new
```

Формат: **Прозвище / Nickname** — кому давать свободным текстом — `факторы`
Примеры:

**Волкодав** — натаскан на тварей, знает как с ними — `trait.hate_beasts + attr.MeleeSkill.high`; `background.houndmaster + trait.hate_beasts`
**Крюк** — цепляется и не отпускает — `perk.crippling_strikes`; `background.hackflows_hangman`; `background.fisherman`

---

FILL HERE

**Подкова / Horseshoe** — то ли кузнец, то ли счастливчик — `trait.lucky`; `background.hackflows_blacksmith`; `trait.sure_footing + trait.lucky`
// **Клин / Wedge** — вбивается первым, раздвигает строй — `weapon.spear + attr.MeleeSkill.high`; `perk.underdog + trait.brave`; `trait.strong + attr.MeleeDefense.high`
**Колун / Chopper** — рубит как дрова — `weapon.axe + trait.strong`; `background.lumberjack + weapon.axe`; `weapon.axe + perk.brawny`; `weapon.axe + trait.huge`
**Кочан / Cabbage** — голова крепкая, мысли простые — `trait.iron_jaw + trait.dumb`; `perk.steel_brow + trait.dumb`; `injury.brain_damage + perk.steel_brow`
// **Корень / Root** — его с места не выдернешь — `trait.sure_footing + trait.tough`; `perk.hold_out`; `attr.MeleeDefense.high + attr.Stamina.high`
// **Обух / Poll** — бьёт тупой стороной, зато метко — `weapon.axe + trait.brute`; `weapon.mace + trait.brute`; `perk.head_hunter + weapon.axe`
// **Жернов / Millstone** — медленный, тяжёлый, всё перетрёт — `background.miller`; `trait.fat + trait.strong`; `attr.Initiative.low + attr.Hitpoints.high`
**Квас / Kvass** — кислый после пьянки, бодрит перед дракой — `trait.drunkard + trait.optimist`; `background.hackflows_barkeep`; `trait.drunkard + attr.Bravery.high`
**Пробка / Cork** — тонет редко, выживает часто — `trait.survivor`; `trait.lucky + trait.survivor`; `perk.nine_lives`
**Гнилушка / Rotten Stub** — слабый с виду, но всё ещё держится — `trait.ailing + trait.survivor`; `background.hackflows_leper`; `injury.weakened_heart + trait.survivor`
**Сучок / Snag** — мал, крив, но застрянет где не надо — `trait.tiny + trait.determined`; `trait.clubfooted + trait.tough`;
**Пила / Saw** — пилит броню, нервы и кости — `weapon.cleaver + perk.crippling_strikes`; `weapon.axe + perk.crippling_strikes`; `background.hackflows_carpenter`
**Кочерыжка / Cabbage Stump** — мелкий остаток, а зубы об него сломаешь — `trait.tiny + trait.tough`; `trait.tiny + perk.steel_brow`; `attr.Hitpoints.high + trait.tiny`
// **Плеть / Lash** — достаёт издалека и оставляет полосы — `weapon.flail`; `weapon.polearm + trait.swift`; `perk.reach_advantage`
**Окорок / Ham** — толстый кусок мяса в строю — `trait.fat + attr.Hitpoints.high`; `trait.gluttonous + trait.fat`; `background.butcher + trait.fat`
// **Сухарь / Rusk** — жёсткий и не портится — `trait.tough`; `trait.survivor + trait.tough`; `background.retired_soldier + trait.tough`
**Кисель / Jelly** — дрожит, пока не надо бежать — `trait.craven`; `trait.insecure + attr.Bravery.low`; `trait.fainthearted + attr.Initiative.high`
// **Блин / Pancake** — плоско падает, быстро встаёт — `perk.nine_lives`; `trait.clumsy + trait.survivor`; `trait.tiny + trait.fat`
**Калач / Roll** — тёртый, круглый, из печи и драки — `background.hackflows_cook`; `trait.survivor + trait.optimist`; `background.brawler + trait.tough`
**Репа / Turnip** — простая голова, крепкий корень — `trait.dumb + trait.tough`; `background.farmhand`; `attr.Hitpoints.high + attr.Initiative.low`; `trait.iron_jaw + trait.dumb`; `perk.steel_brow + trait.dumb`
**Хрен / Horseradish** — злой корешок, слёзы выбивает — `trait.brute + trait.tiny`; `weapon.dagger + trait.brute`; `trait.irrational + trait.brave`
// **Кочергой / Poker Arm** — прямой, жёсткий, лезет в огонь — `trait.determined + trait.brave`; `weapon.polearm + trait.determined`; `background.hackflows_blacksmith + trait.determined`
**Половник / Ladle** — кухонный герой с длинной рукой — `background.hackflows_cook + weapon.polearm`; `background.servant + weapon.polearm`; `weapon.polearm + trait.dumb`
// **Казан / Cauldron** — большой, чёрный, вечно кипит — `trait.fat + trait.brute`; `background.hackflows_cook + trait.brute`; `trait.drunkard + trait.brute`
**Котелок / Pothead** — голова звенит, но не трескается — `trait.iron_jaw`; `perk.steel_brow`; `injury.brain_damage + trait.tough`
// **Прутик / Twig** — тонкий, гнётся, не ломается — `trait.tiny + trait.survivor`; `trait.swift + trait.tiny`; `perk.dodge + attr.Hitpoints.low`
**Багор / Gaff** — цепляет с воды и из строя — `background.fisherman + weapon.polearm`; `weapon.polearm + perk.crippling_strikes`; `perk.reach_advantage + trait.determined`
// **Весло / Oar** — длинная рука для речной драки — `background.fisherman + weapon.polearm`; `background.hackflows_pirate + weapon.polearm`; `weapon.polearm + trait.strong`
// **Сеть / Net** — путает ноги и планы — `background.fisherman + trait.weasel`; `perk.overwhelm`; `perk.footwork + trait.weasel`
// **Узел / Knot** — всё связывает, сам не развяжется — `trait.determined`; `trait.loyal + trait.teamplayer`; `background.hackflows_hangman`
**Верёвка / Rope** — полезна, пока не окажется на шее — `background.hackflows_hangman`; `background.hackflows_pirate`; `perk.rotation + trait.teamplayer`
// **Ключ / Key** — лезет в замок и в щель доспеха — `background.hackflows_locksmith`; `weapon.dagger + trait.dexterous`; `perk.backstabber + trait.dexterous`
**Петух в мешке / Bagged Rooster** — шумит, пока не связан — `trait.cocky + attr.Bravery.low`; `trait.cocky + trait.craven`; `perk.taunt + trait.craven`
// **Сапог / Boot** — пинает, топчет, держит дорогу — `background.hackflows_cobbler`; `trait.sure_footing`; `perk.pathfinder`
**Подмётка / Sole** — всё прошла и ещё держится — `background.hackflows_cobbler + trait.survivor`; `perk.pathfinder + trait.survivor`; `injury.maimed_foot + trait.determined`
// **Сажа / Soot** — чёрный от работы и дурной славы — `background.hackflows_blacksmith`; `background.hackflows_cook`; `background.miner`
// **Копоть / Smudge** — где прошёл, там след — `background.hackflows_blacksmith`; `background.mason`; `background.hackflows_painter`
// **Уголь / Coal** — тёмный, горячий, бьёт искрами — `background.miner`; `background.hackflows_blacksmith + trait.brute`; `trait.brute + attr.Initiative.high`
// **Искра / Spark** — вспыхивает первым — `trait.impatient + attr.Initiative.high`; `perk.adrenaline`; `trait.optimist + trait.impatient`
// **Огниво / Firesteel** — высечет драку из ничего — `trait.impatient + trait.brute`; `background.hackflows_blacksmith + trait.impatient`; `perk.taunt + trait.brute`
// **Мел / Chalk** — белый след на тёмной доске — `background.hackflows_painter`; `background.historian`; `trait.bright + trait.short_sighted`
// **Глина / Clay** — мнётся, но держит форму после огня — `background.mason`; `trait.insecure + trait.survivor`; `trait.tough + trait.determined`
**Черепок / Potsherd** — битый, острый, валяется под ногами — `injury.brain_damage + trait.survivor`; `injury.brain_damage + trait.brute`; `injury.broken_elbow_joint + trait.survivor`; `trait.fragile + trait.bloodthirsty`
// **Плитка / Tile** — с крыши упал, по голове попал — `background.hackflows_roofer`; `weapon.throwing + trait.lucky`; `perk.bullseye + weapon.throwing`
// **Скат / Roofslope** — ноги сами находят край — `background.hackflows_roofer`; `trait.sure_footing + trait.swift`; `perk.footwork + trait.sure_footing`
// **Стропило / Rafter** — длинный, сухой, держит крышу — `background.hackflows_roofer + trait.huge`; `trait.huge + attr.Stamina.high`; `weapon.polearm + trait.huge`
**Сверчок / Cricket** — мелкий, громкий, не спит ночью — `trait.tiny + trait.night_owl`; `background.minstrel + trait.tiny`; `trait.optimist + trait.night_owl`
**Фитиль / Fuse** — короткий и быстро вспыхивает — `trait.tiny + trait.impatient`; `trait.impatient + trait.irrational`; `weapon.firearm + trait.impatient`
// **Пищаль / Handgonne** — дымит, грохочет, попадает иногда — `weapon.firearm`; `weapon.firearm + attr.RangedSkill.high`; `trait.brute + weapon.firearm`
// **Картечь / Grapeshot** — разносит сразу многих — `weapon.firearm + perk.overwhelm`; `weapon.throwing + perk.overwhelm`; `perk.hackflows.bloody_harvest`
// **Камень / Stone** — простой ответ на сложный вопрос — `weapon.throwing`; `trait.tough`; `trait.dumb + trait.tough`
**Булыжник / Cobble** — городской камень для чужой головы — `background.mason`; `weapon.throwing + trait.strong`; `perk.steel_brow + trait.tough`
// **Праща / Sling** — бедняцкая дальняя рука — `weapon.sling`; `background.shepherd + weapon.sling`; `background.beggar + weapon.sling`
// **Семечко / Seed** — малое зерно большой беды — `trait.tiny + trait.bright`; `background.hackflows_gardener`; `weapon.throwing + trait.tiny`
// **Крапива / Nettle** — жжётся, если тронешь — `background.hackflows_gardener`; `trait.weasel + perk.overwhelm`; `weapon.dagger + perk.overwhelm`
**Репей / Burr** — прицепится к плащу и к жизни — `trait.determined + trait.survivor`; `perk.hold_out`; `perk.underdog + trait.determined`
// **Тёрн / Blackthorn** — колючий куст у дороги — `background.hackflows_drifter + weapon.dagger`; `trait.weasel + weapon.dagger`; `trait.tough + trait.weasel`
// **Можжевельник / Juniper** — сухой, колючий, вонючий дым — `background.hackflows_herbalist`; `trait.pessimist + trait.tough`; `background.witchhunter + trait.pessimist`
**Мухомор / Toadstool** — красивый дурак, есть опасно — `trait.cocky + trait.dumb`; `background.hackflows_herbalist + trait.irrational`; `trait.irrational + trait.weasel`; `background.hackflows_cook + trait.dumb`
// **Полынь / Wormwood** — горький лекарь и горький человек — `background.hackflows_herbalist`; `trait.pessimist`; `background.witchhunter + trait.pessimist`
**Пиявочник / Leecher** — лечит тем, что пьёт кровь — `background.hackflows_herbalist + trait.greedy`; `background.hackflows_surgeon + trait.greedy`; `perk.necro.blood_sucking`
**Костыль / Crutch** — сам кривой, другим опора — `background.cripple`; `injury.maimed_foot`; `trait.clubfooted`
**Шрам / Scar** — старую беду носит на лице — `injury.missing_ear`; `injury.missing_eye`; `trait.survivor`
// **Пробоина / Breach** — дыра есть, корабль плывёт — `injury.collapsed_lung_part + trait.survivor`; `background.hackflows_pirate + trait.survivor`; `perk.nine_lives`
**Пустое ухо / Empty Ear** — слышит плохо, слушает хуже — `injury.missing_ear`; `injury.missing_ear + trait.dumb`; `injury.missing_ear + trait.brave`
// **Осколок / Shard** — маленький, острый, вечно в ране — `trait.tiny + weapon.dagger`; `injury.missing_finger + trait.determined`; `perk.crippling_strikes + trait.tiny`
// **Сломыш / Bent One** — поломан, но не списан — `injury.broken_knee`; `injury.broken_elbow_joint`; `background.cripple + trait.survivor`
// **Дырявая грудь / Holechest** — дышит через старую беду — `injury.collapsed_lung_part`; `trait.asthmatic + trait.survivor`; `injury.collapsed_lung_part + trait.iron_lungs`
**Мёртвяк / Deadman** — выглядит покойником, дерётся живым — `trait.ailing + trait.fearless`; `trait.survivor + trait.fear_undead`;
// **Кладбище / Graveyard** — пахнет землёй и плохими вестями — `background.gravedigger`; `background.graverobber`; `trait.hate_undead + background.gravedigger`
// **Могильщик / Graveman** — не профессия, а обещание — `background.gravedigger`; `trait.hate_undead`; `perk.fearsome + background.gravedigger`
**Святая вода / Holy Water** — брызжет верой, особенно от страха — `trait.fear_undead`; `background.monk + trait.fear_undead`; `background.witchhunter + trait.hate_undead`
// **Кадило / Censer** — дымит, звенит, пугает нежить — `background.monk`; `trait.hate_undead + background.monk`; `perk.rally_the_troops + background.monk`
// **Псалом / Psalm** — поёт, когда остальные ругаются — `background.monk`; `background.minstrel + trait.fear_undead`; `perk.rally_the_troops + perk.fortified_mind`
// **Исповедь / Confession** — перед ним все вспоминают грехи — `background.monk + perk.fearsome`; `background.flagellant`; `perk.taunt + background.monk`
**Хлыст / Whip** — сам себя гонит и других достаёт — `background.flagellant`; `trait.deathwish + background.flagellant`; `perk.overwhelm + weapon.flail`
// **Шов / Stitch** — сшивает раны, режет новые — `background.hackflows_surgeon`; `background.tailor + weapon.dagger`; `perk.hackflows.stabilized`
**Напёрсток / Thimble** — мал, но палец бережёт — `background.tailor + trait.tiny`; `trait.tiny + perk.shield_expert`; `trait.dexterous + trait.tiny`; `background.hackflows_con_artist + trait.tiny`; `background.hackflows_con_artist + trait.dexterous`
// **Заплата / Patch** — держится там, где всё порвалось — `background.tailor + trait.survivor`; `perk.hold_out`; `trait.teamplayer + perk.rotation`
// **Пуговица / Button** — мелкий, круглый, вечно теряется — `trait.tiny + trait.clumsy`; `background.tailor + trait.tiny`; `trait.tiny + trait.lucky`
**Монета / Coin** — звонит, манит, предаёт сторону — `trait.greedy`; `background.gambler`; `trait.disloyal + trait.greedy`
// **Кубик / Die** — выпал как выпал — `background.gambler`; `trait.lucky`; `trait.lucky + perk.nine_lives`
// **Краплёная карта / Marked Card** — честным его не назовёшь — `background.gambler + trait.weasel`; `background.hackflows_con_artist`; `trait.legend_double_tongued`
// **Ставка / Wager** — всё ставит на один удар — `background.gambler + trait.deathwish`; `perk.killing_frenzy`; `trait.lucky + trait.brave`
// **Прикуп / Draw** — всегда держит что-то в рукаве — `perk.quick_hands`; `background.gambler + perk.quick_hands`; `trait.weasel + perk.bags_and_belts`
// **Тень у костра / Camp Shadow** — рядом, но глаз не поймает — `background.thief`; `background.assassin`; `perk.dodge + trait.weasel`
**Ночной горшок / Chamberpot** — нужная вещь, дурная слава — `background.servant`; `background.servant + trait.pessimist`; `background.beggar + trait.fat`
**Крысиный хвост / Rat-tail** — грязная мелочь с дурным концом — `background.ratcatcher`; `trait.weasel + trait.tiny`; `background.beggar + trait.weasel`
// **Мышелов / Mouser** — за мелочью охотится ловко — `background.ratcatcher`; `trait.eagle_eyes + trait.dexterous`; `perk.backstabber + trait.dexterous`
// **Сыр / Cheese** — приманка для дураков и крыс — `background.ratcatcher`; `trait.gluttonous + trait.tiny`; `trait.dumb + trait.lucky`
// **Почтовый рожок / Post Horn** — трубит раньше дела — `background.messenger`; `trait.swift + perk.rally_the_troops`; `trait.cocky + attr.Initiative.high`
**Пыльная пятка / Dust Heel** — видно только след — `background.messenger + trait.swift`; `perk.pathfinder + trait.swift`; `background.hackflows_drifter + perk.pathfinder`
// **Перекат / Tumble** — катится от беды к беде — `background.vagabond`; `background.hackflows_drifter`; `perk.footwork + trait.lucky`
// **Дорожный узел / Road Knot** — всё его добро на плече — `background.vagabond + perk.bags_and_belts`; `background.caravan_hand`; `background.refugee + perk.bags_and_belts`
// **Верста / Milestone** — мерит дорогу ногами — `background.messenger`; `background.caravan_hand + perk.pathfinder`; `background.hackflows_cartographer + perk.pathfinder`
// **Пыльник / Dustcoat** — весь в дороге, весь в чужой земле — `background.caravan_hand`; `background.hackflows_outlander`; `background.nomad`
// **Карта / Map** — знает путь туда, где нас убьют — `background.hackflows_cartographer`; `perk.pathfinder`; `trait.bright + perk.pathfinder`
// **Компас / Compass** — врёт редко, заводит далеко — `background.hackflows_cartographer`; `trait.sure_footing + perk.pathfinder`; `background.messenger + trait.bright`
// **Набат / Watch Bell** — шумит, когда поздно — `background.hackflows_town_watchman`; `trait.paranoid + perk.anticipation`; `trait.night_owl + background.hackflows_town_watchman`
**Будка / Watchbox** — стоит у ворот и ворчит — `background.hackflows_town_watchman + trait.pessimist`; `trait.hesitant + attr.MeleeDefense.high`; `perk.shield_expert`; `background.houndmaster`; `background.houndmaster + trait.loyal`
// **Соколок / Little Falcon** — маленький глазастый охотник — `background.hackflows_falconer`; `trait.eagle_eyes + trait.tiny`; `type.ranged + trait.eagle_eyes`
// **Перышко / Feather** — лёгкий, быстрый, сдувает первым — `trait.swift + trait.tiny`; `trait.legend_light`; `perk.dodge + trait.tiny`
// **Клюв / Beak** — бьёт точно и клюёт падаль — `background.hackflows_falconer + attr.RangedSkill.high`; `weapon.dagger + perk.coup_de_grace`; `trait.eagle_eyes + perk.bullseye`

## Ещё сотня

// **Борона / Harrow** — цепляет ряд за рядом — `weapon.polearm + perk.overwhelm`; `weapon.flail + perk.overwhelm`; `background.farmhand + weapon.polearm`
**Кайло / Pickaxe** — шахтёрский удар по шлему — `background.miner`;
// **Клык / Fang** — малый нож, большая дырка — `weapon.dagger + trait.bloodthirsty`; `trait.hate_beasts + weapon.dagger`; `perk.coup_de_grace + weapon.dagger`
**Кость / Bone** — торчит, хрустит, не сдаётся — `injury.broken_elbow_joint`; `perk.hold_out + trait.dumb`;`trait.iron_jaw + trait.dumb`
// **Жила / Sinew** — сухой, тянется до конца — `attr.Stamina.high + trait.tough`; `perk.recover + trait.survivor`; `trait.iron_lungs + attr.Stamina.high`
// **Солонина / Salt Beef** — старое мясо, долго лежит — `trait.fat + trait.survivor`; `trait.tough + trait.fat`; `background.butcher + trait.survivor`
**Копыто / Hoof** — топчет и не спотыкается — `trait.sure_footing + trait.strong`; `background.shepherd + trait.sure_footing`;
**Кабанчик / Shoat** — мал, жирен и лезет под ноги — `trait.tiny + trait.fat`; `trait.brute + trait.fat`; `trait.gluttonous + trait.impatient`
// **Хомут / Yoke** — тянет, пока не упадёт — `trait.loyal + trait.strong`; `background.farmhand + attr.Stamina.high`; `perk.brawny + trait.loyal`
// **Ошейник / Collar** — служит верно, пока держат — `trait.loyal`; `background.slave + trait.loyal`; `background.houndmaster + trait.teamplayer`
**Капюшон / Hood** — лицо прячет, нож держит — `background.thief`; `background.assassin`; `perk.backstabber`
// **Сундук / Chest** — тяжёлый, заперт, полный добра — `perk.bags_and_belts + trait.greedy`; `background.caravan_hand + trait.greedy`; `attr.Hitpoints.high + trait.fat`
// **Ларь / Strongbox** — малый сундук с замком — `background.hackflows_locksmith + trait.tiny`; `trait.greedy + trait.tiny`; `perk.bags_and_belts + trait.tiny`
// **Засов / Bolt Bar** — закрыл проход собой — `attr.MeleeDefense.high + trait.tough`; `perk.shield_expert`; `trait.determined + perk.underdog`
// **Щеколда / Latch** — держится на малом железе — `trait.tiny + trait.determined`; `background.hackflows_locksmith`; `perk.hold_out + trait.tiny`
// **Петлица / Buttonhole** — мелкая дырка, а дело держит — `background.tailor + trait.dexterous`; `trait.tiny + trait.teamplayer`; `perk.rotation + trait.dexterous`
// **Завязка / Tie** — всё связывает и всех тормозит — `background.tailor`; `perk.overwhelm + trait.dexterous`; `trait.teamplayer + perk.rotation`
// **Лоскут / Rag** — драный, грязный, ещё годится — `background.beggar`; `trait.survivor + trait.fragile`; `background.hackflows_leper + trait.survivor`
// **Тряпка / Dishrag** — мягок, мокр, но нужен — `trait.insecure`; `background.servant`; `trait.fainthearted + trait.teamplayer`
// **Половик / Doormat** — об него все ноги вытерли — `background.servant + trait.insecure`; `trait.fainthearted + trait.loyal`; `attr.Bravery.low + trait.teamplayer`
// **Кочедыжник / Poker** — ковыряет, пока не вспыхнет — `background.hackflows_blacksmith + trait.impatient`; `weapon.polearm + perk.overwhelm`; `trait.impatient + weapon.spear`
// **Ухват / Pot Hook** — тащит из огня и в огонь — `background.hackflows_cook + trait.brave`; `weapon.polearm + trait.brave`; `perk.rotation + trait.brave`
// **Кочерга / Fire Iron** — железная палка для чужих зубов — `background.hackflows_blacksmith + weapon.mace`; `trait.determined + weapon.mace`; `perk.steel_brow + trait.determined`
// **Кружка / Mug** — пустая к утру, тяжёлая в драке — `trait.drunkard`; `background.hackflows_barkeep`; `trait.drunkard + weapon.mace`
// **Бочонок / Keg** — меньше бочки, шуму столько же — `trait.fat + trait.drunkard`; `background.hackflows_barkeep + trait.fat`; `trait.gluttonous + trait.drunkard`
// **Пена / Froth** — лезет через край — `trait.impatient + trait.drunkard`; `background.hackflows_barkeep + trait.optimist`; `trait.cocky + trait.drunkard`
// **Закуска / Snack** — малый кусок перед мясом — `trait.tiny + trait.gluttonous`; `background.hackflows_cook + trait.tiny`; `trait.tiny + trait.fat`
// **Похлёбка / Pottage** — мутный, горячий, дешёвый — `background.hackflows_cook`; `trait.dumb + trait.optimist`; `cost.low + trait.fat`
// **Корка / Crust** — сухая, жёсткая, бедняцкая — `background.beggar + trait.tough`; `trait.tough + attr.Hitpoints.low`; `cost.low + trait.survivor`
// **Сухарь в щах / Soup Crust** — тонет, но не размокает — `trait.tough + trait.survivor`; `background.hackflows_cook + trait.tough`; `perk.hold_out + trait.survivor`
// **Крошка / Crumb** — мал, а везде найдётся — `trait.tiny`; `trait.tiny + trait.lucky`; `background.beggar + trait.tiny`
// **Соль / Salt** — щиплет раны и язык — `background.hackflows_cook`; `trait.pessimist + trait.cocky`; `perk.taunt + trait.pessimist`
**Сало / Lard** — мягкий запас на чёрный день — `trait.fat`; `trait.gluttonous`; `background.butcher + trait.gluttonous`
// **Шкварка / Crackling** — малый жирный кусок, хрустит — `trait.tiny + trait.fat`; `background.butcher + trait.tiny`; `trait.gluttonous + trait.tiny`
// **Потрох / Gut** — висит, пахнет, пугает — `trait.fat + perk.fearsome`; `background.butcher + perk.fearsome`; `trait.bloodthirsty + perk.fearsome`
// **Требуха / Tripe** — скользкая дрянь из мясника — `background.butcher + trait.weasel`; `trait.fat + trait.weasel`; `trait.gluttonous + trait.weasel`
// **Селезёнка / Spleen** — ноет сбоку и злит — `trait.pessimist + trait.irrational`; `trait.fragile + trait.brute`; `injury.collapsed_lung_part + trait.pessimist`
// **Горло / Gullet** — орёт, пьёт, просит ещё — `trait.drunkard + perk.rally_the_troops`; `trait.gluttonous + trait.cocky`; `perk.taunt + trait.drunkard`
// **Глотка / Throat** — громкая цель для ножа — `perk.rally_the_troops`; `perk.taunt + attr.Bravery.high`; `trait.cocky + attr.Stamina.high`
// **Затылок / Nape** — всё ловит головой — `perk.steel_brow`; `trait.iron_jaw + trait.dumb`; `injury.brain_damage + perk.steel_brow`
// **Темя / Crown** — бьют сверху, а он смеётся — `perk.steel_brow`; `trait.iron_jaw + trait.fearless`; `perk.head_hunter + trait.brute`
// **Челюсть / Jawbone** — зубы выбиты, упрямство нет — `trait.iron_jaw`; `injury.missing_nose + trait.tough`; `perk.steel_brow + trait.iron_jaw`
// **Скоба / Staple** — скрепляет строй грубым железом — `trait.teamplayer + attr.MeleeDefense.high`; `background.hackflows_blacksmith + trait.teamplayer`; `perk.rotation + trait.teamplayer`
// **Заклёпка / Rivet** — малая железка, держит панцирь — `trait.tiny + trait.tough`; `background.hackflows_blacksmith + trait.tiny`; `perk.battle_forged + trait.tiny`
// **Гвоздик / Tack** — мелко колет и мешает — `trait.tiny + weapon.dagger`; `perk.overwhelm + trait.tiny`; `background.hackflows_cobbler + trait.tiny`
// **Шип / Thorn** — наступишь раз, помнишь долго — `weapon.dagger + perk.crippling_strikes`; `trait.tiny + perk.crippling_strikes`; `background.hackflows_gardener + trait.weasel`
// **Колючка / Prickle** — мелкая гадость в рукаве — `trait.tiny + trait.weasel`; `weapon.dagger + trait.tiny`; `perk.backstabber + trait.tiny`
// **Крапивник / Nettleman** — жжётся и живёт в канаве — `background.hackflows_gardener + trait.brute`; `trait.pessimist + perk.overwhelm`; `background.beggar + trait.brute`
// **Лопух / Burdock** — широк, глуп, к грязи липнет — `trait.dumb + trait.fat`; `background.hackflows_gardener + trait.dumb`; `trait.gluttonous + trait.dumb`
// **Редька / Radish** — горек, мал, из земли — `background.farmhand + trait.pessimist`; `trait.tiny + trait.pessimist`; `background.hackflows_gardener + trait.tiny`
// **Луковица / Onion** — слёзы выбивает слоями — `background.hackflows_cook`; `perk.fearsome + trait.tiny`; `trait.pessimist + trait.gluttonous`
// **Чесночина / Garlic Bulb** — от нежити и друзей воняет — `trait.fear_undead`; `background.hackflows_cook + trait.fear_undead`; `background.witchhunter + trait.fear_undead`
// **Крап / Speck** — малое пятно на чистой рубахе — `background.hackflows_painter + trait.tiny`; `trait.tiny + trait.disloyal`; `background.tailor + trait.weasel`
// **Мазок / Daub** — куда ткнули, там след — `background.hackflows_painter`; `trait.clumsy + background.hackflows_painter`; `weapon.mace + trait.clumsy`
// **Клякса / Blot** — расползся и всё испортил — `trait.clumsy`; `trait.fat + trait.clumsy`; `background.hackflows_painter + trait.dumb`
// **Пятно / Stain** — не отмыть ни с рубахи, ни с имени — `trait.disloyal`; `background.killer_on_the_run`; `background.oathbreaker`
// **Мазила / Dauber** — мажет краской и клинком — `background.hackflows_painter + attr.MeleeSkill.low`; `type.ranged + attr.RangedSkill.low`; `trait.clumsy + weapon.throwing`
// **Огарок / Candle Stub** — мал, чадит, скоро кончится — `trait.tiny + trait.ailing`; `trait.tiny + attr.Hitpoints.low`; `background.monk + trait.tiny`
// **Свечник / Candlestick** — держит свет и получает по голове — `background.monk + perk.steel_brow`; `weapon.mace + background.monk`; `trait.fear_undead + perk.steel_brow`
// **Ладанка / Charm Bag** — трясётся, но молится — `trait.fear_undead + trait.superstitious`; `background.monk + trait.superstitious`; `trait.fear_undead + attr.Bravery.low`
// **Обет / Vow** — сказал и теперь мучается — `background.flagellant`; `background.paladin + trait.determined`; `trait.determined + trait.fearless`
// **Вериги / Chains** — сам себя тащит железом — `background.flagellant`; `perk.brawny + background.flagellant`; `trait.deathwish + perk.battle_forged`
// **Рубец / Welt** — след от плети и чужой руки — `background.flagellant`; `injury.traumatized + trait.tough`; `trait.survivor + perk.hold_out`
// **Плаха / Block** — ждёт топора спокойно — `background.hackflows_hangman`; `trait.fearless + perk.steel_brow`; `perk.coup_de_grace + weapon.axe`
// **Колокол / Bell** — слышно до соседнего болота — `perk.rally_the_troops`; `trait.cocky + perk.rally_the_troops`; `background.hackflows_town_watchman + perk.rally_the_troops`
// **Рында / Bellman** — стережёт и орёт — `background.hackflows_town_watchman`; `background.messenger + perk.rally_the_troops`; `trait.night_owl + perk.rally_the_troops`
// **Калитка / Wicket** — впускает своих, бьёт чужих — `background.hackflows_town_watchman + trait.teamplayer`; `perk.rotation + attr.MeleeDefense.high`; `perk.shield_expert + trait.teamplayer`
// **Сторожка / Guard Hut** — тесно, грязно, но укрывает — `background.hackflows_town_watchman`; `trait.paranoid + attr.MeleeDefense.high`; `perk.anticipation + trait.paranoid`
// **Свистун / Whistler** — первым подаёт голос — `background.messenger`; `perk.rally_the_troops + trait.swift`; `trait.cocky + trait.swift`
// **Сапожник / Bootman** — чинит подошвы, ломает пальцы — `background.hackflows_cobbler`; `background.hackflows_cobbler + weapon.mace`; `trait.dexterous + background.hackflows_cobbler`
// **Шнурок / Shoelace** — тонок, но держит шаг — `background.hackflows_cobbler + trait.tiny`; `trait.tiny + trait.teamplayer`; `perk.pathfinder + trait.tiny`
// **Колодка / Shoe Last** — деревянная нога с характером — `background.hackflows_cobbler`; `trait.clubfooted + trait.tough`; `injury.maimed_foot + trait.determined`
// **Подкова в лоб / Forehead Shoe** — счастье прилетело железом — `trait.lucky + perk.steel_brow`; `background.hackflows_blacksmith + perk.head_hunter`; `weapon.throwing + perk.head_hunter`
// **Черпак / Scoop** — выносит грязь и похлёбку — `background.servant`; `background.hackflows_cook + trait.teamplayer`; `perk.rotation + background.servant`
// **Помело / Broom** — метёт всех в кучу — `background.servant`; `perk.overwhelm + weapon.polearm`; `trait.teamplayer + perk.rotation`
// **Таз / Basin** — звенит, мнётся, держит воду — `background.servant + perk.steel_brow`; `trait.fat + perk.steel_brow`; `attr.Hitpoints.high + trait.clumsy`
// **Решётка / Grate** — держит удар, всё пропускает — `attr.MeleeDefense.high + attr.RangedDefense.low`; `perk.shield_expert + attr.RangedDefense.low`; `trait.tough + attr.RangedDefense.low`
// **Заслон / Screen** — прячет других за собой — `perk.shield_expert + trait.teamplayer`; `perk.rotation + trait.teamplayer`; `attr.MeleeDefense.high + trait.teamplayer`
// **Навес / Lean-to** — кривой, но от дождя спасёт — `background.hackflows_carpenter`; `trait.clubfooted + trait.teamplayer`; `background.hackflows_roofer + trait.teamplayer`
// **Щепка / Woodchip** — отлетает, но режет глаз — `background.hackflows_carpenter + trait.tiny`; `weapon.axe + trait.tiny`; `trait.fragile + weapon.dagger`
// **Стружка / Shaving** — тонкая, сухая, везде лезет — `background.hackflows_carpenter + trait.swift`; `trait.tiny + trait.swift`; `perk.dodge + trait.swift`
// **Смола / Tar** — липнет к сапогам и чужой славе — `trait.weasel + trait.greedy`; `background.hackflows_pirate + trait.weasel`; `background.lumberjack + trait.weasel`
// **Дёготь / Pitch** — чёрный след после плохого дела — `background.hackflows_pirate`; `trait.disloyal + trait.weasel`; `background.raider + trait.disloyal`
// **Киль / Keel** — держит путь, пока всё тонет — `background.hackflows_pirate + trait.determined`; `trait.sure_footing + background.hackflows_pirate`; `perk.pathfinder + background.hackflows_pirate`
// **Рыбья кость / Fishbone** — в горле застрянет — `background.fisherman + weapon.dagger`; `weapon.dagger + perk.crippling_strikes`; `trait.tiny + perk.overwhelm`
// **Чешуя / Scales** — скользит и блестит чужим добром — `background.fisherman + trait.weasel`; `trait.dexterous + trait.weasel`; `perk.dodge + trait.weasel`
// **Поплавок / Float** — дернулся, значит живой — `background.fisherman`; `trait.survivor + trait.lucky`; `perk.nine_lives + trait.lucky`
// **Кормак / Feedbag** — ест за двоих, бьёт за одного — `trait.gluttonous`; `trait.gluttonous + trait.strong`; `background.farmhand + trait.gluttonous`
// **Зерно / Grain** — малое, но в мешке сила — `background.farmhand`; `trait.tiny + trait.teamplayer`; `cost.low + trait.determined`
// **Сноп / Sheaf** — связан, тяжёл и всё равно падает — `background.farmhand + trait.fat`; `trait.hesitant + trait.fat`; `perk.bags_and_belts + background.farmhand`
// **Мякиш / Crumb Belly** — мягкий внутри и снаружи — `trait.fat + trait.insecure`; `trait.fragile + trait.fat`; `background.hackflows_cook + trait.insecure`
// **Квашняк / Doughman** — липкий ком у костра — `trait.fat + trait.clumsy`; `trait.gluttonous + trait.clumsy`; `background.miller + trait.fat`
// **Мука / Meal** — весь белый от дороги и мельницы — `background.miller`; `background.hackflows_baker`; `trait.fainthearted + trait.fragile`
// **Мешочник / Sackman** — всё тащит, всё теряет — `perk.bags_and_belts`; `background.caravan_hand + perk.bags_and_belts`; `trait.clumsy + perk.bags_and_belts`
// **Тележник / Cartman** — медленный, но всё довезёт — `background.caravan_hand`; `attr.Stamina.high + attr.Initiative.low`; `perk.brawny + attr.Initiative.low`
// **Ось / Axle** — скрипит и держит воз — `background.caravan_hand + trait.tough`; `trait.clubfooted + trait.tough`; `attr.Stamina.high + trait.tough`
**Колесо / Wheel** — крутится, пока не сломается — `background.caravan_hand`; `perk.rotation`; `trait.swift + perk.footwork`
// **Спица / Spoke** — тонкая часть общего дела — `trait.tiny + trait.teamplayer`; `perk.rotation + trait.tiny`; `background.hackflows_carpenter + trait.teamplayer`
// **Ремень / Strap** — перетянет рану и горло — `background.tailor + trait.teamplayer`; `background.hackflows_torturer`; `perk.hold_out + trait.teamplayer`
// **Портянка / Footwrap** — воняет, но без неё никак — `background.hackflows_cobbler`; `background.servant + trait.teamplayer`; `trait.loyal + trait.fat`
// **Кляп / Gag** — лучше бы молчал — `perk.taunt + trait.dumb`; `background.hackflows_torturer`; `trait.cocky + trait.dumb`
// **Щипцы / Tongs** — держит горячее и чужое — `background.hackflows_blacksmith`; `background.hackflows_torturer`; `trait.dexterous + perk.crippling_strikes`
// **Зажим / Clamp** — стиснет и не отпустит — `perk.crippling_strikes + trait.strong`; `background.hackflows_blacksmith + perk.crippling_strikes`; `perk.underdog + trait.strong`
// **Тесак / Cleaver Lad** — рубит широко и грязно — `weapon.cleaver`; `weapon.cleaver + trait.brute`; `background.butcher + weapon.cleaver`
**Секач / Hewer** — рубит не глядя — `weapon.axe + trait.impatient`; `weapon.cleaver + trait.impatient`; `perk.berserk`
// **Рёбра / Ribs** — считай, если успеешь — `trait.fragile + trait.tough`; `injury.collapsed_lung_part`; `perk.crippling_strikes + weapon.mace`
// **Селёдка / Herring** — тощий рыбный запах — `background.fisherman + trait.tiny`; `trait.fragile + trait.tiny`; `background.hackflows_pirate + trait.tiny`
// **Тарань / Dried Fish** — сухой, солёный, долго живёт — `background.fisherman + trait.tough`; `trait.pessimist + trait.survivor`; `trait.ailing + trait.tough`
**Хомяк / Hoarder** — щёки полны, руки заняты — `trait.greedy + trait.gluttonous`; `perk.bags_and_belts + trait.greedy`; `trait.fat + trait.greedy`
// **Крот / Mole** — землю любит, света нет — `background.miner`; `trait.night_blind`; `background.gravedigger + trait.short_sighted`
// **Барсук / Badger** — в норе сидит, из норы кусает — `background.miner + trait.brave`; `trait.tiny + trait.brute`; `perk.underdog + trait.brute`
// **Жук / Beetle** — малый панцирь под сапогом — `trait.tiny + perk.battle_forged`; `trait.tiny + trait.tough`; `perk.nimble + trait.tiny`
// **Жужело / Buzzer** — шумит над ухом перед дракой — `trait.cocky + trait.tiny`; `perk.taunt + trait.tiny`; `background.minstrel + trait.cocky`
**Паскуда / Scab** — грязная мелочь с улыбкой — `trait.weasel + trait.disloyal`; `background.hackflows_con_artist + trait.disloyal`; `trait.greedy + trait.weasel`
// **Прищепка / Clothespin** — мала, цепка, больно щиплет — `trait.tiny + trait.dexterous`; `background.tailor + trait.dexterous`; `perk.crippling_strikes + trait.dexterous`
// **Клещи / Pincers** — с двух сторон и до крови — `weapon.dagger + perk.duelist`; `perk.crippling_strikes + trait.dexterous`; `background.hackflows_blacksmith + weapon.dagger`

## Двухсловные

**Гнилой зуб / Rot Tooth** — мерзкий оскал после грязной работы — `trait.weasel + trait.disloyal`; `trait.bloodthirsty + trait.weasel`; `background.killer_on_the_run`
// **Кривой нож / Bent Knife** — режет косо, но глубоко — `weapon.dagger + trait.clumsy`; `weapon.dagger + trait.weasel`; `background.thief + trait.clumsy`
// **Рыбий глаз / Fish Eye** — мутный взгляд с речного берега — `background.fisherman`; `trait.short_sighted`; `trait.night_blind + background.fisherman`
// **Чужой нож / Strange Knife** — появился невесть откуда и уже в спине — `background.hackflows_outlander + weapon.dagger`; `background.assassin`; `perk.backstabber + trait.disloyal`
// **Сухой язык / Dry Tongue** — ворчит, просит пить, спорит — `trait.pessimist + trait.drunkard`; `trait.cocky + trait.pessimist`; `background.hackflows_barkeep + trait.pessimist`
**Битый жбан / Cracked Jug** — голова треснула, ноги идут — `injury.brain_damage`; `injury.brain_damage + trait.survivor`; `perk.nine_lives + trait.dumb`
// **Пустой жбан / Empty Jug** — звенит громко, толку мало — `trait.dumb`; `trait.dumb + trait.cocky`; `perk.taunt + trait.dumb`
// **Кровавый рукав / Red Sleeve** — вытер клинок и пошёл дальше — `trait.bloodthirsty`; `weapon.cleaver + trait.bloodthirsty`; `perk.killing_frenzy`
// **Драный рукав / Torn Sleeve** — весь в лоскутах, но держит щит — `background.beggar + trait.tough`; `trait.survivor + trait.fragile`; `perk.hold_out`
// **Мёртвая хватка / Dead Grip** — пальцы не разжимает даже после удара — `perk.crippling_strikes + trait.determined`; `trait.strong + trait.determined`; `perk.underdog + trait.determined`
// **Третий зуб / Third Tooth** — зубов мало, злобы хватит — `trait.iron_jaw + trait.brute`; `trait.tiny + trait.brute`; `perk.fearsome + trait.brute`
**Свиное ушко / Pig Ear** — всё слышал, всё сожрал — `trait.gluttonous + trait.greedy`; `injury.missing_ear + trait.gluttonous`; `trait.fat + trait.greedy`
// **Пьяный гвоздь / Drunk Nail** — криво забит, крепко сидит — `trait.drunkard + trait.determined`; `trait.drunkard + trait.tough`; `background.hackflows_barkeep + perk.hold_out`
// **Слепой болт / Blind Bolt** — летит куда-то, иногда в цель — `weapon.crossbow + attr.RangedSkill.low`; `weapon.crossbow + trait.short_sighted`; `perk.bullseye + trait.night_blind`
**Грязный ноготь / Dirty Nail** — грязь под ногтями и на совести — `background.gravedigger`; `background.miner`; `trait.disloyal + trait.weasel`
// **Сломанный зуб / Split Tooth** — больной оскал перед дракой — `trait.iron_jaw + trait.irrational`; `injury.missing_nose + trait.brute`; `perk.fearsome + trait.iron_jaw`
// **Старый шрам / Old Scar** — старая рана учит новой — `trait.survivor`; `background.retired_soldier + trait.survivor`; `injury.traumatized + trait.tough`
// **Свежий шов / Fresh Stitch** — ещё мокрый, уже в строю — `background.hackflows_surgeon`; `injury.missing_finger + trait.survivor`; `perk.hackflows.stabilized`
// **Грязный бинт / Dirty Rag** — лечит плохо, держит крепко — `background.hackflows_surgeon + trait.pessimist`; `background.hackflows_herbalist + trait.clumsy`; `perk.hackflows.stabilized + trait.clumsy`
// **Медная кружка / Copper Mug** — звонкая башня после попойки — `trait.drunkard + perk.steel_brow`; `background.hackflows_barkeep + perk.rally_the_troops`; `trait.iron_jaw + trait.drunkard`
// **Ржавая цепь / Rust Chain** — скрипит, но держит — `weapon.flail`; `background.slave + trait.determined`; `trait.tough + trait.hesitant`
// **Гнилой канат / Rot Rope** — выглядит плохо, рвётся позже — `background.hackflows_pirate + trait.survivor`; `background.hackflows_hangman + trait.tough`; `trait.fragile + trait.survivor`
// **Кривой крюк / Bent Hook** — цепляет не там, но больно — `background.fisherman + trait.clumsy`; `perk.crippling_strikes + trait.clumsy`; `weapon.polearm + trait.clumsy`
// **Сухая плеть / Dry Lash** — хлещет без крови, пока не надоест — `weapon.flail + trait.determined`; `background.flagellant`; `perk.overwhelm + weapon.flail`
// **Пустая петля / Empty Noose** — ждёт чужую шею — `background.hackflows_hangman`; `perk.coup_de_grace`; `trait.determined + background.hackflows_hangman`
// **Мокрый сапог / Wet Boot** — тяжёлый шаг после канавы — `background.hackflows_cobbler`; `trait.clubfooted`; `injury.maimed_foot + trait.tough`
// **Дырявый сапог / Hole Boot** — бедный, хромой, упрямый — `background.hackflows_cobbler + trait.tough`; `injury.maimed_foot`; `background.beggar + trait.determined`
**Две левых / Two Left** — всё время не с той ноги — `trait.clubfooted`; `trait.clubfooted + trait.clumsy`; `trait.clubfooted + trait.pessimist`
**Не та нога / Wrong Leg** — всё время не с той ноги — `trait.clubfooted`; `trait.clubfooted + trait.clumsy`; `trait.clubfooted + trait.pessimist`
// **Чужой сапог / Odd Boot** — носит чужое и врёт своё — `background.thief + trait.greedy`; `background.hackflows_con_artist`; `trait.disloyal + trait.greedy`
// **Бабий платок / Wife Scarf** — завязан крепче, чем клятва — `background.tailor`; `trait.insecure + trait.loyal`; `trait.fainthearted + trait.teamplayer`
// **Вдовий платок / Widow Scarf** — тёмная тряпка после плохих дел — `background.gravedigger`; `background.killer_on_the_run`; `trait.pessimist + trait.disloyal`
// **Мёртвый узел / Dead Knot** — не развязать, только резать — `trait.determined`; `background.hackflows_hangman + trait.determined`; `perk.hold_out + trait.determined`
// **Кровный долг / Blood Debt** — считает удары и головы — `trait.bloodthirsty + trait.determined`; `perk.killing_frenzy`; `trait.hate_greenskins + trait.determined`
// **Слепая клятва / Blind Oath** — верит сильнее, чем видит — `background.paladin + trait.short_sighted`; `background.monk + trait.determined`; `trait.fear_undead + trait.determined`
// **Пьяная клятва / Drunk Oath** — утром забыл, в драке помнит — `trait.drunkard + trait.loyal`; `trait.drunkard + trait.brave`; `background.hackflows_barkeep + trait.loyal`
// **Пустая миска / Empty Bowl** — просит добавки и крови — `background.beggar`; `trait.gluttonous`; `trait.greedy + trait.gluttonous`
// **Треснувший щит / Split Shield** — прикрывает, пока не развалится — `perk.shield_expert + trait.fragile`; `perk.shield_expert + trait.survivor`; `trait.teamplayer + perk.shield_expert`
// **Глухой щит / Deaf Shield** — не слышит, зато стоит — `injury.missing_ear + perk.shield_expert`; `trait.dumb + perk.shield_expert`; `attr.MeleeDefense.high + trait.dumb`
// **Солёный кулак / Salt Fist** — моряк, пьяница, драчун — `background.hackflows_pirate + trait.brute`; `trait.drunkard + weapon.mace`; `background.fisherman + trait.brute`
// **Грязный кулак / Dirt Fist** — пахнет землёй и дракой — `background.farmhand + trait.brute`; `background.gravedigger + trait.brute`; `trait.brute + trait.dumb`
// **Мельничный кулак / Mill Fist** — мука на руке, кровь на костяшках — `background.miller + trait.strong`; `background.miller + weapon.mace`; `trait.strong + weapon.mace`
// **Рыбацкий кулак / Fish Fist** — пахнет рекой, бьёт сухо — `background.fisherman + trait.strong`; `background.fisherman + weapon.mace`; `trait.strong + trait.sure_footing`
**Песья кость / Dog Bone** — грызёт старую обиду — `background.houndmaster`; `trait.loyal + trait.brute`; `trait.hate_beasts + trait.brute`
// **Волчья яма / Wolf Pit** — туда лезут один раз — `background.hunter + perk.crippling_strikes`; `trait.hate_beasts + perk.crippling_strikes`; `perk.underdog + perk.fearsome`
// **Крысиная нора / Rat Hole** — грязный выход всегда найдёт — `background.ratcatcher`; `trait.weasel + perk.footwork`; `perk.pathfinder + trait.weasel`
// **Воронья лапа / Crow Foot** — кривой след после падали — `background.graverobber`; `trait.weasel + injury.maimed_foot`; `background.hackflows_drifter + trait.weasel`
// **Слепая ворона / Blind Crow** — каркает, но цель чует — `trait.short_sighted + trait.cocky`; `trait.night_blind + perk.anticipation`; `background.graverobber + trait.short_sighted`
// **Собачья верность / Dog Faith** — за хозяина и в грязь — `trait.loyal + trait.teamplayer`; `background.houndmaster + trait.loyal`; `perk.rotation + trait.loyal`
// **Собачья драка / Dog Fight** — вцепился первым — `background.brawler`; `trait.brute + trait.impatient`; `perk.underdog + trait.brute`
// **Ведьмин зуб / Witch Tooth** — от ведьмы трофей или проклятие — `background.witchhunter`; `trait.hate_beasts + trait.superstitious`; `trait.fear_undead + trait.superstitious`
// **Мёртвая свеча / Dead Candle** — светит только покойникам — `background.gravedigger + trait.pessimist`; `trait.fear_undead + background.gravedigger`; `background.monk + trait.pessimist`
// **Гробовой гвоздь / Coffin Nail** — короткий путь в землю — `background.gravedigger + weapon.dagger`; `perk.coup_de_grace + weapon.dagger`; `background.hackflows_carpenter + trait.bloodthirsty`
// **Могильный пёс / Grave Dog** — сторожит мёртвых лучше живых — `background.gravedigger + trait.loyal`; `background.houndmaster + trait.fear_undead`; `trait.hate_undead + trait.loyal`
// **Плохая монета / Bad Coin** — блестит, но не берут — `trait.greedy + trait.disloyal`; `background.gambler + trait.disloyal`; `background.hackflows_con_artist + trait.greedy`
// **Битый медяк / Bent Penny** — дешёвый, мятый, ходит — `cost.low + trait.survivor`; `cost.low + trait.tough`; `trait.lucky + cost.low`
// **Кровавый медяк / Red Penny** — мелкая плата за грязь — `cost.low + trait.bloodthirsty`; `trait.greedy + trait.bloodthirsty`; `background.killer_on_the_run + trait.greedy`
// **Чёрная карта / Black Card** — тянет беду из колоды — `background.gambler + trait.pessimist`; `background.hackflows_con_artist + trait.weasel`; `trait.lucky + trait.disloyal`
// **Рваная карта / Torn Card** — краплёная, мятая, счастливая — `background.gambler + trait.lucky`; `background.gambler + trait.weasel`; `trait.lucky + trait.weasel`
// **Пустой рукав / Empty Sleeve** — рука ушла, нож остался — `injury.missing_hand`; `injury.missing_hand + trait.survivor`; `injury.missing_hand + perk.quick_hands`
// **Железный локоть / Iron Elbow** — сломан, но работает — `injury.broken_elbow_joint + trait.tough`; `injury.broken_elbow_joint + trait.determined`; `perk.brawny + trait.tough`
// **Дурная нога / Bad Leg** — сама несёт куда не надо — `trait.clubfooted`; `injury.maimed_foot`; `trait.clubfooted + trait.impatient`
// **Чужая рука / Wrong Hand** — берёт не своё — `background.thief`; `trait.greedy + trait.weasel`; `perk.quick_hands + trait.disloyal`
// **Липкая рука / Sticky Hand** — к чужому добру пристаёт — `background.thief + trait.greedy`; `background.hackflows_con_artist + trait.greedy`; `perk.quick_hands + trait.greedy`
// **Длинная рука / Long Hand** — достаёт из строя и кармана — `weapon.polearm`; `background.thief + perk.quick_hands`; `perk.reach_advantage`
// **Тяжёлая ладонь / Heavy Palm** — ласкает как молот — `weapon.mace + trait.strong`; `weapon.hammer + trait.strong`; `trait.strong + perk.brawny`
// **Лёгкая ладонь / Light Palm** — шлёпнет, и кошель пропал — `background.thief + trait.dexterous`; `perk.quick_hands + trait.dexterous`; `weapon.dagger + trait.dexterous`
// **Кривой палец / Bent Finger** — показывает не туда, бьёт туда — `injury.missing_finger`; `trait.clumsy + weapon.dagger`; `perk.backstabber + trait.clumsy`
// **Сухой палец / Dry Finger** — на курке дрожит — `weapon.firearm + trait.hesitant`; `weapon.crossbow + trait.hesitant`; `trait.hesitant + attr.RangedSkill.high`

**Карман / Pocket** — чужое добро само туда падает — `background.thief`; `background.hackflows_con_artist`; `trait.greedy + perk.quick_hands`; `trait.weasel + perk.bags_and_belts`
// **Блудный палец / Stray Finger** — сам лезет в кошель — `background.thief + injury.missing_finger`; `trait.greedy + injury.missing_finger`; `perk.quick_hands + injury.missing_finger`
// **Горький хлеб / Bitter Bread** — бедняцкий кусок с зубами — `background.beggar + trait.pessimist`; `background.refugee + trait.pessimist`; `trait.pessimist + trait.tough`
// **Чёрствый хлеб / Stale Bread** — сухой и крепкий — `trait.tough`; `background.hackflows_cook + trait.tough`; `trait.survivor + attr.Stamina.high`
// **Плесневый хлеб / Mold Bread** — старый, зелёный, живой — `trait.ailing + trait.survivor`; `background.hackflows_leper`; `background.beggar + trait.ailing`
// **Последний кусок / Last Bite** — за него режут — `trait.greedy + trait.gluttonous`; `background.beggar + trait.greedy`; `background.refugee + trait.gluttonous`
// **Сиротский суп / Orphan Soup** — жидкий, бедный, злой — `background.refugee + trait.pessimist`; `background.beggar + trait.irrational`; `cost.low + trait.pessimist`
// **Поминальный суп / Wake Soup** — после него молчат — `background.gravedigger + trait.pessimist`; `background.hackflows_cook + trait.pessimist`; `trait.fear_undead + background.hackflows_cook`
// **Волчий суп / Wolf Soup** — мечта голодного зверобоя — `trait.hate_beasts + trait.gluttonous`; `background.houndmaster + trait.gluttonous`; `background.hunter + trait.gluttonous`
// **Кровяная каша / Blood Porridge** — мешает всё красное — `background.hackflows_cook + trait.bloodthirsty`; `weapon.cleaver + trait.gluttonous`; `trait.bloodthirsty + trait.gluttonous`
// **Пьяная каша / Drunk Mash** — утром никто не помнит состав — `trait.drunkard + trait.dumb`; `background.hackflows_barkeep + trait.dumb`; `trait.drunkard + trait.clumsy`
// **Крысиный суп / Rat Soup** — еда бедняка и ловца — `background.ratcatcher + trait.gluttonous`; `background.beggar + trait.gluttonous`; `background.hackflows_cook + trait.weasel`
// **Гнилая ложка / Rot Spoon** — кормит плохо, бьёт больно — `background.hackflows_cook + trait.pessimist`; `background.servant + weapon.mace`; `trait.clumsy + weapon.mace`
**Деревянный меч / Wood Sword** — выглядит бойцом издалека — `weapon.sword + attr.MeleeSkill.low`; `background.apprentice + weapon.sword`; `cost.low + weapon.sword`
// **Ржавый меч / Rust Sword** — старый клинок, злая рука — `weapon.sword + trait.pessimist`; `weapon.sword + trait.bloodthirsty`; `background.retired_soldier + weapon.sword`
// **Вдовий меч / Widow Sword** — после него плачут дома — `weapon.sword + trait.bloodthirsty`; `background.killer_on_the_run + weapon.sword`; `perk.killing_frenzy + weapon.sword`
// **Сиротский нож / Orphan Knife** — дешёвый нож из чужой беды — `background.refugee + weapon.dagger`; `background.beggar + weapon.dagger`; `cost.low + weapon.dagger`
// **Нищий топор / Beggar Axe** — топор дороже хозяина — `background.beggar + weapon.axe`; `cost.low + weapon.axe`; `trait.greedy + weapon.axe`
// **Пьяный топор / Drunk Axe** — рубит стол, дверь и врага — `trait.drunkard + weapon.axe`; `trait.clumsy + weapon.axe`; `perk.berserk + trait.drunkard`
// **Чёрный топор / Black Axe** — уголь, кровь и рубка — `background.lumberjack + trait.pessimist`; `weapon.axe + trait.bloodthirsty`; `background.hackflows_blacksmith + weapon.axe`
// **Костяной молот / Bone Hammer** — ломает то, что уже болит — `weapon.hammer + perk.crippling_strikes`; `weapon.mace + perk.crippling_strikes`; `trait.brute + perk.crippling_strikes`
// **Свиная кувалда / Pig Maul** — жирный замах без красоты — `trait.fat + weapon.hammer`; `trait.gluttonous + weapon.mace`; `trait.brute + trait.fat`
**Мясной крюк / Meat Hook** — бывший мясник или будущий — `background.butcher + weapon.polearm`; `weapon.polearm + perk.crippling_strikes`; `trait.bloodthirsty + perk.crippling_strikes`
// **Печная лопата / Oven Peel** — кухонная палка для войны — `background.hackflows_cook + weapon.polearm`; `background.servant + weapon.polearm`; `weapon.polearm + trait.clumsy`
// **Шахтный зуб / Mine Tooth** — скала оставила память — `background.miner + perk.steel_brow`; `background.miner + trait.iron_jaw`; `weapon.hammer + trait.iron_jaw`
// **Каменный рот / Stone Mouth** — молчит, пока не плюнет кровью — `trait.iron_jaw + trait.pessimist`; `background.mason + trait.dumb`; `perk.fortified_mind + trait.dumb`
// **Мельничный пёс / Mill Dog** — таскается у муки и лает — `background.miller + trait.loyal`; `background.miller + trait.cocky`; `trait.loyal + perk.taunt`
// **Кузнечный бес / Forge Devil** — горячий, чёрный, злой — `background.hackflows_blacksmith + trait.brute`; `background.hackflows_blacksmith + trait.impatient`; `trait.brute + trait.irrational`
// **Печной бес / Oven Devil** — из кухни в драку — `background.hackflows_cook + trait.brute`; `background.hackflows_cook + trait.irrational`; `trait.gluttonous + trait.brute`
// **Кровяной лекарь / Blood Doc** — лечит тем, что режет — `background.hackflows_surgeon + trait.bloodthirsty`; `background.hackflows_surgeon + weapon.dagger`; `perk.crippling_strikes + background.hackflows_surgeon`
