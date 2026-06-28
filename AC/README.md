# Accessory Companions (fixed by hackflow)

*This mod stems from [Accessory Companions][original] by Vazl, with bug fixes, a richer taming
formula and better compatibility.*

Lets you tame beasts as companions, level your companions up and have them gain additional attributes and skills.

## How It Works

- Any brother with an empty accessory slot gains a **Tame Beast** skill. The chance grows with
  the target's missing health, injuries, being rooted, stunned or taunted, and low morale, it also scales with the player's level. A failed attempt locks that beast out for the rest of the
  fight, and a tamed beast cannot be unleashed in the same battle it was caught in.
- Webknechts may also drop from eggs
- Beasts take wounds in battle and heal up on the world map over time. Their current health shows in the tooltip.
- Companions gain experience from kills (their own, a brother's or another companion's) without
  reducing the brothers' share, and don't need to be unleashed to do so. They learn faster if equipped by Houndmaster or Beastmaster.
- On level up they grow their preferred and two random attributes and pick a random quirk; at level 11 beasts get the **Good Boy/Girl** quirk that scales their base damage.
- Beasts can be re-leashed to remove them from the field, but only unleashed once per battle.
  "Super beasts" (unhold, schrat, lindwurm) only start acting the round after being unleashed.
- Equipped companions add to the party's strength, scaling with their level.
-  number of companions of each type is limited: only one Lindwurm, Unhold and Schrat at a time, up to 6 wolves, 12 dogs and such.

## Learnable Quirks

On level up a companion may gain one quirk from a curated pool: combat perks (e.g. Colossus,
Nine Lives, Adrenaline, Executioner, Dodge, Steel Brow, Backstabber, Relentless, Berserk,
Nimble, Fearsome, Killing Frenzy, Indomitable, Devastating Strikes, Battering Ram), the traits
Huge and Lucky, and special effects like Rage, Poisonous, Healthy, Soften Blows and Regenerative.

## Other Additions

- **Beastmaster** is a higher-tier Houndmaster variant, drafted in larger settlements
  (cities, citadels), experienced with all beasts and better at taming them. Smaller
  settlements still draft ordinary Houndmasters.
- Necromancers have a small chance (~3%) to drop a **Tome of Reanimation**. It gives a bro an ability to raise undead. Tome's raised undead also get experience and levels.


## Compatibility

Is safe to add midgame, cannot remove. Plays nice with:

- Reforged
- [Autopilot New][autopilot]
- [Proper Druid][druid] and [More Backgrounds and Events (Updated)][xbe] - druid have a higher taming chance
- [North Expansion][north-expansion] - a wolf pet becomes a companion
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

[autopilot]: https://www.nexusmods.com/battlebrothers/mods/675
[xbe]: https://www.nexusmods.com/battlebrothers/mods/769
[north-expansion]: https://www.nexusmods.com/battlebrothers/mods/720
[druid]: https://www.nexusmods.com/battlebrothers/mods/...
[love]: https://www.nexusmods.com/battlebrothers/mods/686
