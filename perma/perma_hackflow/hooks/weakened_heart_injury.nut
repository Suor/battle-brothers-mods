::PermaHackflow.mh.hook("scripts/skills/injury_permanent/weakened_heart_injury", function (q) {
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
                icon = "ui/icons/health.png",
                // text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30%[/color] Hitpoints"
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color] Hitpoints"
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
        // _properties.HitpointsMult *= 0.7;
        _properties.HitpointsMult *= 0.85;
        _properties.IsContentWithBeingInReserve = true;
    }
})
