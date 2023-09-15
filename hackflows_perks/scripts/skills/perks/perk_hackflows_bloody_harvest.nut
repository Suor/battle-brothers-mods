this.perk_hackflows_bloody_harvest <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.hackflows.bloody_harvest";
		this.m.Name = this.Const.Strings.PerkName.BloodyHarvest;
		this.m.Description = this.Const.Strings.PerkDescription.BloodyHarvest;
		this.m.Icon = "wotn_perks/double_strike.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill.isAOE() && _skill.isAttack())
		{
			_properties.MeleeSkill += 10;
			_properties.RangedSkill += 10;
		}
	}

});
