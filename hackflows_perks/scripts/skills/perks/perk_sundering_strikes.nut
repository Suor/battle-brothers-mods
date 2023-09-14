this.perk_sundering_strikes <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.sundering_strikes";
		this.m.Name = this.Const.Strings.PerkName.SunderingStrikes;
		this.m.Description = this.Const.Strings.PerkDescription.SunderingStrikes;
		this.m.Icon = "wotn_perks/sundering_strikes.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.DamageArmorMult += 0.2;
	}

});

