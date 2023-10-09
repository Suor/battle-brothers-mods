this.grant_linebreaker_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.grant_linebreaker";
		this.m.Name = "Grants Linebreaker";
		this.m.Icon = "ui/traits/trait_icon_10.png";
		this.m.Description = "Enables the Linebreaker Skill";

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
				text = "Enables the Linebreaker skill"
			}
		];
	}

	function onAdded()
	{
		if (!this.m.Container.hasSkill("actives.line_breaker"))
		{
			this.m.Container.add(this.new("scripts/skills/actives/line_breaker"));
		}
	}

	function onRemoved()
	{
		this.m.Container.removeByID("actives.line_breaker");
	}

});

