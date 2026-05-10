# Translation Rules

## Before You Start

**Check if a translation already exists.** Before labeling a mod as untranslated, search for `rosetta_ru.nut` inside the mod's own directory tree — translations are sometimes co-located with the mod scripts, not in `hackflows_translations/`.

## Terminology — Check data_014 and pack_ru First

Before translating any term, look it up in `~/projects/bbm/base/data_014/` and `pack_ru.nut` to find the established Russian convention. Do not guess or translate literally.

Known traps:
- **Fatigue** as a stat / capacity / cost → `выносливость` ("стоит X выносливости", "восстанавливает выносливость")
- **Max Fatigue** as a bonus/penalty (`+N`, штраф) → `выносливость` без "максимальной" — бонусы всегда идут в максимум, "максимальная" избыточно ("+1 к выносливости", "штраф к выносливости")
- **Max Fatigue** как величина в расчёте → `максимальная выносливость` ("15% максимальной выносливости")
- **Fatigue** as accumulation (what builds up) → `усталость` ("накапливает усталость", "меньше усталости от атак")
  - data_014: «общее количество **усталости**, которую персонаж может **накапливать** (или **выносливости**, которую персонаж может **потратить**)»
- **Crowns** (currency) → `крон` (not монет/монеты)
- **Perk** → `навык`
- **Perk tree** → `дерево навыков`
- **Polearm Mastery** → `Мастер древкового оружия`
- **Bow Mastery** → `Мастер лука`
- **Crossbow Mastery** → `Мастер арбалета`
- **Dazed** → `Выбит дух` (not одурманенный/дезориентированный)
- **Melee defense** → `защита в ближнем бою` (not "защита ближнего боя" — preposition "в" required)
- **Ranged defense** → `защита в дальнем бою`
- **Head armor** → `шлем`; **body armor** → `доспех` / `броня`; together → `броня и шлем` (data_014: Nimble, BattleForged, Brawny perks)
  - Bonus/stat context: `+N к прочности шлема и доспеха`
  - Not: "броня головы и тела"

## Morale States

Use exact names from `data_014/scripts/config/character.nut` (`MoraleStateName`):

| English   | Russian        |
|-----------|----------------|
| Fleeing   | Отступает      |
| Breaking  | Сломлен        |
| Wavering  | Нерешителен    |
| Steady    | Уравновешен    |
| Confident | Решителен      |
| Bold      | Непоколебим    |

When used as adjective in a sentence: "нерешительный боевой дух", "сломленный боевой дух", "решительный боевой дух", "уравновешенный боевой дух".

Traps: "wavering" ≠ "колебание", "breaking" ≠ "паника", "confident" ≠ "уверенный", "steady" ≠ "стойкий".

## Event Log Messages

Check `data_014` for the style conventions before translating combat/event log strings:
- Tense and aspect (Russian present vs past can differ from English "has destroyed")
- Color formatting on nouns (e.g. `[color=#xxxxxx]щит[/color]`)
