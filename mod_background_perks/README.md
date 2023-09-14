# Background Perks Mod

This mod gives brothers a chance to begin with certain perks in the perk tree unlocked by default depending on the background they belong to. Based on [Starting Perks by Background][base-mod].

Changes from the base mod:

- added backgrounds from new DLCs
- vary free perks more, chances readjusted
- scale probability by time, later hires have higher chance to get free perks
- fixed The Gifted bug

This is more about fun, but also makes some weaker backgrounds more appealing, might need to hire and fire several times to get a bro with desired perks though.

Scaling works stronger on low chances, i.e. 1% turns into 4%, 5% to 13%, 25% to 40% and 50% only to 62% on day 100, which is the end of the scale. This in part meant to compensate for rare hires later in the game. This is up for rebalancing, as well as perk chances.

Perks given, their chances, scaling and overall are for discussion and balancing. Please create a post if you have ideas.


## Install

Download a zip from [NexusMods][] and put it into `data` dir. Requires [modhooks][] of version 19 or newer.


## Starting perks for non-vanilla backgrounds

If you are creating a mod with new backgrounds or even if you want to add this for backgrounds from some other mod you play then it is possible to do so. For this I expose `::BgPerks.chances` table, which might be complemented like this: 

```squirrel
::mods_queue("mod_extra_bgs", ">mod_background_perks", function () {
    if (!::mods_getRegisteredMod("mod_background_perks")) return;

    ::BgPerks.chances.skirmisher <- {
        "mastery.axe": 15
        "mastery.throwing": 15
    }
    ::BgPerks.chances.master_archer <- {
        "mastery.bow": 100
        "bulls_eye": 50
    }
    
    // Or these might be put to a dedicated file with
    ::include("extra_bgs/background_perks");
});
```

Note that a key in `::BgPerks.chances` is the background ID with `background.` prefix stripped.


[NexusMods]: https://www.nexusmods.com/battlebrothers/mods/661
[modhooks]: https://www.nexusmods.com/battlebrothers/mods/42
[base-mod]: https://www.nexusmods.com/battlebrothers/mods/70
