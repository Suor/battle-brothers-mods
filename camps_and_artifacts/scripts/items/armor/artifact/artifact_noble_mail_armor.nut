this.artifact_noble_mail_armor <- this.inherit("scripts/items/armor/artifact/artifact_armor", {
	m = {},
	function create()
	{
		this.artifact_armor.create();
		this.m.ID = "armor.body.artifact_noble_mail_armor";
		this.m.Description = "This piece of light mail armor seems to be made of lowing silver. It is incredibly light, yet nearly indestructible.";
		this.m.NameList = [
			"Mythril Shirt",
			"Auric Mail",
			"Kingsguard",
			"Fencing Paragon"
		];
		this.m.Variant = 99;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 15500;
		this.m.Condition = 160;
		this.m.ConditionMax = 160;
		this.m.StaminaModifier = -15;
		this.randomizeValues();
		this.randomizePerks("light");
	}
});
