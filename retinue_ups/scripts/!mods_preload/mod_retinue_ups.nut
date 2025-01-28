local def = ::RetinueUps <- {
    ID = "mod_retinue_ups"
    Name = "Retinue Promotions"
    Version = "1.2.0"
}

local function positive(value) {
    return ::Const.UI.getColorized(value + "", ::Const.UI.Color.PositiveValue)
}
local function named(value) {return ::Const.UI.getColorized(value + "", "#1e468f")}
local function enemy(value) {return ::Const.UI.getColorized(value + "", "#8f1e1e")}

local mod = def.mh <- ::Hooks.register(def.ID, def.Version, def.Name);
mod.queue(">sato_balance_mod", ">tnf_expandedRetinue", ">mod_more_followers", function () {
    if ("mods_registerJS" in getroottable()) ::mods_registerJS("retinue_ups.js");
    else ::Hooks.registerLateJS("ui/mods/retinue_ups.js");

    mod.hook("scripts/retinue/retinue_manager", function (q) {
        q.setFollower = @(__original) function (_slot, _follower) {
            // When follower is replaced it looses its promotion
            local prev = this.m.Slots[_slot];
            if (prev != null) this.ru_demote(prev);
            return __original(_slot, _follower);
        }

        q.onDeserialize = @(__original) function ( _in ) {
            __original(_in);
            // Update costs and effects
            foreach (f in this.m.Followers) {
                if (this.ru_isPromoted(f)) f.ru_onPromote();
            }
        }

        // TODO: check the presense of a follower, i.e. one might remove the mod,
        //       replace the follower, reinstall the mod and reap the promotion effects sometimes.
        q.ru_isPromoted <- function (follower) {
            local clsName = typeof follower == "string" ? follower : follower.ClassName;
            return ::World.Flags.has("mod_retinue_ups." + clsName);
        }
        q.ru_promote <- function (follower) {
            ::World.Flags.add("mod_retinue_ups." + follower.ClassName);
            follower.ru_onPromote();
        }
        q.ru_demote <- function (follower) {
            ::World.Flags.remove("mod_retinue_ups." + follower.ClassName);
            follower.ru_onDemote();
        }
    })

    mod.hook("scripts/ui/screens/world/world_campfire_screen", function (q) {
        q.ru_onSlotCtrlClicked <- function (_i) {
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
        q.refresh = @(__original) function () {
            local R = ::World.Retinue;
            foreach (f in R.m.Followers) {
                if (R.ru_isPromoted(f) && R.m.Slots.find(f) == null) R.ru_demote(f)
            }
            // This is a bug that those two modules don't do this recalc, we clean up after them.
            // Might move to the click handler above otherwise.
            ::World.Assets.resetToDefaults();
            __original();
        }
    });

    mod.hook("scripts/retinue/follower", function (q) {
        q.getName = @(__original) function () {
            return __original() + (::World.Retinue.ru_isPromoted(this) ? " (Promoted)" : "")
        }

        q.getTooltip = @(__original) function () {
            local tooltip = __original();
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

        q.ru_hasPromotion <- function () {return "ru_promotion" in this.m}
        q.ru_onPromote <- function () {
            this.m.ru_base <- {
                Cost = this.m.Cost
                Effects = clone this.m.Effects
            }

            local up = this.m.ru_promotion;
            this.m.Cost += up.Cost;  // Add cost for expanded retinue/more followers refund
            if ("Effects" in up) this.m.Effects.extend(up.Effects);
        }
        q.ru_onDemote <- function () {
            this.m.Cost = this.m.ru_base.Cost;
            this.m.Effects = this.m.ru_base.Effects;
        }
    })

    // Second tier Bounty Hunter
    mod.hook("scripts/retinue/followers/bounty_hunter_follower", function (q) {
        q.m.ru_promotion <- {Cost = 7000, Tease = "for even more champions"}

        q.onUpdate = @(__original) function () {
            ::World.Assets.m.ChampionChanceAdditional = ::World.Retinue.ru_isPromoted(this) ? 7 : 3;
        }

        q.ru_onPromote <- function () {
            this.follower.ru_onPromote();
            this.m.Effects[0] =
                positive("Greatly") + " increases the chance of encountering champions";
        }
    })

    // Second tier Blacksmith
    mod.hook("scripts/retinue/followers/blacksmith_follower", function (q) {
        q.m.ru_promotion <- {
            Cost = 3000
            Tease = "to recover items from slain enemies more often"
            Effects = ["Gives better chance to get items from slain enemies, even broken ones"]
        }
    })
    mod.hookTree("scripts/scenarios/world/starting_scenario", function (q) {
        q.isDroppedAsLoot = @(__original) function (_item) {
            local isPromoted = ::World.Retinue.ru_isPromoted("blacksmith_follower");
            return __original(_item) || isPromoted && ::Math.rand(1, 100) <= 7;
        }
    })

    // Second tier Scavenger
    mod.hook("scripts/retinue/followers/scavenger_follower", function (q) {
        q.m.ru_promotion <- {Cost = 3000, Tease = "to double the ammo and tools recovered"}
    })
    mod.hook("scripts/states/tactical_state", function (q) {
        q.gatherLoot = @(__original) function () {
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
            __original();
        }
    })

    // Trader
    mod.hook("scripts/retinue/followers/trader_follower", function (q) {
        q.m.ru_promotion <- {
            Cost = 7000
            Tease = "for more stuff in shops, including named items"
            Effects = ["Finds more stuff in shops, including more named items"]
        }
    })
    mod.hook("scripts/entity/world/settlement_modifiers", function (q) {
        // NOTE: this is only called on add/remove settlement situation or contract,
        //       so changes might not be immediate
        q.reset = @(__original) function () {
            __original();
            if (::World.Retinue.ru_isPromoted("trader_follower")) {
                this.RarityMult *= 1.10; // Not as good as well supplied
            }
        }
    })

    // Cook
    // Q: is there a way to make it more useful and/or fun?
    mod.hook("scripts/retinue/followers/cook_follower", function (q) {
        q.m.ru_promotion <- {
            Cost = 2500
            Tease = "to get extra food after combat"
            Effects = ["Finds extra food after combat"]
        }
    })
    mod.hook("scripts/entity/world/world_entity", function (q) {
        q.dropFood = @(__original) function (_num, _items, _lootTable) {
            if (::World.Retinue.ru_isPromoted("cook_follower")) _num++;

            local cook = ::World.Retinue.ru_isPromoted("cook_follower");
            __original(_num, _items, _lootTable);
        }
    })

    // Drill Sergeant
    mod.hook("scripts/retinue/followers/drill_sergeant_follower", function (q) {
        q.m.ru_promotion <- {
            Cost = 3500
            Tease = "to provide training for new recruites and make the most from training halls"
            Effects = [
                "New hires get " + positive("+70%") + " experience in first 3 battles"
                "Training halls experience bonus is doubled"
            ]
        }
    })
    mod.hook("scripts/entity/tactical/player", function (q) {
        q.onHired = @(__original) function () {
            __original();
            if (!::World.Retinue.ru_isPromoted("drill_sergeant_follower")) return;
            if (this.getSkills().hasSkill("effects.trained")) return;

            local effect = this.new("scripts/skills/effects_world/new_trained_effect");
            effect.m.Duration = 3;
            effect.m.XPGainMult = 1.7; // Double from usual +35%
            effect.m.Icon = "skills/status_effect_76.png";
            this.getSkills().add(effect);
        }
    })
    mod.hook("scripts/ui/screens/world/modules/world_town_screen/town_training_dialog_module",
            function (q) {
        q.onTrain = @(__original) function (_data) {
            local ret = __original(_data);
            if (ret == null) return ret;
            if (!::World.Retinue.ru_isPromoted("drill_sergeant_follower")) return ret;

            local entityID = _data[0];
            local entity = this.Tactical.getEntityByID(entityID);
            local effect = entity.getSkills().getSkillByID("effects.trained");
            effect.m.XPGainMult += effect.m.XPGainMult - 1;

            return ret;
        }
    })

    // Lookout
    mod.hook("scripts/retinue/followers/lookout_follower", function (q) {
        q.m.ru_promotion <- {
            Cost = 3500
            Tease = "to show more info about locations"
            Effects = [
                "Shows a faction of unscoutable locations "
                + "and whether its treasury has " + named("named items")
            ]
        }
    })
    mod.hook("scripts/entity/world/location", function (q) {
        local function hasNamed(_location) {
            foreach (item in _location.m.Loot.getItems()) {
                if (item != null && item.isItemType(::Const.Items.ItemType.Named)) return true;
            }
            return false;
        }

        q.getTooltip = @(__original) function () {
            local tooltip = __original();
            if (!::World.Retinue.ru_isPromoted("lookout_follower")) return tooltip;

            foreach (entry in tooltip)
                if (entry.type == "text" && entry.icon == "ui/orientation/player_01_orientation.png") {
                    local faction = ::World.FactionManager.getFaction(this.getFaction()).getName();
                    entry.text = "Unknown " + enemy(faction);
                }

            if (hasNamed(this)) {
                tooltip.push({
                    id = 30
                    type = "hint"
                    icon = "ui/icons/bag.png"
                    text = "Has " + named("named item") + " in there"
                });
            }
            return tooltip;
        }
    })


    // Guide promotion for Sato's Balance mod
    if (::mods_getRegisteredMod("sato_balance_mod")) {
        mod.hook("scripts/retinue/followers/scout_follower", function (q) {
            q.m.ru_promotion <- {
                Cost = 9000
                Tease = "to also move faster on normal terrain"
                Effects = [
                    "Makes the company travel " + positive("15%") + " faster on normal terrain"
                ]
            }
        })
        // Need to use ::mods_hookNewObject() to wrap Sato's same hook
        mod.hook("scripts/retinue/followers/scout_follower", function (q) {
            q.onUpdate = @(__original) function () {
                __original();
                if (!::World.Retinue.ru_isPromoted("scout_follower")) return;
                for (local i = 0; i < World.Assets.m.TerrainTypeSpeedMult.len(); ++i) {
                    if (Const.World.TerrainTypeSpeedMult[i] > 0.8) {
                        World.Assets.m.TerrainTypeSpeedMult[i] *= 1.15;
                    }
                }
            }
        })
    }

    // Surgeon
    mod.hook("scripts/retinue/followers/surgeon_follower", function (q) {
        q.m.ru_promotion <- {
            Cost = 3500
            Tease = "to sometimes fix permanent injuries on level ups"
            Effects = [
                "Give " + positive("15%") + " chance to fix permanent injury on level up"
            ]
        }
    })
    ::include("scripts/i_retinue_ups_levelup_changes");
    ::LevelUpChanges.onLevel(function (_player, _level) {
        if (!::World.Retinue.ru_isPromoted("surgeon_follower")) return;

        local injuries = _player.getSkills().query(::Const.SkillType.PermanentInjury);
        if (injuries.len() == 0) return;
        if (::Math.rand(1, 100) > 15) return;

        local index = ::Math.rand(0, injuries.len() - 1);
        local toRemove = injuries[index].get(); // .query() returns weakrefs
        ::logInfo("Promoted Surgeon fixes " + toRemove.getName() + " on " + _player.getName());
        _player.getSkills().remove(toRemove);

        _player.addLevelUpChanges("Promoted Surgeon fixes", [{
            id = toRemove.getID()
            icon = toRemove.getIcon()
            removed = true
            tooltip = toRemove.getTooltip() // TODO: do not save tooltip and icon?
        }])

        _player.getSprite("permanent_injury_1").Visible = false;
        _player.getSprite("permanent_injury_2").Visible = false;
        _player.getSprite("permanent_injury_3").Visible = false;
        _player.getSprite("permanent_injury_4").Visible = false;
        _player.getSprite("permanent_injury_1").resetBrush();
        _player.getSprite("permanent_injury_2").resetBrush();
        _player.getSprite("permanent_injury_3").resetBrush();
        _player.getSprite("permanent_injury_4").resetBrush();
        _player.updateInjuryVisuals()
    })
})

// hack for updates
mod.queue(">msu", function () {
    if (!("MSU" in getroottable())) return;
    ::include("scripts/i_retinue_ups_hack_msu");
    ::HackMSU.setup(def, {
        nexus = "https://www.nexusmods.com/battlebrothers/mods/681"
        github = "https://github.com/Suor/battle-brothers-mods/tree/master/retinue_ups"
        tagPrefix = "retinue-ups-"
    })
})
