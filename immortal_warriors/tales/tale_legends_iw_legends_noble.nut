// mode: campaign seed=bbtest-battle origin=scenario.legends_noble
// mods: mod_legends==19.4.23 mod_immortal_warriors@dev stdlib@dev

// KNOWN_BUGS immortal_warriors #1 on real Legends 19.4.23: the origin starts with the soul jars.
test("IW-KB1 legends: scenario.legends_noble starts with 3 soul jars", function (t) {
    t.eq(::World.Assets.getOrigin().getID(), "scenario.legends_noble", "origin");
    local jars = ::World.Assets.getStash().getItems().filter(@(_, i) i != null && i.getID() == "misc.immortal_soul_jar");
    t.eq(jars.len(), 3, "soul jars in the stash");
    local so = ::World.Assets.getOrigin().onSpawnAssets;
    t.probe("onSpawnAssets source", so.getinfos().src);
});
