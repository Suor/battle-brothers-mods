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

## Увечья и внешность

**Глухарь / Deaf Grouse** — ironic: глухарь токует громко, а этот не слышит ни хрена — `injury.missing_ear`; `injury.missing_ear + trait.dumb`
**Безрукий / Handless** — literal: нет руки, и ирония: неумеха — `injury.missing_hand`; `type.melee + attr.MeleeSkill.low + trait.clumsy`
**Беспалый / Fingerless** — ironic: мастер-лучник потерял палец — `injury.missing_finger`; `injury.missing_finger + background.hackflows_master_archer`
**Подранок / Wounded Bird** — еле тащится, но живой — `trait.bleeder`; `injury.maimed_foot + trait.survivor`
**Битый / the Beaten** — столько бит, что дальше некуда — `injury.traumatized + trait.tough`; `trait.survivor + trait.ailing`

## Оружие

**Штык / Bayonet** — колет длинным и держит дистанцию — `weapon.spear + attr.MeleeSkill.high`; `weapon.polearm + perk.reach_advantage`; `weapon.spear + trait.impatient`
**Пращник / Slinger** — literal: с пращой — `weapon.sling`
**Камушек / Pebble** — мал, а бьёт в лоб — `weapon.sling + trait.tiny`; `weapon.sling`
// **Дротик / Javelin** — бросил — и готов — `weapon.throwing`; `weapon.throwing + attr.RangedSkill.high`
**Самострел / Self-Shot** — ironic: в себя бы не пальнул — `weapon.crossbow + trait.clumsy`; `weapon.crossbow + trait.dumb`
**Залп / Volley** — гром гремит — `weapon.firearm`; `weapon.firearm + trait.brute`
**Рогатина / Boar Spear** — ходит на зверя с тяжёлым копьём — `weapon.spear + trait.hate_beasts`; `weapon.spear + background.hunter`
**Клевец / War Pick** — пробивает любую броню — `weapon.hammer + attr.MeleeSkill.high`; `weapon.hammer + perk.head_hunter`
// **Посох / Staff** — literal: ходит с посохом — `weapon.staff`; `weapon.staff + background.monk`
// **Оглушитель / Stunner** — сносит шлемы — `weapon.mace + perk.head_hunter`; `weapon.hammer + perk.head_hunter`
// **Жернов / Millstone** — стирает в муку — `weapon.hammer + trait.strong`; `background.miller + trait.strong`
**Кол / Stake** — против нежити, как полагается — `weapon.spear + trait.hate_undead`; `background.witchhunter + weapon.spear`
// **Пика / Pike** — держит строй — `weapon.polearm`; `weapon.polearm + attr.MeleeDefense.high`
**Ледоруб / Ice-Cutter** — бьёт сверху вниз — `weapon.axe + perk.head_hunter`; `weapon.axe + trait.strong`
**Меткий / Sharpshooter** — literal: бьёт в яблочко — `attr.RangedSkill.high + perk.bullseye`; `type.ranged + attr.RangedSkill.high + trait.eagle_eyes`
**Оса / Wasp** — мелкий и жалит — `weapon.dagger + trait.bloodthirsty`; `weapon.dagger + trait.cocky`; `weapon.dagger + attr.MeleeSkill.high`

## Броня и стойкость

// **Стена / Bulwark** — не сдвинешь — `perk.shield_expert + attr.Hitpoints.high`; `attr.MeleeDefense.high + trait.huge`
**Скала / the Cliff** — непоколебим — `trait.iron_jaw + attr.Hitpoints.high`; `trait.determined + trait.tough`
// **Несгибаемый / Unbending** — держит до конца — `perk.indomitable`; `perk.hold_out + trait.determined`
// **Жила / Sinew** — не устаёт, не ломается — `perk.relentless`; `perk.recover + trait.survivor`
**Призрак / Ghost** — стрелы мимо, клинки мимо — `perk.dodge + trait.dexterous`; `attr.MeleeDefense.high + attr.RangedDefense.high + trait.swift`
**Подушка / Pillow** — мнётся, но живёт — `attr.Hitpoints.high + attr.MeleeDefense.low + trait.survivor`; `attr.Hitpoints.high + trait.tough`;  `attr.Hitpoints.high + trait.fat`
**Дуб / Oak** — стоит намертво — `attr.Bravery.high + trait.tough`; `attr.Bravery.high + trait.determined`; `trait.dumb + trait.tough`; `trait.sure_footing + attr.Hitpoints.high`
**Булат / Damascus** — закалённый в бою — `perk.battle_forged + attr.Bravery.high`;  `perk.battle_forged`
**Бивень / Tusk** — торчит и не ломается — `trait.iron_jaw + trait.huge`; `trait.iron_jaw + perk.fearsome`
**Чугун / Pig-Iron** — тяжёлый, тупой, крепкий — `trait.iron_jaw + trait.dumb`; `perk.steel_brow + trait.dumb`
// **Стальная Башка / Steel Head** — голову не пробьёшь — `perk.steel_brow + trait.iron_jaw`; `perk.steel_brow + attr.Hitpoints.high`

