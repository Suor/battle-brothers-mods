this.preternatural_dodge_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {
		IsUsed = false
	},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.preternatural_dodge";
		this.m.Name = "Preternatural Dodge";
		this.m.Icon = "ui/traits/trait_icon_18.png";
		this.m.Description = "This character reacts with unnatural speed";

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
				text = "Dodges the first attack each round"
			}
		];
	}

	function onTurnStart()
	{
		this.m.IsUsed = false;
	}


	function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		if (this.m.IsUsed)
		{
			return;
		}

		if (_hitInfo.DamageDirect < 1.0)
		{
			this.m.IsUsed = true;
			this.Tactical.EventLog.log("Dodge!");
			_properties.DamageReceivedTotalMult = 0.0;
		}
	}

});

