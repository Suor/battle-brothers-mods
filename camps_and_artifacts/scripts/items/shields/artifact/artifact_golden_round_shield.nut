this.artifact_golden_round_shield <- this.inherit("scripts/items/shields/artifact/artifact_shield", {
	m = {},
	function create()
	{
		this.artifact_shield.create();
		this.m.Variant = 4;
		this.updateVariant();
		this.m.ID = "shield.artifact_golden_round_shield";
		this.m.NameList = this.Const.Strings.ArtifactShieldNames;
		this.m.Description = "A round shield of unmatched quality.  The very metal of this shield swirls with dark veins.";
		this.m.SoundOnHit = this.Const.Sound.ShieldHitMetal;
		this.m.AddGenericSkill = true;
		this.m.ShowOnCharacter = true;
		this.m.Value = 15000;
		this.m.MeleeDefense = 20;
		this.m.RangedDefense = 15;
		this.m.StaminaModifier = -18;
		this.m.Condition = 50;
		this.m.ConditionMax = 50;
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

	function onEquip()
	{
		this.artifact_shield.onEquip();
		this.addSkill(this.new("scripts/skills/actives/shieldwall"));
		this.addSkill(this.new("scripts/skills/actives/knock_back"));
	}

});