## Перки и умения

// **Хват / Grip** — цепко, быстро перехватывает — `perk.quick_hands`; `perk.quick_hands + trait.swift`
**Чуткий / Hunch** — знает, откуда прилетит — `perk.anticipation`; `perk.anticipation + trait.paranoid`
// **Обманка / Feint** — уходит с удара — `perk.dodge`; `perk.anticipation + trait.dexterous`
**Старожил / Old-Timer** — вышел из скольких передряг — `perk.nine_lives + trait.survivor`; `background.retired_soldier + trait.tough`
**Волчара / Grey Wolf** — один и страшен — `perk.lone_wolf + trait.bloodthirsty`; `perk.lone_wolf + attr.MeleeSkill.high`
**Ураган / Hurricane** — всё сметает — `cost.high + perk.berserk + attr.MeleeSkill.high`; `cost.high + perk.killing_frenzy + perk.overwhelm`
// **Ящерица / Lizard** — скользит, не ухватишь — `perk.dodge + trait.swift`; `trait.weasel + trait.swift`

## Характер

**Лисёнок / Fox Cub** — молодой, но уже хитрит — `background.apprentice + trait.weasel`; `trait.bright + trait.weasel + trait.tiny`
**Волчонок / Wolf Cub** — молодой, а уже кусается — `background.apprentice + attr.MeleeSkill.high`; `background.apprentice + trait.bloodthirsty`; `background.squire + trait.bloodthirsty`; `background.aspirant + attr.MeleeSkill.high`
**Зубоскал / Snickerer** — лыбится и задирает — `trait.cocky + trait.impatient`; `trait.cocky + trait.bloodthirsty`
// **Сверчок / Cricket** — сидит тихо, пищит по ночам — `trait.fainthearted + trait.tiny`; `trait.fainthearted + attr.Bravery.low`
**Гусь / Goose** — важный и шумный — `trait.cocky + attr.Stamina.high`; `trait.cocky + attr.Initiative.high`
**Муха / Fly** — липнет и жужжит — `trait.cocky + trait.impatient`; `trait.tiny + trait.impatient`; `trait.tiny + attr.Initiative.high`
// **Ёж / Hedgehog** — колючий, в себе — `trait.insecure + trait.paranoid`; `trait.insecure + attr.MeleeDefense.high`
**Плут / Crook** — обведёт и оберёт — `background.thief + trait.weasel`; `background.hackflows_con_artist + trait.bright`
**Змеёныш / Snakeling** — мелкий предатель — `trait.weasel + trait.tiny`; `trait.disloyal + trait.tiny`
**Бедокур / Mischief-Maker** — беду натворит — `trait.irrational + trait.drunkard`; `background.brawler + trait.drunkard`

## Страхи и ненависть

// **Ладанка / Amulet** — прячется за оберегом — `trait.fear_undead + trait.superstitious`
// **Заячье Сердце / Hare Heart** — тварей как огня боится — `trait.fear_beasts`; `trait.fear_greenskins + attr.Bravery.low`
// **Блоха / Flea** — прыгает от страха — `trait.tiny + trait.fear_beasts`; `trait.tiny + attr.Initiative.high`
**Орколом / Orc-Breaker** — не боится зелёных — рубит — `trait.hate_greenskins + attr.MeleeSkill.high`; `trait.hate_greenskins + weapon.hammer`

## Происхождение

