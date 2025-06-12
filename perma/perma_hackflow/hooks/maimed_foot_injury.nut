::PermaHackflow.mh.hook("scripts/skills/injury_permanent/maimed_foot_injury", function (q) {
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
                // text = "[color=" + this.Const.UI.Color.NegativeValue + "]1[/color] Additional Action Point per tile moved"
                text = "Builds up [color=" + this.Const.UI.Color.NegativeValue + "]3[/color] more Fatigue for each tile travelled"
            },
            {
                id = 7,
                type = "text",
                icon = "ui/icons/initiative.png",
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20%[/color] Initiative"
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
        // _properties.MovementAPCostAdditional += 1;
        _properties.MovementFatigueCostAdditional += 3;
        _properties.InitiativeMult *= 0.8;
        _properties.IsContentWithBeingInReserve = true;
    }
})
