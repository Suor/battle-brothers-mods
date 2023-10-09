local mod = ::HackflowsPerks <- {
    ID = "mod_hackflows_perks"
    Name = "Hackflow's Perks"
    Version = 1.0

    BoneInjuries = [
        "injury.broken_leg"
        "injury.broken_nose"
        "injury.broken_ribs"
        "injury.fractured_elbow"
        "injury.fractured_hand"
        "injury.fractured_ribs"
        "injury.fractured_skull"
        "injury.smashed_hand"
    ]
    function fleshOnBonesActive(_player) {
        local fleshOnTheBones = false;
        local bonesOk = true;
        foreach (skill in _player.m.Skills.m.Skills) { // -> skills_container -> actual array
            if (skill.isGarbage()) continue;

            local id = skill.getID();
            if (id == "perk.hackflows.flesh_on_the_bones") fleshOnTheBones = true;
            if (this.BoneInjuries.find(id) != null) bonesOk = false;
        }
        return fleshOnTheBones && bonesOk;
    }
}
local Str = ::std.Str, Text = ::std.Text;

::mods_registerMod(mod.ID, mod.Version, mod.Name);
::mods_queue(mod.ID, "stdlib, >mod_heal_repair_fix", function() {
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

    ::mods_hookExactClass("entity/tactical/actor", function (cls) {
        local setHitpoints = cls.setHitpoints;
        cls.setHitpoints = function (_h) {
            if (inAssetManagerUpdate && _h > this.m.Hitpoints && mod.fleshOnBonesActive(this)) {
                _h += _h - this.m.Hitpoints; // Double the addition
            }
            setHitpoints(_h);
        }
    })

    ::mods_hookExactClass("entity/tactical/player", function (cls) {
        local getRosterTooltip = cls.getRosterTooltip;
        cls.getRosterTooltip = function () {
            local tooltip = getRosterTooltip();
            if (this.getHitpoints() >= this.getHitpointsMax()) return tooltip;
            if (!mod.fleshOnBonesActive(this)) return tooltip;

            foreach (line in tooltip) {
                if (!Str.startswith(line.text, "Light Wounds")) continue;

                local rate = ::Const.World.Assets.HitpointsPerHour * 2; // This perk doubles it
                if (("State" in ::World) && ::World.State != null)
                    rate *= ::World.Assets.m.HitpointsPerHourMult;

                local toHeal = this.getHitpointsMax() - this.getHitpoints();
                local days = ::Math.ceil(toHeal * 1.0 / rate / 24);
                line.text = format("Light Wounds (%i day%s)", days, Text.plural(days));
            }
            return tooltip;
        }
    })

    // Injury hint thinks there is only one reason to ignore injuries.
    // This is not true even without this mod. Cultist prophet also ignores them.
    ::mods_hookExactClass("skills/injury/injury", function (cls) {
        local addTooltipHint = cls.addTooltipHint;
        cls.addTooltipHint = function (_tooltip) {
            addTooltipHint(_tooltip);
            if (!mod.fleshOnBonesActive(this.getContainer().getActor())) return;

            foreach (line in _tooltip) {
                if (Str.endswith(line.text, "Iron Will effect"))
                    line.text = Str.replace(line.text, "Iron Will effect", "Flesh on the Bones")
            }
        }
    })
})