**Травник / Herbman** — знает травы — `background.hackflows_herbalist`; `background.hackflows_herbalist + trait.bright`
**Голубятник / Pigeon-Keeper** — по крышам как дома — `background.hackflows_roofer`
// **Соломник / Thatcher** — крыл крыши соломой — `background.hackflows_roofer + trait.sure_footing`
**Кисточка / Brush** — мелкий маляр — `background.hackflows_painter + trait.tiny`
**Маляр / Dauber** — ironic: художником себя считает — `background.hackflows_painter + trait.dumb`
// **Сеятель / Sower** — копал землю — `background.hackflows_gardener`
**Тяпка / Hoe** — привык махать тяпкой — `background.hackflows_gardener + trait.dumb`; `background.farmhand + trait.dumb`
// **Нитка / Thread** — был тощий с иглой — `background.tailor + trait.tiny`
**Игла / Needle** — ловкий, колет быстро — `background.tailor + weapon.dagger`; `background.tailor + trait.swift`; `weapon.dagger + trait.swift`
// **Наперсток / Thimble** — крепкий, но мелкий — `background.tailor`; `background.tailor + trait.fragile`
// **Ягнёнок / Lamb** — ironic: сам овец пас, сам как овца — `background.shepherd + trait.fainthearted`; `background.shepherd + attr.Hitpoints.low`
// **Рожок / Shepherd's Pipe** — дудит то там, то тут — `background.shepherd + background.minstrel`
**Ряса / Cassock** — literal: ходит в рясе — `background.monk`; `background.monk + attr.Stamina.low`
// **Келья / Cell** — всех сторонится, как в монастыре — `background.monk + trait.paranoid`
// **Постник / Faster** — тощий от поста — `background.monk + attr.Hitpoints.low`; `background.monk + trait.ailing`
// **Паперть / Churchsteps** — где всегда просил милостыню — `background.beggar + background.monk`; `background.beggar + trait.superstitious`
**Служивый / Servicer** — старой службы человек — `background.retired_soldier`; `background.retired_soldier + trait.loyal`
**Служака / Barracks Man** — казарменный до мозга костей — `group.combat + trait.loyal`; `background.retired_soldier + trait.loyal`
**Сирота / Orphan** — никого у него — `background.refugee + trait.fainthearted`; `background.vagabond + attr.Hitpoints.low`
// **Безотцовщина / Fatherless** — literal — `background.bastard`; `background.bastard + trait.cocky`
// **Молотобоец / Sledge** — работал молотом всю жизнь — `background.hackflows_blacksmith + trait.strong`
**Горн / Forge** — литой, горячий — `background.hackflows_blacksmith`; `background.hackflows_blacksmith + attr.Hitpoints.high`
// **Бинт / Bandage** — всегда с тряпками в руках — `background.hackflows_surgeon`; `background.hackflows_surgeon + trait.ailing`
// **Пила / Saw** — режет не хуже врага — `background.hackflows_surgeon + trait.bloodthirsty`; `background.hackflows_carpenter + trait.dumb`
// **Дятел / Woodpecker** — стучит, строгает — `background.hackflows_carpenter + trait.determined`
// **Новобранец / Rookie** — только взяли — `background.aspirant`; `background.militia + cost.low`
**Приблудный / Stray** — прибился к отряду — `background.refugee + trait.disloyal`; `background.deserter + trait.disloyal`
**Перекати-поле / Tumbleweed** — нигде не держится — `background.vagabond + trait.impatient`; `background.hackflows_drifter + trait.impatient`
**Креститель / Baptist** — загоняет нечисть обратно — `background.witchhunter + trait.hate_undead`; `background.witchhunter + perk.fearsome`
// **Каратель / Punisher** — чужой боли не знает — `background.witchhunter + trait.bloodthirsty`; `background.hackflows_torturer + trait.bloodthirsty`

## Сословие и цена

// **Барчук / Young Lord** — надутый, неженка — `group.noble + trait.cocky`; `group.noble + trait.fainthearted`
**Синяя Кровь / Blue Blood** — литерально — `group.noble`
// **Мужик / Muzhik** — простой, крепкий — `group.lowborn + attr.Stamina.high`; `group.lowborn + trait.tough`
**Босяк / Bareheel** — гол как сокол — `group.pauper + background.beggar`; `background.vagabond + attr.Stamina.low`
**Дорогой / Pricey** — ironic: дорого стоит, а жадный — `cost.high + trait.greedy`; `cost.high + attr.MeleeSkill.high`
// **Дешёвка / Cheapo** — дёшево и сердито — `cost.low`; `cost.low + trait.craven`
// **Копейка / Penny** — цена ему копейка — `cost.low + trait.tiny`
**Кубышка / Piggybank** — жадный и пухлый — `trait.greedy + attr.Hitpoints.high`; `trait.greedy + trait.fat`

## Звери

