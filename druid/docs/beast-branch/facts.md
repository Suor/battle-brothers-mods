# Beast Branch — факты (заземлённые в коде/игре)

Каждое утверждение с `path:line` или путём. Append; устаревшее помечать, не переписывать.

## Текущее дерево перков друида

Источник: `mods/druid/scripts/config/z_druid.nut`.

- Перки инжектятся в `::Const.Perks.Druid`, поле `Row` задаёт тир в дереве; `Unlocks = Row`.
- Текущее размещение:
  - **Regrowth** — Row 1 (`z_druid.nut:16`)
  - **Venom** — Row 1 (`z_druid.nut:25`)
  - **Entangling Roots** — Row 3 (`z_druid.nut:34`)
  - **Hatch** — Row 3 (`z_druid.nut:43`)
  - **Pack Leader** — Row 4 (`z_druid.nut:52`)
  - **Apex Predators** — Row 6 (`z_druid.nut:62`)

## Механики существующих перков

- **Summon Beast** — базовый актив, по умолчанию раз за бой; кулдаун тикает только при Hatch
  (`mods/druid/scripts/skills/actives/druid_summon_beast.nut:3,72`). Призывает зверя по биому
  (uncommanded). Общий для всех друидов.
- **Regrowth** — пер-тёрн хил на одного союзника, x2 на животных, один носитель за раз, не на
  нежить (`scripts/skills/actives/druid_regrowth.nut`, `scripts/skills/effects/druid_regrowth_effect.nut`).
- **Venom** — укусы призванных зверей накладывают ослабляющий poison-coat (дебафф зрения +
  замедление, не урон, не истощается — 99 атак) (`scripts/skills/racial/druid_venom.nut`).
  Наследует `poison_coat_effect` (гоблинская логика).
- **Pack Leader** — маркер `racial.druid_fearless`: зверя можно потрясти, но он не убегает
  (мораль не падает ниже Breaking) (`scripts/skills/perks/perk_druid_pack_leader.nut`,
  `scripts/skills/racial/druid_fearless.nut`).
- **Apex Predators** — апгрейд призванных: `direwolf→direwolf_high`, `hyena→hyena_high`, прочих
  растит на месте (`z_druid.nut` `ApexMap`, `makeApex()`).
- `::Const.Druid.isAnimal(_actor)` — хелпер «зверь/животное» для x2-хила и подобного
  (`z_druid.nut`).

## Текущие пулы призыва

- Базовый пул сейчас стартует с `direwolf` почти во всех биомах (`z_druid.nut:81-95`).
  Default = `["direwolf"]`. Т.е. на 1-м уровне уже даётся Direwolf — отсюда «сильновато».

## Сущности зверей (возможность скейлинга)

- `Wolf` и `Direwolf` — РАЗНЫЕ ванильные сущности: есть
  `base/data_001/scripts/entity/tactical/enemies/wolf.nut`, `.../direwolf.nut`,
  `.../direwolf_high.nut`. Значит «старт с Wolf → апгрейд до Direwolf/разнообразия» реализуемо
  подменой сущности. (`wolf_high` есть только в `base/mod_custombackgrounds/...`.)

## Совместимость по образцу necro

- necro работает в чистой ванили: перки инжектятся прямо в дерево; если установлен
  DynamicPerks — добавляются через `SpecialPerkGroup`
  (`mods/necro/scripts/!mods_preload/mod_necro.nut:193-195`, `mods/necro/scripts/necro_pg.nut`);
  для Reforged — отдельные совместимые хуки (`mod_necro.nut:27`,
  `mods/necro/scripts/skills/backgrounds/necro_background.nut:40-43`). Жёстких зависимостей нет.

## Статы зверей (ваниль)

- `Const.Tactical.Actor.Wolf` (`base/data_001/scripts/config/faction_greenskins.nut:150`):
  HP 40, MSk 65, MDef 15, Init 140, брони нет; укус `wolf_bite` 20–40, ×0.4 по броне.
- `Direwolf` (`base/data_001/scripts/config/faction_beasts.nut:31`): HP 130, MSk 60, MDef 10,
  Init 150, броня 30/30; укус `werewolf_bite` 30–50, ×0.7 по броне.
- `FrenziedDirewolf` (`faction_beasts.nut:50` + `direwolf_high.nut`): HP 150, MSk 65,
  Bravery 70, урон ×1.25, +Overwhelm, +Relentless, иммунитет к disarm, без ночного штрафа.
  Защита/броня/AP/Init — как у Direwolf.
