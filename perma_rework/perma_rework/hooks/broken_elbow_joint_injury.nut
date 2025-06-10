::PermaRework.mh.hook("scripts/skills/injury_permanent/broken_elbow_joint_injury", function (q) {
    q.getTooltip = @(__original) function () {
        local ret = [
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
                id = 7,
                type = "text",
                icon = "ui/icons/melee_skill.png",
                // text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20%[/color] Melee Skill"
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] Melee Skill"
            },
            {
                id = 7,
                type = "text",
                icon = "ui/icons/ranged_skill.png",
                // text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20%[/color] Ranged Skill"
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] Ranged Skill"
            },
            {
                id = 7,
                type = "text",
                icon = "ui/icons/melee_defense.png",
                // text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30%[/color] Melee Defense"
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] Melee Defense"
            },
            {
                id = 16,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Is always content with being in reserve"
            }
        ];
        this.addTooltipHint(ret);
        return ret;
    }

    q.onUpdate = @(__original) function (_properties) {
        // _properties.MeleeSkillMult *= 0.8;
        // _properties.RangedSkillMult *= 0.8;
        // _properties.MeleeDefenseMult *= 0.7;
        // START NEW CODE
        _properties.MeleeSkillMult *= 0.9;
        _properties.RangedSkillMult *= 0.9;
        _properties.MeleeDefenseMult *= 0.85;
        // END NEW CODE
        _properties.IsContentWithBeingInReserve = true;
    }
})
