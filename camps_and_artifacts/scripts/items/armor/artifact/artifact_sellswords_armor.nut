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

	function getTooltip()
	{
		local result = this.armor.getTooltip();
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
		this.artifact_armor.onEquip();
		local c = this.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull() && this.m.AttachedPerk != "")
		{
			this.m.Container.getActor().getSkills().add(this.new(this.m.AttachedPerk));
		}
	}

	function onUnequip()
	{
		this.artifact_armor.onUnequip();
		local c = this.getContainer();

		if (c != null && c.getActor() != null && !c.getActor().isNull() && this.m.AttachedPerk != "")
		{
			this.m.Container.getActor().getSkills().removeAllByID(this.m.APID);
		}

	}

});

