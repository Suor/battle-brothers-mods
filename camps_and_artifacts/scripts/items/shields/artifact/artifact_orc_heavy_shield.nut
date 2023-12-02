this.artifact_orc_heavy_shield <- this.inherit("scripts/items/shields/artifact/artifact_shield", {
	m = {},
	function create()
	{
		this.artifact_shield.create();
		this.m.Variant = this.Math.rand(1, 3);
		this.updateVariant();
		this.m.ID = "shield.artifact_orc_heavy_shield";
		this.m.NameList = this.Const.Strings.ArtifactOrcShieldNames;
		this.m.Description = "A colossal hunk of meteoric iron with a leather band attached.  While unwieldy, this shield will withstand incredible amounts of punishment";
		this.m.SoundOnHit = this.Const.Sound.ShieldHitMetal;
		this.m.AddGenericSkill = true;
		this.m.ShowOnCharacter = true;
		this.m.Value = 10500;
		this.m.MeleeDefense = 15;
		this.m.RangedDefense = 15;
		this.m.StaminaModifier = -22;
		this.m.Condition = 72;
		this.m.ConditionMax = 72;
		this.m.FatigueOnSkillUse = 5;
		if (::CampsAndArtifacts.Mods.Reforged) {
			this.m.ReachIgnore = 3;
		}
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.Sprite = "shield_orc_02_named_0" + this.m.Variant;
		this.m.SpriteDamaged = "shield_orc_02_named_0" + this.m.Variant + "_damaged";
		this.m.ShieldDecal = "shield_orc_02_named_0" + this.m.Variant + "_destroyed";
		this.m.IconLarge = "shields/orc_iron_shield_named_0" + this.m.Variant + "_140x70.png";
		this.m.Icon = "shields/orc_iron_shield_named_0" + this.m.Variant + "_70x70.png";
	}

	function onEquip()
	{
		this.artifact_shield.onEquip();
		this.addSkill(this.new("scripts/skills/actives/shieldwall"));
		this.addSkill(this.new("scripts/skills/actives/knock_back"));
	}

});

