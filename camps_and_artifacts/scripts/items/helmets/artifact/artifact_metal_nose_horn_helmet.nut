this.artifact_metal_nose_horn_helmet <- this.inherit("scripts/items/helmets/artifact/artifact_helmet", {
	m = {},
	function create()
	{
		this.artifact_helmet.create();
		this.m.ID = "armor.head.artifact_metal_nose_horn_helmet";
		this.m.Description = "This helmet must have belonged to a legendary warrior of the barbarians. Its size and design appear alien to all southern folks.";
		this.m.NameList = [
			"Hermetic Helmet",
			"Spiked Headpiece",
			"Bladed Headguard",
			"Meteoric Faceguard"
		];
		this.m.PrefixList = this.Const.Strings.BarbarianPrefix;
		this.m.UseRandomName = false;
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.HideCharacterHead = true;
		this.m.Variant = 234;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 15000;
		this.m.Condition = 230;
		this.m.ConditionMax = 230;
		this.m.StaminaModifier = -15;
		this.m.Vision = -1;
		this.randomizeValues();
		this.randomizePerks("heavy");
	}

	function getTooltip()
	{
		local result = this.helmet.getTooltip();
		result.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = this.m.APTooltip
		});
		return result;
	}

	function onEquip()
	{
		this.artifact_helmet.onEquip();
		local c = this.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull() && this.m.AttachedPerk != "")
		{
			this.m.Container.getActor().getSkills().add(this.new(this.m.AttachedPerk));
		}
	}

	function onUnequip()
	{
		this.artifact_helmet.onUnequip();
		local c = this.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull() && this.m.AttachedPerk != "")
		{
			this.m.Container.getActor().getSkills().removeAllByID(this.m.APID);
		}

	}

});

