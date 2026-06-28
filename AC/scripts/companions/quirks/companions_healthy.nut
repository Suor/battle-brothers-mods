this.companions_healthy <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "quirk.healthy";
		this.m.Name = "Healthy";
		this.m.Description = "This entity is a picture of health.";
		this.m.Icon = "ui/traits/trait_icon_14.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = true;
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.Hitpoints += 25;
	}
});
