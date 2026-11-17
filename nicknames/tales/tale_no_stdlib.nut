// mode: menu
// mods: mod_nicknames@dev !stdlib
// allow-errors: ^\[Error SQ\] mod_nicknames \(Nicknames for Everyone\) requires stdlib \(stdlib\)$
// allow-errors: ^\[Error SQ\] Errors occured when validating mod compatibility

// KNOWN_BUGS #7, fixed in 0.6.0: without stdlib Modern Hooks names the missing dependency (the
// two errors allowed above) in a popup that quits the game, instead of a hang. Any other error
// at boot, e.g. from mod_nicknames.nut, fails this launch.
test("KB7: without stdlib the mod reports the dependency and the game quits", function (t) {
    t.eq(::Hooks.hasMod("mod_nicknames"), true, "registered");
    t.eq(::Hooks.Popup.m.ForceQuit, true, "Modern Hooks' error popup quits the game");
});
