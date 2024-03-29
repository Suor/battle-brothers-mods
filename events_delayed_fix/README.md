# Events and Ambitions Delayed Fix

Removes unpredictably long delays before events and ambitions are selected and fired.

**TLDR.** Install this and install [Swifter][], enjoy.


## The Issue and the Fix

Currently Battle Brothers have a bug preventing events and ambitions from occuring while you are going to any enterable location, i.e. a town or a lair, or pursuing an enemy. This means to trigger events you need to either go to a point on a map, stand still, camp or ride caravan.

This resulted in many complaints over the years about ambitions not resolving or coming and events being too rare. This mod removes the restrictions explained above, making events and ambitions way more predictable to appear and progress.

**NOTE 1.** This does not make events more frequent and does not remove or reduce other delays, i.e. after combat, between event fire chance checks, between events fired or event specific cooldowns. For that you may use the [Swifter][] mod, it's event frequency part will be less needed with this fix though. 

**NOTE 2.** After events mechanism started it needs some time to score all the events and pick the one to fire, which has two consequences:

1. If you are running on a global map at x2 or higher speed more in-game time will pass by the moment a event is triggered. The aforemention **Swifter** mod is the only way to compensate this as far as I know.
2. If you save game and then load it then the process will restart, including a random roll whether to start it at all or wait another 2 game hours. The latter will always succeed given enough time since last event, last check and battle though. 

**NOTE 3.** Several things may also fail the event scoring and selection mechanism:

- enemies nearby
- battle occured
- special event interfering, i.e. a reminder to look at retinue
- crysis news: start, progress, end

All of these still require the whole scoring to finish, i.e. calculate scores for all events,
then they are rolled with an error - sum of scores should be updated to exclude events that
won't pass because of any of the above, but it's not so roll might simply miss everything, in which case one would get "no event???" message in the log and the process will start again, same as save/load.

This fix will make things recover faster, still keeping some decent after battle delay. 


## Install

Download a zip from [NexusMods][] and put it into `data` dir. Requires [modhooks][] of version 20 or newer.

[Swifter]: https://www.nexusmods.com/battlebrothers/mods/542
[NexusMods]: https://www.nexusmods.com/battlebrothers/mods/666
[modhooks]: https://www.nexusmods.com/battlebrothers/mods/42
