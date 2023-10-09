this.mind_immune_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.mind_immune";
		this.m.Name = "Mind Immune";
		this.m.Icon = "ui/perks/perk_08.png";
		this.m.Description = "Immune to mental effects";
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
				text = "Immune against fear and mind control abilities"
			}
		];
	}

	function onUpdate( _properties )
	{
		_properties.MoraleCheckBraveryMult[this.Const.MoraleCheckType.MentalAttack] *= 1000.0;
	}

});

