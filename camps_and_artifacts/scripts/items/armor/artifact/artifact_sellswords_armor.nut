this.artifact_sellswords_armor <- this.inherit("scripts/items/armor/artifact/artifact_armor", {
	m = {},
	function create()
	{
		this.artifact_armor.create();
		this.m.ID = "armor.body.artifact_sellswords_armor";
		this.m.Description = "This piece of layered armor bears the hallmarks of a hero of legend. Its incredible resilience and flexibility make it a irreplacible piece of craftsmanship.";
		this.m.NameList = [
			"Legend\'s Coat",
			"Paragon\'s Hide",
			"Hero\'s Layered Armor",
			"King\'s Plated Coat"
		];
		this.m.Variant = 101;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 20000;
		this.m.Condition = 260;
		this.m.ConditionMax = 260;
		this.m.StaminaModifier = -32;
		this.randomizeValues();
		this.randomizePerks("heavy");
	}
});
