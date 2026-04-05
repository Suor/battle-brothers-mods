# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A collection of Battle Brothers game mods written in Squirrel (`.nut` files). Each mod lives in its own subdirectory and uses the **Modern Hooks** framework to non-invasively patch game classes.

Sister repos (often referenced): `../stdlib` and `../rosetta`.

## Build Commands

All commands run from within a specific mod's directory (e.g. `cd nicknames && make test`).

```bash
make test           # Check syntax + run test.nut (if it exists)
make check-compile  # Syntax-check all .nut files via squirrel -c
make zip            # Create release ZIP (checks for debug statements, uses git tag for name)
make install        # Install to DATA_DIR (from .env)
make include        # Copy shared files from ../_includes/ with variable substitution
```

Build config is in `.env` at repo root — sets `STDLIB_DIR`, `DATA_DIR`, `SCRIPTS`, etc. All mods use `include ../Makefile.common`.

## Mod Architecture

Each mod follows this layout:

```
mod_name/
  scripts/!mods_preload/mod_<name>.nut   # Entry point, loaded by the game
  mod_name/                              # Mod logic
    *.nut                                # Config, data, helpers
    hooks/                               # Hook implementations
      *.nut
  Makefile                               # Defines MOD_NAME, TAG_NAME, SOURCES, INCLUDES
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

### Testing

Tests use a standalone Squirrel interpreter (no game engine). The pattern:

```squirrel
dofile(getenv("STDLIB_DIR") + "tests/mocks.nut", true);  // core game API mocks
dofile("mocks.nut", true);                               // mod-specific mocks
dofile("scripts/!mods_preload/mod_name.nut", true);      // load the mod

// ... assertions using throw on failure
```

Tests pass if no stderr output. `mocks.nut` provides fake `::Hooks`, `::Const`, `::Math`, `::include()`, etc. See `nicknames/mocks.nut` and `nicknames/test.nut` for a full example of a well-tested mod.

### Rosetta (Translations)

Mods include translation files like `mod_name/rosetta_ru.nut` in SOURCES if they support localization. The rosetta framework intercepts strings at the Squirrel/JS boundary.

### _includes Directory

Shared boilerplate (MSU settings, common hooks) lives in `_includes/`. The `<mod_name>` placeholder in included files is replaced with `MOD_NAME` at copy time.

## Utility Scripts

- `hookify.py` — converts old "copy and edit" mod files to Modern Hooks style
- `migrate_hooks.py` — converts Adam's hooks format to Modern Hooks format
