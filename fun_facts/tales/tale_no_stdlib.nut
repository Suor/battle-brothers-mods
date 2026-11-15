// mode: menu
// mods: mod_fun_facts !stdlib
// allow-errors: ^\[Error SQ\] mod_fun_facts \(Fun Facts\) requires stdlib
// allow-errors: ^\[Error SQ\] Errors occured when validating mod compatibility

// KNOWN_BUGS #6, open: without stdlib the player should get the "requires stdlib" message
// from the mod loader (the errors allowed above, as Modern Hooks words them), not a script
// error from the preload's ::std use. Now the preload's error stops the boot: the launch fails
// with "the index 'std' does not exist" at scripts/!mods_preload/mod_fun_facts.nut:16.
test("KB6: without stdlib the mod reports the dependency", function (t) {
    t.eq(::Hooks.hasMod("mod_fun_facts"), true, "registered");
    t.eq(::Hooks.Popup.m.ForceQuit, true, "the loader's error popup quits the game");
});
