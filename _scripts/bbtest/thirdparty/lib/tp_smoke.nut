// Shared body of the third-party smoke tests: registered mods, an AI battle, days, save/load.
::TPSmoke <- {
    hasMod = function (id) {
        if ("Hooks" in getroottable() && ::Hooks.hasMod(id)) return true;
        return "mods_isRegistered" in getroottable() && ::mods_isRegistered(id);
    }
    // Registers the standard smoke tests for a mod set; `ids` are the mods that must be registered.
    register = function (test, ids, spawn = "BanditRaiders") {
        test("registered", function (t) {
            foreach (id in ids) t.ok(::TPSmoke.hasMod(id), id + " registered");
            t.probe("roster", ::World.getPlayerRoster().getAll().len());
        });
        test("battle, days, save/load", function (t) {
            ::BBT.toughen();
            local n = t.roster().len();
            // Reforged's experimental AI logs this in some AI battles headless (runner README)
            local restore = ::BBT.tolerateRfAI();
            yield t.battle({spawn = spawn, resources = 60});
            restore();
            t.probe("result", t.result);
            t.eq(t.result.survivors.enemies, 0, "won");
            t.eq(t.roster().len(), n, "nobody died");
            yield t.days(2);
            t.save("smoke");
            yield t.load("smoke");
            t.eq(t.roster().len(), n, "roster after load");
        });
    }
};