**Лось / Elk** — большой и выносливый — `trait.huge + attr.Stamina.high`; `trait.huge + trait.determined`
// **Тур / Aurochs** — как дикий бык, только крепче — `trait.huge + attr.Hitpoints.high`; `trait.huge + trait.tough`
// **Сом / Catfish** — огромный, вялый — `trait.huge + attr.Initiative.low`; `background.fisherman + trait.huge`
// **Щука / Pike-Fish** — рыбак, но зубастый — `background.fisherman + attr.MeleeSkill.high`; `background.fisherman + trait.bloodthirsty`
// **Коршун / Kite** — видит и бьёт сверху — `attr.RangedSkill.high + attr.Bravery.high`; `background.hackflows_master_archer + trait.eagle_eyes`

## Грубые и телесные

**Мешок / Sack** — обвис и не двигается — `trait.fat + attr.Initiative.low`; `trait.fat + trait.clumsy`
**Пузырь / Bubble** — чуть толкни — лопнет — `trait.fragile + attr.Hitpoints.low`; `trait.fainthearted + trait.fragile`
**Лепёха / Flatbread** — мягкий, плоский — `trait.fat + trait.fragile`; `trait.fat + attr.Stamina.low`
**Мямля / ...** — размяк, ни на что не годен — `trait.pessimist + trait.fainthearted`; `trait.fainthearted + trait.fragile`
// **Солонина / Salt Beef** — ironic: старое мясо, а держится — `trait.fat + trait.survivor`; `trait.fat + trait.tough`

---

# На повторный просмотр

## Предыдущая порция (односложные)

// **Хрип / Wheezer** — дышит с присвистом, а бьёт крепко — `trait.asthmatic`; `trait.asthmatic + trait.determined`
**Безносый / Noseless** — literal: нос потерял — `injury.missing_nose`; `injury.missing_nose + trait.insecure`
// **Скрипач / Fiddler** — literal: играет и пиликает — `background.minstrel + weapon.musical`; `background.minstrel + weapon.polearm`
**Хрящ / Gristle** — мелкий, но не разжуёшь — `trait.iron_jaw + trait.tiny`; `trait.tough + trait.tiny`
// **Колода / Log** — лежит, не сдвинешь — `trait.huge + attr.Initiative.low`; `attr.Hitpoints.high + attr.Initiative.low`
// **Вертун / Spinner** — крутится в свалке — `perk.rotation + trait.swift`; `perk.rotation + perk.footwork`
// **Ученик / Student** — перенимает быстро — `perk.student + trait.bright`; `background.apprentice + perk.student`
**Бирюк / Loner** — сам по себе, недоверчив — `trait.paranoid + perk.lone_wolf`; `trait.paranoid + background.hackflows_drifter`
**Баклан / Cormorant** — рыбарь, тупой и наглый — `background.fisherman + trait.cocky`; `background.fisherman + trait.dumb`
// **Репей / Burr** — прицепится, не отдерёшь — `background.ratcatcher + trait.determined`; `trait.tiny + trait.irrational`
**Плакса / Crybaby** — ноет да скулит — `trait.fainthearted + trait.craven`; `trait.fainthearted + attr.Bravery.low`
// **Икота / Hiccup** — икает да спотыкается — `trait.drunkard + trait.clumsy`; `trait.drunkard + attr.Initiative.low`
**Зевака / Gawker** — ротозей в бою — `trait.hesitant + attr.MeleeSkill.low`; `trait.hesitant + attr.Initiative.low`
**Ловец / ...** — ловит крыс, людей, зверей — `background.ratcatcher`; `background.manhunter`; `background.witchhunter`; `background.beast_slayer`
**Каменщик / Mason** — literal — `background.mason`;

## Новая порция (с характером, часто двухсложные)

### Увечья и болезни

