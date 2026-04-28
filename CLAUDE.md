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
make log            # Print first errors from the game's log.html with stacktraces
```

Use `make log` to inspect failures. Look at the **first** error and ignore the JS/UI ConsoleAPI noise; those are downstream effects of an earlier squirrel failure.

Build config is in `.env` at repo root — sets `STDLIB_DIR`, `DATA_DIR`, `SCRIPTS`, etc. All mods use `include ../Makefile.common`.

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

**IMPORTANT — Translation style:** These are strings from Battle Brothers game, set in middle age Europe, it also has some fantasy elements like witches, weidegangers and greenskins. Follow the game setting. Prefer fun and concise translations over literal or formal ones.

To verify a rosetta translation file, run:

```bash
rosetta -c <path/to/translation.nut> <path/to/mod/dir>
```

## Utility Scripts

- `hookify.py` — converts old "copy and edit" mod files to Modern Hooks style
- `migrate_hooks.py` — converts Adam's hooks format to Modern Hooks format
