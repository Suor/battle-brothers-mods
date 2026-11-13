// Shared body of bp_load*.nut: a save loaded in the running campaign vs. as from the main menu.
::BPLoad <- {
    items = function () {
        local n = 0;
        foreach (bro in ::World.getPlayerRoster().getAll()) n += bro.getItems().getAllItems().len();
        return n;
    }
    register = function (test) {
        test("load in the running campaign", function (t) {
            local n = [t.roster().len(), ::BPLoad.items()];
            t.save("bp_load");
            yield t.load("bp_load");
            t.eq([t.roster().len(), ::BPLoad.items()], n, "roster and its items");
        });
        // A load from the main menu (after starting the game or quitting to the menu) runs in a new world_state
        // whose World.Flags is empty while the roster loads: the rosters load before world_state.onDeserialize
        // restores the flags. New empty flags give the same; `--snapshot` loads through the main menu itself.
        test("load as from the main menu", function (t) {
            local n = [t.roster().len(), ::BPLoad.items()];
            t.save("bp_load");
            ::World.State.m.Flags = ::new("scripts/tools/tag_collection");
            ::World.Flags = ::World.State.m.Flags;
            yield t.load("bp_load");
            t.eq([t.roster().len(), ::BPLoad.items()], n, "roster and its items");
        });
    }
};
