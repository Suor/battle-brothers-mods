this.artifact_black_leather_armor <- this.inherit("scripts/items/armor/artifact/artifact_armor", {
	m = {},
	function create()
	{
		this.artifact_armor.create();
		this.m.ID = "armor.body.artifact_black_leather";
		this.m.Description = "Leather armor from a tough but supple beast hide that you cannot recognize, supported by a padded gambeson and chainmail. Light to wear but incredibly sturdy.";
		this.m.NameList = [
			"Second Skin",
			"Coldstream Guard",
			"Black Coat",
			"Nightcloak",
			"Vantablack",
			"Dark Omen"
		];
		this.m.Variant = 42;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 12000;
		this.m.Condition = 110;
		this.m.ConditionMax = 110;
		this.m.StaminaModifier = -11;
		this.randomizeValues();
		this.randomizePerks("light");
	}
});
