this.companions_good_boy <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "quirk.good_boy";
		this.m.Name = "Good Boy/Girl";
		this.m.Description = "Who\'s a good boy?!";
		this.m.Icon = "skills/status_effect_06.png";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.Order = this.Const.SkillOrder.VeryLast;
		this.m.IsActive = false;
		this.m.IsStacking = false;
		this.m.IsHidden = false;
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
		local bonus = this.getContainer().getActor().m.Item.m.Level - 10;
		_properties.DamageRegularMin += this.Math.floor(0.5 * bonus);
		_properties.DamageRegularMax += this.Math.floor(1.0 * bonus);
	}
});
