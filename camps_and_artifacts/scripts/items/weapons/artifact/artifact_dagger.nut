this.artifact_dagger <- this.inherit("scripts/items/weapons/artifact/artifact_weapon", {
	m = {},
	function create()
	{
		this.artifact_weapon.create();
		this.m.Variant = this.Math.rand(1, 3);
		this.updateVariant();
		this.m.ID = "weapon.artifact_dagger";
		this.m.NameList = this.Const.Strings.ArtifactDaggerNames;
		this.m.Description = "An impossibly sharp short blade.  This eerie dagger never seems to lose its edge.";
		this.m.Categories = "Dagger, One-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.OneHanded;
		this.m.IsDoubleGrippable = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Condition = 50.0;
		this.m.ConditionMax = 50.0;
		this.m.Value = 11500;
		this.m.RegularDamage = 20;
		this.m.RegularDamageMax = 40;
		this.m.ArmorDamageMult = 0.7;
		this.m.DirectDamageMult = 0.2;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/dagger_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/dagger_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_named_dagger_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.artifact_weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/stab"));
		this.addSkill(this.new("scripts/skills/actives/puncture"));
	}

});

