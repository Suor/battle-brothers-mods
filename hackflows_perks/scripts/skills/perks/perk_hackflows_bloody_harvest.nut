this.perk_hackflows_bloody_harvest <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.hackflows.bloody_harvest";
		this.m.Name = ::Const.Perks.LookupMap[this.m.ID].Name;
		this.m.Description = ::Const.Perks.LookupMap[this.m.ID].Description;
		this.m.Icon = "hackflows_perks/bloody_harvest.png";
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
