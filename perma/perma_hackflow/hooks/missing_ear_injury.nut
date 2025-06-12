::PermaHackflow.mh.hook("scripts/skills/injury_permanent/missing_ear_injury", function (q) {
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
            // {
            //     id = 7,
            //     type = "text",
            //     icon = "ui/icons/initiative.png",
            //     text = "[color=" + this.Const.UI.Color.NegativeValue + "]-10%[/color] Initiative"
            // }
    // START NEW CODE

    // END NEW CODE
        ];
        this.addTooltipHint(ret);
        return ret;
    }

    q.onUpdate = @() function (_properties) {}
})
