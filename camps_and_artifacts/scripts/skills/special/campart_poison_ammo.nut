this.campart_poison_ammo <- ::inherit("scripts/skills/skill", {
    m = {},
    function create()
    {
        this.m.ID = "special.campart_poison_ammo";
        this.m.Name = "Poisoned Ammo Effect";
        this.m.Description = "Poisons a target on hit.";
        this.m.Icon = "";
        this.m.SoundOnUse = [
            "sounds/combat/poison_applied_01.wav",
            "sounds/combat/poison_applied_02.wav"
        ];
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
                text = "Applies goblin poison on hit"
            });
        }
    }

    function onTargetHit( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
    {
        if (!this.m.Item.appliesTo(_skill)) return;

        // Copy-pasted from goblin_ambusher_racial
        // NOTE: we ignore minimim damage needed for bleeding
        if (_targetEntity.getCurrentProperties().IsImmuneToPoison || _targetEntity.getHitpoints() <= 0)
        {
            return;
        }

        if (!_targetEntity.isAlive())
        {
            return;
        }

        if (_targetEntity.getFlags().has("undead"))
        {
            return;
        }

        if (!_targetEntity.isHiddenToPlayer())
        {
            if (this.m.SoundOnUse.len() != 0)
            {
                this.Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], this.Const.Sound.Volume.RacialEffect * 1.5, _targetEntity.getPos());
            }

            this.Tactical.EventLog.log(this.Const.UI.getColorizedEntityName(_targetEntity) + " is poisoned");
        }

        this.spawnIcon("status_effect_54", _targetEntity.getTile());
        local poison = _targetEntity.getSkills().getSkillByID("effects.goblin_poison");

        if (poison == null)
        {
            _targetEntity.getSkills().add(this.new("scripts/skills/effects/goblin_poison_effect"));
        }
        else
        {
            poison.resetTime();
        }
    }
});
