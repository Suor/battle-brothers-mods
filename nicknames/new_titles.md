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

**Латник / Ironclad** — закован в железо, отскакивает урон — `perk.battle_forged + attr.MeleeDefense.high`; `perk.battle_forged + trait.tough`; `perk.battle_forged + background.hedge_knight`
**Доброе Железо / Goodblade** — оружие надёжное, как сам — `weapon.sword + attr.MeleeSkill.high`; `weapon.sword + perk.duelist`; `weapon.axe + attr.MeleeSkill.high + trait.determined`

**Кузнечик / Quickstep** — мелкий, скачет, нигде не задерживается — `background.hackflows_skirmisher + trait.swift`; `trait.tiny + perk.footwork`; `trait.swift + trait.dexterous`
**Скороход / Longstride** — длинноногий, шагает за двоих — `trait.huge + background.hunter`; `trait.huge + background.messenger`; `trait.huge + trait.athletic`
**Лоб / Hardhead** — лбом удары держит, упрямый — `trait.iron_jaw + trait.determined`; `perk.steel_brow + trait.brute`; `perk.steel_brow + trait.determined`
**Барин / Proudfoot** — корчит из себя благородного, ходит вразвалку — `trait.cocky + background.disowned_noble`; `background.disowned_noble + group.combat`; `trait.cocky + group.noble`

**Волчий Глаз / Wolfeye** — видит ночью, бьёт без жалости — `trait.night_owl + trait.bloodthirsty`; `trait.night_owl + background.killer_on_the_run`; `trait.night_owl + background.hackflows_town_watchman`
**Бугай / Bullneck** — кряжистый, толстошеий, в строю не сдвинуть — `trait.strong + trait.huge`; `trait.strong + perk.steel_brow`; `background.hackflows_bodyguard + trait.strong`
**Хряк / Boarhead** — прёт буром, шлемом сшибает щиты — `trait.brute + trait.huge`; `trait.brute + perk.berserk`; `background.wildman + trait.brute`

**Благодетель / Godsend** — иронично: «спас» город — и обчистил — `trait.bloodthirsty + background.sellsword`; `trait.greedy + background.sellsword`; `trait.bloodthirsty + background.hedge_knight`
**Миротворец / Makepeace** — иронично: миром не умеет, только железом — `trait.bloodthirsty + weapon.hammer`; `trait.bloodthirsty + trait.brute`; `trait.brute + attr.MeleeSkill.high`
**Дружок / Goodfriend** — иронично: «друг», пока золото платят — `trait.disloyal + trait.greedy`; `background.hackflows_con_artist + trait.disloyal`; `trait.greedy + background.sellsword`
