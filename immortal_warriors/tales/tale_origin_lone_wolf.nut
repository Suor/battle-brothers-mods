// mode: campaign seed=bbtest-battle origin=scenario.lone_wolf
// mods: mod_immortal_warriors@dev stdlib@dev

// KNOWN_BUGS #1 (reported for Lone Wolf under Legends): every origin starts with the jars.
test("IW-KB1: lone_wolf starts with 3 soul jars", function (t) {
    local jars = ::World.Assets.getStash().getItems().filter(@(_, i) i != null && i.getID() == "misc.immortal_soul_jar");
    t.eq(jars.len(), 3, "soul jars in the stash");
});
