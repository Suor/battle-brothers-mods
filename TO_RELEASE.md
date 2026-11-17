TODO: update main README, maybe split all mods into groups, i.e. content/gameplay/whatever

Ready:


Ready or almost:

- [ ] challenges (0.5.1): Pandora's Hobby compat, Black Pyramid fix, shields off on load fix
    - [ ] CH-L1 under Legends banned followers are offered
- [ ] Bro Studio (1.3.3): origins give levels via updateLevel()
    - [ ] commit rosetta pairs for percents
    - [ ] BS1 "Add good traits" can't be turned off (stdlib)
- [ ] immortal warriors: preserve special traits, mutations, arena fights and other flags
    - [ ] IW1 kills of earlier lives counted again, IW2 Boost Talents keeps old level-up rows, IW-KB1 Legends origins without soul jars
- [ ] camps_and_artifacts: always give ammo for artifact throwing weapons
    - [ ] commit combat location templates (4 locations)
    - [ ] CA-KB1, CA-KB6 (Reforged), CA-KB8 freezing ammo chills, CA-KB16 (Legends)
- [ ] background perks: butcher dagger mastery
    - [ ] too small to release?
    - [ ] Legends: BP-KB4 setStartValuesEx loses args, BP-L1 ~4/100 recruits fail on perks
- [ ] fun_facts (1.1.0 is out): money spent in training halls, "Was payed" typo
    - [ ] commit, incl. new town_training_dialog_module.nut
- [ ] autopilot (2.9.0 is out): help ally skills (Bandages...), Pandora's Hobby, Reforged skills, cleanse, three dog modes
    - [ ] commit quiver fix (throwing weapons, firelances)
    - [ ] 12 open report bugs: A1–A6, KB2–KB6, KB9
- [ ] standout enemies: load after black_pyramid_beasts (uncommitted)
    - [ ] SE-KB1 colors don't come back after the curse, SE-KB2 a resisted curse fails
- [ ] elite few
    - [ ] event/contract masters multiplier = 15 (uncommitted)
    - [ ] add event bro slider, move to sliders from enums (need https://github.com/MSUTeam/MSU/pull/491 or copy of slider code, like challenges do)
    - [ ] EF1 party strength doubles after load, EF2 Clever Recruiter double roll, EF-KB1 Hardened soft lock, EF-KB2 event error, EF-KB3 Reforged dummy, EF-KB10 Legends Deathwish
- [ ] xbe
    - [ ] iterate on excluded
    - [ ] add `make check` same as other mods
- [ ] rosetta
    - [ ] ???
- [ ] renamer: some russian renames (since 2025)

Work needed:

- [ ] translations
    - [x] add more ???
    - [x] fix Swifter translation
    - [ ] make rosetta skip/group texts with number better
    - [ ] make rosetta not load pairs for absent mod
    - [ ] TR1 a price line without a range stays English

Open report bugs in released mods:

- necro: NE1 perk group icon MSU error (Reforged), NE2 Possess icon, NE-KB1 Possess takes enemy zombie, NE-KB2 Mind Meld skips stacking perks
- `retinue_ups`: RU1, RU2, RU-KB1, RU-KB2, RU-L1
- `hackflows_perks`: HP1 Full Force (Reforged), HP-KB2 Lone Wolf text with Sato's
- AC: AC-KB1 Reach 0 (Reforged), AC-KB2 tamed ghoul HP (Hardened)
- `more_blood`: MB1 overwrites ::EventsFix
- `fixes`: FX1; `fix_reforged`: FR1 doesn't boot with Reforged 0.8

WIP:

- `events_delayed_fix`: finish ED_Mult mechanic, strip logInfo / Debug.logRepr from preload

Up to date: AC, `beast_loot`, `cheap_meat`, druid, `hackflows_perks`, `heal_repair_fix`, `more_blood`, necro, `nicknames`, `perma`, `retinue_ups`, `useful`
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

