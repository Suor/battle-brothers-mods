# Starting Perks by Background

This mod gives brothers a chance to begin with certain perks in the perk tree unlocked by default depending on the background they belong to. Based on [Starting Perks by Background][base-mod].

Changes from the base mod:

- added backgrounds from new DLCs
- vary free perks more, chances readjusted
- scale probability by time, later hires have higher chance to get free perks
- added a way to extend this, see below
- integrates with [Hackflow's Perks][hackperks] mod if both are installed, i.e. gives a chance to receive perks from there
- fixed The Gifted bug

This is more about fun, but also makes some weaker backgrounds more appealing, might need to hire and fire several times to get a bro with desired perks though.

Scaling works stronger on low chances, i.e. 1% turns into 4%, 5% to 13%, 25% to 40% and 50% only to 62% on day 100, which is the end of the scale. This in part meant to compensate for rare hires later in the game. This is up for rebalancing, as well as perk chances.

Perks given, their chances, scaling and overall are for discussion and balancing. Please create a post if you have ideas.


## Install

Download a zip from [NexusMods][] and put it into `data` dir. Requires [modhooks][] of version 20 or newer.


## How these were chosen

This mod is understandably from "fun > balance" variety, however, I wouldn't want to tilt the latter too much either, so giving many perks to a single background is the one thing I tried to avoid. I also like hiring having its randomness, it adds to fun and replayability in my opinion, which guaranteed perks take away. Also should take into account scaling, which grows probabilities from day 1 to day 100, say 10% turns into 21% by day 100 and to 15% by day 50.

I will summarize my take on all of this into points:

1. Shy away from 100% perks unless it's sort of presumed by background, e.g. Swordmaster. Also allow this more for perks with little immediate or overall benefit, like Student or Quick Hands.
2. Do not give too many perks to a single background, even with a small probabilities. The reasons are scaling and some random generator quirks, which sometimes makes many perks fire at once. The exeption here is weapon masteries as they cannot be used together anyway.
3. Give more for particularly weak backgrounds like Cripple and Historian as long as this feels fitting. 
4. When I want to give a perk for role playing/flavour reason, which might break the balance, I would do so with a small probability - 3-7%. This plus scaling is enough to occasionally get it.
5. I don't want this to become repetative, so I removed a chance to have Resilient, Relentless and Adrenaline for everyone, even small one. I also try to use less some frequent ones and more some rarer ones. 
6. On top of the previous point spamming Resilient will make various curses, poisons and other effects less relevant for little investment from a player. I didn't want to shut down the entire mechanic like this.
7. Finally some stuff was left from the original mod, I made a couple of passes around everything, but when in doubt I tended to leave things as is or only adjust probabilities as a tribute to the original mod author.


## Starting perks for non-vanilla backgrounds

If you are creating a mod with new backgrounds or even if you want to add this for backgrounds from some other mod you play then it is possible to do so. For this I expose `::BgPerks.chances` table, which might be complemented like this: 

```squirrel
::mods_queue("mod_extra_bgs", ">mod_background_perks", function () {
    if (!::mods_getRegisteredMod("mod_background_perks")) return;

    ::BgPerks.chances.skirmisher <- {
        "mastery.axe": 15
        "mastery.throwing": 15  // 15% chance of having each rolled indepently
    }
    ::BgPerks.chances.master_archer <- {
        "mastery.bow": 100  // will always have this at start
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
[hackperks]: https://www.nexusmods.com/battlebrothers/mods/673
