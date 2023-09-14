this.vengeance_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.vengeance";
		this.m.Name = "Vengeance!";
		this.m.Icon = "wotn_perks/vengeance.png";
		this.m.IconMini = "vengeance_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getDescription()
	{
		return "Having just received a hit, this character is spurred on for gruesome act of revenge! The next attack will inflict [color=" + this.Const.UI.Color.PositiveValue + "]+20%[/color] damage to a single target. If multiple targets are hit, only the first one will receive increased damage. If the attack misses, the effect is wasted.";
	}

	function onAdded()
	{
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_targetEntity == null || !_skill.isAttack()) return;
		if (!this.m.IsGarbage) this.removeSelf();
	}
	
	function onUpdate( _properties )
	{
		_properties.DamageTotalMult *= 1.2;
	}

});

