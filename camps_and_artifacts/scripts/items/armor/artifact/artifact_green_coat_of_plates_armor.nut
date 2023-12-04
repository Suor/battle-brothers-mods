this.artifact_green_coat_of_plates_armor <- this.inherit("scripts/items/armor/artifact/artifact_armor", {
	m = {},
	function create()
	{
		this.artifact_armor.create();
		this.m.ID = "armor.body.artifact_green_coat_of_plates";
		this.m.Description = "A coat of plates crafted from strange metal.  Dark lines swirl and flow through the metal.";
		this.m.NameList = [
			"Coat of Damascus",
			"Bulwark",
			"Invulnerable Carapace",
			"Adamant Shell",
			"Damascus Plate Cuirass",
			"Green Plate Coat",
			"Argent Harness",
			"Ward"
		];
		this.m.Variant = 43;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 25000;
		this.m.Condition = 320;
		this.m.ConditionMax = 320;
		this.m.StaminaModifier = -42;
		this.randomizeValues();
		this.randomizePerks("heavy");
	}
});
