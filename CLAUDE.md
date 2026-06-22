# CLAUDE.md

This repo is a collection of Battle Brothers game mods written in Squirrel (`.nut` files). Each mod lives in its own subdirectory and uses the **Modern Hooks** framework to non-invasively patch game classes.

Battle Brothers is a tactical rogue-like game, set in middle age Europe, it also has some fantasy elements like witches, weidegangers and greenskins.

## Related Directories (in `~/projects/bbm/`, which is `../`)

```
base/
  scripts-base/   # vanilla game scripts — look up original classes, methods, constants
  data_001/       # vanilla game resources unpacked
  data_014/       # Russian translation unpacked
legends/          # Legends mod — a major overhaul mod
stdlib/           # shared utility library used by mods
rosetta/          # localization framework; rosetta.py CLI, AGENTS_TRANSLATING.md
3rdparty/         # third-party mods and libraries
  msu/            # MSU — Modding Standards & Utilities, mod compatibility library
  reforged/       # Reforged — a newer but smaller major overhaul mod
  xbe/            # XBE — More Backgrounds and Events mod
mods/             # THIS DIR, a collection of hackflow's (mine) mods
  _includes/      # Shared utils, may be auto-included by a mod during build
  <mod-name>/     # Individuals mods
  ...
```

Can compare data_014 .nut and .js files to their english counterparts in data_001 to find out established term translations to russian.

## Build Commands

All commands run from within a specific mod's directory (e.g. `cd nicknames && make test`).

```bash
make check          # Run all the checks: syntax, tests, custom check
make install        # Install to DATA_DIR (from .env)
make zip            # Create release ZIP (checks for debug statements, uses git tag for name)
make log            # Print first errors from the game's log.html with stacktraces (wraps `../_scripts/bb_log_errors.py`)
```

Use `make log` (or `../_scripts/bb_log_errors.py`) to inspect failures — this is the default for almost any "what blew up" question. Look at the **first** error and ignore the JS/UI ConsoleAPI noise; those are downstream effects of an earlier squirrel failure.

For deeper traces use `../_scripts/parse_log.py` — flattens `log.html` to `HH:MM:SS [level] TAG | text`, plays nicely with `grep`. Default filter drops engine/rosetta noise; use `--all` to disable, `--level error,warning` / `--tag SQ` / `--tail N` to narrow. Reach for it only when you need context around `logInfo` calls our own code emits (decision loops, AI verbose mode, custom diagnostics), not for ordinary errors.

Build config is in `.env` at repo root — sets `STDLIB_DIR`, `DATA_DIR`, `SCRIPTS`, etc. All mods use `include ../Makefile.common`.

`make check` runs syntax + tests + a gfx guard + the mod's own check, often `rosetta -c`.

## Mod Architecture

Each mod follows this layout:

```
mod_name/
  scripts/!mods_preload/mod_<name>.nut   # Entry point, loaded by the game
  <name>/                                # Mod logic
    *.nut                                # Config, data, helpers, custom logic
    hooks/                               # Hook implementations
      *.nut
  README.md
  Makefile                               # Defines MOD_NAME, TAG_NAME, SOURCES
  test.nut                               # (optional) unit tests
  mocks.nut                              # (optional) test mocks
```

### Entry Point Pattern

```squirrel
local def = ::ModName <- { ID = "mod_name", Version = "1.0.0", Name = "Human Name" }
local mod = def.mh <- ::Hooks.register(def.ID, def.Version, def.Name);
mod.require("other_mod >= 1.0");
mod.queue(function() {
    ::include("mod_name/hooks/some_class");
    // ...
});
```

### Hooks Pattern

Hooks use `mod.hook()` to wrap game class methods without replacing entire files:

```squirrel
mod.hook("scripts/path/to/class", function(q) {
    q.methodName = function(_orig) {
        return function() {
            // modify behavior, call _orig() as needed
        }
    }
});
```

### Common Idioms

- **Null checks for game objects** — use `::std.Util.isNull(x)`, not `x == null`. Game objects are often `WeakRef` wrappers that compare oddly against `null`.
- **Class detection** — use `::std.Util.isKindOf(item, "weapon")` to test the class hierarchy (weapon, shield, armor, helmet, player, etc.). `isItemType()` is for the type bitmask (`Named`, `Legendary`, `Armor`, `Helmet`, `Quest`, `Usable`...) and is not interchangeable with `isKindOf`.

### Testing

Tests use a standalone Squirrel interpreter (no game engine). The pattern:

```squirrel
dofile(getenv("STDLIB_DIR") + "tests/mocks.nut", true);  // core game API mocks
dofile("mocks.nut", true);                               // mod-specific mocks
dofile("scripts/!mods_preload/mod_name.nut", true);      // load the mod

// ... assertions using throw on failure
```

