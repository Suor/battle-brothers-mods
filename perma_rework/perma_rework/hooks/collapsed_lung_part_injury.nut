//
::mods_hookExactClass("skills/injury_permanent/collapsed_lung_part_injury", function(cls) {

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
                icon = "ui/icons/fatigue.png",
                // text = "[color=" + this.Const.UI.Color.NegativeValue + "]-40%[/color] Fatigue"
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]-3[/color] Fatigue Recovery per turn"
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

    local onUpdate = cls.onUpdate;
    cls.onUpdate = function (_properties) {
        // _properties.StaminaMult *= 0.6;
        _properties.FatigueRecoveryRate += -3;
        _properties.IsContentWithBeingInReserve = true;
    }
})
