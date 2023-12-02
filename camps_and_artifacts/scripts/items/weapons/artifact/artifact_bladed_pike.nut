this.artifact_bladed_pike <- this.inherit("scripts/items/weapons/artifact/artifact_weapon", {
	m = {},
	function create()
	{
		this.artifact_weapon.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "weapon.artifact_bladed_pike";
		this.m.NameList = this.Const.Strings.ArtifactPolearmNames;
		this.m.UseRandomName = false;
		this.m.Description = "A masterwork of the old empire. Strange magic has kept this pike preserved and deadly through countless millenia.";
		this.m.Categories = "Polearm, Two-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 12200;
		this.m.ShieldDamage = 0;
		this.m.Condition = 50.0;
		this.m.ConditionMax = 50.0;
		this.m.StaminaModifier = -14;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 55;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 1.25;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 5;
		if (::CampsAndArtifacts.Mods.Reforged) this.m.Reach = 7;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/bladed_pike_01_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/bladed_pike_01_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_bladed_pike_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.artifact_weapon.onEquip();
		local impale = this.new("scripts/skills/actives/impale");
		impale.m.Icon = "skills/active_54.png";
		impale.m.IconDisabled = "skills/active_54_sw.png";
		impale.m.Overlay = "active_54";
		this.addSkill(impale);
		this.addSkill(this.new("scripts/skills/actives/repel"));
	}

});

