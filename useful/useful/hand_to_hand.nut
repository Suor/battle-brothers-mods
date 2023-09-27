local Text = ::std.Text;

::mods_hookExactClass("skills/actives/hand_to_hand", function (cls) {
    local function skillToLevel(_skill) {
        local actor = _skill.getContainer().getActor();
        return actor.ClassName == "player" ? actor.getLevel() : null;
    }

    cls.getTooltip = function() {
        local ret = this.getDefaultTooltip();

        local props = {MeleeSkill = 0, FatigueDealtPerHitMult = 0};
        this.onAnySkillUsed(this, null, props);

        local bonus = props.MeleeSkill;
        // local color = bonus > 0 ? Const.UI.Color.PositiveValue: Const.UI.Color.NegativeValue;
        if (bonus != 0) {
            ret.push({
                id = 6
                type = "text"
                icon = "ui/icons/hitchance.png"
                text = Text._render("Has {0|sign|percent|color} chance to hit", props.MeleeSkill)
                // text = "Has " + Text.color(Text.sign(bonus)) + " chance to hit"
                // text = "Has " + Text(props.MeleeSkill).sign().color() + " chance to hit"
                // text = "Has [color=" + color + "]" + (bonus > 0 ? "+" : "") + bonus
                //      + "%[/color] chance to hit"
            })
        }
        if (props.FatigueDealtPerHitMult > 0) {
            local fat =  Const.Combat.FatigueReceivedPerHit * props.FatigueDealtPerHitMult;
            ret.push({
                id = 7
                type = "text"
                icon = "ui/icons/special.png"
                text = "Inflicts " + Text.damage(fat)  + " extra fatigue"
            })
        }
        return ret;
    }

    local onUpdate = cls.onUpdate;
    cls.onUpdate = function (_properties) {
        if (this.isUsable()) {
            local level = skillToLevel(this);
            if (level != null) {
                // Get damage 15-20 with 20% direct on level 11
                // TODO: should probably cap at level 21 or brawler lvl 31 gets:
                //          50-60 dmg, 40% direct, +25 to hit, +10 fatigure
                //       That is a real late game though.
                local bonus = Math.min(10, level - 1) + Math.max(0, level - 11) / 2;
                _properties.DamageRegularMin = 5 + bonus;
                _properties.DamageRegularMax = 10 + bonus;
                _properties.DamageArmorMult = 0.5;
                _properties.DamageDirectMult += 0.02 * bonus;
                // _properties.DamageDirectAdd += 0.02 * bonus;
            } else {
                onUpdate(_properties)
            }
        }
    }

    cls.onAnySkillUsed = function (_skill, _targetEntity, _properties) {
        if (_skill == this) {
            local level = skillToLevel(this);
            if (level != null) {
                local bonus = level < 6 ? (level - 1) * 2 - 10 : level - 6;
                _properties.MeleeSkill += bonus;
                _properties.FatigueDealtPerHitMult += 0.2 * Math.max(0, Math.min(10, level - 6));
            } else {
                _properties.MeleeSkill -= 10;
            }
        }
    }
})
