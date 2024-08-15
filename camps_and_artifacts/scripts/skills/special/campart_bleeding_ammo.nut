this.campart_bleeding_ammo <- ::inherit("scripts/skills/skill", {
    m = {},
    function create()
    {
        this.m.ID = "special.campart_bleeding_ammo";
        this.m.Name = "Bleeding Ammo Effect";
        this.m.Description = "A successful hit will make the target bleed.";
        this.m.Icon = "";
        this.m.Type = this.Const.SkillType.Special;
        this.m.Order = ::Const.SkillOrder.VeryLast;
        this.m.IsActive = false;
        this.m.IsStacking = false;
        this.m.IsHidden = true;
    }

    function onQueryTooltip( _skill, _tooltip )
    {
        if (this.m.Item.appliesTo(_skill))
        {
            _tooltip.push({
                id = 10,
                type = "text",
                icon = "ui/icons/special.png",
                text = "Applies bleeding on hit"
            });
        }
    }

    function onTargetHit(
        _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
    {
        // NOTE: we ignore minimim damage needed for bleeding
        if (!this.m.Item.appliesTo(_skill)) return;
        if (!_targetEntity.isAlive() && !_targetEntity.isDying()
            || _targetEntity.getCurrentProperties().IsImmuneToBleeding) return;

        if (!_targetEntity.isHiddenToPlayer()) {
            // TODO: add bleeding sounds?
            // ::Sound.play(this.m.SoundOnUse[::Math.rand(0, this.m.SoundOnUse.len() - 1)], ::Const.Sound.Volume.Skill, _user.getPos());
            ::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_targetEntity) + " is bleeding");
        }

        local effect = ::new("scripts/skills/effects/bleeding_effect");
        effect.setDamage(10);
        _targetEntity.getSkills().add(effect);
    }
});
