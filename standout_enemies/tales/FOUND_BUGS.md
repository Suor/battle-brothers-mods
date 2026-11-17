# Standout Enemies — bugs reproduced by the scenario tests

Found 2026-11-12 on the working tree (1.4.0). Code: `cursed_effect.nut` =
`standout_enemies/scripts/skills/cursed_effect.nut`. Commands from `~/projects/bbm/bbtales`.
Both fail packed and with `--isolate`.

## SE-KB1. Hair and beard stay dark after the curse; head and body lose their tint — medium (KNOWN_BUGS #1)

- Test: `core::SE-KB1: a brother's look comes back after the curse` — `./bbtales.py -k SE-KB1 ../mods/standout_enemies/tales/tale_core.nut`
- Observed (sprite `[R, G, B, Saturation]` before the curse vs after the battle removed it):
  ```
  expected {beard = [237, 235, 242, 1], beard_top = [255, 255, 255, 1], body = [240, 247, 252, 0.9811], hair = [237, 235, 242, 1], head = [240, 247, 252, 0.9811]}
  got      {beard = [23, 23, 24, 1],    beard_top = [25, 25, 25, 1],    body = [255, 255, 255, 1],       hair = [23, 23, 24, 1],    head = [255, 255, 255, 1]}
  ```
- Cause: `updateAppearance` (`cursed_effect.nut:152-165`) calls `setBrightness(0.1)` then
  `setBrightness(1.0)` on hair/beard. The native scales the sprite's current color and keeps
  nothing else (the engine reimplements the original's `0x5048c0` that way), so 1.0 doesn't
  undo 0.1. Head/body/face go through `Mod.color(..., "#ffffff", 1.0)`, which resets them to plain
  white and saturation 1, dropping the color the background rolled (`character_background.nut:349-353`).
  `onRemoved` does run after the battle; the original look just isn't saved anywhere.
- Fix direction: remember `Color`/`Saturation` of each sprite in `onAdded`, restore them in `onRemoved`.

## SE-KB2. A status-resistant target throws `the index 'actor' does not exist` — medium (KNOWN_BUGS #2)

- Test: `core::SE-KB2: a status-resistant target resists the curse without an error`
- Observed: 20 curses on a bro with `IsResistantToAnyStatuses` → 8–12 errors
  `the index 'actor' does not exist` (every resisted roll, 50%).
- Cause: `checkResist()` (`cursed_effect.nut:116-125`) uses `actor` without declaring it. Hits
  Ijirok-potion bros and anything else with `IsResistantToAnyStatuses` (vanilla undead have it too).