**Битый Жбан / Cracked Pot** — пыльным мешком битый — `injury.brain_damage`; `injury.brain_damage + trait.irrational`
**Глаз Да Глаз / One-Eyed Watch** — глаза нет, а всё видит — `injury.missing_eye + perk.anticipation`; `injury.missing_eye + trait.paranoid`; `perk.anticipation + trait.paranoid`; `trait.disloyal + trait.greedy`
**Лихоманка / Fever** — трясёт, а воюет — `trait.ailing + attr.Hitpoints.low`; `trait.ailing + trait.pessimist`
// **Сердечник / Bad Ticker** — с сердцем нелады — `injury.weakened_heart`; `injury.weakened_heart + trait.fainthearted`
// **Гнилые Лёгкие / Rot-Lungs** — хрипит, как в колодце — `injury.collapsed_lung_part`; `injury.collapsed_lung_part + trait.asthmatic`
// **Ломаный Хребет / Broken Spine** — весь из заплаток — `injury.broken_knee + trait.survivor`; `injury.broken_elbow_joint + trait.survivor`
**Драная Шкура / Torn Hide** — шитый-перешитый — `trait.bleeder + perk.nine_lives`; `trait.bleeder + trait.tough`
**Живучий Кот / Tough Cat** — семижильный — `perk.nine_lives + trait.lucky`; `perk.nine_lives + perk.fast_adaption`
// **Ходячий Мертвец / Walking Dead** — в глине, а дышит — `trait.ailing + perk.nine_lives`; `injury.collapsed_lung_part + trait.survivor`
// **Плохая Память / Bad Memory** — вчера забыл, сегодня забудет — `injury.traumatized + trait.hesitant`; `injury.traumatized + trait.irrational`
**Хромой Чёрт / Limping Devil** — хромает, а злющий — `trait.clubfooted + trait.bloodthirsty`; `trait.clubfooted + trait.determined`

### Оружие

**Верный Клинок / True Blade** — с мечом на «ты» — `weapon.sword + attr.MeleeSkill.high`; `weapon.sword + perk.duelist`; + some loyal combo
// **Кривой Нож / Crooked Knife** — ножом тыкает криво — `weapon.dagger + trait.clumsy`; `weapon.dagger + attr.MeleeSkill.low`
// **Тяжёлая Рука / Heavy Hand** — бьёт как молотом — `trait.strong + weapon.hammer`; `trait.strong + weapon.mace`
**Лёгкая Рука / Light Hand** — режет, не касаясь — `trait.dexterous + weapon.dagger`; `type.melee + attr.MeleeSkill.high + trait.swift`; `type.melee + attr.MeleeSkill.high + attr.Initiative.high`
// **Горсть Стрел / Fist of Arrows** — стрелы сыпет горстями — `perk.quick_hands + type.ranged`; `perk.quick_hands + attr.RangedSkill.high`
// **Зубастый Топор / Jagged Axe** — лезвие в зазубринах — `weapon.axe + perk.crippling_strikes`; `weapon.axe + trait.bloodthirsty`
// **Тихая Стрела / Silent Arrow** — прилетит — не услышишь — `weapon.bow + perk.backstabber`; `weapon.bow + background.poacher`
// **Скорый Нож / Quick Knife** — выдёргивает первым — `perk.quick_hands + weapon.dagger`; `weapon.dagger + attr.Initiative.high`
**Дубовая Стрела / Oaken Arrow** — стрелу тащит, как полено — `weapon.bow + trait.dumb`; `weapon.bow + attr.RangedSkill.low`
// **Мясник Без Рук / Butcher-No-Hands** — мясник, а рубит бестолково — `background.butcher + attr.MeleeSkill.low`; `background.butcher + trait.clumsy`
**Три Руки / Three Hands** — и там, и тут, и поспел — `perk.quick_hands + trait.swift`; `perk.quick_hands + trait.dexterous`; `perk.quick_hands + attr.MeleeSkill.high`

### Броня и стойкость

// **Кожаный Мех / Leather Sack** — пей не пей, а не лопнет — `attr.Hitpoints.high + trait.tough`; `perk.brawny + trait.tough`
**Медная Шкура / Copper Hide** — сам в шкуре, как в котле — `perk.battle_forged + attr.Stamina.high`; `perk.battle_forged + perk.colossus`
// **Чёрный Шлем / Black Helmet** — в глухом шлеме и глух к боли — `perk.shield_expert + attr.MeleeDefense.high`; `perk.steel_brow + attr.MeleeDefense.high`
// **Медведь в Броне / Armored Bear** — громадина в железе — `trait.huge + perk.battle_forged`; `trait.huge + perk.colossus`
// **Сухой Крепыш / Dry Tough** — тощ, а держится — `trait.tough + trait.fragile`; `trait.tough + attr.Hitpoints.low`
**Бычья Шея / Ox Neck** — шею не свернёшь — `trait.strong + perk.steel_brow`; `trait.huge + perk.steel_brow`
// **Косая Сажень / Broad Shoulder** — в плечах как дверь — `trait.huge + attr.MeleeSkill.high`; `trait.huge + trait.strong + perk.brawny`

### Перки и сноровка

