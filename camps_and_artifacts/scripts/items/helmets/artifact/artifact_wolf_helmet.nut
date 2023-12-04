this.artifact_wolf_helmet <- this.inherit("scripts/items/helmets/artifact/artifact_helmet", {
	m = {},
	function create()
	{
		this.artifact_helmet.create();
		this.m.ID = "armor.head.artifact_wolf";
		this.m.Description = "A silvery metal helmet with attached mail, covered with an impressive wolf head.";
		this.m.NameList = [
			"Primal Cap",
			"Helmet of the Beast",
			"Berserker Coif",
			"Beast King Coif",
			"Dire Wolf Crown",
			"Apex Predator Crown"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.Variant = 48;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 12000;
		this.m.Condition = 140;
		this.m.ConditionMax = 140;
		this.m.StaminaModifier = -8;
		this.randomizeValues();
		this.randomizePerks("light");
	}
});
