this.perk_battering_ram <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.battering_ram";
		this.m.Name = this.Const.Strings.PerkName.BatteringRam;
		this.m.Description = this.Const.Strings.PerkDescription.BatteringRam;
		this.m.Icon = "wotn_perks/battering_ram.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsImmuneToStun = true;
	}

});

