# CLAUDE.md

This directory is the `hackflows_translations` mod — a collection of Russian Rosetta translations for 3rdparty Battle Brothers mods that don't ship their own Russian localization.

## Adding a New Mod Translation

If the mod has no source dir in `~/projects/bbm/3rdparty/`, find its ZIP in `DATA_DIR` (from root `.env`) and unzip it there first.

1. Generate boilerplate: `cd ~/projects/bbm/3rdparty/<mod_dir> && rosetta -lru . > ~/projects/bbm/mods/translations/hackflows_translations/<name>.nut`
2. Fill translations in the generated file.
3. Add `::include("hackflows_translations/<name>");` to `scripts/!mods_preload/mod_hackflows_translations.nut`.
4. Add `rosetta -qc hackflows_translations/<name>.nut ~/projects/bbm/3rdparty/<mod_dir>` to `Makefile`'s `check` target.

To validate a single file: `rosetta -qc hackflows_translations/<file>.nut ~/projects/bbm/3rdparty/<mod_dir>`

## Resources

- `RULES.md` — terminology conventions and translation style rules
- `TODO.md` — mods that still need translation and their string counts
- `AGENTS.md` — full Rosetta guide (patterns, plural forms, capture types)
