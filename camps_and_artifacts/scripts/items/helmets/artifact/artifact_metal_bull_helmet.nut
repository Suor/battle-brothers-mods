this.artifact_metal_bull_helmet <- this.inherit("scripts/items/helmets/artifact/artifact_helmet", {
	m = {},
	function create()
	{
		this.artifact_helmet.create();
		this.m.ID = "armor.head.artifact_metal_bull_helmet";
		this.m.Description = "A reinforced helmet made from an meteoric iron. It is richly decorated and heavy but offers extraordinary protection.";
		this.m.NameList = [
			"Spiked Helmet",
			"Meteoric Headpiece",
			"Meteoric Sallet",
			"Protector",
			"Spiked Crest"
		];
		this.m.PrefixList = this.Const.Strings.BarbarianPrefix;
		this.m.UseRandomName = false;
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.Variant = 233;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 18000;
		this.m.Condition = 300;
		this.m.ConditionMax = 300;
		this.m.StaminaModifier = -22;
		this.m.Vision = -2;
		this.randomizeValues();
		this.randomizePerks("heavy");
	}
});
