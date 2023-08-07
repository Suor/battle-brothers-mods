::mods_registerMod("mod_beast_loot", 0.11, "Beast Loot");
::mods_queue("mod_beast_loot", "mod_hooks(>=19)", function() {
    this.logInfo("bl: loading mod_beast_loot");

    ::mods_hookDescendants("scenarios/world/starting_scenario", function(cls) {
        // this.logInfo("bl: hook " + cls.m.ID);
        local onInit = "onInit" in cls ? cls.onInit : null;
        cls.onInit <- function() {
            if (onInit) onInit();
            this.World.Assets.m.ExtraLootChance += 50;
            // this.logInfo("bl: init " + this.m.ID + " ExtraLootChance = " + this.World.Assets.m.ExtraLootChance);
        }
    });
});
