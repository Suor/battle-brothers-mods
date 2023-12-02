this.artifact_pike <- this.inherit("scripts/items/weapons/artifact/artifact_weapon", {
	m = {},
	function create()
	{
		this.artifact_weapon.create();
		this.m.Variant = this.Math.rand(1, 3);
		this.updateVariant();
		this.m.ID = "weapon.artifact_pike";
		this.m.NameList = this.Const.Strings.ArtifactPolearmNames;
		this.m.Description = "This pike, forged of a strange metal, seems strangely light.  It moves with the ease of a much smaller weapon; its tip passes easily through metal and flesh.";
		this.m.Categories = "Polearm, Two-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded | this.Const.Items.ItemType.Defensive;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 12800;
		this.m.ShieldDamage = 0;
		this.m.Condition = 64.0;
		this.m.ConditionMax = 64.0;
		this.m.StaminaModifier = -14;
		this.m.RangeMin = 1;
		this.m.RangeMax = 2;
		this.m.RangeIdeal = 2;
		this.m.RegularDamage = 60;
		this.m.RegularDamageMax = 80;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.3;
		this.m.ChanceToHitHead = 5;
		if (::CampsAndArtifacts.Mods.Reforged) {
			this.m.Reach = 7;
		}
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/pike_01_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/pike_01_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_named_pike_0" + this.m.Variant;
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

