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

* Ironclad: Given to a heavily armored mercenary who survives a ridiculous amount of damage.
* Goodblade: For a soldier known for a highly reliable, high-quality weapon.

* Quickstep: A common descriptor for an agile skirmisher, scout, or a fast-moving duelist.
* Longstride: For an exceptionally tall mercenary or a scout who covers terrain quickly.
* Hardhead: For a brute known for taking a blow to the face without backing down, or an incredibly stubborn veteran.
* Proudfoot: A real historical medieval surname used for someone who walked with an arrogant, swaggering gait. [2]

* Wolfeye: Implies a highly alert night-scout or a cold-blooded killer.
* Bullneck: A rugged, single-word description for a thick-set, muscular infantryman.
* Boarhead: Perfect for a savage, reckless charger who breaks enemy shield walls.

* Godsend: Often used ironically for a completely brutal, ungodly mercenary who saves a town only to loot it.
* Makepeace: An ironic name for a mercenary whose only method of solving conflicts is violence.
* Goodfriend: A real medieval compound name, often used mockingly for a mercenary who is only loyal to his comrades as long as the gold holds out.
