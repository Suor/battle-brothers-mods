this.artifact_leopard_armor <- this.inherit("scripts/items/armor/artifact/artifact_armor", {
	m = {},
	function create()
	{
		this.artifact_armor.create();
		this.m.ID = "armor.body.artifact_leopard_armor";
		this.m.Description = "A heavy lamellar plate harness combined with exquisite mail and luxurious padding. An exceptional piece that is almost too precious to be torn in battle.";
		this.m.NameList = [
			"Sultan\'s Embrace",
			"Sultan\'s Guard",
			"Resplendant Lamellar",
			"Sultan\'s Harness",
			"Carapace of the Blazing Sands",
			"Nimrod\'s Armor"
		];
		this.m.VariantString = "body_southern_named";
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 25000;
		this.m.Condition = 290;
		this.m.ConditionMax = 290;
		this.m.StaminaModifier = -35;
		this.randomizeValues();
		this.randomizePerks("heavy");
	}
});
