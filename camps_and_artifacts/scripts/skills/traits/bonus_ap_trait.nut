this.bonus_ap_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.bonus_ap";
		this.m.Name = "Bonus AP";
		this.m.Icon = "ui/traits/trait_icon_46.png";
		this.m.Description = "Moving faster than most men";

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
			},
			{
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+1[/color] Action Point"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.ActionPoints += 1;
	}

});

