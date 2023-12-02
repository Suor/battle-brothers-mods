this.artifact_warbow <- this.inherit("scripts/items/weapons/artifact/artifact_weapon", {
	m = {},
	function create()
	{
		this.artifact_weapon.create();
		this.m.Variant = this.Math.rand(1, 3);
		this.updateVariant();
		this.m.ID = "weapon.artifact_warbow";
		this.m.NameList = this.Const.Strings.ArtifactBowNames;
		this.m.Description = "This bow seems to have been grown rather than hewn.  Light and impossibly strong, you have never seen its equal.";
		this.m.Categories = "Bow, Two-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.RangedWeapon | this.Const.Items.ItemType.Defensive;
		this.m.EquipSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = true;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 14600;
		this.m.RangeMin = 2;
		this.m.RangeMax = 7;
		this.m.RangeIdeal = 7;
		this.m.StaminaModifier = -6;
		this.m.Condition = 100.0;
		this.m.ConditionMax = 100.0;
		this.m.RegularDamage = 50;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 0.6;
		if (::CampsAndArtifacts.Mods.SatoBalance) this.m.ArmorDamageMult += 0.05;
		this.m.DirectDamageMult = 0.35;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/ranged/bow_01_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/ranged/bow_01_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_named_bow_0" + this.m.Variant;
	}

	function getAmmoID()
	{
		return "ammo.arrows";
	}

	function onEquip()
	{
		this.artifact_weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/quick_shot"));
		this.addSkill(this.new("scripts/skills/actives/aimed_shot"));
	}

});

