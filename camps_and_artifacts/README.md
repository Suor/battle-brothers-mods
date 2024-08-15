# Camps and Artifacts (Reworked)

Adds higher difficulty camps and a higher tier of super-named "artifact" items, which help extend the lategame. A rework of a very fun [Expanded Camps and Artifacts][camps-old] by ProFoolie.

Changes from the base mod:

- added flaming, freezing and poisoned ammo
- add special camps on top not instead of, i.e. there will be more lairs total
- not crowded noble and city state camps
- updated 2h flail base attributes to match vanilla rebalance (was upped somewhat)
- update artifact warbow and greatsword base attributes if [Sato's Balance Mod][sato_balance_mod] is present

Fixes:

- stop messing with lair generation, some things were broken, i.e. vampire coven won't ever show up with original mod
- undead scourge was really broken by this and maybe
- stop messing with spawnlists
- stop messing up item sort order
- no longer interfere with contracts and city situations (there were errors in log)
- fixed spawning artifacts in weak locations (a square negative error)
- do not overwrite huge files both config and bb classes, this used to overwrite changes from vanilla/DLC updates and brought many small issues
- fixed lindwurm armor and helmet, they now both provide acid immunit and random perk
- fixed some artifact prices
- always provide a unique name for an artifact as long as they are available
- fixed artifact weapons type to not contain Weapon (affected Autopilot)

## Compatibility

Safe to add midgame, can't remove. Is also savegame compatible with the old camps mod, i.e. if you have a campaign played with that you can replace it with this, the artifacts with updated attributes won't be regenerated though.

Should be highly compatible with other mods. Tested and works with:

- Reforged
- [Legends][]
- [Item Spawner][item-spawner]


## Install

Download a zip from [NexusMods][] and put it into `data` dir. Requires [modhooks][] of version 20 or newer.


[NexusMods]: https://www.nexusmods.com/battlebrothers/mods/678
[modhooks]: https://www.nexusmods.com/battlebrothers/mods/42

[camps-old]: https://www.nexusmods.com/battlebrothers/mods/195
[sato_balance_mod]: https://github.com/jcsato/sato_balance_mod
[legends]: https://www.nexusmods.com/battlebrothers/mods/60
[item-spawner]: https://www.nexusmods.com/battlebrothers/mods/583
