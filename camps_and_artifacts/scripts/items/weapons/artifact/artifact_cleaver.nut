this.artifact_cleaver <- this.inherit("scripts/items/weapons/artifact/artifact_weapon", {
	m = {},
	function create()
	{
		this.artifact_weapon.create();
		this.m.Variant = this.Math.rand(1, 3);
		this.updateVariant();
		this.m.ID = "weapon.artifact_cleaver";
		this.m.NameList = this.Const.Strings.ArtifactSwordNames;
		this.m.Description = "A sword of legend.  This blade bears the mark of an ancient tyrant, built for dismembering opponents and seeming to call out for blood.";
		this.m.Categories = "Cleaver, One-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ShieldDamage = 0;
		this.m.Condition = 80.0;
		this.m.ConditionMax = 80.0;
		this.m.StaminaModifier = -12;
		this.m.Value = 13800;
		this.m.RegularDamage = 40;
		this.m.RegularDamageMax = 60;
		this.m.ArmorDamageMult = 0.9;
		this.m.DirectDamageMult = 0.25;
		if (::CampsAndArtifacts.Mods.Reforged) this.m.Reach = 4;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/cleaver_01_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/cleaver_01_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_named_cleaver_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.artifact_weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/cleave"));
		this.addSkill(this.new("scripts/skills/actives/decapitate"));
	}

});

