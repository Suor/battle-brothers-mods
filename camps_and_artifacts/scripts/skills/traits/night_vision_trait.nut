this.night_vision_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.night_vision";
		this.m.Name = "Night Vision";
		this.m.Icon = "skills/status_effect_98.png";
		this.m.Description = "Sees in the dark, clear as day";
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
				icon = "ui/icons/special.png",
				text = "Unaffected by Nighttime effect"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.IsAffectedByNight = false;
	}

});

