this.artifact_norse_helmet <- this.inherit("scripts/items/helmets/artifact/artifact_helmet", {
	m = {},
	function create()
	{
		this.artifact_helmet.create();
		this.m.ID = "armor.head.artifact_norse_helmet";
		this.m.Description = "An exquisite nordic helmet that must have belonged to a high king or exalted champion, thought lost to time.";
		this.m.NameList = [
			"Highlord's Helmet",
			"Lord's Nasal Helmet",
			"Mythril Faceguard",
			"Meteoric Norse Helmet",
			"Odin's Helmet"
		];
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.Variant = 203;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 2000;
		this.m.Condition = 125;
		this.m.ConditionMax = 125;
		this.m.StaminaModifier = -6;
		this.m.Vision = -1;
		this.randomizeValues();
		this.randomizePerks("light");
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

