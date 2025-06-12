::PermaHackflow.mh.hook("scripts/skills/injury_permanent/brain_damage_injury", function (q) {
    q.getTooltip = @(__original) function () {
        local ret = __original();
        ret.insert(ret.len() - 1, {
            id = 7
            type = "text"
            icon = "ui/icons/asset_daily_money.png"
            text = "[color=" + Const.UI.Color.PositiveValue + "]-3[/color] Daily wage"
        })
        return ret;
    }

    q.onUpdate = @(__original) function (_properties) {
        __original(_properties);
        _properties.DailyWage -= 3;
    }
})
