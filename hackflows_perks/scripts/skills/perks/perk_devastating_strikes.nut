this.perk_devastating_strikes <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.devastating_strikes";
		this.m.Name = this.Const.Strings.PerkName.DevastatingStrikes;
		this.m.Description = this.Const.Strings.PerkDescription.DevastatingStrikes;
		this.m.Icon = "wotn_perks/devastating_strikes.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.DamageTotalMult *= 1.1;
	}

});

