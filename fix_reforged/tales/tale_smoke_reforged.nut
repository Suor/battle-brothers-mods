// mode: campaign seed=bbtest-battle fresh=1
// mods: mod_reforged_fix_custom_backgrounds@dev stdlib@dev
// FR1: with Reforged 0.8.18 and 0.9.3 every background's create() throws (`the index 'PerkTreeMultipliers' does not
// exist`, mod_fix_reforged.nut:15). Each is logged and the game goes on: on 0.9.3 the launch errors at the campaign
// start and the battle test fails on the backgrounds rolled during its days; see FOUND_BUGS.md.

::Tales.smokeTests("mod_reforged_fix_custom_backgrounds", "smoke reforged");
