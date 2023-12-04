this.artifact_brown_coat_of_plates_armor <- this.inherit("scripts/items/armor/artifact/artifact_armor", {
	m = {},
	function create()
	{
		this.artifact_armor.create();
		this.m.ID = "armor.body.artifact_brown_coat_of_plates";
		this.m.Description = "A thick mail hauberk combined with plates of meteoric iron. This armor will protect its wearer even in the pandemonium of battle.";
		this.m.NameList = [
			"Hard Harness",
			"Ward",
			"Paragon's Defense",
			"Barrier of the Ages",
			"Meteoric Plate Armor",
			"Meteoric Plated Vest",
			"Lifesaver"
		];
		this.m.Variant = 45;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 24000;
		this.m.Condition = 300;
		this.m.ConditionMax = 300;
		this.m.StaminaModifier = -36;
		this.randomizeValues();
		this.randomizePerks("heavy");
	}
});
