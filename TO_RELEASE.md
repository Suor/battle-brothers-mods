Ready:

- [x] necro: fixed double raise loot lost, fixed arena giving raised loot
- [x] `camps_and_artifacts`
    - [x] look into durability 2 shields
- [ ] AC
    - [ ] move to mods saving history, i.e. original version, my modifications as separate commit
- [x] stdlib 2.6
- [ ] background perks
    - [ ] too small to release?

Ready or almost:

- [ ] nicknames (0.7.0)
    - [x] NE factors
    - [ ] testing new factors ok
- [ ] challenges
    - [x] test last loot changes
    - [ ] screenshots
        - [ ] 4 mod options screens
        - [x] loot screen with capped items
        - [ ] ridiculously costly food screen ?
    - [x] test scaling works or exclude
    - [ ] test no firing
- [ ] fun_facts
    - [ ] test killed/chopped ...
    - [ ] req. new rosetta (clonable/setdelegate ::Rosetta feature)
- [ ] bro studio
    - [ ] req. stdlib 2.6
- [ ] druid
    - [ ] some extra testing
    - [ ] test with no Reforged
    - [ ] autopilot (but not strictly req.)
    - [ ] AC (soft dep)

Work needed:

- [ ] xbe
    - [ ] iterate on excluded
    - [ ] add `make check` same as other mods
- [ ] translations
    - [x] add more ???
    - [ ] fix Swifter translation
        - [ ] make rosetta skip/group texts with number better
    - [ ] make rosetta not load pairs for absent mod
- [ ] autopilot
    - [ ] test druid behaviors more
- [ ] elite few
    - [ ] add event bro slider, move to sliders from enums (need https://github.com/MSUTeam/MSU/pull/491 or copy of slider code, like challenges do)

WIP:

- `events_delayed_fix`: finish ED_Mult mechanic, strip logInfo / Debug.logRepr from preload

Up to date: `cheap_meat`, `beast_loot`, `hackflows_perks`, `heal_repair_fix`, `immortal_warriors`, `more_blood`, `perma`, `renamer`, `retinue_ups`, `standout_enemies`, `useful`
Internal: stupid_game, fixes, `fix_reforged`
Dead: random_perk, vap


# Instructions

Use `make cl` to help update the above.

## Preparing a Release

1. Check for things unfhished:
    - functionality not in full
    - bugs
    - not enough testing done - code too hot
2. Check for deps unpublished, including stdlib and rosetta
3. Commit the mod changes in semantical commits. Follow the style, do not be verbose. Do not commit nor stage any changes not belonging to the mod.
4. Update README to respect the new changes. This doesn't mean it should become more verbose.
5. Prepare a changelog entry, use `clsub` in mods subdir to draft it. If git changelog is not clear look into actual changes. Changelog should mostly be a single line per change.
6. Up a version, everywhere: mod_*.nut, rosetta or whatever - grep for existing version.
7. Build a zip: first as is, switch off any debugs, commit version up, make a tag, i.e. necro-0.6.0, make a proper zip - it should not get `_MODIFIED` suffix.

