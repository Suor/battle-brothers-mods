this.artifact_lindwurm_armor <- this.inherit("scripts/items/armor/artifact/artifact_armor", {
	m = {},
	function create()
	{
		this.artifact_armor.create();
		this.m.ID = "armor.body.artifact_lindwurm_armor";
		this.m.Description = "The sturdy scales of a true dragon sewn together ontop a heavy chainmail. Though you doubt the existence of such a beast, this relic makes you reconsider. The shimmering scales remain untouched by any corroding Lindwurm blood.";
		this.m.NameList = [
			"True Dragon Scales",
			"True Dragon\'s Hide",
			"Dragon\'s Harness",
			"Dragon\'s Coat",
			"Dragoncales",
			"Coat of the Dragon"
		];
		this.m.Variant = 82;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 27500;
		this.m.Condition = 300;
		this.m.ConditionMax = 300;
		this.m.StaminaModifier = -36;
		this.randomizeValues();
		this.randomizePerks("heavy");
	}

	function getTooltip()
	{
		local result = this.armor.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Unaffected by acidic Lindwurm blood"
		});
		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = this.m.APTooltip
		});
		return result;
	}
});

