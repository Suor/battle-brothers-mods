this.artifact_two_handed_mace <- this.inherit("scripts/items/weapons/artifact/artifact_weapon", {
	m = {},
	function create()
	{
		this.artifact_weapon.create();
		this.m.Variant = this.Math.rand(1, 2);
		this.updateVariant();
		this.m.ID = "weapon.artifact_two_handed_mace";
		this.m.NameList = this.Const.Strings.ArtifactMaceNames;
		this.m.Description = "A massive two-handed mace whose construction has been lost to time.  This weapon is a true terror when weilded by a skilled hand.";
		this.m.Categories = "Mace, Two-Handed";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.Value = 13400;
		this.m.ShieldDamage = 26;
		this.m.Condition = 120.0;
		this.m.ConditionMax = 120.0;
		this.m.StaminaModifier = -16;
		this.m.RegularDamage = 75;
		this.m.RegularDamageMax = 95;
		this.m.ArmorDamageMult = 1.25;
		this.m.DirectDamageMult = 0.5;
		this.m.ChanceToHitHead = 0;
		if (::CampsAndArtifacts.Mods.Reforged) {
			this.m.Reach = 5;
			this.m.ShieldDamage = 22;
		}
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.IconLarge = "weapons/melee/mace_two_handed_02_named_0" + this.m.Variant + ".png";
		this.m.Icon = "weapons/melee/mace_two_handed_02_named_0" + this.m.Variant + "_70x70.png";
		this.m.ArmamentIcon = "icon_mace_two_handed_02_named_0" + this.m.Variant;
	}

	function onEquip()
	{
		this.artifact_weapon.onEquip();
		local skill;
		skill = this.new("scripts/skills/actives/cudgel_skill");
		skill.m.Icon = "skills/active_133.png";
		skill.m.IconDisabled = "skills/active_133_sw.png";
		skill.m.Overlay = "active_133";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/strike_down_skill");
		skill.m.Icon = "skills/active_134.png";
		skill.m.IconDisabled = "skills/active_134_sw.png";
		skill.m.Overlay = "active_134";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/split_shield");
		skill.setFatigueCost(skill.getFatigueCostRaw() + 5);
		this.addSkill(skill);
	}

});