**Лёгкие Ноги / Light Foot** — пляшет по полю — `perk.footwork + trait.swift`; `perk.pathfinder + trait.swift`
// **Медвежья Хватка / Bear Grip** — схватил — не вырвешься — `trait.strong + perk.crippling_strikes`; `perk.footwork + trait.strong`
**Вторая Кожа / Second Skin** — в броне как в рубахе — `perk.nimble + trait.dexterous`; `perk.nimble + trait.swift`; `perk.nimble + attr.Initiative.high`
// **Две Ладони / Two Palms** — успевает и там и тут — `perk.quick_hands + perk.footwork`; `perk.rotation + perk.quick_hands`
// **Пустая Голова / Empty Head** — ничего не держит в башке — `perk.fortified_mind + trait.dumb`; `trait.dumb + attr.Bravery.high`
**Кошачья Лапа / Cat Paw** — мягко ступает, бьёт больно — `perk.footwork + trait.dexterous`; `trait.dexterous + attr.MeleeSkill.high`
**Медная Глотка / Brass Throat** — орёт — аж уши вянут — `perk.rally_the_troops + attr.Stamina.high`; `perk.rally_the_troops + attr.Bravery.high`

### Характер — благородный

// **Чистое Золото / Pure Gold** — чем тяжелее, тем дороже — `cost.high + trait.bright`; `cost.high + trait.loyal`
// **Каменное Сердце / Stone Heart** — не дрогнет — `attr.Bravery.high + trait.fearless`; `attr.Bravery.high + trait.iron_jaw`
// **Крутой Нрав / Hard Temper** — с ним не шути — `trait.bloodthirsty + trait.determined`; `trait.fearless + trait.determined`
**Старый Волк / Old Wolf** — сам ходит, сам и добудет — `perk.lone_wolf + background.retired_soldier`; `perk.lone_wolf + trait.survivor`
// **Живой Флаг / Live Banner** — за ним идут — `perk.rally_the_troops + attr.Bravery.high`; `perk.rally_the_troops + trait.loyal`
// **Соль Земли / Salt of the Earth** — из земли и за землю — `group.lowborn + trait.loyal`; `background.farmhand + trait.loyal`
// **Тёртый Калач / Well-Baked** — битый, мятый, везде был — `trait.survivor + background.retired_soldier`; `trait.survivor + background.hackflows_drifter`
// **Малый Да Удалый / Small but Mean** — мал, а лезет первым — `trait.tiny + attr.Bravery.high`; `trait.tiny + trait.fearless`

### Характер — трусость, слабость

**Мокрая Курица / Wet Hen** — и дождь ему — беда — `trait.craven + trait.fainthearted`; `trait.craven + attr.Stamina.low`
// **Божий Одуванчик / God's Dandelion** — дунь — и нет его — `trait.fragile + background.retired_soldier`; `trait.fragile + trait.ailing`
// **Тюха-Матюха / Bumpkin** — неуклюжий дурень — `trait.dumb + trait.clumsy`; `trait.dumb + attr.Initiative.low`
**Коленки / Shaky Knees** — ноги подгибаются — `trait.craven + attr.Bravery.low`; `trait.fainthearted + attr.Initiative.low`
**Кислый Хрен / Sour Horseradish** — с утра недоволен — `trait.pessimist + trait.hesitant`; `trait.pessimist + attr.Bravery.low`
**Тихий Омут / Quiet Pool** — сам молчит, клинок говорит — `trait.pessimist + attr.MeleeSkill.high`; `perk.fortified_mind + attr.MeleeSkill.high`
// **Худое Знамя / Lean Banner** — ведёт, а сам еле тащится — `perk.rally_the_troops + attr.Hitpoints.low`; `perk.rally_the_troops + trait.fainthearted`

### Характер — наглый, вредный

