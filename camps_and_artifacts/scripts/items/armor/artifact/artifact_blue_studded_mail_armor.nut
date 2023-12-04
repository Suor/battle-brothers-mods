this.artifact_blue_studded_mail_armor <- this.inherit("scripts/items/armor/artifact/artifact_armor", {
	m = {},
	function create()
	{
		this.artifact_armor.create();
		this.m.ID = "armor.body.artifact_blue_studded_mail";
		this.m.Description = "This silvery mail shirt is combined with a gambeson and covered with a tough, riveted leather jacket for a light yet exceedingly resilient armor.";
		this.m.NameList = [
			"Padded Mythril",
			"Impskin",
			"Feyskin"
		];
		this.m.Variant = 46;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 14000;
		this.m.Condition = 150;
		this.m.ConditionMax = 150;
		this.m.StaminaModifier = -18;
		this.randomizeValues();
		this.randomizePerks("light");
	}
});
