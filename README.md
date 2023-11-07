# Battle Brothers Mods

A collection of mods to make Battle Brothers more fun and comfy. Written by me or fixed by me. You can also take a look at [my Nexus Mods page][nexus-mods], which have releases of many of these.

| Name | Description |
---|---
[Autopilot New](autopilot) | Makes bros use more skills smarter and fixes some crashes. Compatible with Swifter. My version of [Adam's Autopilot][autopilot-old].
[Better Beast Loot](mod_beast_loot) | Better loot from beasts, makes them worth fighting.
[Bro Renamer](renamer) | Autochange each bro title to his profession + roman number.
**[Bro Studio](bro_studio)** | Customize bro level ups: talents, perk points, traits, attribute gain.
[Camps and Artifacts (Reworked)](camps_and_artifacts) | Adds extra strong lairs and artifacts. A fixed version of the old [Extended Camps][camps-old].
[Cheap Meat](mod_cheap_meat) | Cheaper bros and tryots.
[Cook and Blacksmith Fix](heal_repair_fix) | Fixes Cook and Blacksmith speeding up healing and repairing.
**[Elite Few - Master Bros](elite_few)** | A rewrite of the old [The Elite Few - Master Bros][elite-few-old], aimed at better compatibility with other mods and newer DLCs. Plus some fixes.
[Events and Ambitions Delayed Fix](events_delayed_fix) | Removes unpredicatably long delays before events and ambitions are fired.
[Fun Facts](fun_facts) *(Alpha)* | Collects and shows some fun facts about your bros.
**[Hackflow's Perks](hackflows_perks)** | Adds several perks either collected or newly crafted. 
[Starting Perks by Background](mod_background_perks) | Gives brothers a chance to have certain perks unlocked from start depending on their background. A rewrite of the [old mod][background-perks-old] by CleverFool.
**[Standout Enemies](standout_enemies)** | Randomly adds some quirks to the most common enemies making fighting them less repetitive and more fun.
[Veteran Attrs and Perks](mod_vap) | Veterans will sometimes get better than just 1 for attributes they have talents in. Also gives extra perks for them at certain levels.
[More Blood](more_blood) | Makes it more Tarantino style. A compatible variant of older [More Blood][more-blood-old] mod.

<!-- [Brogen](brogen) | An alternative to Ultra Bros -->
<!-- [Useful Things](useful) | Some things made more useful: nets, hand to hand, ... -->


## Installation

The easiest way is to go to [NexusMods][nexus-mods] and download a zip release from there. Some of these mods are not there yet, also here you can find the lastest versions (which might be broken, but not usually). Anyway to get the latest version you'll need:

1. Get this repo locally - either `git clone` or just [download ZIP][zip] and unpack.
2. Go to a subdir of a desired mod.
3. Zip all the dirs there - either manually or execute `make zip`.
4. Put it to `data` folder as usual, make sure removing older zip of the same mod.

**TODO:** say about deps


## Feedback

Any suggestions, bug reports, other feedback are welcome. The best place for it is this Github, i.e. just create an issue. Or you can post or create a bug on [NexusMods][nexus-mods] on a specific mod page.


## Using This Code

My code here is [BSD licensed](LICENSE), which basically means you may use it for any purposes, including bundling it or its parts as part of your stuff, either public or private. Don't need to explicitly ask for permission. However, if you do distribute such your work then you should say you are using this in your docs/README/description/whatever.


## Hookify

Is a python script to convert old-style "copy and edit" mod files to hooks.

```
Usage:
    python hookify.py <mod-file> [<to-file>] [options]
    python hookify.py <mod-dir> [options]

Arguments:
    <mod-file>  The path to a mod file to convert
    <to-file>   File to write hooks code to, defaults to <mod-name>/path/to/class.nut,
                use - to print to stdout instead
    <mod-dir>   Process all *.nut files in a dir

Options:
    -f          Overwrite existing files
    -t          Use tabs instead of spaces
    -v          Verbose output
    -h, --help  Show this help
```

The intended workflow is:

1. Set the SCRIPTS var at the top of your file to point to a base scripts dir, this is either vanilla decompiled scripts or legends ones - if you base your mod on that.
2. Run `python hookify.py your_module_dir/`.
3. *(Optional).* Open new hook files and edit them so that to not really overwrite the whole function bodies, remove `// START/END NEW CODE` if it's only new code now. Also, may see that some edits are bogus, i.e. unintended or obsolete, drop those - this is very common if your mod file is based on older version of the base file.
4. `::include()` new hook files from your `!mods_preload/mod_your_thing.nut`, note that while config files might be included from the root the hook files should be included from within `::mods_queue()`.
5. Remove the files that were hookified. Here you should be cautious because the files that do not have base equivalent should not be removed - hookify will skip those with `SKIPPED, no vanilla` message.

Steps 2-5 might be done on per file or per subdir basis to make it easier.


[nexus-mods]: https://www.nexusmods.com/battlebrothers/users/97435548?tab=user+files
[zip]: https://github.com/Suor/battle-brothers-mods/archive/refs/heads/master.zip

[autopilot-old]: https://www.nexusmods.com/battlebrothers/mods/62
[camps-old]: https://www.nexusmods.com/battlebrothers/mods/195
[elite-few-old]: https://www.nexusmods.com/battlebrothers/mods/253
[background-perks-old]: https://www.nexusmods.com/battlebrothers/mods/70
[more-blood-old]: https://www.nexusmods.com/battlebrothers/mods/28
