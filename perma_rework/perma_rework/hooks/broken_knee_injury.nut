::PermaRework.mh.hook("scripts/skills/injury_permanent/broken_knee_injury", function (q) {
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
                icon = "ui/icons/melee_defense.png",
                // text = "[color=" + this.Const.UI.Color.NegativeValue + "]-40%[/color] Melee Defense"
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20%[/color] Melee Defense"
            },
            {
                id = 7,
                type = "text",
                icon = "ui/icons/ranged_defense.png",
                // text = "[color=" + this.Const.UI.Color.NegativeValue + "]-40%[/color] Ranged Defense"
                text = "[color=" + this.Const.UI.Color.NegativeValue + "]-20%[/color] Ranged Defense"
            },
            {
                id = 7,
                type = "text",
                icon = "ui/icons/initiative.png",
                // text = "[color=" + this.Const.UI.Color.NegativeValue + "]-40%[/color] Initiative"
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
        // _properties.MeleeDefenseMult *= 0.6;
        // _properties.RangedDefenseMult *= 0.6;
        // _properties.InitiativeMult *= 0.6;
        // START NEW CODE
        _properties.MeleeDefenseMult *= 0.8;
        _properties.RangedDefenseMult *= 0.8;
        _properties.InitiativeMult *= 0.8;
        // END NEW CODE
        _properties.IsContentWithBeingInReserve = true;
    }
})
