this.perk_steadfast <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.steadfast";
		this.m.Name = this.Const.Strings.PerkName.Steadfast;
		this.m.Description = this.Const.Strings.PerkDescription.Steadfast;
		this.m.Icon = "wotn_perks/clarity_circle.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.FatigueLossOnAnyAttackMult = 0.5;
	}

});

