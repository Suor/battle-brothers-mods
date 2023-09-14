this.perk_stalwart <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "perk.stalwart";
		this.m.Name = this.Const.Strings.PerkName.Stalwart;
		this.m.Description = this.Const.Strings.PerkDescription.Stalwart;
		this.m.Icon = "wotn_perks/stalwart.png";
		this.m.Type = this.Const.SkillType.Perk;
		this.m.Order = this.Const.SkillOrder.Perk;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
	}

	function onUpdate( _properties )
	{
		_properties.IsImmuneToKnockBackAndGrab = true;
	}

});

