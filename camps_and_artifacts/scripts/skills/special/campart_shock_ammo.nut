this.campart_shock_ammo <- ::inherit("scripts/skills/skill", {
    m = {},
    function create()
    {
        this.m.ID = "special.campart_shock_ammo";
        this.m.Name = "Shocking Ammo Effect";
        this.m.Description = "A successful hit will daze the target.";
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
                text = "Will daze a target on hit"
            });
        }
    }

    function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
    {
        if (!_targetEntity.isAlive() || _targetEntity.getCurrentProperties().IsImmuneToDaze) return;
        if (!this.m.Item.appliesTo(_skill)) return;

        _targetEntity.getSkills().add(this.new("scripts/skills/effects/dazed_effect"));

        if (!_targetEntity.isHiddenToPlayer()) {
            ::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(_targetEntity) + " is dazed");
        }
    }
});
