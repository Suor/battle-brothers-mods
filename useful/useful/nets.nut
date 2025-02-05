local Text = ::std.Text;

local function hookNet(cls) {
    local create = cls.create;
    cls.create = function () {
        create();
        this.m.Ammo = 1;
        this.m.AmmoMax = 1;
        this.m.AmmoCost = 6;
        this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Ammo;

        // Saving these to be put back after a net is restored
        this.m.useful_Name <- this.m.Name;
        this.m.useful_IconLarge <- this.m.IconLarge;
        this.m.useful_Icon <- this.m.Icon;
    }

    local getTooltip = cls.getTooltip;
    cls.getTooltip = function () {
        local tooltip = getTooltip().filter(
            @(_, rec) rec.type != "text" || rec.text != "Is destroyed on use");

        local icon = this.m.Ammo > 0 ? "ui/icons/ammo.png" : "ui/tooltips/warning.png";
        local text = this.m.Ammo > 0 ? "Can be used once" : "Broken";
        text += ", needs " + Text.negative(this.m.AmmoCost) + " ammo to be restored"
        tooltip.push({id = 10, type = "text", icon = icon, text = text})
        return tooltip;
    }

    cls.setAmmo <- function( _a ) {
        this.m.Ammo = _a;

        if (this.m.Ammo > 0) {
            this.m.Name = this.m.useful_Name;
            this.m.IconLarge = this.m.useful_IconLarge;
            this.m.Icon = this.m.useful_Icon;
            this.m.ShowArmamentIcon = true;
        } else {
            this.m.Name = this.m.useful_Name + " (Used)";
            this.m.IconLarge = "weapons/ranged/javelins_01_bag.png";
            this.m.Icon = "weapons/ranged/javelins_01_bag_70x70.png";
            this.m.ShowArmamentIcon = false;
        }

        this.updateAppearance();
    }
}

::mods_hookExactClass("items/tools/throwing_net", hookNet);
::mods_hookExactClass("items/tools/reinforced_throwing_net", hookNet);

::mods_hookExactClass("skills/actives/throw_net", function (cls) {
    cls.getAmmo <- function() {
        local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
        return item ? item.getAmmo() : 0;
    }

    cls.isUsable <- function() {
        return this.getAmmo() > 0 && this.skill.isUsable();
    }

    local getTooltip = cls.getTooltip;
    cls.getTooltip = function () {
        local tooltip = getTooltip();

        if (this.getAmmo() == 0) tooltip.push({
            id = 8,
            type = "text",
            icon = "ui/tooltips/warning.png",
            text = Text.negative("No throwing net left")
        })
        return tooltip;
    }

    local onUse = cls.onUse;
    cls.onUse = function (_user, _targetTile) {
        local net = _user.getItems().getItemAtSlot(::Const.ItemSlot.Offhand);
        net.consumeAmmo();
        onUse(_user, _targetTile);
        _user.getItems().equip(net); // Put it back
    }
})

// Fix how reusable nets interact with kingfisher perk. I.e. ammo should be spent on auto use.
// Since it's hard to impossible to detect it, we restore ammo later in .equip()
// TODO: refactor kingfisher for this to be easier
if ("Hooks" in getroottable() && ::Hooks.hasMod("mod_reforged")) {
    local function unconsumeAmmo(_item) {
        _item.setAmmo(::Math.min(_item.m.AmmoMax, _item.m.Ammo + 1));
        if (_item.getContainer().getActor().isPlayerControlled()) {
            ::Tactical.Entities.spendAmmo(_item.m.AmmoCost);
        }
    }

    local mod = ::Hooks.getMod(::Useful.ID);
    mod.hook("scripts/items/item_container", function (q) {
        q.equip = @(__original) function(_item) {
            if (_item.ClassName != "throwing_net" && _item.ClassName != "reinforced_throwing_net")
                return __original(_item);

            local off = getItemAtSlot(::Const.ItemSlot.Offhand);
            if (!off || off.ClassName != _item.ClassName) return __original(_item);

            unconsumeAmmo(off);
            return false;
        }
    })
}

// Nets do not prevent double grip anymore, they just hang on a shoulder, common :)
::mods_hookExactClass("skills/special/double_grip", function (cls) {
    local canDoubleGrip = cls.canDoubleGrip;
    cls.canDoubleGrip = function () {
        local ret = canDoubleGrip();
        if (ret) return ret; // Make it compatible with En Garde perk from Reforged and whatever

        local items = this.getContainer().getActor().getItems();
        local main = items.getItemAtSlot(this.Const.ItemSlot.Mainhand);
        local off = items.getItemAtSlot(this.Const.ItemSlot.Offhand);
        return main != null && main.isDoubleGrippable()
            && (off == null || off.getID() == "tool.throwing_net" 
                            || off.getID() == "tool.reinforced_throwing_net")
    }
})

// Nachezers can't swallow through net
::mods_hookExactClass("skills/actives/swallow_whole_skill", function (cls) {
    local isUsable = cls.isUsable;
    cls.isUsable = function () {
        return isUsable() && !this.getContainer().hasSkill("effects.net");
    }
})
