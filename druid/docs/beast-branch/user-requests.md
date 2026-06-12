# Beast Branch — запросы пользователя (verbatim)

Append-only. Дословные формулировки из обсуждения; правим только опечатки.

## Исходный запрос

> Add a "Beast" branch to druid's perks. I.e. on level 3 you take one of "Regrowth"
> or "Beastform", the second one becomes inaccessible. This makes you choose Supporter
> vs Fighter role.
>
> Entangle, Hatch and Apex Predators should probably become only accessible to Supporter.
> Maybe drop venom (but not sure), maybe just make a better icon and find some place.
>
> Beastform should give some physical advantages and some limitations, say cannot use
> shields (suggestions are welcome). Then later on should get a perk giving rage, like
> Orc Berserkers have or Barbarian perk from Reforged — not sure we need melee defense
> reduction though (may debate), damage resistance probably replace with regeneration.
> Maybe more perks on this path.

## Уточнения (порядок реплик)

1. Плохие ролы — не проблема дизайна: «if you have bad attributes or talents... then
   simply don't use beastform».
2. Базовый призыв общий для обеих веток: «the initial summon I never intended to go».
3. Яд ослабляющий, не уроновый: «we have weakening poison, not damaging, so not an issue»;
   позже — «Venom makes all of them poisonous, this is not damaging but debuff poison,
   which doesn't stack».

4. **Beastform — пассивное превращение:** «you turn one-time — then cannot use shields and
   helms heavier than 10 and armors heavier than 20 and ranged weapons but get some bonuses».
   Двухфазный режим тоже интересен, «might link it with rage».

5. **Rage отдельным перком:** «Rage is a separate perk, which gives you bonuses as it stacks
   up, but you loose def — same as barbarian Rage in Reforged, and on some threshold level
   you drop shield right in battle». Эмерджентный выбор: all-in без щита → двуручка, либо щит
   на старте (от стрел) → одноручка/dual-wield. «if you roll bad on defense you might just
   not take Beast Rage perk». Позже: «обычно в Rage дебаффы накапливаются постепенно вместе
   с баффами, т.е. на старте пока ярости особо нету, и дебаффов нет».

6. **Графика:** гуманоид-зверь, не животное. «Fantasy Bros might have some graphics, they
   have lizardmen for example. Or may generate». Превращение «either one-time — then it's seen
   more, or on rage threshold, which is also fun, can add some roar sound, also useful from UX
   perspective».

7. **Отвергнутые перки:** Barkskin — «already have regen in rage»; Thick Hide — «might become
   "always take" thing»; Rend / Scent of Blood — «feels like adding for volume»; Pounce —
   «just no»; Feral Senses — «boring, just a stat boost»; Howl — «not a fighter thing really».

8. **Принцип:** «more perks are not better but worse, i.e. if you have 10 druid perks and they
   synergize then you take them all, so there will be only one druid build — this is partially
   the issue with necro, and this is one of the reasons I want druid perks be split».

9. **Pack Leader:** «Maybe drop pack_leader, what do you think? But supporter having more custom
   perks — less need for normal combat perks makes sense».

10. **Beast Aura (идея пользователя):** в Beastform призванные звери не убегают, держатся рядом
    как телохранители, рашат вместе с тобой; «+1 accessory dog/companion». Перк: «Beast Aura —
    all beasts (not only yours) close to you (say within 2 tiles) get some bonuses, morale,
    whatever — taking the perk changes your beasts behavior, but bonus applies to any ally beast,
    say AC unleashed by other bro». Позже: аура «сама накладывает ограничение — зверей больше
    нельзя использовать для преследования, они тусуются с тобой»; для бойца «можно полностью
    забить на призывы — оставить стартовый суммон для ситуативных преимуществ — создать
    окружение, или поставить зверя так, чтобы на него сротироваться и сбежать».

11. **Venom — финальная позиция:** держать отдельным и адаптивным, два значения — это нормально:
    «не вижу ничего плохого в этом. Вливать в Apex — это усложнение». Под-стиль supporter-не-
    призыватель: «такому можно пропустить hatch и apex, а venom можно взять или нет (особенно
    если он будет работать на выпускаемого из слота зверя)». Ранее рассматривались варианты:
    не давать Venom бойцу (3 перка хватит); либо «make Venom and Beast Rage mutually exclusive,
    i.e. rage vs cunning warrior»; либо Venom только на себя, как Overwhelm, берётся независимо.