Tests pass if no stderr output. `mocks.nut` provides fake `::Hooks`, `::Const`, `::Math`, `::include()`, etc. See `nicknames/mocks.nut` and `nicknames/test.nut` for a full example of a well-tested mod.

When reproducing or fixing a bug, add a failing assertion to the project's existing `test.nut` (or `test_rosetta.py` for Rosetta) — don't create throwaway scripts in `/tmp`. Run `make test` (or `pytest`) to watch it flip from fail→pass. The same applies to framework fixes in `../rosetta/`, `../stdlib/`, etc.

### Rosetta (Translations)

Mods include translation files like `mod_name/rosetta_ru.nut` in SOURCES if they support localization. The rosetta framework intercepts strings at the Squirrel/JS boundary. See [`../rosetta/AGENTS_TRANSLATING.md`](../rosetta/AGENTS_TRANSLATING.md) for a detailed guide on creating and updating translations.

**Before translating any term, consult the "Terminology & Conventions" section of [`../rosetta/AGENTS_TRANSLATING.md`](../rosetta/AGENTS_TRANSLATING.md)** — it holds the EN→RU glossary (e.g. background → происхождение, Fatigue → выносливость) and log-style rules. Always verify against `../base/data_014/` rather than guessing.

**IMPORTANT — Translation style:** These are strings from Battle Brothers game, set in middle age Europe, it also has some fantasy elements like witches, weidegangers and greenskins. Follow the game setting. Prefer fun and concise translations over literal or formal ones.

To verify a rosetta translation file, run:

```bash
rosetta -c <path/to/translation.nut> <path/to/mod/dir>
```

## Brushes & Sprites (bbrusher)

Sprite names passed to `setBrush(...)`, `spawnIcon(...)` and `m.IconMini` are **brush-atlas
sprites**, not PNG paths (unlike `m.Icon`, which is a direct `gfx/...png` path). Each `.brush`
file describes a sprite sheet; the game auto-loads every `*.brush` in a mod's `brushes/` dir, so
a sprite is available by id once its brush ships (e.g. `druid/brushes/druid_icons.brush` +
`gfx/druid_icons.png` provide `druid_regrowth` / `druid_regrowth_mini`).

**`bbrusher`** (`../base/bbrusher.sh`, a wine wrapper around `bbrusher.exe`) packs/unpacks brushes:

```bash
# Unpack an existing sheet to inspect sprites + metadata
../base/bbrusher.sh unpack path/to/file.brush [outDir]

# Pack a dir of PNGs into file.brush + the sheet named in metadata.xml
../base/bbrusher.sh pack path/to/file.brush <inputDir>
```

The input dir for `pack` **must** contain a `metadata.xml` (note: `unpack` writes that same
`metadata.xml`; the `--help` text calling it `sprites.xml` is wrong). Format:

```xml
<brush name="gfx/druid_icons.png" version="17" b1="2" b5="0">
  <sprite id="druid_regrowth" img="druid_regrowth.png" />
  <sprite id="druid_regrowth_mini" offsetY="35" img="druid_regrowth_mini.png" />
</brush>
```

`id` is the runtime sprite name; `img` is the source PNG in the input dir; `width`/`height`/`ic`
(avg color) and offsets are auto-computed if omitted. `name` is the output sheet path, written
relative to the brush file's grandparent dir by default (`brushes/x.brush` → `gfx/...`); override
with `--gfxPath`. Status-effect floating icons are 56×56; their `_mini` status-strip versions are
20×20. Vanilla sprites live in `../base/unpacked_brushes/<brush>/metadata.xml` — grep there to find
an existing sprite id (e.g. `status_effect_79` = the regen heart) or copy its attributes.
Commit only the resulting `.brush` + sheet PNG (source PNGs/metadata are kept out of the mod, like
`druid_beast.brush`).

## Utility Scripts

- `hookify.py` — converts old "copy and edit" mod files to Modern Hooks style
- `migrate_hooks.py` — converts Adam's hooks format to Modern Hooks format


## Notes

- **`hookTree` vs `mods_hookDescendants` are not interchangeable.** Modern Hooks `hookTree`
  effectively wraps only leaf classes (applied after inherit snapshots), so a wrapper runs
  once after the full `create`. Adam's `mods_hookDescendants` wraps intermediates too, firing
  nested during a leaf's `this.parent.create()` before the leaf sets its fields. A capture
  reading `m.Condition` post-`create()` is safe under `hookTree`, broken under
  `mods_hookDescendants` (sees the default `1.0`).
