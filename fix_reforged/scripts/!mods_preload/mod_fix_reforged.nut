local mod = ::FixReforged <- {
    ID = "mod_reforged_fix"
    Name = "Reforged Fix"
    Version = 0.1
    // Debug = ::std.Debug.with({prefix = "u: "})
}
// local Util = ::std.Util;
::mods_registerMod(mod.ID, mod.Version, mod.Name);

::mods_queue(mod.ID, "mod_reforged, >mod_hackflows_perks, >msu", function () {
    // Make vanilla backgrounds get dynamic perks
    ::mods_hookExactClass("skills/backgrounds/character_background", function (cls) {
        local create = cls.create;
        cls.create = function () {
            this.m.PerkTreeMultipliers = {
                "pg.rf_resilient": 3,
                "pg.rf_trained": 2,
            };
            this.m.PerkTree = ::new(::DynamicPerks.Class.PerkTree).init({
                DynamicMap = {
                    "pgc.rf_exclusive_1": [],
                    "pgc.rf_shared_1": [],
                    "pgc.rf_weapon": [],
                    "pgc.rf_armor": [],
                    "pgc.rf_fighting_style": []
                }
            });
            create();
        }
    })

    if (::mods_getRegisteredMod("mod_hackflows_perks")) {
        local groupToPerks = {
            "pg.rf_sturdy":  [
                [0, "perk.hackflows.flesh_on_the_bones"],
                [4, "perk.hackflows.full_force"],
            ]
            "pg.rf_militia": [[0, "perk.hackflows.flesh_on_the_bones"]]
            "pg.rf_pauper": [[1, "perk.hackflows.flesh_on_the_bones"]]
            "pg.rf_agile": [[3, "perk.hackflows.balance"]]
            "pg.rf_medium_armor": [[4, "perk.hackflows.balance"]]
            "pg.rf_heavy_armor": [[3, "perk.hackflows.full_force"]]
            "pg.rf_large": [[4, "perk.hackflows.full_force"]]
        }

        local add = ::DynamicPerks.PerkGroups.add;
        ::DynamicPerks.PerkGroups.add = function (_perkGroup) {
            add(_perkGroup);
            if (_perkGroup.getID() in groupToPerks) {
                logInfo("fr: add hackflows perks to " + _perkGroup.getID())
                local tree = _perkGroup.m.Trees["default"];
                foreach (pair in groupToPerks[_perkGroup.getID()]) {
                    tree[pair[0]].push(pair[1])
                }
            }
        }

        // local function addToGroup(_group, _row, _perk) {
        //     logInfo("fr: addToGroup " + _group + " " + _perk)
        //     ::mods_hookExactClass("mods/mod_reforged/perk_groups/" + _group, function (cls) {
        //         logInfo("fr: hook " + _group)
        //         local create = cls.create;
        //         cls.create = function () {
        //             create();
        //             logInfo("fr: create " + _group)
        //             this.m.Trees["default"][_row].push(_perk);
        //         }
        //     })
        //     // local tree = ::DynamicPerks.PerkGroups.LookupMap[_group].m.Trees["default"];
        //     // tree[_row].push(_perk);
        // }
        // // std.debug(::DynamicPerks.PerkGroups.LookupMap["pg.rf_heavy_armor"].m.Trees)


        // "perk.hackflows.flesh_on_the_bones", ->
        //     pg_resilient ? militia(1) ? pg_rf_sturdy(1) ? pg_rf_pauper(2)
        // "perk.hackflows.balance" -> agile(4) ? resilient ? medium_armor(4,5) ? pg_rf_sturdy
        // "perk.hackflows.full_force" -> pg_heavy_armor(4,7) ? pg_rf_sturdy(4,5,6)
    }
})
