this.grab_immune_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.grab_immune";
		this.m.Name = "Grab Immune";
		this.m.Icon = "ui/traits/trait_icon_43.png";
		this.m.Description = "Immune to grab effects";
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
				text = "Immunity to being rooted by nets or grasping vines"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.IsImmuneToRoot = true;
	}

});

