this.last_stand_effect <- this.inherit("scripts/skills/skill", {
	m = {
		IsEnabled = true,
		LastDamageTakenInRound = 0
	},
	function create()
	{
		this.m.ID = "effects.last_stand";
		this.m.Name = "Last Stand";
		this.m.Description = "Sheer resolve improves the character's melee and ranged defense at the closing brink of defeat.";
		this.m.Icon = "ui/perks/perk_32.png";
		this.m.IconMini = "perk_32_mini";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function getTooltip()
	{
		local healthBonus = 1.0 - this.getContainer().getActor().getHitpoints() / this.getContainer().getActor().getHitpointsMax();
		local meleeBonus = this.Math.floor(this.getContainer().getActor().getCurrentProperties().getMeleeDefense() * healthBonus);
		local rangedBonus = this.Math.floor(this.getContainer().getActor().getCurrentProperties().getRangedDefense() * healthBonus);
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
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + meleeBonus + "[/color] Melee Defense"
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + rangedBonus + "[/color] Ranged Defense"
			}
		];
	}

	function onUpdate( _properties )
	{
		if (this.m.IsEnabled)
		{
			local healthBonus = 1.0 - this.getContainer().getActor().getHitpoints() / this.getContainer().getActor().getHitpointsMax();
			_properties.MeleeDefense += this.Math.max(0, this.Math.floor(_properties.MeleeDefense*healthBonus));
			_properties.RangedDefense += this.Math.max(0, this.Math.floor(_properties.RangedDefense*healthBonus));
		}
	}

});

