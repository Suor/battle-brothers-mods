::mods_registerMod("mod_hackflows_perks", 0.5, "Hackflows's Perks Collection");
// TODO: align properly with cook fix
::mods_queue("mod_hackflows_perks", ">mod_hackflows", function() {
    logInfo("load mod_hackflows_perks");
    local inAssetManagerUpdate = false;

    ::mods_hookNewObjectOnce("states/world/asset_manager", function (o) {
        this.logInfo("hp: hook asset_manager");
        local update = o.update;
        o.update = function (_worldState) {
            inAssetManagerUpdate = true;
            update(_worldState);
            inAssetManagerUpdate = false;
        }
    })

    local boneInjuries = [
        "injury.broken_leg"
        "injury.broken_ribs"
        "injury.fractured_elbow"
        "injury.fractured_hand"
        "injury.fractured_ribs"
        "injury.fractured_skull"
        "injury.smashed_hand"
    ]
    ::mods_hookExactClass("entity/tactical/actor", function (cls) {
        local setHitpoints = cls.setHitpoints;
        cls.setHitpoints = function (_h) {
            if (inAssetManagerUpdate && _h > this.m.Hitpoints) {
                local fleshOnTheBones = false;
                local bonesOk = true;
                foreach (skill in this.m.Skills.m.Skills) { // -> skills_container -> actual array
                    if (skill.isGarbage()) continue;

                    local id = skill.getID();
                    if (id == "perk.flesh_on_the_bones") fleshOnTheBones = true;
                    if (boneInjuries.find(id) != null) bonesOk = false;
                }
                if (fleshOnTheBones && bonesOk) _h += _h - this.m.Hitpoints;
            }

            setHitpoints(_h);
        }
    })
})