// **Жадный Рот / Greedy Mouth** — на еду и на мзду — `trait.greedy + trait.gluttonous`; `trait.greedy + trait.fat`
**Дурной Глаз / Evil Eye** — куда глянет, там беда — `trait.superstitious + trait.paranoid`; `trait.superstitious + trait.irrational`
// **Крапивное Семя / Nettle Seed** — жжёт с первого слова — `trait.irrational + trait.impatient`; `trait.irrational + trait.bloodthirsty`
// **Белая Ворона / White Crow** — среди своих чужой — `background.hackflows_outlander + trait.insecure`; `background.hackflows_dissenter + trait.disloyal`
**Бешеный Пёс / Mad Dog** — кого укусит — не его забота — `trait.bloodthirsty + trait.irrational`; `trait.bloodthirsty + perk.berserk`
// **Чёрное Сердце / Black Heart** — чужой боли не ведает — `trait.bloodthirsty + trait.pessimist`; `trait.bloodthirsty + perk.fearsome`
**Гнилой Зуб / Rotten Tooth** — дышит на ладан, а кусает — `trait.ailing + trait.pessimist`; `trait.ailing + trait.drunkard`
// **Пустая Бочка / Empty Barrel** — гремит громче всех — `trait.fat + trait.dumb`; `trait.fat + trait.cocky`
// **Тухлый Кот / Stale Cat** — пьёт, хромает, но идёт — `trait.drunkard + trait.ailing`; `trait.drunkard + attr.Stamina.low`
// **Гнилой Язык / Rotten Tongue** — за словом в карман не полезет — `trait.disloyal + trait.pessimist`; `trait.disloyal + trait.fainthearted`
**Сорняк / Weed** — сколько ни руби — лезет — `trait.survivor + trait.disloyal`; `trait.survivor + trait.pessimist`

### Страхи и ненависть

// **Молот Ведьм / Witch Hammer** — бьёт по оберегам — `background.witchhunter + weapon.hammer`; `background.witchhunter + trait.irrational`
// **Звериный Страх / Beast Fear** — при виде шерсти дрожит — `trait.fear_beasts + trait.fainthearted`; `trait.fear_beasts + attr.Bravery.low`
// **Зелёный Ужас / Green Dread** — зелёных как огня — `trait.fear_greenskins + trait.fainthearted`; `trait.fear_greenskins + attr.Bravery.low`
// **Лунный Брат / Moon Brother** — при луне оживает — `trait.night_owl + trait.pessimist`; `trait.night_owl + background.monk`
// **Тёмный Час / Dark Hour** — во тьме как дома — `trait.night_owl + trait.paranoid`; `trait.night_owl + trait.superstitious`
// **Мёртвая Башка / Dead Head** — черепа мерещатся — `trait.hate_undead + perk.fearsome`; `background.graverobber + perk.fearsome`
**Гробовщик / Undertaker** — ... — `background.gravedigger`


### Происхождение и работа

**Старый Монах / Old Monk** — годы в монастыре — `background.monk + trait.survivor`; `background.monk + attr.Bravery.high`
// **Свечной Огарок / Candle Stub** — тощий, на ладан дышит — `background.monk + trait.tiny`; `background.monk + trait.fragile`
// **Ржавый Гвоздь / Rusty Nail** — старый, гнутый, но держит — `background.retired_soldier + trait.ailing`; `background.retired_soldier + attr.Hitpoints.low`
// **Грозный Дед / Dread Grandpa** — стариком ещё настращает — `background.retired_soldier + perk.fearsome`; `background.retired_soldier + attr.Bravery.high`
// **Рыбий Глаз / Fish Eye** — глаз у рыбака наметан — `background.fisherman + perk.bullseye`; `background.fisherman + trait.eagle_eyes`
**Лесной Волк / Forest Wolf** — один в глуши — `background.wildman + perk.lone_wolf`; `background.wildman + trait.bloodthirsty`
**Дикий Пёс / Wild Dog** — не приручишь — `background.wildman + trait.fearless`; `background.wildman + trait.brute`
// **Поганый Пёс / Dirty Dog** — побирушка да прохвост — `background.beggar + trait.disloyal`; `background.beggar + trait.weasel`
// **Чёрный Псарь / Houndsman** — псов травил, людей пустит — `background.houndmaster + trait.bloodthirsty`; `background.houndmaster + trait.hate_greenskins`
// **Хозяин Собак / Dog-Master** — за спиной свора — `background.houndmaster`; `background.houndmaster + trait.teamplayer`
// **Гроза Лесов / Forest Scourge** — олень и тот боится — `background.poacher + attr.RangedSkill.high`; `background.poacher + trait.hate_beasts`
**Шкурник / Pelter** — шкуры снимает да барыжит — `background.poacher + trait.greedy`; `background.poacher + weapon.bow`
// **Медвежье Ухо / Bear Ear** — в лесу слышит всё — `background.hunter + trait.eagle_eyes`; `background.hunter + trait.hate_beasts`
// **Угольный Чёрт / Coal Devil** — весь в саже, с кайлом — `background.miner + trait.ailing`; `background.miner + attr.Hitpoints.low`
// **Кротовая Нора / Molehole** — в темноте дома — `background.miner + trait.short_sighted`; `background.miner + trait.night_blind`
**Конокрад / Horse Thief** — ноги сами уносят — `background.thief + attr.Initiative.high`; `background.thief + trait.swift`
**Серая Мышь / Grey Mouse** — тих, но не пропадёт — `background.servant + trait.tiny`; `background.hackflows_cobbler + trait.tiny`
**Лавочник / Shopkeep** — счёт ведёт всему — `background.peddler + trait.greedy`; `background.peddler + trait.fat`
// **Уличный Пёс / Street Dog** — по кулакам выросший — `background.brawler + trait.disloyal`; `background.brawler + trait.bloodthirsty`
**Голый Зад / Bare Arse** — штаны — и те чужие — `group.pauper + attr.Stamina.low`; `background.beggar`
// **Могильный Ветер / Grave Wind** — несёт от него сыростью — `background.gravedigger + trait.superstitious`; `background.gravedigger + trait.paranoid`
// **Вол в Упряжке / Yoked Ox** — тянет и не ропщет — `trait.strong + trait.loyal`; `trait.huge + trait.loyal`

