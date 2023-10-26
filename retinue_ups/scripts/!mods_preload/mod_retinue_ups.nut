local mod = ::RetinueUps <- {
    ID = "mod_retinue_ups"
    Name = "Retinue Promotions"
    Version = 0.5
}

local function positive(value) {
    return ::Const.UI.getColorized(value + "", ::Const.UI.Color.PositiveValue)
}

::mods_registerMod(mod.ID, mod.Version, mod.Name);
::mods_queue(mod.ID, "mod_hooks(>=20), >tnf_expandedRetinue, >mod_more_followers", function() {
    ::mods_registerJS("retinue_ups.js");

    ::mods_hookNewObjectOnce("retinue/retinue_manager", function (obj) {
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

    ::mods_hookNewObjectOnce("ui/screens/world/world_campfire_screen", function (obj) {
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
                    text = "Promote for " + this.m.ru_promotion.Tease
                        + ", costs " + this.m.ru_promotion.Cost + "[img]gfx/ui/tooltips/money.png[/img]"
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
        cls.m.ru_promotion <- {Cost = 4000, Tease = "even more champions"}

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
            Tease = "some chance to recover items from slain enemies"
            Effects = ["Gives some chance to get even broken items from slain enemies as loot"]
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
        cls.m.ru_promotion <- {Cost = 3000, Tease = "double bonus"}
    })
    ::mods_hookExactClass("states/tactical_state", function (cls) {
        local gatherLoot = cls.gatherLoot;
        cls.gatherLoot = function () {
            if (::World.Retinue.ru_isPromoted("scavenger_follower")) {
                this.m.AmmoSpent *= 2;
                this.m.ArmorParts *= 2;
            }
            gatherLoot();
        }
    })
})
