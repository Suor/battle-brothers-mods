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
service/          # mod support service; data/ holds scraped Discord & Nexus threads, sources/ collected mod zips
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

### Investigating crash

Use `make log` (or `../_scripts/bb_log_errors.py`) to inspect failures — this is the default for almost any "what blew up" question. **The first error** is what usually matters, the rest is just a fallout.

### Debugging

If you need to debug an issue, and you cannot find a fix from a crash stacktrace (or it doesn't have one), then use `logInfo()/logWarning()/logError()` calls and `../_scripts/parse_log.py` to read the log. Default filter drops engine/rosetta noise; use `--all` to disable, `--level error,warning` / `--tag SQ` / `--tail N` to narrow.

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
- **stdlib over MSU** — when stdlib (`::std.*`) has the function, use it instead of the MSU one (e.g. `::std.Text.negative` / `positive`, not `::MSU.Text.colorRed` / `colorGreen`).
- **Class detection** — use `::std.Util.isKindOf(item, "weapon")` to test the class hierarchy (weapon, shield, armor, helmet, player, etc.). `isItemType()` is for the type bitmask (`Named`, `Legendary`, `Armor`, `Helmet`, `Quest`, `Usable`...) and is not interchangeable with `isKindOf`.

### Compatibility

A fix or change must keep working with the older game, Legends and Reforged versions the mod supports, and with other mods doing unexpected things (calling a hook twice, replacing a function our hook wraps). Dropping support for anything is a deliberate decision, stated in the CHANGELOG, never a side effect of a fix.

### Squirrel 3.0

The game runs Squirrel 3.0; the standalone `squirrel` and modern-bb-engine run 3.2 and accept more (bbtales's `--env code` runs 3.0). Mods and their tests (`<mod>/tales/`) must stick to 3.0:

- `push`, `append`, `extend`, `insert`, `resize`, `reverse`, `sort`, `clear` return null — call them as statements, never use their value.
- Tables have no `keys()`, `values()`, `filter()`, `map()`; `reduce` takes no initial value, `tointeger` no base, `tolower`/`toupper` no range; no `in` on a class.
- A statement after an if-block on the same line (`if (c) { ... } return;`) doesn't compile.
- A closure made inside a generator reads the generator's locals as null after a `yield`.
- `World.getRoster(id)` of a missing id raises instead of returning null.

`~/projects/bbm/bbtales/lint.py <dir>` finds these with the game's own 3.0 compiler (bbtales runs it on tales). The full list: `~/projects/bbm/bbtales/docs/SQUIRREL_3_0.md`; engine differences: its README, "Engine issues".

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

## Brushes & Sprites

Sprite names in `setBrush(...)`, `spawnIcon(...)` and `m.IconMini` are brush-atlas ids, not PNG paths (unlike
`m.Icon`). Packing, unpacking and finding sprites: the `brushes` skill.

## Releasing a mod

The steps, Nexus upload and Discord announcements: `_docs/releasing.md`; screenshots: `_docs/screenshots.md`.
Posting to Nexus or Discord is outward-facing: show the text and get the user's go-ahead first.

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
