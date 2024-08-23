local mod = ::ImmortalWarriors, Text = ::std.Text;

this.immortal_warrior_trait <- this.inherit("scripts/skills/traits/character_trait", {
    m = {
        // We store info associated with immortal or his jar in globally, here is a ref
        immortal_Index = null
    },
    function create()
    {
        this.character_trait.create();
        this.m.ID = "trait.immortal_warrior";
        this.m.Name = "Immortal";
        this.m.Icon = "ui/traits/immortal_warrior.png";
        this.m.Description = "A soul of an ancient warrior entered this character. Passing him the experience of countless battles.";
        this.m.Order = this.Const.SkillOrder.Trait - 10;
    }

    function getTooltip()
    {
        local ret = this.character_trait.getTooltip();

        local info = mod.getImmortalInfo(this.m.immortal_Index);
        if (info.Deaths > 0) {
           ret.push({
                id = 5
                type = "text"
                icon = "ui/icons/miniboss.png"
                text = "Was slain and reborn " + Text.damage(info.Deaths)
                     + " time" + Text.plural(info.Deaths) + " under your command."
            })
        }

        local baseProps = this.m.Container.m.Actor.getCurrentProperties();
        local props = baseProps.getClone();
        this.onUpdate(props);

        local keys = ["ActionPoints" "FatigueRecoveryRate" "MeleeSkill" "MeleeDefense"];
        local icons = ["action_points_small" "fatigue" "melee_skill" "melee_defense"];
        local names = [
            null "Fatigue Recovery per turn" "Melee and Ranged Skill" "Melee and Ranged Defense"];
        foreach (i, key in keys) {
            local bonus = props[key] - baseProps[key];
            if (bonus <= 0) continue;

            local name = i > 0 ? names[i] : "Action Point" + Text.plural(bonus);
            ret.push({
                id = 6 + i
                type = "text"
                icon = "ui/icons/" + icons[i] + ".png"
                text = Text.positive("+" + bonus) + " " + name
            })
        }

        return ret;
    }

    function onUpdate( _properties )
    {
        local actor = this.getContainer().getActor();

        local ap = mod.conf("ap");
        local apMult = ::Math.min(actor.getLevel() / 3, 3);
        _properties.ActionPoints += ap / 3 * apMult;

        _properties.FatigueRecoveryRate += mod.conf("fatigueRecovery");

        local skill = mod.conf("skill");
        _properties.MeleeSkill += skill;
        _properties.RangedSkill += skill;
        // if (skill > 0) {
        //     local bg = actor.getBackground();
        //     _properties[bg && mod.isRangedBg(bg) ? "RangedSkill" : "MeleeSkill"] += skill;
        // }

        local defense = mod.conf("defense");
        _properties.MeleeDefense += defense;
        _properties.RangedDefense += defense;
    }

    function onDeath( _fatalityType )
    {
        if (_fatalityType == ::Const.FatalityType.Unconscious) return;

        // Update stats
        local actor = this.getContainer().getActor();
        local stats = actor.getLifetimeStats();
        local info = mod.getImmortalInfo(this.m.immortal_Index);
        info.Name = actor.m.Name;
        info.Title = actor.m.Title;
        info.Level = actor.m.Level;
        info.Battles += stats.Battles;
        info.Kills += stats.Kills;
        info.Deaths ++;

        // Return the soul to a jar
        local jar = ::new("scripts/items/special/immortal_soul_jar");
        jar.m.immortal_Index = this.m.immortal_Index;

        local added = ::World.Assets.getStash().add(jar);
        if (!added) added = ::Tactical.CombatResultLoot && ::Tactical.CombatResultLoot.add(jar);
        // Should be recreated with an event later
        if (!added) ::logWarning("iw: Immortal Soul Jar " + this.m.immortal_Index + " is lost!");
    }

    function onSerialize( _out )
    {
        this.character_trait.onSerialize(_out);
        _out.writeU16(this.m.immortal_Index);
    }

    function onDeserialize( _in )
    {
        this.character_trait.onDeserialize(_in);
        this.m.immortal_Index = _in.readU16();
    }
});
