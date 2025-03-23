local mod = ::Useful.mh, Text = ::std.Text;

mod.hook("scripts/skills/actives/hand_to_hand", function (q) {
    local function skillToLevel(_skill) {
        local actor = _skill.getContainer().getActor();
        return actor.ClassName == "player" ? actor.getLevel() : null;
    }

    q.getTooltip = @() function () {
        local ret = this.getDefaultTooltip();
        local props = this.m.Container.buildPropertiesForUse(this, null);
        local baseProps = this.m.Container.m.Actor.getCurrentProperties();

        local bonus = props.MeleeSkill - baseProps.MeleeSkill;
        local colored = bonus > 0 ? Text.positive : Text.negative;
        if (bonus != 0) {
            ret.push({
                id = 6
                type = "text"
                icon = "ui/icons/hitchance.png"
                text = "Has " + colored((bonus > 0 ? "+" : "") + bonus + "%") + " chance to hit"
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

    // Level 1: 5-10 damage, -10% to hit, 5 fat (same as vanilla)
    // Level 6: 15-20 damage, 10% direct, 9 fat
    // Level 11: 25-30 damage, 20% direct, +5% to hit, 14 fat
    // Level 21: 35-40 damage (cap), 30% direct, +15% to hit, 15 fat (cap)
    // Direct damage and to hit continue to grow 1% per level
    q.onUpdate = @(__original) function (_properties) {
        if (this.isUsable()) {
            local level = skillToLevel(this);
            if (level != null) {
                local bonus = Math.min(10, level - 1) + Math.max(0, level - 11) / 2;
                _properties.DamageRegularMin = 5 + Math.min(30, bonus * 2);
                _properties.DamageRegularMax = 10 + Math.min(30, bonus * 2);
                _properties.DamageArmorMult = 0.5;
                _properties.DamageDirectMult += 0.02 * bonus;
            } else {
                __original(_properties) // TODO: always call to be compat
            }
        }
    }

    q.onAnySkillUsed = @(__original) function (_skill, _targetEntity, _properties) {
        // TODO: always call original to be compat
        if (_skill == this) {
            local level = skillToLevel(this);
            if (level != null) {
                local bonus = level < 6 ? (level - 1) * 2 - 10 : level - 6;
                _properties.MeleeSkill += bonus;
                _properties.FatigueDealtPerHitMult += 0.2 * Math.max(0, Math.min(10, level - 2));
            } else {
                _properties.MeleeSkill -= 10;
            }
        }
    }
})

mod.hook("scripts/skills/backgrounds/brawler_background", function (q) {
    q.getTooltip = @(__original) function () {
        local ret = __original().filter(@(_, rec) rec.id != 12);
        ret.push({
            id = 6,
            type = "text",
            icon = "ui/icons/hitchance.png"
            text = "Has " + Text.positive("+10%") + " chance to hit when unarmed"
        })
        ret.push({
            id = 12,
            type = "text",
            icon = "ui/icons/regular_damage.png",
            text = Text.positive("+5-10") + " damage when unarmed"
        })
        return ret;
    }

    // Double damage becomes too large for brawler so we do +5-10 damage and +10 hit chance instead
    q.onAnySkillUsed = @(__original) function (_skill, _targetEntity, _properties) {
        // TODO: call original ???
        if (_skill.getID() == "actives.hand_to_hand") {
            _properties.MeleeSkill += 10;
            _properties.DamageRegularMin += 5;
            _properties.DamageRegularMax += 10;
        }
    }
})
