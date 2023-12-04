this.artifact_golden_scale_armor <- this.inherit("scripts/items/armor/artifact/artifact_armor", {
	m = {},
	function create()
	{
		this.artifact_armor.create();
		this.m.ID = "armor.body.artifact_golden_scale";
		this.m.Description = "A scale armor made of small, interlocking scales. You swear that this armor is truly made of the scales of a golden dragon.";
		this.m.NameList = [
			"Brilliant Scale Shirt",
			"Lusterous Scale Armor",
			"Paladine's Dragonskin",
			"Dragon Scales",
			"Golden Wyrmskin",
			"Goldskin",
			"Prismatic Scale Tunic",
			"Auric Armor",
			"Auric Dawn"
		];
		this.m.Variant = 44;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 18000;
		this.m.Condition = 230;
		this.m.ConditionMax = 230;
		this.m.StaminaModifier = -30;
		this.randomizeValues();
		this.randomizePerks("heavy");
	}
});
