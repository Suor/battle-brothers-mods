this.companions_soften_blows <- this.inherit("scripts/skills/skill", {
	m = {
		IsUsed = false
	},
	function create()
	{
		this.m.ID = "quirk.soften_blows";
		this.m.Name = "Soften Blows";
		this.m.Description = "Brace yourself for incoming attacks!";
		this.m.Icon = "skills/status_effect_104.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
	}

	function onAdded()
	{
		this.m.IsUsed = false;
		this.m.IsHidden = false;
	}

	function onTurnStart()
	{
		this.m.IsUsed = false;
		this.m.IsHidden = false;
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (this.m.IsUsed)
		{
			return;
		}
		if (this.getContainer().getActor().getCurrentProperties().IsStunned)
		{
			return;
		}
		if (this.getContainer().getActor().getMoraleState() == this.Const.MoraleState.Fleeing)
		{
			return;
		}

		this.m.IsUsed = true;
		this.m.IsHidden = true;
		_properties.DamageReceivedTotalMult *= 0.75;
	}
});
