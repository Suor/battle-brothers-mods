local mod = ::RetinueUps <- {
    ID = "mod_retinue_ups"
    Name = "Retinue Promotions"
    Version = 0.7
}

local function positive(value) {
    return ::Const.UI.getColorized(value + "", ::Const.UI.Color.PositiveValue)
}

::mods_registerMod(mod.ID, mod.Version, mod.Name);
::mods_queue(mod.ID,
        "mod_hooks(>=20), >sato_balance_mod, >tnf_expandedRetinue, >mod_more_followers",
        function() {
    ::mods_registerJS("retinue_ups.js");

    ::mods_hookNewObject("retinue/retinue_manager", function (obj) {
        local setFollower = obj.setFollower;
        obj.setFollower = function(_slot, _follower) {
            // When follower is replaced it looses its promotion
            local prev = this.m.Slots[_slot];
            if (prev != null) this.ru_demote(prev);
            return setFollower(_slot, _follower);
        }

        local onDeserialize = obj.onDeserialize;
        obj.onDeserialize = function ( _in ) {
            onDeserialize(_in);
            // Update costs and effects
            foreach (f in this.m.Followers) {
                if (this.ru_isPromoted(f)) f.ru_onPromote();
            }
        }

        // TODO: check the presense of a follower, i.e. one might remove the mod,
        //       replace the follower, reinstall the mod and reap the promotion effects sometimes.
        obj.ru_isPromoted <- function (follower) {
            local clsName = typeof follower == "string" ? follower : follower.ClassName;
            return ::World.Flags.has("mod_retinue_ups." + clsName);
        }
        obj.ru_promote <- function (follower) {
            ::World.Flags.add("mod_retinue_ups." + follower.ClassName);
            follower.ru_onPromote();
        }
        obj.ru_demote <- function (follower) {
            ::World.Flags.remove("mod_retinue_ups." + follower.ClassName);
            follower.ru_onDemote();
        }
    })

    ::mods_hookNewObject("ui/screens/world/world_campfire_screen", function (obj) {
        obj.ru_onSlotCtrlClicked <- function (_i) {
            local follower = ::World.Retinue.m.Slots[_i];
            ::logInfo("Promote " + _i + " " + follower.getID());
            if (follower == null
                    || !follower.ru_hasPromotion() || ::World.Retinue.ru_isPromoted(follower)) {
                return {Result = 999} // Do nothing
            }

            local currentMoney = ::World.Assets.getMoney();
            local promoteCost = follower.m.ru_promotion.Cost;
            if (currentMoney < promoteCost) {
                return {Result = ::Const.UI.Error.NotEnoughMoney}
            }

            ::World.Retinue.ru_promote(follower);
            ::World.Assets.addMoney(-promoteCost);
            ::World.State.updateTopbarAssets();
            this.refresh();
            return {Result = 0}
        }

        // Both tnf_expandedRetinue and mod_more_followers may set slot to null, after which they
        // call this. Here we check if deleted one should be demoted and also recalc asset values.
        local refresh = obj.refresh;
        obj.refresh = function () {
            local R = ::World.Retinue;
            foreach (f in R.m.Followers) {
                if (R.ru_isPromoted(f) && R.m.Slots.find(f) == null) R.ru_demote(f)
            }
            // This is a bug that those two modules don't do this recalc, we clean up after them.
            // Might move to the click handler above otherwise.
            ::World.Assets.resetToDefaults();
            refresh();
        }
    });

    ::mods_hookBaseClass("retinue/follower", function (cls) {
        cls = cls[cls.SuperName];

        local getName = cls.getName;
        cls.getName = function () {
            return getName() + (::World.Retinue.ru_isPromoted(this) ? " (Promoted)" : "")
        }

        local getTooltip = cls.getTooltip;
        cls.getTooltip = function () {
            local tooltip = getTooltip();
            if (this.ru_hasPromotion() && !::World.Retinue.ru_isPromoted(this)) {
                tooltip.push({
                    id = 1
                    type = "hint"
                    icon = "retinue_ups/mouse_left_button_ctrl.png"
                    text = "Promote " + this.m.ru_promotion.Tease + ", costs "
                        + this.m.ru_promotion.Cost + "[img]gfx/ui/tooltips/money.png[/img]"
                });
            }
            return tooltip;
        }

        cls.ru_hasPromotion <- function () {return "ru_promotion" in this.m}
        cls.ru_onPromote <- function () {
            this.m.ru_base <- {
                Cost = this.m.Cost
                Effects = clone this.m.Effects
            }

            local up = this.m.ru_promotion;
            this.m.Cost += up.Cost;  // Add cost for expanded retinue/more followers refund
            if ("Effects" in up) this.m.Effects.extend(up.Effects);
        }
        cls.ru_onDemote <- function () {
            this.m.Cost = this.m.ru_base.Cost;
            this.m.Effects = this.m.ru_base.Effects;
        }
    })

    // Second tier Bounty Hunter
    ::mods_hookExactClass("retinue/followers/bounty_hunter_follower", function (cls) {
        cls.m.ru_promotion <- {Cost = 7000, Tease = "for even more champions"}

        local onUpdate = cls.onUpdate;
        cls.onUpdate = function() {
            ::World.Assets.m.ChampionChanceAdditional = ::World.Retinue.ru_isPromoted(this) ? 7 : 3;
        }

        cls.ru_onPromote <- function () {
            this.follower.ru_onPromote();
            this.m.Effects[0] =
                positive("Greatly") + " increases the chance of encountering champions";
        }
    })

    // Second tier Blacksmith
    ::mods_hookExactClass("retinue/followers/blacksmith_follower", function (cls) {
        cls.m.ru_promotion <- {
            Cost = 3000
            Tease = "to recover items from slain enemies more often"
            Effects = ["Gives better chance to get items from slain enemies, even broken ones"]
        }
    })
    ::mods_hookBaseClass("scenarios/world/starting_scenario", function (cls) {
        cls = cls[cls.SuperName];

        local isDroppedAsLoot = cls.isDroppedAsLoot;
        cls.isDroppedAsLoot = function (_item) {
            local isPromoted = ::World.Retinue.ru_isPromoted("blacksmith_follower");
            return isDroppedAsLoot(_item) || isPromoted && ::Math.rand(1, 100) <= 7;
        }
    })

    // Second tier Scavenger
    ::mods_hookExactClass("retinue/followers/scavenger_follower", function (cls) {
        cls.m.ru_promotion <- {Cost = 3000, Tease = "to double the ammo and tools recovered"}
    })
    ::mods_hookExactClass("states/tactical_state", function (cls) {
        local gatherLoot = cls.gatherLoot;
        cls.gatherLoot = function () {
            local te = this.Tactical.Entities;
            if (::World.Retinue.ru_isPromoted("scavenger_follower")) {
                // Double this stuff
                te.spendAmmo(te.getAmmoSpent());

                local sp = this.m.StrategicProperties;
                local shouldLoot = !this.isScenarioMode() &&
                    (sp == null || !sp.IsArenaMode && !sp.IsLootingProhibited)

                // Can't just double armor parts because of 60 cap, so we copy the code
                if (shouldLoot && te.getArmorParts() > 0 && ::World.Assets.m.IsRecoveringArmor) {
                    local num = te.getArmorParts() * ::Const.World.Assets.ArmorPartsPerArmor * 0.15;
                    local amount = ::Math.min(60, ::Math.max(1, num));
                    amount = ::Math.rand(amount / 2, amount);

                    if (amount > 0) {
                        local parts = ::new("scripts/items/supplies/armor_parts_item");
                        parts.setAmount(amount);
                        this.m.CombatResultLoot.add(parts) // put here, will go loot and back here
                    }
                }

            }
            gatherLoot();
        }
    })

    // Trader
    ::mods_hookExactClass("retinue/followers/trader_follower", function (cls) {
        cls.m.ru_promotion <- {
            Cost = 7000
            Tease = "for more stuff in shops, including named items"
            Effects = ["Finds more stuff in shops, including more named items"]
        }
    })
    ::mods_hookNewObject("entity/world/settlement_modifiers", function (obj) {
        // NOTE: this is only called on add/remove settlement situation or contract,
        //       so changes might not be immediate
        local reset = obj.reset;
        obj.reset = function () {
            reset();
            if (::World.Retinue.ru_isPromoted("trader_follower")) {
                this.RarityMult *= 1.10; // Not as good as well supplied
            }
        }
    })

    // Cook
    ::mods_hookExactClass("retinue/followers/cook_follower", function (cls) {
        cls.m.ru_promotion <- {
            Cost = 2500
            Tease = "to get extra food after combat"
            Effects = ["Finds extra food after combat"]
        }
    })
    ::mods_hookBaseClass("entity/world/world_entity", function (cls) {
        cls = cls.world_entity;

        local dropFood = cls.dropFood;
        cls.dropFood = function(_num, _items, _lootTable) {
            if (::World.Retinue.ru_isPromoted("cook_follower")) _num++;

            local cook = ::World.Retinue.ru_isPromoted("cook_follower");
            dropFood(_num, _items, _lootTable);
        }
    })

    // Drill Sergeant
    ::mods_hookExactClass("retinue/followers/drill_sergeant_follower", function (cls) {
        cls.m.ru_promotion <- {
            Cost = 3500
            Tease = "to provide training for new recruites and make the most from training halls"
            Effects = [
                "New hires get " + positive("+70%") + " experience in first 3 battles"
                "Training halls experience bonus is doubled"
            ]
        }
    })
    ::mods_hookExactClass("entity/tactical/player", function (cls) {
        local onHired = cls.onHired;
        cls.onHired = function () {
            onHired();
            if (!::World.Retinue.ru_isPromoted("drill_sergeant_follower")) return;
            if (this.getSkills().hasSkill("effects.trained")) return;

            local effect = this.new("scripts/skills/effects_world/new_trained_effect");
            effect.m.Duration = 3;
            effect.m.XPGainMult = 1.7; // Double from usual +35%
            effect.m.Icon = "skills/status_effect_76.png";
            this.getSkills().add(effect);
        }
    })
    ::mods_hookExactClass("ui/screens/world/modules/world_town_screen/town_training_dialog_module",
            function (cls) {
        local onTrain = cls.onTrain;
        cls.onTrain = function (_data) {
            local ret = onTrain(_data);
            if (ret == null) return ret;
            if (!::World.Retinue.ru_isPromoted("drill_sergeant_follower")) return ret;

            local entityID = _data[0];
            local entity = this.Tactical.getEntityByID(entityID);
            local effect = entity.getSkills().getSkillByID("effects.trained");
            effect.m.XPGainMult += effect.m.XPGainMult - 1;

            return ret;
        }
    })

    // Guide promotion for Sato's Balance mod
    if (::mods_getRegisteredMod("sato_balance_mod")) {
        ::mods_hookExactClass("retinue/followers/scout_follower", function (cls) {
            cls.m.ru_promotion <- {
                Cost = 9000
                Tease = "to also move faster on normal terrain"
                Effects = [
                    "Makes the company travel " + positive("15%") + " faster on normal terrain"
                ]
            }
        })
        // Need to use ::mods_hookNewObject() to wrap Sato's same hook
        ::mods_hookNewObject("retinue/followers/scout_follower", function (obj) {
            local onUpdate = obj.onUpdate;
            obj.onUpdate = function () {
                onUpdate();
                if (!::World.Retinue.ru_isPromoted("scout_follower")) return;
                for (local i = 0; i < World.Assets.m.TerrainTypeSpeedMult.len(); ++i) {
                    if (Const.World.TerrainTypeSpeedMult[i] > 0.8) {
                        World.Assets.m.TerrainTypeSpeedMult[i] *= 1.15;
                    }
                }
            }
        })
    }
})
