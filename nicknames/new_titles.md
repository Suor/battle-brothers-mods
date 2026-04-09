# Новые прозвища — черновик для ревью

Стиль, факторы и уже добавленные прозвища — в `nicknames/titles.nut`.
Прозвища, уже существующие в игре — в `built-in.nut`.
Разъяснения смысла факторов — комментарии EXPLAINED в `titles.nut`.
Сюда добавляем только новые, не повторяя ни то, ни другое.

## Что работает

- **Короткое конкретное существительное** — 1–2 слова, знакомые всем.
  Хорошо: Мул, Козёл, Гарпун, Крюк. Плохо: Дружинник, Ланцет, Завсегдатай.
- **Двойной смысл** — буквальное происхождение (фон/фактор) + боевая метафора.
  Хорошо: Гарпун (рыбак с копьём — одно и то же), Наковальня (берёт удары).
- **Животное с очевидной характеристикой** в народной речи.
  Хорошо: Рысь, Мул, Козёл, Жаба, Сорока. Плохо: Богомол, Выдра, Куница, Аист — слабо.
- **Ирония** — если есть, должна быть сразу понятна игроку (как с Малышом).

## Что не работает

- **Прилагательные вместо существительных** — Желчный, Упёртый, Угрюмый, Дутый — слишком описательно, не цепляет.
- **Поэтические/литературные образы** — Зарница, Буревестник, Ртуть, Соломинка — не язык лагерного костра.
- **Слова-действия или концепции** — Засада, Острие — описывают тактику, а не человека.
- **Книжные слова** — Ворог, Скрытень — не в ходу у наёмников.
- **Переименование фона своими словами** — Дружинник, Ополченец, Сиделец — не добавляют смысла.
- **Слишком умные/специфические** — Ланцет, Богомол — для простых мужиков не так работает.

## Ошибки с факторами

- `trait.brute` — агрессивный, бьёт в голову с плеча, грубая сила без тактики. **НЕ** значит "физически сильный" или "мощный удар". Не использовать там, где нужна просто сила.
- `background.hackflows_skirmisher` — лёгкий боец, не разведчик/дозорный. Для дозора — `background.hackflows_town_watchman`.

## Отвергнуты как неинтересные

Богомол, Выдра, Куница, Аист, Острие, Пест, Засада, Кистень, Желчный, Упёртый, Головня, Дутый,
Угрюмый, Дрёма, Соломинка, Семь бед, Чёрный день, Буревестник, Зарница, Ртуть, Сквозняк, Порох,
Скрытень, Мякина, Разгильдяй, Свалка, Ворог, Сиделец, Ланцет, Ополченец, Завсегдатай, Дружинник

Формат: **Прозвище** — кому давать свободным текстом — `факторы`

---

## Животные

1. **Шершень** — мелкий боец, злобный и агрессивный не по размеру, лезет на всех — `trait.tiny + trait.brute`; `trait.tiny + trait.impatient`

2. **Рысь** — быстрый хищник, бьёт точно и неожиданно — `trait.swift + attr.Initiative.high`; `trait.eagle_eyes + attr.Initiative.high`

3. **Мул** — упрямый и выносливый, попробуй сдвинь с места — `trait.determined + attr.Stamina.high`; `attr.Stamina.high + trait.tough`

4. **Соколик** — налетает, бьёт точно и отходит; или буквально сокольничий — `background.hackflows_falconer`; `weapon.Bow + attr.RangedSkill.high + attr.Initiative.high` + eagle_eyes and their combo 

5. **Хорёк** — юркий и вёрткий пройдоха, нос везде сунет — `trait.tiny + trait.weasel`; `background.thief + trait.dexterous` + simply weasel

7. **Козёл** — упрямый, лезет куда не звали, бьёт лбом — `trait.determined + trait.impatient`; `trait.determined + trait.cocky`

8. **Жаба** — толстый и медленный, сидит тихо и ждёт своего; ироничн.: вечно дёргается, а с места не двинется — `trait.fat + attr.Initiative.low`; `trait.paranoid + attr.Initiative.low`

12. **Сорока** — тащит всё, что плохо лежит, и где что лежит — помнит — `trait.greedy`; `trait.greedy + perk.bags_and_belts`; `background.graverobber + trait.bright`

13. **Бобёр** — грызёт методично и упрямо, пока не перегрызёт — `background.lumberjack + trait.determined``background.hackflows_carpenter + trait.determined`

---

## Боевые

14. **Гарпун** — бывший рыбак; копьё в его руках — то же, что гарпун в море — `background.fisherman`; `background.fisherman + weapon.Spear`, `background.fisherman + perk.mastery.spear`, `background.fisherman + perk.mastery.throwing`

15. **Наковальня** — принимает удары и не гнётся, другим бить больно — `trait.iron_jaw`;`trait.iron_jaw + attr.Hitpoints.high`; `perk.steel_brow + trait.tough`

