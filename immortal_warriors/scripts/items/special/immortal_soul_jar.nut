local mod = ::ImmortalWarriors, Text = ::std.Text, Player = ::std.Player;

this.immortal_soul_jar <- this.inherit("scripts/items/item", {
    m = {
        // We store info associated with immortal or his jar in globally, here is a ref
        immortal_Index = null
    },
    function create()
    {
        this.item.create();
        this.m.ID = "misc.immortal_soul_jar";
        this.m.Name = "Soul Jar of an Immortal Warrior";
        this.m.Description = "This jar contains a soul of an immortal warrior, who fought numerous battles and slained countless enemies over the ages";
        // TODO: proper unique icon
        this.m.Icon = "consumables/jug_01.png";
        this.m.SlotType = this.Const.ItemSlot.None;
        this.m.ItemType = this.Const.Items.ItemType.Usable;
        this.m.IsDroppedAsLoot = true;
        this.m.IsAllowedInBag = false;
        this.m.IsUsable = true;
        this.m.Value = 1;
        if (::std.Util.isIn("IsSellable", this.m)) this.m.IsSellable = false;
    }

    function getDescription()
    {
        local info = mod.getImmortalInfo(this.m.immortal_Index);
        if (!info.Name) return this.m.Description;

        local name = info.Title == "" ? info.Name : info.Name + " " + info.Title;
        local desc = "This jar contains the soul of " + Text.ally(name)
            + ", who fought numerous battles and slained countless enemies over the ages.";
        if (info.Kills == 0) {
            desc += " He did not do much after that though"
        } else {
            desc += " He also crushed " + Text.enemy(info.Kills) + " foe" + Text.plural(info.Kills)
                 + " as you were counting";
        }
        desc += " and died being level " + Text.positive(info.Level) + ".";
        if (info.Deaths == 1) {
            desc += " It was his first death in new times.";
        } else {
            desc += " He managed to die " + Text.negative(info.Deaths) + " times recently.";
        }
        return desc;
    }

    function getTooltip()
    {
        // Copy title, description, icon. Drop value text.
        local ret = this.item.getTooltip().filter(@(_, item) item.id != 66);

        local info = mod.getImmortalInfo(this.m.immortal_Index);
        local levels = this.levelsBoost(info);
        if (levels > 0) {
            ret.push({
                id = 10,
                type = "text",
                icon = "ui/icons/level.png",
                text = "Gives " + (levels == 1 ? "a level" : levels + " levels")
            });
        }
        local talents = mod.conf("talents");
        if (talents > 0) {
            ret.push({
                id = 11,
                type = "text",
                icon = "ui/icons/talent_1.png",
                text = "Boosts " + (talents == 1 ? "one talent" : talents + " talents")
            });
        }
        local traits = mod.conf("traits");
        if (traits > 0) {
            ret.push({
                id = 12,
                type = "text",
                icon = "ui/icons/unknown_traits.png",
                text = "Adds " + (traits == 1 ? "a good trait" : traits + " good traits")
            });
        }
        ret.push({
            id = 20,
            type = "text",
            icon = "ui/icons/obituary.png",
            text = "Grants immortal power"
        });
        ret.push({
            id = 65,
            type = "text",
            text = "Right-click or drag onto the currently selected character in order to use. "
                 + "This item will be consumed in the process."
        });
        return ret;
    }

    function playInventorySound( _eventType )
    {
        this.Sound.play("sounds/bottle_01.wav", this.Const.Sound.Volume.Inventory);
    }

    function levelsBoost(_info)
    {
        return _info.Level == 0 ? mod.conf("levels") :
               mod.conf("retainLevels") == "all" ? _info.Level - 1 :
               mod.conf("retainLevels") == "half" ? _info.Level / 2 : 0;
    }

    function onUse( _actor, _item = null )
    {
        if (_actor.getSkills().hasSkill("trait.immortal_warrior")) return false;

        this.Sound.play("sounds/enemies/ghost_death_0" + ::Math.rand(1, 2) + ".wav",
                        this.Const.Sound.Volume.Inventory);

        local trait = this.new("scripts/skills/traits/immortal_warrior_trait");
        trait.m.immortal_Index = this.m.immortal_Index;
        _actor.getSkills().add(trait);

        // Add powers
        mod.boostTalents(_actor, mod.conf("talents"));
        Player.addTraits(_actor, mod.conf("traits"), {good = true, bad = false, soso = false});

        local info = mod.getImmortalInfo(this.m.immortal_Index);

        Player.giveLevels(_actor, this.levelsBoost(info));

        // Set name and stats
        if (info.Name) {
            _actor.setName(info.Name);
            _actor.setTitle(info.Title); // ?
            local stats = _actor.getLifetimeStats();
            stats.Battles += info.Battles;
            stats.Kills += info.Kills;
        }

        return true;
    }

    function onSerialize( _out )
    {
        this.item.onSerialize(_out);
        _out.writeU16(this.m.immortal_Index);
    }

    function onDeserialize( _in )
    {
        this.item.onDeserialize(_in);
        this.m.immortal_Index = _in.readU16();
    }
});