- Вывод по силе: скачок Wolf→Direwolf (HP+броня+урон в разы) много больше скачка
  Direwolf→Frenzied (~+25% урона, +5 MSk, +15% HP, утилити-перки).

## Референс «Rage» из Reforged

- То, что пользователь зовёт «Barbarian Rage in Reforged», — это хук ванильной орочьей ярости
  `berserker_rage_effect`: стакающиеся `+Damage / +Resolve / +Initiative` по числу RageStacks
  **плюс** флэтовое снижение получаемого урона
  (`3rdparty/reforged/mod_reforged/hooks/skills/effects/berserker_rage_effect.nut:18-44`).
  Именно компонент «снижение урона» пользователь хочет заменить на регенерацию.
- Внимание к неймингу: `barbarian_fury_skill` в Reforged — это РОТАЦИЯ строя (смена мест с
  союзником), а не ярость (`3rdparty/reforged/mod_reforged/hooks/skills/actives/barbarian_fury_skill.nut`).
- УТОЧНЕНИЕ (частично устаревает первый пункт): хук Reforged на `berserker_rage_effect` —
  чисто косметический (описание + тултип, `calcDamageTakenMult` влияет только на тултип);
  механику он НЕ меняет (`3rdparty/reforged/mod_reforged/hooks/skills/effects/berserker_rage_effect.nut`).
- **Ванильная орочья ярость** (`base/data_001/scripts/skills/effects/berserker_rage_effect.nut`):
  стаки +2 за попадание, +5 за убийство, −1 в начале хода. За стак: −2% получаемого урона
  (кап −70%), +1 Resolve, +1 min/max Damage, +1 Initiative. Штрафа защите НЕТ. Рык при наборе.
- **Reforged `perk_rf_feral_rage`** (`3rdparty/reforged/scripts/skills/perks/perk_rf_feral_rage.nut`) —
  игроцкий перк-ярость, лучше всего совпадает с описанием пользователя («bonuses as it stacks
  up, but you loose def»): стаки +2 за мили-попадание вплотную, +3 за мили-убийство, +1 за
  полученный удар; −3 в начале хода; сброс в 0 после боя. За стак: +2% мили-урона, −2%
  получаемого урона (кап −70%), +2 Resolve, +2 Initiative, **−1 Melee Defense**.

## Графика гуманоида-зверя

- Полноценной модели «оборотень/зверочеловек» в ванили нет; ближайшее — гуманоидные звери в
  сторонних модах (Fantasy Bros lizardmen, по словам пользователя). Подмена модели на лету не
  обязательна: перманентный облик можно дать при взятии Beastform. (Не заземлено в коде — оценка.)
- ПОДТВЕРЖДЕНО: Fantasy Bros (`3rdparty/fantasy/entity_xx/witch/`) содержит бюсты-головы
  зверолюдей, надеваемые на гуманоидное тело: `bust_bigwolf_01–05` (белый волк),
  `bust_wolfking_01–02` (тёмный волк), `bust_bear_01–02`, `bust_boar_01–03`, `bust_lion_01–02`,
  `bust_liger_01–02`, `bust_mino_01–02` (минотавр); ящеры — `bust_head_7910–7915` +
  тело `bust_naked_body_7890`. У части есть `_dead`/`_injured` варианты. (По оценке
  пользователя это «animals» — для Beastform нужен гуманоид, см. следующий пункт.)
- **Гуманоидный зверочеловек «Baku»** — готовый приключенец-бэкграунд Fantasy Bros
  (`3rdparty/fantasy/scripts/skills/backgrounds/xxhero_baku_background.nut`): мохнатое
  гуманоидное тело `bust_naked_body_7873/7874` + львино-кошачья гуманоидная голова
  `bust_head_7880–7882` + грива `hair_beast_01–05`. Прочие гуманоиды той же серии: орки
  (`bust_head_7900–7902`, тело `7872`), маски/нежить (`7874–7877`), демоны (`7890–7891`).
- Механизм смены облика — подмена брашей спрайтов `body`/`head` через `setBrush()`, образец:
  `3rdparty/fantasy/scripts/skills/backgrounds/xxhero_lizard_background.nut:14-34`
  (`onSetAppearance`). Браши упакованы в `brushes/entity_xx.brush` + атлас `gfx/entity_xx.png`.
