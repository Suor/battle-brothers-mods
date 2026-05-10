# Translation Rules

## Before You Start

**Check if a translation already exists.** Before labeling a mod as untranslated, search for `rosetta_ru.nut` inside the mod's own directory tree — translations are sometimes co-located with the mod scripts, not in `hackflows_translations/`.

## Terminology — Check data_014 and pack_ru First

Before translating any term, look it up in `~/projects/bbm/base/data_014/` and `pack_ru.nut` to find the established Russian convention. Do not guess or translate literally.

Known traps:
- **Fatigue / Max Fatigue** → `выносливость` (not усталость/усталось)
- **Perk** → `навык`
- **Perk tree** → `дерево навыков`
- **Polearm Mastery** → `Мастер древкового оружия`
- **Bow Mastery** → `Мастер лука`
- **Crossbow Mastery** → `Мастер арбалета`

## Event Log Messages

Check `data_014` for the style conventions before translating combat/event log strings:
- Tense and aspect (Russian present vs past can differ from English "has destroyed")
- Color formatting on nouns (e.g. `[color=#xxxxxx]щит[/color]`)
