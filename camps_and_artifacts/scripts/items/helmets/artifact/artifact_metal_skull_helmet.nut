this.artifact_metal_skull_helmet <- this.inherit("scripts/items/helmets/artifact/artifact_helmet", {
	m = {},
	function create()
	{
		this.artifact_helmet.create();
		this.m.ID = "armor.head.artifact_metal_skull_helmet";
		this.m.Description = "A skull-like mask made of meteoric iron. This piece is as massive as it is impressive.";
		this.m.NameList = [
			"Face of the North",
			"Fallen Skull",
			"Meteoric Facemask",
			"Aspect of the Clans",
			"Adamant Mask",
			"Steel Veil",
			"Ancient's Visage",
			"Pillager Gaze"
		];
		this.m.PrefixList = this.Const.Strings.BarbarianPrefix;
		this.m.UseRandomName = false;
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.HideCharacterHead = true;
		this.m.Variant = 232;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 15000;
		this.m.Condition = 210;
		this.m.ConditionMax = 210;
		this.m.StaminaModifier = -13;
		this.m.Vision = -1;
		this.randomizeValues();
		this.randomizePerks("light");
	}
});
