::PermaHackflow.mh.hook("scripts/skills/injury_permanent/traumatized_injury", function (q) {
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
                icon = "ui/icons/bravery.png",
                // text = "[color=" + this.Const.UI.Color.NegativeValue + "]-40%[/color] Resolve"
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20%[/color] Resolve"
            },
            {
                id = 7,
                type = "text",
                icon = "ui/icons/initiative.png",
                // text = "[color=" + this.Const.UI.Color.NegativeValue + "]-30%[/color] Initiative"
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] Initiative"
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
        // _properties.BraveryMult *= 0.6;
        // _properties.InitiativeMult *= 0.7;
        // START NEW CODE
        _properties.BraveryMult *= 0.8;
        _properties.InitiativeMult *= 0.9;
        // END NEW CODE
        _properties.IsContentWithBeingInReserve = true;
    }
})
