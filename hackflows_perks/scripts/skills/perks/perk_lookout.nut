this.perk_lookout <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.lookout";
		this.m.Name = this.Const.Strings.PerkName.Lookout;
		this.m.Description = this.Const.Strings.PerkDescription.Lookout;
		this.m.Icon = "wotn_perks/lookout.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.Vision += 1;
	}

});