### Звери-метафоры

**Жирный Боров / Fat Hog** — сало да кулаки — `trait.gluttonous + trait.fat`; `trait.fat + trait.strong`
// **Вольный Ястреб / Free Hawk** — сам себе хозяин — `background.hackflows_master_archer + attr.RangedSkill.high`; `background.hackflows_master_archer + trait.bright`
// **Травяная Гадюка / Grass Adder** — зелья да ножик — `background.hackflows_herbalist + weapon.dagger`; `background.hackflows_herbalist + trait.weasel`
**Сон-трава / Sleep-Herb** — ни во что не верит — `background.hackflows_herbalist + trait.pessimist`; `trait.pessimist + attr.Initiative.low`
// **Беличий Хвост / Squirrel Tail** — вьётся и жмёт — `trait.weasel + trait.dexterous`; `trait.weasel + trait.swift`
// **Змеиный Глаз / Snake Eye** — хитёр да зорок — `trait.weasel + attr.RangedSkill.high`; `trait.weasel + trait.eagle_eyes`

### Грубые и телесные

// **Вялая Вошь / Limp Louse** — мелкая, вялая — `trait.tiny + trait.fragile`; `trait.tiny + attr.Stamina.low`
**Сухой Сучок / Dry Twig** — треснет под ногой — `trait.fragile + attr.Stamina.low`; `trait.fragile + trait.ailing`
**Толстый Каравай / Fat Loaf** — мягок, но сытен — `trait.fat + trait.gluttonous`; `trait.fat + attr.Hitpoints.high`
// **Сырое Мясо / Raw Meat** — только с кухни — `background.aspirant + attr.MeleeSkill.low`; `cost.low + attr.MeleeSkill.low`
// **Пустой Мешок / Empty Sack** — ни денег, ни силы — `cost.low + trait.craven`; `cost.low + attr.Hitpoints.low`
**Тупой Кол / Dull Stake** — тупее не бывает — `trait.dumb + trait.determined`; `trait.dumb + trait.loyal`
**Пень С Глазами / Stump-with-Eyes** — встал да смотрит — `attr.Initiative.low + trait.dumb`; `trait.huge + trait.dumb`; `trait.dumb + trait.eagle_eyes`
// **Пустой Кулак / Empty Fist** — силён руками, да ничего нет — `group.pauper + trait.impatient`; `group.pauper + attr.Stamina.low`
**Золотые Руки / Golden Hands** — хоть клинок, хоть жбан — `background.tailor + attr.MeleeSkill.high`; `background.hackflows_blacksmith + attr.MeleeSkill.high`
// **Волчий Глаз / Wolf Eye** — в темноте видит — `perk.lone_wolf + trait.eagle_eyes`; `background.hunter + trait.night_owl`
// **Битый Медяк / Battered Penny** — дешёв, а ходит — `cost.low + trait.survivor`; `cost.low + trait.tough`
**Лошадиная Сила / Horse Power** — выносит всё — `attr.Stamina.high + attr.Hitpoints.high`; `trait.iron_lungs + attr.Stamina.high`
// **Тяжёлый Сон / Heavy Sleep** — спит крепко, думает медленно — `attr.Initiative.low + trait.fainthearted`; `attr.Initiative.low + trait.dumb`

