this.perk_hackflows_balance <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.hackflows.balance";
		this.m.Name = ::Const.Perks.LookupMap[this.m.ID].Name;
		this.m.Description = ::Const.Perks.LookupMap[this.m.ID].Description;
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

