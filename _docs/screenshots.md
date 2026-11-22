# Screenshots for mod pages

Made with bbtales (`~/projects/bbm/bbtales`) in the engine's window: the real game frame (world map, portraits, the
UI page on top), set up by a probe script. Fun Facts' `fun_facts/tales/probe_shots.nut` is the worked example;
finished shots go to `_screenshots/`.

## Running

```sh
cd ~/projects/bbm/bbtales
nice -n 10 ./intel_gpu.sh ./bbtales.py --env ui --show --config video.width=1920,video.height=1080 \
    ../mods/<mod>/tales/probe_shots.nut
```

- A probe is not a `tale_*` file, so suites skip it; it runs when named.
- `--show` keeps the window open after the tests: close it (kill the `target/release/bb` process) once the PNGs
  are in `work/runs/<run>/1/logs/`. The window takes the real mouse: keep yours off it, or it moves the cursor.
- `--config` sets the engine's `settings.txt` keys. 1920x1080 at UI scale 1.0 (the default) is what a vanilla
  player sees at 1080p; `video.ui_scale=1.3` matches 130% in the game's options.
- `--env game` (the original under Proton) is no reference for text: it mounts every `.dat` of the Steam install,
  a Russian translation's `data_014.dat` included, whose FreeUniversal (a 2017 edit with Cyrillic, also copied
  loose to `data/gfx/fonts/`) has narrower capitals. The engine leaves
  `data_014` out (`BBTALES_SKIP_DATS`), so its text is vanilla's.
- Headless `--env ui` runs the same script without a window: check it there first, shots there are the page only.

## Making the scene believable

- A full company (12), each with background, level (`updateLevel` + `setAttributeLevelUpValues` per level, three
  attributes by role), perks fitting the weapon, equipment by role, a formation: shields and one-handers in the
  front row (slots 0-8), two-tile weapons, bows and crossbows in the second (9-17).
- Nothing at 100%: `item.setCondition(max * k)`; the front row's gear wears more.
- The stash as players have it (see the user's own shots in `~/Pictures`): cheap grain in stacks of 25, used
  quivers (`setAmmo`), nets, bandages, beast trophies, and the last enemy's gear to sell: armor and helmets at
  25-100% (vanilla drops loot armor only above 30 and 25% of its max), its weapons and painted shields
  (`setFaction(banner)`). No expensive food, no trade goods, no odd potions.
- Every number agrees with the rest: days with the company, lifetime battles and kills, "the most powerful opponent"
  (the highest-XP kill, XP from vanilla's `Const.Tactical.Actor`), wages by daily pay times days, the obituary row
  with the fallen's history. A companion is "with the company from the very beginning", so not hired for money.
- No made-up text unless the user asks: a string the scene fills in (an obituary's cause of death, a name with a
  title) is what the game or a mod would write, so look up its source (the cause is the skill's `KilledString` +
  " by " + the killer, `player.nut` `getObituaryInfo`: an aimed shot gives "Shot by Torkel").
- Fun first, no joke twice across the shots: give each shot its own facts, and let the jokes connect (the archer
  shot two bros in the back, the obituary lists both as "Shot by" him).

## Tricks

- Hover a bro by his portrait: slots keep the bro's id, `$('.is-brother-slot .brother').map(... $(this).data('ID'))`;
  select him first (mousedown, mouseup, click) so the left panel shows him.
- Hide the tooltip before hovering again (`.tooltip-module` `display-none`), or the wait sees the old one.
- Wait some 60 frames before `t.shot`: screens and tooltips fade in.
- The drawn cursor goes where `::UI.setCursorPosition(x, y)` puts it, in window pixels: put it on what's hovered.
- The engine measures the obituary tooltip before its text wraps and places it off-screen; place it as vanilla's
  `setupUITooltip` would (centered over the row, above or below) before the shot.
- `yield` takes only a wait (`t.frames`, `t.until...`): no helper generators.
