# Cook and Blacksmith Fix

Currently cook **does not** speed up healing and blacksmith only partially works when camping, due to a [rounding bug](https://steamcommunity.com/app/365360/discussions/1/3721692478292060034/). This mod fixes this, now both of them give the advertised <span style="color: #239223">+33%</span> healing and repairing speed bonus.

However, this mod will also fixes the rounding for camping itself. It has intended to give <span style="color: #239223">+50%</span> for both healing and repairing, which after rounding gives us double healing both with or without cook, repairing is bugged in a more convoluted way. All these can be summarized into a couple of tables:

| Healing, hps/hour | Vanilla | Camping, Vanilla | Fixed | Camping, Fixed
|---|---|---| --- | ---
|No Cook | 1  | 2 | 1 | 1.5
|Cook    | 1  | 2 | 1.33 | 1.995

| Repairing, pts/hour | Vanilla | Camping, Vanilla | Fixed | Camping, Fixed
|---|---|---| --- | ---
|No Blacksmith | 3  | 4 | 3 | 4.5
|Blacksmith    | 3  | 5 | 4 | 6

I.e. with this fix a guy always gives <span style="color: #239223">+33%</span> and camping <span style="color: #239223">+50%</span>, these both combined give double rate.


## Install

Download a zip from [NexusMods][] and put it into `data` dir. Requires [modhooks][] of version 20 or newer.

[NexusMods]: https://www.nexusmods.com/battlebrothers/mods/668
[modhooks]: https://www.nexusmods.com/battlebrothers/mods/42
