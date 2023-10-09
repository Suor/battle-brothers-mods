this.artifact_sipar_shield <- this.inherit("scripts/items/shields/artifact/artifact_shield", {
	m = {},
	function create()
	{
		this.artifact_shield.create();
		this.m.Variant = this.Math.rand(1, 2);
		this.updateVariant();
		this.m.ID = "shield.artifact_sipar_shield";
		this.m.NameList = this.Const.Strings.ArtifactShieldNames;
		this.m.Description = "A full metal round shield of southern design with exquisite ornaments. Heavy, but nearly impenetrable";
		this.m.SoundOnHit = this.Const.Sound.ShieldHitMetal;
		this.m.AddGenericSkill = true;
		this.m.ShowOnCharacter = true;
		this.m.Value = 15000;
		this.m.MeleeDefense = 18;
		this.m.RangedDefense = 18;
		this.m.StaminaModifier = -18;
		this.m.Condition = 60;
		this.m.ConditionMax = 60;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.Sprite = "shield_metal_round_03_named_0" + this.m.Variant;
		this.m.SpriteDamaged = "shield_metal_round_03_named_0" + this.m.Variant + "_damaged";
		this.m.ShieldDecal = "shield_metal_round_03_named_0" + this.m.Variant + "_destroyed";
		this.m.IconLarge = "shields/inventory_metal_round_shield_03_named_0" + this.m.Variant + ".png";
		this.m.Icon = "shields/icon_metal_round_shield_03_named_0" + this.m.Variant + ".png";
	}

	function onEquip()
	{
		this.artifact_shield.onEquip();
		this.addSkill(this.new("scripts/skills/actives/shieldwall"));
		this.addSkill(this.new("scripts/skills/actives/knock_back"));
	}

});

