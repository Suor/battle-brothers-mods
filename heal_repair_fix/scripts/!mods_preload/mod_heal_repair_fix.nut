local mod = ::HealRepairFix <- {
    ID = "mod_heal_repair_fix"
    Name = "Cool and Blacksmith Fix"
    Version = 0.5
}
::mods_registerMod(mod.ID, mod.Version, mod.Name);
::mods_queue(mod.ID, "mod_hooks(>=20)", function () {
    local inAssetManagerUpdate = false;
    local gen = ::rng_new(); // Make our own private generator to not mess with nobody

    ::mods_hookNewObjectOnce("states/world/asset_manager", function (o) {
        local update = o.update;
        o.update = function (_worldState) {
            inAssetManagerUpdate = true;
            update(_worldState);
            inAssetManagerUpdate = false;
        }
    })

    ::mods_hookExactClass("entity/tactical/actor", function (cls) {
        local original = cls.setHitpoints;
        cls.setHitpoints = function (_h) {
            if (!inAssetManagerUpdate || _h <= this.m.Hitpoints) return original(_h);

            // Stohastically round it to store only ints unlike item condition below
            local floor = Math.floor(_h);
            _h = gen.nextFloat() < _h - floor ? floor + 1 : floor;
            original(_h);
        }
    })
    ::mods_hookBaseClass("items/item", function (cls) {
        while (!("setCondition" in cls)) cls = cls[cls.SuperName];
        local original = cls.setCondition;
        cls.setCondition = function( _a ) {
            if (!inAssetManagerUpdate || _a <= this.m.Condition) return original(_a);

            // Add back an old fractional part, which was dropped by .getCondition()
            _a += this.m.Condition - Math.floor(this.m.Condition);
            // We also add 0.015 to compensate for Blacksmith always repairing 3.99 outside camp
            // and 4.985 in, i.e. 3 or 5 first time and only 4 or 6 starting from second one.
            // NOTE: we save some tiny fraction of armor parts on this, which only compensates
            //       the rounding error of replacing 1/15 with 0.067 for ArmorPartsPerArmor when
            //       no camp no Blacksmith, otherwise it's less.
            _a += 0.015;
            // Finally make sure we don't overflow, as it shows "100%" in UI
            original(Math.minf(this.m.ConditionMax, _a));
        }
    })

    // // Debug stuff
    // ::mods_hookExactClass("entity/tactical/actor", function (cls) {
    //     local original = cls.setHitpoints;
    //     cls.setHitpoints = function (_h) {
    //         local oldValue = this.m.Hitpoints;
    //         original(_h);
    //         this.logInfo("hx: setHitpoints " + this.getName() + " " + oldValue
    //             + " -> " + _h + " really " + this.m.Hitpoints)
    //     }
    // })
    // ::mods_hookBaseClass("items/item", function (cls) {
    //     while (!("setCondition" in cls)) cls = cls[cls.SuperName];
    //     local original = cls.setCondition;
    //     cls.setCondition = function( _a ) {
    //         local oldValue = this.m.Condition;
    //         original(_a);
    //         this.logInfo("hx: setCondition " + this.getName() + " " + oldValue
    //              + " -> " + _a + " really " + this.m.Condition);
    //     }
    // })
})
