this.perk_rebound <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.rebound";
		this.m.Name = this.Const.Strings.PerkName.Rebound;
		this.m.Description = this.Const.Strings.PerkDescription.Rebound;
		this.m.Icon = "wotn_perks/rebound.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.FatigueRecoveryRate += 5;
	}

});
