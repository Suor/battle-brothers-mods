::PermaRework.mh.hook("scripts/skills/injury_permanent/missing_finger_injury", function (q) {
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
                icon = "ui/injury/injury_permanent_icon_02.png",
                text = "May drop shield or weapon on shield hit"
            }
        ];
        this.addTooltipHint(ret);
        return ret;
    }

    q.onUpdate = @() function (_properties) {}
})
