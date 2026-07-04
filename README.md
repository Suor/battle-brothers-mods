# Battle Brothers Mods

A collection of mods to make Battle Brothers more fun and comfy. Written by me or fixed by me. You can also take a look at [my Nexus Mods page][nexus-mods], which have releases of many of these.

## New Content

| Name | Description |
---|---
[Accessory Companions (Fixed)](AC) | Tame beasts as companions, level them up and have them gain new attributes and skills. A fixed and improved version of [the original][ac-old] by Vazl.
[Camps and Artifacts (Reworked)](camps_and_artifacts) | Adds extra strong lairs and artifacts. A fixed and extended version of the old [Extended Camps][camps-old].
**[Hackflow's Perks](hackflows_perks)** | Adds several perks either collected or newly crafted.
[Immortal Warriors](immortal_warriors) | Get several warriors who are reborn after death.
**[Nicknames for Everyone](nicknames)** | Gives every brother a nickname that fits who he is, earned by background, traits, attributes, talents, perks or injuries.
[Proper Druid](druid) | A hedge-mage background calling the beasts of the wild to fight at his side. With two custom perk paths and a dedicated origin.
[Proper Necro](necro) | A hirable Necromancer, with custom perks and an origin.
**[Standout Enemies](standout_enemies)** | Randomly adds some quirks to the most common enemies making fighting them less repetitive and more fun.

## Gameplay and Balance

| Name | Description |
---|---
[Better Beast Loot](mod_beast_loot) | Better loot from beasts, makes them worth fighting.
**[Bro Studio](bro_studio)** | Customize bro level ups: talents, perk points, traits, attribute gain.
[Challenges](challenges) | Configurable challenges to make runs harder and more unique: less loot, blind or restricted hiring, gear bans and more.
[Cheap Meat](cheap_meat) | Cheaper bros and tryots.
**[Elite Few - Master Bros](elite_few)** | A rewrite of the old [The Elite Few - Master Bros][elite-few-old], aimed at better compatibility with other mods and newer DLCs. Plus some fixes.
**[Hackflow's Permanent Injuries](perma)** | Less severe, more balanced and more fun permanent injuries.
**[Retinue Promotions](retinue_ups)** | Allows promoting followers to make them extra useful.
[Starting Perks by Background](background_perks) | Gives brothers a chance to have certain perks unlocked from start depending on their background. A rewrite of the [old mod][background-perks-old] by CleverFool.
[Useful Things](useful) | Makes some weaker things more useful, like 2h flails and named goblin weapons.

## Fixes and Convenience

| Name | Description |
---|---
**[Autopilot New](autopilot)** | Automate repeating orders or turn BB into Autobattler.
[Bro Renamer](renamer) | Autochange each bro title to his profession + roman number.
[Cook and Blacksmith Fix](heal_repair_fix) | Fixes Cook and Blacksmith speeding up healing and repairing.
[Events and Ambitions Delayed Fix](events_delayed_fix) | Removes unpredicatably long delays before events and ambitions are fired.
**[Fun Facts](fun_facts)** | Collects and shows some fun facts about your bros.
[Hackflow's Translations](translations) | Russian translations for a handful of third-party mods, works via [Rosetta][rosetta].
[More Blood](more_blood) | Makes it more Tarantino style. A compatible variant of older [More Blood][more-blood-old] mod.

<!-- renamer -->


## See Also

- [More Backgrounds and Events (Updated)](https://github.com/Suor/battle-brothers-xbe) - a content and gameplay mod aimed to make hiring brothers fresh and fun
- [stdlib](https://github.com/Suor/battle-brothers-stdlib) - an assortment of various utils to help coding mods


## Installation

The easiest way is to go to [NexusMods][nexus-mods] and download a zip release from there. Some of these mods are not there yet, also here you can find the latest versions (which might be broken, but usually not). Anyway to get the latest version you'll need:

1. Get this repo locally - either `git clone` or just [download ZIP][zip] and unpack.
2. Go to a subdir of a desired mod.
3. Zip all the dirs there - either manually or execute `make zip`.
4. Put it to `data` folder as usual, make sure removing older zip of the same mod.

Don't forget to install any required deps, these are usually listed in the mod README.


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


## Migrate Hooks script

Is a python script to convert mods using Adam's hooks to Modern ones.

```
Usage:
    python migrate_hooks.py <mod-file> [options]

Arguments:
    <mod-file>  The path to a mod file to convert

Options:
    -i      Update file inplace, will create a <mod-file>_new.nut by default
    -mVAR   Use this var name for whatever ::Hooks.register() returns, defaults to `mod`
    -h      Show this help
```

This doesn't do dirs at the moment, instead you may use bash if you have it:

```bash
find path/to/mod/ -name \*.nut -exec python migrate_hooks.py {} -i \;
```


[nexus-mods]: https://www.nexusmods.com/battlebrothers/users/97435548?tab=user+files
[zip]: https://github.com/Suor/battle-brothers-mods/archive/refs/heads/master.zip

[ac-old]: https://www.nexusmods.com/battlebrothers/mods/314
[autopilot-old]: https://www.nexusmods.com/battlebrothers/mods/62
[rosetta]: https://www.nexusmods.com/battlebrothers/mods/802
[camps-old]: https://www.nexusmods.com/battlebrothers/mods/195
[elite-few-old]: https://www.nexusmods.com/battlebrothers/mods/253
[background-perks-old]: https://www.nexusmods.com/battlebrothers/mods/70
[more-blood-old]: https://www.nexusmods.com/battlebrothers/mods/28
