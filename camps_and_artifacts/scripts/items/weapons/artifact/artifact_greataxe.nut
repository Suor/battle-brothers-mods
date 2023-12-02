this.artifact_greataxe <- this.inherit("scripts/items/weapons/artifact/artifact_weapon", {
	m = {},
	function create()
	{
		this.artifact_weapon.create();
		this.m.Variant = this.Math.rand(1, 5);
		this.updateVariant();
		this.m.ID = "weapon.artifact_greataxe";
		this.m.NameList = this.Const.Strings.ArtifactAxeNames;
		this.m.Description = "A massive weapon forged from meteoric iron.  This two-handed axe hums as it cleaves through armor, flesh, and bone.";
		this.m.Categories = "Axe, Two-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 14600;
		this.m.ShieldDamage = 36;
		this.m.Condition = 72.0;
		this.m.ConditionMax = 72.0;
		this.m.StaminaModifier = -16;
		this.m.RegularDamage = 80;
		this.m.RegularDamageMax = 100;
		this.m.ArmorDamageMult = 1.5;
		this.m.DirectDamageMult = 0.4;
		this.m.ChanceToHitHead = 0;
		if (::CampsAndArtifacts.Mods.Reforged) {
			this.m.Reach = 5;
			this.m.ShieldDamage = 40;
		}
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/axe_two_handed_01_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/axe_two_handed_01_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_named_two_handed_axe_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.artifact_weapon.onEquip();
		this.addSkill(this.new("scripts/skills/actives/split_man"));
		this.addSkill(this.new("scripts/skills/actives/round_swing"));
		local skillToAdd = this.new("scripts/skills/actives/split_shield");
		skillToAdd.setApplyAxeMastery(true);
		skillToAdd.setFatigueCost(skillToAdd.getFatigueCostRaw() + 5);
		this.addSkill(skillToAdd);
	}

});