12. **Скейлинг зверей:** «Direwolf для старта — сильновато. Самое простое — скейлить
    характеристики зверей с уровнем, может накидывать им каких-то перков на порогах. Ещё
    вариант — начинаешь с волком, который Wolf, а не Direwolf. Переключать на всё разнообразие
    на каком-то уровне, например пятом (это четвёртый тир перков, там где Hatch)».

13. Оформить всё в стиле `/forge-plan`.

14. **Размещение по тирам — позже, скопом:** «Let's decide this later, all supporter perks
    together, then all beastform together».

15. **Бонусы Beastform:** «Of cause beastform will get bonuses. Let's say +10% melee skill
    and defense, +20% HP and regeneration of 10 HP per turn».

16. **Реген — в Rage, не в Beastform:** «ok, let's make Beastform not give regen, and Beast
    Rage be the same as perk_rf_feral_rage but damage reduction is replaced with 2 HP regen
    per turn per stack, also give +1 stack for missing enemy».

17. **Ранний Venom + выбор Fighter** (выбор из вариантов): «Переключается, Rage блок» —
    Venom меняет значение на fighter-вариант, Beast Rage блокируется; ранний Venom =
    неявный предвыбор «хитрого бойца».

18. **Графика — гуманоид, не животное:** «No, those are animals, and our guy should be
    humanoid, i.e. like some adventurer backgrounds from Fantasy Bros - there are orcs and
    elves». На показанный композит Baku: «Да, Baku как есть» — реюз тела 7873/7874 +
    голов 7880–7882 (+ гривы hair_beast).

19. **Пересмотр развилки:** «I am thinking is it correct to set Regrowth against Beastform,
    i.e. maybe you want to be a summoner and don't care about regrowth that much? But isn't
    Hatch and auto-pick if you not go Beast? Some maybe swap Regrowth and Hatch. Or do not
    swap, just become supporter when you peak any supporter only perk? Beast Aura and Beast
    Rage still be gated by Beastform». На предложенный вариант неявного выбора: «ok, let's
    do this».

20. **Совместимость:** «Implementation detail - we want to support vanilla too, i.e. no
    Reforged, no Dynamic Perks. Same as necro».

21. **Размещение.** Supporter (выбор из вариантов): «Entangle → Row 4» — Regrowth Row 1,
    Hatch Row 3, Entangle Row 4, Apex Row 6. Про нумерацию: «It's confusing how you count
    rows, you say Row 1, but actually this means second row, because they start from 0.
    So it's not number but index in array». Beast Rage: «Rage I supposed to be on last row,
    why do you suggest placing it tha early?»

22. **Скейлинг призыва — уточнение:** на «начинать с Wolf, а не Direwolf» — «this is
    confusing, I meant all the options are locked until you grow to that level, you always
    get a basic wolf».

23. **Venom — позже; пересбор Fighter-рядов:** «Venom that early is a mistake now, need to
    move it later. But tier 7 Venom doesn't make sense, it's not strong enough. I was
    thinking of swapping tiers of aura and rage, but then aura also - is it string enough
    for tier 7? Venom and Rage on same tier as a direct choice also looks nice». После
    разбора статов Apex: «Let's put Venom and Rage on tier 6. So the there will be no
    3 perks on same level» — тир 6 = Row 5 (индекс), лвл 7.

24. **Порог сброса щита в Rage** (выбор из вариантов): «~10 стаков» — наступает на 2–3-й
    ход активной драки, щит защищает на подходе.

25. **Бонусы Beast Aura** (выбор из вариантов): «Только мораль/бесстрашие» — не бегут +
    бонус Resolve; главная ценность перка — смена ИИ (телохранители), а не статы.

26. **Fighter-вариант Venom** (выбор из вариантов): «Тот же яд, что у зверей» — мили-атаки
    самого друида накладывают тот же ослабляющий poison-coat (зрение + замедление).
