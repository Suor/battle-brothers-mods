local mod = ::HackflowsPerks <- {
    ID = "mod_hackflows_perks"
    Name = "Hackflow's Perks"
    Version = 1.0
}

::mods_registerMod(mod.ID, mod.Version, mod.Name);
::mods_queue(mod.ID, ">mod_heal_repair_fix", function() {
    // Hooks for Flesh on the Bones perk
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
    local function fleshOnBonesActive(_player) {
        local fleshOnTheBones = false;
        local bonesOk = true;
        foreach (skill in _player.m.Skills.m.Skills) { // -> skills_container -> actual array
            if (skill.isGarbage()) continue;

            local id = skill.getID();
            if (id == "perk.hackflows.flesh_on_the_bones") fleshOnTheBones = true;
            if (boneInjuries.find(id) != null) bonesOk = false;
        }
        return fleshOnTheBones && bonesOk;
    }

    ::mods_hookExactClass("entity/tactical/actor", function (cls) {
        local setHitpoints = cls.setHitpoints;
        cls.setHitpoints = function (_h) {
            if (inAssetManagerUpdate && _h > this.m.Hitpoints && fleshOnBonesActive(this)) {
                _h += _h - this.m.Hitpoints;
            }
            setHitpoints(_h);
        }
    })

    ::mods_hookExactClass("entity/tactical/player", function (cls) {
        local getRosterTooltip = cls.getRosterTooltip;
        cls.getRosterTooltip = function () {
            local tooltip = getRosterTooltip();
            if (this.getHitpoints() >= this.getHitpointsMax()) return tooltip;
            if (!fleshOnBonesActive(this)) return tooltip;

            foreach (line in tooltip) {
                if (!std.Str.startswith(line.text, "Light Wounds")) continue;

                local rate = ::Const.World.Assets.HitpointsPerHour * 2; // This perk double
                if (("State" in ::World) && ::World.State != null)
                    rate *= ::World.Assets.m.HitpointsPerHourMult;

                local toHeal = this.getHitpointsMax() - this.getHitpoints();
                local days = Math.ceil(toHeal * 1.0 / rate / 24);
                line.text = format("Light Wounds (%i day%s)", days, days > 1 ? "s" : "");
            }
            return tooltip;
        }
    })
})
