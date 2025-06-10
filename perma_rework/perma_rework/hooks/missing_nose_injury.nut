::PermaRework.mh.hook("scripts/skills/injury_permanent/missing_nose_injury", function (q) {
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
                icon = "ui/icons/fatigue.png",
                // text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] Max Fatigue"
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]-5%[/color] Max Fatigue"
            }
        ];
        this.addTooltipHint(ret);
        return ret;
    }

    q.onUpdate = @(__original) function (_properties) {
        // _properties.StaminaMult *= 0.9;
        _properties.StaminaMult *= 0.95;
    }
})
