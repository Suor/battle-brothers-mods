this.artifact_golden_feathers_helmet <- this.inherit("scripts/items/helmets/artifact/artifact_helmet", {
	m = {},
	function create()
	{
		this.artifact_helmet.create();
		this.m.ID = "armor.head.artifact_golden_feathers";
		this.m.Description = "A helmet of strange alloy, combined with a full mail coif for incomperable protection.";
		this.m.NameList = [
			"Golden Headpiece",
			"Golden Skullcap",
			"Peacock Helm",
			"Prismatic Helmet"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 50;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 16000;
		this.m.Condition = 240;
		this.m.ConditionMax = 240;
		this.m.StaminaModifier = -16;
		this.m.Vision = -2;
		this.randomizeValues();
		this.randomizePerks("heavy");
	}
});
