# Releasing a mod

`TO_RELEASE.md` tracks what is ready; `make cl` in the repo root lists unreleased commits per mod. Screenshots for a
mod's page: `_docs/screenshots.md`.

1. Ready check: nothing half-done, known bugs fixed, `make check` and the mod's tales pass. Deps the
   new version needs (stdlib, Rosetta, ...) must be released already; raise the mod's guards
   (`mod.require(...)`, the rosetta file's `::Rosetta.Version` check) to them.
2. Commit the mod's changes as small semantic commits, `<abbr>: <what>` (`ff:`, `hp:`, `nicks:`,
   ...) — never stage other mods' or the user's unrelated changes.
3. Update README for user-visible changes, without making it longer than needed.
4. CHANGELOG: draft with `clsub` (shell alias, run in the mod dir) — it lists commits since the last
   `up to` one. One short line per change, user-facing words, sections `Compatibility:`/`Fixes:`
   when useful. The entry is headed by the bare version, `nexus.py` finds it by that line.
5. Bump the version everywhere it is written: `Version` in `scripts/!mods_preload/mod_*.nut`, the
   rosetta file's `mod = {..., version = ...}`, anything else `grep` finds.
6. Commit CHANGELOG + version bump as `<abbr>: up to X.Y.Z`, then tag that commit
   `<TAG_NAME>-X.Y.Z` (lightweight, `TAG_NAME` from the Makefile, e.g. `fun-facts-1.1.0`).
7. `make zip` — the name comes from the last tag; a `_MODIFIED` suffix means sources differ from the
   tag, so don't ship that. It also refuses to build with `debug = true` left in sources.
8. `git push` with `--tags`.
9. Nexus: `make upload` (= `../_scripts/nexus.py upload`) uploads the newest non-`_MODIFIED` zip as
   a new version of the main file and asks for a file description; `-c CHANGELOG` also posts the
   version's changelog entry (`nexus.py add-changelog X.Y.Z CHANGELOG` does it separately). The mod
   page comes from `URL = ...` in the mod's Makefile — many don't have one, then pass the page url
   or id as an argument. Needs `NEXUSMODS_KEY` in `../.env`.
10. Discord: announce in the mod's thread in each hub it has one — Legends, Reforged, BB Modding.
    `../_scripts/discord.py announce X.Y.Z` posts the full CHANGELOG entry, subheaders included,
    under `**Released X.Y.Z** on [NexusMods](<URL>):` to the threads listed in the Makefile's
    `DISCORD = <thread id>...`; `-n` only prints it. It works through the logged-in Discord tab of
    the CDP browser. A mod has 1 to 3 threads; to find missing ones look for `thread_id` in
    `../service/data/discord_*.jsonl`. Posting is outward-facing: show the text and get the user's
    go-ahead first. To fix a posted announcement, `discord.py edit THREAD MESSAGE_ID FILE` in place
    (`discord.py last THREAD` shows message ids), never post a second one.
