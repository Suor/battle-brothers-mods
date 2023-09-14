this.double_strike_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.double_strike";
		this.m.Name = "Double Strike!";
		this.m.Icon = "wotn_perks/double_strike.png";
		this.m.IconMini = "double_strike_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Having just landed a hit, this character is ready to perform a powerful followup strike! The next attack will inflict [color=" + this.Const.UI.Color.PositiveValue + "]+20%[/color] damage to a single target. If multiple targets are hit, only the first one will receive increased damage. If the attack misses, the effect is wasted.";
	}

	function onAdded()
	{
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null)
		{
			return;
		}

		if (!this.m.IsGarbage)
		{
			this.removeSelf();
		}
	}
	
	function onUpdate( _properties )
	{
		_properties.DamageTotalMult *= 1.2;
	}

});

