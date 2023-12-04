this.artifact_heraldic_mail_helmet <- this.inherit("scripts/items/helmets/artifact/artifact_helmet", {
	m = {},
	function create()
	{
		this.artifact_helmet.create();
		this.m.ID = "armor.head.artifact_heraldic_mail";
		this.m.Description = "A meteoric iron bascinet with a moveable visor, worn over a mail coif. A relic befitting a king.";
		this.m.NameList = [
			"Kingly Bascinet",
			"Argent Bascinet",
			"Argent Helmet",
			"Kingly Helm"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.Variant = 53;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 18000;
		this.m.Condition = 280;
		this.m.ConditionMax = 280;
		this.m.StaminaModifier = -19;
		this.m.Vision = -1;
		this.randomizeValues();
		this.randomizePerks("heavy");
	}
});
