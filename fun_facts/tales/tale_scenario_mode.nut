// mode: menu
// mods: mod_fun_facts@dev stdlib@dev
// include: lib/helpers.nut

// KNOWN_BUGS #2, open: in the main menu's tactical scenarios (no campaign, no ::World.Statistics)
// a bro's kill goes through Fun Facts' hooks.
test("KB2: a kill in a main-menu scenario", function (t) {
    ::RootState.get("MainMenuState").scenario_menu_module_onPlayPressed(0);
    yield t.until(function () {
        if (!::Tales.inBattle() || ::LoadingScreen.isVisible()) return false;
        local e = ::Tactical.TurnSequenceBar.getActiveEntity();
        return e != null && ::Tales.hostiles().len() > 0;
    }, 3000, "the scenario battle to start");
    t.eq(::Tactical.State.isScenarioMode(), true, "scenario mode");
    local bro = ::Tactical.Entities.getInstancesOfFaction(::Const.Faction.Player)[0];
    local enemy = ::Tales.hostiles()[0];
    t.ok("FunFacts" in bro.m && bro.m.FunFacts != null, "scenario bros get FunFacts");
    local error = null;
    try {
        enemy.kill(bro, ::Tales.attack(bro), ::Const.FatalityType.None);
    } catch (e) {
        error = e;
    }
    t.eq(error, null, "error from the kill");
    t.eq([enemy.isAlive(), enemy.isPlacedOnMap()], [false, false], "the enemy is dead and off the map");
    local inTurnOrder = false;
    foreach (e in ::Tactical.TurnSequenceBar.getAllEntities()) if (e.getID() == enemy.getID()) inTurnOrder = true;
    t.eq(inTurnOrder, false, "the enemy left the turn order");
});