16. **Заноза** — мелкий, но постоянно достаёт; не смертелен, зато раздражает — `trait.tiny + trait.impatient`; `weapon.Dagger + attr.MeleeSkill.high`

17. **Затычка** — встал в дыру в строю и держит, никто не пройдёт — `perk.shield_expert + attr.MeleeDefense.high`; `attr.Hitpoints.high + attr.MeleeDefense.high`

18. **Кремень** — твёрдый, и искры летят при ударе — `trait.determined + trait.tough`; `trait.iron_jaw + trait.tough` -- NEED better factors

22. **Молотило** — flail weapon or mastery, and think of something else

23. **Карусель** — AOE two-handed flail or Axe also Шут

24. **Дробина** — мелкий, но удар крепкий и неожиданный, как дробь — `trait.tiny + attr.MeleeSkill.high`; `trait.tiny + trait.strong`

25. **Щепка** — острая и маленькая; не видишь, пока не воткнулась — `trait.tiny + weapon.Dagger`; 

26. **Зубодробитель** — лупит в морду так, что зубы летят — `weapon.Hammer + trait.brute + perk.head_hunter`; `weapon.Mace + trait.brute`

---

## Характер

29. **Правдоруб** — режет правду напрямую, без дипломатии и оглядки — `trait.brute + trait.bright`; `trait.cocky + trait.bright` -- dissenter, brute doesn't make sense as usual

33. **Гнилой** — прогнил изнутри; не доверяй спине — `trait.disloyal + trait.greedy`; `background.deserter + trait.disloyal`

34. **Нелюдь** — определён тем, кого ненавидит; ироничн.: с людьми ладит не намного лучше — `trait.hate_greenskins`; `trait.hate_undead + trait.hate_greenskins`; `trait.hate_beasts + trait.hate_greenskins`

36. **Мудрила** — умный, но умеет это показать так, что все раздражаются — `trait.bright + trait.cocky`; `perk.student + trait.cocky`

38. **Дрёма** — медленный и сонный; ироничн.: ночная птица засыпает на посту — `attr.Initiative.low + attr.Stamina.low`; `attr.Initiative.low + trait.night_owl` -- идея норм, само прозвище не очень. Лучше - Соня, Тюлень (но можно факторы подобрать поточнее)

39. **Заводила** — разжигает драки и тянет других за собой — `trait.impatient + perk.rally_the_troops`; `trait.cocky + perk.taunt`

41. **Дурной** — непредсказуемый; не понять чего ждать, и он сам не знает — `trait.irrational`; `trait.irrational + trait.brave`

---

## Судьба

42. **Беда** — несчастье для врагов; и для своих порой тоже — `trait.bloodthirsty + attr.MeleeSkill.high`; `perk.fearsome` -- more factors for "и для своих порой тоже"

---

## Разное / абстрактные

51. **Гром** — бьёт как гром: без предупреждения и больно — `weapon.Hammer + attr.MeleeSkill.high`; `trait.brute + attr.MeleeSkill.high` (в отличие от Молота — не оружие, а эффект) -- better factors, maybe cost.high too

52. **Сквозняк** — проходит незаметно, не ухватишь — `trait.weasel + trait.night_owl`; `background.thief + attr.Initiative.high + trait.dexterous` -- скучно, но можно попробовать Ветерок, с несколько другими факторами

54. **Волкодав** — натаскан на тварей, знает как с ними — `trait.hate_beasts + attr.MeleeSkill.high`; `background.houndmaster + trait.hate_beasts`

56. **Крюк** — цепляется и не отпускает — `perk.crippling_strikes`; `background.hackflows_hangman` (петля-крюк — один инструмент) -- cool name, can think about more factors

58. **Золотой** — дорого стоит, и все об этом знают; ироничн.: а толку — `cost.high + attr.MeleeSkill.high`; `cost.high + attr.Bravery.high`

60. **Болячка** — всегда что-то болит, всегда жалуется — `trait.ailing`; `trait.ailing + trait.pessimist` -- можно поробовать найти название поинтереснее

---

## Профессии / происхождение

65. **Дозорный** — первым замечает беду, пока другие спят — `background.hackflows_skirmisher + trait.eagle_eyes`; `background.hackflows_skirmisher + attr.Initiative.high` -- skirmisher is not about that, this is more about town_watchman

67. **Колдун** — шепчет что-то непонятное, и от этого неуютно — `background.hackflows_druid`; `background.cultist`; `background.hackflows_herbalist`

70. **Дед** — старый, дешёвый, но умудрённый; ироничн.: лет много, а всё воюет — `background.retired_soldier`; `background.retired_soldier + cost.low` -- add stamina low factor

---

## Прочие

78. **Самосуд** — вершит правосудие сам, без суда и следствия — `background.witchhunter + trait.bloodthirsty`; `background.killer_on_the_run`
