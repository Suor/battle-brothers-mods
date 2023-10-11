local Mod = StandoutEnemies.Mod;
local Rand = ::std.Rand;

this.cursed_effect <- this.inherit("scripts/skills/skill", {
    m = {
        Count = 1
        TurnsLeft = 3
    }
    function create() {
        this.m.ID = "standout_enemies.effects.cursed";
        this.m.Name = "Cursed";
        this.m.Icon = "skills/status_effect_108.png"; // status_effect_00 also looks ok
        this.m.IconMini = "status_effect_108_mini";
        this.m.Type = this.Const.SkillType.StatusEffect;
        this.m.IsActive = false;
        this.m.IsStacking = false;
        this.m.IsRemovedAfterBattle = true;
    }

    function getName() {
        return this.m.Name + (this.m.Count > 1 ? " (x" + this.m.Count + ")" : "");
    }

    function getDescription() {
        return "This character is cursed. "
            + "His ability to attack and defend decreased. "
            + "The effect will slowly wear off over "
            + "[color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.TurnsLeft + "[/color] more turn(s).";
    }

    function getTooltip() {
        local debuffValue = -10 * this.m.Count;
        return [
            {
                id = 1,
                type = "title",
                text = this.getName()
            },
            {
                id = 2,
                type = "description",
                text = this.getDescription()
            },
            {
                id = 10,
                type = "text",
                icon = "ui/icons/melee_skill.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + debuffValue
                       + "%[/color] Melee Skill"
            },
            {
                id = 11,
                type = "text",
                icon = "ui/icons/ranged_skill.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]" + debuffValue
                       + "%[/color] Ranged Skill"
            },
            {
                id = 12,
                type = "text",
                icon = "ui/icons/melee_defense.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]"
                       + debuffValue + "%[/color] Melee Defense"
            },
            {
                id = 13,
                type = "text",
                icon = "ui/icons/ranged_defense.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]"
                       + debuffValue + "%[/color] Ranged Defense"
            },
        ];
    }

    function onUpdate( _properties ) {
        _properties.MeleeSkillMult *= 1.0 - 0.1 * this.m.Count;
        _properties.RangedSkillMult *= 1.0 - 0.1 * this.m.Count;
        _properties.MeleeDefenseMult *= 1.0 - 0.1 * this.m.Count;
        _properties.RangedDefenseMult *= 1.0 - 0.1 * this.m.Count;
    }

    function onAdded() {
        if (this.checkResist()) {
            this.removeSelf();
            return;
        }

        local actor = this.getContainer().getActor();
        local props = actor.getCurrentProperties();
        this.m.Count = 1;
        // +1 turn to penalize a resillient bro hitting cursed once,
        // otherwise turn end will erase it immediately with no effect for a Resilient bro.
        this.m.TurnsLeft = 1 + this.Math.max(1, 3 + props.NegativeStatusEffectDuration);

        this.showEffect();
        this.updateAppearance(this.m.Count);
    }

    function onRefresh() {
        if (this.checkResist()) return;

        local props = this.getContainer().getActor().getCurrentProperties();

        ++this.m.Count;
        local turns = this.Math.max(1, 3 + props.NegativeStatusEffectDuration);
        this.m.TurnsLeft = this.m.TurnsLeft < turns ? turns : this.m.TurnsLeft + 1;
        this.showEffect();
    }

    function checkResist() {
        local props = this.getContainer().getActor().getCurrentProperties();
        local success = props.IsResistantToAnyStatuses && Rand.chance(0.5);
        if (success) {
            if (!actor.isHiddenToPlayer()) {
                this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor)
                    + " is unaffected by the curse thanks to his unnatural physiology");
            }
        }
        return success;
    }

    function onRemoved() {
        this.updateAppearance(0);
    }

    function onTurnEnd() {
        if (this.m.Count > 1) --this.m.Count;  // Can't loose the last one
        if (--this.m.TurnsLeft <= 0) this.removeSelf();
    }

    // Cosmetic stuff

    function showEffect() {
        local actor = this.getContainer().getActor();
        if (!actor.isHiddenToPlayer()) {
            local sound = Rand.choice([
                "sounds/combat/poison_applied_01.wav"
                "sounds/combat/poison_applied_02.wav"
            ]);
            this.Sound.play(sound, this.Const.Sound.Volume.Skill, actor.getPos());
            this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(actor) + " is cursed");
        }
        this.spawnIcon("status_effect_108", actor.getTile());
    }

    function updateAppearance(count) {
        local actor = this.getContainer().getActor();
        local color = count > 0 ? "#777777" : "#ffffff";
        local brightness = Math.maxf(0.3, 1.0 - 0.07 * count);

        // Make black or normal
        foreach (sprite in ["head" "face" "body" "arms_icon" "shield_icon"]) {
            Mod.color(actor, sprite, color, brightness);
        }
        foreach (sprite in ["hair" "beard" "beard_top"]) {
            if (actor.hasSprite(sprite))
                actor.getSprite(sprite).setBrightness(count > 0 ? 0.1 : 1.0);
        }
    }
});

