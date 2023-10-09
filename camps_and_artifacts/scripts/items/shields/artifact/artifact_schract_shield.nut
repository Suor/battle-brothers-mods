this.artifact_schract_shield <- this.inherit("scripts/items/shields/artifact/artifact_shield", {
	m = {},
	function create()
	{
		this.artifact_shield.create();
		this.m.Variant = 8;
		this.updateVariant();
		this.m.ID = "shield.artifact_schract_shield";
		this.m.NameList = this.Const.Strings.ArtifactShieldNames;
		this.m.Description = "This long wooden shield seems to have been grown rather than crafted.  The continual growth of the wood has kept it whole for an age.";
		this.m.AddGenericSkill = true;
		this.m.ShowOnCharacter = true;
		this.m.Value = 11700;
		this.m.MeleeDefense = 20;
		this.m.RangedDefense = 17;
		this.m.StaminaModifier = -16;
		this.m.Condition = 48;
		this.m.ConditionMax = 48;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.Sprite = "shield_named_0" + this.m.Variant;
		this.m.SpriteDamaged = "shield_named_0" + this.m.Variant + "_damaged";
		this.m.ShieldDecal = "shield_named_0" + this.m.Variant + "_destroyed";
		this.m.IconLarge = "shields/inventory_named_shield_0" + this.m.Variant + ".png";
		this.m.Icon = "shields/icon_named_shield_0" + this.m.Variant + ".png";
	}

	function getTooltip()
	{
		local result = this.shield.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Regenerates itself by [color=" + this.Const.UI.Color.PositiveValue + "]4[/color] points of durability each turn."
		});
		return result;
	}

	function onEquip()
	{
		this.artifact_shield.onEquip();
		this.addSkill(this.new("scripts/skills/actives/shieldwall"));
		this.addSkill(this.new("scripts/skills/actives/knock_back"));
	}

	function onTurnStart()
	{
		this.m.Condition = this.Math.min(this.m.ConditionMax, this.m.Condition + 4);
		this.updateAppearance();
	}

	function onCombatFinished()
	{
		this.m.Condition = this.m.ConditionMax;
		this.updateAppearance();
	}

});

