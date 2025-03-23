local def = ::Useful, mod = def.mh, Text = ::std.Text;

local function hookNet(q) {
    q.create = @(__original) function () {
        __original();
        this.m.Ammo = 1;
        this.m.AmmoMax = 1;
        this.m.AmmoCost = 6;
        this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Ammo;

        // Saving these to be put back after a net is restored
        this.m.useful_Name <- this.m.Name;
        this.m.useful_IconLarge <- this.m.IconLarge;
        this.m.useful_Icon <- this.m.Icon;
    }

    q.getTooltip = @(__original) function () {
        // TODO: find a better way to filter out this line, now language dependent
        local tooltip = __original().filter(
            @(_, rec) rec.type != "text" || rec.text != "Is destroyed on use");

        local icon = this.m.Ammo > 0 ? "ui/icons/ammo.png" : "ui/tooltips/warning.png";
        local text = this.m.Ammo > 0 ? "Can be used once" : "Broken";
        text += ", needs " + Text.negative(this.m.AmmoCost) + " ammo to be restored"
        tooltip.push({id = 10, type = "text", icon = icon, text = text})
        return tooltip;
    }

    q.setAmmo <- function (_a) {
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

mod.hook("scripts/items/tools/throwing_net", hookNet);
mod.hook("scripts/items/tools/reinforced_throwing_net", hookNet);

mod.hook("scripts/skills/actives/throw_net", function (q) {
    q.getAmmo <- function() {
        local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
        return item ? item.getAmmo() : 0;
    }

    q.isUsable <- function() {
        return this.getAmmo() > 0 && this.skill.isUsable();
    }

    q.getTooltip = @(__original) function () {
        local tooltip = __original();

        if (this.getAmmo() == 0) tooltip.push({
            id = 8,
            type = "text",
            icon = "ui/tooltips/warning.png",
            text = Text.negative("No throwing net left")
        })
        return tooltip;
    }

    q.onUse = @(__original) function (_user, _targetTile) {
        local net = _user.getItems().getItemAtSlot(::Const.ItemSlot.Offhand);
        net.consumeAmmo();
        __original(_user, _targetTile);
        _user.getItems().equip(net); // Put it back
    }
})

// Fix how reusable nets interact with kingfisher perk. I.e. ammo should be spent on auto use.
// Since it's hard to impossible to detect it, we restore ammo later in .equip()
// TODO: refactor kingfisher for this to be easier
if (::Hooks.hasMod("mod_reforged")) {
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
mod.hook("scripts/skills/special/double_grip", function (q) {
    q.canDoubleGrip = @(__original) function () {
        local ret = __original();
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
mod.hook("scripts/skills/actives/swallow_whole_skill", function (q) {
    q.isUsable = @(__original) function () {
        return __original() && !this.getContainer().hasSkill("effects.net");
    }
})
