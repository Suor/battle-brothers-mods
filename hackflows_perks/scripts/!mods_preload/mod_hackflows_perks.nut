local def = ::HackflowsPerks <- {
    ID = "mod_hackflows_perks"
    Name = "Hackflow's Perks"
    Version = "1.6.1"
    Updates = {
        nexus = "https://www.nexusmods.com/battlebrothers/mods/673"
        github = "https://github.com/Suor/battle-brothers-mods/tree/master/hackflows_perks"
        tagPrefix = "hackflows-perks-"
    }

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
        foreach (skill in _player.m.Skills.m.Skills) { // -> skills_container -> actual array
            if (skill.isGarbage()) continue;

            local id = skill.getID();
            if (id == "perk.hackflows.flesh_on_the_bones") fleshOnTheBones = true;
            if (this.BoneInjuries.find(id) != null) return false;
        }
        return fleshOnTheBones;
    }
}
local Str = ::std.Str, Text = ::std.Text;

::include("scripts/hp_rosetta_ru");

local mod = def.mh <- ::Hooks.register(def.ID, def.Version, def.Name);
mod.require("stdlib");
mod.queue(">stdlib", ">mod_heal_repair_fix", ">mod_reforged", function () {
    // Hooks for Flesh on the Bones perk
    mod.hook("scripts/entity/tactical/actor", function (q) {
        q.setHitpoints = @(__original) function (_h) {
            if (_h > this.m.Hitpoints && def.fleshOnBonesActive(this)) {
                local hp = this.m.Hitpoints, h = _h;
                _h += _h - ::Math.max(0, this.m.Hitpoints); // Double the addition
            }
            __original(_h);
        }
    })

    // Double Nine Lives too, it sets hitpoints directly so the above won't work.
    // Modular Vanilla changes that to .setHitpoints()
    if (!::Hooks.hasMod("mod_modular_vanilla")) {
        mod.hook("scripts/skills/perks/perk_nine_lives", function (q) {
            q.setSpent = @(__original) function (_f) {
                if (!_f || !def.fleshOnBonesActive(this.getContainer().getActor())) return __original(_f);

                local actor = this.getContainer().getActor();
                actor.m.Hitpoints = ::Math.min(actor.m.Hitpoints * 2, actor.getHitpointsMax());
                return __original(_f);
            }
        })
    }

    mod.hook("scripts/entity/tactical/player", function (q) {
        // These are not calculated correcly if Flesh on the Bones is in effect
        q.getDaysWounded = @(__original) function () {
            if (!def.fleshOnBonesActive(this)) return __original();

            local mult = ::World.Assets.m.HitpointsPerHourMult;
            ::World.Assets.m.HitpointsPerHourMult *= 2;
            local days = __original();
            ::World.Assets.m.HitpointsPerHourMult = mult;

            return days;
        }

        // This does not use .getDaysWounded() in vanilla code, so need to hook it too
        q.getRosterTooltip = @(__original) function () {
            local tooltip = __original();
            if (this.getHitpoints() >= this.getHitpointsMax()) return tooltip;
            if (!def.fleshOnBonesActive(this)) return tooltip;

            foreach (line in tooltip) {
                if ("icon" in line && line.icon == "ui/icons/days_wounded.png") {
                    local days = this.getDaysWounded();
                    line.text = format("Light Wounds (%i day%s)", days, Text.plural(days));
                }
            }
            return tooltip;
        }
    })

    // Injury hint thinks there is only one reason to ignore injuries.
    // This is not true even without this mod. Cultist prophet also ignores them.
    mod.hook("scripts/skills/injury/injury", function (q) {
        q.addTooltipHint = @(__original) function (_tooltip) {
            __original(_tooltip);
            if (!def.fleshOnBonesActive(this.getContainer().getActor())) return;

            foreach (line in _tooltip) {
                if (line.id == 7 && line.type == "text" && line.icon == "ui/icons/warning.png") {
                    line.text = "Will take effect only after combat ends due to the Flesh on the Bones effect";
                    break;
                }
            }
        }

        q.onAdded = @(__original) function () {
            __original();
            // All non-bone injuries heal 1 day faster with Flesh on the Bones
            if (m.IsNew && def.BoneInjuries.find(m.ID) == null
                    && getContainer().hasSkill("perk.hackflows.flesh_on_the_bones")) {
                addHealingTime(-1);
            }
        }
    })

    // Add these perks to Reforged perk trees.
    // Do not use Stabilized: Reforged has its own medium armor perk.
    // Bloody Harvest is kind of superseded with Death Dealer, doesn't work with ranged though.
    // And Reforged has an unpolished version of Battle Flow.
    if (::Hooks.hasMod("mod_reforged")) {
        local groupToPerks = {
            "pg.rf_soldier":  [[0, "perk.hackflows.flesh_on_the_bones"]]
            "pg.rf_militia": [[0, "perk.hackflows.flesh_on_the_bones"]]
            "pg.rf_pauper": [[1, "perk.hackflows.flesh_on_the_bones"]]
            "pg.rf_vigorous": [[0, "perk.hackflows.flesh_on_the_bones"]]
            "pg.rf_agile": [[4, "perk.hackflows.balance"]]
            "pg.rf_power": [[5, "perk.hackflows.full_force"]]
            "pg.rf_medium_armor": [[4, "perk.hackflows.balance"]]
            "pg.rf_heavy_armor": [[5, "perk.hackflows.full_force"]] // ???
            "pg.rf_large": [[4, "perk.hackflows.full_force"]]
        }

        local add = ::DynamicPerks.PerkGroups.add;
        ::DynamicPerks.PerkGroups.add = function (_perkGroup) {
            if (_perkGroup.getID() in groupToPerks) {
                local tree = _perkGroup.m.Tree;
                foreach (pair in groupToPerks[_perkGroup.getID()]) {
                    tree[pair[0]].push(pair[1])
                }
            }
            add(_perkGroup);
        }

        ::include("scripts/hackflows_perks/potential");
    }
})

mod.queue(">msu", function () {
     if (!("MSU" in getroottable())) return;
    ::include("scripts/i_hackflows_perks_hack_msu");
    ::HackMSU.setup(def, def.Updates)
});
