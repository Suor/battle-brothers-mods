this.artifact_sallet_green_helmet <- this.inherit("scripts/items/helmets/artifact/artifact_helmet", {
	m = {},
	function create()
	{
		this.artifact_helmet.create();
		this.m.ID = "armor.head.artifact_sallet_green";
		this.m.Description = "A inscrutable sallet supported by a mail coif, crested with gossamer ribbons.";
		this.m.NameList = [
			"Decorated Sallet",
			"Eerie Sallet",
			"Auric Sallet",
			"Ribboned Sallet"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.Variant = 49;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 17000;
		this.m.Condition = 150;
		this.m.ConditionMax = 265;
		this.m.StaminaModifier = -18;
		this.m.Vision = 0;
		this.randomizeValues();
		this.randomizePerks("heavy");
	}
});
