//
::mods_hookExactClass("skills/injury_permanent/missing_eye_injury", function(cls) {

    local getTooltip = cls.getTooltip;
    cls.getTooltip = function () {
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
                icon = "ui/icons/ranged_skill.png",
                // text = "[color=" + this.Const.UI.Color.NegativeValue + "]-50%[/color] Ranged Skill"
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]-25%[/color] Ranged Skill"
            },
            {
                id = 7,
                type = "text",
                icon = "ui/icons/vision.png",
                // text = "[color=" + this.Const.UI.Color.NegativeValue + "]-2[/color] Vision"
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]-1[/color] Vision"
            }
        ];
        this.addTooltipHint(ret);
        return ret;
    }

    local onUpdate = cls.onUpdate;
    cls.onUpdate = function (_properties) {
        // _properties.RangedSkillMult *= 0.5;
        // _properties.Vision -= 2;
        // START NEW CODE
        _properties.RangedSkillMult *= 0.75;
        _properties.Vision -= 1;
        // END NEW CODE
    }
})
