# Accessory Companions (fixed by hackflow)

*This mod stems from [Accessory Companions][original] by Vazl, with bug fixes, a richer taming
formula and better compatibility.*

Lets you tame beasts as companions, level your companions up and have them gain additional attributes and skills.

## Compatibility

Is safe to add midgame, cannot remove. Plays nice with:

- Reforged
- [More Backgrounds and Events (Updated)][xbe]
- [North Expansion][north-expansion]
- [Proper Druid][druid]
- [More Love For Dogs][love]

Should use a specialized version for Legends, i.e. not this.

## Changes from the Original Mod

- tame chance formula expanded — on top of the target's missing health it now accounts for
  injuries, being rooted, stunned or taunted, and low morale, and it scales with the
  player's level (double at level 11)
- tame chance is shown in the combat log on both success and failure
- fixed a crash when loading a save with a corrupted companion accessory

Compatibility fixes:

- beasts are identified by their class instead of their displayed name, which:
    - works with a translated game (the original matched English names only)
    - is generally more mod- and future-proof
- works with the [Northern Expansion][north-expansion] direwolf
- avoids duplicate tooltips when Nested Tooltips is installed
- doubles the tame chance for the Druid background from [Proper Druid][druid] or [More Backgrounds and Events (Updated)][xbe].

Russian localization included — need to install [Rosetta][] and its dependencies.

## Install

Download a zip and put it into the `data` dir. Requires [modhooks][] of version 20 or newer.

To use the built-in Russian translation also install [Rosetta][] and the Russian translation
of the game itself (data_014 and fonts). Once that is done the mod switches to Russian
automatically.

[original]: https://www.nexusmods.com/battlebrothers/mods/314
[modhooks]: https://www.nexusmods.com/battlebrothers/mods/42
[Rosetta]: https://www.nexusmods.com/battlebrothers/mods/802

[xbe]: https://www.nexusmods.com/battlebrothers/mods/769
[north-expansion]: https://www.nexusmods.com/battlebrothers/mods/720
[druid]: https://www.nexusmods.com/battlebrothers/mods/...
[love]: https://www.nexusmods.com/battlebrothers/mods/686
