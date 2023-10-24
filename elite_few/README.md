# Elite Few - Master Bros

A rewrite of the old [The Elite Few - Master Bros][old-mod], aimed at better compatibility with other mods and newer DLCs. Plus some fixes.

Makes some bros "masters" with max attribute rolls, an extra talent and no bad traits. Master bros have:

- max rolls in all attributes, i.e. Sellsword will always have 67 melee skill and 13 melee defense, etc.
- an extra talent - 4 instead of 3 (unless other mods change this)
- 10-50-40 % probabilities for 1-2-3 star(s) in all talents, up from 60-30-10%
- no bad traits, like drunkard or clumsy, this indirectly makes good ones more frequent
- +5 initiative from a special "Master" trait
- +9 extra daily wage

By default the rate at which a brother is a master is

```python
1 in max(30, 100 - 2 * baseWage - [20 if ranged])
```

This means a Hedge Knight and Hunter will have a 1 in 30 chance to be a master, Witchhunter - 1 in 54, and a cripple a 1 in 94. By default indebted cannot be masters.

Each master bro's worth is 25-50% higher when calculating party strength, which affects enemy scaling, sending larger groups of enemies at you. The exact formula:

```python
min(50, baseWage / 2 + 25)
```

Note that only top 12 top level bros (14 for militia and manhunters origins) are taken into account when calculating the party strength, so a newly hired low level master bro might not contribute.


## Configuration

It is possible to configure chance multplier and other stuff via MSU's Mod Options: Esc -> Mod Options -> Elite Few - Master Bros. Consult field tooltips there for more info. 


## Compatibility

Safe to add midgame, can't remove once you have these masters anywhere including city hiring rosters. Set "Select masters" to "none" in Mod Options instead.

- compatible with mods like Ultra Bros, Weighted Talents, Starting Perks by Background and such
- should work with any mods changing bro generation by applying its changes on top
- works with Legends (tested 16.3.3 and 17.0.9)
- works with Accessory Companions (AC) mods


## Changes from the Original Mod

- new icon, not using Old trait icon anymore
- added "dubious" traits list, might be excluded via Mod Options
- allow Bloodthirsty for masters
- added 1 in 30 limit for very high cost backgrounds, multiplier applies on top
- capped strength update at 50%

Compatibily, apart from listed above:

- autodetect ranged origins
- fixed some newer DLC changes overwritten by the original mod
- overall better other mods and future compatibility

Math fixes:

- made talent chances calculation to match the description (there was off by 1 error)
- removed hardcoded to 1 in 10 for gladiator origin, ignoring multiplier
- removed integer division rounding in master chance and party strength calculation


## Install

Download a zip from [NexusMods][] and put it into `data` dir. Requires [modhooks][] of version 20 or newer.


[NexusMods]: https://www.nexusmods.com/battlebrothers/mods/665
[modhooks]: https://www.nexusmods.com/battlebrothers/mods/42
[old-mod]: https://www.nexusmods.com/battlebrothers/mods/253
